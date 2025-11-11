<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('lista_compras_items', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('id_ingrediente');
            $table->unsignedBigInteger('id_unidad_medida');
            $table->unsignedBigInteger('id_lista_compra');
            $table->decimal('cantidad', 10, 2);
            $table->boolean('comprado')->default(false);
            $table->timestamp('created_at', 0)->useCurrent();
            $table->timestamp('updated_at', 0)->useCurrent()->useCurrentOnUpdate();

            $table->foreign('id_ingrediente')
                ->references('id')->on('ingredientes');
            $table->foreign('id_unidad_medida')
                ->references('id')->on('subdominios');
            $table->foreign('id_lista_compra')
                ->references('id')->on('lista_compras')
                ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('lista_compras_items');
    }
};
