import 'package:flutter/material.dart';
import 'ia/screens/ia_inicio_page.dart'; // <- Aquí apuntas a tu pantalla del módulo IA

void main() {
  runApp(const NutriChefApp());
}

class NutriChefApp extends StatelessWidget {
  const NutriChefApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nutrichef',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF8C21), // Naranja principal
          primary: const Color(0xFFFF8C21),
          secondary: const Color(0xFFFFD54F),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const IaInicioPage(), // <- Aquí defines que tu app arranque directamente en tu módulo IA
    );
  }
}
