<?php

namespace App\Models;

use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    use HasApiTokens, Notifiable;

    /**
     * Mass assignable fields
     */
    protected $fillable = [
        'name',
        'email',
        'password',
        'username',
        'bio',
        'profile_image',

        // ⭐ Creator Growth System
        'content_type',
        'interests',

        // ⭐ Gamification
        'points',
        'followers_count',
        'following_count',
    ];

    /**
     * Hidden fields
     */
    protected $hidden = [
        'password',
        'remember_token',
    ];

    /**
     * Cast special fields
     */
    protected $casts = [
        'interests' => 'array',   // ⭐ IMPORTANT for feed system
        'email_verified_at' => 'datetime',
    ];
}