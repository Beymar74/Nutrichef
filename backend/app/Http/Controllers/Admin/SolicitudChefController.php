<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\SolicitudChef;
use App\Models\Usuario;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Auth;

class SolicitudChefController extends Controller
{
    /**
     * Listado de solicitudes con filtros
     */
    public function index(Request $request)
    {
        $query = SolicitudChef::with(['usuario', 'estado', 'revisor']);

        // Búsqueda por nombre o email del usuario
        if ($request->filled('search')) {
            $search = $request->search;
            $query->whereHas('usuario', function($q) use ($search) {
                $q->where('name', 'ilike', "%{$search}%")
                  ->orWhere('email', 'ilike', "%{$search}%");
            });
        }

        // Filtro por estado
        if ($request->filled('estado')) {
            $estadoFiltro = strtoupper($request->estado);
            $query->whereHas('estado', function($q) use ($estadoFiltro) {
                $q->whereRaw('UPPER(descripcion) = ?', [$estadoFiltro]);
            });
        }

        $solicitudes = $query->orderBy('created_at', 'desc')->paginate(10);

        // Conteo de pendientes para badge
        $pendientesCount = SolicitudChef::pendientes()->count();

        return view('admin.solicitudes-chef.index', compact('solicitudes', 'pendientesCount'));
    }

    /**
     * Detalle de una solicitud
     */
    public function show($id)
    {
        $solicitud = SolicitudChef::with(['usuario', 'estado', 'revisor'])->findOrFail($id);
        return view('admin.solicitudes-chef.show', compact('solicitud'));
    }

    /**
     * Aprobar solicitud y cambiar rol a Chef
     */
    public function approve(Request $request, $id)
    {
        $solicitud = SolicitudChef::findOrFail($id);
        
        DB::beginTransaction();
        try {
            // 1. Obtener ID del estado APROBADA
            $estadoAprobada = DB::table('subdominios')
                ->join('dominios', 'subdominios.id_dominio', '=', 'dominios.id')
                ->where('dominios.descripcion', 'ESTADO_SOLICITUD')
                ->where('subdominios.descripcion', 'APROBADA')
                ->value('subdominios.id');

            if (!$estadoAprobada) {
                throw new \Exception('No se encontró el estado APROBADA en la base de datos');
            }

            // 2. Obtener ID del rol CHEF desde la tabla roles
            $rolChef = DB::table('roles')
                ->where('descripcion', 'chef')
                ->value('id');

            if (!$rolChef) {
                throw new \Exception('No se encontró el rol CHEF en la base de datos');
            }

            // 3. Actualizar solicitud
            $solicitud->update([
                'id_estado' => $estadoAprobada,
                'revisado_por' => Auth::id(),
                'fecha_revision' => now(),
                'comentario_admin' => $request->comentario_admin ?? 'Solicitud aprobada',
            ]);

            // 4. Cambiar rol del usuario a CHEF
            $usuario = Usuario::findOrFail($solicitud->id_usuario);
            $usuario->update(['id_rol' => $rolChef]);

            DB::commit();

            // ✅ Redirige a la misma página (show) con mensaje de éxito
            return redirect()->route('admin.solicitudes.show', $id)
                           ->with('success', '¡Solicitud aprobada! El usuario ahora es Chef.');

        } catch (\Exception $e) {
            DB::rollBack();
            return redirect()->back()->with('error', 'Error al aprobar: ' . $e->getMessage());
        }
    }

    /**
     * Rechazar solicitud
     */
    public function reject(Request $request, $id)
    {
        $request->validate([
            'comentario_admin' => 'required|string|min:10|max:500',
        ], [
            'comentario_admin.required' => 'Debes especificar el motivo del rechazo',
            'comentario_admin.min' => 'El motivo debe tener al menos 10 caracteres',
        ]);

        $solicitud = SolicitudChef::findOrFail($id);
        
        try {
            // Obtener ID del estado RECHAZADA
            $estadoRechazada = DB::table('subdominios')
                ->join('dominios', 'subdominios.id_dominio', '=', 'dominios.id')
                ->where('dominios.descripcion', 'ESTADO_SOLICITUD')
                ->where('subdominios.descripcion', 'RECHAZADA')
                ->value('subdominios.id');

            if (!$estadoRechazada) {
                throw new \Exception('No se encontró el estado RECHAZADA en la base de datos');
            }

            $solicitud->update([
                'id_estado' => $estadoRechazada,
                'revisado_por' => Auth::id(),
                'fecha_revision' => now(),
                'comentario_admin' => $request->comentario_admin,
            ]);

            // ✅ Redirige a la misma página (show) con mensaje de éxito
            return redirect()->route('admin.solicitudes.show', $id)
                           ->with('success', 'Solicitud rechazada correctamente.');

        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Error al rechazar: ' . $e->getMessage());
        }
    }

    /**
     * Eliminar solicitud
     */
    public function destroy($id)
    {
        try {
            $solicitud = SolicitudChef::findOrFail($id);
            $solicitud->delete();

            return redirect()->route('admin.solicitudes.index')
                           ->with('success', 'Solicitud eliminada correctamente.');
        } catch (\Exception $e) {
            return redirect()->back()->with('error', 'Error al eliminar: ' . $e->getMessage());
        }
    }
}