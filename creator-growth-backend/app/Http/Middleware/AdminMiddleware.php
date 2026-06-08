<?php

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

class AdminMiddleware
{
    public function handle(Request $request, Closure $next): Response
    {
        $user = $request->user();

        // ❌ Not logged in
        if (!$user) {
            return response()->json([
                'message' => 'Unauthenticated'
            ], 401);
        }

        // ✅ SAFE ROLE CHECK (fixes \r\n issue)
        if (trim($user->role) !== 'admin') {
            return response()->json([
                'message' => 'Admin access only'
            ], 403);
        }

        return $next($request);
    }
}