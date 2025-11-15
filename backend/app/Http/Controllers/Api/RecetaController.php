<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class RecetaController extends Controller
{
    public function index()
    {
        try {
            // Primero obtenemos las recetas directamente
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
                ->where('recetas.id_estado', 1) // Estado "Publicado" tiene id = 1
                ->get();

            \Log::info('Total recetas encontradas: ' . $recetas->count());

            $recetasArray = [];

            foreach ($recetas as $receta) {
                // Ingredientes
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

                // Dietas
                $dietas = DB::table('receta_dieta')
                    ->join('subdominios', 'receta_dieta.id_dieta', '=', 'subdominios.id')
                    ->where('receta_dieta.id_receta', $receta->id)
                    ->pluck('subdominios.descripcion');

                $recetasArray[] = [
                    'id' => $receta->id,
                    'titulo' => $receta->titulo,
                    'resumen' => $receta->resumen,
                    'tiempo_preparacion' => $receta->tiempo_preparacion,
                    'preparacion' => $receta->preparacion,
                    'porciones_estimadas' => $receta->porciones_estimadas,
                    'imagen' => $receta->imagen ?? 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
                    'ingredientes' => $ingredientesArray,
                    'dietas' => $dietas->toArray(),
                    'chef' => 'Chef Nutrichef',
                    'chef_username' => '@nutrichef'
                ];
            }

            return response()->json([
                'success' => true,
                'data' => $recetasArray,
                'total' => count($recetasArray)
            ], 200);

        } catch (\Exception $e) {
            \Log::error('Error en RecetaController@index: ' . $e->getMessage());
            
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener recetas',
                'error' => $e->getMessage(),
                'line' => $e->getLine(),
            ], 500);
        }
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

            // Ingredientes
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

            // Dietas
            $dietas = DB::table('receta_dieta')
                ->join('subdominios', 'receta_dieta.id_dieta', '=', 'subdominios.id')
                ->where('receta_dieta.id_receta', $id)
                ->pluck('subdominios.descripcion');

            $recetaArray = [
                'id' => $receta->id,
                'titulo' => $receta->titulo,
                'resumen' => $receta->resumen,
                'tiempo_preparacion' => $receta->tiempo_preparacion,
                'preparacion' => $receta->preparacion,
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
            \Log::error('Error en RecetaController@show: ' . $e->getMessage());
            
            return response()->json([
                'success' => false,
                'message' => 'Error al obtener la receta',
                'error' => $e->getMessage(),
                'line' => $e->getLine(),
            ], 500);
        }
    }
}