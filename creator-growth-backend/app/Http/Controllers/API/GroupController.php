<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Group;
use App\Models\GroupMember;
use Illuminate\Http\Request;

class GroupController extends Controller
{
    // Create Group
    public function create(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string'
        ]);

        $group = Group::create([
            'name' => $request->name,
            'description' => $request->description,
            'created_by' => $request->user()->id,
        ]);

        // Creator automatically joins
        GroupMember::create([
            'group_id' => $group->id,
            'user_id' => $request->user()->id,
        ]);

        return response()->json([
            'message' => 'Group created successfully',
            'group' => $group
        ]);
    }

    // All Groups
    public function index()
    {
        return response()->json(
            Group::latest()->get()
        );
    }

    // Join Group
    public function join(Request $request, $id)
    {
        GroupMember::firstOrCreate([
            'group_id' => $id,
            'user_id' => $request->user()->id,
        ]);

        return response()->json([
            'message' => 'Joined successfully'
        ]);
    }

    // Leave Group
    public function leave(Request $request, $id)
    {
        GroupMember::where('group_id', $id)
            ->where('user_id', $request->user()->id)
            ->delete();

        return response()->json([
            'message' => 'Left group successfully'
        ]);
    }

    // Members
    public function members($id)
    {
        $members = GroupMember::where('group_id', $id)->get();

        return response()->json([
            'members' => $members
        ]);
    }
}