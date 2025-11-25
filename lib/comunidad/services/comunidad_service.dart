import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ComunidadService extends ChangeNotifier {
  bool loading = false; // Indica si estamos cargando las publicaciones
  List<dynamic> posts = []; // Lista donde almacenaremos las publicaciones
  List<dynamic> comentarios = []; // Lista para almacenar los comentarios

  // Método para cargar las publicaciones desde la API
  Future<void> cargarFeed(String token) async {
    loading = true;
    notifyListeners();

    print('🔍 === INICIANDO CARGA DE FEED ===');
    print('🔑 Token recibido: $token');
    print('📡 URL: http://192.168.0.5:18000/api/publicaciones');

    try {
      final response = await http
          .get(
            Uri.parse('http://192.168.0.5:18000/api/publicaciones'),
            headers: {
              'Authorization': 'Bearer $token',
              'Accept': 'application/json',
            },
          )
          .timeout(Duration(seconds: 10));

      print('📊 Status Code: ${response.statusCode}');
      print('📄 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        posts = data['data'] ?? [];
        print('✅ Posts cargados: ${posts.length}');
      } else {
        print('❌ Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ EXCEPCIÓN: $e');
    }

    loading = false;
    notifyListeners();
    print('🏁 === FIN CARGA ===');
  }

  // Función para obtener los comentarios de una publicación
  Future<void> obtenerComentarios(int idPublicacion, String token) async {
    final url = Uri.parse(
      'http://192.168.0.5:18000/api/publicaciones/$idPublicacion/comentarios',
    ); // Ajusta la URL si es necesario
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Autenticación con token
          'Accept': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        comentarios = data['data']; // Guardamos los comentarios en la lista
      } else {
        throw Exception('Error al cargar los comentarios');
      }
    } catch (e) {
      print('Error al obtener los comentarios: $e');
    }
    notifyListeners(); // Notificamos que los comentarios se han cargado
  }

  // Método para dar reacción (like) a una publicación
  Future<Map<String, dynamic>> darReaccion(
    int idPublicacion,
    String token,
  ) async {
    final url = Uri.parse(
      'http://192.168.0.5:18000/api/publicaciones/$idPublicacion/reaccion',
    ); // Asegúrate de que este sea el endpoint correcto en tu API
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Autenticación con token
          'Accept': 'application/json',
          'Content-Type':
              'application/json', // Especificamos que estamos enviando JSON
        },
        body: json.encode({
          'reaccion': 'like', // O el tipo de reacción que estés manejando
        }),
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Reacción agregada'};
      } else {
        return {'success': false, 'message': 'Error al agregar reacción'};
      }
    } catch (e) {
      print('Error al agregar reacción: $e');
      return {'success': false, 'message': 'Error en la conexión'};
    }
  }

  // Función para eliminar una publicación
  Future<Map<String, dynamic>> eliminarPublicacion(
    int idPublicacion,
    String token,
  ) async {
    final url = Uri.parse(
      'http://192.168.0.5:18000/api/publicaciones/$idPublicacion',
    ); // URL para eliminar publicación

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Autenticación
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Publicación eliminada correctamente',
        };
      } else {
        return {'success': false, 'message': 'Error al eliminar publicación'};
      }
    } catch (e) {
      print('Error al eliminar la publicación: $e');
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  // Función para reportar publicación
  Future<Map<String, dynamic>> reportarPublicacion(
    int idPublicacion,
    String token,
  ) async {
    final url = Uri.parse(
      'http://192.168.0.5:18000/api/publicaciones/reportar/$idPublicacion',
    ); // Ajusta la URL si es necesario

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Autenticación con token
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {
          'success': true,
          'message': data['message'] ?? 'Publicación reportada con éxito',
        };
      } else {
        return {
          'success': false,
          'message': 'Error al reportar la publicación',
        };
      }
    } catch (e) {
      print('Error al reportar la publicación: $e');
      return {'success': false, 'message': 'Error al conectar con el servidor'};
    }
  }

  // Función para crear publicación
  Future<Map<String, dynamic>> crearPublicacion(
    String titulo,
    String contenido,
    String token,
  ) async {
    final url = Uri.parse('http://192.168.0.5:18000/api/publicaciones');
    try {
      final response = await http.post(
        url,
        body: json.encode({'titulo': titulo, 'contenido': contenido}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Enviar el token de autenticación
        },
      );

      if (response.statusCode == 200) {
        return {'success': true, 'message': 'Publicación creada correctamente'};
      } else {
        return {'success': false, 'message': 'Error al crear publicación'};
      }
    } catch (e) {
      print('Error al crear la publicación: $e');
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  // Función para actualizar una publicación existente
  Future<Map<String, dynamic>> actualizarPublicacion(
    int idPublicacion,
    String titulo,
    String contenido,
    String token,
  ) async {
    final url = Uri.parse(
      'http://192.168.0.5:18000/api/publicaciones/$idPublicacion',
    ); // URL de actualización de la publicación

    try {
      final response = await http.put(
        url,
        body: json.encode({'titulo': titulo, 'contenido': contenido}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Autenticación
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Publicación actualizada correctamente',
        };
      } else {
        return {'success': false, 'message': 'Error al actualizar publicación'};
      }
    } catch (e) {
      print('Error al actualizar la publicación: $e');
      return {'success': false, 'message': 'Error de conexión'};
    }
  }

  // Método para obtener una publicación por su ID
  Future<void> obtenerPublicacionPorId(int id, String token) async {
    loading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.5:18000/api/publicaciones/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        posts = [data['data']]; // Asignamos solo una publicación
      } else {
        throw Exception('Error al obtener la publicación');
      }
    } catch (e) {
      print('Error al obtener la publicación: $e');
    }

    loading = false;
    notifyListeners();
  }

  // Función para agregar un comentario a una publicación
  Future<Map<String, dynamic>> agregarComentario(
    int idPublicacion,
    String contenido,
    String token,
  ) async {
    final url = Uri.parse(
      'http://192.168.0.5:18000/api/publicaciones/$idPublicacion/comentarios',
    );
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({'contenido': contenido}),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Recargar los comentarios después de agregar uno nuevo
        await obtenerComentarios(idPublicacion, token);
        return {
          'success': true,
          'message': 'Comentario agregado correctamente',
        };
      } else {
        return {'success': false, 'message': 'Error al agregar comentario'};
      }
    } catch (e) {
      print('Error al agregar comentario: $e');
      return {'success': false, 'message': 'Error de conexión'};
    }
  }
}
