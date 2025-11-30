import 'package:flutter/material.dart';
import 'registro.dart';
import 'home.dart';
import 'chef/home_chef.dart'; // 🔹 IMPORTAR HomeChef
import 'recuperar_password.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  //LOGIN NORMAL
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

    if (token.isNotEmpty) {
      usuario['token'] = token; // 🟢 Guardamos el token en usuario
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(response['message'] ?? 'Inicio de sesión exitoso'),
        backgroundColor: Colors.green,
      ),
    );

    // 🔹 REDIRECCIÓN SEGÚN ROL
    final idRol = usuario['id_rol'];
    
    print('🔍 DEBUG - ID del rol recibido: $idRol');
    print('🔍 DEBUG - Tipo de dato: ${idRol.runtimeType}');
    
    // Convertir a int si viene como String
    final rolNumerico = idRol is int ? idRol : int.tryParse(idRol.toString()) ?? 1;
    
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

  // 🔹 LOGIN CON GOOGLE
  Future<void> _loginConGoogle() async {
    final authService = AuthService();
    final user = await authService.signInWithGoogle();

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Inicio de sesión cancelado o fallido'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final email = user.email ?? '';
    final nombreCompleto = user.displayName ?? 'Usuario Google';
    final foto = user.photoURL ?? '';

    // 🔸 Verificar si ya existe en tu base de datos
    final verificar = await ApiService.verificarUsuarioGoogle(email);

    if (verificar['success'] == true && verificar['existe'] == true) {
      // ✅ Usuario ya registrado → iniciar sesión
      final usuario = verificar['usuario'] ?? {};
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bienvenido de nuevo 👋'),
          backgroundColor: Colors.green,
        ),
      );

      // 🔹 REDIRECCIÓN SEGÚN ROL PARA GOOGLE
      final idRol = usuario['id_rol'];
      
      print('🔍 DEBUG Google - ID del rol: $idRol');
      print('🔍 DEBUG Google - Tipo: ${idRol.runtimeType}');
      
      // Convertir a int si viene como String
      final rolNumerico = idRol is int ? idRol : int.tryParse(idRol.toString()) ?? 1;
      
      if (rolNumerico == 2) {
        // ROL CHEF → Redirigir a HomeChef
        print('✅ Google: Redirigiendo a HomeChef');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => HomeChef(usuario: usuario)),
        );
      } else {
        // ROL USUARIO NORMAL → Redirigir a Home
        print('✅ Google: Redirigiendo a Home (usuario normal)');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => Home(usuario: usuario)),
        );
      }
    } else {
      // 🔹 Si no existe → registrar en base de datos
      final partesNombre = nombreCompleto.split(' ');
      final nombres = partesNombre.isNotEmpty ? partesNombre.first : nombreCompleto;
      final apellido = partesNombre.length > 1 ? partesNombre.last : '';

      final registro = await ApiService.registrarUsuarioGoogle(
        nombres: nombres,
        apellidoPaterno: apellido,
        email: email,
        foto: foto,
      );

      if (registro['success'] == true) {
        final usuario = registro['usuario'] ?? {
          'nombres': nombres,
          'email': email,
          'foto': foto,
        };
        
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cuenta creada con Google ✅'),
            backgroundColor: Colors.green,
          ),
        );

        // 🔹 REDIRECCIÓN SEGÚN ROL PARA NUEVO USUARIO GOOGLE
        final idRol = usuario['id_rol'];
        
        print('🔍 DEBUG Google Nuevo - ID del rol: $idRol');
        print('🔍 DEBUG Google Nuevo - Tipo: ${idRol.runtimeType}');
        
        // Convertir a int si viene como String
        final rolNumerico = idRol is int ? idRol : int.tryParse(idRol.toString()) ?? 1;
        
        if (rolNumerico == 2) {
          // ROL CHEF → Redirigir a HomeChef
          print('✅ Google Nuevo: Redirigiendo a HomeChef');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => HomeChef(usuario: usuario)),
          );
        } else {
          // ROL USUARIO NORMAL → Redirigir a Home
          print('✅ Google Nuevo: Redirigiendo a Home (usuario normal)');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => Home(usuario: usuario)),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(registro['message'] ?? 'Error al registrar usuario'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
                Image.asset(
                  'assets/images/logo.png',
                  width: 100,
                  height: 100,
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
                                fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white,),
                          ),
                  ),
                ),

                const SizedBox(height: 15),

                // BOTÓN REGISTRARSE
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _registrarse,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF8C21),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Registrarse',
                      style: TextStyle(
                          fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white,),
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

                const SizedBox(height: 25),

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