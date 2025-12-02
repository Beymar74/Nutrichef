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
        posts = (body["data"] as List).map((json) {
          return Publicacion.fromJson(json);
        }).toList();
      }
    } catch (e) {
      print("❌ Error cargando feed: $e");
    }

    loading = false;
    notifyListeners();
  }

  // ================================
  // LIKE TOGGLE
  // ================================
  Future<void> likeToggle(int idPublicacion, String token) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/publicaciones/$idPublicacion/reaccion"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json"
        },
      );

      if (response.statusCode == 200) {
        final idx = posts.indexWhere((p) => p['id'] == idPublicacion);
        if (idx != -1) {
          bool yaDioLike = posts[idx]['ya_dio_like'] ?? false;
          posts[idx]['ya_dio_like'] = !yaDioLike;
          posts[idx]['likes_count'] =
              (posts[idx]['likes_count'] ?? 0) + (yaDioLike ? -1 : 1);
        }
      }
    } catch (e) {
      print("❌ Error en toggle like: $e");
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
  Future<void> eliminarPublicacion(int idPublicacion, String token) async {
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
      }
    } catch (e) {
      print("❌ Error eliminar publicación: $e");
    }

    notifyListeners();
  }

  // ================================
  // REPORTAR PUBLICACIÓN
  // ================================
  Future<void> reportarPublicacion(int idPublicacion, String token) async {
    try {
      await http.post(
        Uri.parse("$baseUrl/publicaciones/reportar/$idPublicacion"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json"
        },
      );
    } catch (e) {
      print("❌ Error al reportar: $e");
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
      }
    } catch (e) {
      print("❌ Error obtener comentarios: $e");
    }

    notifyListeners();
  }

  // ================================
  // AGREGAR COMENTARIO
  // ================================
  Future<void> agregarComentario(
      int idPublicacion, String contenido, String token) async {
    try {
      await http.post(
        Uri.parse("$baseUrl/publicaciones/$idPublicacion/comentarios"),
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
        body: jsonEncode({"contenido": contenido}),
      );

      await obtenerComentarios(idPublicacion, token);

      final idx = posts.indexWhere((p) => p['id'] == idPublicacion);
      if (idx != -1) {
        posts[idx]['comentarios_count'] =
            (posts[idx]['comentarios_count'] ?? 0) + 1;
      }
    } catch (e) {
      print("❌ Error agregar comentario: $e");
    }

    notifyListeners();
  }

  // ================================
  // CREAR PUBLICACIÓN (Sin imágenes aún)
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

      return response.statusCode == 200 || response.statusCode == 201;
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

      return response.statusCode == 200;
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

    for (var i = 0; i < imagenes.length; i++) {
      final img = await http.MultipartFile.fromPath(
        "imagenes[]",
        imagenes[i].path,
      );
      request.files.add(img);
    }

    try {
      final response = await request.send();
      final body = await response.stream.bytesToString();

      return response.statusCode == 200 || response.statusCode == 201;
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
    final url = Uri.parse("$baseUrl/publicaciones/$idPublicacion");

    final request = http.MultipartRequest("PUT", url);
    request.headers["Authorization"] = "Bearer $token";
    request.headers["Accept"] = "application/json";

    request.fields["descripcion"] = descripcion;

    for (var i = 0; i < imagenes.length; i++) {
      final img = await http.MultipartFile.fromPath(
        "imagenes[]",
        imagenes[i].path,
      );
      request.files.add(img);
    }

    try {
      final response = await request.send();
      final body = await response.stream.bytesToString();

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("❌ Error al actualizar publicación: $e");
      return false;
    }
  }
}
