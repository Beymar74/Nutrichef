<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\PerfilController;
use App\Http\Controllers\Api\RecetaController;
use App\Http\Controllers\Api\PublicacionController;
use App\Http\Controllers\Auth\PasswordResetController;
use App\Http\Controllers\IAController;
use Illuminate\Support\Facades\DB;

// ========================================
// RUTAS PÚBLICAS (sin autenticación)
// ========================================

Route::get('/test', function () {
    return response()->json([
        'message'        => 'API Nutrichef funcionando correctamente',
        'database'       => DB::connection()->getDatabaseName(),
        'usuarios_count' => DB::table('usuarios')->count(),
        'timestamp'      => now()
    ]);
});

// Autenticación
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login',    [AuthController::class, 'login']);

// Recuperación de contraseña
Route::post('/recuperar-password/enviar-codigo',    [PasswordResetController::class, 'enviarCodigo']);
Route::post('/recuperar-password/verificar-codigo', [PasswordResetController::class, 'verificarCodigo']);
Route::post('/recuperar-password/cambiar',          [PasswordResetController::class, 'cambiarPassword']);

// Recetas (públicas)
Route::get('/recetas',      [RecetaController::class, 'index']);
Route::get('/recetas/{id}', [RecetaController::class, 'show']);

// IA
Route::post('/identificar-ingredientes', [IAController::class, 'identificar']);
Route::post('/buscar-recetas', [IAController::class, 'buscarPorIngredientes']);
Route::get('/ingredientes/listar', [IAController::class, 'listarIngredientes']);
Route::get('/unidades/listar', [IAController::class, 'listarUnidades']);

// Publicaciones (públicas - solo lectura)
Route::get('/publicaciones', [PublicacionController::class, 'index']);
Route::get('/publicaciones/{id}', [PublicacionController::class, 'show']);
Route::get('/publicaciones/{id}/comentarios', [PublicacionController::class, 'obtenerComentarios']);

// ========================================
// RUTAS PROTEGIDAS (requieren autenticación)
// ========================================

Route::middleware('auth:sanctum')->group(function () {
    
    // Perfil de usuario
    Route::put('/usuario/perfil',      [AuthController::class, 'actualizarPerfil']);
    Route::put('/perfil/dieta',        [PerfilController::class, 'actualizarDieta']);
    Route::put('/perfil/nivel-cocina', [PerfilController::class, 'actualizarNivelCocina']);
    Route::put('/perfil/alergias',     [PerfilController::class, 'actualizarAlergias']);
    
    // Publicaciones (crear, editar, eliminar)
    Route::post('/publicaciones', [PublicacionController::class, 'store']);
    Route::put('/publicaciones/{id}', [PublicacionController::class, 'update']);
    Route::delete('/publicaciones/{id}', [PublicacionController::class, 'eliminarPublicacion']);
    
    // Reacciones
    Route::post('/publicaciones/{id}/reaccion', [PublicacionController::class, 'darReaccion']);
    
    // Comentarios
    Route::post('/publicaciones/{id}/comentarios', [PublicacionController::class, 'agregarComentario']);
    Route::delete('/comentarios/{id}', [PublicacionController::class, 'eliminarComentario']);
    
    // Reportes
    Route::post('/publicaciones/reportar/{id}', [PublicacionController::class, 'reportar']);
});