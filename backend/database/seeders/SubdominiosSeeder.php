<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class SubdominiosSeeder extends Seeder
{
    public function run(): void
    {
        $now = now()->format('Y-m-d H:i:s');

        // Mapeamos descripcion_de_dominio => id
        $dominios = DB::table('dominios')
            ->pluck('id', 'descripcion')
            ->toArray();

        // Definición de subdominios por dominio
        $data = [

            'ESTADO_RECETA' => [
                'BORRADOR',
                'PUBLICADA',
                'OCULTA',
                'ELIMINADA',
            ],

            'ESTADO_PUBLICACION' => [
                'PUBLICADA',
                'OCULTA',
                'REPORTADA',
                'ELIMINADA',
            ],

            'ESTADO_COMENTARIO' => [
                'VISIBLE',
                'ELIMINADO_AUTOR',
                'ELIMINADO_ADMIN',
                'REPORTADO',
            ],

            'TIPO_ALIMENTO' => [
                'ITALIANA',
                'HAMBURGUESAS',
                'ENSALADAS',
                'POSTRES',
                'BEBIDAS',
                'MEXICANA',
                'ASIATICA',
                'RAPIDA',
                'SALUDABLE',
                'VEGANA',
                'OTRO',
            ],

            'UNIDAD_MEDIDA' => [
                'G',
                'KG',
                'ML',
                'L',
                'CUCHARADITA',
                'CUCHARADA',
                'TAZA',
                'UNIDAD',
            ],

            'DIETA' => [
                'OMNIVORA',
                'VEGETARIANA',
                'VEGANA',
                'SIN_GLUTEN',
                'SIN_LACTOSA',
                'KETO',
                'HIPOCALORICA',
                'HIPERCALORICA',
            ],

            'NIVEL_COCINA' => [
                'PRINCIPIANTE',
                'INTERMEDIO',
                'AVANZADO',
                'PROFESIONAL',
            ],

            'ALERGENO' => [
                'GLUTEN',
                'LACTOSA',
                'HUEVO',
                'MANI',
                'FRUTOS_SECOS',
                'MARISCOS',
                'PESCADO',
                'SOYA',
            ],

            'TIPO_REACCION' => [
                'LIKE',
                'LOVE',
                'DISLIKE',
            ],
        ];

        foreach ($data as $dominioDescripcion => $subdominios) {

            if (!isset($dominios[$dominioDescripcion])) {
                // Si falta algún dominio, lo saltamos para no romper el seeder
                continue;
            }

            $idDominio = $dominios[$dominioDescripcion];

            foreach ($subdominios as $descripcion) {
                $exists = DB::table('subdominios')
                    ->where('id_dominio', $idDominio)
                    ->where('descripcion', $descripcion)
                    ->exists();

                if (!$exists) {
                    DB::table('subdominios')->insert([
                        'id_dominio' => $idDominio,
                        'descripcion'=> $descripcion,
                        'created_at' => $now,
                        'updated_at' => $now,
                    ]);
                }
            }
        }
    }
}
