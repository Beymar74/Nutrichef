<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><?php echo $__env->yieldContent('titulo', 'Admin'); ?> - NutriChef</title>
    
    <!-- Tailwind CSS via CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <!-- Iconos Lucide -->
    <script src="https://unpkg.com/lucide@latest"></script>
    
    <!-- Configuración de Colores Corporativos -->
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        // Naranja Calabaza (Color Principal - Acciones)
                        calabaza: {
                            50: '#fff7ed',
                            100: '#ffedd5',
                            200: '#fed7aa',
                            500: '#f97316', 
                            600: '#ea580c',
                            800: '#9a3412',
                        },
                        // Dorado Ámbar (Sub Color - Institucional/Sidebar)
                        ambar: {
                            50: '#fffbeb',
                            100: '#fef3c7',
                            800: '#92400e', // Tono oscuro para fondo sidebar
                            900: '#78350f', // Tono más oscuro para bordes
                            950: '#451a03', // Tono muy oscuro para footer
                        }
                    }
                }
            }
        }
    </script>
    
    <style>
        /* Scrollbar fino y sutil */
        .custom-scrollbar::-webkit-scrollbar { width: 5px; }
        .custom-scrollbar::-webkit-scrollbar-track { background: transparent; }
        .custom-scrollbar::-webkit-scrollbar-thumb { background: rgba(255,255,255,0.2); border-radius: 10px; }
        .custom-scrollbar::-webkit-scrollbar-thumb:hover { background: rgba(255,255,255,0.3); }
    </style>
</head>
<body class="bg-slate-50 font-sans text-slate-800">

    <!-- Overlay Móvil -->
    <div id="mobile-overlay" class="fixed inset-0 bg-black/50 z-20 hidden lg:hidden transition-opacity opacity-0" onclick="toggleSidebar()"></div>

    <div class="flex h-screen overflow-hidden">
        
        <!-- BARRA LATERAL (Sidebar) - Dorado Ámbar -->
        <aside id="sidebar" class="fixed inset-y-0 left-0 z-30 w-64 bg-ambar-800 text-white transition-transform duration-300 ease-in-out -translate-x-full lg:translate-x-0 lg:static flex flex-col shadow-2xl lg:shadow-none border-r border-ambar-900">
            
            <!-- Logo -->
            <div class="h-16 flex items-center px-6 border-b border-ambar-900 bg-ambar-950/20">
                <div class="flex items-center gap-3">
                    <!-- Logo personalizado -->
                    <div class="bg-white p-1 rounded-lg shadow-sm w-8 h-8 flex items-center justify-center overflow-hidden">
                        <!-- Usamos un icono por defecto si la imagen no carga -->
                        <i data-lucide="utensils" class="text-ambar-800 w-5 h-5"></i>
                        
                    </div>
                    <span class="text-lg font-bold tracking-wide text-white">NutriChef</span>
                </div>
            </div>

            <!-- Menú de Navegación -->
            <nav class="flex-1 p-4 space-y-1 overflow-y-auto custom-scrollbar">
                
                <p class="px-4 text-xs font-bold text-ambar-200 uppercase tracking-wider mb-2 mt-2">Principal</p>
                
                <!-- Dashboard -->
                <a href="<?php echo e(route('admin.dashboard')); ?>" 
                   class="flex items-center gap-3 px-4 py-2.5 rounded-lg transition-all group 
                   <?php echo e(request()->routeIs('admin.dashboard') ? 'bg-calabaza-600 text-white shadow-md shadow-calabaza-900/20 transform hover:-translate-y-0.5' : 'text-ambar-50 hover:bg-ambar-900/50 hover:text-white'); ?>">
                    <i data-lucide="layout-dashboard" class="w-5 h-5 <?php echo e(request()->routeIs('admin.dashboard') ? '' : 'group-hover:text-calabaza-500 transition-colors'); ?>"></i>
                    <span>Dashboard</span>
                </a>

                <!-- Usuarios (CONECTADO) -->
                <a href="<?php echo e(route('admin.usuarios.index')); ?>" 
                   class="flex items-center gap-3 px-4 py-2.5 rounded-lg transition-all group 
                   <?php echo e(request()->routeIs('admin.usuarios.*') ? 'bg-calabaza-600 text-white shadow-md shadow-calabaza-900/20 transform hover:-translate-y-0.5' : 'text-ambar-50 hover:bg-ambar-900/50 hover:text-white'); ?>">
                    <i data-lucide="users" class="w-5 h-5 <?php echo e(request()->routeIs('admin.usuarios.*') ? '' : 'group-hover:text-calabaza-500 transition-colors'); ?>"></i>
                    <span>Usuarios</span>
                </a>

                <p class="px-4 text-xs font-bold text-ambar-200 uppercase tracking-wider mb-2 mt-6">Gestión</p>

                <!-- Recetas (CONECTADO) -->
                <a href="<?php echo e(route('admin.recetas.index')); ?>" 
                   class="flex items-center gap-3 px-4 py-2.5 rounded-lg transition-all group 
                   <?php echo e(request()->routeIs('admin.recetas.*') ? 'bg-calabaza-600 text-white shadow-md shadow-calabaza-900/20 transform hover:-translate-y-0.5' : 'text-ambar-50 hover:bg-ambar-900/50 hover:text-white'); ?>">
                    <i data-lucide="utensils-crossed" class="w-5 h-5 <?php echo e(request()->routeIs('admin.recetas.*') ? '' : 'group-hover:text-calabaza-500 transition-colors'); ?>"></i>
                    <span class="font-medium">Recetas</span>
                </a>

                <!-- Planificación -->
                <a href="#" class="flex items-center gap-3 px-4 py-2.5 text-ambar-50 hover:bg-ambar-900/50 hover:text-white rounded-lg transition-all group">
                    <i data-lucide="calendar" class="w-5 h-5 group-hover:text-calabaza-500 transition-colors"></i>
                    <span>Planificación</span>
                </a>

                <!-- Configuración -->
                <a href="#" class="flex items-center gap-3 px-4 py-2.5 text-ambar-50 hover:bg-ambar-900/50 hover:text-white rounded-lg transition-all group">
                    <i data-lucide="settings" class="w-5 h-5 group-hover:text-calabaza-500 transition-colors"></i>
                    <span>Configuración</span>
                </a>
            </nav>

            <!-- Pie del Sidebar -->
            <div class="p-4 border-t border-ambar-900 bg-ambar-950/30">
                <div class="flex items-center gap-3 mb-3 px-2">
                    <div class="w-9 h-9 rounded-full bg-calabaza-100 flex items-center justify-center text-sm font-bold text-calabaza-700 border-2 border-calabaza-200 overflow-hidden">
                        <?php echo e(substr(Auth::user()->name ?? 'A', 0, 1)); ?>

                    </div>
                    <div class="overflow-hidden">
                        <p class="text-sm font-medium text-white truncate"><?php echo e(Auth::user()->name ?? 'Admin'); ?></p>
                        <p class="text-xs text-ambar-200 truncate w-32"><?php echo e(Auth::user()->email ?? ''); ?></p>
                    </div>
                </div>
                <form method="POST" action="<?php echo e(route('logout')); ?>">
                    <?php echo csrf_field(); ?>
                    <button type="submit" class="flex items-center justify-center gap-2 text-ambar-200 hover:text-white hover:bg-white/10 w-full px-4 py-2 rounded-lg transition-colors text-sm font-medium group">
                        <i data-lucide="log-out" class="w-4 h-4 group-hover:text-calabaza-500 transition-colors"></i>
                        <span>Cerrar Sesión</span>
                    </button>
                </form>
            </div>
        </aside>

        <!-- CONTENIDO PRINCIPAL -->
        <div class="flex-1 flex flex-col min-w-0 overflow-hidden bg-slate-50">
            
            <!-- Barra Superior (Navbar) -->
            <header class="bg-white border-b border-slate-200 shadow-sm h-16 flex items-center justify-between px-6 lg:px-8 z-10">
                <div class="flex items-center gap-4">
                    <!-- Botón Menú Móvil -->
                    <button class="lg:hidden text-slate-500 hover:text-calabaza-600 transition-colors p-1 rounded-md hover:bg-slate-100" onclick="toggleSidebar()">
                        <i data-lucide="menu" class="w-6 h-6"></i>
                    </button>
                    
                    <!-- Título de Página -->
                    <h2 class="text-lg font-bold text-slate-800 hidden sm:block flex items-center gap-2">
                        <span class="w-1 h-6 bg-calabaza-500 rounded-full"></span>
                        <?php echo $__env->yieldContent('titulo_pagina', 'Panel Administrativo'); ?>
                    </h2>
                </div>

                <div class="flex items-center gap-4">
                    <!-- Notificaciones -->
                    <button class="p-2 text-slate-400 hover:text-calabaza-600 rounded-full hover:bg-calabaza-50 transition-colors relative">
                        <i data-lucide="bell" class="w-5 h-5"></i>
                        <span class="absolute top-2 right-2 w-2 h-2 bg-calabaza-500 rounded-full border-2 border-white"></span>
                    </button>
                    
                    <div class="h-8 w-px bg-slate-200 hidden sm:block"></div>
                    
                    <!-- Info Usuario (Navbar) -->
                    <span class="text-sm text-slate-600 font-medium hidden sm:block">Hola, <?php echo e(Auth::user()->name ?? 'Admin'); ?></span>
                </div>
            </header>

            <!-- Área de Contenido -->
            <main class="flex-1 overflow-y-auto p-6 lg:p-8 scroll-smooth">
                <?php echo $__env->yieldContent('contenido'); ?>
            </main>
        </div>

    </div>

    <!-- SCRIPTS GLOBALES -->
    <script>
        // 1. Inicializar Iconos
        lucide.createIcons();

        // 2. Lógica Sidebar Móvil
        function toggleSidebar() {
            const sidebar = document.getElementById('sidebar');
            const overlay = document.getElementById('mobile-overlay');
            
            if (sidebar.classList.contains('-translate-x-full')) {
                sidebar.classList.remove('-translate-x-full');
                overlay.classList.remove('hidden');
                setTimeout(() => overlay.classList.remove('opacity-0'), 10);
            } else {
                sidebar.classList.add('-translate-x-full');
                overlay.classList.add('opacity-0');
                setTimeout(() => overlay.classList.add('hidden'), 300);
            }
        }

        // 3. LÓGICA VITAL PARA MODALES (Eliminar/Banear)
        function openModal(modalId, actionUrl) {
            const modal = document.getElementById(modalId);
            if(modal) {
                modal.classList.remove('hidden');
                modal.classList.add('flex'); 
                
                // Inyectar la ruta de eliminación en el formulario del modal
                const form = modal.querySelector('form');
                if(form) {
                    form.action = actionUrl;
                }
            }
        }

        function closeModal(modalId) {
            const modal = document.getElementById(modalId);
            if(modal) {
                modal.classList.add('hidden');
                modal.classList.remove('flex');
            }
        }
        
        // Cerrar al hacer clic fuera del modal
        window.onclick = function(event) {
            const modals = document.querySelectorAll('[id$="Modal"]');
            modals.forEach(modal => {
                if (!modal.classList.contains('hidden') && event.target === modal) {
                     closeModal(modal.id);
                }
            });
        }
    </script>
</body>
</html><?php /**PATH /var/www/resources/views/layouts/admin.blade.php ENDPATH**/ ?>