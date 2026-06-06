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

        // Check balance
        if ($wallet->credits < $request->reward_credits) {
            return response()->json([
                'message' => 'Not enough credits'
            ], 400);
        }

        // Deduct credits (escrow system)
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
    // PERSONALIZED FEED (IMPORTANT UPDATE)
    // =========================
    public function index(Request $request)
    {
        $user = $request->user();

        $query = CreatorTask::with('user:id,name')
            ->where('status', 'open');

        // 🎯 PERSONALIZED FEED BASED ON INTERESTS
        if (!empty($user->interests)) {

            $query->where(function ($q) use ($user) {

                $q->whereIn('category', $user->interests)
                    ->orWhereNull('category');
            });
        }

        // 🔥 BOOST HIGH REWARD TASKS
        $query->orderBy('reward_credits', 'desc');

        $tasks = $query->paginate(20);

        return response()->json([
            'message' => 'Personalized task feed loaded 🚀',
            'tasks' => $tasks
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
    // COMPLETE TASK (FULL SAFE ENGINE)
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

        // 💰 Give credits to helper
        CreatorCredit::addCredits(
            $userId,
            $task->reward_credits
        );

        // 🏆 Give points
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