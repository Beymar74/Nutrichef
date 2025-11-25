<?php

namespace App\Http\Controllers\Api;

use App\Models\Publicacion;
use App\Models\Reaccion;
use App\Models\Comentario;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;

class PublicacionController extends Controller
{
    public function index()
    {
        // ✅ Simplificado: sin cargar relaciones que no existen
        $publicaciones = Publicacion::orderBy('created_at', 'desc')->get();

        return response()->json([
            'success' => true,
            'data' => $publicaciones
        ]);
    }

    public function darReaccion($id)
    {
        $publicacion = Publicacion::find($id);
        if (!$publicacion) {
            return response()->json(['success' => false, 'message' => 'Publicación no encontrada'], 404);
        }

        $reaccion = new Reaccion();
        $reaccion->id_publicacion = $publicacion->id;
        $reaccion->id_usuario = Auth::id();
        $reaccion->tipo_reaccion = 'like';
        $reaccion->save();

        return response()->json(['success' => true, 'message' => 'Reacción agregada']);
    }

    public function eliminarPublicacion($id)
    {
        $publicacion = Publicacion::find($id);

        if ($publicacion) {
            $publicacion->reacciones()->delete();
            $publicacion->delete();
            return response()->json(['success' => true, 'message' => 'Publicación eliminada']);
        }

        return response()->json(['success' => false, 'message' => 'Publicación no encontrada'], 404);
    }

    public function reportar($id)
    {
        $publicacion = Publicacion::find($id);

        if ($publicacion) {
            $publicacion->increment('reportes');
            return response()->json([
                'success' => true,
                'message' => 'Publicación reportada correctamente'
            ]);
        }

        return response()->json([
            'success' => false,
            'message' => 'Publicación no encontrada'
        ], 404);
    }

    public function obtenerComentarios($id)
    {
        $publicacion = Publicacion::find($id);

        if ($publicacion) {
            $comentarios = $publicacion->comentarios;
            return response()->json([
                'success' => true,
                'data' => $comentarios
            ]);
        }

        return response()->json([
            'success' => false,
            'message' => 'Publicación no encontrada'
        ], 404);
    }

    public function agregarComentario(Request $request, $id)
    {
        $publicacion = Publicacion::find($id);

        if (!$publicacion) {
            return response()->json(['success' => false, 'message' => 'Publicación no encontrada'], 404);
        }

        $request->validate([
            'contenido' => 'required|string|max:255',
        ]);

        $comentario = new Comentario();
        $comentario->contenido = $request->contenido;
        $comentario->id_publicacion = $publicacion->id;
        $comentario->id_usuario = Auth::id();
        $comentario->save();

        return response()->json([
            'success' => true,
            'message' => 'Comentario agregado correctamente',
            'data' => $comentario
        ]);
    }
}