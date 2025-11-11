<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('recetas', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('id_usuario_creador');
            $table->unsignedBigInteger('id_estado');
            $table->unsignedBigInteger('id_tipo_alimento');
            $table->string('titulo', 200);
            $table->text('resumen')->nullable();
            $table->integer('tiempo_preparacion')->nullable();
            $table->text('preparacion');
            $table->integer('porciones_estimadas')->nullable();
            $table->timestamp('created_at', 0)->useCurrent();
            $table->timestamp('updated_at', 0)->useCurrent()->useCurrentOnUpdate();

            $table->foreign('id_usuario_creador')
                ->references('id')->on('usuarios')
                ->onDelete('cascade');
            $table->foreign('id_estado')
                ->references('id')->on('subdominios');
            $table->foreign('id_tipo_alimento')
                ->references('id')->on('subdominios');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('recetas');
    }
};
