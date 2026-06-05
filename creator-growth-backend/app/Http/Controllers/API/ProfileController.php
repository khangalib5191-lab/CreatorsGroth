<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;

class ProfileController extends Controller
{
    // GET MY PROFILE
    public function me(Request $request)
    {
        return response()->json([
            'user' => $request->user()
        ]);
    }

    // UPDATE PROFILE
    public function update(Request $request)
    {
        $user = $request->user();

        $request->validate([
            'username' => 'nullable|string|unique:users,username,' . $user->id,
            'bio' => 'nullable|string|max:500',
        ]);

        $user->username = $request->username ?? $user->username;
        $user->bio = $request->bio ?? $user->bio;

        // ⭐ keep creator growth logic ready
        if (!$user->points) {
            $user->points = 0;
        }

        $user->save();

        return response()->json([
            'message' => 'Profile updated successfully 🚀',
            'user' => $user
        ]);
    }
}