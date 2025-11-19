<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Usuario;
use App\Models\Rol;
use App\Models\Persona;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class UsuarioController extends Controller
{
    // ... métodos index, show y toggleStatus se mantienen igual ...

    public function index(Request $request)
    {
        $query = Usuario::with(['rol', 'persona']);

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

        if ($request->filled('rol')) {
            $query->where('id_rol', $request->rol);
        }

        $usuarios = $query->orderBy('created_at', 'desc')->paginate(10);
        $roles = Rol::where('estado', true)->get();

        return view('admin.usuarios.index', compact('usuarios', 'roles'));
    }

    public function show($id)
    {
        $usuario = Usuario::with(['rol', 'persona', 'recetasCreadas', 'planificadorComidas'])->findOrFail($id);
        return view('admin.usuarios.show', compact('usuario'));
    }

    public function toggleStatus($id)
    {
        $usuario = Usuario::findOrFail($id);
        $usuario->estado = !$usuario->estado;
        $usuario->save();
        $status = $usuario->estado ? 'activado' : 'desactivado';
        return back()->with('success', "El usuario ha sido {$status} correctamente.");
    }

    public function edit($id)
    {
        $usuario = Usuario::with(['persona', 'rol'])->findOrFail($id);
        $roles = Rol::where('estado', true)->get();
        return view('admin.usuarios.edit', compact('usuario', 'roles'));
    }

    public function update(Request $request, $id)
    {
        $usuario = Usuario::findOrFail($id);

        $request->validate([
            'id_rol' => 'required|exists:roles,id',
            'name' => 'required|string|max:100',
            'email' => 'required|email|unique:usuarios,email,' . $id,
            'nombres' => 'required|string|max:100',
            'apellido_paterno' => 'required|string|max:100',
            'apellido_materno' => 'nullable|string|max:100',
            'telefono' => 'nullable|string|max:20',
            'fecha_nacimiento' => 'nullable|date',
        ]);

        try {
            DB::beginTransaction();

            $usuario->update([
                'id_rol' => $request->id_rol,
                'name' => $request->name,
                'email' => $request->email,
            ]);

            if ($usuario->persona) {
                $usuario->persona->update([
                    'nombres' => $request->nombres,
                    'apellido_paterno' => $request->apellido_paterno,
                    'apellido_materno' => $request->apellido_materno,
                    'telefono' => $request->telefono,
                    'fecha_nacimiento' => $request->fecha_nacimiento,
                ]);
            } else {
                $persona = Persona::create([
                    'nombres' => $request->nombres,
                    'apellido_paterno' => $request->apellido_paterno,
                    'apellido_materno' => $request->apellido_materno,
                    'telefono' => $request->telefono,
                    'fecha_nacimiento' => $request->fecha_nacimiento,
                    'estado' => true
                ]);
                $usuario->id_persona = $persona->id;
                $usuario->save();
            }

            DB::commit();
            return redirect()->route('admin.usuarios.show', $id)->with('success', 'Datos actualizados correctamente.');

        } catch (\Exception $e) {
            DB::rollBack();
            return back()->with('error', 'Error: ' . $e->getMessage());
        }
    }

    // --- NUEVOS MÉTODOS CREATE Y STORE ---

    public function create()
    {
        $roles = Rol::where('estado', true)->get();
        return view('admin.usuarios.create', compact('roles'));
    }

    public function store(Request $request)
    {
        $request->validate([
            'id_rol' => 'required|exists:roles,id',
            'name' => 'required|string|max:100',
            'email' => 'required|email|unique:usuarios,email',
            'password' => 'required|string|min:8|confirmed', // Requiere password_confirmation en el form
            'nombres' => 'required|string|max:100',
            'apellido_paterno' => 'required|string|max:100',
            'apellido_materno' => 'nullable|string|max:100',
            'telefono' => 'nullable|string|max:20',
            'fecha_nacimiento' => 'nullable|date',
        ]);

        try {
            DB::beginTransaction();

            // 1. Crear Persona Primero
            $persona = Persona::create([
                'nombres' => $request->nombres,
                'apellido_paterno' => $request->apellido_paterno,
                'apellido_materno' => $request->apellido_materno,
                'telefono' => $request->telefono,
                'fecha_nacimiento' => $request->fecha_nacimiento,
                'estado' => true
            ]);

            // 2. Crear Usuario vinculado
            $usuario = Usuario::create([
                'id_rol' => $request->id_rol,
                'id_persona' => $persona->id,
                'name' => $request->name,
                'email' => $request->email,
                'password' => Hash::make($request->password),
                'estado' => true,
                'descripcion_perfil' => 'Usuario nuevo creado por administración.'
            ]);

            DB::commit();

            return redirect()->route('admin.usuarios.index')
                             ->with('success', 'Usuario creado exitosamente.');

        } catch (\Exception $e) {
            DB::rollBack();
            return back()->withInput()->with('error', 'Error al crear usuario: ' . $e->getMessage());
        }
    }
}