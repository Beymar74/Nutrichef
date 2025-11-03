import 'package:flutter/material.dart';
import 'dart:async';
import 'login.dart';
import 'estilos/estilosInicio.dart';

class Inicio extends StatefulWidget {
  const Inicio({super.key});

  @override
  State<Inicio> createState() => _InicioState();
}

class _InicioState extends State<Inicio> {
  @override
  void initState() {
    super.initState();
    _navigateToLogin();
  }

  void _navigateToLogin() async {
    await Future.delayed(const Duration(seconds: 3));
    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const Login()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EstilosInicio.colorFondo,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: EstilosInicio.tamanoLogo,
              height: EstilosInicio.tamanoLogo,
              decoration: EstilosInicio.decoracionLogo,
              child: const Icon(
                Icons.restaurant_menu,
                size: 60,
                color: Color(0xFFFF9800),
              ),
            ),
            const SizedBox(height: EstilosInicio.espacioLogoTitulo),
            const Text(
              'NutriChef',
              style: EstilosInicio.estiloTitulo,
            ),
          ],
        ),
      ),
    );
  }
}
