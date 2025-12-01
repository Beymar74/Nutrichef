<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

class CleanDatabaseSeeder extends Seeder
{
    public function run()
    {
        Schema::disableForeignKeyConstraints();

        $this->command->info('🧹 Limpiando base de datos...');

        $tables = [
            'multimedia_recetas',
            'ingrediente_receta',
            'receta_dieta',
            'comentarios',
            'calificacion',
            'usuario_favorito',
            'seguidores',
            'publicaciones',
            'recetas',
            'ingredientes',
            'usuarios',
            'personas',
            'subdominios',
            'dominios',
            'roles',
        ];

        foreach ($tables as $table) {
            DB::table($table)->truncate();
            $this->command->info("✅ Tabla {$table} limpiada");
        }

        Schema::enableForeignKeyConstraints();

        $this->command->info('🎉 Base de datos limpia');
    }
}