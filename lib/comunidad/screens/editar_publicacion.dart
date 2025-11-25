import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/comunidad_service.dart'; // Importar el servicio

class EditarPublicacionScreen extends StatefulWidget {
  final int idPublicacion; // ID de la publicación a editar

  const EditarPublicacionScreen({Key? key, required this.idPublicacion}) : super(key: key);

  @override
  _EditarPublicacionScreenState createState() => _EditarPublicacionScreenState();
}

class _EditarPublicacionScreenState extends State<EditarPublicacionScreen> {
  final _tituloController = TextEditingController();
  final _contenidoController = TextEditingController();

  bool _isLoading = false; // Estado de carga

  @override
  void initState() {
    super.initState();
    // Cargar los datos de la publicación al iniciar
    _cargarPublicacion();
  }

  // Método para cargar la publicación a editar
  Future<void> _cargarPublicacion() async {
    final comunidadService = Provider.of<ComunidadService>(context, listen: false);
    final token = 'token'; // Aquí deberías usar el token real

    // Cargar los datos de la publicación por su ID
    await comunidadService.obtenerPublicacionPorId(widget.idPublicacion, token);

    // Si la publicación fue cargada, asignamos los datos a los controladores
    if (comunidadService.posts.isNotEmpty) {
      _tituloController.text = comunidadService.posts[0]['titulo'];
      _contenidoController.text = comunidadService.posts[0]['contenido'];
    }
  }

  // Método para actualizar la publicación
  Future<void> _actualizarPublicacion() async {
    final titulo = _tituloController.text.trim();
    final contenido = _contenidoController.text.trim();

    if (titulo.isEmpty || contenido.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor llena todos los campos")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final comunidadService = Provider.of<ComunidadService>(context, listen: false);
    final token = 'token'; // Aquí deberías usar el token real

    // Llamamos a la función para actualizar la publicación
    final response = await comunidadService.actualizarPublicacion(
      widget.idPublicacion, 
      titulo, 
      contenido, 
      token
    );

    setState(() {
      _isLoading = false;
    });

    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Publicación actualizada con éxito")),
      );
      // Redirigir a la pantalla principal o feed
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Error al actualizar publicación")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Publicación'),
        backgroundColor: const Color(0xFFFFA726), // Calabaza
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(labelText: "Título"),
            ),
            TextField(
              controller: _contenidoController,
              decoration: const InputDecoration(labelText: "Contenido"),
              maxLines: 4,
            ),
            const SizedBox(height: 20),
            _isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: _actualizarPublicacion,
                    child: const Text("Actualizar Publicación"),
                  ),
          ],
        ),
      ),
    );
  }
}
