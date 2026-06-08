<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\User;
use App\Models\CreatorTask;
use App\Models\CreatorCredit;
use App\Models\CreatorPoint;
use App\Models\TaskCompletion;
use Illuminate\Http\Request;

class AdminController extends Controller
{
    // =========================
    // DASHBOARD STATS
    // =========================
    public function dashboard()
    {
        return response()->json([
            'total_users' => User::count(),
            'total_tasks' => CreatorTask::count(),
            'active_users' => User::where('is_banned', false)->count(),
            'banned_users' => User::where('is_banned', true)->count(),
            'pending_completions' => TaskCompletion::where('status', 'pending')->count(),
        ]);
    }

    // =========================
    // ALL USERS
    // =========================
    public function users()
    {
        return response()->json([
            'users' => User::latest()->get()
        ]);
    }

    // =========================
    // SINGLE USER
    // =========================
    public function showUser($id)
    {
        return response()->json([
            'user' => User::findOrFail($id)
        ]);
    }

    // =========================
    // BAN USER
    // =========================
    public function banUser($id)
    {
        $user = User::findOrFail($id);
        $user->is_banned = true;
        $user->save();

        return response()->json([
            'message' => 'User banned successfully'
        ]);
    }

    // =========================
    // UNBAN USER
    // =========================
    public function unbanUser($id)
    {
        $user = User::findOrFail($id);
        $user->is_banned = false;
        $user->save();

        return response()->json([
            'message' => 'User unbanned successfully'
        ]);
    }

    // =========================
    // DELETE USER
    // =========================
    public function deleteUser($id)
    {
        $user = User::findOrFail($id);
        $user->delete();

        return response()->json([
            'message' => 'User deleted successfully'
        ]);
    }

    // =========================
    // PENDING TASKS
    // =========================
    public function pendingTasks()
    {
        return response()->json([
            'tasks' => CreatorTask::where('admin_status', 'pending')
                ->latest()
                ->get()
        ]);
    }

    // =========================
    // APPROVE TASK
    // =========================
    public function approveTask($id)
    {
        $task = CreatorTask::findOrFail($id);

        $task->admin_status = 'approved';
        $task->save();

        $this->updateTrust($task->user_id, 5);

        return response()->json([
            'message' => 'Task approved successfully'
        ]);
    }

    // =========================
    // REJECT TASK + REFUND
    // =========================
    public function rejectTask($id)
    {
        $task = CreatorTask::findOrFail($id);

        $task->admin_status = 'rejected';
        $task->save();

        CreatorCredit::addCredits(
            $task->user_id,
            $task->reward_credits
        );

        $this->updateTrust($task->user_id, -10);

        return response()->json([
            'message' => 'Task rejected and credits refunded'
        ]);
    }

    // =========================
    // ADJUST CREDITS
    // =========================
    public function adjustCredits(Request $request, $userId)
    {
        $request->validate([
            'amount' => 'required|integer'
        ]);

        CreatorCredit::addCredits($userId, $request->amount);

        return response()->json([
            'message' => 'Credits updated successfully'
        ]);
    }

    // =========================
    // PENDING COMPLETIONS
    // =========================
    public function pendingCompletions()
    {
        return response()->json([
            'message' => 'Pending task completions',
            'data' => TaskCompletion::with(['task', 'user'])
                ->where('status', 'pending')
                ->latest()
                ->get()
        ]);
    }

    // =========================
    // APPROVE COMPLETION
    // =========================
    public function approveCompletion($id)
    {
        $completion = TaskCompletion::findOrFail($id);

        if ($completion->status !== 'pending') {
            return response()->json([
                'message' => 'Already processed'
            ], 400);
        }

        $completion->status = 'approved';
        $completion->save();

        $task = $completion->task;

        CreatorCredit::addCredits(
            $completion->user_id,
            $task->reward_credits
        );

        CreatorPoint::addPoints(
            $completion->user_id,
            10
        );

        $this->updateTrust($completion->user_id, 3);

        return response()->json([
            'message' => 'Completion approved & rewards given'
        ]);
    }

    // =========================
    // REJECT COMPLETION
    // =========================
    public function rejectCompletion($id)
    {
        $completion = TaskCompletion::findOrFail($id);

        if ($completion->status !== 'pending') {
            return response()->json([
                'message' => 'Already processed'
            ], 400);
        }

        $completion->status = 'rejected';
        $completion->save();

        $this->updateTrust($completion->user_id, -10);

        return response()->json([
            'message' => 'Completion rejected'
        ]);
    }

    // =========================
    // TRUST SYSTEM (PHASE 5 CORE)
    // =========================
    private function updateTrust($userId, $points)
    {
        $user = User::find($userId);

        if (!$user) return;

        if (!isset($user->trust_score)) {
            $user->trust_score = 50;
        }

        $user->trust_score += $points;

        // keep safe range
        $user->trust_score = max(0, min(100, $user->trust_score));

        $user->save();
    }

    // =========================
    // LEADERBOARD (PHASE 5 FEATURE)
    // =========================
    public function leaderboard()
    {
        return response()->json([
            'users' => User::orderBy('trust_score', 'desc')
                ->take(50)
                ->get(['id', 'name', 'trust_score', 'points'])
        ]);
    }

    // =========================
    // ANALYTICS (PHASE 5 FEATURE)
    // =========================
    public function analytics()
    {
        return response()->json([
            'total_users' => User::count(),
            'active_users_today' => User::whereDate('created_at', now())->count(),
            'total_tasks' => CreatorTask::count(),
            'completed_tasks' => TaskCompletion::where('status', 'approved')->count(),
            'pending_tasks' => TaskCompletion::where('status', 'pending')->count(),
        ]);
    }
}