<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;

class IAController extends Controller
{
    public function identificar(Request $request)
    {
        // 1. Validación: Que sí o sí llegue una imagen
        $request->validate([
            'imagen' => 'required|image|mimes:jpeg,png,jpg|max:10240', // Max 10MB
        ]);

        // 2. Preparamos el archivo
        $imagen = $request->file('imagen');
        
        // Abrimos el flujo de datos (stream) para enviarlo sin guardarlo en disco si no queremos
        $stream = fopen($imagen->getRealPath(), 'r');

        try {
            // 3. EL SALTO DE FE: Docker -> Windows
            // 'host.docker.internal' es la IP mágica que apunta a tu PC anfitriona
            // El puerto 5000 es donde está corriendo tu script de Python
            $response = Http::attach(
                'file', 
                $stream, 
                $imagen->getClientOriginalName()
            )->post('http://host.docker.internal:5000/detectar');

            // 4. Respuesta
            if ($response->successful()) {
                return response()->json($response->json());
            } else {
                return response()->json([
                    'success' => false,
                    'error' => 'La IA respondió con error',
                    'detalle' => $response->body()
                ], 500);
            }

        } catch (\Exception $e) {
            return response()->json([
                'success' => false,
                'error' => 'No se pudo conectar con el motor de IA',
                'mensaje' => $e->getMessage()
            ], 500);
        }
    }
}