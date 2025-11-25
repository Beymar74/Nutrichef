import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/comunidad_service.dart'; // Importar el servicio

class NuevaPublicacionScreen extends StatefulWidget {
  const NuevaPublicacionScreen({Key? key}) : super(key: key);

  @override
  _NuevaPublicacionScreenState createState() => _NuevaPublicacionScreenState();
}

class _NuevaPublicacionScreenState extends State<NuevaPublicacionScreen> {
  final _tituloController = TextEditingController();
  final _contenidoController = TextEditingController();

  bool _isLoading = false; // Estado de carga para el botón

  // Método para enviar la publicación al servidor
  Future<void> _crearPublicacion() async {
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

    // Obtener el token (puedes obtenerlo de la sesión del usuario o del almacenamiento local)
    final token = 'tu_token_aqui'; // Aquí deberías usar el token real

    // Llamada al servicio para crear la publicación
    final comunidadService = Provider.of<ComunidadService>(context, listen: false);
    final response = await comunidadService.crearPublicacion(titulo, contenido, token);

    setState(() {
      _isLoading = false;
    });

    if (response['success'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Publicación creada con éxito")),
      );
      // Aquí podrías redirigir a la pantalla principal o a otra
      Navigator.pop(context); // Regresar a la pantalla anterior
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Error al crear publicación")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Publicación'),
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
                    onPressed: _crearPublicacion,
                    child: const Text("Crear Publicación"),
                  ),
          ],
        ),
      ),
    );
  }
}
