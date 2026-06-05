<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Status;

class StatusController extends Controller
{
    // CREATE STATUS
    public function create(Request $request)
    {
        $request->validate([
            'text' => 'nullable|string|max:500',
            'image' => 'nullable|image|max:2048',
        ]);

        $imagePath = null;

        if ($request->hasFile('image')) {
            $imagePath = $request->file('image')->store('statuses', 'public');
        }

        $status = Status::create([
            'user_id' => $request->user()->id,
            'text' => $request->text,
            'image' => $imagePath,
        ]);

        return response()->json([
            'message' => 'Status created successfully 🚀',
            'status' => $status
        ]);
    }

    // GET ALL STATUSES (FEED)
    public function index()
    {
        $statuses = Status::with('user')
            ->latest()
            ->get();

        return response()->json([
            'statuses' => $statuses
        ]);
    }

    // GET USER STATUSES
    public function userStatuses($id)
    {
        $statuses = Status::where('user_id', $id)
            ->latest()
            ->get();

        return response()->json([
            'statuses' => $statuses
        ]);
    }

    // DELETE STATUS
    public function delete($id, Request $request)
    {
        $status = Status::where('id', $id)
            ->where('user_id', $request->user()->id)
            ->firstOrFail();

        $status->delete();

        return response()->json([
            'message' => 'Status deleted'
        ]);
    }

    public function feed(Request $request)
{
    $user = $request->user();

    // Get IDs of users I follow
    $followingIds = \App\Models\Follow::where(
        'follower_id',
        $user->id
    )->pluck('following_id');

    // Include my own ID
    $followingIds->push($user->id);

    // Get feed statuses
    $statuses = \App\Models\Status::with('user')
        ->whereIn('user_id', $followingIds)
        ->latest()
        ->paginate(20);

    return response()->json([
        'feed' => $statuses
    ]);
}
}