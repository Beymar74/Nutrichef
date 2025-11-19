@extends('layouts.admin')

@section('titulo', 'Dashboard')
@section('titulo_pagina', 'Resumen General')

@section('contenido')
    <!-- Bienvenida -->
    <div class="mb-8 flex justify-between items-end">
        <div>
            <h1 class="text-2xl font-bold text-slate-800">¡Hola, {{ Auth::user()->name }}!</h1>
            <p class="mt-1 text-sm text-slate-500">Aquí tienes lo que está pasando en NutriChef hoy.</p>
        </div>
        <div class="text-sm font-medium text-slate-500 bg-white px-4 py-2 rounded-lg shadow-sm border border-slate-100">
            {{ now()->format('d M, Y') }}
        </div>
    </div>

    <!-- Tarjetas de Estadísticas (Datos Reales) -->
    <div class="grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-4 mb-8">
        
        <!-- Card 1: Usuarios -->
        <div class="bg-white overflow-hidden shadow-sm rounded-xl border border-slate-100 hover:shadow-md transition-shadow">
            <div class="p-5">
                <div class="flex items-center">
                    <div class="flex-shrink-0 bg-calabaza-50 rounded-lg p-3">
                        <i data-lucide="users" class="h-6 w-6 text-calabaza-600"></i>
                    </div>
                    <div class="ml-5 w-0 flex-1">
                        <dl>
                            <dt class="text-xs font-bold text-slate-400 uppercase tracking-wider">Usuarios</dt>
                            <dd class="flex items-baseline">
                                <div class="text-2xl font-bold text-slate-800">{{ $totalUsuarios }}</div>
                                <div class="ml-2 flex items-baseline text-xs font-semibold text-emerald-600">
                                    {{ $usuariosActivos }} activos
                                </div>
                            </dd>
                        </dl>
                    </div>
                </div>
            </div>
            <div class="bg-slate-50 px-5 py-2 border-t border-slate-100">
                <a href="{{ route('admin.usuarios.index') }}" class="text-xs font-medium text-calabaza-600 hover:text-calabaza-800 flex items-center">
                    Ver directorio <i data-lucide="arrow-right" class="ml-1 w-3 h-3"></i>
                </a>
            </div>
        </div>

        <!-- Card 2: Recetas Publicadas (Tus "Borrador") -->
        <div class="bg-white overflow-hidden shadow-sm rounded-xl border border-slate-100 hover:shadow-md transition-shadow">
            <div class="p-5">
                <div class="flex items-center">
                    <div class="flex-shrink-0 bg-emerald-50 rounded-lg p-3">
                        <i data-lucide="check-circle" class="h-6 w-6 text-emerald-600"></i>
                    </div>
                    <div class="ml-5 w-0 flex-1">
                        <dl>
                            <dt class="text-xs font-bold text-slate-400 uppercase tracking-wider">Publicadas</dt>
                            <dd class="text-2xl font-bold text-slate-800">{{ $recetasPublicadas }}</dd>
                        </dl>
                    </div>
                </div>
            </div>
            <div class="bg-slate-50 px-5 py-2 border-t border-slate-100">
                <a href="{{ route('admin.recetas.index', ['estado' => 'aprobada']) }}" class="text-xs font-medium text-emerald-600 hover:text-emerald-800 flex items-center">
                    Ver publicadas <i data-lucide="arrow-right" class="ml-1 w-3 h-3"></i>
                </a>
            </div>
        </div>

        <!-- Card 3: Pendientes de Revisión -->
        <div class="bg-white overflow-hidden shadow-sm rounded-xl border-l-4 border-calabaza-500 hover:shadow-md transition-shadow">
            <div class="p-5">
                <div class="flex items-center">
                    <div class="flex-shrink-0">
                        <i data-lucide="clock" class="h-8 w-8 text-calabaza-500"></i>
                    </div>
                    <div class="ml-5 w-0 flex-1">
                        <dl>
                            <dt class="text-xs font-bold text-slate-400 uppercase tracking-wider">Por Revisar</dt>
                            <dd class="text-2xl font-bold text-slate-800">{{ $recetasPendientes }}</dd>
                        </dl>
                    </div>
                </div>
            </div>
            <div class="bg-slate-50 px-5 py-2 border-t border-slate-100">
                <a href="{{ route('admin.recetas.index', ['estado' => 'pendiente']) }}" class="text-xs font-medium text-calabaza-600 hover:text-calabaza-800 flex items-center">
                    Moderar ahora <i data-lucide="arrow-right" class="ml-1 w-3 h-3"></i>
                </a>
            </div>
        </div>
        
        <!-- Card 4: Rechazadas -->
        <div class="bg-white overflow-hidden shadow-sm rounded-xl border border-slate-100 hover:shadow-md transition-shadow">
            <div class="p-5">
                <div class="flex items-center">
                    <div class="flex-shrink-0 bg-red-50 rounded-lg p-3">
                        <i data-lucide="x-circle" class="h-6 w-6 text-red-600"></i>
                    </div>
                    <div class="ml-5 w-0 flex-1">
                        <dl>
                            <dt class="text-xs font-bold text-slate-400 uppercase tracking-wider">Rechazadas</dt>
                            <dd class="text-2xl font-bold text-slate-800">{{ $recetasRechazadas }}</dd>
                        </dl>
                    </div>
                </div>
            </div>
            <div class="bg-slate-50 px-5 py-2 border-t border-slate-100">
                <a href="{{ route('admin.recetas.index', ['estado' => 'rechazada']) }}" class="text-xs font-medium text-red-600 hover:text-red-800 flex items-center">
                    Ver historial <i data-lucide="arrow-right" class="ml-1 w-3 h-3"></i>
                </a>
            </div>
        </div>
    </div>

    <!-- Sección Inferior: Actividad Reciente -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
        
        <!-- Tabla de Últimas Recetas -->
        <div class="bg-white shadow-sm rounded-xl border border-slate-100 p-6">
            <h3 class="text-lg font-bold text-slate-800 mb-4">Últimas Recetas Subidas</h3>
            <div class="space-y-4">
                @forelse($ultimasRecetas as $receta)
                    <div class="flex items-center justify-between p-3 hover:bg-slate-50 rounded-lg transition-colors border border-transparent hover:border-slate-100">
                        <div class="flex items-center gap-3">
                            <!-- Miniatura -->
                            <div class="w-10 h-10 rounded-lg bg-slate-100 overflow-hidden flex-shrink-0">
                                @php $img = $receta->multimedia->first(); @endphp
                                @if($img)
                                    <img src="{{ \Illuminate\Support\Str::startsWith($img->archivo, 'http') ? $img->archivo : asset('storage/'.$img->archivo) }}" class="w-full h-full object-cover">
                                @else
                                    <div class="flex items-center justify-center h-full text-slate-400"><i data-lucide="image" class="w-4 h-4"></i></div>
                                @endif
                            </div>
                            <!-- Info -->
                            <div>
                                <p class="text-sm font-bold text-slate-800 line-clamp-1">{{ $receta->titulo }}</p>
                                <p class="text-xs text-slate-500">Por {{ $receta->creador->name ?? 'Anónimo' }}</p>
                            </div>
                        </div>
                        <!-- Estado -->
                        @php
                            $estado = strtoupper($receta->estado->descripcion ?? 'PENDIENTE');
                            $color = match($estado) {
                                'BORRADOR' => 'text-emerald-600 bg-emerald-50',
                                'PENDIENTE' => 'text-calabaza-600 bg-calabaza-50',
                                'OCULTA' => 'text-red-600 bg-red-50',
                                default => 'text-slate-600 bg-slate-50'
                            };
                        @endphp
                        <span class="px-2 py-1 rounded text-xs font-bold {{ $color }}">
                            {{ $estado == 'BORRADOR' ? 'APROBADA' : $estado }}
                        </span>
                    </div>
                @empty
                    <p class="text-slate-400 italic text-sm">No hay actividad reciente.</p>
                @endforelse
            </div>
            <a href="{{ route('admin.recetas.index') }}" class="block mt-4 text-center text-sm font-medium text-calabaza-600 hover:text-calabaza-700">
                Ver todas las recetas
            </a>
        </div>

        <!-- Acciones Rápidas -->
        <div class="bg-white shadow-sm rounded-xl border border-slate-100 p-6 h-fit">
            <h3 class="text-lg font-bold text-slate-800 mb-4">Accesos Directos</h3>
            <div class="grid grid-cols-2 gap-4">
                <a href="{{ route('admin.usuarios.create') }}" class="flex flex-col items-center justify-center p-4 rounded-xl border border-slate-200 hover:border-calabaza-300 hover:bg-calabaza-50 transition-all group">
                    <div class="bg-calabaza-100 p-3 rounded-full mb-2 group-hover:bg-calabaza-200 transition-colors">
                        <i data-lucide="user-plus" class="w-6 h-6 text-calabaza-600"></i>
                    </div>
                    <span class="text-sm font-bold text-slate-700 group-hover:text-calabaza-700">Nuevo Usuario</span>
                </a>

                <a href="{{ route('admin.recetas.index', ['estado' => 'pendiente']) }}" class="flex flex-col items-center justify-center p-4 rounded-xl border border-slate-200 hover:border-calabaza-300 hover:bg-calabaza-50 transition-all group">
                    <div class="bg-calabaza-100 p-3 rounded-full mb-2 group-hover:bg-calabaza-200 transition-colors">
                        <i data-lucide="check-square" class="w-6 h-6 text-calabaza-600"></i>
                    </div>
                    <span class="text-sm font-bold text-slate-700 group-hover:text-calabaza-700">Moderar Recetas</span>
                </a>
            </div>
        </div>

    </div>
@endsection