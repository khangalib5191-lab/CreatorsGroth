<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\CreatorTask;
use App\Models\CreatorCredit;
use App\Models\CreatorPoint;
use App\Models\TaskCompletion;
use Illuminate\Http\Request;

class CreatorTaskController extends Controller
{
    // =========================
    // CREATE TASK
    // =========================
    public function create(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'link' => 'required|url',
            'instructions' => 'nullable|string',
            'reward_credits' => 'required|integer|min:1|max:1000',
            'category' => 'nullable|string|max:100'
        ]);

        $userId = $request->user()->id;

        // Wallet
        $wallet = CreatorCredit::firstOrCreate(
            ['user_id' => $userId],
            ['credits' => 100]
        );

        if ($wallet->credits < $request->reward_credits) {
            return response()->json([
                'message' => 'Not enough credits'
            ], 400);
        }

        // Deduct credits
        CreatorCredit::deductCredits($userId, $request->reward_credits);

        // Create task
        $task = CreatorTask::create([
            'user_id' => $userId,
            'title' => $request->title,
            'link' => $request->link,
            'instructions' => $request->instructions,
            'reward_credits' => $request->reward_credits,
            'category' => $request->category,
            'status' => 'open'
        ]);

        return response()->json([
            'message' => 'Task created successfully',
            'task' => $task
        ]);
    }

    // =========================
    // ADVANCED FEED (FIXED)
    // =========================
    public function index(Request $request)
    {
        $user = $request->user();

        $tasks = CreatorTask::with('user:id,name')
            ->where('status', 'open')
            ->where('admin_status', 'approved')
            ->latest()
            ->get();

        $scoredTasks = $tasks->map(function ($task) use ($user) {

            $score = 0;

            // 💰 Reward weight
            $score += $task->reward_credits;

            // ⏱️ Recency boost
            $hoursOld = now()->diffInHours($task->created_at);
            $score += max(0, 50 - $hoursOld);

            // 🎯 Interest match boost
            if (!empty($user->interests) && $task->category) {
                if (in_array($task->category, $user->interests)) {
                    $score += 100;
                }
            }

            $task->score = $score;

            return $task;
        });

        $sorted = $scoredTasks->sortByDesc('score')->values();

        return response()->json([
            'message' => 'Advanced feed loaded 🚀',
            'tasks' => $sorted
        ]);
    }

    // =========================
    // MY TASKS
    // =========================
    public function myTasks(Request $request)
    {
        $tasks = CreatorTask::where('user_id', $request->user()->id)
            ->latest()
            ->get();

        return response()->json([
            'tasks' => $tasks
        ]);
    }

    // =========================
    // COMPLETE TASK
    // =========================
    public function completeTask(Request $request, $taskId)
    {
        $request->validate([
            'proof' => 'nullable|string|max:1000'
        ]);

        $task = CreatorTask::findOrFail($taskId);

        $userId = $request->user()->id;

        // ❌ cannot complete own task
        if ($task->user_id == $userId) {
            return response()->json([
                'message' => 'You cannot complete your own task'
            ], 400);
        }

        // ❌ prevent duplicate completion
        $alreadyDone = TaskCompletion::where([
            'task_id' => $taskId,
            'user_id' => $userId
        ])->exists();

        if ($alreadyDone) {
            return response()->json([
                'message' => 'You already completed this task'
            ], 400);
        }

        // Save completion
        TaskCompletion::create([
            'task_id' => $taskId,
            'user_id' => $userId,
            'proof' => $request->proof
        ]);

        // 💰 reward credits
        CreatorCredit::addCredits(
            $userId,
            $task->reward_credits
        );

        // 🏆 reward points
        CreatorPoint::addPoints(
            $userId,
            10
        );

        return response()->json([
            'message' => 'Task completed successfully',
            'credits_earned' => $task->reward_credits,
            'points_earned' => 10
        ]);
    }
}