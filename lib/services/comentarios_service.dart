import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/comentario_model.dart';
import 'api_service.dart';

class ComentariosService {
  static Future<List<Map<String, dynamic>>> getComentarios(int publicacionId) async {
    final url = Uri.parse("${ApiService.baseUrl}/publicaciones/$publicacionId/comentarios");

    final response = await http.get(url, headers: ApiService.headers());

    if (response.statusCode != 200) {
      throw Exception("Error al obtener comentarios");
    }

    final data = jsonDecode(response.body);

    // Asegúrate de que 'data' sea una lista de mapas, no una lista de objetos
    return List<Map<String, dynamic>>.from(data);
  }

  static Future<void> agregarComentario(int publicacionId, String contenido) async {
    final url = Uri.parse("${ApiService.baseUrl}/publicaciones/$publicacionId/comentarios");

    final response = await http.post(url,
        headers: ApiService.headers(),
        body: jsonEncode({
          'contenido': contenido,
        }));

    if (response.statusCode != 201) {
      throw Exception("Error al agregar comentario");
    }
  }
}
