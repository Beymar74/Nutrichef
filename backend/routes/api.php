<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use Illuminate\Support\Facades\DB;
use App\Http\Controllers\Auth\PasswordResetController;

Route::get('/test', function () {
    return response()->json([
        'message' => '¡API funcionando!',
        'database' => DB::connection()->getDatabaseName(),
        'usuarios_count' => DB::table('usuarios')->count()
    ]);
});


Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
Route::post('/recuperar-password/enviar-codigo', [PasswordResetController::class, 'enviarCodigo']);
Route::post('/recuperar-password/verificar-codigo', [PasswordResetController::class, 'verificarCodigo']);
Route::post('/recuperar-password/cambiar', [PasswordResetController::class, 'cambiarPassword']);