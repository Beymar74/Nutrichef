import 'package:flutter/material.dart';
import '../../../models/receta_model.dart';
import '../../../detalles-receta.dart';

class RecetaDestacada extends StatelessWidget {
  final Receta? receta;
  final bool esFavorito;
  final VoidCallback onToggleFavorito;

  const RecetaDestacada({
    super.key,
    required this.receta,
    required this.esFavorito,
    required this.onToggleFavorito,
  });

  @override
  Widget build(BuildContext context) {
    if (receta == null) {
      return _buildPlaceholder();
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetallesRecetaScreen(
              receta: receta!.toMap(),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              _buildImagen(),
              _buildBotonFavorito(),
              _buildInfoReceta(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImagen() {
    return Image.network(
      receta!.imagen ?? 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800',
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return Container(
          height: 200,
          color: Colors.grey[300],
          child: const Icon(
            Icons.restaurant,
            size: 60,
            color: Colors.grey,
          ),
        );
      },
    );
  }

  Widget _buildBotonFavorito() {
    return Positioned(
      top: 10,
      right: 10,
      child: GestureDetector(
        onTap: onToggleFavorito,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 1,
                blurRadius: 4,
              ),
            ],
          ),
          child: Icon(
            esFavorito ? Icons.favorite : Icons.favorite_border,
            color: esFavorito ? const Color(0xFFEC888D) : Colors.grey[400],
            size: 20,
          ),
        ),
      ),
    );
  }

  Widget _buildInfoReceta() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    receta!.titulo,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.access_time, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      '${receta!.tiempoPreparacion}min',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              receta!.resumen,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 6),
            Row(
              children: const [
                Icon(Icons.star, size: 14, color: Color(0xFFFF8C21)),
                SizedBox(width: 4),
                Text(
                  '5',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEC888D),
                  ),
                ),
                SizedBox(width: 2),
                Icon(Icons.favorite, size: 14, color: Color(0xFFEC888D)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text('No hay recetas disponibles para esta categoría'),
      ),
    );
  }
}