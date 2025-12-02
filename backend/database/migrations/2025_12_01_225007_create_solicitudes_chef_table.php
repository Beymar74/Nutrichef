<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('solicitudes_chef', function (Blueprint $table) {
            $table->id();
            
            // Usuario que solicita
            $table->unsignedBigInteger('id_usuario');
            $table->foreign('id_usuario')
                  ->references('id')
                  ->on('usuarios')
                  ->onDelete('cascade');
            
            $table->text('motivo')->nullable();
            $table->string('experiencia', 500)->nullable();
            
            // ✅ Estado de la solicitud (usa subdominios para ESTADO_SOLICITUD)
            $table->unsignedBigInteger('id_estado');
            $table->foreign('id_estado')
                  ->references('id')
                  ->on('subdominios')
                  ->onDelete('restrict');
            
            // Admin que revisó
            $table->unsignedBigInteger('revisado_por')->nullable();
            $table->foreign('revisado_por')
                  ->references('id')
                  ->on('usuarios')
                  ->onDelete('set null');
            
            $table->text('comentario_admin')->nullable();
            $table->timestamp('fecha_revision')->nullable();
            $table->timestamps();
            
            // Índices
            $table->index('id_estado');
            $table->index('id_usuario');
            $table->index('created_at');
        });
        
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('solicitudes_chef');
    }
};