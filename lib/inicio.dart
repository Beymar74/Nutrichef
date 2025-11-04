import 'package:flutter/material.dart';
import 'dart:async';
import 'login.dart';

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

    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const Login()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFF8C21), // Calabaza-Naranja
              Color(0xFFFF9F4D),
              Color(0xFFFFB366),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo - VERSIÓN CON TAMAÑO AUMENTADO
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 800),
                curve: Curves.elasticOut,
                builder: (context, double value, child) {
                  return Transform.scale(scale: value, child: child);
                },
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(30),
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // Título con animación
              TweenAnimationBuilder(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOut,
                builder: (context, double value, child) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 20 * (1 - value)),
                      child: child,
                    ),
                  );
                },
                child: const Text(
                  'NutriChef',
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 3.0,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 15),

              // Subtítulo
              const Text(
                'Tu compañero de cocina saludable',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.0,
                ),
              ),

              const SizedBox(height: 60),

              // Indicador de carga
              const SizedBox(
                width: 40,
                height: 40,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
