<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('menu_items', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->string('item', 150);
            $table->string('ruta', 255)->nullable();
            $table->unsignedBigInteger('id_padre')->nullable();
            $table->smallInteger('nivel')->nullable();
            $table->integer('orden')->nullable();
            $table->timestamp('created_at', 0)->useCurrent();
            $table->timestamp('updated_at', 0)->useCurrent()->useCurrentOnUpdate();

            // FK opcional a sí misma (jerarquía)
            $table->foreign('id_padre')
                ->references('id')
                ->on('menu_items')
                ->onDelete('cascade');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('menu_items');
    }
};
