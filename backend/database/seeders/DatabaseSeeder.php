<?php

namespace Database\Seeders;

use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Primero seeders base (catálogos y configuración)
        $this->call([
            RolesSeeder::class,
            DominiosSeeder::class,
            SubdominiosSeeder::class,
        ]);

        // Usuarios (dependen de roles)
        $this->call([
            AdminUserSeeder::class,
        ]);

        // Datos de recetas e ingredientes
        $this->call([
            RecetasSeeder::class,
            RecetasdosSeeder::class,
            IngredientSeeder::class,
            NombresComercialesSeeder::class,
        ]);

        // Comentarios (dependen de usuarios y recetas)
        $this->call([
            ComentariosSeeder::class,
        ]);
    }
}