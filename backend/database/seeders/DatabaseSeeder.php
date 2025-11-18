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
        // Primero seeders base (catálogos)
        $this->call([
            RolesSeeder::class,
            DominiosSeeder::class,
            SubdominiosSeeder::class,
        ]);

        // Luego seeders dependientes
        // (Usuarios, ingredientes, etc. si los tienes)
        // $this->call([
        //     UsuariosSeeder::class,
        //     IngredientesSeeder::class,
        // ]);

        // Finalmente tus seeders de recetas
        $this->call([
            RecetasSeeder::class,
            RecetasdosSeeder::class,
        ]);
    }
}
