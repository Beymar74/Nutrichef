import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/publicacion_model.dart';

class ComunidadService extends ChangeNotifier {
  bool loading = false;
  List<dynamic> posts = [];
  List<dynamic> comentarios = [];

  final String baseUrl = "http://192.168.0.5:18000/api";

  // ================================
  // CARGAR FEED
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

  // ================================
  // LIKE TOGGLE (MEJORADO)
  // ================================
  Future<void> likeToggle(int idPublicacion, String token) async {
    // ✅ Actualización optimista (UI instantánea)
    final idx = posts.indexWhere((p) => p['id'] == idPublicacion);
    if (idx == -1) return;

    final yaDioLike = posts[idx]['ya_dio_like'] ?? false;
    final likesActuales = posts[idx]['likes_count'] ?? 0;

    // Actualizar UI inmediatamente
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
        // ✅ Sincronizar con respuesta del servidor
        final body = jsonDecode(response.body);
        posts[idx]['ya_dio_like'] = body['ya_dio_like'];
        posts[idx]['likes_count'] = body['likes_count'];
        print("✅ Like actualizado correctamente");
      } else {
        // ❌ Revertir cambio si falla
        print("❌ Error toggle like: ${response.statusCode}");
        posts[idx]['ya_dio_like'] = yaDioLike;
        posts[idx]['likes_count'] = likesActuales;
      }
    } catch (e) {
      print("❌ Error en toggle like: $e");
      // ❌ Revertir cambio si hay excepción
      posts[idx]['ya_dio_like'] = yaDioLike;
      posts[idx]['likes_count'] = likesActuales;
    }

    notifyListeners();
  }

  // ================================
  // OCULTAR (LOCAL)
  // ================================
  void ocultarPublicacion(int id) {
    posts.removeWhere((p) => p['id'] == id);
    notifyListeners();
  }

  // ================================
  // ELIMINAR PUBLICACIÓN
  // ================================
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

  // ================================
  // REPORTAR PUBLICACIÓN
  // ================================
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

  // ================================
  // OBTENER COMENTARIOS
  // ================================
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

  // ================================
  // AGREGAR COMENTARIO
  // ================================
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
        
        // Agregar comentario a la lista
        comentarios.add(body['data']);
        
        // Actualizar contador en el feed
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

  // ================================
  // ELIMINAR COMENTARIO (NUEVO)
  // ================================
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
        // Remover de la lista
        comentarios.removeWhere((c) => c['id'] == idComentario);
        
        // Actualizar contador
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

  // ================================
  // CREAR PUBLICACIÓN (Sin imágenes)
  // ================================
  Future<bool> crearPublicacion(String descripcion, String token) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/publicaciones"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: jsonEncode({"descripcion": descripcion}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Publicación creada");
        return true;
      }
      return false;
    } catch (e) {
      print("❌ Error crear publicación: $e");
      return false;
    }
  }

  // ================================
  // ACTUALIZAR PUBLICACIÓN
  // ================================
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
        // Actualizar en el feed local
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

  // ================================
  // OBTENER UNA PUBLICACIÓN POR ID
  // ================================
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

  // ================================
  // CREAR PUBLICACIÓN CON IMÁGENES
  // ================================
  Future<bool> crearPublicacionConImagenes(
    String descripcion,
    List<File> imagenes,
    String token,
  ) async {
    final url = Uri.parse("$baseUrl/publicaciones");

    final request = http.MultipartRequest("POST", url);
    request.headers["Authorization"] = "Bearer $token";
    request.headers["Accept"] = "application/json";

    request.fields["descripcion"] = descripcion;

    // ✅ Validar que las imágenes existan
    for (var i = 0; i < imagenes.length; i++) {
      if (!imagenes[i].existsSync()) {
        print("❌ Imagen no existe: ${imagenes[i].path}");
        continue;
      }

      try {
        final img = await http.MultipartFile.fromPath(
          "imagenes[]",
          imagenes[i].path,
        );
        request.files.add(img);
        print("✅ Imagen $i agregada");
      } catch (e) {
        print("❌ Error al agregar imagen $i: $e");
      }
    }

    try {
      final response = await request.send();
      final body = await response.stream.bytesToString();
      
      print("📤 Respuesta servidor: $body");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Publicación con imágenes creada");
        return true;
      }
      print("❌ Error: ${response.statusCode}");
      return false;
    } catch (e) {
      print("❌ Error al subir publicación: $e");
      return false;
    }
  }

  // ================================
  // ACTUALIZAR PUBLICACIÓN CON IMÁGENES
  // ================================
  Future<bool> actualizarPublicacionConImagenes(
    int idPublicacion,
    String descripcion,
    List<File> imagenes,
    String token,
  ) async {
    // ⚠️ NOTA: Laravel no soporta PUT con multipart/form-data nativamente
    // Usamos POST con _method=PUT
    final url = Uri.parse("$baseUrl/publicaciones/$idPublicacion");

    final request = http.MultipartRequest("POST", url);
    request.headers["Authorization"] = "Bearer $token";
    request.headers["Accept"] = "application/json";

    // ✅ Simular PUT en Laravel
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

  // ================================
  // LIMPIAR COMENTARIOS
  // ================================
  void limpiarComentarios() {
    comentarios = [];
    notifyListeners();
  }
}