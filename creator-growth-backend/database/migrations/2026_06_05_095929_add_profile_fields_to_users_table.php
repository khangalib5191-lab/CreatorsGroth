<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->string('username')->unique()->nullable();
            $table->text('bio')->nullable();
            $table->string('profile_image')->nullable();

            // ⭐ Creator Growth features
            $table->integer('points')->default(0);
            $table->integer('followers_count')->default(0);
            $table->integer('following_count')->default(0);
        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn([
                'username',
                'bio',
                'profile_image',
                'points',
                'followers_count',
                'following_count'
            ]);
        });
    }
};
