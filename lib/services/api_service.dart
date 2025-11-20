import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // URL base del backend Laravel
  // URL base: apunta al backend Laravel (Docker puerto 18000)
  //static const String baseUrl = 'http://10.0.2.2:18000/api';

  static const String baseUrl = 'http://192.168.0.5:18000/api';  // Cambia por tu IP


  // TOKEN global después del login
  static String? token;

  // ÉTODO UNIVERSAL DE HEADERS (soluciona tu error)
  static Map<String, String> headers() {
    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  // ---------------------------------------------------------
  // REGISTRO
  // ---------------------------------------------------------
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
      final response = await http
          .post(
            Uri.parse('$baseUrl/register'),
            headers: headers(),
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
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return {
          'success': true,
          'message': data['message'] ?? 'Usuario registrado correctamente',
          'usuario': data['usuario'],
          'persona': data['persona'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Error al registrar usuario',
          'errors': data['errors'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al conectar con el servidor',
        'error': e.toString(),
      };
    }
  }

  // ---------------------------------------------------------
  // LOGIN
  // ---------------------------------------------------------
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: headers(),
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 15));

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['usuario'] != null) {
        // Guardar token para futuros requests 🔐
        token = data['token'];

        final usuario = data['usuario'];
        final persona = usuario['persona'];

        String nombreFinal = usuario['name'] ??
            '${persona?['nombres']?.split(" ").first ?? ''}${persona?['apellido_paterno']?[0] ?? ''}'
                .toLowerCase();

        return {
          'success': true,
          'message': data['message'] ?? 'Inicio de sesión exitoso',
          'usuario': usuario,
          'nombreUsuario': nombreFinal,
          'token': data['token'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Credenciales incorrectas',
          'errors': data['errors'],
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al conectar con el servidor',
        'error': e.toString(),
      };
    }
  }

  // ---------------------------------------------------------
  // TUS MÉTODOS GOOGLE — NO TOCADOS
  // ---------------------------------------------------------

  static Future<Map<String, dynamic>> verificarUsuarioGoogle(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/verificar_usuario_google.php'),
        body: {'email': email},
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al verificar usuario Google',
        'error': e.toString(),
      };
    }
  }

  static Future<Map<String, dynamic>> registrarUsuarioGoogle({
    required String nombres,
    required String apellidoPaterno,
    required String email,
    String? foto,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/registrar_usuario_google.php'),
        body: {
          'nombres': nombres,
          'apellido_paterno': apellidoPaterno,
          'email': email,
          'foto': foto ?? '',
        },
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        'success': false,
        'message': 'Error al registrar usuario Google',
        'error': e.toString(),
      };
    }
  }
}
