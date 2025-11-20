<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Usuario;
use App\Models\Receta;
use Illuminate\Support\Facades\DB;

class DashboardController extends Controller
{
    public function index()
    {
        // 1. Estadísticas de Usuarios
        $totalUsuarios = Usuario::count();
        $usuariosActivos = Usuario::where('estado', true)->count();

        // 2. Estadísticas de Recetas (Lógica Personalizada)
        $recetasPublicadas = Receta::whereHas('estado', function($q) {
            $q->where('descripcion', 'BORRADOR');
        })->count();

        $recetasPendientes = Receta::whereHas('estado', function($q) {
            $q->whereRaw('UPPER(descripcion) = ?', ['PENDIENTE']);
        })->count();

        $recetasRechazadas = Receta::whereHas('estado', function($q) {
            $q->where('descripcion', 'OCULTA');
        })->count();

        // 3. Recetas Recientes
        $ultimasRecetas = Receta::with(['creador', 'estado'])
                                ->latest()
                                ->take(5)
                                ->get();

        // CAMBIO AQUÍ: Nueva ruta de la vista
        return view('admin.dashboard.dashboard', compact(
            'totalUsuarios',
            'usuariosActivos',
            'recetasPublicadas',
            'recetasPendientes',
            'recetasRechazadas',
            'ultimasRecetas'
        ));
    }
}