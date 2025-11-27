import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // URL base: apunta al backend Laravel (Docker puerto 18000)
  //static const String baseUrl = 'http://172.172.4.254:18000/api'; //IP EMI 172.174.2.19:18000
  static const String baseUrl = 'http://192.168.0.5:18000/api'; // IP CASA

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
      print('📡 Enviando solicitud de registro...');

      final response = await http
          .post(
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
              'name': name, // nombre corto tipo “kiap”
              'email': email,
              'password': password,
              'password_confirmation': confirmarPassword,
            }),
          )
          .timeout(const Duration(seconds: 15));

      print('📦 Registro -> Código: ${response.statusCode}');
      print('📦 Registro -> Respuesta: ${response.body}');

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
      print('❌ Error de conexión en registro: $e');
      return {
        'success': false,
        'message': 'Error al conectar con el servidor',
        'error': e.toString(),
      };
    }
  }
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('🔑 Iniciando sesión...');

      final response = await http
          .post(
            Uri.parse('$baseUrl/login'),
            headers: {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode({
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 15));

      print('📦 Login -> Código: ${response.statusCode}');
      print('📦 Login -> Respuesta: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['usuario'] != null) {
        final usuario = data['usuario'];
        final persona = usuario['persona'];

        // 🧠 Si no hay 'name', lo generamos de forma segura
        String nombreFinal = usuario['name'] ??
            '${persona?['nombres']?.split(" ").first ?? ''}${persona?['apellido_paterno']?[0] ?? ''}'
                .toLowerCase();

        return {
          'success': true,
          'message': data['message'] ?? 'Inicio de sesión exitoso',
          'usuario': usuario,
          'nombreUsuario': nombreFinal, 
          'token': data['token'] ?? '',// 👈 lo devolvemos al frontend
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Credenciales incorrectas',
          'errors': data['errors'],
        };
      }
    } catch (e) {
      print('❌ Error de conexión en login: $e');
      return {
        'success': false,
        'message': 'Error al conectar con el servidor',
        'error': e.toString(),
      };
    }
  }
  static Future<Map<String, dynamic>> verificarUsuarioGoogle(String email) async {
    try {
      print('🔍 Verificando usuario Google con email: $email');

      final response = await http.post(
        Uri.parse('$baseUrl/verificar_usuario_google.php'),
        body: {'email': email},
      );

      print('📦 Verificar Google -> Código: ${response.statusCode}');
      print('📦 Verificar Google -> Respuesta: ${response.body}');

      return jsonDecode(response.body);
    } catch (e) {
      print('❌ Error al verificar usuario Google: $e');
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
      print('🆕 Registrando usuario Google: $email');

      final response = await http.post(
        Uri.parse('$baseUrl/registrar_usuario_google.php'),
        body: {
          'nombres': nombres,
          'apellido_paterno': apellidoPaterno,
          'email': email,
          'foto': foto ?? '',
        },
      );

      print('📦 Registro Google -> Código: ${response.statusCode}');
      print('📦 Registro Google -> Respuesta: ${response.body}');

      return jsonDecode(response.body);
    } catch (e) {
      print('❌ Error al registrar usuario Google: $e');
      return {
        'success': false,
        'message': 'Error al registrar usuario Google',
        'error': e.toString(),
      };
    }
  }
}
