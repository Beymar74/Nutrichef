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

        $this->call([
            RecetasSeeder::class,
            RecetasdosSeeder::class,
            IngredientSeeder::class,
        ]);
    }
}
