<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\RecetaController;

// Rutas de recetas
Route::get('/recetas', [RecetaController::class, 'index']);
Route::get('/recetas/{id}', [RecetaController::class, 'show']);

// Ruta de prueba
Route::get('/test', function () {
    return response()->json([
        'message' => 'API Nutrichef funcionando correctamente',
        'timestamp' => now()
    ]);
});
