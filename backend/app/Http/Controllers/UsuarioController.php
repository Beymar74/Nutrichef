<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;

class UsuarioController extends Controller
{
    public function actualizarPerfil(Request $request)
    {
        $user = $request->user();  // Usuario autenticado

        $request->validate([
            'name' => 'required|string|max:100',
            'descripcion_perfil' => 'nullable|string',
            'altura' => 'nullable|numeric',
            'peso' => 'nullable|numeric',
        ]);

        // 🟡 Actualiza la tabla usuarios
        $user->update([
            'name' => $request->name,
            'descripcion_perfil' => $request->descripcion_perfil,
        ]);

        // 🟠 Actualiza la tabla personas
        $user->persona?->update([
            'altura' => $request->altura,
            'peso' => $request->peso,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Perfil actualizado correctamente',
            'usuario' => $user->load('persona'),
        ]);
    }
}
