<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Schema;

class RolesSeeder extends Seeder
{
    public function run(): void
    {
        // Desactivar restricciones temporalmente
        Schema::disableForeignKeyConstraints();
        
        // Limpiar la tabla
        DB::table('roles')->truncate();
        
        $now = Carbon::now();

        $roles = [
            ['descripcion' => 'admin', 'estado' => true],
            ['descripcion' => 'user',  'estado' => true],
        ];

        foreach ($roles as $role) {
            DB::table('roles')->insert([
                'descripcion' => $role['descripcion'],
                'estado' => $role['estado'],
                'created_at' => $now,
                'updated_at' => $now
            ]);
        }

        // Reactivar restricciones
        Schema::enableForeignKeyConstraints();

        $this->command->info('Roles seed completed (idempotent).');
    }
}