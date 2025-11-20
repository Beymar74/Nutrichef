import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/publicacion_model.dart';
import 'api_service.dart';

class PublicacionesService {
  // Método para obtener las publicaciones
  static Future<List<Publicacion>> getPublicaciones() async {
    final url = Uri.parse("${ApiService.baseUrl}/publicaciones");

    // Asegúrate de que el token esté en las cabeceras
    final response = await http.get(url, headers: ApiService.headers());

    // Depurar la respuesta (esto puede ayudarte a ver si el servidor está respondiendo)
    print("Respuesta de la API: ${response.body}");

    // Si el servidor responde con un error, lanzamos una excepción
    if (response.statusCode != 200) {
      throw Exception("Error al obtener publicaciones");
    }

    // Si todo está bien, decodificamos el JSON y retornamos las publicaciones
    final data = jsonDecode(response.body);
    return (data as List).map((p) => Publicacion.fromJson(p)).toList();
  }

  // Método para obtener una publicación por ID
  static Future<Publicacion> getPublicacionById(int id) async {
    final url = Uri.parse("${ApiService.baseUrl}/publicaciones/$id");

    final response = await http.get(url, headers: ApiService.headers());

    if (response.statusCode != 200) {
      throw Exception("No se pudo obtener la publicación");
    }

    return Publicacion.fromJson(jsonDecode(response.body));
  }

  // Método para crear una nueva publicación
  static Future<void> crearPublicacion(String titulo, String contenido, String resumen) async {
    final url = Uri.parse("${ApiService.baseUrl}/publicaciones");

    final response = await http.post(
      url,
      headers: ApiService.headers(),
      body: jsonEncode({
        'titulo': titulo,
        'contenido': contenido,
        'resumen': resumen,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception("Error al crear publicación");
    }

    // Si la publicación se creó correctamente, no retornamos nada.
    // Puedes agregar lógica adicional si necesitas manejar la respuesta.
  }

  // Método para editar una publicación existente
  static Future<void> editarPublicacion(int id, String titulo, String contenido, String resumen) async {
    final url = Uri.parse("${ApiService.baseUrl}/publicaciones/$id");

    final response = await http.put(
      url,
      headers: ApiService.headers(),
      body: jsonEncode({
        'titulo': titulo,
        'contenido': contenido,
        'resumen': resumen,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception("Error al editar publicación");
    }
  }

  // Método para eliminar una publicación
  static Future<void> eliminarPublicacion(int id) async {
    final url = Uri.parse("${ApiService.baseUrl}/publicaciones/$id");

    final response = await http.delete(
      url,
      headers: ApiService.headers(),
    );

    if (response.statusCode != 200) {
      throw Exception("Error al eliminar publicación");
    }
  }
}
