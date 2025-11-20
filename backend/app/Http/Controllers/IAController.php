<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\DB;

class IAController extends Controller
{
    public function identificar(Request $request)
    {
        // 1. Validación
        $request->validate([
            'imagen' => 'required|image|mimes:jpeg,png,jpg|max:10240',
        ]);

        $imagen = $request->file('imagen');
        $stream = fopen($imagen->getRealPath(), 'r');

        try {
            // 2. Enviar a Python (YOLO)
            $response = Http::attach(
                'file', 
                $stream, 
                $imagen->getClientOriginalName()
            )->post('http://host.docker.internal:5000/detectar');

            if (!$response->successful()) {
                return response()->json([
                    'success' => false, 
                    'error' => 'La IA falló.', 
                    'detalle' => $response->body()
                ], 500);
            }

            // 3. Procesar y Traducir la respuesta
            $rawData = $response->json();
            
            if (!isset($rawData['data'])) {
                return response()->json($rawData);
            }

            $ingredientesTraducidos = [];

            foreach ($rawData['data'] as $item) {
                $nombreIngles = $item['ingrediente']; // Ej: "baseball bat"

                // BUSCAR EN LA BDD
                $ingredienteBD = DB::table('ingredientes')
                                    ->where('yolo_key', $nombreIngles)
                                    ->first();

                // --- FILTRO DE SEGURIDAD ---
                // Si la base de datos NO tiene registrado este 'yolo_key',
                // significa que es un objeto basura (bate, persona, etc.) -> LO IGNORAMOS.
                if (!$ingredienteBD) {
                    continue; // Salta a la siguiente iteración del bucle
                }

                // Si llegamos aquí, es un ingrediente válido de tu sistema
                $ingredientesTraducidos[] = [
                    'nombre_original' => $nombreIngles,
                    'nombre' => $ingredienteBD->descripcion, // Ej: "Manzana"
                    'cantidad' => $item['cantidad'],
                    'unidad' => $item['unidad_estimada']
                ];
            }

            return response()->json([
                'success' => true,
                'ingredientes' => $ingredientesTraducidos
            ]);

        } catch (\Exception $e) {
            return response()->json(['success' => false, 'error' => $e->getMessage()], 500);
        }
    }


     public function buscarPorIngredientes(Request $request)
    {
        // 1. Validación: Esperamos un array de textos (ej: ["Manzana", "Zanahoria"])
        $request->validate([
            'ingredientes' => 'required|array',
            'ingredientes.*' => 'string'
        ]);

        $nombresIngredientes = $request->input('ingredientes');

        // 2. Obtener los IDs de esos ingredientes en tu BDD
        $idsIngredientes = DB::table('ingredientes')
            ->whereIn('descripcion', $nombresIngredientes)
            ->pluck('id');

        if ($idsIngredientes->isEmpty()) {
            return response()->json([
                'success' => true,
                'mensaje' => 'No se encontraron recetas con esos ingredientes.',
                'recetas' => []
            ]);
        }

        // 3. CONSULTA INTELIGENTE (RANKING)
        // - Hacemos JOIN con la tabla pivot.
        // - Filtramos solo las recetas que tengan AL MENOS UNO de los ingredientes.
        // - Agrupamos por receta.
        // - COUNT: Contamos cuántos ingredientes coincidieron.
        // - ORDER BY DESC: Las que tengan más coincidencias van primero.
        
        $recetas = DB::table('recetas')
            ->join('ingrediente_receta', 'recetas.id', '=', 'ingrediente_receta.id_receta')
            ->whereIn('ingrediente_receta.id_ingrediente', $idsIngredientes)
            ->select(
                'recetas.id',
                'recetas.titulo',
                'recetas.resumen',
                'recetas.tiempo_preparacion',
                'recetas.porciones_estimadas',
                // Esta línea mágica cuenta los aciertos
                DB::raw('COUNT(ingrediente_receta.id_ingrediente) as coincidencias_count')
            )
            ->groupBy(
                'recetas.id', 
                'recetas.titulo', 
                'recetas.resumen', 
                'recetas.tiempo_preparacion', 
                'recetas.porciones_estimadas'
            )
            ->orderByDesc('coincidencias_count') // <--- AQUÍ ESTÁ EL ORDENAMIENTO
            ->get();

        // 4. Enriquecer con Imagen y Detalles visuales
        foreach ($recetas as $receta) {
            // Buscar imagen principal
            $imagen = DB::table('multimedia_recetas')
                ->where('id_receta', $receta->id)
                ->orderBy('orden', 'asc')
                ->value('archivo');
            
            $receta->imagen = $imagen ?? 'https://via.placeholder.com/300?text=Sin+Imagen';

            // Buscar qué ingredientes faltan vs cuáles tiene (Opcional, pero útil para el frontend)
            // Aquí simplemente listamos los nombres de los ingredientes que SÍ tiene la receta y coincidieron
            $ingredientesMatch = DB::table('ingredientes')
                ->join('ingrediente_receta', 'ingredientes.id', '=', 'ingrediente_receta.id_ingrediente')
                ->where('ingrediente_receta.id_receta', $receta->id)
                ->whereIn('ingredientes.id', $idsIngredientes)
                ->pluck('descripcion');

            $receta->ingredientes_coincidentes = $ingredientesMatch;
        }

        return response()->json([
            'success' => true,
            'cantidad_resultados' => count($recetas),
            'recetas' => $recetas
        ]);
    }

    /**
     * Obtiene el listado completo de ingredientes para el buscador manual.
     */
    public function listarIngredientes()
    {
        try {
            // Ordenamos alfabéticamente para que sea fácil buscar en el frontend
            $ingredientes = DB::table('ingredientes')
                ->select('id', 'descripcion')
                ->orderBy('descripcion', 'asc')
                ->get();

            return response()->json([
                'success' => true,
                'data' => $ingredientes
            ]);

        } catch (\Exception $e) {
            return response()->json(['success' => false, 'error' => $e->getMessage()], 500);
        }
    }

    /**
     * Obtiene las unidades de medida (id_dominio = 5 según tu captura).
     */
    public function listarUnidades()
    {
        try {
            // Filtramos por el dominio 5 que es UNIDAD_MEDIDA
            $unidades = DB::table('subdominios')
                ->where('id_dominio', 5)
                ->select('id', 'descripcion')
                ->orderBy('id', 'asc')
                ->get();

            return response()->json([
                'success' => true,
                'data' => $unidades
            ]);

        } catch (\Exception $e) {
            return response()->json(['success' => false, 'error' => $e->getMessage()], 500);
        }
    }
}