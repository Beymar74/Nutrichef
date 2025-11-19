import 'dart:convert';
import 'package:http/http.dart' as http;

class PerfilService {
  //static const String baseUrl = "http://10.0.2.2:18000/api";
  static const String baseUrl = 'http://192.168.0.8:18000/api';

  // ✔ ACTUALIZA PERFIL COMPLETO
  static Future<Map<String, dynamic>> actualizarPerfil({
    required String token,
    required String name,
    required String descripcion,
    required String altura,
    required String peso,
  }) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/usuario/perfil"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "name": name,
          "descripcion_perfil": descripcion,
          "altura": altura,
          "peso": peso,
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        "success": false,
        "message": "❌ Error de conexión",
        "error": e.toString()
      };
    }
  }

  // ✔ ACTUALIZA DIETA (ID)
  static Future<Map<String, dynamic>> actualizarDieta({
    required String token,
    required int dietaId,     // 👈 en lugar de texto
  }) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/perfil/dieta"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "dieta": dietaId,      // 👈 ENVIAMOS EL ID REAL
        }),
      );

      return jsonDecode(res.body);
    } catch (e) {
      return {
        "success": false,
        "message": "❌ Error enviando dieta",
        "error": e.toString()
      };
    }
  }

  // ✔ ACTUALIZA NIVEL DE COCINA (ID)
  static Future<Map<String, dynamic>> actualizarNivelCocina({
    required String token,
    required int nivelCocinaId, // 👈 en lugar de texto
  }) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/perfil/nivel-cocina"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonEncode({
          "nivel_cocina": nivelCocinaId,  // 👈 ENVIAMOS EL ID REAL
        }),
      );

      return jsonDecode(res.body);
    } catch (e) {
      return {
        "success": false,
        "message": "❌ Error enviando nivel de cocina",
        "error": e.toString()
      };
    }
  }

  // ✔ ACTUALIZA ALERGIAS (lista de IDs)
  static Future<Map<String, dynamic>> actualizarAlergias({
    required String token,
    required List<int> alergiasIds,   // 👈 lista de IDs
  }) async {
    try {
      final response = await http.put(
        Uri.parse("$baseUrl/perfil/alergias"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode({
          "alergias": alergiasIds,   // 👈 ENVIAMOS LOS IDS DIRECTOS
        }),
      );

      return jsonDecode(response.body);
    } catch (e) {
      return {
        "success": false,
        "message": "❌ Error enviando alergias",
        "error": e.toString(),
      };
    }
  }
}
