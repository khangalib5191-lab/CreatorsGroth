<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('creator_tasks', function (Blueprint $table) {

            $table->id();

            $table->foreignId('user_id')
                ->constrained()
                ->onDelete('cascade');

            $table->string('title');

            $table->string('link');

            $table->text('instructions')
                ->nullable();

            $table->integer('reward_credits')
                ->default(5);

            $table->enum('status', [
                'open',
                'completed',
                'cancelled'
            ])->default('open');

            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('creator_tasks');
    }
};