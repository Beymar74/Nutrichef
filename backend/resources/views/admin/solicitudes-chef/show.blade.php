@extends('layouts.admin')

@section('titulo', 'Revisión de Solicitud')

@section('contenido')
    
    <!-- Mensajes Flash -->
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

    <div class="mb-6">
        <a href="{{ route('admin.solicitudes.index') }}" class="text-slate-500 hover:text-calabaza-600 flex items-center gap-1 text-sm font-medium mb-4 transition-colors w-fit">
            <i data-lucide="arrow-left" class="w-4 h-4"></i> Volver al listado
        </a>
    </div>

    <div class="grid md:grid-cols-3 gap-8">
        
        <!-- Columna Izquierda: Información Principal -->
        <div class="md:col-span-2 space-y-6">
            <div class="bg-white p-8 rounded-xl shadow-sm border border-slate-100">
                
                <!-- Encabezado -->
                <div class="flex justify-between items-start mb-6">
                    <h1 class="text-3xl font-bold text-slate-900">Solicitud de Chef</h1>
                    
                    @php
                        $estadoDesc = strtoupper($solicitud->estado->descripcion ?? 'PENDIENTE');
                        $configs = [
                            'PENDIENTE' => ['clase' => 'bg-calabaza-100 text-calabaza-800 border-calabaza-200'],
                            'APROBADA' => ['clase' => 'bg-emerald-100 text-emerald-700 border-emerald-200'],
                            'RECHAZADA' => ['clase' => 'bg-red-100 text-red-700 border-red-200'],
                        ];
                        $config = $configs[$estadoDesc] ?? ['clase' => 'bg-slate-100 text-slate-700 border-slate-200'];
                    @endphp
                    <span class="px-4 py-1.5 rounded-full text-sm font-semibold border {{ $config['clase'] }} shadow-sm">
                        {{ ucfirst(strtolower($estadoDesc)) }}
                    </span>
                </div>

                <!-- Información del Usuario -->
                <div class="bg-slate-50 rounded-xl p-6 mb-6 border border-slate-100">
                    <div class="flex items-center gap-4 mb-4">
                        <div class="w-16 h-16 rounded-full bg-calabaza-100 flex items-center justify-center text-calabaza-700 font-bold text-2xl border-2 border-calabaza-200 shadow-md">
                            {{ substr($solicitud->usuario->name ?? 'U', 0, 1) }}
                        </div>
                        <div>
                            <h3 class="text-xl font-bold text-slate-800">{{ $solicitud->usuario->name ?? 'Desconocido' }}</h3>
                            <p class="text-sm text-slate-500">{{ $solicitud->usuario->email ?? '' }}</p>
                            <p class="text-xs text-slate-400 mt-1">
                                <i data-lucide="calendar" class="w-3 h-3 inline"></i> 
                                Solicitud enviada el {{ $solicitud->created_at->format('d/m/Y H:i') }}
                            </p>
                        </div>
                    </div>
                </div>

                <!-- Motivo -->
                <div class="mb-6">
                    <h3 class="text-lg font-bold text-slate-800 mb-3 flex items-center gap-2">
                        <i data-lucide="message-square" class="text-calabaza-500 w-5 h-5"></i> Motivo de la Solicitud
                    </h3>
                    <div class="bg-slate-50 rounded-xl p-5 border border-slate-100">
                        <p class="text-slate-700 leading-relaxed">
                            {{ $solicitud->motivo ?? 'No especificado' }}
                        </p>
                    </div>
                </div>

                <!-- Experiencia -->
                @if($solicitud->experiencia)
                <div class="mb-6">
                    <h3 class="text-lg font-bold text-slate-800 mb-3 flex items-center gap-2">
                        <i data-lucide="award" class="text-calabaza-500 w-5 h-5"></i> Experiencia Culinaria
                    </h3>
                    <div class="bg-slate-50 rounded-xl p-5 border border-slate-100">
                        <p class="text-slate-700 leading-relaxed">
                            {{ $solicitud->experiencia }}
                        </p>
                    </div>
                </div>
                @endif

                <!-- Comentario del Admin (si existe) -->
                @if($solicitud->comentario_admin)
                <div class="mb-6">
                    <h3 class="text-lg font-bold text-slate-800 mb-3 flex items-center gap-2">
                        <i data-lucide="shield-check" class="text-blue-500 w-5 h-5"></i> Observaciones del Administrador
                    </h3>
                    <div class="bg-blue-50 rounded-xl p-5 border border-blue-200">
                        <p class="text-slate-700 leading-relaxed italic">
                            "{{ $solicitud->comentario_admin }}"
                        </p>
                        @if($solicitud->revisor)
                            <p class="text-xs text-slate-500 mt-3">
                                — Revisado por <strong>{{ $solicitud->revisor->name }}</strong> 
                                el {{ $solicitud->fecha_revision?->format('d/m/Y H:i') }}
                            </p>
                        @endif
                    </div>
                </div>
                @endif

            </div>
        </div>

        <!-- Columna Derecha: Panel de Moderación -->
        <div class="space-y-6">
            
            <!-- Panel de Acciones (Sticky) -->
            <div class="bg-white p-6 rounded-xl shadow-lg border border-calabaza-100 sticky top-24">
                <h3 class="font-bold text-slate-800 mb-4 flex items-center gap-2">
                    <i data-lucide="shield-check" class="w-5 h-5 text-calabaza-500"></i> Acciones de Moderación
                </h3>
                
                @php
                    $estaPendiente = strtoupper($solicitud->estado->descripcion ?? '') === 'PENDIENTE';
                    $estaAprobada = strtoupper($solicitud->estado->descripcion ?? '') === 'APROBADA';
                    $estaRechazada = strtoupper($solicitud->estado->descripcion ?? '') === 'RECHAZADA';
                @endphp

                @if($estaPendiente)
                    <!-- ✅ SOLO MOSTRAR BOTONES SI ESTÁ PENDIENTE -->
                    <div class="space-y-3">
                        
                        <!-- Botón APROBAR -->
                        <form action="{{ route('admin.solicitudes.approve', $solicitud->id) }}" method="POST" id="approveForm">
                            @csrf
                            <textarea 
                                name="comentario_admin" 
                                placeholder="Comentario opcional (ej: Bienvenido al equipo de chefs)..." 
                                class="w-full mb-3 p-3 border border-slate-200 rounded-lg text-sm focus:ring-2 focus:ring-emerald-500 focus:outline-none"
                                rows="2"
                            ></textarea>
                            <button 
                                type="submit" 
                                onclick="return confirm('¿Estás seguro de aprobar esta solicitud? El usuario se convertirá en Chef.')"
                                class="w-full bg-emerald-600 hover:bg-emerald-700 text-white font-semibold py-3 px-4 rounded-lg flex items-center justify-center gap-2 transition-all shadow-md shadow-emerald-500/20 transform hover:-translate-y-0.5"
                            >
                                <i data-lucide="user-check" class="w-5 h-5"></i>
                                Aprobar y Convertir en Chef
                            </button>
                        </form>

                        <!-- Botón RECHAZAR (Toggle) -->
                        <button 
                            onclick="document.getElementById('rejectForm').classList.toggle('hidden')" 
                            class="w-full bg-white border-2 border-red-100 text-red-600 hover:bg-red-50 hover:border-red-200 font-semibold py-3 px-4 rounded-lg flex items-center justify-center gap-2 transition-all"
                        >
                            <i data-lucide="x-circle" class="w-5 h-5"></i>
                            Rechazar Solicitud
                        </button>

                        <!-- Formulario de Rechazo -->
                        <div id="rejectForm" class="hidden mt-4 pt-4 border-t border-slate-100">
                            <form action="{{ route('admin.solicitudes.reject', $solicitud->id) }}" method="POST">
                                @csrf
                                <label class="block text-xs font-bold text-slate-700 mb-2 uppercase">Motivo del Rechazo:</label>
                                <textarea 
                                    name="comentario_admin" 
                                    placeholder="Explica por qué se rechaza (mínimo 10 caracteres)..." 
                                    class="w-full mb-3 p-3 border border-slate-200 rounded-lg text-sm focus:ring-2 focus:ring-red-500 focus:outline-none"
                                    rows="3"
                                    required
                                    minlength="10"
                                ></textarea>
                                <button 
                                    type="submit" 
                                    onclick="return confirm('¿Confirmas el rechazo de esta solicitud?')"
                                    class="w-full bg-red-600 hover:bg-red-700 text-white text-sm font-semibold py-2 rounded-lg shadow-sm transition-colors"
                                >
                                    Confirmar Rechazo
                                </button>
                            </form>
                        </div>
                        
                    </div>
                @else
                    <!-- ✅ MENSAJE SI YA FUE REVISADA -->
                    <div class="bg-slate-50 rounded-lg p-4 border border-slate-200 text-center">
                        <i data-lucide="info" class="w-8 h-8 mx-auto mb-2 text-slate-400"></i>
                        <p class="text-sm text-slate-600 font-medium">
                            Esta solicitud ya fue 
                            @if($estaAprobada)
                                <span class="text-emerald-600 font-bold">aprobada</span>
                            @elseif($estaRechazada)
                                <span class="text-red-600 font-bold">rechazada</span>
                            @else
                                revisada
                            @endif
                        </p>
                    </div>
                @endif

                <!-- Botón ELIMINAR (siempre visible) -->
                <button 
                    onclick="openModal('deleteModal', '{{ route('admin.solicitudes.destroy', $solicitud->id) }}')" 
                    class="w-full mt-6 pt-4 border-t border-slate-100 flex justify-center items-center py-2 px-4 text-sm font-medium rounded-xl text-slate-400 hover:text-red-600 transition-colors"
                >
                    <i data-lucide="trash-2" class="w-4 h-4 mr-2"></i>
                    Eliminar solicitud
                </button>
            </div>

        </div>
    </div>
    
    <!-- Modal Confirmación -->
    <x-modal-confirm 
        id="deleteModal"
        title="Eliminar Solicitud"
        message="¿Estás seguro? Esta acción eliminará permanentemente la solicitud."
        action="#" 
        confirmText="Sí, eliminar"
    />

@endsection