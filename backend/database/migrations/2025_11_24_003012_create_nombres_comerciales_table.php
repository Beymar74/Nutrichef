<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('nombres_comerciales', function (Blueprint $table) {
            $table->id(); // Esto es equivalente a bigIncrements('id')
            
            // La clave foránea
            $table->unsignedBigInteger('id_ingrediente');
            
            // El nombre detectado por OCR (Ej: "grano de oro", "pil")
            // Le ponemos index() para que las búsquedas sean rápidas
            $table->string('nombre_comercial')->index(); 

            $table->timestamps();

            // Relación (Constraint)
            $table->foreign('id_ingrediente')
                  ->references('id')
                  ->on('ingredientes')
                  ->onDelete('cascade'); // Si borras el ingrediente, se borran sus alias
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('nombres_comerciales');
    }
};