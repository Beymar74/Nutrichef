import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/environment.dart';
import '../models/chef_receta_model.dart';

class ChefService {
  
  // --- LEER RECETAS ---
  Future<List<Receta>> obtenerMisRecetas(int chefId) async {
    final url = Uri.parse('${Environment.apiUrl}/recetas?id_usuario_creador=$chefId');
    try {
      final response = await http.get(url, headers: Environment.headers);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        return data.map((json) => Receta.fromJson(json)).toList();
      }
    } catch (e) {
      print("Error obteniendo recetas: $e");
    }
    return [];
  }

  // --- CREAR RECETA ---
  Future<bool> crearReceta(Receta receta, File? imagen) async {
    final url = Uri.parse('${Environment.apiUrl}/recetas');
    return _enviarSolicitudMultipart(url, 'POST', receta, imagen);
  }

  // --- ACTUALIZAR RECETA ---
  Future<bool> actualizarReceta(Receta receta, File? nuevaImagen) async {
    if (receta.id == null) return false;
    final url = Uri.parse('${Environment.apiUrl}/recetas/${receta.id}');
    // Laravel prefiere POST con _method=PUT para archivos
    return _enviarSolicitudMultipart(url, 'POST', receta, nuevaImagen, metodoHttp: 'PUT');
  }

  // --- ELIMINAR RECETA ---
  Future<bool> eliminarReceta(int id) async {
    final url = Uri.parse('${Environment.apiUrl}/recetas/$id');
    try {
      final response = await http.delete(url, headers: Environment.headers);
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print("Error eliminando: $e");
      return false;
    }
  }

  // --- ACTUALIZAR PERFIL (Nuevo) ---
  Future<bool> actualizarPerfil(int userId, Map<String, dynamic> datos) async {
    final url = Uri.parse('${Environment.apiUrl}/usuario/perfil');
    
    final bodyDatos = {
      'id': userId.toString(),
      ...datos,
    };

    try {
      print("👤 [ChefService] Actualizando perfil...");
      final response = await http.put(
        url,
        headers: Environment.headers,
        body: json.encode(bodyDatos),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print("Error perfil: ${response.body}");
        return false;
      }
    } catch (e) {
      print("🔥 [ChefService] Error perfil: $e");
      return false;
    }
  }

  // --- HELPER PRIVADO ---
  Future<bool> _enviarSolicitudMultipart(Uri url, String method, Receta receta, File? imagen, {String? metodoHttp}) async {
    var request = http.MultipartRequest(method, url);
    
    receta.toJson().forEach((key, value) {
      if (value != null) request.fields[key] = value.toString();
    });

    if (metodoHttp != null) request.fields['_method'] = metodoHttp;

    if (imagen != null) {
      var pic = await http.MultipartFile.fromPath("imagen", imagen.path);
      request.files.add(pic);
    }

    request.headers.addAll({'Accept': 'application/json'});

    try {
      var response = await request.send();
      return (response.statusCode >= 200 && response.statusCode < 300);
    } catch (e) {
      print("Error envío: $e");
      return false;
    }
  }

  // --- ESTADÍSTICAS ---
  Future<Map<String, dynamic>> obtenerEstadisticas(int chefId) async {
    final url = Uri.parse('${Environment.apiUrl}/chefs/$chefId/estadisticas');
    try {
      final response = await http.get(url, headers: Environment.headers);
      if (response.statusCode == 200) return json.decode(response.body);
    } catch (e) { print(e); }
    return {};
  }

  Future<List<CatalogoOpcion>> obtenerCatalogo(String dominio) async {
    return [];
  }
}