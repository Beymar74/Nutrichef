<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\SolicitudChef;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

class SolicitudChefController extends Controller
{
    /**
     * Enviar solicitud para ser chef
     */
    public function store(Request $request)
    {
        $request->validate([
            'motivo' => 'required|string|min:20|max:500',
            'experiencia' => 'nullable|string|max:300',
        ]);

        $usuario = Auth::user();

        // Verificar si ya tiene una solicitud pendiente
        $solicitudPendiente = SolicitudChef::where('id_usuario', $usuario->id)
            ->whereHas('estado', function($q) {
                $q->whereRaw('UPPER(descripcion) = ?', ['PENDIENTE']);
            })
            ->exists();

        if ($solicitudPendiente) {
            return response()->json([
                'success' => false,
                'message' => 'Ya tienes una solicitud pendiente de revisión',
            ], 400);
        }

        // Verificar si ya es chef
        if ($usuario->rol && strtolower($usuario->rol->descripcion) === 'chef') {
            return response()->json([
                'success' => false,
                'message' => 'Ya eres chef',
            ], 400);
        }

        // Obtener ID del estado PENDIENTE
        $estadoPendiente = DB::table('subdominios')
            ->join('dominios', 'subdominios.id_dominio', '=', 'dominios.id')
            ->where('dominios.descripcion', 'ESTADO_SOLICITUD')
            ->where('subdominios.descripcion', 'PENDIENTE')
            ->value('subdominios.id');

        if (!$estadoPendiente) {
            return response()->json([
                'success' => false,
                'message' => 'Error en la configuración del sistema. Contacta al administrador.',
            ], 500);
        }

        // Crear solicitud
        $solicitud = SolicitudChef::create([
            'id_usuario' => $usuario->id,
            'motivo' => $request->motivo,
            'experiencia' => $request->experiencia,
            'id_estado' => $estadoPendiente,
        ]);

        return response()->json([
            'success' => true,
            'message' => 'Solicitud enviada correctamente',
            'data' => [
                'id' => $solicitud->id,
                'estado' => 'PENDIENTE',
                'fecha' => $solicitud->created_at->format('Y-m-d H:i:s'),
            ]
        ], 201);
    }

    /**
     * Ver mis solicitudes enviadas
     */
    public function misSolicitudes()
    {
        $usuario = Auth::user();

        $solicitudes = SolicitudChef::with(['estado', 'revisor'])
            ->where('id_usuario', $usuario->id)
            ->orderBy('created_at', 'desc')
            ->get()
            ->map(function($sol) {
                return [
                    'id' => $sol->id,
                    'motivo' => $sol->motivo,
                    'experiencia' => $sol->experiencia,
                    'estado' => $sol->estado->descripcion ?? 'DESCONOCIDO',
                    'comentario_admin' => $sol->comentario_admin,
                    'fecha_solicitud' => $sol->created_at->format('Y-m-d H:i:s'),
                    'fecha_revision' => $sol->fecha_revision?->format('Y-m-d H:i:s'),
                    'revisado_por' => $sol->revisor?->name,
                ];
            });

        return response()->json([
            'success' => true,
            'data' => $solicitudes
        ]);
    }
}