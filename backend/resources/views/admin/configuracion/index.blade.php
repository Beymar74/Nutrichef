@extends('layouts.admin')

@section('titulo', 'Configuración del Sistema')
@section('titulo_pagina', 'Catálogos y Parámetros')

@section('contenido')

    @if(session('success'))
        <div class="mb-6 bg-emerald-50 border border-emerald-200 text-emerald-700 px-4 py-3 rounded-lg flex items-center gap-2 shadow-sm">
            <i data-lucide="check-circle" class="w-5 h-5"></i>
            <span class="font-medium">{{ session('success') }}</span>
        </div>
    @endif

    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
        @foreach($dominios as $dominio)
            <div class="bg-white rounded-xl shadow-sm border border-slate-100 overflow-hidden flex flex-col h-full hover:shadow-md transition-shadow">
                
                <!-- Encabezado de la Tarjeta -->
                <div class="p-4 bg-slate-50 border-b border-slate-100 flex justify-between items-center">
                    <h3 class="font-bold text-slate-700 text-sm uppercase tracking-wide flex items-center gap-2">
                        <i data-lucide="list" class="w-4 h-4 text-calabaza-500"></i>
                        {{ str_replace('_', ' ', $dominio->descripcion) }}
                    </h3>
                    <span class="bg-white text-slate-500 text-xs px-2 py-1 rounded border border-slate-200 font-mono">
                        {{ $dominio->subdominios->count() }}
                    </span>
                </div>
                
                <!-- Lista de Subdominios -->
                <div class="p-4 flex-1 overflow-y-auto max-h-64 space-y-2 custom-scrollbar">
                    @forelse($dominio->subdominios as $sub)
                        <div class="flex justify-between items-center group p-2 hover:bg-slate-50 rounded-lg transition-colors border border-transparent hover:border-slate-100">
                            <span class="text-sm text-slate-600 font-medium">{{ $sub->descripcion }}</span>
                            
                            <!-- Botón Eliminar -->
                            <!-- CORRECCIÓN: Agregado el prefijo 'admin.' a la ruta -->
                            <form action="{{ route('admin.configuracion.subdominio.destroy', $sub->id) }}" method="POST" class="opacity-0 group-hover:opacity-100 transition-opacity">
                                @csrf 
                                @method('DELETE')
                                <button type="submit" class="text-slate-300 hover:text-red-500 p-1 rounded hover:bg-red-50 transition-colors" title="Eliminar opción" onclick="return confirm('¿Estás seguro de eliminar esta opción?')">
                                    <i data-lucide="trash-2" class="w-4 h-4"></i>
                                </button>
                            </form>
                        </div>
                    @empty
                        <div class="flex flex-col items-center justify-center py-8 text-slate-400">
                            <i data-lucide="inbox" class="w-8 h-8 mb-2 opacity-50"></i>
                            <p class="text-xs italic">Sin opciones registradas</p>
                        </div>
                    @endforelse
                </div>

                <!-- Pie: Formulario de Agregar -->
                <div class="p-3 border-t border-slate-100 bg-slate-50/30">
                    <!-- CORRECCIÓN: Agregado el prefijo 'admin.' a la ruta -->
                    <form action="{{ route('admin.configuracion.subdominio.store') }}" method="POST" class="flex gap-2">
                        @csrf
                        <input type="hidden" name="id_dominio" value="{{ $dominio->id }}">
                        <input type="text" name="descripcion" placeholder="Nueva opción..." required
                               class="flex-1 text-sm px-3 py-2 border border-slate-200 rounded-lg focus:outline-none focus:border-calabaza-500 focus:ring-2 focus:ring-calabaza-200 transition-all shadow-sm">
                        <button type="submit" class="bg-slate-800 hover:bg-calabaza-600 text-white p-2 rounded-lg transition-colors shadow-sm" title="Agregar">
                            <i data-lucide="plus" class="w-4 h-4"></i>
                        </button>
                    </form>
                </div>
            </div>
        @endforeach
    </div>
@endsection