<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('personas', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('id_dieta')->nullable();
            $table->unsignedBigInteger('id_nivel_cocina')->nullable();
            $table->string('nombres', 100);
            $table->string('apellido_paterno', 100);
            $table->string('apellido_materno', 100)->nullable();
            $table->string('telefono', 20)->nullable();
            $table->decimal('altura', 5, 2)->nullable();
            $table->decimal('peso', 6, 2)->nullable();
            $table->date('fecha_nacimiento')->nullable();
            $table->boolean('estado')->default(true);
            $table->timestamp('created_at', 0)->useCurrent();
            $table->timestamp('updated_at', 0)->useCurrent()->useCurrentOnUpdate();

            $table->foreign('id_dieta')
                ->references('id')->on('subdominios');
            $table->foreign('id_nivel_cocina')
                ->references('id')->on('subdominios');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('personas');
    }
};
