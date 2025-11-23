

<?php $__env->startSection('titulo', 'Moderación'); ?>
<?php $__env->startSection('titulo_pagina', 'Comentarios de Usuarios'); ?>

<?php $__env->startSection('contenido'); ?>

    <?php if(session('success')): ?>
        <div class="mb-6 bg-emerald-50 border border-emerald-200 text-emerald-700 px-4 py-3 rounded-lg flex items-center gap-2 shadow-sm">
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
                <?php $__empty_1 = true; $__currentLoopData = $comentarios; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $comentario): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
                    <tr class="hover:bg-slate-50/50 transition-colors group">
                        <td class="px-6 py-4">
                            <div class="flex items-center gap-2">
                                <div class="w-8 h-8 rounded-full bg-calabaza-100 flex items-center justify-center text-calabaza-700 font-bold text-xs border border-calabaza-200">
                                    <?php echo e(substr($comentario->usuario->name ?? 'A', 0, 1)); ?>

                                </div>
                                <span class="text-sm font-medium text-slate-700"><?php echo e($comentario->usuario->name ?? 'Anónimo'); ?></span>
                            </div>
                        </td>
                        <td class="px-6 py-4 max-w-md">
                            <p class="text-slate-600 text-sm italic">"<?php echo e($comentario->contenido ?? 'Sin contenido'); ?>"</p>
                            <span class="text-xs text-slate-400 mt-1 block"><?php echo e($comentario->created_at->diffForHumans()); ?></span>
                        </td>
                        <td class="px-6 py-4">
                            <span class="text-sm font-medium text-calabaza-600">
                                <?php echo e($comentario->publicacion->receta->titulo ?? 'Receta Eliminada'); ?>

                            </span>
                        </td>
                        <td class="px-6 py-4">
                            <?php
                                $est = strtoupper($comentario->estado->descripcion ?? 'VISIBLE');
                                $badge = match($est) {
                                    'VISIBLE' => 'bg-emerald-100 text-emerald-700 border-emerald-200',
                                    'REPORTADO' => 'bg-orange-100 text-orange-700 border-orange-200',
                                    'ELIMINADO_ADMIN' => 'bg-red-100 text-red-700 border-red-200 line-through opacity-60',
                                    default => 'bg-slate-100 text-slate-600 border-slate-200'
                                };
                            ?>
                            <span class="px-2 py-1 rounded text-xs font-bold border <?php echo e($badge); ?>">
                                <?php echo e($est); ?>

                            </span>
                        </td>
                        <td class="px-6 py-4 text-right">
                            <div class="flex justify-end gap-2 opacity-0 group-hover:opacity-100 transition-opacity">
                                <!-- Aprobar / Restaurar -->
                                <form action="<?php echo e(route('admin.comentarios.moderar', ['id' => $comentario->id, 'accion' => 'aprobar'])); ?>" method="POST">
                                    <?php echo csrf_field(); ?> <?php echo method_field('PATCH'); ?>
                                    <button type="submit" class="p-2 text-emerald-500 hover:bg-emerald-50 rounded-lg transition-colors border border-transparent hover:border-emerald-200" title="Marcar Visible">
                                        <i data-lucide="check" class="w-4 h-4"></i>
                                    </button>
                                </form>
                                <!-- Eliminar -->
                                <form action="<?php echo e(route('admin.comentarios.moderar', ['id' => $comentario->id, 'accion' => 'eliminar'])); ?>" method="POST">
                                    <?php echo csrf_field(); ?> <?php echo method_field('PATCH'); ?>
                                    <button type="submit" class="p-2 text-red-500 hover:bg-red-50 rounded-lg transition-colors border border-transparent hover:border-red-200" title="Eliminar">
                                        <i data-lucide="trash-2" class="w-4 h-4"></i>
                                    </button>
                                </form>
                            </div>
                        </td>
                    </tr>
                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
                    <tr><td colspan="5" class="px-6 py-12 text-center text-slate-500 italic">No hay comentarios registrados.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
        <div class="p-4"><?php echo e($comentarios->links()); ?></div>
    </div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /var/www/resources/views/admin/comentarios/index.blade.php ENDPATH**/ ?>