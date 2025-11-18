import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  final String nombreUsuario;
  final int estrellas;
  final int monedas;

  const HomeHeader({
    super.key,
    required this.nombreUsuario,
    this.estrellas = 0,
    this.monedas = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hola! $nombreUsuario',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFFEC888D),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Que te gustaría cocinar hoy',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
        Row(
          children: [
            _buildBadge(
              icon: Icons.star,
              iconColor: const Color(0xFFFF8C21),
              value: estrellas,
            ),
            const SizedBox(width: 8),
            _buildBadge(
              emoji: '🪙',
              value: monedas,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBadge({IconData? icon, Color? iconColor, String? emoji, required int value}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD54F),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          if (icon != null)
            Icon(icon, color: iconColor, size: 20)
          else if (emoji != null)
            Text(emoji, style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 4),
          Text(
            value.toString(),
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}