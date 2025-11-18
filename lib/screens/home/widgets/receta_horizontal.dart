import 'package:flutter/material.dart';
import '../../../models/receta_model.dart';
import '../../../detalles-receta.dart';

class RecetaHorizontal extends StatelessWidget {
  final Receta receta;

  const RecetaHorizontal({
    super.key,
    required this.receta,
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
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            _buildImagen(),
            const SizedBox(width: 12),
            Expanded(child: _buildInfo()),
          ],
        ),
      ),
    );
  }

  Widget _buildImagen() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: Image.network(
        receta.imagen ?? 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
        width: 80,
        height: 80,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 80,
            height: 80,
            color: Colors.grey[300],
            child: const Icon(Icons.restaurant, size: 30),
          );
        },
      ),
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          receta.titulo,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          receta.resumen,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(
              Icons.access_time,
              size: 14,
              color: Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              '${receta.tiempoPreparacion}min',
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ],
    );
  }
}