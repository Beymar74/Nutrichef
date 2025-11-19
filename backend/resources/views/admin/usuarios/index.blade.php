@extends('layouts.admin')

@section('titulo', 'Gestión de Usuarios')
@section('titulo_pagina', 'Directorio de Usuarios')

@section('contenido')

    @if(session('success'))
        <div class="mb-6 bg-emerald-50 border border-emerald-200 text-emerald-700 px-4 py-3 rounded-lg flex items-center gap-2 shadow-sm">
            <i data-lucide="check-circle" class="w-5 h-5"></i>
            <span class="font-medium">{{ session('success') }}</span>
        </div>
    @endif

    <!-- Filtros y Acciones -->
    <div class="bg-white p-4 rounded-xl shadow-sm border border-slate-100 mb-6 flex flex-col lg:flex-row gap-4 items-center justify-between">
        
        <!-- Formulario de Búsqueda -->
        <form method="GET" action="{{ route('admin.usuarios.index') }}" class="flex gap-4 w-full lg:w-auto flex-1">
            <div class="relative flex-1 lg:w-96">
                <i data-lucide="search" class="absolute left-3 top-3 text-slate-400 w-5 h-5"></i>
                <input type="text" name="search" value="{{ request('search') }}" placeholder="Buscar por nombre, email..." 
                       class="w-full pl-10 pr-4 py-2.5 bg-slate-50 border border-slate-200 rounded-lg focus:ring-2 focus:ring-calabaza-500 outline-none">
            </div>
            
            <select name="rol" class="bg-slate-50 border border-slate-200 rounded-lg px-4 py-2.5 text-slate-700 focus:outline-none focus:border-calabaza-500" onchange="this.form.submit()">
                <option value="">Todos los roles</option>
                @foreach($roles as $rol)
                    <option value="{{ $rol->id }}" {{ request('rol') == $rol->id ? 'selected' : '' }}>
                        {{ $rol->descripcion }}
                    </option>
                @endforeach
            </select>
        </form>
        
        <div class="flex items-center gap-4 w-full lg:w-auto">
            <div class="text-sm text-slate-500 hidden md:block">
                Total: <strong>{{ $usuarios->total() }}</strong> usuarios
            </div>
            
            <!-- BOTÓN NUEVO USUARIO -->
            <a href="{{ route('admin.usuarios.create') }}" class="flex items-center justify-center gap-2 bg-calabaza-600 hover:bg-calabaza-700 text-white px-4 py-2.5 rounded-lg font-medium shadow-md shadow-calabaza-500/20 transition-all w-full lg:w-auto">
                <i data-lucide="user-plus" class="w-4 h-4"></i>
                Nuevo Usuario
            </a>
        </div>
    </div>

    <!-- Tabla -->
    <div class="bg-white rounded-xl shadow-sm border border-slate-100 overflow-hidden">
        <table class="w-full text-left border-collapse">
            <thead class="bg-slate-50/80 border-b border-slate-200 text-xs uppercase text-slate-500 font-semibold">
                <tr>
                    <th class="px-6 py-4">Usuario</th>
                    <th class="px-6 py-4">Rol</th>
                    <th class="px-6 py-4">Datos Personales</th>
                    <th class="px-6 py-4">Estado</th>
                    <th class="px-6 py-4 text-right">Acciones</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-slate-100">
                @forelse($usuarios as $usuario)
                    <tr class="hover:bg-slate-50/50 transition-colors">
                        <td class="px-6 py-4">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 rounded-full bg-calabaza-100 flex items-center justify-center text-calabaza-700 font-bold">
                                    {{ substr($usuario->name, 0, 1) }}
                                </div>
                                <div>
                                    <p class="font-bold text-slate-800 text-sm">{{ $usuario->name }}</p>
                                    <p class="text-xs text-slate-500">{{ $usuario->email }}</p>
                                </div>
                            </div>
                        </td>
                        <td class="px-6 py-4">
                            <span class="px-3 py-1 rounded-full text-xs font-medium bg-slate-100 text-slate-600 border border-slate-200">
                                {{ $usuario->rol->descripcion ?? 'Sin Rol' }}
                            </span>
                        </td>
                        <td class="px-6 py-4 text-sm text-slate-600">
                            @if($usuario->persona)
                                <p>{{ $usuario->persona->nombres }} {{ $usuario->persona->apellido_paterno }}</p>
                                <p class="text-xs text-slate-400">{{ $usuario->persona->telefono ?? 'Sin teléfono' }}</p>
                            @else
                                <span class="italic text-slate-400">Sin perfil</span>
                            @endif
                        </td>
                        <td class="px-6 py-4">
                            @if($usuario->estado)
                                <span class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-medium bg-emerald-100 text-emerald-800 border border-emerald-200">
                                    <span class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span> Activo
                                </span>
                            @else
                                <span class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800 border border-red-200">
                                    <span class="w-1.5 h-1.5 rounded-full bg-red-500"></span> Inactivo
                                </span>
                            @endif
                        </td>
                        <td class="px-6 py-4 text-right">
                            <div class="flex justify-end gap-2">
                                <a href="{{ route('admin.usuarios.show', $usuario->id) }}" class="p-2 bg-white border border-slate-200 rounded-lg text-slate-500 hover:text-calabaza-600 hover:border-calabaza-200 transition-colors" title="Ver Perfil">
                                    <i data-lucide="eye" class="w-4 h-4"></i>
                                </a>
                                
                                <form action="{{ route('admin.usuarios.toggle', $usuario->id) }}" method="POST">
                                    @csrf
                                    @method('PATCH')
                                    <button type="submit" class="p-2 bg-white border border-slate-200 rounded-lg text-slate-500 hover:text-red-600 hover:border-red-200 transition-colors" 
                                            title="{{ $usuario->estado ? 'Desactivar' : 'Activar' }}">
                                        <i data-lucide="{{ $usuario->estado ? 'ban' : 'check-circle' }}" class="w-4 h-4"></i>
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="5" class="px-6 py-12 text-center text-slate-500">
                            No se encontraron usuarios con esos criterios.
                        </td>
                    </tr>
                @endforelse
            </tbody>
        </table>
    </div>

    <div class="mt-4">
        {{ $usuarios->appends(request()->query())->links() }}
    </div>
@endsection