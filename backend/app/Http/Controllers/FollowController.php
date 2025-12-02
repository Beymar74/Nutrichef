<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Seguidor;
use App\Models\Usuario;
use Illuminate\Support\Facades\DB;

class FollowController extends Controller
{
    /**
     * Seguir a un usuario (Chef).
     * POST /api/chefs/{id}/follow
     */
    public function toggleFollow(Request $request, $id)
    {
        // En una app real, obtendrías el ID del usuario autenticado así:
        // $followerId = auth()->id();
        
        // PARA PRUEBAS (Hardcodeado al usuario 1 si no hay auth implementado aún)
        // CAMBIA ESTO cuando tengas autenticación (Sanctum/Passport)
        $followerId = $request->input('follower_id', 1); 

        // Validar que no se siga a sí mismo
        if ($followerId == $id) {
            return response()->json(['message' => 'No puedes seguirte a ti mismo'], 400);
        }

        // Verificar si el usuario a seguir existe
        $chef = Usuario::find($id);
        if (!$chef) {
            return response()->json(['message' => 'Chef no encontrado'], 404);
        }

        // Verificar si ya existe la relación
        $seguimiento = Seguidor::where('id_usuario', $followerId) // Seguidor
            ->where('id_usuario_seguido', $id) // Seguido
            ->first();

        if ($seguimiento) {
            // Si ya existe, lo borramos (Dejar de seguir / Unfollow)
            $seguimiento->delete();
            $isFollowing = false;
            $message = 'Dejaste de seguir a ' . $chef->name;
        } else {
            // Si no existe, lo creamos (Seguir / Follow)
            Seguidor::create([
                'id_usuario' => $followerId,
                'id_usuario_seguido' => $id,
                'created_at' => now(),
                'updated_at' => now(),
            ]);
            $isFollowing = true;
            $message = 'Ahora sigues a ' . $chef->name;
        }

        // Devolver el nuevo estado y conteo actualizado
        $newFollowersCount = Seguidor::where('id_usuario_seguido', $id)->count();

        return response()->json([
            'success' => true,
            'message' => $message,
            'is_following' => $isFollowing,
            'followers_count' => $newFollowersCount,
        ]);
    }

    /**
     * Verificar si sigo a este chef.
     * GET /api/chefs/{id}/is-following
     */
    public function checkFollowStatus(Request $request, $id)
    {
        // Mismo caso: obtener usuario autenticado
        $followerId = $request->input('follower_id', 1); 

        $isFollowing = Seguidor::where('id_usuario', $followerId)
            ->where('id_usuario_seguido', $id)
            ->exists();

        return response()->json(['is_following' => $isFollowing]);
    }
}