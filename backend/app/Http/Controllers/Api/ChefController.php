<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Models\User;   // Asegúrate de tener tus modelos creados
use App\Models\Receta;

class ChefController extends Controller
{
    public function show($id)
    {
        // 1. Buscar al Chef (Usuario) y contar sus relaciones
        // Asumiendo que usas Eloquent y tienes las relaciones definidas en el modelo User
        $chef = User::withCount(['recetas', 'seguidores', 'siguiendo'])
                    ->where('id', $id)
                    ->firstOrFail();

        // 2. Obtener las recetas del chef
        // Filtramos solo las que no estén eliminadas o borradores si es necesario
        $recetas = Receta::where('id_usuario_creador', $id)
            ->join('subdominios as estado', 'recetas.id_estado', '=', 'estado.id')
            ->where('estado.descripcion', 'PUBLICADA') // Solo recetas publicadas
            ->with(['multimedia' => function($q) {
                $q->orderBy('orden', 'asc')->take(1); // Solo la primera imagen (portada)
            }])
            ->select('recetas.*')
            ->orderBy('recetas.created_at', 'desc')
            ->get()
            ->map(function ($receta) {
                // Formateamos la respuesta para Flutter
                return [
                    'id' => $receta->id,
                    'titulo' => $receta->titulo,
                    'tiempo' => $receta->tiempo_preparacion . ' min',
                    'rating' => 4.8, // Valor ejemplo, calcular real si tienes tabla calificaciones
                    // Obtenemos la URL de la primera imagen o una por defecto
                    'imagen' => $receta->multimedia->first() ? $receta->multimedia->first()->archivo : 'https://via.placeholder.com/300',
                ];
            });

        // 3. Respuesta JSON para Flutter
        return response()->json([
            'chef' => [
                'id' => $chef->id,
                'name' => $chef->name,
                'handle' => '@' . strtolower(str_replace(' ', '', $chef->name)), // Generar handle si no existe
                'bio' => $chef->descripcion_perfil ?? 'Amante de la cocina saludable.',
                'imagen' => 'https://ui-avatars.com/api/?name=' . urlencode($chef->name) . '&background=ff8e00&color=fff', // Avatar automático si no hay foto
                'stats' => [
                    'recetas' => $chef->recetas_count,
                    'seguidores' => $chef->seguidores_count ?? 0, // Ajustar según tu modelo
                    'siguiendo' => $chef->siguiendo_count ?? 0
                ]
            ],
            'recetas' => $recetas
        ]);
    }
}