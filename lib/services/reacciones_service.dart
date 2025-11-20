import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart';

class ReaccionesService {
  static Future<void> reaccionar(int publicacionId, String reaccion) async {
    final url = Uri.parse("${ApiService.baseUrl}/publicaciones/$publicacionId/reacciones");

    final response = await http.post(
      url,
      headers: ApiService.headers(),
      body: jsonEncode({'reaccion': reaccion}),
    );

    if (response.statusCode != 200) {
      throw Exception("Error al enviar reacción");
    }
  }
}
