<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Receta;
use App\Models\Subdominio;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class RecetaController extends Controller
{
    public function index(Request $request)
    {
        $query = Receta::with(['creador', 'estado', 'tipoAlimento', 'multimedia']);

        // Filtro de búsqueda
        if ($request->filled('search')) {
            $search = $request->search;
            $query->where(function($q) use ($search) {
                $q->where('titulo', 'ilike', "%{$search}%")
                  ->orWhereHas('creador', function($q2) use ($search) {
                      $q2->where('name', 'ilike', "%{$search}%");
                  });
            });
        }

        // Filtro de estado (TU LÓGICA PERSONALIZADA)
        if ($request->filled('estado')) {
            $estadoFiltro = $request->estado;
            $query->whereHas('estado', function($q) use ($estadoFiltro) {
                if ($estadoFiltro === 'aprobada') {
                    $q->where('descripcion', 'BORRADOR');
                } elseif ($estadoFiltro === 'pendiente') {
                    $q->whereRaw('UPPER(descripcion) = ?', ['PENDIENTE']);
                } elseif ($estadoFiltro === 'rechazada') {
                    $q->where('descripcion', 'OCULTA');
                }
            });
        }

        $recetas = $query->orderBy('created_at', 'desc')->paginate(10);

        // Conteo de Pendientes (TU LÓGICA: Buscar 'PENDIENTE')
        $pendientesCount = Receta::whereHas('estado', function($q) {
            $q->whereRaw('UPPER(descripcion) = ?', ['PENDIENTE']);
        })->count(); 

        return view('admin.recetas.index', compact('recetas', 'pendientesCount'));
    }

    public function show($id)
    {
        // Carga 'ingredientesReceta.ingrediente' para el detalle completo
        $receta = Receta::with(['creador', 'estado', 'tipoAlimento', 'ingredientesReceta.ingrediente', 'multimedia'])->findOrFail($id);        
        return view('admin.recetas.show', compact('receta'));
    }

    public function edit($id)
    {
        $receta = Receta::findOrFail($id);
        return view('admin.recetas.edit', compact('receta'));
    }

    public function update(Request $request, $id)
    {
        $request->validate([
            'titulo' => 'required|string|max:200',
            'resumen' => 'nullable|string',
            'tiempo_preparacion' => 'required|integer',
            'porciones_estimadas' => 'required|integer',
            'preparacion' => 'required|string',
        ]);

        $receta = Receta::findOrFail($id);
        $receta->update($request->all());

        return redirect()->route('admin.recetas.index')
                         ->with('success', 'Receta actualizada correctamente.');
    }

    public function destroy($id)
    {
        $receta = Receta::findOrFail($id);
        $receta->delete();

        return redirect()->route('admin.recetas.index')
                         ->with('success', 'La receta ha sido eliminada correctamente.');
    }

    // Lógica personalizada para Aprobar (Borrador)
    public function approve($id)
    {
        $receta = Receta::findOrFail($id);
        
        $estadoBorrador = DB::table('subdominios')
            ->join('dominios', 'subdominios.id_dominio', '=', 'dominios.id')
            ->where('dominios.descripcion', 'ESTADO_RECETA') // Ajusta a 'ESTADO' si tu BD lo tiene así
            ->where('subdominios.descripcion', 'BORRADOR')
            ->value('subdominios.id');
        
        $receta->update(['id_estado' => $estadoBorrador]);

        return redirect()->back()->with('success', 'La receta ha sido aprobada correctamente.');
    }

    // Lógica personalizada para Rechazar (Oculta)
    public function reject($id)
    {
        $receta = Receta::findOrFail($id);
        
        $estadoOculta = DB::table('subdominios')
            ->join('dominios', 'subdominios.id_dominio', '=', 'dominios.id')
            ->where('dominios.descripcion', 'ESTADO_RECETA') 
            ->where('subdominios.descripcion', 'OCULTA')
            ->value('subdominios.id');
        
        $receta->update(['id_estado' => $estadoOculta]);

        return redirect()->back()->with('success', 'La receta ha sido rechazada.');
    }
}