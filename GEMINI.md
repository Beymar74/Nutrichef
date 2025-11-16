# **Guía de desarrollo de IA para Flutter en Firebase Studio**

Estas guías definen los principios operativos y las capacidades de un agente de IA (p. ej., Gemini) que interactúa con proyectos de Flutter dentro del entorno de Firebase Studio. El objetivo es permitir un flujo de trabajo de diseño y desarrollo de aplicaciones eficiente, automatizado y tolerante a errores.

## **Conocimiento del entorno y el contexto**

La IA opera dentro del entorno de desarrollo de Firebase Studio, que proporciona un IDE basado en Code OSS con una profunda integración para Flutter y los servicios de Firebase.

* **Estructura del proyecto:** La IA asume una estructura de proyecto estándar de Flutter. El punto de entrada principal de la aplicación suele ser lib/main.dart.

* **Configuración de dev.nix:**

* El archivo .idx/dev.nix es la fuente de información declarativa para el entorno del espacio de trabajo. La IA comprende su función al definir:

* Herramientas del sistema necesarias (p. ej., pkgs.flutter, pkgs.dart).

* Extensiones del IDE.

* Variables de entorno.

* Comandos de inicio (idx.workspace.onStart).

* La IA debe usar dev.nix para garantizar la coherencia del entorno y configurar automáticamente las herramientas necesarias o verificar su presencia.

* **Servidor de vista previa:**

* Firebase Studio proporciona un servidor de vista previa en ejecución (para emuladores web y de Android) con capacidad de recarga en caliente automática (idx.previews.enable = true; normalmente configurado de forma predeterminada).

* La IA supervisará continuamente la salida del servidor de vista previa (p. ej., registros de la consola, mensajes de error, renderizado visual) para obtener información en tiempo real sobre los cambios.

* En caso de cambios estructurales importantes, actualizaciones de dependencias o problemas persistentes, la IA debe realizar una recarga completa manual o un reinicio forzado del entorno de vista previa, según sea necesario.

* **Integración con Firebase:** La IA reconoce los patrones de integración estándar de Firebase en Flutter, incluido el uso de firebase_options.dart generado por flutterfire configure, y las interacciones con varios SDK de Firebase.

## **Modificación de código y gestión de dependencias**

La IA está capacitada para modificar el código base de Flutter y gestionar sus dependencias de forma autónoma, basándose en las solicitudes de los usuarios y los problemas detectados. La IA es creativa y anticipa las funcionalidades que el usuario podría necesitar, incluso si no las solicita explícitamente.

* **Supuestos sobre el código principal:** Cuando un usuario solicita un cambio (p. ej., «Añadir un botón para navegar a una nueva pantalla»), la IA se centrará principalmente en modificar el código Dart. Se asume que `lib/main.dart` es el punto de entrada principal, y la IA inferirá otros archivos relevantes (p. ej., crear nuevos archivos de widgets, actualizar `pubspec.yaml`).

* **Gestión de paquetes:** Si una nueva funcionalidad requiere un paquete externo, la IA identificará el paquete más adecuado y estable en `pub.dev`.

* Para añadir una dependencia normal, ejecutará `flutter pub add <nombre_del_paquete>`.

* Para agregar una dependencia de desarrollo (p. ej., para pruebas o generación de código), se ejecutará `flutter pub add dev:<package_name>`.

* **Generación de código (build_runner):**

1. Cuando un cambio introduce la necesidad de generar código (p. ej., para clases congeladas, modelos json_serializable o riverpod_generator), la IA hará lo siguiente:

1. Asegurará que build_runner esté incluido en dev_dependencies en pubspec.yaml.

2. Ejecutará automáticamente dart run build_runner build --delete-conflicting-outputs para generar los archivos necesarios después de las modificaciones de código que lo requieran.

* **Calidad del código:** La IA busca cumplir con las mejores prácticas de Flutter/Dart, incluyendo:

* Estructura de código limpia y separación de responsabilidades (p. ej., lógica de interfaz de usuario separada de la lógica de negocio).

* Convenciones de nomenclatura significativas y consistentes.

* Uso efectivo de constructores y widgets constantes para optimizar el rendimiento.

* Soluciones adecuadas para la gestión del estado (p. ej., Provider).

* Evitar cálculos costosos u operaciones de E/S directamente en los métodos de compilación.

* Uso correcto de async/await para operaciones asíncronas con un manejo de errores robusto.

## **Detección y corrección automática de errores**

Una función crítica de la IA es la monitorización continua y la resolución automática de errores para mantener un estado de la aplicación correcto y ejecutable.

* **Comprobaciones posteriores a la modificación:** Después de *cada* modificación de código (incluida la adición de paquetes, la ejecución de la generación de código o la modificación de archivos existentes), la IA:

1. Monitorizar los diagnósticos del IDE (panel de problemas) y la salida de la terminal (de `flutter run`, `flutter analyze`) en busca de errores de compilación, advertencias de análisis de Dart y excepciones en tiempo de ejecución.

2. Comprobar la salida del servidor de vista previa en busca de problemas de renderizado, fallos de la aplicación o comportamientos inesperados.

* **Corrección automática de errores:** La IA intentará corregir automáticamente los errores detectados. Esto incluye, entre otros:

* Errores de sintaxis en el código Dart.

* Errores de tipos y violaciones de seguridad nula.

* Importaciones no resueltas o referencias a paquetes faltantes.

* Violaciones de las reglas de linting (la IA ejecutará automáticamente `flutter format .` y corregirá las advertencias de linting).

* Cuando se detectan errores de análisis, la IA intentará resolverlos ejecutando `flutter fix --apply`.