<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('reacciones', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('id_publicacion');
            $table->unsignedBigInteger('id_usuario');
            $table->unsignedBigInteger('id_tipo_reaccion');
            $table->timestamp('created_at', 0)->useCurrent();
            $table->timestamp('updated_at', 0)->useCurrent()->useCurrentOnUpdate();

            $table->foreign('id_publicacion')
                ->references('id')->on('publicaciones')
                ->onDelete('cascade');
            $table->foreign('id_usuario')
                ->references('id')->on('usuarios')
                ->onDelete('cascade');
            $table->foreign('id_tipo_reaccion')
                ->references('id')->on('subdominios');

            $table->unique(['id_publicacion', 'id_usuario', 'id_tipo_reaccion']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('reacciones');
    }
};
