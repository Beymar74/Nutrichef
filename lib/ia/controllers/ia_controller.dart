import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class IaController {
  // ⚠️ TU IP CONFIGURADA PARA CELULAR FÍSICO
  static const String _baseUrl = 'http://172.172.4.21:18000/api';

  /// 1. Subir foto y obtener ingredientes detectados (con traducción)
  Future<List<dynamic>> identificarIngredientes(File imagen) async {
    final uri = Uri.parse('$_baseUrl/identificar-ingredientes');
    
    var request = http.MultipartRequest('POST', uri);
    
    // Adjuntamos la imagen
    request.files.add(await http.MultipartFile.fromPath(
      'imagen', 
      imagen.path,
    ));

    try {
      print("📡 Enviando imagen a: $uri");
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          // La API devuelve la lista bajo la clave 'ingredientes'
          return jsonResponse['ingredientes']; 
        } else {
          throw Exception(jsonResponse['error'] ?? 'Error en la respuesta de la IA');
        }
      } else {
        print("❌ Error Servidor: ${response.body}");
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      print("❌ Error Conexión: $e");
      throw Exception('No se pudo conectar con el servidor. Verifica tu IP.');
    }
  }

  /// 2. Buscar recetas basadas en una lista de nombres
  Future<List<dynamic>> buscarRecetas(List<String> ingredientes) async {
    final uri = Uri.parse('$_baseUrl/buscar-recetas');
    
    try {
      print("📡 Buscando recetas para: $ingredientes");
      final response = await http.post(
        uri,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          "ingredientes": ingredientes
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse['success'] == true) {
          // La API devuelve la lista bajo la clave 'recetas'
          return jsonResponse['recetas'];
        } else {
          throw Exception(jsonResponse['mensaje'] ?? 'Error al buscar recetas');
        }
      } else {
        throw Exception('Error del servidor: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error de conexión: $e');
    }
  }

  /// 3. Listar todos los ingredientes (Para el buscador manual)
  Future<List<dynamic>> listarCatalogoIngredientes() async {
    final uri = Uri.parse('$_baseUrl/ingredientes/listar');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['data']; // Retorna [{id:1, descripcion: "Ajo"}, ...]
      } else {
        throw Exception('Error al cargar catálogo');
      }
    } catch (e) {
      print(e);
      return [];
    }
  }

  /// 4. Listar unidades de medida (Para los dropdowns)
  Future<List<dynamic>> listarUnidades() async {
    final uri = Uri.parse('$_baseUrl/unidades/listar');
    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        return jsonResponse['data'];
      } else {
        throw Exception('Error al cargar unidades');
      }
    } catch (e) {
      print(e);
      return [];
    }
  }
}