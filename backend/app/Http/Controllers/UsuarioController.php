<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Usuario;
use App\Models\Rol;
use Illuminate\Http\Request;

class UsuarioController extends Controller
{
    public function index(Request $request)
    {
        // Cargar relaciones para evitar consultas N+1
        $query = Usuario::with(['rol', 'persona']);

        // 1. Buscador (Nombre de usuario, Email o Nombre real)
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function($q) use ($search) {
                $q->where('name', 'ilike', "%{$search}%")
                  ->orWhere('email', 'ilike', "%{$search}%")
                  ->orWhereHas('persona', function($q2) use ($search) {
                      $q2->where('nombres', 'ilike', "%{$search}%")
                         ->orWhere('apellido_paterno', 'ilike', "%{$search}%");
                  });
            });
        }

        // 2. Filtro por Rol
        if ($request->filled('rol')) {
            $query->where('id_rol', $request->rol);
        }

        $usuarios = $query->orderBy('created_at', 'desc')->paginate(10);
        
        // Para el select del filtro
        $roles = Rol::where('estado', true)->get();

        return view('admin.usuarios.index', compact('usuarios', 'roles'));
    }

    public function show($id)
    {
        $usuario = Usuario::with(['rol', 'persona', 'recetasCreadas', 'planificadorComidas'])->findOrFail($id);
        return view('admin.usuarios.show', compact('usuario'));
    }

    // Acción para Desactivar/Activar usuario (Ban)
    public function toggleStatus($id)
    {
        $usuario = Usuario::findOrFail($id);
        
        // Cambia el estado: si es true pasa a false, y viceversa
        $usuario->estado = !$usuario->estado;
        $usuario->save();

        $status = $usuario->estado ? 'activado' : 'desactivado';
        
        return back()->with('success', "El usuario ha sido {$status} correctamente.");
    }
}