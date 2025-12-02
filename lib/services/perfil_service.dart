import 'dart:convert';
import 'package:http/http.dart' as http;

class PerfilService {
  static const String baseUrl = "http://10.0.2.2:18000/api";
  //static const String baseUrl = 'http://192.168.0.16:18000/api';

  /// 🔥 ACTUALIZA PERFIL (con imagen opcional)
  static Future<Map<String, dynamic>> actualizarPerfil({
    required String token,
    required String name,
    required String descripcion,
    required String altura,
    required String peso,
    String? imagen, // Solo se envía si existe
  }) async {
    try {

      ///👇 Enviamos solo los campos necesarios
      final Map<String, dynamic> data = {
        "name": name,
        "descripcion_perfil": descripcion,
        "altura": altura,
        "peso": peso,
      };

      ///👇 Si el usuario seleccionó imagen → se envía
      if (imagen != null) {
        data["imagen"] = imagen;
      }

      final res = await http.put(
        Uri.parse("$baseUrl/usuario/perfil"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token", // 🔥 Sanctum OK
        },
        body: jsonEncode(data),
      );

      return jsonDecode(res.body);

    } catch (e) {
      return {
        "success": false,
        "message": "❌ Error de conexión",
        "error": e.toString()
      };
    }
  }

  /// ======== NO TOCAMOS ESTAS (están correctas) ========

  static Future<Map<String, dynamic>> actualizarDieta({
    required String token,
    required int dietaId,
  }) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/perfil/dieta"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({"dieta": dietaId}),
      );

      return jsonDecode(res.body);
    } catch (e) {
      return {"success": false};
    }
  }

  static Future<Map<String, dynamic>> actualizarNivelCocina({
    required String token,
    required int nivelCocinaId
  }) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/perfil/nivel-cocina"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({"nivel_cocina": nivelCocinaId}),
      );

      return jsonDecode(res.body);
    } catch (e) {
      return {"success": false};
    }
  }

  static Future<Map<String, dynamic>> actualizarAlergias({
    required String token,
    required List<int> alergiasIds,
  }) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/perfil/alergias"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({"alergias": alergiasIds}),
      );

      return jsonDecode(res.body);
    } catch (e) {
      return {"success": false};
    }
  }
}
