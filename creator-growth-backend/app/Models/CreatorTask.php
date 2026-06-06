<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class CreatorTask extends Model
{
    protected $fillable = [
        'user_id',
        'title',
        'link',
        'instructions',
        'reward_credits',
        'status',
    ];

    // 🔥 Relationship (important for feed later)
    public function user()
    {
        return $this->belongsTo(User::class);
    }
}