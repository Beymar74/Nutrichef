<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use Illuminate\Support\Facades\DB;

Route::get('/test', function () {
    return response()->json([
        'message' => '¡API funcionando!',
        'database' => DB::connection()->getDatabaseName(),
        'usuarios_count' => DB::table('users')->count()
    ]);
});

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);
