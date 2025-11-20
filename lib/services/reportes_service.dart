import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_service.dart'; // Asegúrate de que ApiService esté correctamente importado

class ReportesService {
  // Método para reportar una publicación
  static Future<void> reportarPublicacion(int id, String descripcion) async {
    final url = Uri.parse("${ApiService.baseUrl}/publicaciones/$id/reportar");

    try {
      // Realizamos la solicitud HTTP POST a la API con los headers y datos correspondientes
      final response = await http.post(
        url,
        headers: ApiService.headers(),  // Headers con el token de autenticación
        body: jsonEncode({'descripcion': descripcion}), // Datos a enviar (la descripción del reporte)
      );

      // Validación de la respuesta del servidor
      if (response.statusCode != 200) {
        throw Exception("Error al reportar publicación. Código de estado: ${response.statusCode}");
      }

      // Si todo va bien, podemos hacer algo adicional si lo necesitamos
      print("Publicación reportada exitosamente.");
    } catch (e) {
      // Manejo de errores de la solicitud
      print("Error al reportar la publicación: $e");
      throw Exception("No se pudo reportar la publicación. Intente de nuevo.");
    }
  }
}
