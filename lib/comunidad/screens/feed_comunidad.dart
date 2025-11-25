import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/comunidad_service.dart'; // Importar el servicio
import '../models/publicacion_model.dart'; // Importar el modelo de Publicación

class FeedComunidadScreen extends StatefulWidget {
  const FeedComunidadScreen({Key? key}) : super(key: key);

  @override
  _FeedComunidadScreenState createState() => _FeedComunidadScreenState();
}

class _FeedComunidadScreenState extends State<FeedComunidadScreen> {
  @override
  void initState() {
    super.initState();

    // Usamos addPostFrameCallback para asegurarnos de que el código se ejecute después de la construcción
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final comunidadService = Provider.of<ComunidadService>(context, listen: false);
      if (comunidadService.posts.isEmpty && !comunidadService.loading) {
        // Se pasa el token real del usuario aquí
        comunidadService.cargarFeed('token'); // Asegúrate de pasar el token real del usuario
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final comunidadService = Provider.of<ComunidadService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunidad'),
        backgroundColor: const Color(0xFFFFA726), // Calabaza (ejemplo)
      ),
      body: comunidadService.loading
          ? const Center(child: CircularProgressIndicator()) // Indicador de carga
          : comunidadService.posts.isEmpty
              ? const Center(child: Text('No hay publicaciones disponibles'))
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
                            // Aquí puedes agregar la lógica para reaccionar
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
