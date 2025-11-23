📘 NutriChef - Sistema de Gestión Administrativa

NutriChef Admin es una plataforma robusta diseñada para la gestión integral de contenido culinario, usuarios y planificación nutricional. Este sistema permite a los administradores mantener la calidad y seguridad de la comunidad mediante herramientas avanzadas de moderación y análisis.

🚀 Características Principales

1. 🛡️ Gestión de Seguridad y Usuarios

Autenticación Robusta: Login seguro con protección CSRF.

Roles y Permisos: Sistema basado en roles (Administrador, Chef, Usuario, Nutricionista).

Directorio de Usuarios: Listado completo con búsqueda inteligente.

Control de Acceso: Capacidad de bloquear/desbloquear usuarios instantáneamente.

Edición de Perfil: Los administradores pueden corregir datos personales y reasignar roles.

2. 🍲 Gestión de Recetas (Core)

Moderación de Contenido: Flujo de aprobación estricto. Las recetas subidas por usuarios entran en estado PENDIENTE y requieren revisión.

Acciones de Revisión: * ✅ Aprobar: Publica la receta y notifica al autor.

❌ Rechazar: Oculta la receta y envía feedback al autor.

🗑️ Eliminar: Borrado lógico o físico según configuración.

Edición Administrativa: Corrección rápida de títulos, tiempos o instrucciones sin contactar al autor.

3. 💬 Sistema Social y Moderación

Comentarios: Módulo dedicado para supervisar la interacción entre usuarios.

Filtros de Estado: Visualización rápida de comentarios REPORTADOS, VISIBLES o ELIMINADOS.

Acciones: Eliminación de comentarios ofensivos con un solo clic.

4. 🔔 Sistema de Notificaciones

Emails Automáticos: Envío de correos electrónicos a los autores cuando sus recetas son aprobadas o rechazadas.

Feedback Inmediato: Mejora la retención de usuarios al mantenerlos informados sobre el estado de su contenido.

5. ⚙️ Configuración Dinámica (Catálogos)

Gestión de Dominios: Interfaz para administrar las listas desplegables del sistema sin tocar código.

Flexibilidad Total: Agrega o quita "Tipos de Alimento", "Dietas", "Alergias" o "Unidades de Medida" en tiempo real.

6. 📅 Planificación y Monitoreo

Historial de Comidas: Visualización de las planificaciones realizadas por los usuarios para análisis de tendencias de consumo.

🛠️ Arquitectura Técnica y Ubicación de Archivos

El proyecto está construido sobre Laravel 10+ siguiendo el patrón MVC. Aquí tienes el mapa de los archivos clave que componen el sistema:

📍 Rutas y Configuración

Rutas Web: routes/web.php (Define todas las URLs del panel admin).

Configuración Auth: config/auth.php (Define el modelo Usuario como autenticable).

📍 Controladores (app/Http/Controllers/Admin/)

DashboardController.php (Métricas y gráficas).

UsuarioController.php (CRUD de usuarios).

RecetaController.php (Moderación de recetas).

ComentarioController.php (Moderación de comentarios).

PlanificacionController.php (Visualización de planes).

ConfiguracionController.php (Gestión de dominios).

Auth: app/Http/Controllers/Auth/LoginController.php (Login/Logout).

📍 Modelos (app/Models/)

Usuarios: Usuario.php, Persona.php, Rol.php.

Recetas: Receta.php, MultimediaReceta.php, IngredienteReceta.php.

Social: Publicacion.php, Comentario.php, Calificacion.php, Reaccion.php.

Configuración: Dominio.php, Subdominio.php.

Planificación: PlanificadorComida.php, HorarioUsuario.php.

📍 Vistas (resources/views/)

Layout Principal: layouts/admin.blade.php (Sidebar, Navbar, Scripts).

Login: auth/login.blade.php.

Dashboard: admin/dashboard/dashboard.blade.php.

Usuarios: admin/usuarios/index.blade.php, show.blade.php, create.blade.php, edit.blade.php.

Recetas: admin/recetas/index.blade.php, show.blade.php, edit.blade.php.

Comentarios: admin/comentarios/index.blade.php.

Planificación: admin/planificacion/index.blade.php.

Configuración: admin/configuracion/index.blade.php.

📍 Otros Componentes

Seeders: database/seeders/ (DominiosSeeder.php, AdminUserSeeder.php, ComentariosSeeder.php).

Notificaciones: app/Notifications/RecetaAnalizada.php.

📦 Instalación y Despliegue

Sigue estos pasos para levantar el proyecto en un entorno local:

1. Requisitos Previos

PHP >= 8.1

Composer

PostgreSQL (Recomendado) o MySQL

2. Configuración Inicial

# Clonar repositorio
git clone [https://github.com/tu-usuario/nutrichef-admin.git](https://github.com/tu-usuario/nutrichef-admin.git)
cd nutrichef-admin

# Instalar dependencias PHP
composer install

# Instalar dependencias JS (Tailwind)
npm install && npm run build

# Configurar entorno
cp .env.example .env
php artisan key:generate


3. Base de Datos

Configura tus credenciales de base de datos en el archivo .env y luego ejecuta:

# Crear tablas
php artisan migrate

# Poblar datos maestros (CRÍTICO: Crea roles, admin y catálogos)
php artisan db:seed --class=DatabaseSeeder
# O individualmente:
# php artisan db:seed --class=DominiosSeeder
# php artisan db:seed --class=AdminUserSeeder
# php artisan db:seed --class=ComentariosSeeder


4. Ejecución

php artisan serve


Accede a: http://localhost:8000

📝 Notas para Desarrolladores

Rutas: Todas las rutas administrativas están prefijadas con /admin y protegidas por el middleware auth.

Modales: Se utiliza una función global openModal(id, url) en el layout principal para manejar confirmaciones de eliminación. No crear scripts de modales individuales en cada vista.

Seeders: Si agregas un nuevo catálogo al sistema, asegúrate de actualizar DominiosSeeder.php.

Desarrollado con ❤️ por el equipo de Ingeniería de Sistemas - NutriChef.