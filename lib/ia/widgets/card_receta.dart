import 'package:flutter/material.dart';

class CardReceta extends StatelessWidget {
  final String imagen;
  final String titulo;
  final String descripcion;
  final double rating;
  final String tiempo;
  final bool favorito;
  final VoidCallback? onTapFavorito;

  const CardReceta({
    super.key,
    required this.imagen,
    required this.titulo,
    required this.descripcion,
    required this.rating,
    required this.tiempo,
    this.favorito = false,
    this.onTapFavorito,
  });

  @override
  Widget build(BuildContext context) {
    const Color naranja = Color(0xFFFF8C21);
    const Color amarilloSuave = Color(0xFFFFF3E0);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: naranja.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen con botón de favorito
          Stack(
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.asset(
                  imagen,
                  width: double.infinity,
                  height: 160,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: onTapFavorito,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      favorito ? Icons.favorite : Icons.favorite_border,
                      color: favorito ? Colors.pinkAccent : naranja,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Contenido de la receta
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  descripcion,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Colors.black54,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 8),

                // Calificación y tiempo
                Row(
                  children: [
                    Icon(Icons.star, color: naranja, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      rating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.access_time, size: 16, color: Colors.black54),
                    const SizedBox(width: 4),
                    Text(
                      tiempo,
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
