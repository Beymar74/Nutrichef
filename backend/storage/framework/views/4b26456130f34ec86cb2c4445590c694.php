

<?php $__env->startSection('titulo', 'Perfil de Usuario'); ?>
<?php $__env->startSection('titulo_pagina', 'Detalle de Usuario'); ?>

<?php $__env->startSection('contenido'); ?>

    <?php if(session('success')): ?>
        <div class="mb-6 bg-emerald-50 border border-emerald-200 text-emerald-700 px-4 py-3 rounded-lg flex items-center gap-2 shadow-sm">
            <i data-lucide="check-circle" class="w-5 h-5"></i>
            <span class="font-medium"><?php echo e(session('success')); ?></span>
        </div>
    <?php endif; ?>

    <div class="mb-6">
        <a href="<?php echo e(route('admin.usuarios.index')); ?>" class="text-slate-500 hover:text-calabaza-600 flex items-center gap-1 text-sm font-medium w-fit">
            <i data-lucide="arrow-left" class="w-4 h-4"></i> Volver al directorio
        </a>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        
        <!-- Tarjeta Principal -->
        <div class="bg-white rounded-xl shadow-sm border border-slate-100 p-6 lg:col-span-1 h-fit">
            <div class="flex flex-col items-center text-center">
                <!-- Avatar -->
                <div class="w-24 h-24 rounded-full bg-calabaza-100 text-calabaza-600 flex items-center justify-center text-3xl font-bold mb-4 border-4 border-white shadow-lg">
                    <?php echo e(substr($usuario->name, 0, 1)); ?>

                </div>
                
                <h2 class="text-xl font-bold text-slate-800"><?php echo e($usuario->name); ?></h2>
                
                <span class="px-3 py-1 mt-2 rounded-full text-xs font-medium bg-slate-100 text-slate-600 border border-slate-200">
                    <?php echo e($usuario->rol->descripcion ?? 'Sin Rol'); ?>

                </span>
                
                <div class="mt-6 w-full space-y-3 border-t border-slate-100 pt-6 text-left text-sm">
                    <div class="flex justify-between">
                        <span class="text-slate-500">Email:</span>
                        <span class="font-medium text-slate-700"><?php echo e($usuario->email); ?></span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-slate-500">Estado:</span>
                        <span class="<?php echo e($usuario->estado ? 'text-emerald-600' : 'text-red-600'); ?> font-bold">
                            <?php echo e($usuario->estado ? 'Activo' : 'Inactivo'); ?>

                        </span>
                    </div>
                    <div class="flex justify-between">
                        <span class="text-slate-500">Registro:</span>
                        <span class="text-slate-700"><?php echo e($usuario->created_at->format('d/m/Y')); ?></span>
                    </div>
                </div>

                <!-- ACCIONES PRINCIPALES -->
                <div class="w-full mt-6 space-y-3">
                    
                    <!-- 1. Botón Editar (NUEVO) -->
                    <a href="<?php echo e(route('admin.usuarios.edit', $usuario->id)); ?>" class="flex items-center justify-center w-full py-2 px-4 rounded-lg bg-slate-800 hover:bg-slate-900 text-white font-medium transition-colors shadow-lg shadow-slate-500/20">
                        <i data-lucide="edit-2" class="w-4 h-4 mr-2"></i>
                        Editar Datos y Rol
                    </a>

                    <!-- 2. Botón Bloquear -->
                    <form action="<?php echo e(route('admin.usuarios.toggle', $usuario->id)); ?>" method="POST">
                        <?php echo csrf_field(); ?> <?php echo method_field('PATCH'); ?>
                        <button type="submit" class="w-full py-2 px-4 rounded-lg border font-medium transition-colors flex items-center justify-center <?php echo e($usuario->estado ? 'border-red-200 text-red-600 hover:bg-red-50' : 'border-emerald-200 text-emerald-600 hover:bg-emerald-50'); ?>">
                            <?php if($usuario->estado): ?>
                                <i data-lucide="ban" class="w-4 h-4 mr-2"></i> Bloquear Acceso
                            <?php else: ?>
                                <i data-lucide="check-circle" class="w-4 h-4 mr-2"></i> Reactivar Acceso
                            <?php endif; ?>
                        </button>
                    </form>
                </div>

            </div>
        </div>

        <!-- Pestañas de Info (Igual que antes) -->
        <div class="lg:col-span-2 space-y-6">
            <!-- ... Contenido de Datos Personales y Recetas ... -->
            <!-- Datos Personales -->
            <div class="bg-white rounded-xl shadow-sm border border-slate-100 p-6">
                <h3 class="text-lg font-bold text-slate-800 mb-4 border-b border-slate-100 pb-2">Información Personal</h3>
                <?php if($usuario->persona): ?>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label class="block text-xs font-bold text-slate-400 uppercase">Nombre Completo</label>
                            <p class="text-slate-700"><?php echo e($usuario->persona->nombres); ?> <?php echo e($usuario->persona->apellido_paterno); ?> <?php echo e($usuario->persona->apellido_materno); ?></p>
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-slate-400 uppercase">Teléfono</label>
                            <p class="text-slate-700"><?php echo e($usuario->persona->telefono ?? 'No registrado'); ?></p>
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-slate-400 uppercase">Fecha Nacimiento</label>
                            <p class="text-slate-700"><?php echo e($usuario->persona->fecha_nacimiento ?? '--'); ?></p>
                        </div>
                        <div class="flex gap-4">
                            <div>
                                <label class="block text-xs font-bold text-slate-400 uppercase">Altura</label>
                                <p class="text-slate-700"><?php echo e($usuario->persona->altura ?? '-'); ?> m</p>
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-slate-400 uppercase">Peso</label>
                                <p class="text-slate-700"><?php echo e($usuario->persona->peso ?? '-'); ?> kg</p>
                            </div>
                        </div>
                    </div>
                <?php else: ?>
                    <p class="text-slate-400 italic">Este usuario no ha completado su perfil personal.</p>
                <?php endif; ?>
            </div>

            <!-- Recetas Recientes -->
            <div class="bg-white rounded-xl shadow-sm border border-slate-100 p-6">
                <h3 class="text-lg font-bold text-slate-800 mb-4 flex justify-between items-center">
                    <span>Recetas Publicadas</span>
                    <span class="text-xs bg-slate-100 px-2 py-1 rounded text-slate-500"><?php echo e($usuario->recetasCreadas->count()); ?> Total</span>
                </h3>
                
                <div class="space-y-3">
                    <?php $__empty_1 = true; $__currentLoopData = $usuario->recetasCreadas->take(3); $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $receta): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
                        <div class="flex items-center justify-between p-3 bg-slate-50 rounded-lg border border-slate-100">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 rounded bg-white flex items-center justify-center text-calabaza-500 border border-slate-200">
                                    <i data-lucide="utensils" class="w-5 h-5"></i>
                                </div>
                                <div>
                                    <p class="font-medium text-slate-800 text-sm"><?php echo e($receta->titulo); ?></p>
                                    <p class="text-xs text-slate-500"><?php echo e($receta->created_at->diffForHumans()); ?></p>
                                </div>
                            </div>
                            <span class="text-xs font-medium px-2 py-1 rounded bg-white border border-slate-200 text-slate-600">
                                <?php echo e($receta->estado->descripcion ?? 'Estado?'); ?>

                            </span>
                        </div>
                    <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
                        <p class="text-slate-400 italic text-sm">No ha publicado recetas aún.</p>
                    <?php endif; ?>
                </div>
            </div>
        </div>
    </div>

<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /var/www/resources/views/admin/usuarios/show.blade.php ENDPATH**/ ?>