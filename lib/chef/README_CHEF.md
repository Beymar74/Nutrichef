# 📁 Carpeta `chef/`

Esta carpeta contiene todas las pantallas y componentes relacionados con la funcionalidad del **Chef** en la aplicación **NutriChef**.

---

## 📄 Descripción de archivos

### 🏠 Pantalla Principal

#### **`home_chef.dart`** (Pantalla principal del Chef)
**Estado:** 🟡 Modificado

**Descripción:**
Pantalla principal del panel de control del Chef. Muestra un dashboard completo con estadísticas, filtros y gestión de recetas.

**Características:**
- ✅ Dashboard con estadísticas en tiempo real
- ✅ Filtros por estado de recetas (Todas, Publicadas, Pendientes, Rechazadas, Borradores)
- ✅ Lista de recetas del chef
- ✅ Acciones rápidas (Nueva receta, Ver estadísticas, Editar borradores)
- ✅ Bottom navigation bar
- ✅ Notificaciones
- ✅ Pull to refresh

**Navegación desde:**
- Login como Chef
- Registro como Chef

**Navega a:**
- `crear_receta.dart` - Crear nueva receta
- `editar_receta.dart` - Editar receta existente
- `ver_receta_chef.dart` - Ver detalles de receta
- `estadisticas_chef_screen.dart` - Ver estadísticas detalladas
- `perfil_chef_screen.dart` - Ver y editar perfil
- `catalogo_recetas.dart` - Ver catálogo completo

---

### 📊 Gestión de Recetas

#### **`crear_receta.dart`** (Crear nueva receta)
**Estado:** ✅ Existente

**Descripción:**
Formulario completo para crear una nueva receta desde cero.

**Características:**
- ✅ Formulario multi-paso o completo
- ✅ Campos: título, descripción, ingredientes, pasos, tiempo de preparación
- ✅ Upload de imágenes
- ✅ Selección de categorías
- ✅ Información nutricional
- ✅ Validación de campos

**Parámetros requeridos:**
- `chefId` (int) - ID del chef que crea la receta

---

#### **`editar_receta.dart`** (Editar receta existente)
**Estado:** ✅ Existente

**Descripción:**
Formulario para editar una receta previamente creada.

**Características:**
- ✅ Pre-carga de datos existentes
- ✅ Edición de todos los campos de la receta
- ✅ Cambio de imágenes
- ✅ Actualización de estado
- ✅ Validación de campos

**Parámetros requeridos:**
- `receta` (Receta) - Objeto completo de la receta a editar

---

#### **`ver_receta_chef.dart`** (Ver detalles de receta)
**Estado:** ✅ Existente

**Descripción:**
Vista detallada de una receta desde la perspectiva del chef (propietario).

**Características:**
- ✅ Vista completa de la receta
- ✅ Estadísticas de la receta (vistas, comentarios, favoritos)
- ✅ Comentarios y calificaciones
- ✅ Opciones de editar/eliminar
- ✅ Historial de cambios

**Parámetros requeridos:**
- `receta` (Receta) - Objeto completo de la receta a visualizar

---

### 🧩 Componentes Reutilizables

#### **`receta_card_widget.dart`** (Widget de tarjeta de receta)
**Estado:** 🆕 Nuevo

**Descripción:**
Widget reutilizable que muestra una tarjeta de receta con toda su información y acciones.

**Características:**
- ✅ Imagen de la receta
- ✅ Título y descripción
- ✅ Estado de la receta (badge con color)
- ✅ Estadísticas (vistas, rating, comentarios, favoritos)
- ✅ Acciones: Ver, Editar, Eliminar
- ✅ Diseño responsive

**Parámetros requeridos:**
- `receta` (Receta) - Objeto de la receta
- `onEditar` (VoidCallback) - Callback al editar
- `onEliminar` (VoidCallback) - Callback al eliminar

**Extensión incluida:**
- `RecetaExtensions` - Añade propiedades como `estado`, `visualizaciones`, `calificacion`, etc.

---

### 📈 Estadísticas y Análisis

#### **`estadisticas_chef_screen.dart`** (Estadísticas detalladas)
**Estado:** 🆕 Nuevo

**Descripción:**
Pantalla completa dedicada a mostrar estadísticas y métricas detalladas del chef.

**Características:**
- ✅ Resumen general (vistas, rating, comentarios, favoritos)
- ✅ Recetas destacadas (más vista, mejor calificada, más comentada)
- ✅ Distribución de recetas por estado
- ✅ Gráficos visuales
- ✅ Métricas de rendimiento

**Parámetros requeridos:**
- `misRecetas` (List<Receta>) - Lista de todas las recetas del chef
- `recetasPublicadas` (List<Receta>) - Lista de recetas publicadas
- `totalVisualizaciones` (int) - Total de vistas
- `calificacionPromedio` (double) - Calificación promedio
- `totalComentarios` (int) - Total de comentarios
- `totalFavoritos` (int) - Total de favoritos

---

### 👤 Perfil y Configuración

#### **`perfil_chef_screen.dart`** (Perfil del chef)
**Estado:** 🟡 Actualizado

**Descripción:**
Pantalla del perfil personal del chef con su información y estadísticas.

**Características:**
- ✅ Avatar del chef
- ✅ Información personal (nombre, email, ID)
- ✅ Badge de chef profesional
- ✅ Estadísticas de recetas
- ✅ Botones: Editar perfil, Configuración, Cerrar sesión
- ✅ Navegación a pantallas de edición

**Parámetros requeridos:**
- `nombreChef` (String) - Nombre del chef
- `chefId` (int) - ID del chef
- `emailChef` (String) - Email del chef
- `totalRecetas` (int) - Número total de recetas
- `recetasPublicadas` (int) - Número de recetas publicadas
- `calificacionPromedio` (double) - Calificación promedio

**Navega a:**
- `editar_perfil_chef_screen.dart` - Editar perfil
- `configuracion_chef_screen.dart` - Configuración

---

#### **`editar_perfil_chef_screen.dart`** (Editar perfil)
**Estado:** 🆕 Nuevo

**Descripción:**
Formulario completo para editar la información del perfil del chef.

**Características:**
- ✅ **Información Personal:**
  - Nombre completo
  - Correo electrónico
  - Teléfono
  
- ✅ **Información Profesional:**
  - Especialidad culinaria
  - Biografía
  
- ✅ **Otras funciones:**
  - Cambio de foto de perfil (cámara/galería)
  - Cambio de contraseña
  - Eliminar cuenta (con doble confirmación)
  
- ✅ Validación de formulario
- ✅ Loading states
- ✅ Feedback visual

**Parámetros requeridos:**
- `nombreChef` (String) - Nombre actual del chef
- `emailChef` (String) - Email actual del chef

**Parámetros opcionales:**
- `telefono` (String?) - Teléfono del chef
- `biografia` (String?) - Biografía del chef
- `especialidad` (String?) - Especialidad culinaria

---

#### **`configuracion_chef_screen.dart`** (Configuración)
**Estado:** 🆕 Nuevo

**Descripción:**
Pantalla completa de configuración de la aplicación para el chef.

**Características:**

**🔔 Notificaciones:**
- Nuevas recetas
- Comentarios en recetas
- Calificaciones
- Favoritos
- Notificaciones por email

**🔒 Privacidad y Seguridad:**
- Perfil público/privado
- Mostrar/ocultar email
- Mostrar/ocultar teléfono
- Gestión de cuentas bloqueadas
- Descargar datos personales (GDPR)

**🎨 Apariencia:**
- Modo oscuro
- Selección de idioma (Español, English, Português)

**ℹ️ Acerca de:**
- Términos y condiciones
- Política de privacidad
- Centro de ayuda (FAQ)
- Reportar problemas
- Versión de la app

**🚪 Sesión:**
- Cerrar sesión

---

## 🔄 Flujo de navegación

```
home_chef.dart (Principal)
    ├── crear_receta.dart
    │   └── [Guarda] → Vuelve a home_chef
    │
    ├── editar_receta.dart
    │   └── [Guarda] → Vuelve a home_chef
    │
    ├── ver_receta_chef.dart
    │   └── [Puede ir a editar_receta]
    │
    ├── estadisticas_chef_screen.dart
    │   └── [Vista completa de stats]
    │
    └── perfil_chef_screen.dart
        ├── editar_perfil_chef_screen.dart
        │   └── [Guarda] → Vuelve a perfil
        │
        └── configuracion_chef_screen.dart
            └── [Configura] → Vuelve a perfil
```

---

## 🎨 Paleta de colores utilizada

```dart
Color(0xFFFF8C21)  // Naranja principal
Color(0xFFFFB84D)  // Naranja claro (gradiente)
Color(0xFFEC888D)  // Rosa (títulos)
Color(0xFFFFD54F)  // Amarillo (badges)
Color(0xFF4CAF50)  // Verde (publicadas, success)
Color(0xFFFFA726)  // Naranja (pendientes, warning)
Color(0xFFF44336)  // Rojo (rechazadas, eliminar)
Color(0xFF9E9E9E)  // Gris (borradores)
Color(0xFF2196F3)  // Azul (información)
```

---

## 📦 Modelos utilizados

### `Receta` (receta_model.dart)
```dart
class Receta {
  int id;
  String titulo;
  String resumen;
  String? imagen;
  String? estado;
  int? visualizaciones;
  double? calificacion;
  int? totalComentarios;
  int? totalFavoritos;
  // ... más campos
}
```

### `Usuario` (usuario_model.dart)
```dart
Map<String, dynamic> usuario = {
  'id': int,
  'name': String,
  'nombres': String,
  'email': String,
  // ... más campos
}
```

---

## 🔧 Servicios utilizados

### `RecetaService` (receta_service.dart)
```dart
- obtenerRecetas()
- crearReceta()
- actualizarReceta()
- eliminarReceta()
```

---

## ✅ Estado de los archivos

| Archivo | Estado | Descripción |
|---------|--------|-------------|
| `home_chef.dart` | 🟡 Modificado | Refactorizado y optimizado |
| `crear_receta.dart` | ✅ Existente | Sin cambios |
| `editar_receta.dart` | ✅ Existente | Sin cambios |
| `ver_receta_chef.dart` | ✅ Existente | Sin cambios |
| `receta_card_widget.dart` | 🆕 Nuevo | Widget reutilizable |
| `estadisticas_chef_screen.dart` | 🆕 Nuevo | Pantalla completa |
| `perfil_chef_screen.dart` | 🟡 Actualizado | Conectado con nuevas pantallas |
| `editar_perfil_chef_screen.dart` | 🆕 Nuevo | Formulario completo |
| `configuracion_chef_screen.dart` | 🆕 Nuevo | Configuración completa |

---

## 🚀 Próximas mejoras sugeridas

1. **Implementar caché local** para mejorar performance
2. **Agregar búsqueda y filtros avanzados** en las recetas
3. **Implementar gráficos** más avanzados en estadísticas
4. **Agregar notificaciones push** reales
5. **Implementar subida de imágenes** real con Firebase/API
6. **Agregar modo offline** con sincronización
7. **Implementar analytics** para tracking de uso

---

## 📱 Screenshots sugeridos

- Home Chef Dashboard
- Lista de recetas filtradas
- Estadísticas detalladas
- Perfil del chef
- Formulario de editar perfil
- Pantalla de configuración

---

## 🐛 Testing requerido

- [ ] Crear receta completo
- [ ] Editar receta existente
- [ ] Eliminar receta con confirmación
- [ ] Filtros de estado funcionando
- [ ] Navegación entre pantallas
- [ ] Formulario de perfil con validación
- [ ] Configuración de notificaciones
- [ ] Cerrar sesión correctamente

---

## 📝 Notas importantes

- Todos los archivos están ubicados en `lib/chef/`
- Los colores siguen la paleta de NutriChef
- Las extensiones de `Receta` están en `receta_card_widget.dart`
- Los servicios API aún necesitan implementación real
- El código está comentado y es mantenible

---

**Última actualización:** Diciembre 2024
**Versión:** 1.0.0
**Desarrollado por:** Team Con Pila - NutriChef