import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // 🔥 LOGIN COMPLETO CON GOOGLE → FIREBASE → BACKEND LARAVEL
  Future<Map<String, dynamic>> loginWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return {'success': false, 'message': 'Login cancelado'};
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      // Autenticar en Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await _auth.signInWithCredential(credential);

      final idToken = googleAuth.idToken;

      if (idToken == null) {
        return {'success': false, 'message': 'Error obteniendo idToken'};
      }

      // Enviar idToken al backend Laravel
      final response = await http.post(
        Uri.parse('http://10.0.2.2:18000/api/google/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_token': idToken}),
      );

      final data = jsonDecode(response.body);
      return data;

    } catch (e) {
      print("❌ Error al iniciar sesión con Google: $e");
      return {
        'success': false,
        'message': 'Error al iniciar sesión con Google',
        'error': e.toString()
      };
    }
  }

  // 🔹 Cerrar sesión
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // 🔹 Obtener usuario actual
  User? get currentUser => _auth.currentUser;
}
