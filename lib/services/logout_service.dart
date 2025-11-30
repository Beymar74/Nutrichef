import 'package:http/http.dart' as http;

class LogoutService {

  static const String baseUrl = "http://192.168.0.16:8000/api"; 

  static Future<bool> cerrarSesionSanctum(String token) async {
    final url = Uri.parse("$baseUrl/logout");

    final res = await http.post(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Accept": "application/json"
      },
    );

    print("LOGOUT → CODE ${res.statusCode}");
    print("RESPONSE → ${res.body}");

    return res.statusCode == 200;
  }
}
