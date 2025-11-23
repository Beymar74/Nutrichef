@extends('layouts.admin')

@section('titulo', 'Moderación')
@section('titulo_pagina', 'Comentarios de Usuarios')

@section('contenido')

    @if(session('success'))
        <div class="mb-6 bg-emerald-50 border border-emerald-200 text-emerald-700 px-4 py-3 rounded-lg flex items-center gap-2 shadow-sm">
            <i data-lucide="check-circle" class="w-5 h-5"></i>
            <span class="font-medium">{{ session('success') }}</span>
        </div>
    @endif
    
    @if(session('error'))
        <div class="mb-6 bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg flex items-center gap-2 shadow-sm">
            <i data-lucide="alert-circle" class="w-5 h-5"></i>
            <span class="font-medium">{{ session('error') }}</span>
        </div>
    @endif

    <div class="bg-white rounded-xl shadow-sm border border-slate-100 overflow-hidden">
        <table class="w-full text-left border-collapse">
            <thead class="bg-slate-50/80 border-b border-slate-200 text-xs uppercase text-slate-500 font-semibold">
                <tr>
                    <th class="px-6 py-4">Usuario</th>
                    <th class="px-6 py-4">Comentario</th>
                    <th class="px-6 py-4">Receta</th>
                    <th class="px-6 py-4">Estado</th>
                    <th class="px-6 py-4 text-right">Acciones</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-slate-100">
                @forelse($comentarios as $comentario)
                    <tr class="hover:bg-slate-50/50 transition-colors group">
                        <td class="px-6 py-4">
                            <div class="flex items-center gap-2">
                                <div class="w-8 h-8 rounded-full bg-calabaza-100 flex items-center justify-center text-calabaza-700 font-bold text-xs border border-calabaza-200">
                                    {{ substr($comentario->usuario->name ?? 'A', 0, 1) }}
                                </div>
                                <span class="text-sm font-medium text-slate-700">{{ $comentario->usuario->name ?? 'Anónimo' }}</span>
                            </div>
                        </td>
                        <td class="px-6 py-4 max-w-md">
                            <p class="text-slate-600 text-sm italic">"{{ $comentario->contenido ?? 'Sin contenido' }}"</p>
                            <span class="text-xs text-slate-400 mt-1 block">{{ $comentario->created_at->diffForHumans() }}</span>
                        </td>
                        <td class="px-6 py-4">
                            <span class="text-sm font-medium text-calabaza-600">
                                {{ $comentario->publicacion->receta->titulo ?? 'Receta Eliminada' }}
                            </span>
                        </td>
                        <td class="px-6 py-4">
                            @php
                                $est = strtoupper($comentario->estado->descripcion ?? 'VISIBLE');
                                $badge = match($est) {
                                    'VISIBLE' => 'bg-emerald-100 text-emerald-700 border-emerald-200',
                                    'REPORTADO' => 'bg-orange-100 text-orange-700 border-orange-200',
                                    'ELIMINADO_ADMIN' => 'bg-red-100 text-red-700 border-red-200 line-through opacity-60',
                                    default => 'bg-slate-100 text-slate-600 border-slate-200'
                                };
                            @endphp
                            <span class="px-2 py-1 rounded text-xs font-bold border {{ $badge }}">
                                {{ $est }}
                            </span>
                        </td>
                        <td class="px-6 py-4 text-right">
                            <div class="flex justify-end gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                                <!-- Aprobar / Restaurar -->
                                <form action="{{ route('admin.comentarios.moderar', ['id' => $comentario->id, 'accion' => 'aprobar']) }}" method="POST">
                                    @csrf @method('PATCH')
                                    <button type="submit" class="p-2 text-emerald-500 hover:bg-emerald-50 rounded-lg transition-colors border border-transparent hover:border-emerald-200" title="Marcar Visible">
                                        <i data-lucide="check" class="w-4 h-4"></i>
                                    </button>
                                </form>
                                <!-- Eliminar -->
                                <form action="{{ route('admin.comentarios.moderar', ['id' => $comentario->id, 'accion' => 'eliminar']) }}" method="POST">
                                    @csrf @method('PATCH')
                                    <button type="submit" class="p-2 text-red-500 hover:bg-red-50 rounded-lg transition-colors border border-transparent hover:border-red-200" title="Eliminar">
                                        <i data-lucide="trash-2" class="w-4 h-4"></i>
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                @empty
                    <tr><td colspan="5" class="px-6 py-12 text-center text-slate-500 italic">No hay comentarios registrados.</td></tr>
                @endforelse
            </tbody>
        </table>
        <div class="p-4">{{ $comentarios->links() }}</div>
    </div>
@endsection