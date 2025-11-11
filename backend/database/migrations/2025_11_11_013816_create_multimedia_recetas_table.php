<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('multimedia_recetas', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('id_receta');
            $table->binary('archivo'); // BYTEA
            $table->string('tipo_archivo', 50);
            $table->integer('orden')->nullable();
            $table->timestamp('created_at', 0)->useCurrent();
            $table->timestamp('updated_at', 0)->useCurrent()->useCurrentOnUpdate();

            $table->foreign('id_receta')
                ->references('id')->on('recetas')
                ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('multimedia_recetas');
    }
};
