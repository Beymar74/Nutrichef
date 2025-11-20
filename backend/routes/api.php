<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\PerfilController;
use App\Http\Controllers\Api\RecetaController;
use App\Http\Controllers\Auth\PasswordResetController;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\IAController;

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
    Route::put('/usuario/perfil',          [AuthController::class, 'actualizarPerfil']);
    Route::put('/perfil/dieta',            [PerfilController::class, 'actualizarDieta']);
    Route::put('/perfil/nivel-cocina',     [PerfilController::class, 'actualizarNivelCocina']);
    Route::put('/perfil/alergias',         [PerfilController::class, 'actualizarAlergias']);
});
// Recetas
Route::get('/recetas',      [RecetaController::class, 'index']);
Route::get('/recetas/{id}', [RecetaController::class, 'show']);

// Recuperación de contraseña
Route::post('/recuperar-password/enviar-codigo',    [PasswordResetController::class, 'enviarCodigo']);
Route::post('/recuperar-password/verificar-codigo', [PasswordResetController::class, 'verificarCodigo']);
Route::post('/recuperar-password/cambiar',          [PasswordResetController::class, 'cambiarPassword']);

//IA
Route::post('/identificar-ingredientes', [IAController::class, 'identificar']);
Route::post('/buscar-recetas', [IAController::class, 'buscarPorIngredientes']);
// Listados auxiliares
Route::get('/ingredientes/listar', [IAController::class, 'listarIngredientes']);
Route::get('/unidades/listar', [IAController::class, 'listarUnidades']);