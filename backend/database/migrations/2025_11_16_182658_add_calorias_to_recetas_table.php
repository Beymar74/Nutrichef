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
        Schema::table('recetas', function (Blueprint $table) {
            // Añadimos la columna 'calorias' si no existe
            if (!Schema::hasColumn('recetas', 'calorias')) {
                $table->integer('calorias')->nullable()->after('porciones_estimadas');
            }
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::table('recetas', function (Blueprint $table) {
            if (Schema::hasColumn('recetas', 'calorias')) {
                $table->dropColumn('calorias');
            }
        });
    }
};