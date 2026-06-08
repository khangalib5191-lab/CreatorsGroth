<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes - Creator Growth App
|--------------------------------------------------------------------------
*/

use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\ProfileController;
use App\Http\Controllers\API\StatusController;
use App\Http\Controllers\API\FollowController;
use App\Http\Controllers\API\GroupMessageController;
use App\Http\Controllers\API\GroupController;
use App\Http\Controllers\API\AdminController;
use App\Http\Controllers\API\ChatController;
use App\Http\Controllers\API\CreatorCreditController;
use App\Http\Controllers\API\CreatorPointController;
use App\Http\Controllers\API\CreatorTaskController;

/*
|--------------------------------------------------------------------------
| 🔥 TEST ROUTE
|--------------------------------------------------------------------------
*/
Route::get('/test', function () {
    return response()->json([
        'message' => 'API is working 🚀'
    ]);
});

/*
|--------------------------------------------------------------------------
| 🔐 AUTH (PUBLIC ROUTES)
|--------------------------------------------------------------------------
*/
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

/*
|--------------------------------------------------------------------------
| 🔒 PROTECTED ROUTES (SANCTUM)
|--------------------------------------------------------------------------
*/
Route::middleware('auth:sanctum')->group(function () {

    /*
    |--------------------------------------------------------------------------
    | USER
    |--------------------------------------------------------------------------
    */
    Route::get('/user', function (Request $request) {
        return $request->user();
    });

    Route::post('/logout', [AuthController::class, 'logout']);


    /*
    |--------------------------------------------------------------------------
    | PROFILE
    |--------------------------------------------------------------------------
    */
    Route::get('/me', [ProfileController::class, 'me']);
    Route::post('/profile/update', [ProfileController::class, 'update']);


    /*
    |--------------------------------------------------------------------------
    | STATUS SYSTEM
    |--------------------------------------------------------------------------
    */
    Route::post('/status', [StatusController::class, 'create']);
    Route::get('/status', [StatusController::class, 'index']);
    Route::get('/status/user/{id}', [StatusController::class, 'userStatuses']);
    Route::delete('/status/{id}', [StatusController::class, 'delete']);
    Route::get('/feed', [StatusController::class, 'feed']);


    /*
    |--------------------------------------------------------------------------
    | FOLLOW SYSTEM
    |--------------------------------------------------------------------------
    */
    Route::post('/follow/{id}', [FollowController::class, 'follow']);
    Route::post('/unfollow/{id}', [FollowController::class, 'unfollow']);
    Route::get('/my-followers', [FollowController::class, 'myFollowers']);
    Route::get('/my-following', [FollowController::class, 'myFollowing']);


    /*
    |--------------------------------------------------------------------------
    | GROUP SYSTEM
    |--------------------------------------------------------------------------
    */
    Route::post('/groups', [GroupController::class, 'create']);
    Route::get('/groups', [GroupController::class, 'index']);
    Route::post('/groups/{id}/join', [GroupController::class, 'join']);
    Route::post('/groups/{id}/leave', [GroupController::class, 'leave']);
    Route::get('/groups/{id}/members', [GroupController::class, 'members']);


    /*
    |--------------------------------------------------------------------------
    | GROUP MESSAGES
    |--------------------------------------------------------------------------
    */
    Route::post('/groups/{groupId}/messages', [GroupMessageController::class, 'send']);
    Route::get('/groups/{groupId}/messages', [GroupMessageController::class, 'messages']);


    /*
    |--------------------------------------------------------------------------
    | PRIVATE CHAT (DM)
    |--------------------------------------------------------------------------
    */
    Route::post('/chat/start/{userId}', [ChatController::class, 'start']);
    Route::post('/chat/send/{conversationId}', [ChatController::class, 'send']);
    Route::get('/chat/messages/{conversationId}', [ChatController::class, 'messages']);


    /*
    |--------------------------------------------------------------------------
    | CREDITS + POINTS
    |--------------------------------------------------------------------------
    */
    Route::get('/my-credits', [CreatorCreditController::class, 'myCredits']);
    Route::get('/my-points', [CreatorPointController::class, 'myPoints']);


    /*
    |--------------------------------------------------------------------------
    | TASK SYSTEM
    |--------------------------------------------------------------------------
    */

    // Tasks
    Route::post('/tasks', [CreatorTaskController::class, 'create']);
    Route::get('/tasks', [CreatorTaskController::class, 'index']);
    Route::get('/my-tasks', [CreatorTaskController::class, 'myTasks']);

    // 🔥 IMPORTANT: TASK COMPLETION (ADDED)
    Route::post('/tasks/{id}/complete', [CreatorTaskController::class, 'completeTask']);

});


// Admin routes 
Route::middleware(['auth:sanctum', 'admin'])->group(function () {

    // 👑 Dashboard
    Route::get('/admin/dashboard', [AdminController::class, 'dashboard']);

    // 👥 Users
    Route::get('/admin/users', [AdminController::class, 'users']);
    Route::get('/admin/users/{id}', [AdminController::class, 'showUser']);

    // 🚫 Ban / Unban
    Route::post('/admin/users/{id}/ban', [AdminController::class, 'banUser']);
    Route::post('/admin/users/{id}/unban', [AdminController::class, 'unbanUser']);

    // ❌ Delete user
    Route::delete('/admin/users/{id}', [AdminController::class, 'deleteUser']);

    Route::get('/admin/tasks/pending', [AdminController::class, 'pendingTasks']);
    Route::post('/admin/tasks/{id}/approve', [AdminController::class, 'approveTask']);
    Route::post('/admin/tasks/{id}/reject', [AdminController::class, 'rejectTask']);

    Route::post('/admin/users/{id}/credits', [AdminController::class, 'adjustCredits']);

    Route::get('/admin/completions/pending', [AdminController::class, 'pendingCompletions']);
    Route::post('/admin/completions/{id}/approve', [AdminController::class, 'approveCompletion']);
    Route::post('/admin/completions/{id}/reject', [AdminController::class, 'rejectCompletion']);
});