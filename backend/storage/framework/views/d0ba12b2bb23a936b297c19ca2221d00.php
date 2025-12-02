<?php $__env->startSection('titulo', 'Planificación Global'); ?>
<?php $__env->startSection('titulo_pagina', 'Monitoreo de Comidas'); ?>

<?php $__env->startSection('contenido'); ?>
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
                <?php $__empty_1 = true; $__currentLoopData = $planificaciones; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $plan): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
                    <tr class="hover:bg-slate-50/50 transition-colors">
                        <td class="px-6 py-4 font-medium text-slate-700">
                            <?php echo e($plan->usuario->name ?? 'Usuario Eliminado'); ?>

                        </td>
                        <td class="px-6 py-4">
                            <a href="<?php echo e(route('admin.recetas.show', $plan->id_receta)); ?>" class="text-calabaza-600 hover:underline font-medium">
                                <?php echo e($plan->receta->titulo ?? 'Receta Eliminada'); ?>

                            </a>
                        </td>
                        <td class="px-6 py-4 text-sm text-slate-600">
                            <span class="bg-slate-100 px-2 py-1 rounded text-xs font-bold border border-slate-200">
                                <?php echo e($plan->horario->descripcion ?? 'General'); ?>

                            </span>
                        </td>
                        <td class="px-6 py-4 text-sm text-slate-600">
                            <?php $dias = [1=>'Lunes', 2=>'Martes', 3=>'Miércoles', 4=>'Jueves', 5=>'Viernes', 6=>'Sábado', 7=>'Domingo']; ?>
                            <?php echo e($dias[$plan->dia_semana] ?? 'Día ' . $plan->dia_semana); ?>

                        </td>
                        <td class="px-6 py-4 text-xs text-slate-400">
                            <?php echo e($plan->created_at->diffForHumans()); ?>

                        </td>
                    </tr>
                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
                    <tr><td colspan="5" class="px-6 py-12 text-center text-slate-500 italic">No hay planificaciones registradas aún.</td></tr>
                <?php endif; ?>
            </tbody>
        </table>
        <div class="p-4"><?php echo e($planificaciones->links()); ?></div>
    </div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /var/www/resources/views/admin/planificacion/index.blade.php ENDPATH**/ ?>