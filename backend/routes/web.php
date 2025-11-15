<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

// Ruta para el Dashboard Administrador estático
Route::get('/admin', function () {
    return view('admin_dashboard');
});
