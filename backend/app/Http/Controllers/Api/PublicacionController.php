<?php

namespace App\Http\Controllers\Api;

use App\Models\Publicacion;
use App\Models\Reaccion;
use App\Models\Comentario;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Storage;

class PublicacionController extends Controller
{
    public function index()
    {
        $publicaciones = Publicacion::with([
            'usuario:id,name,username,avatar',
            'imagenes',
            'reacciones',
            'comentarios',
        ])
        ->orderBy('created_at', 'desc')
        ->get()
        ->map(function ($p) {
            return [
                'id' => $p->id,
                'descripcion' => $p->descripcion,
                'created_at' => $p->created_at,
                'usuario' => [
                    'id' => $p->usuario->id,
                    'name' => $p->usuario->name,
                    'username' => '@' . $p->usuario->username,
                    'avatar' => $p->usuario->avatar,
                ],
                'imagenes' => $p->imagenes->pluck('ruta'),
                'likes_count' => $p->reacciones->count(),
                'comentarios_count' => $p->comentarios->count(),
                'ya_dio_like' => $p->reacciones->contains('id_usuario', Auth::id()),
            ];
        });

        return response()->json([
            'success' => true,
            'data' => $publicaciones
        ]);
    }

    public function store(Request $request)
    {
        $request->validate([
            'descripcion' => 'required|string',
            'imagenes.*' => 'nullable|image|mimes:jpg,jpeg,png|max:5120',
        ]);

        $publicacion = Publicacion::create([
            'descripcion' => $request->descripcion,
            'id_usuario' => Auth::id(),
        ]);

        if ($request->hasFile('imagenes')) {
            foreach ($request->file('imagenes') as $file) {
                $ruta = $file->store('public/publicaciones');
                $rutaPublica = str_replace('public/', 'storage/', $ruta);

                $publicacion->imagenes()->create([
                    'ruta' => url($rutaPublica),
                ]);
            }
        }

        return response()->json([
            'success' => true,
            'message' => 'Publicación creada exitosamente',
            'data' => [
                'id' => $publicacion->id,
                'descripcion' => $publicacion->descripcion,
                'created_at' => $publicacion->created_at,
                'usuario' => [
                    'id' => Auth::user()->id,
                    'name' => Auth::user()->name,
                    'username' => '@' . Auth::user()->username,
                    'avatar' => Auth::user()->avatar,
                ],
                'imagenes' => $publicacion->imagenes->pluck('ruta'),
                'likes_count' => 0,
                'comentarios_count' => 0,
                'ya_dio_like' => false,
            ]
        ], 201);
    }

    public function darReaccion($id)
{
    $publicacion = Publicacion::find($id);
    
    if (!$publicacion) {
        return response()->json([
            'success' => false,
            'message' => 'Publicación no encontrada'
        ], 404);
    }

    $reaccionExistente = Reaccion::where('id_publicacion', $id)
        ->where('id_usuario', Auth::id())
        ->first();

    if ($reaccionExistente) {
        $reaccionExistente->delete();
        
        return response()->json([
            'success' => true,
            'message' => 'Reacción eliminada',
            'ya_dio_like' => false,
            'likes_count' => $publicacion->reacciones()->count()
        ]);
    } else {
        Reaccion::create([
            'id_publicacion' => $id,
            'id_usuario' => Auth::id(),
            'tipo_reaccion' => 'like'  // ✅ Campo directo
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Reacción agregada',
            'ya_dio_like' => true,
            'likes_count' => $publicacion->reacciones()->count()
        ]);
    }
}

    // ✅ ELIMINAR PUBLICACIÓN (con validación y limpieza de imágenes)
    public function eliminarPublicacion($id)
    {
        $publicacion = Publicacion::find($id);

        if (!$publicacion) {
            return response()->json([
                'success' => false,
                'message' => 'Publicación no encontrada'
            ], 404);
        }

        // ✅ Verificar que el usuario sea dueño
        if ($publicacion->id_usuario !== Auth::id()) {
            return response()->json([
                'success' => false,
                'message' => 'No tienes permiso para eliminar esta publicación'
            ], 403);
        }

        // ✅ Eliminar imágenes del storage
        foreach ($publicacion->imagenes as $imagen) {
            // Extraer ruta del storage desde la URL completa
            $rutaRelativa = str_replace(url('storage/'), 'public/', $imagen->ruta);
            Storage::delete($rutaRelativa);
        }

        // Eliminar relaciones y publicación
        $publicacion->imagenes()->delete();
        $publicacion->reacciones()->delete();
        $publicacion->comentarios()->delete();
        $publicacion->delete();

        return response()->json([
            'success' => true,
            'message' => 'Publicación eliminada correctamente'
        ]);
    }

    public function reportar($id)
    {
        $publicacion = Publicacion::find($id);

        if (!$publicacion) {
            return response()->json([
                'success' => false,
                'message' => 'Publicación no encontrada'
            ], 404);
        }

        $publicacion->increment('reportes');
        
        return response()->json([
            'success' => true,
            'message' => 'Publicación reportada correctamente'
        ]);
    }

    public function obtenerComentarios($id)
    {
        $publicacion = Publicacion::find($id);

        if (!$publicacion) {
            return response()->json([
                'success' => false,
                'message' => 'Publicación no encontrada'
            ], 404);
        }

        $comentarios = $publicacion->comentarios()
            ->with('usuario:id,name,username,avatar')
            ->orderBy('created_at', 'desc')
            ->get()
            ->map(function ($c) {
                return [
                    'id' => $c->id,
                    'contenido' => $c->contenido,
                    'created_at' => $c->created_at,
                    'usuario' => [
                        'id' => $c->usuario->id,
                        'name' => $c->usuario->name,
                        'username' => '@' . $c->usuario->username,
                        'avatar' => $c->usuario->avatar,
                    ],
                    'es_propio' => $c->id_usuario === Auth::id()
                ];
            });

        return response()->json([
            'success' => true,
            'data' => $comentarios
        ]);
    }

    public function agregarComentario(Request $request, $id)
    {
        $publicacion = Publicacion::find($id);

        if (!$publicacion) {
            return response()->json([
                'success' => false,
                'message' => 'Publicación no encontrada'
            ], 404);
        }

        $request->validate([
            'contenido' => 'required|string|max:500',
        ]);

        $comentario = Comentario::create([
            'contenido' => $request->contenido,
            'id_publicacion' => $id,
            'id_usuario' => Auth::id(),
        ]);

        $comentario->load('usuario:id,name,username,avatar');

        return response()->json([
            'success' => true,
            'message' => 'Comentario agregado correctamente',
            'data' => [
                'id' => $comentario->id,
                'contenido' => $comentario->contenido,
                'created_at' => $comentario->created_at,
                'usuario' => [
                    'id' => $comentario->usuario->id,
                    'name' => $comentario->usuario->name,
                    'username' => '@' . $comentario->usuario->username,
                    'avatar' => $comentario->usuario->avatar,
                ],
                'es_propio' => true
            ]
        ]);
    }

    // ✅ ELIMINAR COMENTARIO (faltaba este método)
    public function eliminarComentario($id)
    {
        $comentario = Comentario::find($id);

        if (!$comentario) {
            return response()->json([
                'success' => false,
                'message' => 'Comentario no encontrado'
            ], 404);
        }

        // Verificar que el usuario sea dueño
        if ($comentario->id_usuario !== Auth::id()) {
            return response()->json([
                'success' => false,
                'message' => 'No tienes permiso para eliminar este comentario'
            ], 403);
        }

        $comentario->delete();

        return response()->json([
            'success' => true,
            'message' => 'Comentario eliminado correctamente'
        ]);
    }

    public function show($id)
    {
        $publicacion = Publicacion::with([
            'usuario:id,name,username,avatar',
            'imagenes',
            'reacciones',
            'comentarios'
        ])->find($id);

        if (!$publicacion) {
            return response()->json([
                'success' => false,
                'message' => 'Publicación no encontrada'
            ], 404);
        }

        return response()->json([
            'success' => true,
            'data' => [
                'id' => $publicacion->id,
                'descripcion' => $publicacion->descripcion,
                'created_at' => $publicacion->created_at,
                'usuario' => [
                    'id' => $publicacion->usuario->id,
                    'name' => $publicacion->usuario->name,
                    'username' => '@' . $publicacion->usuario->username,
                    'avatar' => $publicacion->usuario->avatar,
                ],
                'imagenes' => $publicacion->imagenes->pluck('ruta'),
                'likes_count' => $publicacion->reacciones->count(),
                'comentarios_count' => $publicacion->comentarios->count(),
                'ya_dio_like' => $publicacion->reacciones->contains('id_usuario', Auth::id()),
            ]
        ]);
    }

    public function update(Request $request, $id)
    {
        $publicacion = Publicacion::find($id);

        if (!$publicacion) {
            return response()->json([
                'success' => false,
                'message' => 'Publicación no encontrada'
            ], 404);
        }

        if ($publicacion->id_usuario !== Auth::id()) {
            return response()->json([
                'success' => false,
                'message' => 'No autorizado'
            ], 403);
        }

        $request->validate([
            'descripcion' => 'required|string',
        ]);

        $publicacion->descripcion = $request->descripcion;
        $publicacion->save();

        return response()->json([
            'success' => true,
            'message' => 'Publicación actualizada correctamente',
            'data' => $publicacion
        ]);
    }
}