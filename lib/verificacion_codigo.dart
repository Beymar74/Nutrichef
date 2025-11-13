import 'package:flutter/material.dart';
import 'dart:async';
import 'services/password_service.dart';
import 'nueva_contrasena.dart';

class VerificacionCodigo extends StatefulWidget {
  final String email;
  const VerificacionCodigo({super.key, required this.email});

  @override
  State<VerificacionCodigo> createState() => _VerificacionCodigoState();
}

class _VerificacionCodigoState extends State<VerificacionCodigo> {
  final List<TextEditingController> _controllers =
      List.generate(6, (i) => TextEditingController());
  int _segundosRestantes = 49;
  Timer? _timer;
  bool _cargando = false;

  @override
  void initState() {
    super.initState();
    _iniciar();
  }

  void _iniciar() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_segundosRestantes > 0) {
        setState(() => _segundosRestantes--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    for (var c in _controllers) {
      c.dispose();
    }
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _reenviar() async {
    final res = await PasswordService.enviarCodigo(widget.email);
    if (res['success']) {
      setState(() => _segundosRestantes = 49);
      _iniciar();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Código reenviado"),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _verificar() async {
    final codigo = _controllers.map((c) => c.text).join();
    if (codigo.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Ingresa los 6 dígitos"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => _cargando = true);
    final res = await PasswordService.verificarCodigo(widget.email, codigo);
    setState(() => _cargando = false);

    if (res['success'] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NuevaContrasena(email: widget.email),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['message']),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
              const Text(
                "¿Has Olvidado Tu Contraseña?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF8C21),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              const Text(
                "Tienes Correo",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                "Revisa tu bandeja y coloca abajo el código de verificación.",
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700], fontSize: 13),
              ),
              const SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  6,
                  (i) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          width: 2,
                          color: const Color(0xFFFF8C21),
                        ),
                      ),
                      child: Center(
                        child: Text(
                          _controllers[i].text,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: _segundosRestantes == 0 ? _reenviar : null,
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                    children: [
                      const TextSpan(text: "Puedes reenviar en "),
                      TextSpan(
                        text: "$_segundosRestantes s",
                        style: const TextStyle(
                          color: Color(0xFFFF8C21),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 25),
              SizedBox(
                width: 200,
                height: 48,
                child: ElevatedButton(
                  onPressed: _cargando ? null : _verificar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD54F),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: _cargando
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Continuar",
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const Spacer(),
              Column(
                children: [
                  _fila(['1', '2', '3']),
                  const SizedBox(height: 8),
                  _fila(['4', '5', '6']),
                  const SizedBox(height: 8),
                  _fila(['7', '8', '9']),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _tecla('*', () {}),
                      _tecla('0', () => _teclar('0')),
                      _borrar(),
                    ],
                  )
                ],
              ),
              const SizedBox(height: 15),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ========= WIDGETS DEL TECLADO =========
  Widget _fila(List<String> n) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: n.map((x) => _tecla(x, () => _teclar(x))).toList(),
    );
  }

  Widget _tecla(String texto, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 70,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFFD54F), width: 2),
        ),
        child: Center(
          child: Text(
            texto,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _borrar() {
    return InkWell(
      onTap: () {
        for (int i = 5; i >= 0; i--) {
          if (_controllers[i].text.isNotEmpty) {
            setState(() => _controllers[i].text = '');
            break;
          }
        }
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 70,
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFFD54F), width: 2),
        ),
        child: const Icon(Icons.backspace_outlined, size: 22),
      ),
    );
  }

  void _teclar(String valor) {
    for (int i = 0; i < 6; i++) {
      if (_controllers[i].text.isEmpty) {
        setState(() => _controllers[i].text = valor);
        break;
      }
    }
  }
}