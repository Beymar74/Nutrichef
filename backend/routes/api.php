<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\DB;

// Controladores
use App\Http\Controllers\AuthController;
use App\Http\Controllers\PerfilController;
use App\Http\Controllers\Auth\PasswordResetController;
use App\Http\Controllers\IAController;
use App\Http\Controllers\ChefController;
use App\Http\Controllers\FollowController;
// ✅ Importamos una sola vez el controlador de Recetas
use App\Http\Controllers\API\RecetaController; 

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

Route::get('/test', function () {
    return response()->json([
        'message'        => 'API Nutrichef funcionando correctamente',
        'database'       => DB::connection()->getDatabaseName(),
        'usuarios_count' => DB::table('usuarios')->count(),
        'timestamp'      => now()
    ]);
});

// ==========================
// 🔐 AUTENTICACIÓN
// ==========================
Route::post('/register', [AuthController::class, 'register']);
Route::post('/login',    [AuthController::class, 'login']);

// Recuperación de contraseña
Route::post('/recuperar-password/enviar-codigo',    [PasswordResetController::class, 'enviarCodigo']);
Route::post('/recuperar-password/verificar-codigo', [PasswordResetController::class, 'verificarCodigo']);
Route::post('/recuperar-password/cambiar',          [PasswordResetController::class, 'cambiarPassword']);


// ==========================
// 🛡️ RUTAS PROTEGIDAS (Requieren Token)
// ==========================
Route::middleware('auth:sanctum')->group(function () {
    Route::put('/usuario/perfil',          [AuthController::class, 'actualizarPerfil']);
    Route::put('/perfil/dieta',            [PerfilController::class, 'actualizarDieta']);
    Route::put('/perfil/nivel-cocina',     [PerfilController::class, 'actualizarNivelCocina']);
    Route::put('/perfil/alergias',         [PerfilController::class, 'actualizarAlergias']);
    
    Route::post('/logout', function (Request $request) {
        $request->user()->tokens()->delete();
        return response()->json(["success"=>true,"message"=>"Sesión cerrada"]);
    });
});


// ==========================
// 👨‍🍳 GESTIÓN DE RECETAS (CRUD Completo)
// ==========================
Route::get('/recetas',       [RecetaController::class, 'index']);   // Ver lista
Route::post('/recetas',      [RecetaController::class, 'store']);   // Crear (Esta faltaba y causaba el 405)
Route::get('/recetas/{id}',  [RecetaController::class, 'show']);    // Ver detalle
Route::put('/recetas/{id}',  [RecetaController::class, 'update']);  // Actualizar
Route::delete('/recetas/{id}', [RecetaController::class, 'destroy']); // Eliminar


// ==========================
// 🤖 INTELIGENCIA ARTIFICIAL
// ==========================
Route::post('/identificar-ingredientes', [IAController::class, 'identificar']);
Route::post('/buscar-recetas',           [IAController::class, 'buscarPorIngredientes']);


// ==========================
// 📋 UTILIDADES Y LISTADOS
// ==========================
Route::get('/ingredientes/listar', [IAController::class, 'listarIngredientes']);
Route::get('/unidades/listar',     [IAController::class, 'listarUnidades']);

// Estadísticas Mock (Para que no falle el Home del Chef en Flutter)
Route::get('/chefs/{id}/estadisticas', function ($id) {
    return response()->json([
        'total_visualizaciones' => 150,
        'calificacion_promedio' => 4.5,
        'total_comentarios' => 12,
        'total_favoritos' => 8
    ]);
});

// Catálogos Genéricos (Para dropdowns en Flutter)
Route::get('/catalogos/{dominio}', function ($dominio) {
    // Aquí puedes conectar con un controlador real si tienes la tabla subdominios
    return response()->json([]);
});


// ==========================
// 👩‍🍳 PERFIL PÚBLICO CHEF
// ==========================
Route::get('/chefs/{id}', [ChefController::class, 'show']);
Route::get('/imagenes/recetas/{id}', [ChefController::class, 'getRecipeImage'])->name('recetas.imagen');

// Seguidores
Route::post('/chefs/{id}/follow', [FollowController::class, 'toggleFollow']);
Route::get('/chefs/{id}/is-following', [FollowController::class, 'checkFollowStatus']);