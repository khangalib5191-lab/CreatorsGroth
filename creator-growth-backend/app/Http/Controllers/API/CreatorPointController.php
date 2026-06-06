<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\CreatorPoint;
use Illuminate\Http\Request;

class CreatorPointController extends Controller
{
    public function myPoints(Request $request)
    {
        $points = CreatorPoint::firstOrCreate(
            ['user_id' => $request->user()->id],
            ['points' => 0]
        );

        return response()->json([
            'points' => $points->points
        ]);
    }
}