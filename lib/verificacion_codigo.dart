import 'package:flutter/material.dart';
import 'dart:async';

class VerificacionCodigo extends StatefulWidget {
  const VerificacionCodigo({super.key});

  @override
  State<VerificacionCodigo> createState() => _VerificacionCodigoState();
}

class _VerificacionCodigoState extends State<VerificacionCodigo> {
  final List<TextEditingController> _controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );
  final List<FocusNode> _focusNodes = List.generate(
    6,
    (index) => FocusNode(),
  );

  int _segundosRestantes = 49;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _iniciarTemporizador();
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  void _iniciarTemporizador() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_segundosRestantes > 0) {
        setState(() {
          _segundosRestantes--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _reenviarCodigo() {
    setState(() {
      _segundosRestantes = 49;
    });
    _iniciarTemporizador();
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Código reenviado'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _verificarCodigo() {
    String codigo = _controllers.map((c) => c.text).join();
    
    if (codigo.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor ingresa el código completo'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    print('Código ingresado: $codigo');
    // Aquí iría la lógica de verificación
  }

  void _onDigitoIngresado(int index, String value) {
    if (value.isNotEmpty && index < 5) {
      _focusNodes[index + 1].requestFocus();
    }
  }

  void _onDigitoEliminado(int index) {
    if (_controllers[index].text.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  void _onTecladoNumero(String numero) {
    for (int i = 0; i < _controllers.length; i++) {
      if (_controllers[i].text.isEmpty) {
        setState(() {
          _controllers[i].text = numero;
        });
        if (i < 5) {
          _focusNodes[i + 1].requestFocus();
        }
        break;
      }
    }
  }

  void _onTecladoBorrar() {
    for (int i = _controllers.length - 1; i >= 0; i--) {
      if (_controllers[i].text.isNotEmpty) {
        setState(() {
          _controllers[i].text = '';
        });
        _focusNodes[i].requestFocus();
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.black87,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 35),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),

              // TÍTULO
              const Text(
                '¿Haz Olvidado Tu Contraseña?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF8C21),
                ),
              ),

              const SizedBox(height: 40),

              // SUBTÍTULO
              const Text(
                'Tienes Correo',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),

              const SizedBox(height: 15),

              // DESCRIPCIÓN
              Text(
                'Te enviaremos el código de verificación a tu dirección de correo electrónico, revisa tu correo y coloca el código justo abajo.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 40),

              // CAMPOS DE CÓDIGO (6 dígitos)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(6, (index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    child: Container(
                      width: 45,
                      height: 45,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFFFF8C21),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          _controllers[index].text,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 35),

              // TEXTO REENVIAR
              Column(
                children: [
                  const Text(
                    '¿No recibiste el correo?',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                  GestureDetector(
                    onTap: _segundosRestantes == 0 ? _reenviarCodigo : null,
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(fontSize: 14),
                        children: [
                          const TextSpan(
                            text: 'Puedes reenviar en ',
                            style: TextStyle(color: Colors.black87),
                          ),
                          TextSpan(
                            text: '$_segundosRestantes seg',
                            style: const TextStyle(
                              color: Color(0xFFFF8C21),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 35),

              // BOTÓN CONTINUAR
              SizedBox(
                width: 200,
                height: 50,
                child: ElevatedButton(
                  onPressed: _verificarCodigo,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFD54F),
                    foregroundColor: Colors.white,
                    elevation: 3,
                    shadowColor: const Color(0xFFFFD54F).withOpacity(0.4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Continuar',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // TECLADO NUMÉRICO PERSONALIZADO
              Container(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    // Fila 1-2-3
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTeclaNumero('1'),
                        _buildTeclaNumero('2'),
                        _buildTeclaNumero('3'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Fila 4-5-6
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTeclaNumero('4'),
                        _buildTeclaNumero('5'),
                        _buildTeclaNumero('6'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Fila 7-8-9
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTeclaNumero('7'),
                        _buildTeclaNumero('8'),
                        _buildTeclaNumero('9'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Fila *-0-borrar
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTeclaEspecial('*'),
                        _buildTeclaNumero('0'),
                        _buildTeclaBorrar(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeclaNumero(String numero) {
    return InkWell(
      onTap: () => _onTecladoNumero(numero),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 75,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFFD54F), width: 2),
        ),
        child: Center(
          child: Text(
            numero,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTeclaEspecial(String simbolo) {
    return Container(
      width: 75,
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFFFD54F), width: 2),
      ),
      child: Center(
        child: Text(
          simbolo,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildTeclaBorrar() {
    return InkWell(
      onTap: _onTecladoBorrar,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 75,
        height: 55,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFFFD54F), width: 2),
        ),
        child: const Center(
          child: Icon(
            Icons.backspace_outlined,
            color: Colors.black87,
            size: 24,
          ),
        ),
      ),
    );
  }
}