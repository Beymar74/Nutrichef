import 'dart:convert';
import 'package:http/http.dart' as http;

class SolicitudChefService {
  // ✅ PUERTO CORRECTO: 18000 (Docker)
  static const String baseUrl = "http://10.0.2.2:18000/api"; // Para emulador Android
  // static const String baseUrl = "http://192.168.0.16:18000/api"; // Para dispositivo físico

  /// Enviar solicitud para ser chef
  static Future<Map<String, dynamic>> enviarSolicitud({
    required String token,
    required String motivo,
    String? experiencia,
  }) async {
    try {
      print('📡 Enviando solicitud de chef...');
      
      final url = Uri.parse("$baseUrl/solicitudes-chef");
      
      final response = await http
          .post(
            url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            },
            body: jsonEncode({
              "motivo": motivo,
              "experiencia": experiencia ?? "",
            }),
          )
          .timeout(const Duration(seconds: 15));

      print('📦 Solicitud Chef -> Código: ${response.statusCode}');
      print('📦 Solicitud Chef -> Respuesta: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data;
      } else if (response.statusCode == 400) {
        // Usuario ya tiene solicitud pendiente
        final data = jsonDecode(response.body);
        return {
          "success": false,
          "message": data["message"] ?? "Ya tienes una solicitud pendiente",
        };
      } else if (response.statusCode == 401) {
        return {
          "success": false,
          "message": "Tu sesión ha expirado. Inicia sesión nuevamente.",
        };
      } else if (response.statusCode == 422) {
        // Error de validación
        final data = jsonDecode(response.body);
        final errors = data["errors"] as Map<String, dynamic>?;
        
        String errorMsg = "Error de validación:";
        if (errors != null) {
          errors.forEach((key, value) {
            errorMsg += "\n• ${(value as List).join(', ')}";
          });
        }
        
        return {
          "success": false,
          "message": errorMsg,
        };
      } else {
        return {
          "success": false,
          "message": "Error del servidor (${response.statusCode})",
        };
      }
    } catch (e) {
      print('❌ Error de conexión en solicitud chef: $e');
      return {
        "success": false,
        "message": "Error al conectar con el servidor: $e",
      };
    }
  }

  /// Ver mis solicitudes enviadas
  static Future<Map<String, dynamic>> misSolicitudes({
    required String token,
  }) async {
    try {
      print('📡 Obteniendo mis solicitudes chef...');
      
      final url = Uri.parse("$baseUrl/mis-solicitudes-chef");
      
      final response = await http
          .get(
            url,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
              "Authorization": "Bearer $token",
            },
          )
          .timeout(const Duration(seconds: 15));

      print('📦 Mis Solicitudes -> Código: ${response.statusCode}');
      print('📦 Mis Solicitudes -> Respuesta: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode == 401) {
        return {
          "success": false,
          "message": "Tu sesión ha expirado",
        };
      } else {
        return {
          "success": false,
          "message": "Error al obtener solicitudes (${response.statusCode})",
        };
      }
    } catch (e) {
      print('❌ Error de conexión: $e');
      return {
        "success": false,
        "message": "Error de conexión: $e",
      };
    }
  }
}