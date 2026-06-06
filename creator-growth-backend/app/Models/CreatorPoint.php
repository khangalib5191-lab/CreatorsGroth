<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CreatorPoint extends Model
{
    protected $fillable = [
        'user_id',
        'points',
    ];

    public static function addPoints($userId, $amount)
    {
        $points = self::firstOrCreate(
            ['user_id' => $userId],
            ['points' => 0]
        );

        $points->increment('points', $amount);
    }
}