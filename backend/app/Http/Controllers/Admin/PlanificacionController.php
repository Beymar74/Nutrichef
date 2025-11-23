<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\PlanificadorComida; // Importamos el modelo
use Illuminate\Http\Request;

class PlanificacionController extends Controller
{
    public function index()
    {
        // Listar las últimas planificaciones globales para monitoreo
        // Usamos eager loading (with) para optimizar las consultas
        $planificaciones = PlanificadorComida::with(['usuario', 'receta', 'horario'])
                                            ->orderBy('created_at', 'desc')
                                            ->paginate(15);
                                            
        return view('admin.planificacion.index', compact('planificaciones'));
    }
}