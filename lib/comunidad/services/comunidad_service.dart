import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ComunidadService extends ChangeNotifier {
  bool loading = false;
  List<dynamic> posts = [];
  List<dynamic> comentarios = [];
  String? ultimoError; // ✅ NUEVO: Almacenar último error

  final String baseUrl = "http://192.168.0.5:18000/api";

  // ================================
  // CREAR PUBLICACIÓN (Sin imágenes) - MEJORADO
  // ================================
  Future<bool> crearPublicacion(String descripcion, String token) async {
    ultimoError = null; // Limpiar error anterior
    
    try {
      print("📤 Enviando publicación sin imágenes...");
      print("📝 URL: $baseUrl/publicaciones");
      print("📝 Descripción length: ${descripcion.length}");
      
      final response = await http.post(
        Uri.parse("$baseUrl/publicaciones"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: jsonEncode({"descripcion": descripcion}),
      );

      print("📡 Status Code: ${response.statusCode}");
      print("📡 Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Publicación creada exitosamente");
        return true;
      } else {
        // ❌ Capturar error del servidor
        try {
          final errorBody = jsonDecode(response.body);
          ultimoError = errorBody['message'] ?? 
                       errorBody['error'] ?? 
                       "Error ${response.statusCode}";
          print("❌ Error del servidor: $ultimoError");
        } catch (e) {
          ultimoError = "Error ${response.statusCode}: ${response.body}";
          print("❌ Error sin formato JSON: ${response.body}");
        }
        return false;
      }
    } catch (e) {
      ultimoError = "Error de conexión: $e";
      print("❌ Excepción al crear publicación: $e");
      return false;
    }
  }

  // ================================
  // CREAR PUBLICACIÓN CON IMÁGENES - MEJORADO
  // ================================
  Future<bool> crearPublicacionConImagenes(
    String descripcion,
    List<File> imagenes,
    String token,
  ) async {
    ultimoError = null;
    
    print("📤 Iniciando subida con imágenes...");
    print("📝 URL: $baseUrl/publicaciones");
    print("📝 Descripción: ${descripcion.substring(0, 50)}...");
    print("🖼️ Total imágenes: ${imagenes.length}");

    final url = Uri.parse("$baseUrl/publicaciones");
    final request = http.MultipartRequest("POST", url);
    
    request.headers["Authorization"] = "Bearer $token";
    request.headers["Accept"] = "application/json";
    request.fields["descripcion"] = descripcion;

    // ✅ Validar y agregar imágenes
    int imagenesValidas = 0;
    for (var i = 0; i < imagenes.length; i++) {
      if (!imagenes[i].existsSync()) {
        print("❌ Imagen $i no existe: ${imagenes[i].path}");
        continue;
      }

      try {
        final fileSize = imagenes[i].lengthSync();
        print("📷 Imagen $i: ${(fileSize / 1024 / 1024).toStringAsFixed(2)} MB");
        
        // ⚠️ Validar tamaño (máx 10MB por imagen)
        if (fileSize > 10 * 1024 * 1024) {
          print("❌ Imagen $i muy grande (>10MB)");
          ultimoError = "Imagen ${i + 1} es muy grande (máx 10MB)";
          return false;
        }

        final img = await http.MultipartFile.fromPath(
          "imagenes[]",
          imagenes[i].path,
        );
        request.files.add(img);
        imagenesValidas++;
        print("✅ Imagen $i agregada correctamente");
      } catch (e) {
        print("❌ Error al procesar imagen $i: $e");
        ultimoError = "Error procesando imagen ${i + 1}";
        return false;
      }
    }

    if (imagenesValidas == 0) {
      ultimoError = "No se pudo procesar ninguna imagen";
      print("❌ No hay imágenes válidas");
      return false;
    }

    print("📤 Enviando ${imagenesValidas} imágenes al servidor...");

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      print("📡 Status Code: ${response.statusCode}");
      print("📡 Response Body: ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Publicación con imágenes creada exitosamente");
        return true;
      } else {
        // ❌ Capturar error del servidor
        try {
          final errorBody = jsonDecode(response.body);
          ultimoError = errorBody['message'] ?? 
                       errorBody['error'] ?? 
                       "Error ${response.statusCode}";
          print("❌ Error del servidor: $ultimoError");
          
          // Mostrar errores de validación si existen
          if (errorBody['errors'] != null) {
            print("📋 Errores de validación:");
            errorBody['errors'].forEach((key, value) {
              print("  • $key: $value");
            });
          }
        } catch (e) {
          ultimoError = "Error ${response.statusCode}: ${response.body}";
          print("❌ Respuesta no JSON: ${response.body}");
        }
        return false;
      }
    } catch (e) {
      ultimoError = "Error de conexión: $e";
      print("❌ Excepción al subir publicación: $e");
      return false;
    }
  }

  // ================================
  // RESTO DE MÉTODOS (sin cambios)
  // ================================
  
  Future<void> cargarFeed(String token) async {
    loading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/publicaciones"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json"
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        posts = body["data"] ?? [];
        print("✅ Feed cargado: ${posts.length} publicaciones");
      } else {
        print("❌ Error al cargar feed: ${response.statusCode}");
        posts = [];
      }
    } catch (e) {
      print("❌ Error cargando feed: $e");
      posts = [];
    }

    loading = false;
    notifyListeners();
  }

  Future<void> likeToggle(int idPublicacion, String token) async {
    final idx = posts.indexWhere((p) => p['id'] == idPublicacion);
    if (idx == -1) return;

    final yaDioLike = posts[idx]['ya_dio_like'] ?? false;
    final likesActuales = posts[idx]['likes_count'] ?? 0;

    posts[idx]['ya_dio_like'] = !yaDioLike;
    posts[idx]['likes_count'] = yaDioLike ? likesActuales - 1 : likesActuales + 1;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/publicaciones/$idPublicacion/reaccion"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json"
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        posts[idx]['ya_dio_like'] = body['ya_dio_like'];
        posts[idx]['likes_count'] = body['likes_count'];
      } else {
        posts[idx]['ya_dio_like'] = yaDioLike;
        posts[idx]['likes_count'] = likesActuales;
      }
    } catch (e) {
      print("❌ Error en toggle like: $e");
      posts[idx]['ya_dio_like'] = yaDioLike;
      posts[idx]['likes_count'] = likesActuales;
    }

    notifyListeners();
  }

  void ocultarPublicacion(int id) {
    posts.removeWhere((p) => p['id'] == id);
    notifyListeners();
  }

  Future<bool> eliminarPublicacion(int idPublicacion, String token) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/publicaciones/$idPublicacion"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json"
        },
      );

      if (response.statusCode == 200) {
        posts.removeWhere((p) => p['id'] == idPublicacion);
        notifyListeners();
        print("✅ Publicación eliminada");
        return true;
      } else {
        print("❌ Error eliminar: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("❌ Error eliminar publicación: $e");
      return false;
    }
  }

  Future<bool> reportarPublicacion(int idPublicacion, String token) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/publicaciones/reportar/$idPublicacion"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json"
        },
      );

      if (response.statusCode == 200) {
        print("✅ Publicación reportada");
        return true;
      }
      return false;
    } catch (e) {
      print("❌ Error al reportar: $e");
      return false;
    }
  }

  Future<void> obtenerComentarios(int idPublicacion, String token) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/publicaciones/$idPublicacion/comentarios"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json"
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        comentarios = body["data"] ?? [];
        print("✅ Comentarios cargados: ${comentarios.length}");
      } else {
        print("❌ Error cargar comentarios: ${response.statusCode}");
        comentarios = [];
      }
    } catch (e) {
      print("❌ Error obtener comentarios: $e");
      comentarios = [];
    }

    notifyListeners();
  }

  Future<bool> agregarComentario(
      int idPublicacion, String contenido, String token) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/publicaciones/$idPublicacion/comentarios"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: jsonEncode({"contenido": contenido}),
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        
        comentarios.add(body['data']);
        
        final idx = posts.indexWhere((p) => p['id'] == idPublicacion);
        if (idx != -1) {
          posts[idx]['comentarios_count'] =
              (posts[idx]['comentarios_count'] ?? 0) + 1;
        }
        
        notifyListeners();
        print("✅ Comentario agregado");
        return true;
      }
      return false;
    } catch (e) {
      print("❌ Error agregar comentario: $e");
      return false;
    }
  }

  Future<bool> eliminarComentario(int idComentario, int idPublicacion, String token) async {
    try {
      final response = await http.delete(
        Uri.parse("$baseUrl/comentarios/$idComentario"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json"
        },
      );

      if (response.statusCode == 200) {
        comentarios.removeWhere((c) => c['id'] == idComentario);
        
        final idx = posts.indexWhere((p) => p['id'] == idPublicacion);
        if (idx != -1) {
          posts[idx]['comentarios_count'] =
              (posts[idx]['comentarios_count'] ?? 0) - 1;
        }
        
        notifyListeners();
        print("✅ Comentario eliminado");
        return true;
      }
      return false;
    } catch (e) {
      print("❌ Error eliminar comentario: $e");
      return false;
    }
  }

  Future<bool> actualizarPublicacion(
      int id, String descripcion, String token) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/publicaciones/$id"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: jsonEncode({"descripcion": descripcion}),
      );

      if (response.statusCode == 200) {
        final idx = posts.indexWhere((p) => p['id'] == id);
        if (idx != -1) {
          posts[idx]['descripcion'] = descripcion;
          notifyListeners();
        }
        print("✅ Publicación actualizada");
        return true;
      }
      return false;
    } catch (e) {
      print("❌ Error actualizar publicación: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>?> obtenerPublicacionPorId(
      int id, String token) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/publicaciones/$id"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        return body["data"];
      }
    } catch (e) {
      print("❌ Error obtener publicación: $e");
    }

    return null;
  }

  Future<bool> actualizarPublicacionConImagenes(
    int idPublicacion,
    String descripcion,
    List<File> imagenes,
    String token,
  ) async {
    final url = Uri.parse("$baseUrl/publicaciones/$idPublicacion");
    final request = http.MultipartRequest("POST", url);
    
    request.headers["Authorization"] = "Bearer $token";
    request.headers["Accept"] = "application/json";
    request.fields["_method"] = "PUT";
    request.fields["descripcion"] = descripcion;

    for (var i = 0; i < imagenes.length; i++) {
      if (!imagenes[i].existsSync()) continue;

      try {
        final img = await http.MultipartFile.fromPath(
          "imagenes[]",
          imagenes[i].path,
        );
        request.files.add(img);
      } catch (e) {
        print("❌ Error al agregar imagen $i: $e");
      }
    }

    try {
      final response = await request.send();
      final body = await response.stream.bytesToString();

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Publicación actualizada con imágenes");
        return true;
      }
      return false;
    } catch (e) {
      print("❌ Error al actualizar publicación: $e");
      return false;
    }
  }

  void limpiarComentarios() {
    comentarios = [];
    notifyListeners();
  }
}