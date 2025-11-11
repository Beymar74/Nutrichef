<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\Schema;
use Illuminate\Database\Schema\Blueprint;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('alergia_persona', function (Blueprint $table) {
            $table->bigIncrements('id');
            $table->unsignedBigInteger('id_persona');
            $table->unsignedBigInteger('id_alergeno');
            $table->timestamp('created_at', 0)->useCurrent();
            $table->timestamp('updated_at', 0)->useCurrent()->useCurrentOnUpdate();

            $table->foreign('id_persona')
                ->references('id')->on('personas')
                ->onDelete('cascade');
            $table->foreign('id_alergeno')
                ->references('id')->on('subdominios');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('alergia_persona');
    }
};
