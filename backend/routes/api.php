<?php
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Auth\PasswordResetController;
use App\Http\Controllers\Api\RecetaController;

// Rutas de recetas
Route::get('/recetas', [RecetaController::class, 'index']);
Route::get('/recetas/{id}', [RecetaController::class, 'show']);

// Ruta de prueba
Route::get('/test', function () {
    return response()->json([
        'message' => 'API Nutrichef funcionando correctamente',
        'database' => DB::connection()->getDatabaseName(),
        'usuarios_count' => DB::table('usuarios')->count(),
        'timestamp' => now()
    ]);
});

// Rutas de autenticación
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

// Rutas de recuperación de contraseña
Route::post('/recuperar-password/enviar-codigo', [PasswordResetController::class, 'enviarCodigo']);
Route::post('/recuperar-password/verificar-codigo', [PasswordResetController::class, 'verificarCodigo']);
Route::post('/recuperar-password/cambiar', [PasswordResetController::class, 'cambiarPassword']);