@extends('layouts.admin')

@section('titulo', 'Revisión de Receta')

@section('contenido')
    <div class="mb-6">
        <a href="/admin/recetas" class="text-slate-500 hover:text-calabaza-600 flex items-center gap-1 text-sm font-medium mb-4 transition-colors">
            <i data-lucide="arrow-left" class="w-4 h-4"></i> Volver al listado
        </a>
    </div>

    <div class="grid md:grid-cols-3 gap-8">
        <!-- Columna Izquierda: Info Principal -->
        <div class="md:col-span-2 space-y-6">
            <!-- Tarjeta Principal -->
            <div class="bg-white p-6 rounded-xl shadow-sm border border-slate-100">
                <div class="flex justify-between items-start mb-4">
                    <h1 class="text-3xl font-bold text-slate-800">Ensalada de Quinoa Vegana</h1>
                    <span class="px-3 py-1 rounded-full text-xs font-medium bg-calabaza-100 text-calabaza-800 border border-calabaza-200">
                        Pendiente de Revisión
                    </span>
                </div>
                
                <p class="text-slate-600 italic border-l-4 border-calabaza-200 pl-4 py-2 mb-6 bg-slate-50 rounded-r-lg">
                    "Una ensalada fresca y llena de proteínas ideal para el verano, perfecta para dietas veganas."
                </p>

                <div class="grid grid-cols-3 gap-4 mb-6">
                    <div class="bg-slate-50 p-3 rounded-lg text-center border border-slate-100">
                        <i data-lucide="clock" class="w-5 h-5 mx-auto text-calabaza-500 mb-1"></i>
                        <span class="text-sm font-medium text-slate-700">20 min</span>
                    </div>
                    <div class="bg-slate-50 p-3 rounded-lg text-center border border-slate-100">
                        <i data-lucide="users" class="w-5 h-5 mx-auto text-calabaza-500 mb-1"></i>
                        <span class="text-sm font-medium text-slate-700">2 porciones</span>
                    </div>
                    <div class="bg-slate-50 p-3 rounded-lg text-center border border-slate-100">
                        <i data-lucide="flame" class="w-5 h-5 mx-auto text-calabaza-500 mb-1"></i>
                        <span class="text-sm font-medium text-slate-700">350 kcal</span>
                    </div>
                </div>

                <h3 class="font-bold text-slate-800 mb-3 flex items-center gap-2">
                    <i data-lucide="list" class="text-calabaza-500 w-5 h-5"></i> Ingredientes
                </h3>
                <ul class="space-y-2 mb-8 border-b border-slate-100 pb-6">
                    <li class="flex justify-between text-sm p-2 bg-slate-50 rounded">
                        <span>Quinoa cocida</span> <span class="font-bold">1 taza</span>
                    </li>
                    <li class="flex justify-between text-sm p-2 rounded">
                        <span>Tomates cherry</span> <span class="font-bold">100 g</span>
                    </li>
                    <li class="flex justify-between text-sm p-2 bg-slate-50 rounded">
                        <span>Aguacate</span> <span class="font-bold">1 unidad</span>
                    </li>
                </ul>

                <h3 class="font-bold text-slate-800 mb-3 flex items-center gap-2">
                    <i data-lucide="chef-hat" class="text-calabaza-500 w-5 h-5"></i> Preparación
                </h3>
                <div class="space-y-4 text-slate-600 text-sm leading-relaxed">
                    <p>1. Lavar muy bien la quinoa bajo el grifo.</p>
                    <p>2. Cocinar en agua hirviendo por 15 minutos hasta que esté tierna.</p>
                    <p>3. Cortar los tomates y el aguacate en cubos pequeños.</p>
                    <p>4. Mezclar todo en un bol y aderezar al gusto.</p>
                </div>
            </div>
        </div>

        <!-- Columna Derecha: Acciones y Multimedia -->
        <div class="space-y-6">
            <!-- Imagen -->
            <div class="bg-white p-4 rounded-xl shadow-sm border border-slate-100">
                <h3 class="font-bold text-sm text-slate-500 uppercase mb-3">Imagen Principal</h3>
                <div class="aspect-square bg-slate-100 rounded-lg flex items-center justify-center text-slate-300">
                    <!-- Aquí iría la etiqueta img -->
                    <i data-lucide="image" class="w-16 h-16"></i>
                </div>
            </div>

            <!-- Panel de Moderación -->
            <div class="bg-white p-6 rounded-xl shadow-lg border border-calabaza-100">
                <h3 class="font-bold text-slate-800 mb-4">Acciones de Moderación</h3>
                <div class="space-y-3">
                    <form action="#" method="POST"> <!-- Ruta Aprobar -->
                        @csrf
                        <button type="submit" class="w-full bg-emerald-600 hover:bg-emerald-700 text-white font-medium py-2.5 px-4 rounded-lg flex items-center justify-center gap-2 transition-colors shadow-lg shadow-emerald-500/20">
                            <i data-lucide="check-circle" class="w-5 h-5"></i>
                            Aprobar y Publicar
                        </button>
                    </form>

                    <button onclick="document.getElementById('rejectForm').classList.toggle('hidden')" class="w-full bg-white border border-red-200 text-red-600 hover:bg-red-50 font-medium py-2.5 px-4 rounded-lg flex items-center justify-center gap-2 transition-colors">
                        <i data-lucide="x-circle" class="w-5 h-5"></i>
                        Rechazar
                    </button>

                    <!-- Formulario de Rechazo (Oculto por defecto) -->
                    <div id="rejectForm" class="hidden mt-4 pt-4 border-t border-slate-100 animate-in fade-in slide-in-from-top-2">
                        <form action="#" method="POST"> <!-- Ruta Rechazar -->
                            @csrf
                            <label class="block text-sm font-medium text-slate-700 mb-2">Motivo del rechazo:</label>
                            <textarea name="reason" rows="3" class="w-full p-3 border border-slate-200 rounded-lg text-sm mb-3 focus:ring-2 focus:ring-red-500 focus:outline-none" placeholder="Explica la razón..."></textarea>
                            <button type="submit" class="w-full bg-red-600 hover:bg-red-700 text-white text-sm font-medium py-2 rounded-lg">
                                Confirmar Rechazo
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection