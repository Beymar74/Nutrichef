import 'package:flutter/material.dart';
import 'registro.dart';
import 'home.dart';
import 'chef/home_chef.dart';
import 'recuperar_password.dart';
import 'services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _ocultarPassword = true;
  bool _isLoading = false;

  // LOGIN NORMAL
  Future<void> _iniciarSesion() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor completa todos los campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    final response = await ApiService.login(email: email, password: password);

    setState(() => _isLoading = false);

    if (response['success'] == true) {
      final usuario = response['usuario'] ?? {};
      final token = response['token'] ?? '';
      
      final userId = usuario['id']; 
      final idRol = usuario['id_rol']; 

      print('🔍 DEBUG - ID del rol recibido: $idRol');
      print('🔍 DEBUG - Tipo de dato: ${idRol.runtimeType}');

      // 🟢 GUARDAR EN PREFERENCIAS
      final prefs = await SharedPreferences.getInstance();
      if (token.isNotEmpty) {
        await prefs.setString('auth_token', token);
        usuario['token'] = token; 
      }
      
      if (userId != null) {
        await prefs.setInt('auth_user_id', userId is int ? userId : int.parse(userId.toString()));
      }

      // Convertir a int si viene como String
      final rolNumerico = idRol is int ? idRol : int.tryParse(idRol.toString()) ?? 1;
      await prefs.setInt('auth_role', rolNumerico);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Inicio de sesión exitoso'),
          backgroundColor: Colors.green,
        ),
      );

      // 🔹 REDIRECCIÓN SEGÚN ROL
      if (rolNumerico == 2) {
        // ROL CHEF (id_rol = 2) → Redirigir a HomeChef
        print('✅ Redirigiendo a HomeChef');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => HomeChef(usuario: usuario)),
        );
      } else {
        // ROL USUARIO NORMAL (id_rol = 1) → Redirigir a Home
        print('✅ Redirigiendo a Home (usuario normal)');
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => Home(usuario: usuario)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response['message'] ?? 'Error al iniciar sesión'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _registrarse() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const Registro()));
  }

  void _olvidoPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const RecuperarPassword()),
    );
  }

  // 🔹 INTERFAZ
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // LOGO DE LA APP
                Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
                  errorBuilder: (context, error, stackTrace) => 
                    const Icon(Icons.restaurant_menu, size: 80, color: Color(0xFFFF8C21)),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Iniciar Sesión',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF8C21),
                  ),
                ),
                const SizedBox(height: 40),

                // EMAIL
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD54F),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'ejemplo@ejemplocorreo.com',
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // CONTRASEÑA
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Contraseña',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD54F),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _ocultarPassword,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      border: InputBorder.none,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _ocultarPassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: Colors.grey[700],
                        ),
                        onPressed: () {
                          setState(() {
                            _ocultarPassword = !_ocultarPassword;
                          });
                        },
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 35),

                // BOTÓN LOGIN
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _iniciarSesion,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8C21),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white, strokeWidth: 2)
                        : const Text(
                            'Iniciar Sesión',
                            style: TextStyle(
                              fontSize: 17, 
                              fontWeight: FontWeight.bold, 
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 25),

                // ENLACE OLVIDASTE CONTRASEÑA
                TextButton(
                  onPressed: _olvidoPassword,
                  child: const Text(
                    '¿Olvidaste tu contraseña?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // DIVISOR
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey[400])),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text(
                        'O',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey[400])),
                  ],
                ),

                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿No tienes ninguna cuenta? ',
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                    GestureDetector(
                      onTap: _registrarse,
                      child: const Text(
                        'Regístrate',
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFFFF8C21),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}