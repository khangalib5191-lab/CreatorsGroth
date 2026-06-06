<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\GroupMember;
use App\Models\GroupMessage;
use Illuminate\Http\Request;

class GroupMessageController extends Controller
{
    // Send Message
    public function send(Request $request, $groupId)
    {
        $request->validate([
            'message' => 'required|string|max:5000',
        ]);

        $isMember = GroupMember::where('group_id', $groupId)
            ->where('user_id', $request->user()->id)
            ->exists();

        if (!$isMember) {
            return response()->json([
                'message' => 'You are not a member of this group'
            ], 403);
        }

        $message = GroupMessage::create([
            'group_id' => $groupId,
            'user_id' => $request->user()->id,
            'message' => $request->message,
        ]);

        return response()->json([
            'message' => 'Message sent',
            'data' => $message
        ]);
    }

    // Get Messages
    public function messages(Request $request, $groupId)
    {
        $isMember = GroupMember::where('group_id', $groupId)
            ->where('user_id', $request->user()->id)
            ->exists();

        if (!$isMember) {
            return response()->json([
                'message' => 'You are not a member of this group'
            ], 403);
        }

        $messages = GroupMessage::with('user')
            ->where('group_id', $groupId)
            ->orderBy('created_at', 'asc')
            ->get();

        return response()->json([
            'messages' => $messages
        ]);
    }
}