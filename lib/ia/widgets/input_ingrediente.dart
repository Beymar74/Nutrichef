import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFFFF8C21);
  static const Color accent = Color(0xFFFFC107); // Amarillo cálido
  static const Color background = Colors.white;
  static const Color textLight = Color(0xFF6F6F6F);
}

class InputIngrediente extends StatefulWidget {
  final Function(String unidad, String nombre) onAgregar;
  final Function()? onEliminar;

  const InputIngrediente({
    super.key,
    required this.onAgregar,
    this.onEliminar,
  });

  @override
  State<InputIngrediente> createState() => _InputIngredienteState();
}

class _InputIngredienteState extends State<InputIngrediente> {
  final TextEditingController unidadController = TextEditingController();
  final TextEditingController nombreController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          // --- Campo Unidad ---
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: unidadController,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: AppColors.textLight,
                ),
                decoration: const InputDecoration(
                  hintText: 'Amt',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    color: AppColors.textLight,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // --- Campo Ingrediente ---
          Expanded(
            flex: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: nombreController,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 13,
                  color: AppColors.textLight,
                ),
                decoration: const InputDecoration(
                  hintText: 'Ice cubes',
                  hintStyle: TextStyle(
                    fontFamily: 'Poppins',
                    color: AppColors.textLight,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // --- Botón eliminar ---
          if (widget.onEliminar != null)
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.6),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.delete, color: AppColors.primary, size: 18),
                onPressed: widget.onEliminar,
              ),
            ),

          const SizedBox(width: 8),

          // --- Botón agregar ---
          ElevatedButton(
            onPressed: () {
              final unidad = unidadController.text.trim();
              final nombre = nombreController.text.trim();
              if (unidad.isNotEmpty && nombre.isNotEmpty) {
                widget.onAgregar(unidad, nombre);
                unidadController.clear();
                nombreController.clear();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            ),
            child: const Text(
              '+ Añadir',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
                fontSize: 13,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
