<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Comentario;
use App\Models\Subdominio;
use Illuminate\Http\Request;

class ComentarioController extends Controller
{
    public function index()
    {
        $comentarios = Comentario::with(['usuario', 'publicacion.receta', 'estado'])
                                ->orderBy('created_at', 'desc')
                                ->paginate(10);

        return view('admin.comentarios.index', compact('comentarios'));
    }

    public function moderar($id, $accion)
    {
        $comentario = Comentario::findOrFail($id);
        
        $nuevoEstado = null;
        $mensaje = '';

        if ($accion === 'aprobar') {
            $nuevoEstado = Subdominio::where('descripcion', 'VISIBLE')->value('id');
            $mensaje = 'Comentario marcado como visible.';
        } elseif ($accion === 'eliminar') {
            $nuevoEstado = Subdominio::where('descripcion', 'ELIMINADO_ADMIN')->value('id');
            $mensaje = 'Comentario eliminado por administración.';
        }

        if ($nuevoEstado) {
            $comentario->update(['id_estado' => $nuevoEstado]);
            return back()->with('success', $mensaje);
        }

        return back()->with('error', 'No se encontró el estado solicitado. Verifique sus seeders.');
    }
}