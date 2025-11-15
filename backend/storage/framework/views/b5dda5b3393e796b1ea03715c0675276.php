<!doctype html>
<html lang="es">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Dashboard Administrador - NutriChef</title>
  <script src="https://cdn.tailwindcss.com"></script>
  <script src="https://cdn.jsdelivr.net/npm/lucide@latest/dist/umd/lucide.min.js"></script>
</head>
<body class="min-h-screen bg-gray-50">
  <!-- Header -->
  <header class="bg-gradient-to-r from-green-600 to-green-700 text-white shadow-lg">
    <div class="container mx-auto px-6 py-4">
      <div class="flex items-center justify-between">
        <div class="flex items-center space-x-3">
          <div class="text-white" data-lucide="chef-hat" style="width:32px;height:32px;"></div>
          <div>
            <h1 class="text-2xl font-bold">Dashboard Administrador</h1>
            <p class="text-green-100 text-xs">Sistema NutriChef</p>
          </div>
        </div>
        <div class="flex items-center space-x-4">
          <div class="text-right mr-4">
            <p class="text-xs text-green-100">Última actualización</p>
            <p class="text-sm font-semibold" id="currentDate"></p>
          </div>
          <div class="flex items-center space-x-3 bg-white/10 rounded-lg px-3 py-2 backdrop-blur-sm">
            <div class="w-10 h-10 rounded-full bg-white/20 flex items-center justify-center font-bold text-white">KI</div>
            <div>
              <p class="font-semibold text-white text-sm">Ki</p>
              <p class="text-xs text-green-100">Administrador</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  </header>

  <div class="container mx-auto px-6 py-8">
    <!-- Acciones Rápidas -->
    <div class="bg-white rounded-lg shadow-md p-6 mb-8">
      <h2 class="text-xl font-bold text-gray-800 mb-4 flex items-center">
        <div data-lucide="zap" class="mr-2 text-yellow-500" style="width:24px;height:24px;"></div>
        Acciones Rápidas de Administrador
      </h2>
      <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-4">
        <button onclick="showModal('add')" class="flex flex-col items-center justify-center p-4 bg-green-50 hover:bg-green-100 rounded-lg transition border-2 border-green-200 hover:border-green-400">
          <div data-lucide="plus-circle" class="text-green-600 mb-2" style="width:32px;height:32px;"></div>
          <span class="text-sm font-semibold text-green-700">Agregar Receta</span>
        </button>
        
        <button onclick="showModal('view')" class="flex flex-col items-center justify-center p-4 bg-blue-50 hover:bg-blue-100 rounded-lg transition border-2 border-blue-200 hover:border-blue-400">
          <div data-lucide="eye" class="text-blue-600 mb-2" style="width:32px;height:32px;"></div>
          <span class="text-sm font-semibold text-blue-700">Ver Recetas</span>
        </button>
        
        <button onclick="showModal('edit')" class="flex flex-col items-center justify-center p-4 bg-amber-50 hover:bg-amber-100 rounded-lg transition border-2 border-amber-200 hover:border-amber-400">
          <div data-lucide="edit" class="text-amber-600 mb-2" style="width:32px;height:32px;"></div>
          <span class="text-sm font-semibold text-amber-700">Editar Recetas</span>
        </button>
        
        <button onclick="showModal('delete')" class="flex flex-col items-center justify-center p-4 bg-red-50 hover:bg-red-100 rounded-lg transition border-2 border-red-200 hover:border-red-400">
          <div data-lucide="trash-2" class="text-red-600 mb-2" style="width:32px;height:32px;"></div>
          <span class="text-sm font-semibold text-red-700">Eliminar Recetas</span>
        </button>
        
        <button onclick="showModal('users')" class="flex flex-col items-center justify-center p-4 bg-purple-50 hover:bg-purple-100 rounded-lg transition border-2 border-purple-200 hover:border-purple-400">
          <div data-lucide="users" class="text-purple-600 mb-2" style="width:32px;height:32px;"></div>
          <span class="text-sm font-semibold text-purple-700">Gestionar Usuarios</span>
        </button>
        
        <button onclick="showModal('catalogs')" class="flex flex-col items-center justify-center p-4 bg-indigo-50 hover:bg-indigo-100 rounded-lg transition border-2 border-indigo-200 hover:border-indigo-400">
          <div data-lucide="database" class="text-indigo-600 mb-2" style="width:32px;height:32px;"></div>
          <span class="text-sm font-semibold text-indigo-700">Catálogos</span>
        </button>
      </div>
    </div>

    <!-- Estadísticas Principales -->
    <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
      <div class="bg-white rounded-lg shadow-md p-6 border-l-4" style="border-left-color:#10b981;">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-gray-500 text-sm font-medium">Usuarios Totales</p>
            <p class="text-3xl font-bold mt-2" style="color:#10b981">1</p>
            <p class="text-gray-400 text-xs mt-1">Usuarios activos en el sistema</p>
          </div>
          <div data-lucide="users" class="text-gray-400" style="width:40px;height:40px;"></div>
        </div>
      </div>

      <div class="bg-white rounded-lg shadow-md p-6 border-l-4" style="border-left-color:#3b82f6;">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-gray-500 text-sm font-medium">Recetas Totales</p>
            <p class="text-3xl font-bold mt-2" style="color:#3b82f6">24</p>
            <p class="text-gray-400 text-xs mt-1">0 publicadas, 24 borradores</p>
          </div>
          <div data-lucide="book" class="text-gray-400" style="width:40px;height:40px;"></div>
        </div>
      </div>

      <div class="bg-white rounded-lg shadow-md p-6 border-l-4" style="border-left-color:#8b5cf6;">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-gray-500 text-sm font-medium">Publicaciones</p>
            <p class="text-3xl font-bold mt-2" style="color:#8b5cf6">0</p>
            <p class="text-gray-400 text-xs mt-1">Publicaciones en la comunidad</p>
          </div>
          <div data-lucide="message-square" class="text-gray-400" style="width:40px;height:40px;"></div>
        </div>
      </div>

      <div class="bg-white rounded-lg shadow-md p-6 border-l-4" style="border-left-color:#f59e0b;">
        <div class="flex items-center justify-between">
          <div>
            <p class="text-gray-500 text-sm font-medium">Tiempo Promedio</p>
            <p class="text-3xl font-bold mt-2" style="color:#f59e0b">35.83 min</p>
            <p class="text-gray-400 text-xs mt-1">Tiempo de preparación</p>
          </div>
          <div data-lucide="clock" class="text-gray-400" style="width:40px;height:40px;"></div>
        </div>
      </div>
    </div>

    <!-- Top Recetas y Ingredientes Populares -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6 mb-8">
      <!-- Top 5 Recetas -->
      <div class="bg-white rounded-lg shadow-md p-6">
        <div class="flex items-center justify-between mb-4">
          <h2 class="text-xl font-bold text-gray-800 flex items-center">
            <div data-lucide="star" class="mr-2 text-yellow-500" style="width:24px;height:24px;"></div>
            Top 5 Recetas
          </h2>
        </div>

        <div class="space-y-3">
          <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition">
            <div class="flex items-center space-x-3">
              <span class="bg-green-500 text-white rounded-full w-8 h-8 flex items-center justify-center font-bold text-sm">1</span>
              <div>
                <p class="font-semibold text-gray-800">Ensalada de Quinoa Vegana</p>
                <p class="text-xs text-gray-500">Por: admin</p>
              </div>
            </div>
            <div class="text-right">
              <p class="text-sm font-medium text-gray-600">30 min</p>
              <span class="text-xs bg-blue-100 text-blue-700 px-2 py-1 rounded-full">SALUDABLE</span>
            </div>
          </div>

          <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition">
            <div class="flex items-center space-x-3">
              <span class="bg-green-500 text-white rounded-full w-8 h-8 flex items-center justify-center font-bold text-sm">2</span>
              <div>
                <p class="font-semibold text-gray-800">Pollo a la Plancha con Verduras</p>
                <p class="text-xs text-gray-500">Por: admin</p>
              </div>
            </div>
            <div class="text-right">
              <p class="text-sm font-medium text-gray-600">25 min</p>
              <span class="text-xs bg-blue-100 text-blue-700 px-2 py-1 rounded-full">Principal</span>
            </div>
          </div>

          <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition">
            <div class="flex items-center space-x-3">
              <span class="bg-green-500 text-white rounded-full w-8 h-8 flex items-center justify-center font-bold text-sm">3</span>
              <div>
                <p class="font-semibold text-gray-800">Smoothie Energético</p>
                <p class="text-xs text-gray-500">Por: admin</p>
              </div>
            </div>
            <div class="text-right">
              <p class="text-sm font-medium text-gray-600">10 min</p>
              <span class="text-xs bg-blue-100 text-blue-700 px-2 py-1 rounded-full">BEBIDAS</span>
            </div>
          </div>

          <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition">
            <div class="flex items-center space-x-3">
              <span class="bg-green-500 text-white rounded-full w-8 h-8 flex items-center justify-center font-bold text-sm">4</span>
              <div>
                <p class="font-semibold text-gray-800">Sopa de Verduras</p>
                p class="text-xs text-gray-500">Por: admin</p>
              </div>
            </div>
            <div class="text-right">
              <p class="text-sm font-medium text-gray-600">40 min</p>
              <span class="text-xs bg-blue-100 text-blue-700 px-2 py-1 rounded-full">SALUDABLE</span>
            </div>
          </div>

          <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition">
            <div class="flex items-center space-x-3">
              <span class="bg-green-500 text-white rounded-full w-8 h-8 flex items-center justify-center font-bold text-sm">5</span>
              <div>
                <p class="font-semibold text-gray-800">Bowl de Arroz Integral con Salmón</p>
                <p class="text-xs text-gray-500">Por: admin</p>
              </div>
            </div>
            <div class="text-right">
              <p class="text-sm font-medium text-gray-600">35 min</p>
              <span class="text-xs bg-blue-100 text-blue-700 px-2 py-1 rounded-full">Principal</span>
            </div>
          </div>
        </div>
      </div>

      <!-- Ingredientes Populares -->
      <div class="bg-white rounded-lg shadow-md p-6">
        <div class="flex items-center justify-between mb-4">
          <h2 class="text-xl font-bold text-gray-800 flex items-center">
            <div data-lucide="trending-up" class="mr-2 text-orange-500" style="width:24px;height:24px;"></div>
            Ingredientes Más Usados
          </h2>
        </div>

        <div class="space-y-3">
          <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
            <div class="flex-1">
              <p class="font-semibold text-gray-800">Tomate</p>
              <div class="w-full bg-gray-200 rounded-full h-2 mt-2">
                <div class="bg-gradient-to-r from-orange-400 to-orange-600 h-2 rounded-full transition-all" style="width:100%"></div>
              </div>
            </div>
            <div class="ml-4 text-right">
              <p class="text-lg font-bold text-orange-600">7</p>
              <p class="text-xs text-gray-500">usos</p>
            </div>
          </div>

          <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
            <div class="flex-1">
              <p class="font-semibold text-gray-800">Cebolla</p>
              <div class="w-full bg-gray-200 rounded-full h-2 mt-2">
                <div class="bg-gradient-to-r from-orange-400 to-orange-600 h-2 rounded-full transition-all" style="width:85%"></div>
              </div>
            </div>
            <div class="ml-4 text-right">
              <p class="text-lg font-bold text-orange-600">6</p>
              <p class="text-xs text-gray-500">usos</p>
            </div>
          </div>

          <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
            <div class="flex-1">
              <p class="font-semibold text-gray-800">Espinaca</p>
              <div class="w-full bg-gray-200 rounded-full h-2 mt-2">
                <div class="bg-gradient-to-r from-orange-400 to-orange-600 h-2 rounded-full transition-all" style="width:57%"></div>
              </div>
            </div>
            <div class="ml-4 text-right">
              <p class="text-lg font-bold text-orange-600">4</p>
              <p class="text-xs text-gray-500">usos</p>
            </div>
          </div>

          <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
            <div class="flex-1">
              <p class="font-semibold text-gray-800">Zanahoria</p>
              <div class="w-full bg-gray-200 rounded-full h-2 mt-2">
                <div class="bg-gradient-to-r from-orange-400 to-orange-600 h-2 rounded-full transition-all" style="width:43%"></div>
              </div>
            </div>
            <div class="ml-4 text-right">
              <p class="text-lg font-bold text-orange-600">3</p>
              <p class="text-xs text-gray-500">usos</p>
            </div>
          </div>

          <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg">
            <div class="flex-1">
              <p class="font-semibold text-gray-800">Leche de almendra</p>
              <div class="w-full bg-gray-200 rounded-full h-2 mt-2">
                <div class="bg-gradient-to-r from-orange-400 to-orange-600 h-2 rounded-full transition-all" style="width:43%"></div>
              </div>
            </div>
            <div class="ml-4 text-right">
              <p class="text-lg font-bold text-orange-600">3</p>
              <p class="text-xs text-gray-500">usos</p>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Usuarios Activos -->
    <div class="bg-white rounded-lg shadow-md p-6 mb-8">
      <h2 class="text-xl font-bold text-gray-800 mb-4 flex items-center">
        <div data-lucide="activity" class="mr-2 text-green-500" style="width:24px;height:24px;"></div>
        Usuarios Más Activos
      </h2>

      <div class="overflow-x-auto">
        <table class="w-full">
          <thead class="bg-gray-50">
            <tr>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Usuario</th>
              <th class="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase">Nombre Completo</th>
              <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase">Recetas</th>
              <th class="px-6 py-3 text-center text-xs font-medium text-gray-500 uppercase">Seguidores</th>
            </tr>
          </thead>
          <tbody class="divide-y divide-gray-200">
            <tr class="hover:bg-gray-50 transition">
              <td class="px-6 py-4 whitespace-nowrap"><span class="font-medium text-gray-900">admin</span></td>
              <td class="px-6 py-4 whitespace-nowrap text-gray-600">Admin Nutrichef</td>
              <td class="px-6 py-4 whitespace-nowrap text-center"><span class="bg-blue-100 text-blue-700 px-3 py-1 rounded-full text-sm font-medium">24</span></td>
              <td class="px-6 py-4 whitespace-nowrap text-center text-gray-600">0</td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <!-- Actividad Reciente y Dominios -->
    <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
      <div class="bg-white rounded-lg shadow-md p-6">
        <h2 class="text-xl font-bold text-gray-800 mb-4 flex items-center">
          <div data-lucide="clock" class="mr-2 text-purple-500" style="width:24px;height:24px;"></div>
          Actividad Reciente
        </h2>

        <div class="space-y-3 max-h-96 overflow-y-auto">
          <div class="flex items-start space-x-3 p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition">
            <div class="bg-purple-100 rounded-full p-2 flex-shrink-0">
              <div data-lucide="book" class="text-purple-600" style="width:16px;height:16px;"></div>
            </div>
            <div class="flex-1">
              <p class="font-medium text-gray-800">Ensalada de Quinoa Vegana</p>
              <p class="text-xs text-gray-500 mt-1">Por <span class="font-medium">admin</span> • 2025-11-13</p>
            </div>
          </div>

          <div class="flex items-start space-x-3 p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition">
            <div class="bg-purple-100 rounded-full p-2 flex-shrink-0">
              <div data-lucide="book" class="text-purple-600" style="width:16px;height:16px;"></div>
            </div>
            <div class="flex-1">
              <p class="font-medium text-gray-800">Pollo a la Plancha con Verduras</p>
              <p class="text-xs text-gray-500 mt-1">Por <span class="font-medium">admin</span> • 2025-11-13</p>
            </div>
          </div>

          <div class="flex items-start space-x-3 p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition">
            <div class="bg-purple-100 rounded-full p-2 flex-shrink-0">
              <div data-lucide="book" class="text-purple-600" style="width:16px;height:16px;"></div>
            </div>
            <div class="flex-1">
              <p class="font-medium text-gray-800">Smoothie Energético</p>
              <p class="text-xs text-gray-500 mt-1">Por <span class="font-medium">admin</span> • 2025-11-13</p>
            </div>
          </div>

          <div class="flex items-start space-x-3 p-3 bg-gray-50 rounded-lg hover:bg-gray-100 transition">
            <div class="bg-purple-100 rounded-full p-2 flex-shrink-0">
              <div data-lucide="book" class="text-purple-600" style="width:16px;height:16px;"></div>
            </div>
            <div class="flex-1">
              <p class="font-medium text-gray-800">Sopa de Verduras</p>
              <p class="text-xs text-gray-500 mt-1">Por <span class="font-medium">admin</span> • 2025-11-13</p>
            </div>
          </div>
        </div>
      </div>

      <div class="bg-white rounded-lg shadow-md p-6">
        <h2 class="text-xl font-bold text-gray-800 mb-4">Catálogos del Sistema</h2>
        <div class="space-y-2">
          <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg hover:bg-blue-50 transition">
            <span class="font-medium text-gray-700">ALERGENO</span>
            <span class="bg-blue-500 text-white px-3 py-1 rounded-full text-sm font-bold">8 items</span>
          </div>
          <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg hover:bg-blue-50 transition">
            <span class="font-medium text-gray-700">DIETA</span>
            <span class="bg-blue-500 text-white px-3 py-1 rounded-full text-sm font-bold">10 items</span>
          </div>
          <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg hover:bg-blue-50 transition">
            <span class="font-medium text-gray-700">ESTADO</span>
            <span class="bg-blue-500 text-white px-3 py-1 rounded-full text-sm font-bold">2 items</span>
          </div>
          <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg hover:bg-blue-50 transition">
            <span class="font-medium text-gray-700">NIVEL_COCINA</span>
            <span class="bg-blue-500 text-white px-3 py-1 rounded-full text-sm font-bold">4 items</span>
          </div>
          <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg hover:bg-blue-50 transition">
            <span class="font-medium text-gray-700">TIPO_ALIMENTO</span>
            <span class="bg-blue-500 text-white px-3 py-1 rounded-full text-sm font-bold">12 items</span>
          </div>
          <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg hover:bg-blue-50 transition">
            <span class="font-medium text-gray-700">TIPO_REACCION</span>
            <span class="bg-blue-500 text-white px-3 py-1 rounded-full text-sm font-bold">3 items</span>
          </div>
          <div class="flex items-center justify-between p-3 bg-gray-50 rounded-lg hover:bg-blue-50 transition">
            <span class="font-medium text-gray-700">UNIDAD_MEDIDA</span>
            <span class="bg-blue-500 text-white px-3 py-1 rounded-full text-sm font-bold">11 items</span>
          </div>
        </div>
      </div>
    </div>
  </div>

  <!-- Modal -->
  <div id="modal" class="hidden fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50 p-4">
    <div class="bg-white rounded-lg shadow-xl max-w-2xl w-full max-h-[90vh] overflow-y-auto">
      <div class="p-6 border-b border-gray-200">
        <div class="flex items-center justify-between">
          <h3 id="modalTitle" class="text-2xl font-bold text-gray-800"></h3>
          <button onclick="closeModal()" class="text-gray-400 hover:text-gray-600 transition">
            <div data-lucide="x" style="width:24px;height:24px;"></div>
          </button>
        </div>
      </div>
      <div id="modalContent" class="p-6">
        <!-- El contenido se cargará dinámicamente -->
      </div>
    </div>
  </div>

  <script>
    // Inicializar iconos de Lucide
    document.addEventListener('DOMContentLoaded', function() {
      if(window.lucide) lucide.createIcons();
      
      // Establecer fecha actual
      const today = new Date();
      const formattedDate = today.toLocaleDateString('es-ES', {
        day: '2-digit',
        month: '2-digit',
        year: 'numeric'
      });
      document.getElementById('currentDate').textContent = formattedDate;
    });

    function showModal(action) {
      const modal = document.getElementById('modal');
      const modalTitle = document.getElementById('modalTitle');
      const modalContent = document.getElementById('modalContent');
      
      let title = '';
      let content = '';
      
      switch(action) {
        case 'add':
          title = 'Agregar Nueva Receta';
          content = `
            <form class="space-y-4">
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Nombre de la Receta</label>
                <input type="text" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500 focus:border-transparent" placeholder="Ej: Pasta Carbonara">
              </div>
              <div class="grid grid-cols-2 gap-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Nivel de Dificultad</label>
                  <select class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500">
                    <option>Fácil</option>
                    <option>Intermedio</option>
                    <option>Difícil</option>
                    <option>Experto</option>
                  </select>
                </div>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Categoría</label>
                <select class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500">
                  <option>Principal</option>
                  <option>Entrada</option>
                  <option>Postre</option>
                  <option>Bebida</option>
                  <option>Saludable</option>
                </select>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Descripción</label>
                <textarea class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500" rows="4" placeholder="Describe tu receta..."></textarea>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-1">Ingredientes (uno por línea)</label>
                <textarea class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-green-500" rows="5" placeholder="200g de pasta&#10;100g de panceta&#10;2 huevos"></textarea>
              </div>
              <div class="flex justify-end space-x-3 pt-4">
                <button type="button" onclick="closeModal()" class="px-6 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 transition">Cancelar</button>
                <button type="submit" class="px-6 py-2 bg-green-600 text-white rounded-lg hover:bg-green-700 transition">Guardar Receta</button>
              </div>
            </form>
          `;
          break;
          
        case 'view':
          title = 'Ver Todas las Recetas';
          content = `
            <div class="space-y-3">
              <div class="flex items-center space-x-3 p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition cursor-pointer">
                <img src="https://via.placeholder.com/60" alt="Receta" class="w-16 h-16 rounded-lg object-cover">
                <div class="flex-1">
                  <h4 class="font-semibold text-gray-800">Ensalada de Quinoa Vegana</h4>
                  <p class="text-sm text-gray-500">30 min • Saludable • Por: admin</p>
                </div>
                <span class="bg-yellow-100 text-yellow-700 px-3 py-1 rounded-full text-xs font-medium">Borrador</span>
              </div>
              <div class="flex items-center space-x-3 p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition cursor-pointer">
                <img src="https://via.placeholder.com/60" alt="Receta" class="w-16 h-16 rounded-lg object-cover">
                <div class="flex-1">
                  <h4 class="font-semibold text-gray-800">Pollo a la Plancha con Verduras</h4>
                  <p class="text-sm text-gray-500">25 min • Principal • Por: admin</p>
                </div>
                <span class="bg-yellow-100 text-yellow-700 px-3 py-1 rounded-full text-xs font-medium">Borrador</span>
              </div>
              <div class="flex items-center space-x-3 p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition cursor-pointer">
                <img src="https://via.placeholder.com/60" alt="Receta" class="w-16 h-16 rounded-lg object-cover">
                <div class="flex-1">
                  <h4 class="font-semibold text-gray-800">Smoothie Energético</h4>
                  <p class="text-sm text-gray-500">10 min • Bebida • Por: admin</p>
                </div>
                <span class="bg-yellow-100 text-yellow-700 px-3 py-1 rounded-full text-xs font-medium">Borrador</span>
              </div>
              <div class="flex items-center space-x-3 p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition cursor-pointer">
                <img src="https://via.placeholder.com/60" alt="Receta" class="w-16 h-16 rounded-lg object-cover">
                <div class="flex-1">
                  <h4 class="font-semibold text-gray-800">Sopa de Verduras</h4>
                  <p class="text-sm text-gray-500">40 min • Saludable • Por: admin</p>
                </div>
                <span class="bg-yellow-100 text-yellow-700 px-3 py-1 rounded-full text-xs font-medium">Borrador</span>
              </div>
              <div class="flex items-center space-x-3 p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition cursor-pointer">
                <img src="https://via.placeholder.com/60" alt="Receta" class="w-16 h-16 rounded-lg object-cover">
                <div class="flex-1">
                  <h4 class="font-semibold text-gray-800">Bowl de Arroz Integral con Salmón</h4>
                  <p class="text-sm text-gray-500">35 min • Principal • Por: admin</p>
                </div>
                <span class="bg-yellow-100 text-yellow-700 px-3 py-1 rounded-full text-xs font-medium">Borrador</span>
              </div>
              <div class="text-center pt-4">
                <p class="text-sm text-gray-500">Mostrando 5 de 24 recetas</p>
              </div>
            </div>
          `;
          break;
          
        case 'edit':
          title = 'Editar Receta';
          content = `
            <div class="mb-4">
              <label class="block text-sm font-medium text-gray-700 mb-2">Seleccionar Receta a Editar</label>
              <select class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-amber-500" onchange="loadRecipeToEdit(this.value)">
                <option value="">-- Selecciona una receta --</option>
                <option value="1">Ensalada de Quinoa Vegana</option>
                <option value="2">Pollo a la Plancha con Verduras</option>
                <option value="3">Smoothie Energético</option>
                <option value="4">Sopa de Verduras</option>
                <option value="5">Bowl de Arroz Integral con Salmón</option>
              </select>
            </div>
            <div id="editForm" class="hidden">
              <form class="space-y-4">
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Nombre de la Receta</label>
                  <input type="text" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-amber-500" value="Ensalada de Quinoa Vegana">
                </div>
                <div class="grid grid-cols-2 gap-4">
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Tiempo (minutos)</label>
                    <input type="number" class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-amber-500" value="30">
                  </div>
                  <div>
                    <label class="block text-sm font-medium text-gray-700 mb-1">Nivel de Dificultad</label>
                    <select class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-amber-500">
                      <option selected>Fácil</option>
                      <option>Intermedio</option>
                      <option>Difícil</option>
                      <option>Experto</option>
                    </select>
                  </div>
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Categoría</label>
                  <select class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-amber-500">
                    <option>Principal</option>
                    <option>Entrada</option>
                    <option>Postre</option>
                    <option>Bebida</option>
                    <option selected>Saludable</option>
                  </select>
                </div>
                <div>
                  <label class="block text-sm font-medium text-gray-700 mb-1">Descripción</label>
                  <textarea class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-amber-500" rows="4">Una deliciosa ensalada vegana con quinoa, vegetales frescos y aderezo casero.</textarea>
                </div>
                <div class="flex justify-end space-x-3 pt-4">
                  <button type="button" onclick="closeModal()" class="px-6 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 transition">Cancelar</button>
                  <button type="submit" class="px-6 py-2 bg-amber-600 text-white rounded-lg hover:bg-amber-700 transition">Actualizar Receta</button>
                </div>
              </form>
            </div>
          `;
          break;
          
        case 'delete':
          title = 'Eliminar Receta';
          content = `
            <div class="space-y-4">
              <div class="bg-red-50 border border-red-200 rounded-lg p-4 flex items-start space-x-3">
                <div data-lucide="alert-triangle" class="text-red-600 flex-shrink-0" style="width:24px;height:24px;"></div>
                <div>
                  <h4 class="font-semibold text-red-800">Advertencia</h4>
                  <p class="text-sm text-red-700 mt-1">Esta acción no se puede deshacer. La receta será eliminada permanentemente.</p>
                </div>
              </div>
              <div>
                <label class="block text-sm font-medium text-gray-700 mb-2">Seleccionar Receta a Eliminar</label>
                <select class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-red-500">
                  <option value="">-- Selecciona una receta --</option>
                  <option value="1">Ensalada de Quinoa Vegana</option>
                  <option value="2">Pollo a la Plancha con Verduras</option>
                  <option value="3">Smoothie Energético</option>
                  <option value="4">Sopa de Verduras</option>
                  <option value="5">Bowl de Arroz Integral con Salmón</option>
                </select>
              </div>
              <div class="flex justify-end space-x-3 pt-4">
                <button type="button" onclick="closeModal()" class="px-6 py-2 border border-gray-300 rounded-lg hover:bg-gray-50 transition">Cancelar</button>
                <button type="button" onclick="confirmDelete()" class="px-6 py-2 bg-red-600 text-white rounded-lg hover:bg-red-700 transition">Eliminar Receta</button>
              </div>
            </div>
          `;
          break;
          
        case 'users':
          title = 'Gestionar Usuarios';
          content = `
            <div class="space-y-4">
              <div class="flex justify-between items-center mb-4">
                <input type="text" placeholder="Buscar usuario..." class="flex-1 px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500">
                <button class="ml-3 px-4 py-2 bg-purple-600 text-white rounded-lg hover:bg-purple-700 transition flex items-center">
                  <div data-lucide="user-plus" class="mr-2" style="width:18px;height:18px;"></div>
                  Nuevo Usuario
                </button>
              </div>
              <div class="space-y-2">
                <div class="flex items-center justify-between p-4 bg-gray-50 rounded-lg hover:bg-gray-100 transition">
                  <div class="flex items-center space-x-3">
                    <img src="https://ui-avatars.com/api/?name=Admin&background=10b981&color=fff" class="w-12 h-12 rounded-full">
                    <div>
                      <h4 class="font-semibold text-gray-800">Admin Nutrichef</h4>
                      <p class="text-sm text-gray-500">admin@nutrichef.com</p>
                    </div>
                  </div>
                  <div class="flex items-center space-x-2">
                    <span class="bg-green-100 text-green-700 px-3 py-1 rounded-full text-xs font-medium">Admin</span>
                    <button class="p-2 text-blue-600 hover:bg-blue-50 rounded-lg transition">
                      <div data-lucide="edit-2" style="width:18px;height:18px;"></div>
                    </button>
                    <button class="p-2 text-red-600 hover:bg-red-50 rounded-lg transition">
                      <div data-lucide="trash-2" style="width:18px;height:18px;"></div>
                    </button>
                  </div>
                </div>
              </div>
            </div>
          `;
          break;
          
        case 'catalogs':
          title = 'Gestionar Catálogos';
          content = `
            <div class="space-y-3">
              <div class="border border-gray-200 rounded-lg p-4">
                <div class="flex items-center justify-between mb-3">
                  <h4 class="font-semibold text-gray-800 flex items-center">
                    <div data-lucide="alert-circle" class="mr-2 text-red-500" style="width:20px;height:20px;"></div>
                    ALERGENO (8 items)
                  </h4>
                  <button class="px-3 py-1 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition text-sm">Agregar</button>
                </div>
                <div class="flex flex-wrap gap-2">
                  <span class="bg-gray-100 text-gray-700 px-3 py-1 rounded-full text-sm">Gluten</span>
                  <span class="bg-gray-100 text-gray-700 px-3 py-1 rounded-full text-sm">Lácteos</span>
                  <span class="bg-gray-100 text-gray-700 px-3 py-1 rounded-full text-sm">Nueces</span>
                  <span class="bg-gray-100 text-gray-700 px-3 py-1 rounded-full text-sm">Mariscos</span>
                </div>
              </div>
              
              <div class="border border-gray-200 rounded-lg p-4">
                <div class="flex items-center justify-between mb-3">
                  <h4 class="font-semibold text-gray-800 flex items-center">
                    <div data-lucide="apple" class="mr-2 text-green-500" style="width:20px;height:20px;"></div>
                    DIETA (10 items)
                  </h4>
                  <button class="px-3 py-1 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition text-sm">Agregar</button>
                </div>
                <div class="flex flex-wrap gap-2">
                  <span class="bg-gray-100 text-gray-700 px-3 py-1 rounded-full text-sm">Vegana</span>
                  <span class="bg-gray-100 text-gray-700 px-3 py-1 rounded-full text-sm">Vegetariana</span>
                  <span class="bg-gray-100 text-gray-700 px-3 py-1 rounded-full text-sm">Keto</span>
                  <span class="bg-gray-100 text-gray-700 px-3 py-1 rounded-full text-sm">Paleo</span>
                </div>
              </div>
              
              <div class="border border-gray-200 rounded-lg p-4">
                <div class="flex items-center justify-between mb-3">
                  <h4 class="font-semibold text-gray-800 flex items-center">
                    <div data-lucide="chef-hat" class="mr-2 text-orange-500" style="width:20px;height:20px;"></div>
                    NIVEL_COCINA (4 items)
                  </h4>
                  <button class="px-3 py-1 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition text-sm">Agregar</button>
                </div>
                <div class="flex flex-wrap gap-2">
                  <span class="bg-gray-100 text-gray-700 px-3 py-1 rounded-full text-sm">Fácil</span>
                  <span class="bg-gray-100 text-gray-700 px-3 py-1 rounded-full text-sm">Intermedio</span>
                  <span class="bg-gray-100 text-gray-700 px-3 py-1 rounded-full text-sm">Difícil</span>
                  <span class="bg-gray-100 text-gray-700 px-3 py-1 rounded-full text-sm">Experto</span>
                </div>
              </div>
              
              <div class="border border-gray-200 rounded-lg p-4">
                <div class="flex items-center justify-between mb-3">
                  <h4 class="font-semibold text-gray-800 flex items-center">
                    <div data-lucide="utensils" class="mr-2 text-blue-500" style="width:20px;height:20px;"></div>
                    TIPO_ALIMENTO (12 items)
                  </h4>
                  <button class="px-3 py-1 bg-indigo-600 text-white rounded-lg hover:bg-indigo-700 transition text-sm">Agregar</button>
                </div>
                <div class="flex flex-wrap gap-2">
                  <span class="bg-gray-100 text-gray-700 px-3 py-1 rounded-full text-sm">Verduras</span>
                  <span class="bg-gray-100 text-gray-700 px-3 py-1 rounded-full text-sm">Frutas</span>
                  <span class="bg-gray-100 text-gray-700 px-3 py-1 rounded-full text-sm">Carnes</span>
                  <span class="bg-gray-100 text-gray-700 px-3 py-1 rounded-full text-sm">Lácteos</span>
                </div>
              </div>
            </div>
          `;
          break;
      }
      
      modalTitle.innerHTML = title;
      modalContent.innerHTML = content;
      modal.classList.remove('hidden');
      
      // Reinicializar iconos de Lucide después de cargar el contenido
      setTimeout(() => {
        if(window.lucide) lucide.createIcons();
      }, 100);
    }

    function closeModal() {
      document.getElementById('modal').classList.add('hidden');
    }

    function loadRecipeToEdit(value) {
      if(value) {
        document.getElementById('editForm').classList.remove('hidden');
      } else {
        document.getElementById('editForm').classList.add('hidden');
      }
    }

    function confirmDelete() {
      if(confirm('¿Estás seguro de que deseas eliminar esta receta? Esta acción no se puede deshacer.')) {
        alert('Receta eliminada exitosamente');
        closeModal();
      }
    }

    // Cerrar modal al hacer clic fuera de él
    document.getElementById('modal').addEventListener('click', function(e) {
      if(e.target === this) {
        closeModal();
      }
    });
  </script>
</body>
</html><?php /**PATH /var/www/resources/views/admin_dashboard.blade.php ENDPATH**/ ?>