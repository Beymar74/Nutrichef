import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFF8C21);
  static const Color textDark = Color(0xFF1E1E1E);
  static const Color background = Colors.white;
}

class DialogoAlerta extends StatelessWidget {
  final String ingrediente;
  final VoidCallback onContinuar;

  const DialogoAlerta({
    super.key,
    required this.ingrediente,
    required this.onContinuar,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 45),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // --- Ícono de alerta ---
            Image.asset(
              'assets/images/AlertaIcono.png',
              width: 50,
              height: 50,
            ),
            const SizedBox(height: 20),

            // --- Título ---
            const Text(
              '¡Alergeno Detectado!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 15),

            // --- Mensaje dinámico ---
            Text(
              'Se ha detectado un alérgeno del usuario en el siguiente ingrediente:\n'
              '$ingrediente, sea cuidadoso.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: AppColors.textDark,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 25),

            // --- Botón continuar ---
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: onContinuar,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Continuar',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
