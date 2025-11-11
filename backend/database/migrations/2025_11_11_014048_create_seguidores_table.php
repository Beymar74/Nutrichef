<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('seguidores', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('id_usuario');
            $table->unsignedBigInteger('id_usuario_seguido');
            $table->timestamp('created_at', 0)->useCurrent();
            $table->timestamp('updated_at', 0)->useCurrent()->useCurrentOnUpdate();

            $table->foreign('id_usuario')
                ->references('id')->on('usuarios')
                ->onDelete('cascade');
            $table->foreign('id_usuario_seguido')
                ->references('id')->on('usuarios')
                ->onDelete('cascade');

            $table->unique(['id_usuario', 'id_usuario_seguido']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('seguidores');
    }
};
