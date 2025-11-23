<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Carbon\Carbon;

class DominiosSeeder extends Seeder
{
    public function run(): void
    {
        // Lista maestra de dominios
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

        $now = Carbon::now();

        foreach ($dominios as $descripcion) {
            // updateOrInsert: Busca por 'descripcion'. 
            // Si existe, actualiza 'updated_at'. Si no, crea con 'created_at'.
            DB::table('dominios')->updateOrInsert(
                ['descripcion' => $descripcion], // Condición de búsqueda
                [
                    'created_at' => $now, // Solo se usa al crear (por defecto en Eloquent, pero explícito aquí)
                    'updated_at' => $now  // Se actualiza siempre
                ]
            );
        }
        
        // --- SEGUNDA PARTE: SUBDOMINIOS (Opcional pero recomendado) ---
        // Si quieres llenar los valores de una vez, puedes agregarlos aquí.
        // Ejemplo para ESTADO_RECETA:
        
        $idEstadoReceta = DB::table('dominios')->where('descripcion', 'ESTADO_RECETA')->value('id');
        
        if ($idEstadoReceta) {
            $estados = ['BORRADOR', 'PUBLICADA', 'OCULTA', 'ELIMINADA', 'PENDIENTE'];
            
            foreach ($estados as $estado) {
                DB::table('subdominios')->updateOrInsert(
                    [
                        'id_dominio' => $idEstadoReceta,
                        'descripcion' => $estado
                    ],
                    ['updated_at' => $now, 'created_at' => $now]
                );
            }
        }
    }
}