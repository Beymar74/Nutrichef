<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use App\Models\User;

class SeguidoresController extends Controller
{
    // POST /api/seguidores/toggle
    public function toggle(Request $request)
    {
        $request->validate([
            'id_usuario' => 'required|integer', // El usuario logueado (quien da click)
            'id_usuario_seguido' => 'required|integer', // El chef
        ]);

        $usuarioId = $request->id_usuario;
        $chefId = $request->id_usuario_seguido;

        // Verificar si ya existe el registro en la tabla 'seguidores'
        // (Según tu DiccionarioDatos.pdf la tabla es 'seguidores')
        $existente = DB::table('seguidores')
            ->where('id_usuario', $usuarioId)
            ->where('id_usuario_seguido', $chefId)
            ->first();

        if ($existente) {
            // SI YA EXISTE -> DEJAR DE SEGUIR (Borrar)
            DB::table('seguidores')
                ->where('id', $existente->id)
                ->delete();
                
            return response()->json([
                'siguiendo' => false,
                'mensaje' => 'Dejaste de seguir al usuario.'
            ]);
        } else {
            // NO EXISTE -> SEGUIR (Crear)
            DB::table('seguidores')->insert([
                'id_usuario' => $usuarioId,
                'id_usuario_seguido' => $chefId,
                'created_at' => now(),
                'updated_at' => now(),
            ]);

            return response()->json([
                'siguiendo' => true,
                'mensaje' => '¡Ahora sigues al usuario!'
            ]);
        }
    }

    // GET /api/seguidores/status?id_usuario=X&id_usuario_seguido=Y
    public function checkStatus(Request $request)
    {
        $usuarioId = $request->query('id_usuario');
        $chefId = $request->query('id_usuario_seguido');

        $existe = DB::table('seguidores')
            ->where('id_usuario', $usuarioId)
            ->where('id_usuario_seguido', $chefId)
            ->exists();

        return response()->json(['siguiendo' => $existe]);
    }
}