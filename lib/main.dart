import 'package:flutter/material.dart';
import 'inicio.dart';

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
          seedColor: const Color(0xFFFF8C21), // Calabaza-Naranja
          primary: const Color(0xFFFF8C21),
          secondary: const Color(0xFFFFD54F),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const Inicio(),
    );
  }
}
