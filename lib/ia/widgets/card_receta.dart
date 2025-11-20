import 'package:flutter/material.dart';

class CardReceta extends StatelessWidget {
  final String imagen;
  final String titulo;
  final String descripcion;
  final double rating;
  final String tiempo;
  final bool favorito;
  final VoidCallback onTapFavorito;

  const CardReceta({
    super.key,
    required this.imagen,
    required this.titulo,
    required this.descripcion,
    required this.rating,
    required this.tiempo,
    required this.favorito,
    required this.onTapFavorito,
  });

  @override
  Widget build(BuildContext context) {
    const Color naranja = Color(0xFFFF8C21);
    const double borderRadius = 22;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBF5),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: const Color(0xFFFFB870), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // -----------------------------------------------
          // IMAGEN (Soporta Red y Assets)
          // -----------------------------------------------
          SizedBox(
            height: 120,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Transform.translate(
                  offset: const Offset(-0.5, 0),
                  child: Transform.scale(
                    scaleX: 1.03,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(borderRadius),
                      // AQUÍ ESTÁ LA MEJORA:
                      child: imagen.startsWith('http') 
                        ? Image.network(
                            imagen,
                            fit: BoxFit.cover,
                            height: 135,
                            width: double.infinity,
                            errorBuilder: (c, e, s) => Container( // Si falla la carga
                              color: Colors.grey.shade200,
                              child: const Icon(Icons.broken_image, color: Colors.grey),
                            ),
                          )
                        : Image.asset(
                            imagen,
                            fit: BoxFit.cover,
                            height: 135,
                            width: double.infinity,
                          ),
                    ),
                  ),
                ),

                // Ícono de favorito
                Positioned(
                  top: 10,
                  right: 10,
                  child: GestureDetector(
                    onTap: onTapFavorito,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        favorito ? Icons.favorite : Icons.favorite_border,
                        color: favorito ? naranja : Colors.grey,
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // -----------------------------------------------
          // CONTENIDO DEL CARD
          // -----------------------------------------------
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  descripcion,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 10),

                Row(
                  children: [
                    Icon(Icons.star,
                        color: Colors.amber.shade700, size: 18),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const Spacer(),
                    const Icon(Icons.timer_outlined,
                        size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      tiempo,
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 10),
              ],
            ),
          ),
        ],
      ),
    );
  }
}