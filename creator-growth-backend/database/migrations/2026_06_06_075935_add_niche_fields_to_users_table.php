<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('users', function (Blueprint $table) {

            $table->string('content_type')->nullable();
            // main niche (e.g. "YouTube", "Instagram", "Gaming")

            $table->json('interests')->nullable();
            // multiple niches ["gaming", "fitness", "tech"]

        });
    }

    public function down(): void
    {
        Schema::table('users', function (Blueprint $table) {
            $table->dropColumn(['content_type', 'interests']);
        });
    }
};