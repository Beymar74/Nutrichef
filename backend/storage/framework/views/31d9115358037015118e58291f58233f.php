<?php $__env->startSection('titulo', 'Revisión de Receta'); ?>
<?php $__env->startSection('titulo_pagina', 'Moderación de Contenido'); ?>

<?php $__env->startSection('contenido'); ?>
    
    <!-- Mensaje Flash -->
    <?php if(session('success')): ?>
        <div class="mb-6 bg-emerald-50 border border-emerald-200 text-emerald-700 px-4 py-3 rounded-lg flex items-center gap-2 animate-pulse shadow-sm">
            <i data-lucide="check-circle" class="w-5 h-5"></i>
            <span class="font-medium"><?php echo e(session('success')); ?></span>
        </div>
    <?php endif; ?>
    
    <?php if(session('error')): ?>
        <div class="mb-6 bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-lg flex items-center gap-2 shadow-sm">
            <i data-lucide="alert-circle" class="w-5 h-5"></i>
            <span class="font-medium"><?php echo e(session('error')); ?></span>
        </div>
    <?php endif; ?>

    <div class="mb-6">
        <a href="<?php echo e(route('admin.recetas.index')); ?>" class="text-slate-500 hover:text-calabaza-600 flex items-center gap-1 text-sm font-medium mb-4 transition-colors w-fit">
            <i data-lucide="arrow-left" class="w-4 h-4"></i> Volver al listado
        </a>
    </div>

    <div class="grid md:grid-cols-3 gap-8">
        <!-- Columna Izquierda: Info Principal -->
        <div class="md:col-span-2 space-y-6">
            <!-- Tarjeta Principal -->
            <div class="bg-white p-8 rounded-xl shadow-sm border border-slate-100">
                
                <div class="flex justify-between items-start mb-6">
                    <h1 class="text-3xl font-bold text-slate-900 leading-tight"><?php echo e($receta->titulo); ?></h1>
                    
                    <!-- Badge de Estado Dinámico (Sincronizado con Controlador) -->
                    <?php
                        $descEstado = strtoupper($receta->estado->descripcion ?? 'PENDIENTE');
                        
                        // Lógica ajustada a tu Controlador:
                        // BORRADOR = Aprobada (Verde)
                        // PENDIENTE = Pendiente (Naranja)
                        // OCULTA = Rechazada (Rojo)
                        $claseEstado = match($descEstado) {
                            'BORRADOR' => 'bg-emerald-100 text-emerald-700 border-emerald-200',
                            'PENDIENTE' => 'bg-calabaza-100 text-calabaza-800 border-calabaza-200',
                            'OCULTA' => 'bg-red-100 text-red-700 border-red-200',
                            'PUBLICADA' => 'bg-blue-100 text-blue-700 border-blue-200', // Por si acaso existe real
                            'ELIMINADA' => 'bg-gray-100 text-gray-700 border-gray-200',
                            default => 'bg-slate-100 text-slate-700 border-slate-200'
                        };

                        // Texto legible para el humano (Mapeo visual)
                        $textoEstado = match($descEstado) {
                            'BORRADOR' => 'Aprobada',
                            'PENDIENTE' => 'Pendiente',
                            'OCULTA' => 'Rechazada',
                            default => ucfirst(strtolower($descEstado))
                        };
                    ?>
                    <span class="px-4 py-1.5 rounded-full text-sm font-semibold border <?php echo e($claseEstado); ?> shadow-sm">
                        <?php echo e($textoEstado); ?>

                    </span>
                </div>
                
                <div class="bg-slate-50 border-l-4 border-calabaza-400 p-4 rounded-r-lg mb-8 italic text-slate-600">
                    "<?php echo e($receta->resumen ?? 'Sin resumen disponible.'); ?>"
                </div>

                <!-- Métricas Rápidas -->
                <div class="grid grid-cols-3 gap-6 mb-8">
                    <div class="flex flex-col items-center justify-center p-4 bg-white border border-slate-100 rounded-xl shadow-sm">
                        <div class="bg-calabaza-50 p-2 rounded-full mb-2">
                            <i data-lucide="clock" class="w-6 h-6 text-calabaza-500"></i>
                        </div>
                        <span class="text-lg font-bold text-slate-800"><?php echo e($receta->tiempo_preparacion); ?> min</span>
                        <span class="text-xs text-slate-500 uppercase tracking-wide">Tiempo</span>
                    </div>
                    <div class="flex flex-col items-center justify-center p-4 bg-white border border-slate-100 rounded-xl shadow-sm">
                        <div class="bg-calabaza-50 p-2 rounded-full mb-2">
                            <i data-lucide="users" class="w-6 h-6 text-calabaza-500"></i>
                        </div>
                        <span class="text-lg font-bold text-slate-800"><?php echo e($receta->porciones_estimadas); ?></span>
                        <span class="text-xs text-slate-500 uppercase tracking-wide">Porciones</span>
                    </div>
                    <div class="flex flex-col items-center justify-center p-4 bg-white border border-slate-100 rounded-xl shadow-sm">
                        <div class="bg-calabaza-50 p-2 rounded-full mb-2">
                            <i data-lucide="flame" class="w-6 h-6 text-calabaza-500"></i>
                        </div>
                        <span class="text-lg font-bold text-slate-800"><?php echo e($receta->calorias ?? '---'); ?></span>
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
                            <?php $__empty_1 = true; $__currentLoopData = $receta->ingredientesReceta; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $ir): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
                                <div class="flex justify-between items-center p-3 border-b border-slate-100 last:border-0 hover:bg-white transition-colors">
                                    <span class="text-slate-700 font-medium">
                                        <?php echo e($ir->ingrediente->descripcion ?? 'Ingrediente desconocido'); ?>

                                    </span>
                                    
                                    <span class="text-sm font-bold text-slate-900 bg-white px-2 py-1 rounded border border-slate-200 shadow-sm">
                                        <?php echo e($ir->cantidad); ?> <?php echo e($ir->unidadMedida->descripcion ?? ''); ?>

                                    </span>
                                </div>
                            <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
                                <div class="p-4 text-center text-slate-500 italic">No hay ingredientes registrados.</div>
                            <?php endif; ?>
                        </div>
                    </div>

                    <!-- Preparación -->
                    <div>
                        <h3 class="text-lg font-bold text-slate-800 mb-4 flex items-center gap-2">
                            <i data-lucide="chef-hat" class="text-calabaza-500 w-5 h-5"></i> Preparación
                        </h3>
                        <div class="prose prose-slate max-w-none text-slate-600 bg-slate-50 p-6 rounded-xl border border-slate-100">
                            <?php echo nl2br(e($receta->preparacion)); ?>

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
                    <?php
                        $imagen = $receta->multimedia->first();
                    ?>

                    <?php if($imagen && $imagen->archivo): ?>
                        <?php if(\Illuminate\Support\Str::startsWith($imagen->archivo, 'http')): ?>
                            <img src="<?php echo e($imagen->archivo); ?>" alt="Plato" class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105">
                        <?php else: ?>
                            <img src="<?php echo e(asset('storage/' . $imagen->archivo)); ?>" alt="Plato" class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105">
                        <?php endif; ?>
                    <?php else: ?>
                        <div class="flex flex-col items-center gap-2">
                            <i data-lucide="image" class="w-12 h-12 opacity-50"></i>
                            <span class="text-xs font-medium opacity-50">Sin imagen</span>
                        </div>
                    <?php endif; ?>
                </div>
            </div>

            <!-- Panel de Autor -->
            <div class="bg-white p-5 rounded-xl shadow-sm border border-slate-100">
                <h3 class="font-bold text-xs text-slate-500 uppercase tracking-wider mb-4 border-b border-slate-100 pb-2">Autor</h3>
                <div class="flex items-center gap-3">
                    <div class="w-10 h-10 rounded-full bg-calabaza-100 flex items-center justify-center text-calabaza-700 font-bold border border-calabaza-200">
                        <?php echo e(substr($receta->creador->name ?? 'U', 0, 1)); ?>

                    </div>
                    <div>
                        <p class="text-sm font-bold text-slate-800"><?php echo e($receta->creador->name ?? 'Desconocido'); ?></p>
                        <p class="text-xs text-slate-500"><?php echo e($receta->creador->email ?? ''); ?></p>
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
                    <form action="<?php echo e(route('admin.recetas.approve', $receta->id)); ?>" method="POST">
                        <?php echo csrf_field(); ?>
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

                    <!-- Formulario de Rechazo -->
                    <div id="rejectForm" class="hidden mt-4 pt-4 border-t border-slate-100 animate-in slide-in-from-top-2 fade-in duration-200">
                        <form action="<?php echo e(route('admin.recetas.reject', $receta->id)); ?>" method="POST">
                            <?php echo csrf_field(); ?>
                            <label class="block text-xs font-bold text-slate-700 mb-2 uppercase">Confirmación:</label>
                            <p class="text-xs text-slate-500 mb-3">Al rechazar, el estado cambiará a <strong>OCULTA</strong>.</p>
                            
                            <button type="submit" class="w-full bg-red-600 hover:bg-red-700 text-white text-sm font-semibold py-2 rounded-lg shadow-sm transition-colors">
                                Confirmar Rechazo
                            </button>
                        </form>
                    </div>
                    
                    <!-- Botón ELIMINAR -->
                     <button onclick="openModal('deleteModal', '<?php echo e(route('admin.recetas.destroy', $receta->id)); ?>')" 
                            class="w-full mt-6 pt-4 border-t border-slate-100 flex justify-center items-center py-2 px-4 text-sm font-medium rounded-xl text-slate-400 hover:text-red-600 transition-colors">
                        <i data-lucide="trash-2" class="w-4 h-4 mr-2"></i>
                        Eliminar receta
                    </button>
                </div>
            </div>

        </div>
    </div>
    
    <!-- Reutilizamos el componente modal para eliminar -->
    <?php if (isset($component)) { $__componentOriginal7ef94aa801410a663a471c55b223c943 = $component; } ?>
<?php if (isset($attributes)) { $__attributesOriginal7ef94aa801410a663a471c55b223c943 = $attributes; } ?>
<?php $component = Illuminate\View\AnonymousComponent::resolve(['view' => 'components.modal-confirm','data' => ['id' => 'deleteModal','title' => 'Eliminar Receta','message' => '¿Estás seguro? Esta acción eliminará la receta de la base de datos o la marcará como eliminada.','action' => '#','confirmText' => 'Sí, eliminar']] + (isset($attributes) && $attributes instanceof Illuminate\View\ComponentAttributeBag ? $attributes->all() : [])); ?>
<?php $component->withName('modal-confirm'); ?>
<?php if ($component->shouldRender()): ?>
<?php $__env->startComponent($component->resolveView(), $component->data()); ?>
<?php if (isset($attributes) && $attributes instanceof Illuminate\View\ComponentAttributeBag): ?>
<?php $attributes = $attributes->except(\Illuminate\View\AnonymousComponent::ignoredParameterNames()); ?>
<?php endif; ?>
<?php $component->withAttributes(['id' => 'deleteModal','title' => 'Eliminar Receta','message' => '¿Estás seguro? Esta acción eliminará la receta de la base de datos o la marcará como eliminada.','action' => '#','confirmText' => 'Sí, eliminar']); ?>
<?php echo $__env->renderComponent(); ?>
<?php endif; ?>
<?php if (isset($__attributesOriginal7ef94aa801410a663a471c55b223c943)): ?>
<?php $attributes = $__attributesOriginal7ef94aa801410a663a471c55b223c943; ?>
<?php unset($__attributesOriginal7ef94aa801410a663a471c55b223c943); ?>
<?php endif; ?>
<?php if (isset($__componentOriginal7ef94aa801410a663a471c55b223c943)): ?>
<?php $component = $__componentOriginal7ef94aa801410a663a471c55b223c943; ?>
<?php unset($__componentOriginal7ef94aa801410a663a471c55b223c943); ?>
<?php endif; ?>

<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /var/www/resources/views/admin/recetas/show.blade.php ENDPATH**/ ?>