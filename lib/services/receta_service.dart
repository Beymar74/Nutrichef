import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/receta_model.dart';

class RecetaService {
  // Para dispositivo físico usa la IP de tu PC:
  static const String baseUrl = 'http://192.168.0.16:18000/api';
  //static const String baseUrl = "laip";
  
  Future<List<Receta>> obtenerRecetas() async {
    try {
      print('🔍 Intentando obtener recetas desde: $baseUrl/recetas');
      
      final response = await http.get(
        Uri.parse('$baseUrl/recetas'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () {
          throw Exception('Tiempo de espera agotado. Verifica tu conexión.');
        },
      );

      print('📡 Status Code: ${response.statusCode}');
      
      // ✅ PRINT PARA VER EL JSON COMPLETO (solo las primeras 500 caracteres)
      print('📦 Response Body (primeros 500 chars):');
      print(response.body.substring(0, response.body.length > 500 ? 500 : response.body.length));

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        
        // ✅ PRINT PARA VER LA PRIMERA RECETA COMPLETA
        if (jsonList.isNotEmpty) {
          print('🖼️ Primera receta del JSON:');
          print(jsonList[0]);
          print('');
          print('🖼️ imagen_url de la primera receta: ${jsonList[0]['imagen_url']}');
        }
        
        return jsonList.map((json) => Receta.fromJson(json)).toList();
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ Error al obtener recetas: $e');
      rethrow;
    }
  }

  // Obtener receta por ID
  Future<Receta?> obtenerRecetaPorId(int id) async {
    try {
      print('🔍 Obteniendo receta ID: $id');
      
      final response = await http.get(
        Uri.parse('$baseUrl/recetas/$id'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('📡 Status Code: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);
        
        // Si es un Map, podría tener 'data' o ser directo
        if (jsonResponse is Map<String, dynamic>) {
          if (jsonResponse.containsKey('data')) {
            return Receta.fromJson(jsonResponse['data']);
          } else {
            return Receta.fromJson(jsonResponse);
          }
        }
      }
      return null;
    } catch (e) {
      print('❌ Error al obtener receta: $e');
      return null;
    }
  }

  // Obtener recetas por categoría/dieta
  Future<List<Receta>> obtenerRecetasPorDieta(String dieta) async {
    try {
      print('🔍 Obteniendo recetas de dieta: $dieta');
      
      final response = await http.get(
        Uri.parse('$baseUrl/recetas?dieta=$dieta'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('📡 Status Code: ${response.statusCode}');
      print('📦 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => Receta.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('❌ Error al obtener recetas por dieta: $e');
      return [];
    }
  }
}