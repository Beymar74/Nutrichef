<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\PerfilController;
use App\Http\Controllers\Api\RecetaController;
use App\Http\Controllers\Auth\PasswordResetController;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Api\PublicacionController;
use App\Http\Controllers\Api\ComentarioController;

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

// Rutas protegidas
Route::middleware('auth:sanctum')->group(function () {
    // Rutas de usuario y perfil
    Route::put('/usuario/perfil', [AuthController::class, 'actualizarPerfil']);
    Route::put('/perfil/dieta', [PerfilController::class, 'actualizarDieta']);
    Route::put('/perfil/nivel-cocina', [PerfilController::class, 'actualizarNivelCocina']);
    Route::put('/perfil/alergias', [PerfilController::class, 'actualizarAlergias']);

    // Rutas para publicaciones
    Route::get('/publicaciones', [PublicacionController::class, 'index']);  // Obtener todas las publicaciones
    Route::get('/publicaciones/{id}', [PublicacionController::class, 'show']);  // Obtener publicación por ID
    Route::post('/publicaciones', [PublicacionController::class, 'store']);  // Crear nueva publicación
    Route::put('/publicaciones/{id}', [PublicacionController::class, 'update']);  // Editar publicación
    Route::delete('/publicaciones/{id}', [PublicacionController::class, 'destroy']);  // Eliminar publicación

    // Rutas para comentarios
    Route::post('/publicaciones/{id}/comentarios', [ComentarioController::class, 'store']);  // Agregar comentario
    Route::get('/publicaciones/{id}/comentarios', [ComentarioController::class, 'index']);  // Obtener comentarios de una publicación
});

// Rutas públicas (accesibles sin autenticación)
Route::get('/recetas', [RecetaController::class, 'index']);
Route::get('/recetas/{id}', [RecetaController::class, 'show']);

// Recuperación de contraseña
Route::post('/recuperar-password/enviar-codigo', [PasswordResetController::class, 'enviarCodigo']);
Route::post('/recuperar-password/verificar-codigo', [PasswordResetController::class, 'verificarCodigo']);
Route::post('/recuperar-password/cambiar', [PasswordResetController::class, 'cambiarPassword']);
