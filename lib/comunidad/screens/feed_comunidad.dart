import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/comunidad_service.dart'; // Importar el servicio
import '../widgets/barra_reacciones.dart'; // Importamos el widget BarraReacciones

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
        comunidadService.cargarFeed('token'); // Asegúrate de pasar el token real del usuario
      }
    });
  }

  // Método para cargar comentarios
  void _cargarComentarios(int idPublicacion) async {
    final comunidadService = Provider.of<ComunidadService>(context, listen: false);
    final token = 'token'; // Aquí deberías obtener el token real

    await comunidadService.obtenerComentarios(idPublicacion, token); // Llamada a la función de comentarios
  }

  // Método para manejar la reacción de like
  void _darReaccion(int idPublicacion) async {
    final comunidadService = Provider.of<ComunidadService>(context, listen: false);
    final token = 'token'; // Aquí deberías obtener el token real

    final response = await comunidadService.darReaccion(idPublicacion, token);
    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Reacción agregada")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Error al agregar reacción")),
      );
    }
  }

  // Método para eliminar publicación
  void _eliminarPublicacion(int idPublicacion) async {
    final comunidadService = Provider.of<ComunidadService>(context, listen: false);
    final token = 'token'; // Aquí deberías obtener el token real

    final response = await comunidadService.eliminarPublicacion(idPublicacion, token);
    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Publicación eliminada")),
      );
      // Recargar el feed después de eliminar
      comunidadService.cargarFeed(token);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Error al eliminar publicación")),
      );
    }
  }

  // Método para editar publicación
  void _editarPublicacion(int idPublicacion) {
    // Aquí puedes agregar la lógica para navegar a una pantalla de edición de publicación
    print('Editando publicación con ID: $idPublicacion');
    // Navegar a la pantalla de edición, por ejemplo:
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (_) => EditarPublicacionScreen(id: idPublicacion)),
    // );
  }

  // Método para reportar publicación
  void _reportarPublicacion(int idPublicacion) async {
    final comunidadService = Provider.of<ComunidadService>(context, listen: false);
    final token = 'token'; // Aquí deberías obtener el token real

    final response = await comunidadService.reportarPublicacion(idPublicacion, token);
    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Publicación reportada")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Error al reportar publicación")),
      );
    }
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
                    _cargarComentarios(post['id']); // Cargar los comentarios para cada publicación

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      child: ListTile(
                        title: Text(post['titulo']),
                        subtitle: Text(post['contenido']),
                        trailing: BarraReacciones(idPublicacion: post['id']),
                      ),
                    );
                  },
                ),
    );
  }
}