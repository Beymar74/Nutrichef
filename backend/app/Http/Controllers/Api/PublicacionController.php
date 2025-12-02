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
    $publicaciones = Publicacion::with([
        'usuario:id,name,username,avatar',  // Traer datos de usuario
        'imagenes', // Traer las imágenes asociadas
        'reacciones', // Traer reacciones
        'comentarios', // Traer comentarios
    ])
    ->orderBy('created_at', 'desc') // Ordenar por fecha
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
            'ya_dio_like' => $p->reacciones->contains('id_usuario', Auth::id()), // Verificar si ya dio like
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
        'imagenes.*' => 'nullable|image|mimes:jpg,jpeg,png|max:5120', // 5MB por imagen
    ]);

    // Crear la publicación
    $publicacion = Publicacion::create([
        'descripcion' => $request->descripcion,
        'id_usuario' => Auth::id(),
    ]);

    // Guardar imágenes si existen
    if ($request->hasFile('imagenes')) {
        foreach ($request->file('imagenes') as $file) {

            // Guardar la imagen en storage
            $ruta = $file->store('public/publicaciones');
            $rutaPublica = str_replace('public/', 'storage/', $ruta);  // Convertir a URL

            // Insertar la imagen en la base de datos
            $publicacion->imagenes()->create([
                'ruta' => url($rutaPublica),
            ]);
        }
    }

    // Respuesta de éxito con las imágenes
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
    // En PublicacionController.php

public function show($id)
{
    $publicacion = Publicacion::find($id);

    if (!$publicacion) {
        return response()->json([
            'success' => false,
            'message' => 'Publicación no encontrada'
        ], 404);
    }

    return response()->json([
        'success' => true,
        'data' => $publicacion
    ]);
}

public function update(Request $request, $id)
{
    $publicacion = Publicacion::find($id);

    if (!$publicacion) {
        return response()->json(['success' => false, 'message' => 'Publicación no encontrada'], 404);
    }

    // Verificar que el usuario sea el dueño
    if ($publicacion->id_usuario !== Auth::id()) {
        return response()->json(['success' => false, 'message' => 'No autorizado'], 403);
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
} // ✅ Cierre de la clase