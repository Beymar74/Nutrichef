

<?php $__env->startSection('titulo', 'Gestión de Usuarios'); ?>
<?php $__env->startSection('titulo_pagina', 'Directorio de Usuarios'); ?>

<?php $__env->startSection('contenido'); ?>

    <?php if(session('success')): ?>
        <div class="mb-6 bg-emerald-50 border border-emerald-200 text-emerald-700 px-4 py-3 rounded-lg flex items-center gap-2 shadow-sm">
            <i data-lucide="check-circle" class="w-5 h-5"></i>
            <span class="font-medium"><?php echo e(session('success')); ?></span>
        </div>
    <?php endif; ?>

    <!-- Filtros y Acciones -->
    <div class="bg-white p-4 rounded-xl shadow-sm border border-slate-100 mb-6 flex flex-col lg:flex-row gap-4 items-center justify-between">
        
        <!-- Formulario de Búsqueda -->
        <form method="GET" action="<?php echo e(route('admin.usuarios.index')); ?>" class="flex gap-4 w-full lg:w-auto flex-1">
            <div class="relative flex-1 lg:w-96">
                <i data-lucide="search" class="absolute left-3 top-3 text-slate-400 w-5 h-5"></i>
                <input type="text" name="search" value="<?php echo e(request('search')); ?>" placeholder="Buscar por nombre, email..." 
                       class="w-full pl-10 pr-4 py-2.5 bg-slate-50 border border-slate-200 rounded-lg focus:ring-2 focus:ring-calabaza-500 outline-none">
            </div>
            
            <select name="rol" class="bg-slate-50 border border-slate-200 rounded-lg px-4 py-2.5 text-slate-700 focus:outline-none focus:border-calabaza-500" onchange="this.form.submit()">
                <option value="">Todos los roles</option>
                <?php $__currentLoopData = $roles; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $rol): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                    <option value="<?php echo e($rol->id); ?>" <?php echo e(request('rol') == $rol->id ? 'selected' : ''); ?>>
                        <?php echo e($rol->descripcion); ?>

                    </option>
                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
            </select>
        </form>
        
        <div class="flex items-center gap-4 w-full lg:w-auto">
            <div class="text-sm text-slate-500 hidden md:block">
                Total: <strong><?php echo e($usuarios->total()); ?></strong> usuarios
            </div>
            
            <!-- BOTÓN NUEVO USUARIO -->
            <a href="<?php echo e(route('admin.usuarios.create')); ?>" class="flex items-center justify-center gap-2 bg-calabaza-600 hover:bg-calabaza-700 text-white px-4 py-2.5 rounded-lg font-medium shadow-md shadow-calabaza-500/20 transition-all w-full lg:w-auto">
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
                <?php $__empty_1 = true; $__currentLoopData = $usuarios; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $usuario): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
                    <tr class="hover:bg-slate-50/50 transition-colors">
                        <td class="px-6 py-4">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 rounded-full bg-calabaza-100 flex items-center justify-center text-calabaza-700 font-bold">
                                    <?php echo e(substr($usuario->name, 0, 1)); ?>

                                </div>
                                <div>
                                    <p class="font-bold text-slate-800 text-sm"><?php echo e($usuario->name); ?></p>
                                    <p class="text-xs text-slate-500"><?php echo e($usuario->email); ?></p>
                                </div>
                            </div>
                        </td>
                        <td class="px-6 py-4">
                            <span class="px-3 py-1 rounded-full text-xs font-medium bg-slate-100 text-slate-600 border border-slate-200">
                                <?php echo e($usuario->rol->descripcion ?? 'Sin Rol'); ?>

                            </span>
                        </td>
                        <td class="px-6 py-4 text-sm text-slate-600">
                            <?php if($usuario->persona): ?>
                                <p><?php echo e($usuario->persona->nombres); ?> <?php echo e($usuario->persona->apellido_paterno); ?></p>
                                <p class="text-xs text-slate-400"><?php echo e($usuario->persona->telefono ?? 'Sin teléfono'); ?></p>
                            <?php else: ?>
                                <span class="italic text-slate-400">Sin perfil</span>
                            <?php endif; ?>
                        </td>
                        <td class="px-6 py-4">
                            <?php if($usuario->estado): ?>
                                <span class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-medium bg-emerald-100 text-emerald-800 border border-emerald-200">
                                    <span class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span> Activo
                                </span>
                            <?php else: ?>
                                <span class="inline-flex items-center gap-1 px-2.5 py-0.5 rounded-full text-xs font-medium bg-red-100 text-red-800 border border-red-200">
                                    <span class="w-1.5 h-1.5 rounded-full bg-red-500"></span> Inactivo
                                </span>
                            <?php endif; ?>
                        </td>
                        <td class="px-6 py-4 text-right">
                            <div class="flex justify-end gap-2">
                                <a href="<?php echo e(route('admin.usuarios.show', $usuario->id)); ?>" class="p-2 bg-white border border-slate-200 rounded-lg text-slate-500 hover:text-calabaza-600 hover:border-calabaza-200 transition-colors" title="Ver Perfil">
                                    <i data-lucide="eye" class="w-4 h-4"></i>
                                </a>
                                
                                <form action="<?php echo e(route('admin.usuarios.toggle', $usuario->id)); ?>" method="POST">
                                    <?php echo csrf_field(); ?>
                                    <?php echo method_field('PATCH'); ?>
                                    <button type="submit" class="p-2 bg-white border border-slate-200 rounded-lg text-slate-500 hover:text-red-600 hover:border-red-200 transition-colors" 
                                            title="<?php echo e($usuario->estado ? 'Desactivar' : 'Activar'); ?>">
                                        <i data-lucide="<?php echo e($usuario->estado ? 'ban' : 'check-circle'); ?>" class="w-4 h-4"></i>
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
                    <tr>
                        <td colspan="5" class="px-6 py-12 text-center text-slate-500">
                            No se encontraron usuarios con esos criterios.
                        </td>
                    </tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>

    <div class="mt-4">
        <?php echo e($usuarios->appends(request()->query())->links()); ?>

    </div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /var/www/resources/views/admin/usuarios/index.blade.php ENDPATH**/ ?>