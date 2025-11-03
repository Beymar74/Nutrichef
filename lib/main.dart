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
      title: 'NutriChef',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF9800),
          primary: const Color(0xFFFF9800),
          secondary: const Color(0xFFFFD54F),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const Inicio(),
    );
  }
}
