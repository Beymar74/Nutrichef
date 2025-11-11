<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('menu_item_rol', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('id_menu_item');
            $table->unsignedBigInteger('id_rol');
            $table->timestamp('created_at', 0)->useCurrent();
            $table->timestamp('updated_at', 0)->useCurrent()->useCurrentOnUpdate();

            $table->foreign('id_menu_item')
                ->references('id')->on('menu_items')
                ->onDelete('cascade');
            $table->foreign('id_rol')
                ->references('id')->on('roles')
                ->onDelete('cascade');

            $table->unique(['id_menu_item', 'id_rol']);
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('menu_item_rol');
    }
};
