<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin\RecetaController;
use App\Http\Controllers\Auth\LoginController; 
use App\Http\Controllers\Admin\UsuarioController; 
use App\Http\Controllers\Admin\DashboardController;

/*
|--------------------------------------------------------------------------
| RUTAS PÚBLICAS / AUTENTICACIÓN
|--------------------------------------------------------------------------
*/

Route::view('/login', 'auth.login')->name('login');
Route::post('/login', [LoginController::class, 'login']);
Route::post('/logout', [LoginController::class, 'logout'])->name('logout');

// Redirección raíz
Route::redirect('/', '/login');


/*
|--------------------------------------------------------------------------
| RUTAS DEL PANEL DE ADMINISTRACIÓN (PROTEGIDAS)
|--------------------------------------------------------------------------
*/

Route::middleware('auth')->prefix('admin')->name('admin.')->group(function () {

    // --- DASHBOARD ---
    // CORRECCIÓN: Cambiado de '/admin/dashboard' a '/dashboard'
    // Al estar dentro del prefix('admin'), la ruta final será /admin/dashboard
    Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');
    
    // --- GESTIÓN DE RECETAS ---
    Route::get('/recetas', [RecetaController::class, 'index'])->name('recetas.index');
    Route::get('/recetas/{id}', [RecetaController::class, 'show'])->name('recetas.show');
    Route::get('/recetas/{id}/edit', [RecetaController::class, 'edit'])->name('recetas.edit');
    Route::put('/recetas/{id}', [RecetaController::class, 'update'])->name('recetas.update');
    Route::delete('/recetas/{id}', [RecetaController::class, 'destroy'])->name('recetas.destroy');
    Route::post('/recetas/{id}/approve', [RecetaController::class, 'approve'])->name('recetas.approve');
    Route::post('/recetas/{id}/reject', [RecetaController::class, 'reject'])->name('recetas.reject');

    // --- GESTIÓN DE USUARIOS ---
    Route::get('/usuarios', [UsuarioController::class, 'index'])->name('usuarios.index');
    
    // Rutas de creación (siempre antes de {id})
    Route::get('/usuarios/create', [UsuarioController::class, 'create'])->name('usuarios.create');
    Route::post('/usuarios', [UsuarioController::class, 'store'])->name('usuarios.store');

    // Rutas de detalle y edición
    Route::get('/usuarios/{id}', [UsuarioController::class, 'show'])->name('usuarios.show');
    Route::patch('/usuarios/{id}/toggle', [UsuarioController::class, 'toggleStatus'])->name('usuarios.toggle');
    Route::get('/usuarios/{id}/edit', [UsuarioController::class, 'edit'])->name('usuarios.edit');
    Route::put('/usuarios/{id}', [UsuarioController::class, 'update'])->name('usuarios.update');
});