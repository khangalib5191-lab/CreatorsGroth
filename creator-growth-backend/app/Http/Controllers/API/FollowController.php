<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Follow;

class FollowController extends Controller
{
    // FOLLOW USER
    public function follow(Request $request, $id)
    {
        $user = $request->user();

        if ($user->id == $id) {
            return response()->json([
                'message' => "You can't follow yourself"
            ], 400);
        }

        Follow::firstOrCreate([
            'follower_id' => $user->id,
            'following_id' => $id,
        ]);

        return response()->json([
            'message' => 'Followed successfully 🚀'
        ]);
    }

    // UNFOLLOW USER
    public function unfollow(Request $request, $id)
    {
        Follow::where('follower_id', $request->user()->id)
            ->where('following_id', $id)
            ->delete();

        return response()->json([
            'message' => 'Unfollowed successfully'
        ]);
    }

    // 🔒 MY FOLLOWERS (PRIVATE)
    public function myFollowers(Request $request)
    {
        $followers = Follow::where('following_id', $request->user()->id)
            ->with('follower')
            ->get();

        return response()->json([
            'followers' => $followers
        ]);
    }

    // 🔒 MY FOLLOWING (PRIVATE)
    public function myFollowing(Request $request)
    {
        $following = Follow::where('follower_id', $request->user()->id)
            ->with('following')
            ->get();

        return response()->json([
            'following' => $following
        ]);
    }
}