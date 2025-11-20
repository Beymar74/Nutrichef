import 'package:flutter/material.dart';
import '../models/publicacion_model.dart';

class DetallesPublicacionScreen extends StatelessWidget {
  final Publicacion publicacion;

  const DetallesPublicacionScreen({Key? key, required this.publicacion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalles de la Publicación'),
        backgroundColor: const Color(0xFFFF8C21),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Mostrar imagen si existe
            if (publicacion.imagen != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(publicacion.imagen!),
              ),
            const SizedBox(height: 10),
            // Título
            Text(
              publicacion.titulo,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1C0F0D),
              ),
            ),
            const SizedBox(height: 10),
            // Resumen
            Text(publicacion.resumen ?? 'No hay resumen disponible', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            // Contenido
            Text(publicacion.contenido ?? 'No hay contenido disponible', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            // Reacciones
            Row(
              children: [
                Icon(Icons.favorite, color: Color(0xFFFF8C21)),
                const SizedBox(width: 8),
                Text("${publicacion.likes} Likes"),
                const Spacer(),
                Icon(Icons.mood, color: Color(0xFFFF8C21)),
                const SizedBox(width: 8),
                Text("${publicacion.comentarios} Comentarios"),
              ],
            ),
            const SizedBox(height: 20),
            // Botones de acción (compartir, etc.)
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    // Lógica para compartir la publicación
                  },
                  icon: const Icon(Icons.share),
                  label: const Text("Compartir"),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF8C21)),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () {
                    // Lógica para reportar la publicación
                  },
                  icon: const Icon(Icons.report),
                  label: const Text("Reportar"),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
