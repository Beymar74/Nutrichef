import 'dart:convert';
import 'package:http/http.dart' as http;

class PasswordService {
  static const String baseUrl = 'http://10.0.2.2:18000/api';
  //static const String baseUrl = 'http://192.168.0.16:18000/api';


  static Future<Map<String, dynamic>> enviarCodigo(String email) async {
    try {
      print("📨 Enviando código a: $email");

      final response = await http
          .post(
            Uri.parse('$baseUrl/recuperar-password/enviar-codigo'),
            headers: {
              'Accept': 'application/json',
            },
            body: {
              'email': email,
            },
          )
          .timeout(const Duration(seconds: 15));

      print("📦 Respuesta enviar código: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': data['message'] ?? 'Código enviado',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Error inesperado',
        };
      }
    } catch (e) {
      print("❌ Error al enviar código: $e");
      return {
        'success': false,
        'message': 'Error al conectar con el servidor',
      };
    }
  }
static Future<Map<String, dynamic>> cambiarPassword(String email, String password) async {
  try {
    final response = await http.post(
      Uri.parse('$baseUrl/recuperar-password/cambiar'),
      headers: { 'Accept': 'application/json' },
      body: {
        'email': email,
        'password': password,
      },
    );

    final data = jsonDecode(response.body);

    return {
      'success': data['success'] ?? false,
      'message': data['message'] ?? 'Error desconocido',
    };
  } catch (e) {
    return {
      'success': false,
      'message': 'Error de conexión',
    };
  }
}

  static Future<Map<String, dynamic>> verificarCodigo(
      String email, String codigo) async {
    try {
      print("Verificando código $codigo para $email");

      final response = await http
          .post(
            Uri.parse('$baseUrl/recuperar-password/verificar-codigo'),
            headers: {
              'Accept': 'application/json',
            },
            body: {
              'email': email,
              'codigo': codigo,
            },
          )
          .timeout(const Duration(seconds: 15));

      print("Respuesta verificar código: ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        return {
          'success': true,
          'message': data['message'] ?? 'Código verificado',
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Código incorrecto',
        };
      }
    } catch (e) {
      print("Error al verificar código: $e");
      return {
        'success': false,
        'message': 'Error al conectar con el servidor',
      };
    }
  }
}
