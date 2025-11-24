<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class NombresComercialesSeeder extends Seeder
{
    public function run(): void
    {
        // Lista de ingredientes y sus marcas comerciales en Bolivia (todo en minúsculas)
        $data = [
            // --- LOS NUEVOS QUE NO ESTABAN EN TU BDD ---
            'Azúcar' => [
                'la belgica',
                'guabira', 
                'unagro', 
                'san aurelio', 
                'aguai', 
                'azucar blanca'
            ],
            'Fideo' => [
                'don vittorio',
                'lazzaroni', 
                'famosa', 
                'anita', 
                'nutregal', 
                'spaghetti', 
                'tallarin'
            ],
            'Mantequilla' => [
                'regia',
                'bonella', 
                'mavesa', 
                'pilisley', 
                'sancor'
            ],
            
            // --- INGREDIENTES QUE YA TIENES (O PODRÍAN ESTAR) ---
            'Leche' => ['pil', 'delizia', 'pura vida', 'ilolay'],
            'Arroz' => ['grano de oro', 'casserita', 'blue patna', 'arroz japones', 'tio rico'],
            'Aceite' => ['fino', 'rico', 'sabrosa', 'crisol', 'aceite vegetal'],
            'Harina' => ['famosa', 'cañuelas', 'princesa', 'flor', 'trigal'],
            'Atún' => ['lidita', 'san lucas', 'van camps', 'real', 'atun en aceite'],
            'Avena' => ['princesa', 'quaker', 'avena instantanea'],
            'Salsa de tomate' => ['kris', 'arcor', 'salsita'],
            'Mayonesa' => ['kris', 'hellmanns', 'ri-k'],
            'Gaseosa' => ['coca cola', 'pepsi', 'mendocina', 'simba', '7up', 'sprite'],
            'Yogurt' => ['pil', 'delizia', 'yogurt bebible', 'frutado'],
            'Chocolate' => ['el ceibo', 'breaker', 'bubbaloo', 'sublime', 'para ti'],
            'Café' => ['copacabana', 'buen dia', 'nescafe', 'presto']
        ];

        foreach ($data as $nombreIngrediente => $marcas) {
            
            // 1. Buscamos si el ingrediente ya existe en la tabla 'ingredientes'
            // Usamos 'like' para evitar problemas de mayúsculas/minúsculas en la búsqueda
            $ingrediente = DB::table('ingredientes')
                ->where('descripcion', 'LIKE', $nombreIngrediente)
                ->first();

            $ingredienteId = null;

            // 2. Si NO existe, lo creamos
            if (!$ingrediente) {
                $ingredienteId = DB::table('ingredientes')->insertGetId([
                    'descripcion' => $nombreIngrediente,
                    'yolo_key' => null, // Dejamos null porque viene de OCR, no de YOLO
                    'created_at' => Carbon::now(),
                    'updated_at' => Carbon::now(),
                ]);
                $this->command->info("🆕 Ingrediente creado: $nombreIngrediente");
            } else {
                $ingredienteId = $ingrediente->id;
                $this->command->info("✅ Ingrediente existente encontrado: $nombreIngrediente (ID: $ingredienteId)");
            }

            // 3. Insertamos las marcas comerciales (alias)
            foreach ($marcas as $marca) {
                // Verificamos si ya existe la marca para no duplicar al correr el seeder varias veces
                $existeAlias = DB::table('nombres_comerciales')
                    ->where('nombre_comercial', $marca)
                    ->exists();

                if (!$existeAlias) {
                    DB::table('nombres_comerciales')->insert([
                        'id_ingrediente' => $ingredienteId,
                        'nombre_comercial' => $marca, // Ya están en minúsculas en el array
                        'created_at' => Carbon::now(),
                        'updated_at' => Carbon::now(),
                    ]);
                }
            }
        }
        
    }
}