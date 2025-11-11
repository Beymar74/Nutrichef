<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class DominiosSeeder extends Seeder
{
    public function run(): void
    {
        $now = now()->format('Y-m-d H:i:s');

        $dominios = [
            'ESTADO_RECETA',
            'ESTADO_PUBLICACION',
            'ESTADO_COMENTARIO',
            'TIPO_ALIMENTO',
            'UNIDAD_MEDIDA',
            'DIETA',
            'NIVEL_COCINA',
            'ALERGENO',
            'TIPO_REACCION',
        ];

        foreach ($dominios as $descripcion) {
            // Evita duplicados si se vuelve a ejecutar
            $exists = DB::table('dominios')
                ->where('descripcion', $descripcion)
                ->exists();

            if (!$exists) {
                DB::table('dominios')->insert([
                    'descripcion' => $descripcion,
                    'created_at'  => $now,
                    'updated_at'  => $now,
                ]);
            }
        }
    }
}
