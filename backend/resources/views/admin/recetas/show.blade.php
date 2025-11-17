@extends('layouts.admin')

@section('titulo', 'Revisión de Receta')

@section('contenido')
    
    <!-- Mensaje Flash -->
    @if(session('success'))
        <div class="mb-6 bg-emerald-50 border border-emerald-200 text-emerald-700 px-4 py-3 rounded-lg flex items-center gap-2 animate-pulse shadow-sm">
            <i data-lucide="check-circle" class="w-5 h-5"></i>
            <span class="font-medium">{{ session('success') }}</span>
        </div>
    @endif

    <div class="mb-6">
        <a href="{{ route('admin.recetas.index') }}" class="text-slate-500 hover:text-calabaza-600 flex items-center gap-1 text-sm font-medium mb-4 transition-colors w-fit">
            <i data-lucide="arrow-left" class="w-4 h-4"></i> Volver al listado
        </a>
    </div>

    <div class="grid md:grid-cols-3 gap-8">
        <!-- Columna Izquierda: Info Principal -->
        <div class="md:col-span-2 space-y-6">
            <!-- Tarjeta Principal -->
            <div class="bg-white p-8 rounded-xl shadow-sm border border-slate-100">
                
                <div class="flex justify-between items-start mb-6">
                    <h1 class="text-3xl font-bold text-slate-900 leading-tight">{{ $receta->titulo }}</h1>
                    
                    <!-- Badge de Estado Dinámico -->
                    @php
                        $descEstado = strtoupper($receta->estado->descripcion ?? 'Borrador');
                        $claseEstado = match(true) {
                            $descEstado === 'PUBLICADA' => 'bg-emerald-100 text-emerald-700 border-emerald-200',
                            in_array($descEstado, ['PENDIENTE', 'PENDIENTE_REVISION']) => 'bg-calabaza-100 text-calabaza-800 border-calabaza-200',
                            $descEstado === 'RECHAZADA' => 'bg-red-100 text-red-700 border-red-200',
                            default => 'bg-slate-100 text-slate-700 border-slate-200'
                        };
                    @endphp
                    <span class="px-4 py-1.5 rounded-full text-sm font-semibold border {{ $claseEstado }} shadow-sm">
                        {{ ucfirst(strtolower($descEstado)) }}
                    </span>
                </div>
                
                <div class="bg-slate-50 border-l-4 border-calabaza-400 p-4 rounded-r-lg mb-8 italic text-slate-600">
                    "{{ $receta->resumen }}"
                </div>

                <!-- Métricas Rápidas -->
                <div class="grid grid-cols-3 gap-6 mb-8">
                    <div class="flex flex-col items-center justify-center p-4 bg-white border border-slate-100 rounded-xl shadow-sm">
                        <div class="bg-calabaza-50 p-2 rounded-full mb-2">
                            <i data-lucide="clock" class="w-6 h-6 text-calabaza-500"></i>
                        </div>
                        <span class="text-lg font-bold text-slate-800">{{ $receta->tiempo_preparacion }} min</span>
                        <span class="text-xs text-slate-500 uppercase tracking-wide">Tiempo</span>
                    </div>
                    <div class="flex flex-col items-center justify-center p-4 bg-white border border-slate-100 rounded-xl shadow-sm">
                        <div class="bg-calabaza-50 p-2 rounded-full mb-2">
                            <i data-lucide="users" class="w-6 h-6 text-calabaza-500"></i>
                        </div>
                        <span class="text-lg font-bold text-slate-800">{{ $receta->porciones_estimadas }}</span>
                        <span class="text-xs text-slate-500 uppercase tracking-wide">Porciones</span>
                    </div>
                    <div class="flex flex-col items-center justify-center p-4 bg-white border border-slate-100 rounded-xl shadow-sm">
                        <div class="bg-calabaza-50 p-2 rounded-full mb-2">
                            <i data-lucide="flame" class="w-6 h-6 text-calabaza-500"></i>
                        </div>
                        <span class="text-lg font-bold text-slate-800">{{ $receta->calorias ?? '---' }}</span>
                        <span class="text-xs text-slate-500 uppercase tracking-wide">Kcal</span>
                    </div>
                </div>

                <div class="space-y-8">
                    <!-- Ingredientes -->
                    <div>
                        <h3 class="text-lg font-bold text-slate-800 mb-4 flex items-center gap-2">
                            <i data-lucide="list" class="text-calabaza-500 w-5 h-5"></i> Ingredientes
                        </h3>
                        <div class="bg-slate-50 rounded-xl border border-slate-100 overflow-hidden">
                            @forelse($receta->ingredientesReceta as $ir)
                                <div class="flex justify-between items-center p-3 border-b border-slate-100 last:border-0 hover:bg-white transition-colors">
                                    <!-- Accedemos a la relación 'ingrediente' y luego a su campo 'descripcion' -->
                                    <span class="text-slate-700 font-medium">
                                        {{ $ir->ingrediente->descripcion ?? 'Ingrediente desconocido' }}
                                    </span>
                                    
                                    <span class="text-sm font-bold text-slate-900 bg-white px-2 py-1 rounded border border-slate-200 shadow-sm">
                                        {{-- Muestra cantidad y unidad --}}
                                        {{ $ir->cantidad }} {{ $ir->unidadMedida->descripcion ?? '' }}
                                    </span>
                                </div>
                            @empty
                                <div class="p-4 text-center text-slate-500 italic">No hay ingredientes registrados.</div>
                            @endforelse
                        </div>
                    </div>

                    <!-- Preparación -->
                    <div>
                        <h3 class="text-lg font-bold text-slate-800 mb-4 flex items-center gap-2">
                            <i data-lucide="chef-hat" class="text-calabaza-500 w-5 h-5"></i> Preparación
                        </h3>
                        <div class="prose prose-slate max-w-none text-slate-600 bg-slate-50 p-6 rounded-xl border border-slate-100">
                            {!! nl2br(e($receta->preparacion)) !!}
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Columna Derecha: Multimedia y Acciones -->
        <div class="space-y-6">
            
            <!-- Panel de Imagen -->
            <div class="bg-white p-5 rounded-xl shadow-sm border border-slate-100">
                <h3 class="font-bold text-xs text-slate-500 uppercase tracking-wider mb-4 border-b border-slate-100 pb-2">Imagen Principal</h3>
                <div class="aspect-square bg-slate-100 rounded-lg flex items-center justify-center text-slate-300 overflow-hidden relative group border border-slate-200">
                    @php
                        $imagen = $receta->multimedia->where('tipo_archivo', 'image')->first() 
                               ?? $receta->multimedia->where('tipo_archivo', 'imagen')->first();
                    @endphp

                    @if($imagen && $imagen->archivo)
                        @if(\Illuminate\Support\Str::startsWith($imagen->archivo, 'http'))
                            <img src="{{ $imagen->archivo }}" alt="Plato" class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105">
                        @else
                            <img src="{{ asset('storage/' . $imagen->archivo) }}" alt="Plato" class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105">
                        @endif
                    @else
                        <div class="flex flex-col items-center gap-2">
                            <i data-lucide="image" class="w-12 h-12 opacity-50"></i>
                            <span class="text-xs font-medium opacity-50">Sin imagen</span>
                        </div>
                    @endif
                </div>
            </div>

            <!-- Panel de Autor -->
            <div class="bg-white p-5 rounded-xl shadow-sm border border-slate-100">
                <h3 class="font-bold text-xs text-slate-500 uppercase tracking-wider mb-4 border-b border-slate-100 pb-2">Autor</h3>
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-full bg-calabaza-100 flex items-center justify-center text-calabaza-700 font-bold border border-calabaza-200">
                        {{ substr($receta->creador->name ?? 'U', 0, 1) }}
                    </div>
                    <div>
                        <p class="text-sm font-bold text-slate-800">{{ $receta->creador->name ?? 'Desconocido' }}</p>
                        <p class="text-xs text-slate-500">{{ $receta->creador->email ?? '' }}</p>
                    </div>
                </div>
            </div>

            <!-- Panel de Moderación (Sticky) -->
            <div class="bg-white p-6 rounded-xl shadow-lg border border-calabaza-100 sticky top-24">
                <h3 class="font-bold text-slate-800 mb-4 flex items-center gap-2">
                    <i data-lucide="shield-check" class="w-5 h-5 text-calabaza-500"></i> Acciones de Moderación
                </h3>
                
                <div class="space-y-3">
                    <!-- Botón APROBAR -->
                    <form action="{{ route('admin.recetas.approve', $receta->id) }}" method="POST">
                        @csrf
                        <button type="submit" class="w-full bg-emerald-600 hover:bg-emerald-700 text-white font-semibold py-3 px-4 rounded-lg flex items-center justify-center gap-2 transition-all shadow-md shadow-emerald-500/20 transform hover:-translate-y-0.5">
                            <i data-lucide="check-circle" class="w-5 h-5"></i>
                            Aprobar y Publicar
                        </button>
                    </form>

                    <!-- Botón RECHAZAR (Toggle) -->
                    <button onclick="document.getElementById('rejectForm').classList.toggle('hidden')" class="w-full bg-white border-2 border-red-100 text-red-600 hover:bg-red-50 hover:border-red-200 font-semibold py-3 px-4 rounded-lg flex items-center justify-center gap-2 transition-all">
                        <i data-lucide="x-circle" class="w-5 h-5"></i>
                        Rechazar
                    </button>

                    <!-- Formulario de Rechazo (Oculto) -->
                    <div id="rejectForm" class="hidden mt-4 pt-4 border-t border-slate-100 animate-in slide-in-from-top-2 fade-in duration-200">
                        <form action="{{ route('admin.recetas.reject', $receta->id) }}" method="POST">
                            @csrf
                            <label class="block text-xs font-bold text-slate-700 mb-2 uppercase">Motivo del rechazo:</label>
                            <textarea 
                                name="reason" 
                                rows="3" 
                                class="w-full p-3 border border-slate-200 rounded-lg text-sm mb-3 focus:ring-2 focus:ring-red-500/20 focus:border-red-500 focus:outline-none resize-none bg-slate-50" 
                                placeholder="Explica brevemente la razón..."
                                required
                            ></textarea>
                            <button type="submit" class="w-full bg-red-600 hover:bg-red-700 text-white text-sm font-semibold py-2 rounded-lg shadow-sm transition-colors">
                                Confirmar Rechazo
                            </button>
                        </form>
                    </div>
                </div>
            </div>

        </div>
    </div>
@endsection