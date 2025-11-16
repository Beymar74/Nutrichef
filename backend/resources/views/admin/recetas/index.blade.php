@extends('layouts.admin')

@section('titulo', 'Gestión de Recetas')

@section('contenido')
    
    <!-- Mensaje Flash de Éxito -->
    @if(session('success'))
        <div class="mb-6 bg-emerald-50 border border-emerald-200 text-emerald-700 px-4 py-3 rounded-lg flex items-center gap-2 animate-pulse shadow-sm">
            <i data-lucide="check-circle" class="w-5 h-5"></i>
            <span class="font-medium">{{ session('success') }}</span>
        </div>
    @endif

    <!-- Encabezado -->
    <div class="flex flex-col md:flex-row justify-between items-center gap-4 mb-8">
        <div>
            <h1 class="text-2xl font-bold text-slate-800">Listado de Recetas</h1>
            <p class="text-slate-500 text-sm mt-1">Revisa y modera el contenido subido por los chefs.</p>
        </div>
        <div class="flex gap-2">
            <!-- Filtro Rápido de Pendientes -->
            <a href="{{ route('admin.recetas.index', ['estado' => 2]) }}" class="bg-calabaza-50 px-4 py-2 rounded-lg border border-calabaza-200 text-calabaza-800 font-medium flex items-center gap-2 hover:bg-calabaza-100 transition-colors shadow-sm">
                <i data-lucide="clock" class="w-4 h-4"></i>
                <span>Pendientes: <strong>{{ $pendientesCount }}</strong></span>
            </a>
        </div>
    </div>

    <!-- Barra de Busqueda y Filtros -->
    <form method="GET" action="{{ route('admin.recetas.index') }}" class="bg-white p-4 rounded-xl shadow-sm border border-slate-100 mb-6 flex gap-4 items-center">
        <div class="relative flex-1">
            <i data-lucide="search" class="absolute left-3 top-3 text-slate-400 w-5 h-5"></i>
            <input 
                type="text" 
                name="search" 
                value="{{ request('search') }}" 
                placeholder="Buscar receta o autor..." 
                class="w-full pl-10 pr-4 py-2.5 bg-slate-50 border border-slate-200 rounded-lg focus:ring-2 focus:ring-calabaza-500 focus:outline-none transition-all"
            >
        </div>
        
        <!-- Select con Auto-Submit -->
        <div class="relative min-w-[200px]">
            <select 
                name="estado" 
                class="w-full bg-slate-50 border border-slate-200 rounded-lg px-4 py-2.5 text-slate-700 focus:outline-none focus:border-calabaza-500 cursor-pointer font-medium appearance-none pr-10" 
                onchange="this.form.submit()"
            >
                <option value="">Todos los estados</option>
                <option value="2" {{ request('estado') == '2' ? 'selected' : '' }}>Pendiente</option>
                <option value="1" {{ request('estado') == '1' ? 'selected' : '' }}>Publicada</option>
                <option value="3" {{ request('estado') == '3' ? 'selected' : '' }}>Rechazada</option>
            </select>
            <i data-lucide="filter" class="absolute right-3 top-3 text-slate-400 w-4 h-4 pointer-events-none"></i>
        </div>
    </form>

    <!-- Tabla de Datos -->
    <div class="bg-white rounded-xl shadow-sm border border-slate-100 overflow-hidden">
        <table class="w-full text-left border-collapse">
            <thead class="bg-slate-50/80 border-b border-slate-200 text-xs uppercase text-slate-500 font-semibold tracking-wider">
                <tr>
                    <th class="px-6 py-4">Receta</th>
                    <th class="px-6 py-4">Autor</th>
                    <th class="px-6 py-4">Estado</th>
                    <th class="px-6 py-4">Info</th>
                    <th class="px-6 py-4 text-right">Acciones</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-slate-100">
                @forelse($recetas as $receta)
                    <tr class="hover:bg-slate-50/60 transition-colors group">
                        
                        <!-- Columna Receta -->
                        <td class="px-6 py-4">
                            <div class="flex items-center gap-4">
                                <div class="w-12 h-12 rounded-lg bg-slate-100 flex items-center justify-center text-slate-300 overflow-hidden relative shrink-0 border border-slate-200 shadow-sm">
                                    @php $imagen = $receta->multimedia->first(); @endphp
                                    @if($imagen && $imagen->archivo)
                                        @if(\Illuminate\Support\Str::startsWith($imagen->archivo, 'http'))
                                            <img src="{{ $imagen->archivo }}" alt="Img" class="w-full h-full object-cover">
                                        @else
                                            <img src="{{ asset('storage/' . $imagen->archivo) }}" alt="Img" class="w-full h-full object-cover">
                                        @endif
                                    @else
                                        <i data-lucide="image" class="w-6 h-6"></i>
                                    @endif
                                </div>
                                <div>
                                    <p class="font-semibold text-slate-800 line-clamp-1 text-sm" title="{{ $receta->titulo }}">{{ $receta->titulo }}</p>
                                    <div class="flex items-center gap-2 mt-1">
                                        <span class="text-xs text-slate-500 bg-slate-100 px-2 py-0.5 rounded border border-slate-200">
                                            {{ $receta->tipoAlimento->descripcion ?? 'General' }}
                                        </span>
                                        <span class="text-xs text-slate-400 flex items-center gap-1">
                                            <i data-lucide="clock" class="w-3 h-3"></i> {{ $receta->tiempo_preparacion }}m
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </td>

                        <!-- Columna Autor -->
                        <td class="px-6 py-4 text-sm">
                            <div class="flex flex-col">
                                <span class="font-medium text-slate-700">{{ $receta->creador->name ?? 'Desconocido' }}</span>
                                <span class="text-xs text-slate-400">{{ $receta->creador->email ?? '' }}</span>
                            </div>
                        </td>

                        <!-- Columna Estado -->
                        <td class="px-6 py-4">
                            @php
                                $desc = strtoupper($receta->estado->descripcion ?? 'Borrador');
                                $clase = match(true) {
                                    $desc === 'PUBLICADA' => 'bg-emerald-50 text-emerald-700 border-emerald-200',
                                    in_array($desc, ['PENDIENTE', 'PENDIENTE_REVISION']) => 'bg-calabaza-50 text-calabaza-700 border-calabaza-200',
                                    $desc === 'RECHAZADA' => 'bg-red-50 text-red-700 border-red-200',
                                    default => 'bg-slate-50 text-slate-600 border-slate-200'
                                };
                                $dotColor = match(true) {
                                    $desc === 'PUBLICADA' => 'bg-emerald-500',
                                    in_array($desc, ['PENDIENTE', 'PENDIENTE_REVISION']) => 'bg-calabaza-500',
                                    $desc === 'RECHAZADA' => 'bg-red-500',
                                    default => 'bg-slate-400'
                                };
                            @endphp
                            <span class="px-3 py-1 rounded-full text-xs font-semibold border {{ $clase }} flex items-center gap-2 w-fit whitespace-nowrap shadow-sm">
                                <span class="w-1.5 h-1.5 rounded-full {{ $dotColor }}"></span>
                                {{ ucfirst(strtolower($desc)) }}
                            </span>
                        </td>

                        <!-- Columna Info -->
                        <td class="px-6 py-4 text-sm text-slate-500">
                            <div class="flex flex-col gap-1">
                                <span class="flex items-center gap-1 text-xs"><i data-lucide="flame" class="w-3 h-3 text-calabaza-400"></i> {{ $receta->calorias ?? '--' }} kcal</span>
                                <span class="flex items-center gap-1 text-xs"><i data-lucide="users" class="w-3 h-3 text-slate-400"></i> {{ $receta->porciones_estimadas }} p.</span>
                            </div>
                        </td>

                        <!-- BOTONES DE ACCIÓN -->
                        <td class="px-6 py-4 text-right">
                            <div class="flex justify-end gap-2 items-center">
                                <!-- Ver -->
                                <a href="{{ route('admin.recetas.show', $receta->id) }}" class="p-2 bg-white border border-slate-200 text-slate-500 hover:text-calabaza-600 hover:border-calabaza-200 hover:bg-calabaza-50 rounded-lg transition-all shadow-sm" title="Ver Detalle">
                                    <i data-lucide="eye" class="w-4 h-4"></i>
                                </a>

                                <!-- Editar -->
                                <a href="{{ route('admin.recetas.edit', $receta->id) }}" class="p-2 bg-white border border-slate-200 text-slate-500 hover:text-blue-600 hover:border-blue-200 hover:bg-blue-50 rounded-lg transition-all shadow-sm" title="Editar">
                                    <i data-lucide="edit-2" class="w-4 h-4"></i>
                                </a>
                                
                                <!-- Eliminar (Trigger Modal) -->
                                <button 
                                    type="button" 
                                    onclick="openModal('deleteModal', '{{ route('admin.recetas.destroy', $receta->id) }}')"
                                    class="p-2 bg-white border border-slate-200 text-slate-500 hover:text-red-600 hover:border-red-200 hover:bg-red-50 rounded-lg transition-all shadow-sm"
                                    title="Eliminar"
                                >
                                    <i data-lucide="trash-2" class="w-4 h-4"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="5" class="px-6 py-16 text-center">
                            <div class="flex flex-col items-center justify-center text-slate-400">
                                <div class="bg-slate-50 p-4 rounded-full mb-4 border border-slate-100 shadow-sm">
                                    <i data-lucide="chef-hat" class="w-10 h-10 text-slate-300"></i>
                                </div>
                                <p class="text-lg font-semibold text-slate-600">No se encontraron recetas</p>
                                <p class="text-sm text-slate-400 mt-1">Intenta ajustar los filtros de búsqueda.</p>
                                @if(request('search') || request('estado'))
                                    <a href="{{ route('admin.recetas.index') }}" class="mt-4 text-sm text-calabaza-600 hover:text-calabaza-700 hover:underline font-medium flex items-center gap-1">
                                        <i data-lucide="x" class="w-3 h-3"></i> Limpiar filtros
                                    </a>
                                @endif
                            </div>
                        </td>
                    </tr>
                @endforelse
            </tbody>
        </table>
    </div>

    <!-- Paginación -->
    <div class="mt-6">
        {{ $recetas->appends(request()->query())->links() }}
    </div>

    <!-- MODAL COMPONENTE -->
    <x-modal-confirm 
        id="deleteModal"
        title="Eliminar Receta"
        message="¿Estás seguro de que deseas eliminar esta receta permanentemente? Esta acción no se puede deshacer."
        action="#" 
        confirmText="Sí, eliminar"
    />

@endsection