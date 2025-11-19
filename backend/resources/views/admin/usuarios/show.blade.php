@extends('layouts.admin')

@section('titulo', 'Perfil de Usuario')
@section('titulo_pagina', 'Detalle de Usuario')

@section('contenido')

    @if(session('success'))
        <div class="mb-6 bg-emerald-50 border border-emerald-200 text-emerald-700 px-4 py-3 rounded-lg flex items-center gap-2 shadow-sm">
            <i data-lucide="check-circle" class="w-5 h-5"></i>
            <span class="font-medium">{{ session('success') }}</span>
        </div>
    @endif

    <div class="mb-6">
        <a href="{{ route('admin.usuarios.index') }}" class="text-slate-500 hover:text-calabaza-600 flex items-center gap-1 text-sm font-medium w-fit">
            <i data-lucide="arrow-left" class="w-4 h-4"></i> Volver al directorio
        </a>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        
        <!-- Tarjeta Principal -->
        <div class="bg-white rounded-xl shadow-sm border border-slate-100 p-6 lg:col-span-1 h-fit">
            <div class="flex flex-col items-center text-center">
                <!-- Avatar -->
                <div class="w-24 h-24 rounded-full bg-calabaza-100 text-calabaza-600 flex items-center justify-center text-3xl font-bold mb-4 border-4 border-white shadow-lg">
                    {{ substr($usuario->name, 0, 1) }}
                </div>
                
                <h2 class="text-xl font-bold text-slate-800">{{ $usuario->name }}</h2>
                
                <span class="px-3 py-1 mt-2 rounded-full text-xs font-medium bg-slate-100 text-slate-600 border border-slate-200">
                    {{ $usuario->rol->descripcion ?? 'Sin Rol' }}
                </span>
                
                <div class="mt-6 w-full space-y-3 border-t border-slate-100 pt-6 text-left text-sm">
                    <div class="flex justify-between">
                        <span class="text-slate-500">Email:</span>
                        <span class="font-medium text-slate-700">{{ $usuario->email }}</span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-slate-500">Estado:</span>
                        <span class="{{ $usuario->estado ? 'text-emerald-600' : 'text-red-600' }} font-bold">
                            {{ $usuario->estado ? 'Activo' : 'Inactivo' }}
                        </span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-slate-500">Registro:</span>
                        <span class="text-slate-700">{{ $usuario->created_at->format('d/m/Y') }}</span>
                    </div>
                </div>

                <!-- ACCIONES PRINCIPALES -->
                <div class="w-full mt-6 space-y-3">
                    
                    <!-- 1. Botón Editar (NUEVO) -->
                    <a href="{{ route('admin.usuarios.edit', $usuario->id) }}" class="flex items-center justify-center w-full py-2 px-4 rounded-lg bg-slate-800 hover:bg-slate-900 text-white font-medium transition-colors shadow-lg shadow-slate-500/20">
                        <i data-lucide="edit-2" class="w-4 h-4 mr-2"></i>
                        Editar Datos y Rol
                    </a>

                    <!-- 2. Botón Bloquear -->
                    <form action="{{ route('admin.usuarios.toggle', $usuario->id) }}" method="POST">
                        @csrf @method('PATCH')
                        <button type="submit" class="w-full py-2 px-4 rounded-lg border font-medium transition-colors flex items-center justify-center {{ $usuario->estado ? 'border-red-200 text-red-600 hover:bg-red-50' : 'border-emerald-200 text-emerald-600 hover:bg-emerald-50' }}">
                            @if($usuario->estado)
                                <i data-lucide="ban" class="w-4 h-4 mr-2"></i> Bloquear Acceso
                            @else
                                <i data-lucide="check-circle" class="w-4 h-4 mr-2"></i> Reactivar Acceso
                            @endif
                        </button>
                    </form>
                </div>

            </div>
        </div>

        <!-- Pestañas de Info (Igual que antes) -->
        <div class="lg:col-span-2 space-y-6">
            <!-- ... Contenido de Datos Personales y Recetas ... -->
            <!-- Datos Personales -->
            <div class="bg-white rounded-xl shadow-sm border border-slate-100 p-6">
                <h3 class="text-lg font-bold text-slate-800 mb-4 border-b border-slate-100 pb-2">Información Personal</h3>
                @if($usuario->persona)
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label class="block text-xs font-bold text-slate-400 uppercase">Nombre Completo</label>
                            <p class="text-slate-700">{{ $usuario->persona->nombres }} {{ $usuario->persona->apellido_paterno }} {{ $usuario->persona->apellido_materno }}</p>
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-slate-400 uppercase">Teléfono</label>
                            <p class="text-slate-700">{{ $usuario->persona->telefono ?? 'No registrado' }}</p>
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-slate-400 uppercase">Fecha Nacimiento</label>
                            <p class="text-slate-700">{{ $usuario->persona->fecha_nacimiento ?? '--' }}</p>
                        </div>
                        <div class="flex gap-4">
                            <div>
                                <label class="block text-xs font-bold text-slate-400 uppercase">Altura</label>
                                <p class="text-slate-700">{{ $usuario->persona->altura ?? '-' }} m</p>
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-slate-400 uppercase">Peso</label>
                                <p class="text-slate-700">{{ $usuario->persona->peso ?? '-' }} kg</p>
                            </div>
                        </div>
                    </div>
                @else
                    <p class="text-slate-400 italic">Este usuario no ha completado su perfil personal.</p>
                @endif
            </div>

            <!-- Recetas Recientes -->
            <div class="bg-white rounded-xl shadow-sm border border-slate-100 p-6">
                <h3 class="text-lg font-bold text-slate-800 mb-4 flex justify-between items-center">
                    <span>Recetas Publicadas</span>
                    <span class="text-xs bg-slate-100 px-2 py-1 rounded text-slate-500">{{ $usuario->recetasCreadas->count() }} Total</span>
                </h3>
                
                <div class="space-y-3">
                    @forelse($usuario->recetasCreadas->take(3) as $receta)
                        <div class="flex items-center justify-between p-3 bg-slate-50 rounded-lg border border-slate-100">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 rounded bg-white flex items-center justify-center text-calabaza-500 border border-slate-200">
                                    <i data-lucide="utensils" class="w-5 h-5"></i>
                                </div>
                                <div>
                                    <p class="font-medium text-slate-800 text-sm">{{ $receta->titulo }}</p>
                                    <p class="text-xs text-slate-500">{{ $receta->created_at->diffForHumans() }}</p>
                                </div>
                            </div>
                            <span class="text-xs font-medium px-2 py-1 rounded bg-white border border-slate-200 text-slate-600">
                                {{ $receta->estado->descripcion ?? 'Estado?' }}
                            </span>
                        </div>
                    @empty
                        <p class="text-slate-400 italic text-sm">No ha publicado recetas aún.</p>
                    @endforelse
                </div>
            </div>
        </div>
    </div>

@endsection