<?php

namespace App\Http\Controllers\API;

use App\Http\Controllers\Controller;
use App\Models\Receta;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;

class RecetaController extends Controller
{
    /**
     * Obtener lista de recetas
     */
    public function index(Request $request)
    {
        try {
            $query = Receta::query();

            // Filtrar por creador o mostrar solo publicadas
            if ($request->has('id_usuario_creador')) {
                $query->where('id_usuario_creador', $request->input('id_usuario_creador'));
            } else {
                $query->where('id_estado', 2); // 2 = Publicada (Ajusta según tu BD)
            }

            $recetas = $query->with([
                'estado', 
                'tipoAlimento', 
                'multimedia' => function($q) {
                    $q->orderBy('orden', 'asc');
                }
            ])
            ->orderBy('created_at', 'desc')
            ->get();

            // Procesar imágenes
            $recetas->map(function($receta) {
                $receta->imagen_url = $this->getImagenUrl($receta->id);
                return $receta;
            });

            return response()->json($recetas, 200);

        } catch (\Exception $e) {
            return response()->json(['error' => 'Error al cargar recetas: ' . $e->getMessage()], 500);
        }
    }

    /**
     * Crear receta (POST)
     */
    public function store(Request $request)
    {
        DB::beginTransaction();
        try {
            // Validación
            $request->validate([
                'id_usuario_creador' => 'required|integer',
                'titulo'             => 'required|string|max:200',
                'preparacion'        => 'required|string',
            ]);

            $receta = new Receta();
            $receta->fill($request->only([
                'id_usuario_creador', 'titulo', 'resumen', 
                'preparacion', 'tiempo_preparacion', 'porciones_estimadas'
            ]));
            
            // Valores por defecto
            $receta->id_estado = $request->id_estado ?? 1; // 1 = Borrador
            $receta->id_tipo_alimento = $request->id_tipo_alimento ?? 1;
            
            $receta->save();

            // Guardar Imagen
            $this->guardarImagen($request, $receta->id);

            DB::commit();
            
            // Respuesta
            $receta->load('estado', 'tipoAlimento');
            $receta->imagen_url = $this->getImagenUrl($receta->id);
            
            return response()->json($receta, 201);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => 'Error al guardar: ' . $e->getMessage()], 500);
        }
    }

    /**
     * Ver detalle (GET)
     */
    public function show($id)
    {
        try {
            $receta = Receta::with([
                'estado', 'tipoAlimento', 'ingredientesReceta.ingrediente', 
                'ingredientesReceta.unidadMedida', 'multimedia'
            ])->find($id);

            if (!$receta) return response()->json(['message' => 'No encontrada'], 404);

            $receta->imagen_url = $this->getImagenUrl($receta->id);

            return response()->json($receta, 200);

        } catch (\Exception $e) {
            return response()->json(['error' => $e->getMessage()], 500);
        }
    }

    /**
     * Actualizar receta (PUT/POST)
     */
    public function update(Request $request, $id)
    {
        DB::beginTransaction();
        try {
            $receta = Receta::find($id);
            if (!$receta) return response()->json(['message' => 'No encontrada'], 404);

            $receta->fill($request->only([
                'titulo', 'resumen', 'preparacion', 
                'tiempo_preparacion', 'porciones_estimadas', 'id_estado', 'id_tipo_alimento'
            ]));
            
            $receta->save();

            // Actualizar imagen
            if ($request->hasFile('imagen') || $request->has('imagen_url')) {
                DB::table('multimedia_recetas')->where('id_receta', $id)->delete();
                $this->guardarImagen($request, $id);
            }

            DB::commit();
            
            $receta->imagen_url = $this->getImagenUrl($receta->id);
            return response()->json($receta, 200);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => 'Error al actualizar: ' . $e->getMessage()], 500);
        }
    }

    /**
     * Eliminar receta (DELETE)
     */
    public function destroy($id)
    {
        DB::beginTransaction();
        try {
            $receta = Receta::find($id);
            if (!$receta) return response()->json(['message' => 'No encontrada'], 404);

            DB::table('multimedia_recetas')->where('id_receta', $id)->delete();
            $receta->delete();

            DB::commit();
            return response()->json(['message' => 'Eliminada'], 200);

        } catch (\Exception $e) {
            DB::rollBack();
            return response()->json(['error' => 'Error al eliminar: ' . $e->getMessage()], 500);
        }
    }

    // ==========================================
    // HELPERS SIMPLIFICADOS (TEXTO PLANO)
    // ==========================================

    private function getImagenUrl($recetaId)
    {
        // ✅ CORRECCIÓN: Seleccionamos 'archivo' directamente.
        // Quitamos "encode(...)" porque la columna ya es texto en tu BD.
        $multimedia = DB::table('multimedia_recetas')
                        ->where('id_receta', $recetaId)
                        ->orderBy('orden', 'asc')
                        ->first();
        
        if (!$multimedia) return null;

        $pathOrUrl = $multimedia->archivo;

        // Si es URL externa, devolver tal cual
        if (filter_var($pathOrUrl, FILTER_VALIDATE_URL)) {
            return $pathOrUrl;
        }

        // Si es local, generar URL pública
        return Storage::disk('public')->url($pathOrUrl);
    }

    private function guardarImagen(Request $request, $recetaId)
    {
        $path = null;
        $tipo = 'image/jpeg';

        if ($request->hasFile('imagen')) {
            $path = $request->file('imagen')->store('recetas', 'public');
        } 
        elseif ($request->has('imagen_url')) {
            $path = $request->input('imagen_url');
            $tipo = 'image/url';
        }

        if ($path) {
            // ✅ CORRECCIÓN: Insertamos el string directamente.
            // Eliminamos "convert_to(...)"
            DB::table('multimedia_recetas')->insert([
                'id_receta'    => $recetaId,
                'archivo'      => $path,
                'tipo_archivo' => $tipo,
                'orden'        => 1,
                'created_at'   => now(),
                'updated_at'   => now()
            ]);
        }
    }
}