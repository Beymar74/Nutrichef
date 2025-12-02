import 'dart:convert';
import 'package:http/http.dart' as http;

class LogoutService {
  static const String baseUrl = "http://10.0.2.2:18000/api";

  static Future<Map<String, dynamic>> cerrarSesion(String token) async {
    try {
      final url = Uri.parse("$baseUrl/logout");

      final res = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Accept": "application/json",
          "Content-Type": "application/json"
        },
      );

      print("🔴 LOGOUT → CODE ${res.statusCode}");
      print("📄 RESPONSE → ${res.body}");

      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return {"success": true, "message": data["message"] ?? "Sesión cerrada"};
      }

      return {"success": false, "message": "Error al cerrar sesión"};
      
    } catch (e) {
      print("❌ ERROR LOGOUT: $e");
      return {"success": false, "message": "Error de conexión"};
    }
  }
}