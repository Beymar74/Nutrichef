import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/publicacion_model.dart';
import 'api_service.dart';

class PublicacionesService {
  static Future<List<Publicacion>> getPublicaciones() async {
    final url = Uri.parse("${ApiService.baseUrl}/publicaciones");

    final response = await http.get(url, headers: ApiService.headers());

    if (response.statusCode != 200) {
      throw Exception("Error al obtener publicaciones");
    }

    final data = jsonDecode(response.body);

    return (data as List)
        .map((p) => Publicacion.fromJson(p))
        .toList();
  }

  static Future<Publicacion> getPublicacionById(int id) async {
    final url = Uri.parse("${ApiService.baseUrl}/publicaciones/$id");

    final response = await http.get(url, headers: ApiService.headers());

    if (response.statusCode != 200) {
      throw Exception("No se pudo obtener la publicación");
    }

    return Publicacion.fromJson(jsonDecode(response.body));
  }
}
