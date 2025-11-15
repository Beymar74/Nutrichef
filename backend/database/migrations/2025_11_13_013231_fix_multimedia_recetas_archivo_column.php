<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up()
    {
        Schema::table('multimedia_recetas', function (Blueprint $table) {
            // Cambiar de binary a text
            $table->text('archivo')->change();
        });
    }

    public function down()
    {
        Schema::table('multimedia_recetas', function (Blueprint $table) {
            $table->binary('archivo')->change();
        });
    }
};