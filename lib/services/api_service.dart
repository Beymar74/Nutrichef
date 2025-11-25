import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://10.0.2.2:18000/api';
  //static const String baseUrl = 'http://172.172.8.71:18000/api';

  // =====================================================
  // 🔥 GOOGLE LOGIN → BACKEND LARAVEL
  // =====================================================
  static Future<Map<String, dynamic>> loginGoogle(String idToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/google/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_token': idToken}),
      );

      return jsonDecode(response.body);

    } catch (e) {
      print('❌ Error conexión Google: $e');
      return {
        'success': false,
        'message': 'Error al conectar con Google Login',
        'error': e.toString(),
      };
    }
  }

  // =====================================================
  // 🔥 LOGIN NORMAL
  // =====================================================
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['usuario'] != null) {
        final usuario = data['usuario'];
        final persona = usuario['persona'];

        String nombreFinal = usuario['name'] ??
            '${persona?['nombres']?.split(" ").first ?? ''}${persona?['apellido_paterno']?[0] ?? ''}'
                .toLowerCase();

        return {
          'success': true,
          'message': data['message'],
          'usuario': usuario,
          'nombreUsuario': nombreFinal,
          'token': data['token'] ?? '',
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Credenciales incorrectas',
      };

    } catch (e) {
      print('❌ Error en login: $e');
      return {
        'success': false,
        'message': 'Error al conectar con el servidor',
        'error': e.toString(),
      };
    }
  }

  // =====================================================
  // 🔥 REGISTRO NORMAL
  // =====================================================
  static Future<Map<String, dynamic>> register({
    required String nombres,
    required String apellidoPaterno,
    required String apellidoMaterno,
    required String email,
    required String celular,
    required String fechaNacimiento,
    required String password,
    required String confirmarPassword,
    required String name,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'nombres': nombres,
          'apellido_paterno': apellidoPaterno,
          'apellido_materno': apellidoMaterno,
          'telefono': celular,
          'fecha_nacimiento': fechaNacimiento,
          'name': name,
          'email': email,
          'password': password,
          'password_confirmation': confirmarPassword,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'],
          'usuario': data['usuario'],
        };
      }

      return {
        'success': false,
        'message': data['message'] ?? 'Error al registrar usuario',
        'errors': data['errors'],
      };

    } catch (e) {
      print('❌ Error registro: $e');
      return {
        'success': false,
        'message': 'Error al conectar con el servidor',
        'error': e.toString(),
      };
    }
  }
}
