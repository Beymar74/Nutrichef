import 'package:flutter/material.dart';
import 'screens/home/home_screen.dart';

// CLASE DE COMPATIBILIDAD
// Mantiene la clase "Home" para no romper imports existentes
class Home extends StatelessWidget {
  final Map<String, dynamic> usuario;
  
  const Home({super.key, required this.usuario});

  @override
  Widget build(BuildContext context) {
    return HomeScreen(usuario: usuario);
  }
}