<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\API\AuthController;
use App\Http\Controllers\API\ProfileController;
use App\Http\Controllers\API\StatusController;
use App\Http\Controllers\API\FollowController;

/*
|--------------------------------------------------------------------------
| API Routes - Creator Growth App
|--------------------------------------------------------------------------
*/

// 🔥 Test route (always keep for debugging)
Route::get('/test', function () {
    return response()->json([
        'message' => 'API is working 🚀'
    ]);
});


// ================================
// 🔐 AUTH ROUTES (PUBLIC)
// ================================

// Register new user
Route::post('/register', [AuthController::class, 'register']);

// Login user
Route::post('/login', [AuthController::class, 'login']);


// ================================
// 🔒 PROTECTED ROUTES (Sanctum)
// ================================
Route::middleware('auth:sanctum')->group(function () {

    // Get logged-in user
    Route::get('/user', function (Request $request) {
        return $request->user();
    });

    // Logout user
    Route::post('/logout', [AuthController::class, 'logout']);


    // 👤 Profile
    Route::get('/me', [ProfileController::class, 'me']);
    Route::post('/profile/update', [ProfileController::class, 'update']);

    // STATUS SYSTEM
    Route::post('/status', [StatusController::class, 'create']);
    Route::get('/status', [StatusController::class, 'index']);
    Route::get('/status/user/{id}', [StatusController::class, 'userStatuses']);
    Route::delete('/status/{id}', [StatusController::class, 'delete']);

    Route::get('/feed', [StatusController::class, 'feed']);

    // FOLLOW SYSTEM
    Route::post('/follow/{id}', [FollowController::class, 'follow']);
    Route::post('/unfollow/{id}', [FollowController::class, 'unfollow']);

    // 🔒 PRIVATE (ONLY LOGGED-IN USER)
    Route::get('/my-followers', [FollowController::class, 'myFollowers']);
    Route::get('/my-following', [FollowController::class, 'myFollowing']);

});