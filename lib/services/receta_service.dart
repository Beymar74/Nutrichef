import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/receta_model.dart';

class RecetaService {
  // Para dispositivo físico usa la IP de tu PC:
  //static const String baseUrl = "http://172.172.4.254:18000/api"; //IP EMI 
  static const String baseUrl = 'http:// 192.168.0.12:18000/api'; // IP CASA
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
      print('📦 Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        // Ajusta según la estructura de tu API
        if (jsonResponse.containsKey('data')) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => Receta.fromJson(json)).toList();
        } else {
          // Si tu API devuelve directamente un array
          final List<dynamic> data = json.decode(response.body);
          return data.map((json) => Receta.fromJson(json)).toList();
        }
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
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        if (jsonResponse.containsKey('data')) {
          return Receta.fromJson(jsonResponse['data']);
        } else {
          return Receta.fromJson(jsonResponse);
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

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        if (jsonResponse.containsKey('data')) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => Receta.fromJson(json)).toList();
        } else {
          final List<dynamic> data = json.decode(response.body);
          return data.map((json) => Receta.fromJson(json)).toList();
        }
      }
      return [];
    } catch (e) {
      print('❌ Error al obtener recetas por dieta: $e');
      return [];
    }
  }
}
