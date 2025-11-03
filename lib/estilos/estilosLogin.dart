import 'package:flutter/material.dart';

class EstilosLogin {
  // COLORES
  static const Color colorFondo = Colors.white;
  static const Color colorNaranja = Color(0xFFFF9800);
  static const Color colorAmarillo = Color(0xFFFFD54F);
  static const Color colorTexto = Color(0xFF666666);
  static const Color colorTextoOscuro = Color(0xFF333333);

  // ESTILOS DE TEXTO
  static const TextStyle estiloTitulo = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: colorNaranja,
  );

  static const TextStyle estiloLabel = TextStyle(
    fontSize: 16,
    color: colorTextoOscuro,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle estiloTextoInput = TextStyle(
    fontSize: 16,
    color: colorTextoOscuro,
  );

  static const TextStyle estiloTextoBoton = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
    color: colorTextoOscuro,
  );

  static const TextStyle estiloTextoOlvido = TextStyle(
    fontSize: 14,
    color: colorTextoOscuro,
    decoration: TextDecoration.underline,
  );

  static const TextStyle estiloTextoRedesSociales = TextStyle(
    fontSize: 14,
    color: colorTexto,
  );

  static const TextStyle estiloTextoRegistro = TextStyle(
    fontSize: 14,
    color: colorTextoOscuro,
  );

  // DECORACIONES
  static InputDecoration decoracionCampo(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: colorTexto.withOpacity(0.5),
      ),
      filled: true,
      fillColor: colorAmarillo,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
      ),
    );
  }

  // ESTILOS DE BOTONES
  static ButtonStyle estiloBoton = ElevatedButton.styleFrom(
    backgroundColor: colorAmarillo,
    foregroundColor: colorTextoOscuro,
    elevation: 0,
    padding: const EdgeInsets.symmetric(
      horizontal: 50,
      vertical: 15,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
  );

  // TAMAÑOS
  static const double espacioEntreCampos = 20.0;
  static const double espacioEntreBotones = 15.0;
  static const double espacioTitulo = 40.0;
  static const double anchoCampo = 300.0;
  static const double tamanoIconoRedSocial = 40.0;
  static const double espacioEntreIconos = 15.0;
}
