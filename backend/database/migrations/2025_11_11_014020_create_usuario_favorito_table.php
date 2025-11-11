<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('usuario_favorito', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('id_receta');
            $table->unsignedBigInteger('id_usuario');
            $table->timestamp('created_at', 0)->useCurrent();
            $table->timestamp('updated_at', 0)->useCurrent()->useCurrentOnUpdate();

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
        Schema::dropIfExists('usuario_favorito');
    }
};
