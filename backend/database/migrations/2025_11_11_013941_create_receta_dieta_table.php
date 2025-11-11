<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('receta_dieta', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('id_receta');
            $table->unsignedBigInteger('id_dieta');
            $table->timestamp('created_at', 0)->useCurrent();
            $table->timestamp('updated_at', 0)->useCurrent()->useCurrentOnUpdate();

            $table->foreign('id_receta')
                ->references('id')->on('recetas')
                ->onDelete('cascade');
            $table->foreign('id_dieta')
                ->references('id')->on('subdominios');

            $table->unique(['id_receta', 'id_dieta']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('receta_dieta');
    }
};
