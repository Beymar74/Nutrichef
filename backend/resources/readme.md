📘 Guía Técnica del Módulo de Administración - NutriChef

Este documento detalla la estructura, funcionamiento y flujo de datos del módulo de gestión de recetas en el panel administrativo de NutriChef.

1. Arquitectura General (MVC)

El proyecto sigue el patrón Modelo-Vista-Controlador (MVC) de Laravel, con una separación clara de responsabilidades:

Modelo (App\Models\Receta): Define la estructura de los datos y sus relaciones con otras tablas.

Controlador (Admin\RecetaController): Maneja la lógica de negocio (filtrar, buscar, eliminar, actualizar).

Vista (resources/views/admin/recetas/...): Renderiza la interfaz de usuario (HTML + Blade + Tailwind).

Rutas (routes/web.php): Conecta las URLs del navegador con los métodos del controlador.

2. Estructura de Archivos Clave

📂 Rutas

routes/web.php: Define las URLs accesibles.

GET /admin/recetas -> Lista todas las recetas.

GET /admin/recetas/{id} -> Muestra el detalle de una receta.

DELETE /admin/recetas/{id} -> Elimina una receta.

POST /admin/recetas/{id}/approve -> Aprueba una receta.

📂 Controladores

app/Http/Controllers/Admin/RecetaController.php: El cerebro del módulo.

index(): Recupera recetas con paginación y filtros. Usa Eager Loading (with()) para optimizar consultas.

show(): Busca una receta por ID y carga sus relaciones (ingredientes, autor).

destroy(): Elimina el registro de la base de datos.

approve() / reject(): Cambia el id_estado de la receta.

📂 Modelos

app/Models/Receta.php:

Define relaciones clave: creador (Usuario), estado (Subdominio), multimedia (Fotos).

Permite acceder a datos relacionados fácilmente: $receta->creador->name.

📂 Vistas (Blade)

resources/views/layouts/admin.blade.php: La plantilla maestra. Contiene:

<head> con Tailwind CSS y Lucide Icons.

Barra Lateral (Sidebar) con navegación.

Barra Superior (Navbar).

Espacio @yield('contenido') donde se inyectan las páginas específicas.

resources/views/admin/recetas/index.blade.php: La tabla principal.

Itera sobre $recetas usando @forelse.

Muestra botones de acción y filtros.

resources/views/admin/recetas/show.blade.php: La vista de detalle para moderación.

resources/views/components/modal-confirm.blade.php: Componente reutilizable para confirmar acciones destructivas.

3. Flujo de Datos: "Eliminar una Receta"

Para entender cómo funciona todo junto, veamos el ciclo de vida de una acción común: Eliminar.

Usuario (Admin): Hace clic en el botón de "Basurero" en la tabla (index.blade.php).

JavaScript: La función openModal() intercepta el clic:

Muestra el modal visualmente.

Actualiza la URL del formulario dentro del modal para apuntar a /admin/recetas/{ID_RECETA}.

Usuario: Confirma haciendo clic en "Sí, eliminar".

Navegador: Envía una petición POST con un campo oculto _method=DELETE a la ruta definida.

Laravel (Router): Detecta la petición DELETE y la dirige a RecetaController@destroy.

Controlador:

Busca la receta: Receta::findOrFail($id).

Ejecuta $receta->delete().

Redirige atrás con with('success', '...').

Vista (index.blade.php):

Recarga la página.

Detecta session('success') y muestra la alerta verde de éxito.

La receta eliminada ya no aparece en la lista.

4. Componentes Visuales y Clases CSS

Usamos Tailwind CSS para el diseño. Aquí una guía rápida de los colores personalizados:

Color

Clase Tailwind

Uso Principal

Naranja

bg-calabaza-500

Botones primarios, ítems activos, badges de "Pendiente".

Verde

bg-emerald-100

Badges de "Publicada", mensajes de éxito.

Rojo

text-red-600

Botones de eliminar, badges de "Rechazada".

Gris

text-slate-500

Textos secundarios, bordes sutiles.