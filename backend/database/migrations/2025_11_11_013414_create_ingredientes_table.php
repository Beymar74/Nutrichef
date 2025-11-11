<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('ingredientes', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('id_alergeno')->nullable();
            $table->string('descripcion', 200);
            $table->timestamp('created_at', 0)->useCurrent();
            $table->timestamp('updated_at', 0)->useCurrent()->useCurrentOnUpdate();

            $table->foreign('id_alergeno')
                ->references('id')->on('subdominios');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('ingredientes');
    }
};
