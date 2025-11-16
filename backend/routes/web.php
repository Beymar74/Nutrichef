<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin\RecetaController;

Route::prefix('admin')->name('admin.')->group(function () {
    
    // Listado y Filtros
    Route::get('/recetas', [RecetaController::class, 'index'])->name('recetas.index');
    
    // Ver Detalle
    Route::get('/recetas/{id}', [RecetaController::class, 'show'])->name('recetas.show');
    
    // Editar Receta (Formulario y Acción)
    Route::get('/recetas/{id}/edit', [RecetaController::class, 'edit'])->name('recetas.edit');
    Route::put('/recetas/{id}', [RecetaController::class, 'update'])->name('recetas.update');
    
    // Eliminar Receta
    Route::delete('/recetas/{id}', [RecetaController::class, 'destroy'])->name('recetas.destroy');

    // Acciones de Moderación (Aprobar/Rechazar)
    Route::post('/recetas/{id}/approve', [RecetaController::class, 'approve'])->name('recetas.approve');
    Route::post('/recetas/{id}/reject', [RecetaController::class, 'reject'])->name('recetas.reject');

});