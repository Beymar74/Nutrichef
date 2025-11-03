<p align="center"><a href="https://laravel.com" target="_blank"><img src="https://raw.githubusercontent.com/laravel/art/master/logo-lockup/5%20SVG/2%20CMYK/1%20Full%20Color/laravel-logolockup-cmyk-red.svg" width="400" alt="Logotipo de Laravel"></a></p>

<p align="center">
<a href="https://github.com/laravel/framework/actions"><img src="https://github.com/laravel/framework/workflows/tests/badge.svg" alt="Estado de compilación"></a>

<a href="https://packagist.org/packages/laravel/framework"><img <a href="https://img.shields.io/packagist/dt/laravel/framework" alt="Total Downloads"></a>

<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/v/laravel/framework" alt="Latest Stable Version"></a>

<a href="https://packagist.org/packages/laravel/framework"><img src="https://img.shields.io/packagist/l/laravel/framework" alt="License"></a>

</p>

## Acerca de Laravel

Laravel es un framework para aplicaciones web con una sintaxis expresiva y elegante. Creemos que el desarrollo debe ser una experiencia creativa y placentera para ser realmente gratificante. Laravel simplifica el desarrollo al facilitar tareas comunes en muchos proyectos web, como:

- Motor de enrutamiento simple y rápido.

- Potente contenedor de inyección de dependencias.

- Múltiples backends para el almacenamiento de sesiones y caché.

- ORM de base de datos expresivo e intuitivo.

- Migraciones de esquema independientes de la base de datos.

- Robusto procesamiento de tareas en segundo plano.

- Difusión de eventos en tiempo real.

Laravel es accesible, potente y proporciona las herramientas necesarias para crear aplicaciones robustas y de gran tamaño.

## Aprendiendo Laravel

Laravel cuenta con la [documentación](https://laravel.com/docs) y la biblioteca de videotutoriales más extensa y completa de todos los frameworks modernos para aplicaciones web, lo que facilita enormemente el aprendizaje. También puedes consultar [Laravel Learn](https://laravel.com/learn), donde encontrarás una guía paso a paso para crear una aplicación moderna con Laravel.

Si prefieres no leer, [Laracasts](https://laracasts.com) puede ayudarte. Laracasts contiene miles de videotutoriales sobre una amplia gama de temas, incluyendo Laravel, PHP moderno, pruebas unitarias y JavaScript. Mejora tus habilidades explorando nuestra completa biblioteca de vídeos.

## Patrocinadores de Laravel

Agradecemos a los siguientes patrocinadores su apoyo financiero para el desarrollo de Laravel. Si te interesa convertirte en patrocinador, visita el [programa de socios de Laravel](https://partners.laravel.com).

### Socios Premium

- **[Vehikl](https://vehikl.com)**

- **[Tighten Co.](https://tighten.co)**

- **[Kirschbaum Development Group](https://kirschbaumdevelopment.com)**

- **[64 Robots](https://64robots.com)**

- **[Curotec](https://www.curotec.com/services/technologies/laravel)**

- **[DevSquad](https://devsquad.com/hire-laravel-developers)**

- **[Redberry](https://redberry.international/laravel-development)**

- **[Active Logic](https://activelogic.com)**

## Contribuciones

¡Gracias por considerar contribuir al framework Laravel! La guía de contribución se encuentra en la [documentación de Laravel](https://laravel.com/docs/contributions).

## Código de Conducta

Para garantizar que la comunidad de Laravel sea inclusiva, revise y cumpla con el [Código de Conducta](https://laravel.com/docs/contributions#code-of-conduct).

## Vulnerabilidades de seguridad

Si descubre una vulnerabilidad de seguridad en Laravel, envíe un correo electrónico a Taylor Otwell a través de [taylor@laravel.com](mailto:taylor@laravel.com). Todas las vulnerabilidades de seguridad se abordarán con prontitud.

## Licencia

El framework Laravel es software de código abierto con licencia MIT (https://opensource.org/licenses/MIT).

# 🥗 NutriChef - Sistema Inteligente de Gestión de Recetas Saludables

![Laravel](https://img.shields.io/badge/Laravel-FF2D20?style=for-the-badge&logo=laravel&logoColor=white)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)

**Equipo:** Con Pila  
**Institución:** Escuela Militar de Ingeniería  
**Materia:** Ingeniería de Software I  
**Semestre:** 7mo - 2025

---

## 📋 Tabla de Contenidos

1. [Descripción del Proyecto](#-descripción-del-proyecto)
2. [Arquitectura del Sistema](#-arquitectura-del-sistema)
3. [Contenedores Docker](#-contenedores-docker)
4. [Instalación Rápida](#-instalación-rápida)
5. [Tecnologías Utilizadas](#-tecnologías-utilizadas)
6. [Equipo de Desarrollo](#-equipo-de-desarrollo)

---

## 📖 Descripción del Proyecto

**NutriChef** es una aplicación móvil de gestión y recomendación inteligente de recetas saludables que permite a los usuarios:

- 🔍 Buscar recetas adaptadas a diferentes dietas (vegetariana, vegana, celíaca, deportista)
- 👨‍🍳 Seguir instrucciones paso a paso con un asistente interactivo
- 📅 Planificar menús semanales personalizados
- 🛒 Generar listas de compras automáticas
- ⭐ Guardar recetas favoritas
- 📸 Subir fotos de sus propias recetas

---

## 🏗️ Arquitectura del Sistema

```
┌─────────────────────────────────────────────────────────┐
│                    APLICACIÓN MÓVIL                      │
│                  Flutter (Android/iOS)                   │
└────────────────────┬────────────────────────────────────┘
                     │ HTTP REST API
                     ↓
┌─────────────────────────────────────────────────────────┐
│                   BACKEND (Laravel)                      │
│                   Puerto: 8000                           │
└─────────┬───────────────────────────────────────────────┘
          │
          ├──→ PostgreSQL (Base de datos principal)
          ├──→ Redis (Caché para velocidad)
          ├──→ MinIO (Almacenamiento de imágenes)
          ├──→ Elasticsearch (Motor de búsqueda)
          └──→ Mailhog (Sistema de emails)
```

---

## 🐳 Contenedores Docker

Nuestro proyecto utiliza **7 contenedores Docker** que trabajan juntos para proporcionar todas las funcionalidades de NutriChef.

### 1️⃣ PostgreSQL - Base de Datos Principal

**Contenedor:** `nutrichef_db`  
**Puerto:** `5432`  
**Imagen:** `postgres:15-alpine`

#### ¿Para qué sirve?
Almacena toda la información persistente del sistema:
- 👤 Usuarios (nombre, apellido, email, contraseñas)
- 🍽️ Recetas (título, ingredientes, pasos, valores nutricionales)
- ⭐ Favoritos de cada usuario
- 📅 Planes de comidas semanales
- 🔐 Tokens de autenticación y recuperación de contraseña

#### ¿Por qué PostgreSQL?
- ✅ Base de datos relacional robusta y confiable
- ✅ Excelente para datos estructurados (recetas, usuarios, relaciones)
- ✅ Soporta JSON para campos complejos (ingredientes, pasos)
- ✅ Open source y ampliamente usado en producción

#### Credenciales:
- **Base de datos:** `nutrichef`
- **Usuario:** `nutrichef_user`
- **Contraseña:** `nutrichef_password`

---

### 2️⃣ Laravel API - Backend

**Contenedor:** `nutrichef_api`  
**Puerto:** `8000`  
**Framework:** `Laravel 11` con PHP 8.2

#### ¿Para qué sirve?
Es el cerebro de la aplicación. Procesa todas las peticiones de la app móvil:
- 🔐 Autenticación y registro de usuarios
- 📊 CRUD de recetas (Crear, Leer, Actualizar, Eliminar)
- 🔍 Búsqueda y filtrado de recetas
- ⭐ Gestión de favoritos
- 📧 Envío de emails (recuperación de contraseña, notificaciones)
- 🖼️ Procesamiento de imágenes
- 📱 API REST para la app móvil

#### URL:
```
http://localhost:8000
```

#### Ejemplo de endpoints:
```
GET    /api/v1/recetas          - Listar recetas
GET    /api/v1/recetas/{id}     - Ver receta específica
POST   /api/v1/recetas          - Crear nueva receta
PUT    /api/v1/recetas/{id}     - Actualizar receta
DELETE /api/v1/recetas/{id}     - Eliminar receta
POST   /api/v1/login            - Iniciar sesión
POST   /api/v1/register         - Registrar usuario
```

---

### 3️⃣ Adminer - Administrador de Base de Datos

**Contenedor:** `nutrichef_adminer`  
**Puerto:** `8080`  
**Imagen:** `adminer:latest`

#### ¿Para qué sirve?
Interfaz web para administrar la base de datos PostgreSQL:
- 📊 Ver tablas y sus datos
- ✏️ Ejecutar consultas SQL
- 🔍 Buscar registros específicos
- ➕ Insertar datos de prueba
- 🗑️ Eliminar registros
- 📈 Ver estructura de tablas

#### URL:
```
http://localhost:8080
```

#### Credenciales de acceso:
- **System:** PostgreSQL
- **Server:** postgres
- **Username:** nutrichef_user
- **Password:** nutrichef_password
- **Database:** nutrichef

#### ¿Cuándo usarlo?
- Durante desarrollo para ver datos en tiempo real
- Para insertar datos de prueba
- Para debug de problemas con la base de datos
- Para hacer consultas SQL complejas

---

### 4️⃣ MinIO - Almacenamiento de Archivos

**Contenedor:** `nutrichef_storage`  
**Puertos:** `9000` (API), `9001` (Console)  
**Imagen:** `minio/minio:latest`

#### ¿Para qué sirve?
Almacena todos los archivos multimedia de la aplicación:
- 📸 Fotos de recetas subidas por usuarios
- 🖼️ Imágenes de perfil de usuarios
- 🎨 Assets e imágenes del sistema
- 📄 Documentos y PDFs (menús, listas de compras)

#### ¿Por qué MinIO?
- ✅ Compatible con Amazon S3 (fácil migrar a la nube)
- ✅ Almacenamiento eficiente y escalable
- ✅ Open source y gratuito
- ✅ Interfaz web para administrar archivos

#### URLs:
- **API:** `http://localhost:9000`
- **Console:** `http://localhost:9001`

#### Credenciales:
- **Username:** nutrichef
- **Password:** nutrichef123

#### Ejemplo de uso en Flutter:
```dart
// Usuario sube foto de su receta
File image = await picker.pickImage();
String imageUrl = await uploadToMinio(image);
// imageUrl = "http://localhost:9000/recetas/foto_123.jpg"
```

---

### 5️⃣ Redis - Sistema de Caché

**Contenedor:** `nutrichef_redis`  
**Puerto:** `6379`  
**Imagen:** `redis:7-alpine`

#### ¿Para qué sirve?
Acelera la aplicación guardando datos temporales en memoria RAM:
- ⚡ Caché de recetas más populares (evita consultas repetidas a PostgreSQL)
- 🔐 Sesiones de usuario (quién está conectado)
- 🔍 Resultados de búsquedas frecuentes
- 📊 Contadores (vistas de recetas, likes)
- ⏱️ Datos temporales con expiración automática

#### ¿Por qué Redis?
- ✅ **Velocidad extrema:** 10-100x más rápido que consultar la base de datos
- ✅ Reduce la carga en PostgreSQL
- ✅ Mejora la experiencia del usuario (respuestas instantáneas)
- ✅ Ahorra ancho de banda

#### Ejemplo de impacto:
```
SIN Redis:
Usuario abre app → Consulta PostgreSQL → 500ms de respuesta

CON Redis:
Usuario abre app → Lee de caché → 50ms de respuesta
(10x más rápido)
```

---

### 6️⃣ Mailhog - Sistema de Emails (Desarrollo)

**Contenedor:** `nutrichef_mail`  
**Puertos:** `1025` (SMTP), `8025` (Web UI)  
**Imagen:** `mailhog/mailhog:latest`

#### ¿Para qué sirve?
Simula un servidor de email para desarrollo y testing:
- 📧 Captura todos los emails enviados por Laravel
- 👀 Permite ver los emails en una interfaz web
- ✅ Probar emails de recuperación de contraseña
- 📨 Verificar emails de bienvenida
- 🔔 Ver formato de notificaciones

#### URL:
```
http://localhost:8025
```

#### ¿Por qué Mailhog?
- ✅ No envía emails reales (evita spam durante desarrollo)
- ✅ Perfecto para testing
- ✅ Ver emails sin configurar servidor SMTP real
- ✅ Todos los emails quedan guardados para revisión

#### Ejemplo de uso:
```
1. Usuario solicita "olvidé mi contraseña"
2. Laravel envía email
3. Mailhog lo captura
4. Desarrollador abre http://localhost:8025
5. Ve el email con el link de recuperación
6. Puede probar que funciona correctamente
```

**Nota:** En producción, Mailhog se reemplaza por un servicio real (Gmail SMTP, SendGrid, etc.)

---

### 7️⃣ Elasticsearch - Motor de Búsqueda

**Contenedor:** `nutrichef_search`  
**Puerto:** `9200`  
**Imagen:** `elasticsearch:8.11.0`

#### ¿Para qué sirve?
Proporciona búsqueda inteligente y rápida de recetas:
- 🔍 Búsqueda por texto completo ("pasta vegana fácil")
- 🎯 Búsqueda por ingredientes ("pollo, arroz, verduras")
- 🏷️ Filtrado avanzado (calorías, tiempo de preparación, dificultad)
- 💡 Autocompletado ("ensa..." → "ensaladas")
- 📈 Ranking inteligente (resultados más relevantes primero)
- 🔤 Búsqueda con errores de tipeo ("ennsalada" encuentra "ensalada")

#### ¿Por qué Elasticsearch?
- ✅ Búsqueda extremadamente rápida (milisegundos)
- ✅ Búsqueda inteligente con relevancia
- ✅ Soporta búsqueda en español con stemming
- ✅ Usado por grandes empresas (GitHub, Netflix, Uber)

#### URL:
```
http://localhost:9200
```

#### Ejemplo de búsqueda:
```json
// Usuario busca: "recetas veganas rápidas con menos de 300 calorías"
// Elasticsearch devuelve:
{
  "results": [
    {
      "titulo": "Ensalada vegana de quinoa",
      "tiempo": 15,
      "calorias": 280,
      "score": 9.5
    },
    {
      "titulo": "Wrap vegano de verduras",
      "tiempo": 10,
      "calorias": 250,
      "score": 9.2
    }
  ]
}
```

---

## 🚀 Instalación Rápida

### Requisitos Previos
- ✅ Docker Desktop instalado
- ✅ Git instalado
- ✅ 8 GB de RAM disponible
- ✅ 10 GB de espacio en disco

### Pasos de Instalación

```bash
# 1. Clonar el repositorio
git clone https://github.com/Beymar74/Nutrichef.git
cd Nutrichef

# 2. Construir las imágenes (primera vez)
docker-compose build

# 3. Levantar todos los contenedores
docker-compose up -d

# 4. Dar permisos a Laravel
docker exec -it nutrichef_api chmod -R 777 storage bootstrap/cache

# 5. Ejecutar migraciones de base de datos
docker exec -it nutrichef_api php artisan migrate

# 6. Verificar que todo funciona
docker-compose ps
```

### Verificar Instalación

Abre en tu navegador:

| Servicio | URL | Descripción |
|----------|-----|-------------|
| 🚀 **Laravel** | http://localhost:8000 | API Backend |
| 🎨 **Adminer** | http://localhost:8080 | Admin de BD |
| 📦 **MinIO** | http://localhost:9001 | Storage |
| 📧 **Mailhog** | http://localhost:8025 | Emails |
| 🔍 **Elasticsearch** | http://localhost:9200 | Búsqueda |

Si todos abren correctamente, **¡la instalación fue exitosa!** ✅

---

## 🛠️ Comandos Útiles

### Gestión de Contenedores

```bash
# Ver estado de todos los contenedores
docker-compose ps

# Ver logs en tiempo real
docker-compose logs -f

# Ver logs de un contenedor específico
docker-compose logs -f laravel

# Detener todos los contenedores
docker-compose down

# Reiniciar un contenedor
docker-compose restart laravel

# Reconstruir imágenes
docker-compose up -d --build
```

### Comandos de Laravel (Artisan)

```bash
# Crear un controlador
docker exec -it nutrichef_api php artisan make:controller RecetaController

# Crear un modelo
docker exec -it nutrichef_api php artisan make:model Receta

# Crear una migración
docker exec -it nutrichef_api php artisan make:migration create_recetas_table

# Ejecutar migraciones
docker exec -it nutrichef_api php artisan migrate

# Crear datos de prueba
docker exec -it nutrichef_api php artisan db:seed

# Limpiar caché
docker exec -it nutrichef_api php artisan cache:clear

# Ver rutas disponibles
docker exec -it nutrichef_api php artisan route:list

# Entrar al contenedor
docker exec -it nutrichef_api bash
```

### Comandos de Base de Datos

```bash
# Conectarse a PostgreSQL
docker exec -it nutrichef_db psql -U nutrichef_user -d nutrichef

# Ver todas las tablas
docker exec -it nutrichef_db psql -U nutrichef_user -d nutrichef -c "\dt"

# Ver estructura de una tabla
docker exec -it nutrichef_db psql -U nutrichef_user -d nutrichef -c "\d usuarios"

# Ejecutar una consulta
docker exec -it nutrichef_db psql -U nutrichef_user -d nutrichef -c "SELECT * FROM usuarios;"

# Hacer backup de la base de datos
docker exec nutrichef_db pg_dump -U nutrichef_user nutrichef > backup_$(date +%Y%m%d).sql

# Restaurar backup
docker exec -i nutrichef_db psql -U nutrichef_user nutrichef < backup.sql
```

---

## 🔧 Tecnologías Utilizadas

### Backend
- **Laravel 11** - Framework PHP
- **PostgreSQL 15** - Base de datos relacional
- **PHP 8.2** - Lenguaje de programación

### Frontend
- **Flutter** - Framework de desarrollo móvil
- **Dart** - Lenguaje de programación

### Infraestructura
- **Docker** - Contenedorización
- **Docker Compose** - Orquestación de contenedores

### Servicios Adicionales
- **Redis 7** - Sistema de caché en memoria
- **MinIO** - Almacenamiento de objetos (S3-compatible)
- **Elasticsearch 8** - Motor de búsqueda
- **Mailhog** - Servidor SMTP de prueba
- **Adminer** - Administrador de base de datos


## 📊 Estructura del Proyecto

```
Nutrichef/
├── backend/                 # Laravel API
│   ├── app/
│   │   ├── Http/
│   │   │   └── Controllers/
│   │   └── Models/
│   ├── database/
│   │   └── migrations/
│   ├── routes/
│   │   └── api.php
│   └── .env
├── myapp/                   # Flutter App
│   ├── lib/
│   │   ├── main.dart
│   │   ├── services/
│   │   └── screens/
│   └── pubspec.yaml
├── docker-compose.yml       # Configuración de contenedores
├── Dockerfile              # Imagen de Laravel
└── README.md               # Este archivo
```

---

## 🐛 Solución de Problemas

### Problema: "No se puede conectar a la base de datos"

**Solución:**
```bash
# Verificar que PostgreSQL está corriendo
docker-compose ps

# Ver logs de PostgreSQL
docker-compose logs postgres

# Reiniciar el contenedor
docker-compose restart postgres
```

### Problema: "Laravel muestra error 500"

**Solución:**
```bash
# Ver logs de Laravel
docker-compose logs laravel

# Limpiar caché
docker exec -it nutrichef_api php artisan cache:clear
docker exec -it nutrichef_api php artisan config:clear

# Verificar permisos
docker exec -it nutrichef_api chmod -R 777 storage bootstrap/cache
```

### Problema: "Puerto 8000 ya está en uso"

**Solución:**
```bash
# Ver qué está usando el puerto
netstat -ano | findstr :8000

# Cambiar el puerto en docker-compose.yml
ports:
  - "8001:8000"  # Usar 8001 en lugar de 8000
```

### Problema: "No tengo espacio en disco"

**Solución:**
```bash
# Limpiar imágenes no usadas
docker image prune -a

# Limpiar volúmenes no usados
docker volume prune

# Ver uso de espacio
docker system df
```

---

## 📄 Licencia

Este proyecto es académico y fue desarrollado como requisito parcial para la asignatura de Ingeniería de Software I en la Escuela Militar de Ingeniería.

---

## 📞 Contacto

Para dudas o problemas técnicos, contactar a cualquier miembro del equipo "Con Pila".

---

**NutriChef** - Tu compañero perfecto para una vida saludable 🥗

Desarrollado con ❤️ por el equipo "Con Pila" - EMI 2025