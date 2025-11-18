import 'package:flutter/material.dart';
import '../../../models/receta_model.dart';
import '../../../detalles-receta.dart';

class RecetaCard extends StatelessWidget {
  final Receta receta;
  final bool esFavorito;
  final VoidCallback onToggleFavorito;

  const RecetaCard({
    super.key,
    required this.receta,
    required this.esFavorito,
    required this.onToggleFavorito,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetallesRecetaScreen(
              receta: receta.toMap(),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImagen(),
            _buildInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildImagen() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: Image.network(
            receta.imagen ?? 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                height: 120,
                color: Colors.grey[300],
                child: const Icon(Icons.restaurant, size: 40),
              );
            },
          ),
        ),
        Positioned(
          top: 8,
          right: 8,
          child: GestureDetector(
            onTap: onToggleFavorito,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                esFavorito ? Icons.favorite : Icons.favorite_border,
                color: esFavorito ? const Color(0xFFEC888D) : Colors.grey[400],
                size: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfo() {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            receta.titulo,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.star, size: 12, color: Color(0xFFFF8C21)),
              const SizedBox(width: 4),
              const Text(
                '5',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFEC888D),
                ),
              ),
              const Spacer(),
              const Icon(Icons.access_time, size: 12, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                '${receta.tiempoPreparacion}min',
                style: TextStyle(fontSize: 11, color: Colors.grey[600]),
              ),
            ],
          ),
        ],
      ),
    );
  }
}