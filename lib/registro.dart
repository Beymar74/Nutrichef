import 'package:flutter/material.dart';
import 'login.dart';
import 'services/api_service.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoPaternoController = TextEditingController();
  final TextEditingController _apellidoMaternoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _celularController = TextEditingController();
  final TextEditingController _fechaNacimientoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmarPasswordController = TextEditingController();

  bool _ocultarPassword = true;
  bool _ocultarConfirmarPassword = true;
  bool _aceptaTerminos = false;
  bool _isLoading = false;

  Future<void> _registrarUsuario() async {
    String nombre = _nombreController.text.trim();
    String apellidoPaterno = _apellidoPaternoController.text.trim();
    String apellidoMaterno = _apellidoMaternoController.text.trim();
    String email = _emailController.text.trim();
    String celular = _celularController.text.trim();
    String fechaNacimiento = _fechaNacimientoController.text.trim();
    String password = _passwordController.text;
    String confirmarPassword = _confirmarPasswordController.text;

    if (nombre.isEmpty ||
        apellidoPaterno.isEmpty ||
        email.isEmpty ||
        celular.isEmpty ||
        fechaNacimiento.isEmpty ||
        password.isEmpty ||
        confirmarPassword.isEmpty) {
      _mensajeError('Por favor completa todos los campos');
      return;
    }

    // 🔹 Validar formato de email
    if (!_esEmailValido(email)) {
      _mensajeError('Por favor ingresa un correo electrónico válido');
      return;
    }

    if (password != confirmarPassword) {
      _mensajeError('Las contraseñas no coinciden');
      return;
    }

    if (password.length < 6) {
      _mensajeError('La contraseña debe tener al menos 6 caracteres');
      return;
    }

    if (!_aceptaTerminos) {
      _mensajeError('Debes aceptar los términos y condiciones');
      return;
    }

    String fechaFormateada;
    try {
      List<String> partes = fechaNacimiento.replaceAll(' ', '').split('/');
      fechaFormateada = '${partes[2]}-${partes[1]}-${partes[0]}';
    } catch (_) {
      _mensajeError('Formato de fecha inválido');
      return;
    }

    String nameCorto = _generarNombreCorto(nombre, apellidoPaterno);

    setState(() => _isLoading = true);

    final response = await ApiService.register(
      nombres: nombre,
      apellidoPaterno: apellidoPaterno,
      apellidoMaterno: apellidoMaterno,
      email: email,
      celular: celular,
      fechaNacimiento: fechaFormateada,
      password: password,
      confirmarPassword: confirmarPassword,
      name: nameCorto,
    );

    setState(() => _isLoading = false);

    // 🔹 MANEJO MEJORADO DE RESPUESTAS
    if (response['success'] == true ||
        response['message'] == 'Usuario registrado correctamente') {
      _mostrarDialogoExito(nameCorto);
    } else {
      String errorMessage = response['message'] ?? 'Error al registrar';
      
      // 🔹 Manejo específico de errores de validación
      if (response['errors'] != null) {
        final errors = response['errors'] as Map<String, dynamic>;
        
        // Verificar si es error de email duplicado
        if (errors.containsKey('email')) {
          final emailErrors = errors['email'] as List;
          errorMessage = emailErrors.first.toString();
          
          // 🔹 Mensaje más amigable para email duplicado
          if (errorMessage.toLowerCase().contains('already') || 
              errorMessage.toLowerCase().contains('ya') ||
              errorMessage.toLowerCase().contains('existe') ||
              errorMessage.toLowerCase().contains('taken')) {
            errorMessage = '⚠️ Este correo electrónico ya está registrado.\nIntenta iniciar sesión o usa otro correo.';
            _mostrarDialogoCorreoDuplicado(email);
            return;
          }
        } else {
          // Otros errores de validación
          errorMessage = errors.values.first[0].toString();
        }
      }
      
      _mensajeError(errorMessage);
    }
  }

  // 🆕 Validar formato de email
  bool _esEmailValido(String email) {
    final RegExp emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  // 🆕 Diálogo específico para correo duplicado
  void _mostrarDialogoCorreoDuplicado(String email) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF8C21).withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.warning_amber_rounded,
                color: Color(0xFFFF8C21),
                size: 28,
              ),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'Correo Ya Registrado',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'El correo electrónico que ingresaste ya está siendo usado por otra cuenta.',
              style: TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.email_outlined,
                    size: 18,
                    color: Color(0xFFFF8C21),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      email,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              '¿Qué puedes hacer?',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 8),
            _opcionDialogo(
              Icons.login,
              'Iniciar sesión con esta cuenta',
            ),
            _opcionDialogo(
              Icons.email,
              'Usar otro correo electrónico',
            ),
            _opcionDialogo(
              Icons.lock_reset,
              'Recuperar tu contraseña',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Limpiar solo el campo de email
              _emailController.clear();
            },
            child: const Text(
              'Usar otro correo',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const Login()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF8C21),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Iniciar Sesión',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _opcionDialogo(IconData icon, String texto) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: const Color(0xFFFF8C21),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              texto,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  String _generarNombreCorto(String nombres, String apellidoPaterno) {
    final partes = nombres.split(' ');
    final primera = partes.first.toLowerCase();
    final letraApellido =
        apellidoPaterno.isNotEmpty ? apellidoPaterno[0].toLowerCase() : '';
    return (primera.length >= 3 ? primera.substring(0, 3) : primera) +
        letraApellido;
  }

  void _mensajeError(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(texto),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _mostrarDialogoExito(String nombreUsuario) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '¡Registro Exitoso!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF8C21),
                ),
              ),
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 60,
                backgroundColor: Color(0xFFFFD54F),
                child: Icon(Icons.check, color: Colors.white, size: 60),
              ),
              const SizedBox(height: 30),
              Text(
                'Bienvenido $nombreUsuario!',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              const Text(
                'Tu cuenta está lista.\nComienza a descubrir recetas deliciosas.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8C21),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                ),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const Login()),
                  );
                },
                child: const Text(
                  'Continuar',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _seleccionarFecha() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFFFF8C21),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Color(0xFFFF8C21)),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _fechaNacimientoController.text =
            '${picked.day.toString().padLeft(2, '0')} / ${picked.month.toString().padLeft(2, '0')} / ${picked.year}';
      });
    }
  }

  Widget _campo(String label, TextEditingController controller,
      {bool readOnly = false,
      bool obscure = false,
      VoidCallback? onTap,
      Widget? suffixIcon,
      TextInputType? tipo}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFFFD54F),
            borderRadius: BorderRadius.circular(12),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscure,
            readOnly: readOnly,
            onTap: onTap,
            keyboardType: tipo,
            decoration: InputDecoration(
              hintText: label,
              border: InputBorder.none,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              suffixIcon: suffixIcon,
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 20),
          child: Column(
            children: [
              // Botón de retroceso
              Align(
                alignment: Alignment.centerLeft,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Color(0xFFFF8C21),
                    size: 28,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const Login()),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Regístrate a NutriChef',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF8C21),
                ),
              ),
              const SizedBox(height: 30),
              _campo('Nombres', _nombreController),
              _campo('Apellido Paterno', _apellidoPaternoController),
              _campo('Apellido Materno', _apellidoMaternoController),
              _campo('Email', _emailController,
                  tipo: TextInputType.emailAddress),
              _campo('Número Celular', _celularController,
                  tipo: TextInputType.phone),
              _campo('Fecha de Nacimiento', _fechaNacimientoController,
                  readOnly: true, onTap: _seleccionarFecha),
              _campo(
                'Contraseña',
                _passwordController,
                obscure: _ocultarPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _ocultarPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () =>
                      setState(() => _ocultarPassword = !_ocultarPassword),
                ),
              ),
              _campo(
                'Confirmar Contraseña',
                _confirmarPasswordController,
                obscure: _ocultarConfirmarPassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _ocultarConfirmarPassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                  ),
                  onPressed: () => setState(() =>
                      _ocultarConfirmarPassword = !_ocultarConfirmarPassword),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: _aceptaTerminos,
                    onChanged: (v) =>
                        setState(() => _aceptaTerminos = v ?? false),
                    activeColor: const Color(0xFFFF8C21),
                  ),
                  Expanded(
                    child: Text(
                      'Aceptas los Términos de uso y Política de privacidad.',
                      style: TextStyle(color: Colors.grey[700], fontSize: 12),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isLoading ? null : _registrarUsuario,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8C21),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 60, vertical: 14),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        'Registrarme',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}