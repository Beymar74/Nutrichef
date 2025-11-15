<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('multimedia_recetas', function (Blueprint $table) {
            $table->id();
            $table->foreignId('id_receta')->constrained('recetas')->onDelete('cascade');
            $table->text('archivo'); // ✅ AHORA ES TEXT
            $table->string('tipo_archivo')->nullable();
            $table->integer('orden')->default(1);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('multimedia_recetas');
    }
};
