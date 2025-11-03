import 'package:flutter/material.dart';

class EstilosInicio {
  // COLORES
  static const Color colorFondo = Color(0xFFFF9800);
  static const Color colorBlanco = Colors.white;

  // ESTILOS DE TEXTO
  static const TextStyle estiloTitulo = TextStyle(
    fontSize: 48,
    fontWeight: FontWeight.bold,
    color: colorBlanco,
    letterSpacing: 2.0,
  );

  // TAMAÑOS
  static const double tamanoLogo = 120.0;
  static const double espacioLogoTitulo = 30.0;

  // DECORACIONES
  static BoxDecoration decoracionLogo = BoxDecoration(
    color: colorBlanco,
    shape: BoxShape.circle,
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 20,
        offset: const Offset(0, 10),
      ),
    ],
  );
}
