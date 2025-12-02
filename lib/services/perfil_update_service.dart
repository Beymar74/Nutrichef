import 'dart:convert';
import 'package:http/http.dart' as http;

class PerfilUpdateService {
  static const String baseUrl = "http://10.0.2.2:18000/api";

  static Future<Map<String, dynamic>> actualizarPerfilCompleto({
    required String token,
    required String name,
    required String descripcion,
    required String nombres,
    required String apellidoPaterno,
    String? apellidoMaterno,
    String? telefono,
    required String altura,
    required String peso,
    String? fechaNacimiento,
    String? imagen, // Base64
  }) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/usuario/perfil"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "name": name,
          "descripcion_perfil": descripcion,
          "nombres": nombres,
          "apellido_paterno": apellidoPaterno,
          "apellido_materno": apellidoMaterno,
          "telefono": telefono,
          "altura": altura,
          "peso": peso,
          "fecha_nacimiento": fechaNacimiento,
          "imagen": imagen,
        }),
      );

      return jsonDecode(res.body);
    } catch (e) {
      return {"success": false, "message": "Error conexión 🔴", "error": e.toString()};
    }
  }
}
