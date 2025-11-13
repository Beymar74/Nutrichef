import 'package:flutter/material.dart';

class CardReceta extends StatelessWidget {
  final String imagen;
  final String titulo;
  final String descripcion;
  final double rating;
  final String tiempo;

  const CardReceta({
    super.key,
    required this.imagen,
    required this.titulo,
    required this.descripcion,
    required this.rating,
    required this.tiempo,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --------------------------
          // IMAGEN
          // --------------------------
          ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18),
              topRight: Radius.circular(18),
            ),
            child: Image.asset(
              imagen,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // --------------------------
                // TÍTULO
                // --------------------------
                Text(
                  titulo,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),

                const SizedBox(height: 4),

                // --------------------------
                // DESCRIPCIÓN
                // --------------------------
                Text(
                  descripcion,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    height: 1.2,
                    color: Colors.grey.shade700,
                  ),
                ),

                const SizedBox(height: 10),

                // --------------------------
                // RATING + TIEMPO
                // --------------------------
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Color(0xFFFF8C21)),
                    const SizedBox(width: 4),
                    Text(
                      rating.toString(),
                      style: const TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        color: Colors.black87,
                      ),
                    ),

                    const Spacer(),

                    const Icon(Icons.access_time,
                        size: 16, color: Color(0xFFFF8C21)),
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
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
