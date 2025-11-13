import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Emulador Android:    'http://10.0.2.2:8000/api'
  // Emulador iOS:        'http://127.0.0.1:8000/api'
  
  static const String baseUrl = 'http://10.0.2.2:8080/api';


  static Future<Map<String, dynamic>> register({
    required String nombreCompleto,
    required String email,
    required String celular,
    required String fechaNacimiento,
    required String password,
  }) async {
    try {
      print('🔄 Intentando registrar usuario...');
      print('📍 URL: $baseUrl/register');
      
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'nombre_completo': nombreCompleto,
          'email': email,
          'celular': celular,
          'fecha_nacimiento': fechaNacimiento,
          'password': password,
        }),
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Tiempo de espera agotado. Verifica que Laravel esté corriendo.');
        },
      );

      print('📡 Status Code: ${response.statusCode}');
      print('📦 Response: ${response.body}');

      final data = jsonDecode(response.body);
      
      // Agregar el status code para manejar errores
      return {
        ...data,
        'status_code': response.statusCode,
      };
      
    } catch (e) {
      print('❌ Error en registro: $e');
      
      String errorMessage = 'Error de conexión';
      
      if (e.toString().contains('SocketException')) {
        errorMessage = 'No se puede conectar al servidor. Verifica:\n'
                      '1. Laravel está corriendo (php artisan serve)\n'
                      '2. La URL es correcta';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Tiempo de espera agotado';
      }
      
      return {
        'success': false,
        'message': errorMessage,
        'error': e.toString(),
      };
    }
  }

  /// Iniciar sesión
  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('🔄 Intentando iniciar sesión...');
      print('📍 URL: $baseUrl/login');
      
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
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Tiempo de espera agotado. Verifica que Laravel esté corriendo.');
        },
      );

      print('📡 Status Code: ${response.statusCode}');
      print('📦 Response: ${response.body}');

      final data = jsonDecode(response.body);
      
      return {
        ...data,
        'status_code': response.statusCode,
      };
      
    } catch (e) {
      print('❌ Error en login: $e');
      
      String errorMessage = 'Error de conexión';
      
      if (e.toString().contains('SocketException')) {
        errorMessage = 'No se puede conectar al servidor. Verifica:\n'
                      '1. Laravel está corriendo (php artisan serve)\n'
                      '2. La URL es correcta';
      } else if (e.toString().contains('TimeoutException')) {
        errorMessage = 'Tiempo de espera agotado';
      }
      
      return {
        'success': false,
        'message': errorMessage,
        'error': e.toString(),
      };
    }
  }
  //Comnidad / prueba
  static Future<List> obtenerRecetas(String filtro) async {
    // Aquí conectarías con tu backend Laravel
    // Ejemplo usando http
    // final response = await http.get(Uri.parse('$baseUrl/api/recetas?filtro=$filtro'));
    // return jsonDecode(response.body);
    
    // Simulación temporal
    return [
      {
        'autor': 'josh-ryan',
        'autor_imagen': 'https://randomuser.me/api/portraits/men/1.jpg',
        'fecha': '2 años',
        'imagen': 'https://example.com/pollo.jpg',
        'titulo': 'Pollo al Curry',
        'descripcion': 'Esta receta requiere ingredientes básicos...',
        'tiempo': 45,
        'vistas': 2458,
      },
      {
        'autor': 'dakota.mullen',
        'autor_imagen': 'https://randomuser.me/api/portraits/women/2.jpg',
        'fecha': '11 meses',
        'imagen': 'https://example.com/macarons.jpg',
        'titulo': 'Macarons',
        'descripcion': 'Esta receta te guiará a través del arte...',
        'tiempo': 38,
        'vistas': 2273,
      },
    ];
  }
  /// Probar conexión con el servidor
  static Future<Map<String, dynamic>> testConnection() async {
    try {
      print('🔄 Probando conexión con servidor...');
      print('📍 URL: $baseUrl/test');
      
      final response = await http.get(
        Uri.parse('$baseUrl/test'),
        headers: {
          'Accept': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 5),
        onTimeout: () {
          throw Exception('Timeout');
        },
      );

      print('📡 Status Code: ${response.statusCode}');
      print('📦 Response: ${response.body}');

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Conexión exitosa',
          'data': jsonDecode(response.body),
        };
      } else {
        return {
          'success': false,
          'message': 'Error del servidor: ${response.statusCode}',
        };
      }
      
    } catch (e) {
      print('❌ Error en conexión: $e');
      return {
        'success': false,
        'message': 'No se pudo conectar al servidor',
        'error': e.toString(),
      };
    }
  }
}