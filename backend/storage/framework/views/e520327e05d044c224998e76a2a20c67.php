

<?php $__env->startSection('titulo', 'Editar Receta'); ?>

<?php $__env->startSection('contenido'); ?>
    <div class="mb-6">
        <a href="<?php echo e(route('admin.recetas.index')); ?>" class="text-slate-500 hover:text-calabaza-600 flex items-center gap-1 text-sm font-medium mb-4 transition-colors">
            <i data-lucide="arrow-left" class="w-4 h-4"></i> Cancelar y volver
        </a>
    </div>

    <div class="max-w-3xl mx-auto">
        <div class="bg-white rounded-xl shadow-sm border border-slate-100 overflow-hidden">
            <div class="p-6 border-b border-slate-100 bg-slate-50/50">
                <h2 class="text-lg font-bold text-slate-800">Editar Información de la Receta</h2>
                <p class="text-sm text-slate-500">Modifica los detalles principales.</p>
            </div>
            
            <form action="<?php echo e(route('admin.recetas.update', $receta->id)); ?>" method="POST" class="p-6 space-y-6">
                <?php echo csrf_field(); ?>
                <?php echo method_field('PUT'); ?>

                <div class="grid gap-6 md:grid-cols-2">
                    <div class="col-span-2">
                        <label class="block text-sm font-medium text-slate-700 mb-1">Título de la Receta</label>
                        <input type="text" name="titulo" value="<?php echo e(old('titulo', $receta->titulo)); ?>" class="w-full rounded-lg border-slate-200 focus:border-calabaza-500 focus:ring focus:ring-calabaza-200 transition-shadow" required>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-1">Tiempo (minutos)</label>
                        <div class="relative">
                            <i data-lucide="clock" class="absolute left-3 top-2.5 w-5 h-5 text-slate-400"></i>
                            <input type="number" name="tiempo_preparacion" value="<?php echo e(old('tiempo_preparacion', $receta->tiempo_preparacion)); ?>" class="w-full pl-10 rounded-lg border-slate-200 focus:border-calabaza-500 focus:ring focus:ring-calabaza-200" required>
                        </div>
                    </div>

                    <div>
                        <label class="block text-sm font-medium text-slate-700 mb-1">Porciones</label>
                        <div class="relative">
                            <i data-lucide="users" class="absolute left-3 top-2.5 w-5 h-5 text-slate-400"></i>
                            <input type="number" name="porciones_estimadas" value="<?php echo e(old('porciones_estimadas', $receta->porciones_estimadas)); ?>" class="w-full pl-10 rounded-lg border-slate-200 focus:border-calabaza-500 focus:ring focus:ring-calabaza-200" required>
                        </div>
                    </div>
                    
                    <div class="col-span-2">
                        <label class="block text-sm font-medium text-slate-700 mb-1">Resumen Breve</label>
                        <textarea name="resumen" rows="2" class="w-full rounded-lg border-slate-200 focus:border-calabaza-500 focus:ring focus:ring-calabaza-200"><?php echo e(old('resumen', $receta->resumen)); ?></textarea>
                    </div>

                    <div class="col-span-2">
                        <label class="block text-sm font-medium text-slate-700 mb-1">Instrucciones de Preparación</label>
                        <textarea name="preparacion" rows="6" class="w-full rounded-lg border-slate-200 focus:border-calabaza-500 focus:ring focus:ring-calabaza-200" required><?php echo e(old('preparacion', $receta->preparacion)); ?></textarea>
                    </div>
                </div>

                <div class="flex items-center justify-end gap-3 pt-4 border-t border-slate-100">
                    <button type="submit" class="bg-calabaza-500 hover:bg-calabaza-600 text-white px-6 py-2.5 rounded-lg font-medium transition-colors shadow-lg shadow-calabaza-500/20 flex items-center gap-2">
                        <i data-lucide="save" class="w-4 h-4"></i> Guardar Cambios
                    </button>
                </div>
            </form>
        </div>
    </div>
<?php $__env->stopSection(); ?>
<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /var/www/resources/views/admin/recetas/edit.blade.php ENDPATH**/ ?>