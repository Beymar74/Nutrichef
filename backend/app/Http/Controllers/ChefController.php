<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Usuario;
use App\Models\Receta;
use App\Models\MultimediaReceta; // Asegúrate de tener este modelo
use Illuminate\Support\Facades\DB;

class ChefController extends Controller
{
    /**
     * Muestra el perfil público de un Chef (Usuario) con sus estadísticas y recetas.
     */
    public function show($id)
    {
        // 1. Obtener al Chef con sus contadores usando Eloquent
        // 'withCount' utiliza las relaciones que definimos en el modelo Usuario
        // Esto cuenta automáticamente: recetas_count, seguidores_count, seguidos_count
        $chef = Usuario::withCount(['recetas', 'seguidores', 'seguidos'])
            ->find($id);

        if (!$chef) {
            return response()->json(['message' => 'Chef no encontrado'], 404);
        }

        // 2. Obtener las recetas creadas por este chef
        $recetas = Receta::where('id_usuario_creador', $id)
            // Traemos la relación 'multimedia' para verificar si tiene foto, 
            // aunque la URL la generamos aparte.
            ->with('multimedia') 
            // Si tienes la relación de calificaciones configurada, descomenta esto:
            // ->withAvg('calificaciones', 'calificacion') 
            ->orderBy('created_at', 'desc')
            ->limit(20) // Límite de recetas para no sobrecargar
            ->get();

        // 3. Formatear la respuesta JSON exacta para que Flutter la entienda
        return response()->json([
            'chef' => [
                'id' => $chef->id,
                'name' => $chef->name,
                // Generamos un handle (@nombre) si no tiene uno guardado
                'handle' => '@' . strtolower(str_replace(' ', '', $chef->name)),
                // Generamos un avatar por defecto si no tiene imagen de perfil real
                'avatar_url' => 'https://ui-avatars.com/api/?name=' . urlencode($chef->name) . '&background=FF8E00&color=fff&size=256',
                'descripcion_perfil' => $chef->descripcion_perfil ?? 'Sin descripción.',
                
                // Estos campos _count los crea Laravel automáticamente con withCount
                'followers_count' => $chef->seguidores_count,
                'following_count' => $chef->seguidos_count,
                'recipes_count' => $chef->recetas_count,
            ],
            'recetas' => $recetas->map(function ($receta) {
                return [
                    'id' => $receta->id,
                    'title' => $receta->titulo, // Flutter espera 'title'
                    'timeMinutes' => $receta->tiempo_preparacion, // Flutter espera 'timeMinutes'
                    // Usamos el accessor (atributo virtual) que creamos en el modelo Receta
                    // Si no lo tienes, usa un valor por defecto o calcula el promedio aquí
                    'rating' => $receta->rating_promedio ?? 0.0, 
                    
                    // Generamos la ruta a la imagen que servimos en getRecipeImage
                    'imageUrl' => route('recetas.imagen', ['id' => $receta->id]),
                ];
            })
        ]);
    }

    /**
     * Sirve la imagen principal de una receta desde la base de datos (BYTEA).
     * Esto es vital porque Flutter no puede leer el binario directo en el JSON fácilmente.
     */
    public function getRecipeImage($id)
    {
        // Buscamos la primera imagen asociada a la receta
        // Si no tienes el modelo MultimediaReceta, puedes usar DB::table('multimedia_recetas')
        $media = MultimediaReceta::where('id_receta', $id)
            ->orderBy('orden', 'asc') // Asumiendo que 'orden' define la principal
            ->first();

        if ($media && $media->archivo) {
            // Convertir el stream de recursos (BYTEA de Postgres) a string para la respuesta
            $contenido = is_resource($media->archivo) ? stream_get_contents($media->archivo) : $media->archivo;

            return response($contenido)
                ->header('Content-Type', $media->tipo_archivo ?? 'image/jpeg')
                ->header('Cache-Control', 'public, max-age=86400'); // Cache por 1 día para que sea rápido
        }

        // Si no tiene imagen, redirigir a un placeholder gris
        return redirect('https://via.placeholder.com/300?text=Sin+Imagen');
    }
}