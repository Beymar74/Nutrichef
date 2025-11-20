import 'package:flutter/material.dart';
import '../models/publicacion_model.dart'; // Asegúrate de tener el modelo 'Publicacion'

class DetallesPublicacionScreen extends StatelessWidget {
  final Publicacion publicacion;

  const DetallesPublicacionScreen({Key? key, required this.publicacion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF8C21), // Calabaza Naranja
        title: const Text(
          'Detalles de la Publicación',
          style: TextStyle(
            fontFamily: "Poppins",
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        children: [
          // Imagen de la publicación
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: Image.network(
              publicacion.imagen ?? "https://via.placeholder.com/300",  // Usar imagen de placeholder si no hay imagen
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          
          // Título de la publicación
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              publicacion.titulo.isNotEmpty ? publicacion.titulo : "Sin título",  // Verifica si el título está vacío
              style: const TextStyle(
                fontFamily: "Poppins",
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C0F0D), // Color negro suave
              ),
            ),
          ),
          
          // Resumen o descripción
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              publicacion.resumen ?? "No hay resumen disponible",  // Si no hay resumen, mostrar un texto predeterminado
              style: const TextStyle(
                fontFamily: "LeagueSpartan",
                fontSize: 16,
                color: Color(0xFF3E2823), // Café Pocho
              ),
            ),
          ),
          
          const SizedBox(height: 12),

          // Ingredientes o detalles
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              publicacion.contenido ?? "No se proporcionaron detalles.",  // Si no hay contenido, mostrar un texto predeterminado
              style: const TextStyle(
                fontFamily: "LeagueSpartan",
                fontSize: 16,
                color: Color(0xFF3E2823), // Café Pocho
              ),
            ),
          ),
          
          const SizedBox(height: 20),

          // Reacciones: Likes y comentarios
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Icon(Icons.favorite, color: Color(0xFFFF8C21)), // Icono de like
                const SizedBox(width: 8),
                Text(
                  "${publicacion.likes} Likes",  // Muestra el número de likes
                  style: const TextStyle(
                    fontFamily: "LeagueSpartan",
                    fontSize: 16,
                    color: Color(0xFF3E2823),
                  ),
                ),
                const Spacer(),
                Icon(Icons.mood, color: Color(0xFFFF8C21)), // Icono de comentarios
                const SizedBox(width: 8),
                Text(
                  "${publicacion.comentarios} Comentarios",  // Muestra el número de comentarios
                  style: const TextStyle(
                    fontFamily: "LeagueSpartan",
                    fontSize: 16,
                    color: Color(0xFF3E2823),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Botones para interactuar (compartir, reportar, etc.)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Lógica para compartir
                    print('Compartir publicación');
                  },
                  icon: const Icon(Icons.share),
                  label: const Text("Compartir"),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF8C21)),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // Lógica para reportar publicación
                    print('Reportar publicación');
                  },
                  icon: const Icon(Icons.report),
                  label: const Text("Reportar"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
