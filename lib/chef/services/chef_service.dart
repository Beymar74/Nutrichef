import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/environment.dart';
import '../models/chef_receta_model.dart';

class ChefService {
  
  // --- LEER ---
  Future<List<Receta>> obtenerMisRecetas(int chefId) async {
    final String urlString = '${Environment.apiUrl}/recetas?id_usuario_creador=$chefId';
    print("🌐 [ChefService] Intentando conectar a: $urlString");
    
    try {
      final response = await http.get(
        Uri.parse(urlString), 
        headers: Environment.headers
      ).timeout(const Duration(seconds: 10)); // Timeout de 10s

      print("📩 [ChefService] Código de respuesta: ${response.statusCode}");

      if (response.statusCode == 200) {
        // Imprimir los primeros 100 caracteres para ver si llega JSON
        String preview = response.body.length > 100 ? response.body.substring(0, 100) : response.body;
        print("📦 [ChefService] Cuerpo (preview): $preview...");

        final List<dynamic> data = json.decode(response.body);
        print("✅ [ChefService] Se decodificaron ${data.length} recetas");
        
        return data.map((json) => Receta.fromJson(json)).toList();
      } else {
        print("❌ [ChefService] Error del servidor: ${response.body}");
        throw Exception('Error ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print("🔥 [ChefService] EXCEPCIÓN CRÍTICA: $e");
      // Si es un error de conexión, suele ser SocketException
      if (e.toString().contains("SocketException") || e.toString().contains("Connection refused")) {
        print("⚠️ [CONSEJO] Verifica que tu PC y Celular estén en la misma WIFI y el Firewall esté desactivado.");
      }
    }
    return [];
  }

  // --- CREAR ---
  Future<bool> crearReceta(Receta receta, File? imagen) async {
    final url = Uri.parse('${Environment.apiUrl}/recetas');
    print("🌐 [ChefService] Enviando receta a: $url");
    print("📝 [ChefService] Datos: ${receta.toJson()}");

    return _enviarSolicitudMultipart(url, 'POST', receta, imagen);
  }

  // --- ACTUALIZAR ---
  Future<bool> actualizarReceta(Receta receta, File? nuevaImagen) async {
    if (receta.id == null) return false;
    final url = Uri.parse('${Environment.apiUrl}/recetas/${receta.id}');
    return _enviarSolicitudMultipart(url, 'POST', receta, nuevaImagen, metodoHttp: 'PUT');
  }

  // --- ELIMINAR ---
  Future<bool> eliminarReceta(int id) async {
    final url = Uri.parse('${Environment.apiUrl}/recetas/$id');
    try {
      final response = await http.delete(url, headers: Environment.headers);
      print("🗑️ [ChefService] Eliminar status: ${response.statusCode}");
      return response.statusCode == 200 || response.statusCode == 204;
    } catch (e) {
      print("🔥 [ChefService] Error eliminando: $e");
      return false;
    }
  }

  // --- HELPER PRIVADO ---
  Future<bool> _enviarSolicitudMultipart(Uri url, String method, Receta receta, File? imagen, {String? metodoHttp}) async {
    try {
      var request = http.MultipartRequest(method, url);
      
      // Campos de texto
      receta.toJson().forEach((key, value) {
        if (value != null) request.fields[key] = value.toString();
      });

      // Override de método para Laravel
      if (metodoHttp != null) request.fields['_method'] = metodoHttp;

      // Imagen
      if (imagen != null) {
        print("📸 [ChefService] Adjuntando imagen: ${imagen.path}");
        var pic = await http.MultipartFile.fromPath("imagen", imagen.path);
        request.files.add(pic);
      }

      request.headers.addAll({
        'Accept': 'application/json',
        // 'Content-Type': 'multipart/form-data', // No agregar manualmente, http lo hace
      });

      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      
      print("📩 [ChefService] Respuesta Guardado (${response.statusCode}): $respStr");
      
      return (response.statusCode >= 200 && response.statusCode < 300);
    } catch (e) {
      print("🔥 [ChefService] Error envío: $e");
      return false;
    }
  }

  // --- OTROS ---
  Future<Map<String, dynamic>> obtenerEstadisticas(int chefId) async {
    return {'total_visualizaciones': 0, 'calificacion_promedio': 0.0, 'total_comentarios': 0, 'total_favoritos': 0};
  }

  Future<List<CatalogoOpcion>> obtenerCatalogo(String dominio) async {
    return [];
  }
}