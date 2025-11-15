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

    return Padding(
      padding: const EdgeInsets.only(bottom: 20), // separación del borde inferior
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 14),
          decoration: BoxDecoration(
            color: naranja,
            borderRadius: BorderRadius.circular(40),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _item(
                icon: Icons.home_outlined,
                index: 0,
                selectedIndex: selectedIndex,
                onTap: onTap,
              ),
              const SizedBox(width: 40),
              _item(
                icon: Icons.chat_bubble_outline,
                index: 1,
                selectedIndex: selectedIndex,
                onTap: onTap,
              ),
              const SizedBox(width: 40),
              _item(
                icon: Icons.layers_outlined,
                index: 2,
                selectedIndex: selectedIndex,
                onTap: onTap,
              ),
              const SizedBox(width: 40),
              _item(
                icon: Icons.person_outline,
                index: 3,
                selectedIndex: selectedIndex,
                onTap: onTap,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _item({
    required IconData icon,
    required int index,
    required int selectedIndex,
    required Function(int) onTap,
  }) {
    final bool active = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Icon(
        icon,
        color: active ? Colors.white : Colors.white70,
        size: 28,
      ),
    );
  }
}
