<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('pista_auditorias', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->timestamp('fecha', 0);
            $table->string('usuario_bd', 150)->nullable();
            $table->string('accion', 50);
            $table->string('nombre_host', 150)->nullable();
            $table->string('ip_host', 45)->nullable();
            $table->string('pk', 255)->nullable();
            $table->string('nombre_tabla', 150);
            $table->text('registros1')->nullable();
            $table->text('registros2')->nullable();
            $table->timestamp('created_at', 0)->useCurrent();
            $table->timestamp('updated_at', 0)->useCurrent()->useCurrentOnUpdate();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('pista_auditorias');
    }
};
