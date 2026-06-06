<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\CreatorCredit;
use Illuminate\Http\Request;

class CreatorCreditController extends Controller
{
    public function myCredits(Request $request)
    {
        $wallet = CreatorCredit::firstOrCreate(
            ['user_id' => $request->user()->id],
            ['credits' => 100]
        );

        return response()->json([
            'credits' => $wallet->credits
        ]);
    }
}