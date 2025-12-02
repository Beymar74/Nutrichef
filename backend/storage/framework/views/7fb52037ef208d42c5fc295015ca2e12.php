<?php $__env->startSection('titulo', 'Solicitudes de Chef'); ?>

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

    <!-- Encabezado -->
    <div class="flex flex-col md:flex-row justify-between items-center gap-4 mb-8">
        <div>
            <h1 class="text-2xl font-bold text-slate-800">Solicitudes Chef</h1>
            <p class="text-slate-500 text-sm mt-1">Gestiona las peticiones de usuarios para convertirse en chefs.</p>
        </div>
        <div class="flex gap-2">
            <!-- Badge Pendientes -->
            <a href="<?php echo e(route('admin.solicitudes.index', ['estado' => 'pendiente'])); ?>" 
               class="bg-calabaza-50 px-4 py-2 rounded-lg border border-calabaza-200 text-calabaza-800 font-medium flex items-center gap-2 hover:bg-calabaza-100 transition-colors shadow-sm">
                <i data-lucide="clock" class="w-4 h-4"></i>
                <span>Pendientes: <strong><?php echo e($pendientesCount); ?></strong></span>
            </a>
        </div>
    </div>

    <!-- Barra de Búsqueda y Filtros -->
    <form method="GET" action="<?php echo e(route('admin.solicitudes.index')); ?>" class="bg-white p-4 rounded-xl shadow-sm border border-slate-100 mb-6 flex gap-4 items-center">
        <div class="relative flex-1">
            <i data-lucide="search" class="absolute left-3 top-3 text-slate-400 w-5 h-5"></i>
            <input 
                type="text" 
                name="search" 
                value="<?php echo e(request('search')); ?>" 
                placeholder="Buscar por usuario..." 
                class="w-full pl-10 pr-4 py-2.5 bg-slate-50 border border-slate-200 rounded-lg focus:ring-2 focus:ring-calabaza-500 focus:outline-none transition-all"
            >
        </div>
        
        <!-- Filtro Estado -->
        <div class="relative min-w-[200px]">
            <select 
                name="estado" 
                class="w-full bg-slate-50 border border-slate-200 rounded-lg px-4 py-2.5 text-slate-700 focus:outline-none focus:border-calabaza-500 cursor-pointer font-medium appearance-none pr-10" 
                onchange="this.form.submit()"
            >
                <option value="">Todos los estados</option>
                <option value="pendiente" <?php echo e(request('estado') == 'pendiente' ? 'selected' : ''); ?>>Pendiente</option>
                <option value="aprobada" <?php echo e(request('estado') == 'aprobada' ? 'selected' : ''); ?>>Aprobada</option>
                <option value="rechazada" <?php echo e(request('estado') == 'rechazada' ? 'selected' : ''); ?>>Rechazada</option>
            </select>
            <i data-lucide="filter" class="absolute right-3 top-3 text-slate-400 w-4 h-4 pointer-events-none"></i>
        </div>
    </form>

    <!-- Tabla de Solicitudes -->
    <div class="bg-white rounded-xl shadow-sm border border-slate-100 overflow-hidden">
        <table class="w-full text-left border-collapse">
            <thead class="bg-slate-50/80 border-b border-slate-200 text-xs uppercase text-slate-500 font-semibold tracking-wider">
                <tr>
                    <th class="px-6 py-4">Usuario</th>
                    <th class="px-6 py-4">Motivo</th>
                    <th class="px-6 py-4">Estado</th>
                    <th class="px-6 py-4">Fecha</th>
                    <th class="px-6 py-4 text-right">Acciones</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-slate-100">
                <?php $__empty_1 = true; $__currentLoopData = $solicitudes; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $solicitud): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); $__empty_1 = false; ?>
                    <tr class="hover:bg-slate-50/60 transition-colors">
                        
                        <!-- Usuario -->
                        <td class="px-6 py-4">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 rounded-full bg-calabaza-100 flex items-center justify-center text-calabaza-700 font-bold border border-calabaza-200 shadow-sm">
                                    <?php echo e(substr($solicitud->usuario->name ?? 'U', 0, 1)); ?>

                                </div>
                                <div>
                                    <p class="font-semibold text-slate-800 text-sm"><?php echo e($solicitud->usuario->name ?? 'Desconocido'); ?></p>
                                    <p class="text-xs text-slate-500"><?php echo e($solicitud->usuario->email ?? ''); ?></p>
                                </div>
                            </div>
                        </td>

                        <!-- Motivo -->
                        <td class="px-6 py-4">
                            <p class="text-sm text-slate-600 line-clamp-2 max-w-xs" title="<?php echo e($solicitud->motivo); ?>">
                                <?php echo e($solicitud->motivo ?? 'Sin motivo especificado'); ?>

                            </p>
                        </td>

                        <!-- Estado -->
                        <td class="px-6 py-4">
                            <?php
                                $estadoDesc = strtoupper($solicitud->estado->descripcion ?? 'PENDIENTE');
                                $configs = [
                                    'PENDIENTE' => ['clase' => 'bg-calabaza-50 text-calabaza-700 border-calabaza-200', 'dot' => 'bg-calabaza-500'],
                                    'APROBADA' => ['clase' => 'bg-emerald-50 text-emerald-700 border-emerald-200', 'dot' => 'bg-emerald-500'],
                                    'RECHAZADA' => ['clase' => 'bg-red-50 text-red-700 border-red-200', 'dot' => 'bg-red-500'],
                                ];
                                $config = $configs[$estadoDesc] ?? ['clase' => 'bg-slate-50 text-slate-600 border-slate-200', 'dot' => 'bg-slate-400'];
                            ?>
                            <span class="px-3 py-1 rounded-full text-xs font-semibold border <?php echo e($config['clase']); ?> flex items-center gap-2 w-fit">
                                <span class="w-1.5 h-1.5 rounded-full <?php echo e($config['dot']); ?>"></span>
                                <?php echo e(ucfirst(strtolower($estadoDesc))); ?>

                            </span>
                        </td>

                        <!-- Fecha -->
                        <td class="px-6 py-4 text-sm text-slate-500">
                            <?php echo e($solicitud->created_at->format('d/m/Y')); ?>

                        </td>

                        <!-- Acciones -->
                        <td class="px-6 py-4 text-right">
                            <div class="flex justify-end gap-2">
                                <!-- Ver -->
                                <a href="<?php echo e(route('admin.solicitudes.show', $solicitud->id)); ?>" 
                                   class="p-2 bg-white border border-slate-200 text-slate-500 hover:text-calabaza-600 hover:border-calabaza-200 hover:bg-calabaza-50 rounded-lg transition-all shadow-sm" 
                                   title="Ver Detalle">
                                    <i data-lucide="eye" class="w-4 h-4"></i>
                                </a>

                                <!-- Eliminar -->
                                <button 
                                    type="button" 
                                    onclick="openModal('deleteModal', '<?php echo e(route('admin.solicitudes.destroy', $solicitud->id)); ?>')"
                                    class="p-2 bg-white border border-slate-200 text-slate-500 hover:text-red-600 hover:border-red-200 hover:bg-red-50 rounded-lg transition-all shadow-sm"
                                    title="Eliminar"
                                >
                                    <i data-lucide="trash-2" class="w-4 h-4"></i>
                                </button>
                            </div>
                        </td>
                    </tr>
                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); if ($__empty_1): ?>
                    <tr>
                        <td colspan="5" class="px-6 py-16 text-center">
                            <div class="flex flex-col items-center justify-center text-slate-400">
                                <div class="bg-slate-50 p-4 rounded-full mb-4 border border-slate-100 shadow-sm">
                                    <i data-lucide="users" class="w-10 h-10 text-slate-300"></i>
                                </div>
                                <p class="text-lg font-semibold text-slate-600">No hay solicitudes</p>
                                <p class="text-sm text-slate-400 mt-1">Ningún usuario ha solicitado ser chef aún.</p>
                            </div>
                        </td>
                    </tr>
                <?php endif; ?>
            </tbody>
        </table>
    </div>

    <!-- Paginación -->
    <div class="mt-6">
        <?php echo e($solicitudes->appends(request()->query())->links()); ?>

    </div>

    <!-- Modal Confirmación -->
    <?php if (isset($component)) { $__componentOriginal7ef94aa801410a663a471c55b223c943 = $component; } ?>
<?php if (isset($attributes)) { $__attributesOriginal7ef94aa801410a663a471c55b223c943 = $attributes; } ?>
<?php $component = Illuminate\View\AnonymousComponent::resolve(['view' => 'components.modal-confirm','data' => ['id' => 'deleteModal','title' => 'Eliminar Solicitud','message' => '¿Estás seguro de que deseas eliminar esta solicitud? Esta acción no se puede deshacer.','action' => '#','confirmText' => 'Sí, eliminar']] + (isset($attributes) && $attributes instanceof Illuminate\View\ComponentAttributeBag ? $attributes->all() : [])); ?>
<?php $component->withName('modal-confirm'); ?>
<?php if ($component->shouldRender()): ?>
<?php $__env->startComponent($component->resolveView(), $component->data()); ?>
<?php if (isset($attributes) && $attributes instanceof Illuminate\View\ComponentAttributeBag): ?>
<?php $attributes = $attributes->except(\Illuminate\View\AnonymousComponent::ignoredParameterNames()); ?>
<?php endif; ?>
<?php $component->withAttributes(['id' => 'deleteModal','title' => 'Eliminar Solicitud','message' => '¿Estás seguro de que deseas eliminar esta solicitud? Esta acción no se puede deshacer.','action' => '#','confirmText' => 'Sí, eliminar']); ?>
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
<?php echo $__env->make('layouts.admin', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /var/www/resources/views/admin/solicitudes-chef/index.blade.php ENDPATH**/ ?>