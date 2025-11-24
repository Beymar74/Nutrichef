<?php

namespace App\Http\Controllers\Api;

use App\Models\Publicacion;
use Illuminate\Http\Request;
use App\Http\Controllers\Controller;

class PublicacionController extends Controller
{
    // Método para obtener las publicaciones
    public function index()
    {
        // Obtén todas las publicaciones
        $publicaciones = Publicacion::all();

        // Devolvemos las publicaciones en formato JSON
        return response()->json([
            'success' => true,
            'data' => $publicaciones
        ]);
    }
}
