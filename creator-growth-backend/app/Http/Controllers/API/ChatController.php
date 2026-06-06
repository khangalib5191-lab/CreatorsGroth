<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Conversation;
use App\Models\Message;
use Illuminate\Http\Request;

class ChatController extends Controller
{
    // Start conversation
    public function start(Request $request, $userId)
    {
        $me = $request->user()->id;

        if ($me == $userId) {
            return response()->json([
                'message' => 'Cannot chat with yourself'
            ], 400);
        }

        $userOne = min($me, $userId);
        $userTwo = max($me, $userId);

        $conversation = Conversation::firstOrCreate([
            'user_one' => $userOne,
            'user_two' => $userTwo,
        ]);

        return response()->json($conversation);
    }

    // Send message
    public function send(Request $request, $conversationId)
    {
        $request->validate([
            'message' => 'required'
        ]);

        $message = Message::create([
            'conversation_id' => $conversationId,
            'sender_id' => $request->user()->id,
            'message' => $request->message,
        ]);

        return response()->json([
            'message' => 'Sent',
            'data' => $message
        ]);
    }

    // Get messages
    public function messages($conversationId)
    {
        $messages = Message::with('sender')
            ->where('conversation_id', $conversationId)
            ->orderBy('created_at')
            ->get();

        return response()->json([
            'messages' => $messages
        ]);
    }
}