import 'package:flutter/material.dart';

class CategoriaChips extends StatelessWidget {
  final String categoriaSeleccionada;
  final Function(String) onCategoriaSeleccionada;

  const CategoriaChips({
    super.key,
    required this.categoriaSeleccionada,
    required this.onCategoriaSeleccionada,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildChip('Todas'),
          const SizedBox(width: 10),
          _buildChip('Desayuno'),
          const SizedBox(width: 10),
          _buildChip('Almuerzo'),
          const SizedBox(width: 10),
          _buildChip('Cena'),
          const SizedBox(width: 10),
          _buildChip('Vegano'),
          const SizedBox(width: 10),
          _buildChip('Dulce'),
        ],
      ),
    );
  }

  Widget _buildChip(String label) {
    final isSelected = categoriaSeleccionada == label;
    
    return GestureDetector(
      onTap: () => onCategoriaSeleccionada(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF8C21) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF8C21) : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }
}