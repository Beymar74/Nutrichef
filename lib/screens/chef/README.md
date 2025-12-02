Nutrichef - Desarrollo de la Aplicación Móvil 🍳📱

Este documento resume el progreso realizado en la implementación de la aplicación móvil Nutrichef, específicamente en la integración del frontend (Flutter) con el backend (Laravel) para el módulo de perfiles de chef y detalles de recetas.

🚀 Resumen del Progreso

Hemos trabajado en conectar la interfaz de usuario de Flutter con una API RESTful en Laravel para lograr una experiencia dinámica y funcional. Los hitos clave alcanzados son:

Diseño e Implementación de UI: Creación de pantallas modernas y responsivas en Flutter.

Desarrollo de API Backend: Creación de controladores y rutas en Laravel para servir datos.

Integración Frontend-Backend: Consumo de servicios REST para mostrar datos reales.

Gestión de Estado y Sesión: Uso de SharedPreferences para manejar la identidad del usuario.

Lógica de Negocio (Seguir/Dejar de Seguir): Implementación completa de la funcionalidad "Follow".

🛠️ Tecnologías Utilizadas

Frontend: Flutter (Dart)

Backend: Laravel (PHP)

Base de Datos: PostgreSQL

Gestión de Estado Local: shared_preferences

Cliente HTTP: http (paquete Dart)

📂 Estructura de Archivos Clave

Frontend (Flutter)

lib/screens/login.dart:

Maneja el inicio de sesión.

Crucial: Guarda auth_token, auth_user_id y auth_role en las preferencias compartidas tras un login exitoso.

Redirige a la pantalla adecuada (Home o HomeChef) según el rol del usuario.

lib/screens/chef/chef_profile_screen.dart:

Muestra el perfil completo de un chef.

Funcionalidades:

Carga datos del chef (nombre, bio, fotos) desde la API.

Muestra estadísticas (recetas, seguidores, seguidos).

Lista las recetas creadas por ese chef.

Botón "Seguir" Funcional: Verifica si el usuario actual ya sigue al chef y permite alternar el estado (toggle), actualizando la UI en tiempo real.

lib/detalles-receta.dart:

Muestra el detalle completo de una receta seleccionada.

Incluye botón para ir al perfil del creador (ChefProfileScreen) pasando el chefId correcto.

Botón "Seguir" Integrado: También permite seguir al chef directamente desde la vista de la receta.

Backend (Laravel)

routes/api.php:

Define los endpoints accesibles para la app.

GET /chefs/{id}: Obtiene datos del perfil.

POST /chefs/{id}/follow: Gestiona la acción de seguir/dejar de seguir.

GET /chefs/{id}/is-following: Verifica el estado de seguimiento.

GET /imagenes/recetas/{id}: Sirve las imágenes almacenadas como binarios (BYTEA) en la base de datos.

app/Http/Controllers/ChefController.php:

Controlador principal para la lógica del perfil.

Utiliza Eloquent ORM para consultas eficientes (withCount, with).

Formatea la respuesta JSON para que coincida con los modelos de Flutter.

Maneja la conversión de imágenes binarias a respuestas HTTP visibles.

app/Http/Controllers/FollowController.php:

Maneja la lógica de seguimiento.

Evita que un usuario se siga a sí mismo.

Crea o elimina registros en la tabla seguidores.

app/Models/Usuario.php y app/Models/Receta.php:

Modelos Eloquent con relaciones definidas (recetas(), seguidores(), seguidos()).

Incluyen Accessors útiles como rating_promedio.

🔄 Flujo de Datos Implementado

Inicio de Sesión:

El usuario se loguea en la app.

El backend valida credenciales y devuelve un objeto usuario + token.

Flutter guarda el id del usuario en SharedPreferences (auth_user_id).

Navegación al Perfil:

El usuario toca el avatar de un chef en DetallesRecetaScreen.

Se navega a ChefProfileScreen enviando el chefId.

Carga de Datos (Perfil):

ChefProfileScreen lee auth_user_id de la memoria local.

Hace una petición GET al backend enviando follower_id (el ID del usuario logueado).

El backend responde con los datos del chef y un booleano is_following (true/false).

Acción de Seguir:

El usuario pulsa "Seguir".

Flutter envía una petición POST al backend con follower_id.

El backend crea/borra la relación en la BD.

El backend devuelve el nuevo estado y el nuevo conteo de seguidores.

Flutter actualiza el botón y el contador instantáneamente.

⚠️ Puntos de Atención y Solución de Errores

Error "No puedes seguirte a ti mismo":

Causa: Al probar, el usuario logueado (ID 1) intentaba seguir al chef de la receta (que también era el usuario ID 1).

Solución: Se validó que para probar esta funcionalidad es necesario loguearse con un usuario distinto al creador de la receta.

Imágenes:

Las imágenes se guardan como BYTEA en PostgreSQL.

Se implementó una ruta especial en Laravel para servir estos binarios como imágenes normales web, permitiendo que Flutter las cargue con Image.network().

IP del Servidor:

Se configuró la app para apuntar a la IP local de tu máquina (192.168.0.16:18000) para permitir la conexión desde un dispositivo físico o emulador externo.

✅ Estado Actual

El sistema de Perfil de Chef está completamente funcional e integrado. Los usuarios pueden ver perfiles reales, ver sus recetas y seguir a sus chefs favoritos, con toda la información persistiendo correctamente en la base de datos PostgreSQL.