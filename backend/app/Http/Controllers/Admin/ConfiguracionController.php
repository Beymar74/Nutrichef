<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Dominio;
use App\Models\Subdominio;
use Illuminate\Http\Request;

class ConfiguracionController extends Controller
{
    public function index()
    {
        // Cargar todos los dominios con sus subdominios
        $dominios = Dominio::with('subdominios')->get();
        return view('admin.configuracion.index', compact('dominios'));
    }

    public function storeSubdominio(Request $request)
    {
        $request->validate([
            'id_dominio' => 'required|exists:dominios,id',
            'descripcion' => 'required|string|max:100',
        ]);

        Subdominio::create([
            'id_dominio' => $request->id_dominio,
            'descripcion' => strtoupper($request->descripcion), // Guardar en mayúsculas por convención
        ]);

        return back()->with('success', 'Opción agregada correctamente.');
    }

    public function destroySubdominio($id)
    {
        $subdominio = Subdominio::findOrFail($id);
        $subdominio->delete();
        return back()->with('success', 'Opción eliminada.');
    }
}