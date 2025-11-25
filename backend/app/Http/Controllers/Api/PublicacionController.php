<?php

namespace App\Http\Controllers\Api;

use App\Models\Publicacion;
use App\Models\Reaccion;
use App\Models\Comentario; // Asegúrate de tener el modelo Comentario
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;

class PublicacionController extends Controller
{
    // Método para obtener las publicaciones
    public function index()
    {
        $publicaciones = Publicacion::all();

        return response()->json([
            'success' => true,
            'data' => $publicaciones
        ]);
    }

    // Método para agregar una reacción (like) a una publicación
    public function darReaccion($id)
    {
        $publicacion = Publicacion::find($id);
        if (!$publicacion) {
            return response()->json(['success' => false, 'message' => 'Publicación no encontrada'], 404);
        }

        $reaccion = new Reaccion();
        $reaccion->id_publicacion = $publicacion->id;
        $reaccion->id_usuario = Auth::id(); // Obtén el ID del usuario autenticado
        $reaccion->tipo_reaccion = 'like'; // Definir el tipo de reacción
        $reaccion->save();

        return response()->json(['success' => true, 'message' => 'Reacción agregada']);
    }

    // Método para eliminar una publicación
    public function eliminarPublicacion($id)
    {
        $publicacion = Publicacion::find($id);

        if ($publicacion) {
            $publicacion->reacciones()->delete(); // Eliminar todas las reacciones asociadas
            $publicacion->delete(); // Eliminar la publicación

            return response()->json(['success' => true, 'message' => 'Publicación eliminada']);
        }

        return response()->json(['success' => false, 'message' => 'Publicación no encontrada'], 404);
    }

    // Método para reportar una publicación
    public function reportar($id)
    {
        $publicacion = Publicacion::find($id);

        if ($publicacion) {
            $publicacion->increment('reportes'); // Agregar un contador de reportes

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

    // Método para obtener los comentarios de una publicación
    public function obtenerComentarios($id)
    {
        $publicacion = Publicacion::find($id);

        if ($publicacion) {
            $comentarios = $publicacion->comentarios; // Suponiendo que hay una relación 'comentarios' en el modelo Publicacion

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

    // Método para agregar un comentario
    public function agregarComentario(Request $request, $id)
    {
        $publicacion = Publicacion::find($id);

        if (!$publicacion) {
            return response()->json(['success' => false, 'message' => 'Publicación no encontrada'], 404);
        }

        // Validar los datos del comentario
        $request->validate([
            'contenido' => 'required|string|max:255',
        ]);

        // Crear el comentario
        $comentario = new Comentario();
        $comentario->contenido = $request->contenido;
        $comentario->id_publicacion = $publicacion->id;
        $comentario->id_usuario = Auth::id(); // Asociamos el comentario al usuario autenticado
        $comentario->save();

        return response()->json([
            'success' => true,
            'message' => 'Comentario agregado correctamente',
            'data' => $comentario
        ]);
    }
}
