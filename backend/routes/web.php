<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin\RecetaController;
use App\Http\Controllers\Auth\LoginController; 
use App\Http\Controllers\Admin\UsuarioController; 
use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\ComentarioController;
use App\Http\Controllers\Admin\PlanificacionController;
use App\Http\Controllers\Admin\ConfiguracionController;
use App\Http\Controllers\Admin\SolicitudChefController;

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
    // Correcto: Solo '/dashboard', el prefijo 'admin' ya lo pone el grupo
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
    Route::get('/usuarios/create', [UsuarioController::class, 'create'])->name('usuarios.create');
    Route::post('/usuarios', [UsuarioController::class, 'store'])->name('usuarios.store');
    Route::get('/usuarios/{id}', [UsuarioController::class, 'show'])->name('usuarios.show');
    Route::patch('/usuarios/{id}/toggle', [UsuarioController::class, 'toggleStatus'])->name('usuarios.toggle');
    Route::get('/usuarios/{id}/edit', [UsuarioController::class, 'edit'])->name('usuarios.edit');
    Route::put('/usuarios/{id}', [UsuarioController::class, 'update'])->name('usuarios.update');

// --- GESTIÓN DE SOLICITUDES CHEF ---
Route::get('/solicitudes-chef', [SolicitudChefController::class, 'index'])->name('solicitudes.index');
Route::get('/solicitudes-chef/{id}', [SolicitudChefController::class, 'show'])->name('solicitudes.show');
Route::post('/solicitudes-chef/{id}/approve', [SolicitudChefController::class, 'approve'])->name('solicitudes.approve');
Route::post('/solicitudes-chef/{id}/reject', [SolicitudChefController::class, 'reject'])->name('solicitudes.reject');
Route::delete('/solicitudes-chef/{id}', [SolicitudChefController::class, 'destroy'])->name('solicitudes.destroy');

    // --- CONFIGURACIÓN (FALTABA ESTO) ---
    Route::get('/configuracion', [ConfiguracionController::class, 'index'])->name('configuracion.index');
    Route::post('/configuracion/subdominio', [ConfiguracionController::class, 'storeSubdominio'])->name('configuracion.subdominio.store');
    Route::delete('/configuracion/subdominio/{id}', [ConfiguracionController::class, 'destroySubdominio'])->name('configuracion.subdominio.destroy');

    // --- GESTIÓN DE COMENTARIOS ---
    Route::get('/comentarios', [ComentarioController::class, 'index'])->name('comentarios.index');
    Route::patch('/comentarios/{id}/{accion}', [ComentarioController::class, 'moderar'])->name('comentarios.moderar');
});