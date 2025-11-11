<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('calificacion', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('id_publicacion');
            $table->unsignedBigInteger('id_usuario');
            $table->smallInteger('calificacion'); // con validación en modelo o DB
            $table->timestamp('created_at', 0)->useCurrent();
            $table->timestamp('updated_at', 0)->useCurrent()->useCurrentOnUpdate();

            $table->foreign('id_publicacion')
                ->references('id')->on('publicaciones')
                ->onDelete('cascade');
            $table->foreign('id_usuario')
                ->references('id')->on('usuarios')
                ->onDelete('cascade');

            $table->unique(['id_publicacion', 'id_usuario']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('calificacion');
    }
};
