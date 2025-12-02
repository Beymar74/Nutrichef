<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Usuario;
use App\Models\Receta;
use App\Models\Seguidor; // Importar modelo Seguidor
use App\Models\MultimediaReceta;
use Illuminate\Support\Facades\DB;

class ChefController extends Controller
{
    public function show(Request $request, $id)
    {
        // 1. Obtener al Chef con sus contadores
        $chef = Usuario::withCount(['recetas', 'seguidores', 'seguidos'])
            ->find($id);

        if (!$chef) {
            return response()->json(['message' => 'Chef no encontrado'], 404);
        }

        // 2. Obtener recetas
        $recetas = Receta::where('id_usuario_creador', $id)
            ->with('multimedia') 
            ->orderBy('created_at', 'desc')
            ->limit(20)
            ->get();

        // 3. VERIFICAR SI EL USUARIO ACTUAL LO SIGUE
        // Aquí asumimos el usuario ID 1 para pruebas. 
        // En producción: $currentUserId = auth()->id();
        $currentUserId = $request->input('follower_id', 1); 
        
        $isFollowing = Seguidor::where('id_usuario', $currentUserId)
            ->where('id_usuario_seguido', $id)
            ->exists();

        // 4. Respuesta JSON
        return response()->json([
            'chef' => [
                'id' => $chef->id,
                'name' => $chef->name,
                'handle' => '@' . strtolower(str_replace(' ', '', $chef->name)),
                'avatar_url' => 'https://ui-avatars.com/api/?name=' . urlencode($chef->name) . '&background=FF8E00&color=fff&size=256',
                'descripcion_perfil' => $chef->descripcion_perfil ?? 'Sin descripción.',
                'followers_count' => $chef->seguidores_count,
                'following_count' => $chef->seguidos_count,
                'recipes_count' => $chef->recetas_count,
                
                // CAMPO NUEVO IMPORTANTE
                'is_following' => $isFollowing, 
            ],
            'recetas' => $recetas->map(function ($receta) {
                return [
                    'id' => $receta->id,
                    'title' => $receta->titulo,
                    'timeMinutes' => $receta->tiempo_preparacion,
                    'rating' => $receta->rating_promedio ?? 0.0,
                    'imageUrl' => route('recetas.imagen', ['id' => $receta->id]),
                ];
            })
        ]);
    }
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