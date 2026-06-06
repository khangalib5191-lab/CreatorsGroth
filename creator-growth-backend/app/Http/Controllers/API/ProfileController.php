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

    // UPDATE PROFILE (ONLY ONE FUNCTION)
    public function update(Request $request)
    {
        $user = $request->user();

        $request->validate([
            'username' => 'nullable|string|unique:users,username,' . $user->id,
            'name' => 'nullable|string',
            'bio' => 'nullable|string|max:500',
            'content_type' => 'nullable|string',
            'interests' => 'nullable|array',
        ]);

        // Update basic fields
        if ($request->has('username')) {
            $user->username = $request->username;
        }

        if ($request->has('name')) {
            $user->name = $request->name;
        }

        if ($request->has('bio')) {
            $user->bio = $request->bio;
        }

        // Creator Growth fields
        if ($request->has('content_type')) {
            $user->content_type = $request->content_type;
        }

        if ($request->has('interests')) {
            $user->interests = $request->interests;
        }

        // ensure points exist (safe fallback)
        if ($user->points === null) {
            $user->points = 0;
        }

        $user->save();

        return response()->json([
            'message' => 'Profile updated successfully 🚀',
            'user' => $user
        ]);
    }
}