import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/receta_model.dart';

class RecetaService {
  static const String baseUrl = "http://192.168.0.8:18000/api";
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

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        
        if (jsonResponse.containsKey('data')) {
          final List<dynamic> data = jsonResponse['data'];
          return data.map((json) => Receta.fromJson(json)).toList();
        } else {
          final List<dynamic> data = json.decode(response.body);
          return data.map((json) => Receta.fromJson(json)).toList();
        }
      } else {
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Error al obtener recetas: $e');
      rethrow;
    }
  }

  Future<Receta?> obtenerRecetaPorId(int id) async {
    try {
      print('Obteniendo receta ID: $id');
      
      final response = await http.get(
        Uri.parse('$baseUrl/recetas/$id'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

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
      print('Error al obtener receta: $e');
      return null;
    }
  }

  Future<List<Receta>> obtenerRecetasPorDieta(String dieta) async {
    try {
      print('Obteniendo recetas de dieta: $dieta');
      
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
      print('Error al obtener recetas por dieta: $e');
      return [];
    }
  }
}
