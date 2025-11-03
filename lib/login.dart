import 'package:flutter/material.dart';
import 'estilos/estilosLogin.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _ocultarPassword = true;

  void _iniciarSesion() {
    String email = _emailController.text;
    String password = _passwordController.text;
    print('Email: $email');
    print('Password: $password');
  }

  void _registrarse() {
    print('Ir a pantalla de registro');
  }

  void _olvidoPassword() {
    print('Recuperar contraseña');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EstilosLogin.colorFondo,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Login',
                  style: EstilosLogin.estiloTitulo,
                ),
                const SizedBox(height: EstilosLogin.espacioTitulo),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 40, bottom: 8),
                    child: Text('Email', style: EstilosLogin.estiloLabel),
                  ),
                ),
                SizedBox(
                  width: EstilosLogin.anchoCampo,
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: EstilosLogin.estiloTextoInput,
                    decoration:
                        EstilosLogin.decoracionCampo('example@example.com'),
                  ),
                ),
                const SizedBox(height: EstilosLogin.espacioEntreCampos),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 40, bottom: 8),
                    child: Text('Password', style: EstilosLogin.estiloLabel),
                  ),
                ),
                SizedBox(
                  width: EstilosLogin.anchoCampo,
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _ocultarPassword,
                    style: EstilosLogin.estiloTextoInput,
                    decoration: InputDecoration(
                      hintText: '••••••••',
                      hintStyle: TextStyle(
                        color: EstilosLogin.colorTexto.withOpacity(0.5),
                      ),
                      filled: true,
                      fillColor: EstilosLogin.colorAmarillo,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _ocultarPassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: EstilosLogin.colorTexto,
                        ),
                        onPressed: () {
                          setState(() {
                            _ocultarPassword = !_ocultarPassword;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: EstilosLogin.espacioEntreCampos + 10),
                ElevatedButton(
                  onPressed: _iniciarSesion,
                  style: EstilosLogin.estiloBoton,
                  child: const Text(
                    'Log In',
                    style: EstilosLogin.estiloTextoBoton,
                  ),
                ),
                const SizedBox(height: EstilosLogin.espacioEntreBotones),
                ElevatedButton(
                  onPressed: _registrarse,
                  style: EstilosLogin.estiloBoton,
                  child: const Text(
                    'Sign Up',
                    style: EstilosLogin.estiloTextoBoton,
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: _olvidoPassword,
                  child: const Text(
                    'Forgot Password?',
                    style: EstilosLogin.estiloTextoOlvido,
                  ),
                ),
                const SizedBox(height: 30),
                const Text(
                  'or sign up with',
                  style: EstilosLogin.estiloTextoRedesSociales,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _iconoRedSocial(Icons.camera_alt, () {
                      print('Login con Instagram');
                    }),
                    const SizedBox(width: EstilosLogin.espacioEntreIconos),
                    _iconoRedSocial(Icons.g_mobiledata, () {
                      print('Login con Google');
                    }),
                    const SizedBox(width: EstilosLogin.espacioEntreIconos),
                    _iconoRedSocial(Icons.facebook, () {
                      print('Login con Facebook');
                    }),
                    const SizedBox(width: EstilosLogin.espacioEntreIconos),
                    _iconoRedSocial(Icons.chat, () {
                      print('Login con WhatsApp');
                    }),
                  ],
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: _registrarse,
                  child: const Text(
                    "Don't have an account? Sign Up",
                    style: EstilosLogin.estiloTextoRegistro,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _iconoRedSocial(IconData icono, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: EstilosLogin.tamanoIconoRedSocial,
        height: EstilosLogin.tamanoIconoRedSocial,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: EstilosLogin.colorTexto, width: 1.5),
        ),
        child: Icon(
          icono,
          color: EstilosLogin.colorTexto,
          size: 24,
        ),
      ),
    );
  }
}
