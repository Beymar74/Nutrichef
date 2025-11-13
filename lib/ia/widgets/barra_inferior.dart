import 'package:flutter/material.dart';

class BarraInferior extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  const BarraInferior({
    super.key,
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color naranja = Color(0xFFFF8C21);

    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: naranja,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _iconoNav(Icons.home_outlined, 0, selectedIndex, onTap),
          _iconoNav(Icons.chat_bubble_outline, 1, selectedIndex, onTap),
          _iconoNav(Icons.layers_outlined, 2, selectedIndex, onTap),
          _iconoNav(Icons.person_outline, 3, selectedIndex, onTap),
        ],
      ),
    );
  }

  Widget _iconoNav(IconData icon, int index, int selected, Function(int) onTap) {
    final bool activo = index == selected;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Icon(
        icon,
        color: activo ? Colors.white : Colors.white70,
        size: activo ? 30 : 26,
      ),
    );
  }
}
