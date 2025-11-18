import 'package:flutter/material.dart';

class TopChefSection extends StatelessWidget {
  const TopChefSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Top Chef',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFFEC888D),
          ),
        ),
        const SizedBox(height: 15),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildChefCard('joseph.png', 'Joseph'),
              const SizedBox(width: 12),
              _buildChefCard('andrew.png', 'Andrew'),
              const SizedBox(width: 12),
              _buildChefCard('emily.png', 'Emily'),
              const SizedBox(width: 12),
              _buildChefCard('jessica.png', 'Jessica'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChefCard(String imageName, String nombre) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFFF8C21),
              width: 2,
            ),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/$imageName',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.person, size: 35),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          nombre,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}