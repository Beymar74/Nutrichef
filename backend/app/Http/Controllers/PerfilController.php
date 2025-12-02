<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Persona;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Validator;

class PerfilController extends Controller
{
    /**
     * 🧬 Actualizar alergias del usuario (array de IDs de subdominios)
     * Endpoint: PUT /perfil/alergias
     * Body: { "alergias": [44, 48, 51] } o { "alergias": [] } si no tiene
     */
    public function actualizarAlergias(Request $request)
    {
        try {
            $user = $request->user();
            $persona = $user->persona;

            // ✅ Cambio clave: permitir array vacío con 'nullable'
            $validator = Validator::make($request->all(), [
                'alergias'   => 'required|array',          // Debe ser un array (puede estar vacío)
                'alergias.*' => 'nullable|integer|exists:subdominios,id', // ✅ nullable permite []
            ]);

            if ($validator->fails()) {
                return response()->json([
                    "success" => false,
                    "message" => "⚠ Validación fallida",
                    "errors"  => $validator->errors(),
                ], 422);
            }

            $alergias = $request->input('alergias', []); // Default a [] si no viene

            // 🧹 Limpiar alergias anteriores (siempre se ejecuta)
            DB::table('alergia_persona')
                ->where('id_persona', $persona->id)
                ->delete();

            // 🔁 Insertar nuevas alergias (solo si hay alguna)
            if (!empty($alergias)) {
                $now = now();
                $inserts = [];
                
                foreach ($alergias as $idAlergeno) {
                    $inserts[] = [
                        'id_persona'  => $persona->id,
                        'id_alergeno' => $idAlergeno,
                        'created_at'  => $now,
                        'updated_at'  => $now,
                    ];
                }
                
                DB::table('alergia_persona')->insert($inserts);
            }

            $mensaje = empty($alergias) 
                ? "✅ Se eliminaron todas las alergias" 
                : "🌟 Alergias actualizadas correctamente";

            return response()->json([
                "success" => true,
                "message" => $mensaje,
                "total"   => count($alergias),
            ]);

        } catch (\Exception $e) {
            return response()->json([
                "success" => false,
                "message" => "❌ Error interno al guardar alergias",
                "error"   => $e->getMessage(),
            ], 500);
        }
    }

    /**
     * 🍽 Actualizar tipo de dieta (ID de subdominio)
     * Endpoint: PUT /perfil/dieta
     * Body: { "dieta": 32 }
     */
    public function actualizarDieta(Request $request)
    {
        $user = $request->user();
        $persona = $user->persona;

        $validator = Validator::make($request->all(), [
            'dieta' => 'required|integer|exists:subdominios,id',
        ]);

        if ($validator->fails()) {
            return response()->json([
                "success" => false,
                "message" => "⚠ Dieta inválida",
                "errors"  => $validator->errors()
            ], 422);
        }

        $persona->update(['id_dieta' => $request->input('dieta')]);

        return response()->json([
            "success" => true,
            "message" => "🥗 Dieta actualizada correctamente",
            "id_dieta" => $request->input('dieta'),
        ]);
    }

    /**
     * 👨‍🍳 Actualizar nivel de cocina (ID de subdominio)
     * Endpoint: PUT /perfil/nivel-cocina
     * Body: { "nivel_cocina": 42 }
     */
    public function actualizarNivelCocina(Request $request)
    {
        $user = $request->user();
        $persona = $user->persona;

        $validator = Validator::make($request->all(), [
            'nivel_cocina' => 'required|integer|exists:subdominios,id',
        ]);

        if ($validator->fails()) {
            return response()->json([
                "success" => false,
                "message" => "⚠ Nivel de cocina inválido",
                "errors"  => $validator->errors()
            ], 422);
        }

        $persona->update(['id_nivel_cocina' => $request->input('nivel_cocina')]);

        return response()->json([
            "success" => true,
            "message" => "🔪 Nivel de cocina actualizado correctamente",
            "id_nivel_cocina" => $request->input('nivel_cocina'),
        ]);
    }
}