<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Response;

class RecetaController extends Controller
{
    public function index()
    {
        try {
            $recetas = DB::table('recetas')
                ->leftJoin('multimedia_recetas', function($join) {
                    $join->on('recetas.id', '=', 'multimedia_recetas.id_receta')
                         ->where('multimedia_recetas.orden', '=', 1);
                })
                ->select(
                    'recetas.id',
                    'recetas.titulo',
                    'recetas.resumen',
                    'recetas.tiempo_preparacion',
                    'recetas.preparacion',
                    'recetas.porciones_estimadas',
                    'multimedia_recetas.archivo as imagen'
                )
                ->where('recetas.id_estado', 1)
                ->get();

            $recetasArray = [];

            foreach ($recetas as $receta) {
                $ingredientes = DB::table('ingrediente_receta')
                    ->join('ingredientes', 'ingrediente_receta.id_ingrediente', '=', 'ingredientes.id')
                    ->join('subdominios', 'ingrediente_receta.id_unidad_medida', '=', 'subdominios.id')
                    ->where('ingrediente_receta.id_receta', $receta->id)
                    ->select(
                        'ingredientes.descripcion',
                        'ingrediente_receta.cantidad',
                        'subdominios.descripcion as unidad_medida'
                    )
                    ->get();

                $ingredientesArray = [];
                foreach ($ingredientes as $ing) {
                    $ingredientesArray[] = [
                        'descripcion' => $ing->descripcion,
                        'cantidad' => (float) $ing->cantidad,
                        'unidad_medida' => $ing->unidad_medida
                    ];
                }

                $dietas = DB::table('receta_dieta')
                    ->join('subdominios', 'receta_dieta.id_dieta', '=', 'subdominios.id')
                    ->where('receta_dieta.id_receta', $receta->id)
                    ->pluck('subdominios.descripcion');

                $preparacionParseada = $this->parsearPreparacion($receta->preparacion);

                $recetasArray[] = [
                    'id' => $receta->id,
                    'titulo' => $receta->titulo,
                    'resumen' => $receta->resumen,
                    'tiempo_preparacion' => $receta->tiempo_preparacion,
                    'preparacion' => $preparacionParseada,
                    'porciones_estimadas' => $receta->porciones_estimadas,
                    'imagen' => $receta->imagen ?? 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
                    'ingredientes' => $ingredientesArray,
                    'dietas' => $dietas->toArray(),
                    'chef' => 'Chef Nutrichef',
                    'chef_username' => '@nutrichef'
                ];
            }

            return Response::json([
                'success' => true,
                'data' => $recetasArray,
                'total' => count($recetasArray)
            ], 200);

        } catch (\Exception $e) {
            return Response::json([
                'success' => false,
                'message' => 'Error al obtener recetas',
                'error' => $e->getMessage()
            ], 500);
        }
    }

    private function parsearPreparacion($preparacionString)
    {
        $pasos = [];
        
        if (empty($preparacionString) || trim($preparacionString) === '') {
            return $pasos;
        }

        $decoded = json_decode($preparacionString, true);
        if (json_last_error() === JSON_ERROR_NONE && is_array($decoded)) {
            foreach ($decoded as $paso) {
                if (is_array($paso)) {
                    $pasos[] = [
                        'texto' => $paso['texto'] ?? $paso,
                        'tiempo' => $paso['tiempo'] ?? $this->extraerTiempo($paso['texto'] ?? $paso), // ← Mantener tiempo existente
                        'ingredientes' => []
                    ];
                } else {
                    $pasos[] = [
                        'texto' => $paso,
                        'tiempo' => $this->extraerTiempo($paso),
                        'ingredientes' => []
                    ];
                }
            }
            return $pasos;
        }

        $textoNormalizado = trim($preparacionString);
        
        if (preg_match_all('/(\d+\.)\s*(.*?)(?=\s*\d+\.|$)/s', $textoNormalizado . ' ', $matches)) {
            foreach ($matches[2] as $textoPaso) {
                $textoPaso = trim($textoPaso);
                if (!empty($textoPaso)) {
                    $pasos[] = [
                        'texto' => $textoPaso,
                        'tiempo' => $this->extraerTiempo($textoPaso),
                        'ingredientes' => []
                    ];
                }
            }
        } else {
            $partes = explode('.', $textoNormalizado);
            foreach ($partes as $parte) {
                $parte = trim($parte);
                if (!empty($parte) && strlen($parte) > 3) { 
                    $pasos[] = [
                        'texto' => $parte,
                        'tiempo' => $this->extraerTiempo($parte),
                        'ingredientes' => []
                    ];
                }
            }
        }

        if (empty($pasos)) {
            $pasos[] = [
                'texto' => $textoNormalizado,
                'tiempo' => $this->extraerTiempo($textoNormalizado),
                'ingredientes' => []
            ];
        }

        return $pasos;
    }

    private function extraerTiempo($textoPaso)
    {
        $patrones = [
            '/(\d+)\s*minutos?/i',                    
            '/(\d+)\s*min\.?/i',                      
            '/por\s+(\d+)\s*minutos?/i',              
            '/durante\s+(\d+)\s*minutos?/i',          
            '/por\s+(\d+)\s*min\.?/i',                
            '/durante\s+(\d+)\s*min\.?/i',            
            '/dejar\s+(\d+)\s*minutos?/i',            
            '/reposar\s+(\d+)\s*minutos?/i',          
            '/cocinar\s+(\d+)\s*minutos?/i',          
            '/hornear\s+(\d+)\s*minutos?/i',          
            '/asar\s+(\d+)\s*minutos?/i',             
            '/freír\s+(\d+)\s*minutos?/i',            
            '/saltear\s+(\d+)\s*minutos?/i',          
            '/sofreír\s+(\d+)\s*minutos?/i',          
            '/hervir\s+(\d+)\s*minutos?/i',           
            '/cocer\s+(\d+)\s*minutos?/i',            
        ];

        foreach ($patrones as $patron) {
            if (preg_match($patron, $textoPaso, $matches)) {
                $minutos = (int) $matches[1];
                return $minutos > 0 ? $minutos : 1;
            }
        }

        $patronesSegundos = [
            '/(\d+)\s*segundos?/i',                  
            '/por\s+(\d+)\s*segundos?/i',             
            '/durante\s+(\d+)\s*segundos?/i',         
        ];

        foreach ($patronesSegundos as $patron) {
            if (preg_match($patron, $textoPaso, $matches)) {
                $segundos = (int) $matches[1];
                $minutos = ceil($segundos / 60);
                return $minutos > 0 ? $minutos : 1;
            }
        }
        $patronesHoras = [
            '/(\d+)\s*horas?/i',                    
            '/(\d+)\s*hrs?\.?/i',                    
            '/por\s+(\d+)\s*horas?/i',                
            '/durante\s+(\d+)\s*horas?/i',            
        ];

        foreach ($patronesHoras as $patron) {
            if (preg_match($patron, $textoPaso, $matches)) {
                $horas = (int) $matches[1];
                return $horas * 60; // Convertir horas a minutos
            }
        }

        return null;
    }

    public function show($id)
    {
        try {
            $receta = DB::table('recetas')
                ->leftJoin('multimedia_recetas', function($join) {
                    $join->on('recetas.id', '=', 'multimedia_recetas.id_receta')
                         ->where('multimedia_recetas.orden', '=', 1);
                })
                ->select(
                    'recetas.id',
                    'recetas.titulo',
                    'recetas.resumen',
                    'recetas.tiempo_preparacion',
                    'recetas.preparacion',
                    'recetas.porciones_estimadas',
                    'multimedia_recetas.archivo as imagen'
                )
                ->where('recetas.id', $id)
                ->first();

            if (!$receta) {
                return response()->json([
                    'success' => false,
                    'message' => 'Receta no encontrada'
                ], 404);
            }

            $ingredientes = DB::table('ingrediente_receta')
                ->join('ingredientes', 'ingrediente_receta.id_ingrediente', '=', 'ingredientes.id')
                ->join('subdominios', 'ingrediente_receta.id_unidad_medida', '=', 'subdominios.id')
                ->where('ingrediente_receta.id_receta', $id)
                ->select(
                    'ingredientes.descripcion',
                    'ingrediente_receta.cantidad',
                    'subdominios.descripcion as unidad_medida'
                )
                ->get();

            $ingredientesArray = [];
            foreach ($ingredientes as $ing) {
                $ingredientesArray[] = [
                    'descripcion' => $ing->descripcion,
                    'cantidad' => (float) $ing->cantidad,
                    'unidad_medida' => $ing->unidad_medida
                ];
            }

            $dietas = DB::table('receta_dieta')
                ->join('subdominios', 'receta_dieta.id_dieta', '=', 'subdominios.id')
                ->where('receta_dieta.id_receta', $id)
                ->pluck('subdominios.descripcion');

            $preparacionParseada = $this->parsearPreparacion($receta->preparacion);

            $recetaArray = [
                'id' => $receta->id,
                'titulo' => $receta->titulo,
                'resumen' => $receta->resumen,
                'tiempo_preparacion' => $receta->tiempo_preparacion,
                'preparacion' => $preparacionParseada,
                'porciones_estimadas' => $receta->porciones_estimadas,
                'imagen' => $receta->imagen ?? 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
                'ingredientes' => $ingredientesArray,
                'dietas' => $dietas->toArray(),
                'chef' => 'Chef Nutrichef',
                'chef_username' => '@nutrichef'
            ];

            return response()->json([
                'success' => true,
                'data' => $recetaArray
            ], 200);

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener la receta',
                'error' => $e->getMessage()
            ], 500);
        }
    }
}