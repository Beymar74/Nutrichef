import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/comunidad_service.dart'; // Importar el servicio
import '../models/publicacion_model.dart'; // Importar el modelo de Publicación

class FeedComunidadScreen extends StatelessWidget {
  const FeedComunidadScreen({Key? key}) : super(key: key);

  @override
Widget build(BuildContext context) {
  final comunidadService = Provider.of<ComunidadService>(context);

  // Llamamos a cargarFeed si no hemos cargado las publicaciones
  if (comunidadService.posts.isEmpty && !comunidadService.loading) {
    comunidadService.cargarFeed('tu_token'); // Pasa el token real del usuario
  }

  return Scaffold(
    appBar: AppBar(
      title: const Text('Comunidad'),
      backgroundColor: const Color(0xFFFFA726), // Calabaza (ejemplo)
    ),
    body: comunidadService.loading
        ? const Center(child: CircularProgressIndicator()) // Indicador de carga
        : ListView.builder(
            itemCount: comunidadService.posts.length,
            itemBuilder: (context, index) {
              final post = comunidadService.posts[index];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                child: ListTile(
                  title: Text(post['titulo']), // Título de la publicación
                  subtitle: Text(post['contenido']), // Contenido de la publicación
                  trailing: IconButton(
                    icon: const Icon(Icons.thumb_up), // Icono para reacciones
                    onPressed: () {
                      // Lógica para reaccionar (agregar un like)
                    },
                  ),
                ),
              );
            },
          ),
  );
}

}
