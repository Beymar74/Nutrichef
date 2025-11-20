<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class IngredientSeeder extends Seeder
{
    public function run(): void
    {
        $now = Carbon::now();
        
        $ingredientesConIA = [
            // --- FRUTAS Y VERDURAS (Ingredientes Reales) ---
            ['descripcion' => 'Manzana',          'yolo_key' => 'apple'],
            ['descripcion' => 'Banano/Plátano',   'yolo_key' => 'banana'],
            ['descripcion' => 'Naranja',          'yolo_key' => 'orange'],
            ['descripcion' => 'Brócoli',          'yolo_key' => 'broccoli'],
            ['descripcion' => 'Zanahoria',        'yolo_key' => 'carrot'],

            // --- UTENSILIOS Y RECIPIENTES ---
            ['descripcion' => 'Botella',          'yolo_key' => 'bottle'],
        
        ];

        foreach ($ingredientesConIA as $ing) {
            // 1. Preguntamos si ya existe
            $existe = DB::table('ingredientes')
                        ->where('descripcion', $ing['descripcion'])
                        ->exists();

            if ($existe) {
                // 2. Si existe, SOLO actualizamos la llave de IA y la fecha de actualización
                DB::table('ingredientes')
                    ->where('descripcion', $ing['descripcion'])
                    ->update([
                        'yolo_key' => $ing['yolo_key'],
                        'updated_at' => $now
                    ]);
            } else {
                // 3. Si no existe, creamos el registro completo
                DB::table('ingredientes')->insert([
                    'descripcion' => $ing['descripcion'],
                    'yolo_key' => $ing['yolo_key'],
                    'id_alergeno' => null,
                    'created_at' => $now,
                    'updated_at' => $now
                ]);
            }
        }
    }
}