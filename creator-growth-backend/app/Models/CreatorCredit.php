<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CreatorCredit extends Model
{
    protected $fillable = [
        'user_id',
        'credits',
    ];

    public static function addCredits($userId, $amount)
    {
        $wallet = self::firstOrCreate(
            ['user_id' => $userId],
            ['credits' => 0]
        );

        $wallet->increment('credits', $amount);
    }

    public static function deductCredits($userId, $amount)
    {
        $wallet = self::firstOrCreate(
            ['user_id' => $userId],
            ['credits' => 0]
        );

        $wallet->decrement('credits', $amount);
    }
}