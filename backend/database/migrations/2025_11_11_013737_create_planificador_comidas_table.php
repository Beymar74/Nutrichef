<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('planificador_comidas', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('id_horario');
            $table->unsignedBigInteger('id_receta');
            $table->unsignedBigInteger('id_usuario');
            $table->smallInteger('dia_semana'); // 1-7
            $table->text('notas')->nullable();
            $table->integer('porciones')->nullable();
            $table->timestamp('created_at', 0)->useCurrent();
            $table->timestamp('updated_at', 0)->useCurrent()->useCurrentOnUpdate();

            $table->foreign('id_horario')
                ->references('id')->on('horarios_usuario')
                ->onDelete('cascade');
            $table->foreign('id_receta')
                ->references('id')->on('recetas')
                ->onDelete('cascade');
            $table->foreign('id_usuario')
                ->references('id')->on('usuarios')
                ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('planificador_comidas');
    }
};
