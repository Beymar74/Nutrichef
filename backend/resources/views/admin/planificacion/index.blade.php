@extends('layouts.admin')

@section('titulo', 'Planificación Global')
@section('titulo_pagina', 'Monitoreo de Comidas')

@section('contenido')
    <div class="bg-white rounded-xl shadow-sm border border-slate-100 overflow-hidden">
        <div class="p-6 border-b border-slate-100 bg-slate-50/50 flex justify-between items-center">
            <div>
                <h2 class="text-lg font-bold text-slate-800">Registro de Planificaciones</h2>
                <p class="text-sm text-slate-500">Historial reciente de comidas programadas por los usuarios.</p>
            </div>
        </div>
        
        <table class="w-full text-left border-collapse">
            <thead class="bg-slate-50/80 border-b border-slate-200 text-xs uppercase text-slate-500 font-semibold">
                <tr>
                    <th class="px-6 py-4">Usuario</th>
                    <th class="px-6 py-4">Receta Planificada</th>
                    <th class="px-6 py-4">Horario</th>
                    <th class="px-6 py-4">Día/Fecha</th>
                    <th class="px-6 py-4">Creado</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-slate-100">
                @forelse($planificaciones as $plan)
                    <tr class="hover:bg-slate-50/50 transition-colors">
                        <td class="px-6 py-4 font-medium text-slate-700">
                            {{ $plan->usuario->name ?? 'Usuario Eliminado' }}
                        </td>
                        <td class="px-6 py-4">
                            <a href="{{ route('admin.recetas.show', $plan->id_receta) }}" class="text-calabaza-600 hover:underline font-medium">
                                {{ $plan->receta->titulo ?? 'Receta Eliminada' }}
                            </a>
                        </td>
                        <td class="px-6 py-4 text-sm text-slate-600">
                            <span class="bg-slate-100 px-2 py-1 rounded text-xs font-bold border border-slate-200">
                                {{ $plan->horario->descripcion ?? 'General' }}
                            </span>
                        </td>
                        <td class="px-6 py-4 text-sm text-slate-600">
                            @php $dias = [1=>'Lunes', 2=>'Martes', 3=>'Miércoles', 4=>'Jueves', 5=>'Viernes', 6=>'Sábado', 7=>'Domingo']; @endphp
                            {{ $dias[$plan->dia_semana] ?? 'Día ' . $plan->dia_semana }}
                        </td>
                        <td class="px-6 py-4 text-xs text-slate-400">
                            {{ $plan->created_at->diffForHumans() }}
                        </td>
                    </tr>
                @empty
                    <tr><td colspan="5" class="px-6 py-12 text-center text-slate-500 italic">No hay planificaciones registradas aún.</td></tr>
                @endforelse
            </tbody>
        </table>
        <div class="p-4">{{ $planificaciones->links() }}</div>
    </div>
@endsection