import 'package:flutter/material.dart';
import '../services/publicaciones_service.dart';
import '../models/publicacion_model.dart';
import 'detalles_publicacion.dart';
class SocialScreen extends StatefulWidget {
  const SocialScreen({super.key});

  @override
  State<SocialScreen> createState() => _SocialScreenState();
}

class _SocialScreenState extends State<SocialScreen> {
  List<Publicacion> publicaciones = []; // Usamos una lista de Publicacion
  bool _isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _cargarPublicaciones();  // Cargar publicaciones al iniciar la pantalla
  }

  // Método para cargar publicaciones desde el servicio
  Future<void> _cargarPublicaciones() async {
    try {
      final data = await PublicacionesService.getPublicaciones();
      setState(() {
        publicaciones = data;  // Asignar las publicaciones a la lista
        _isLoading = false;  // Indicar que la carga de datos ha terminado
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        errorMessage = 'Error al cargar publicaciones';  // Error al conectar
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFF8C21),
        title: const Text('Comunidad'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);  // Vuelve a la pantalla anterior
          },
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())  // Indicador de carga
          : publicaciones.isEmpty
              ? Center(child: Text(errorMessage.isEmpty ? "No hay publicaciones" : errorMessage))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: publicaciones.length,
                  itemBuilder: (context, index) {
                    final p = publicaciones[index];  // Obtenemos la publicación
                    return GestureDetector(
                      onTap: () {
                        // Navegar a la pantalla de detalles de la publicación
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetallesPublicacionScreen (publicacion: p),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: ListTile(
                          title: Text(p.titulo),  // Título de la publicación
                          subtitle: Text(p.resumen ?? 'No disponible'),  // Resumen de la publicación
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
