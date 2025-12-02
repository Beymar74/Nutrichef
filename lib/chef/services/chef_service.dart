import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/environment.dart';
import '../models/receta_model.dart';

class ChefService {
  
  // Obtener todas las recetas del chef logueado
  Future<List<Receta>> obtenerMisRecetas(int chefId) async {
    // Asumimos ruta en Laravel: GET /api/recetas?chef_id=X
    final url = Uri.parse('${Environment.apiUrl}/recetas?id_usuario_creador=$chefId');
    
    try {
      print("Solicitando recetas a: $url"); // Log para depurar
      final response = await http.get(url, headers: Environment.headers);

      print("Respuesta Code: ${response.statusCode}");
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Receta.fromJson(json)).toList();
      } else {
        print("Error Body: ${response.body}");
        throw Exception('Error al cargar recetas: ${response.statusCode}');
      }
    } catch (e) {
      print("Error Excepción: $e");
      throw Exception('Error de conexión con el servidor: $e');
    }
  }

  // Crear una nueva receta (posiblemente con imagen)
  Future<bool> crearReceta(Receta receta, File? imagen) async {
    // Asumimos ruta en Laravel: POST /api/recetas
    final url = Uri.parse('${Environment.apiUrl}/recetas');
    
    var request = http.MultipartRequest('POST', url);
    
    // Agregar campos de texto
    receta.toJson().forEach((key, value) {
      if (value != null) {
        request.fields[key] = value.toString();
      }
    });

    // Agregar imagen si existe
    if (imagen != null) {
      var pic = await http.MultipartFile.fromPath("imagen", imagen.path);
      request.files.add(pic);
    }

    // Agregar headers si son necesarios (excepto content-type que lo maneja Multipart)
    request.headers.addAll({
      'Accept': 'application/json',
    });

    try {
      var response = await request.send();
      if (response.statusCode == 201 || response.statusCode == 200) {
        return true;
      } else {
        final respStr = await response.stream.bytesToString();
        print("Error subiendo receta (${response.statusCode}): $respStr");
        return false;
      }
    } catch (e) {
      print("Error excepción: $e");
      return false;
    }
  }

  // Obtener Estadísticas del Chef (Dashboard)
  Future<Map<String, dynamic>> obtenerEstadisticas(int chefId) async {
    // Asumimos ruta en Laravel: GET /api/chefs/{id}/estadisticas
    final url = Uri.parse('${Environment.apiUrl}/chefs/$chefId/estadisticas');

    try {
      final response = await http.get(url, headers: Environment.headers);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        // Retornar datos vacíos si falla para no romper la UI
        return {
          'total_visualizaciones': 0,
          'calificacion_promedio': 0.0,
          'total_comentarios': 0,
          'total_favoritos': 0
        };
      }
    } catch (e) {
      return {};
    }
  }

  // Obtener catálogos para los dropdowns (Categorías, Estados)
  Future<List<CatalogoOpcion>> obtenerCatalogo(String dominio) async {
    // dominio: 'TIPO_ALIMENTO' o 'ESTADO_RECETA'
    final url = Uri.parse('${Environment.apiUrl}/catalogos/$dominio'); 
    
    try {
      final response = await http.get(url, headers: Environment.headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => CatalogoOpcion.fromJson(json)).toList();
      }
    } catch (e) {
      print("Error cargando catálogo $dominio: $e");
    }
    return [];
  }
}