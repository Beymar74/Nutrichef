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
            // 2. Obtener URL de IA desde .env (con fallback)
            $aiUrl = env('AI_URL', 'http://nutrichef_ai:5000');
            
            // 3. Enviar a Python (YOLO + OCR) con timeout apropiado
            $response = Http::timeout(60) // 60 segundos para procesamiento de IA
                ->attach(
                    'file', 
                    $stream, 
                    $imagen->getClientOriginalName()
                )
                ->post($aiUrl . '/detectar');

            if (!$response->successful()) {
                return response()->json([
                    'success' => false, 
                    'error' => 'La IA falló.', 
                    'detalle' => $response->body()
                ], 500);
            }

            // 4. Obtener respuesta cruda (Ahora tiene 'visual' y 'etiquetas')
            $rawData = $response->json();
            
            // Validación de estructura nueva
            if (!isset($rawData['data']) || !isset($rawData['data']['visual'])) {
                // Fallback por si acaso el script de python viejo sigue corriendo
                return response()->json($rawData);
            }

            $ingredientesTraducidos = [];
            $idsDetectados = []; // Para evitar duplicados exactos si YOLO y OCR encuentran lo mismo

            // ==========================================
            // PARTE A: PROCESAMIENTO VISUAL (YOLO)
            // ==========================================
            foreach ($rawData['data']['visual'] as $item) {
                $nombreIngles = $item['ingrediente']; 

                $ingredienteBD = DB::table('ingredientes')
                                    ->where('yolo_key', $nombreIngles)
                                    ->first();

                if ($ingredienteBD) {
                    $ingredientesTraducidos[] = [
                        'nombre_original' => $nombreIngles, // Ej: "bottle"
                        'nombre' => $ingredienteBD->descripcion, // Ej: "Aceite"
                        'cantidad' => $item['cantidad'],
                        'unidad' => $item['unidad_estimada']
                    ];
                    $idsDetectados[] = $ingredienteBD->id;
                }
            }

            // ==========================================
            // PARTE B: PROCESAMIENTO DE TEXTO (OCR)
            // ==========================================
            // Traemos todos los alias de la BDD para comparar (optimización de consulta)
            $aliasBDD = DB::table('nombres_comerciales')
                          ->join('ingredientes', 'nombres_comerciales.id_ingrediente', '=', 'ingredientes.id')
                          ->select('nombres_comerciales.nombre_comercial', 'ingredientes.descripcion', 'ingredientes.id as id_real')
                          ->get();

            $etiquetasLeidas = $rawData['data']['etiquetas'] ?? [];

            foreach ($etiquetasLeidas as $textoOcr) {
                // Convertimos lo leído a minúsculas por seguridad (aunque Python ya lo hace)
                $textoOcr = strtolower($textoOcr); 

                foreach ($aliasBDD as $alias) {
                    $nombreMarca = $alias->nombre_comercial; // Ya está en minúsculas en BDD

                    // LÓGICA DE COINCIDENCIA (MATCHING)
                    $esMatch = false;

                    // 1. Coincidencia de subcadena (Ej: "peso neto arroz grano de oro" contiene "grano de oro")
                    if (str_contains($textoOcr, $nombreMarca)) {
                        $esMatch = true;
                    } 
                    // 2. Coincidencia Fuzzy del 75% (Ej: "grno de oro" vs "grano de oro")
                    else {
                        $porcentaje = 0;
                        similar_text($textoOcr, $nombreMarca, $porcentaje);
                        if ($porcentaje >= 75) {
                            $esMatch = true;
                        }
                    }

                    // Si hubo match y no hemos agregado este ingrediente EXACTO en este ciclo de OCR (opcional: o de YOLO)
                    // Nota: Aquí permito que se repita si YOLO lo vio y OCR también, para reforzar la detección.
                    // Si prefieres que no se repita nunca, usa in_array($alias->id_real, $idsDetectados)
                    if ($esMatch) {
                        
                        // Verificar si ya agregamos este mismo ingrediente por OCR en esta petición para no repetir 
                        // "Arroz" 5 veces porque la etiqueta dice "Grano de oro" 5 veces.
                        $yaEstaEnLista = false;
                        foreach($ingredientesTraducidos as $ing){
                            if($ing['nombre'] === $alias->descripcion && $ing['nombre_original'] === 'detectado_por_texto'){
                                $yaEstaEnLista = true;
                                break;
                            }
                        }

                        if(!$yaEstaEnLista){
                            $ingredientesTraducidos[] = [
                                'nombre_original' => 'Etiqueta: ' . $textoOcr, // Para que sepas de dónde vino
                                'nombre' => $alias->descripcion, // Ej: "Arroz" (El nombre real)
                                'cantidad' => 1,
                                'unidad' => 'unidad(es)'
                            ];
                            // Rompemos el bucle de alias para este texto OCR, ya encontramos qué es.
                            break; 
                        }
                    }
                }
            }

            // ==========================================
            // RESPUESTA FINAL (FORMATO ORIGINAL)
            // ==========================================
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