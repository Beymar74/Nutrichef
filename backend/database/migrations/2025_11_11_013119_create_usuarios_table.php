<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('usuarios', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('id_rol');
            $table->unsignedBigInteger('id_persona');
            $table->string('name', 100);
            $table->text('descripcion_perfil')->nullable();
            $table->string('email', 150)->unique();
            $table->string('password', 255);
            $table->string('remember_token', 255)->nullable();
            $table->boolean('estado')->default(true);
            $table->timestamp('created_at', 0)->useCurrent();
            $table->timestamp('updated_at', 0)->useCurrent()->useCurrentOnUpdate();

            $table->foreign('id_rol')
                ->references('id')->on('roles');
            $table->foreign('id_persona')
                ->references('id')->on('personas')
                ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('usuarios');
    }
};
