@extends('layouts.admin')

@section('titulo', 'Editar Usuario')
@section('titulo_pagina', 'Gestión de Perfil')

@section('contenido')

<div class="max-w-4xl mx-auto">
    <!-- Botón Volver -->
    <div class="mb-6">
        <a href="{{ route('admin.usuarios.show', $usuario->id) }}" class="flex items-center text-slate-500 hover:text-calabaza-600 transition-colors font-medium w-fit">
            <i data-lucide="arrow-left" class="w-4 h-4 mr-2"></i>
            Cancelar y volver al perfil
        </a>
    </div>

    <div class="bg-white rounded-xl shadow-sm border border-slate-100 overflow-hidden">
        <div class="p-6 border-b border-slate-100 bg-slate-50/50 flex justify-between items-center">
            <div>
                <h2 class="text-lg font-bold text-slate-800">Editar Datos del Usuario</h2>
                <p class="text-sm text-slate-500">Actualiza roles, permisos y datos personales.</p>
            </div>
            <!-- Icono de Rol Actual -->
            <div class="flex flex-col items-end">
                <span class="text-xs uppercase text-slate-400 font-bold">Rol Actual</span>
                <span class="text-calabaza-600 font-bold">{{ $usuario->rol->descripcion ?? 'Sin Rol' }}</span>
            </div>
        </div>

        <form action="{{ route('admin.usuarios.update', $usuario->id) }}" method="POST" class="p-6 space-y-8">
            @csrf
            @method('PUT')

            <!-- SECCIÓN 1: DATOS DE CUENTA Y ROL -->
            <div>
                <h3 class="text-sm font-bold text-slate-400 uppercase tracking-wider mb-4 flex items-center gap-2">
                    <i data-lucide="shield" class="w-4 h-4"></i> Cuenta y Permisos
                </h3>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 p-5 bg-slate-50 rounded-xl border border-slate-100">
                    
                    <!-- Selector de Rol (CRÍTICO) -->
                    <div class="md:col-span-2">
                        <label for="id_rol" class="block text-sm font-bold text-slate-700 mb-2">Rol del Usuario</label>
                        <div class="relative">
                            <select name="id_rol" id="id_rol" class="w-full pl-4 pr-10 py-3 border border-slate-300 rounded-lg focus:ring-2 focus:ring-calabaza-500 focus:border-calabaza-500 outline-none transition-all appearance-none bg-white font-medium text-slate-700 cursor-pointer">
                                @foreach($roles as $rol)
                                    <option value="{{ $rol->id }}" {{ $usuario->id_rol == $rol->id ? 'selected' : '' }}>
                                        {{ $rol->descripcion }}
                                    </option>
                                @endforeach
                            </select>
                            <i data-lucide="chevron-down" class="absolute right-3 top-3.5 w-5 h-5 text-slate-400 pointer-events-none"></i>
                        </div>
                        <p class="text-xs text-slate-500 mt-2">⚠️ Cambiar el rol afectará los permisos de acceso de este usuario inmediatamente.</p>
                    </div>

                    <!-- Username -->
                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-1">Nombre de Usuario / Alias</label>
                        <input type="text" name="name" value="{{ old('name', $usuario->name) }}" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-calabaza-500 outline-none" required>
                    </div>

                    <!-- Email -->
                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-1">Correo Electrónico</label>
                        <input type="email" name="email" value="{{ old('email', $usuario->email) }}" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-calabaza-500 outline-none" required>
                    </div>
                </div>
            </div>

            <!-- SECCIÓN 2: DATOS PERSONALES -->
            <div>
                <h3 class="text-sm font-bold text-slate-400 uppercase tracking-wider mb-4 flex items-center gap-2">
                    <i data-lucide="user" class="w-4 h-4"></i> Información Personal
                </h3>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
                    
                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-1">Nombres</label>
                        <input type="text" name="nombres" value="{{ old('nombres', $usuario->persona->nombres ?? '') }}" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-calabaza-500 outline-none" required>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-1">Apellido Paterno</label>
                        <input type="text" name="apellido_paterno" value="{{ old('apellido_paterno', $usuario->persona->apellido_paterno ?? '') }}" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-calabaza-500 outline-none" required>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-1">Apellido Materno</label>
                        <input type="text" name="apellido_materno" value="{{ old('apellido_materno', $usuario->persona->apellido_materno ?? '') }}" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-calabaza-500 outline-none">
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-1">Teléfono</label>
                        <input type="text" name="telefono" value="{{ old('telefono', $usuario->persona->telefono ?? '') }}" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-calabaza-500 outline-none">
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-1">Fecha de Nacimiento</label>
                        <input type="date" name="fecha_nacimiento" value="{{ old('fecha_nacimiento', $usuario->persona->fecha_nacimiento ?? '') }}" class="w-full px-4 py-2 border border-slate-300 rounded-lg focus:ring-2 focus:ring-calabaza-500 outline-none">
                    </div>
                </div>
            </div>

            <!-- Botones -->
            <div class="flex items-center justify-end gap-3 pt-6 border-t border-slate-100">
                <a href="{{ route('admin.usuarios.show', $usuario->id) }}" class="px-6 py-2.5 rounded-lg text-slate-600 hover:bg-slate-100 font-medium transition-colors">
                    Cancelar
                </a>
                <button type="submit" class="bg-calabaza-600 hover:bg-calabaza-700 text-white px-6 py-2.5 rounded-lg font-bold shadow-lg shadow-calabaza-500/20 flex items-center gap-2 transition-all transform hover:-translate-y-0.5">
                    <i data-lucide="save" class="w-4 h-4"></i>
                    Guardar Cambios
                </button>
            </div>

        </form>
    </div>
</div>
@endsection