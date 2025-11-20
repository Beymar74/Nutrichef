import 'package:flutter/material.dart';
import '../services/publicaciones_service.dart';  // Servicio para obtener publicaciones
import '../models/publicacion_model.dart'; // El modelo para la publicación
import 'detalles_publicacion.dart';  // Detalles de cada publicación

class SocialScreen extends StatefulWidget {
  const SocialScreen({Key? key}) : super(key: key);

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  List<Publicacion> publicaciones = [];
  bool _isLoading = true;
  String errorMessage = '';  // En caso de error

  @override
  void initState() {
    super.initState();
    _cargarPublicaciones();
  }

  // Cargar publicaciones desde el servicio
  Future<void> _cargarPublicaciones() async {
    try {
      final data = await PublicacionesService.getPublicaciones();  // Llamada al servicio
      setState(() {
        publicaciones = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        errorMessage = 'Error al cargar publicaciones';
      });
    }
  }

  // Navegar a la pantalla de creación de publicación (si se desea)
  void _navegarACrearPublicacion() {
    // Aquí puedes implementar la lógica para permitir al usuario crear una nueva publicación
    // Ejemplo: Navigator.push(context, MaterialPageRoute(builder: (_) => CrearPublicacionScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunidad'),
        backgroundColor: const Color(0xFFFF8C21),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _navegarACrearPublicacion, // Navegar a crear publicación
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : publicaciones.isEmpty
              ? Center(child: Text(errorMessage.isEmpty ? "No hay publicaciones" : errorMessage))
              : ListView.builder(
                  itemCount: publicaciones.length,
                  itemBuilder: (context, index) {
                    final publicacion = publicaciones[index];
                    return Card(
                      margin: const EdgeInsets.all(10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 5,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(10),
                        title: Text(publicacion.titulo),
                        subtitle: Text(publicacion.resumen ?? "Resumen no disponible"),
                        onTap: () {
                          // Navegar a los detalles de la publicación
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DetallesPublicacionScreen(publicacion: publicacion),
                            ),
                          );
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.favorite_border),
                          onPressed: () {
                            // Implementar lógica para dar "me gusta" a la publicación
                          },
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navegarACrearPublicacion,
        backgroundColor: const Color(0xFFFF8C21),
        child: const Icon(Icons.add),
      ),
    );
  }
}
