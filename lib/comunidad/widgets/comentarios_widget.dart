import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/comunidad_service.dart';

class ComentariosWidget extends StatefulWidget {
  final int idPublicacion;

  const ComentariosWidget({Key? key, required this.idPublicacion}) : super(key: key);

  @override
  _ComentariosWidgetState createState() => _ComentariosWidgetState();
}

class _ComentariosWidgetState extends State<ComentariosWidget> {
  final TextEditingController _comentarioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Cargar comentarios al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _cargarComentarios();
    });
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }

  // Método para cargar los comentarios
  void _cargarComentarios() async {
    final comunidadService = Provider.of<ComunidadService>(context, listen: false);
    final token = 'token'; // Deberías obtener el token real del usuario
    await comunidadService.obtenerComentarios(widget.idPublicacion, token);
  }

  // Método para agregar un nuevo comentario
  void _agregarComentario() async {
    if (_comentarioController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("El comentario no puede estar vacío")),
      );
      return;
    }

    final comunidadService = Provider.of<ComunidadService>(context, listen: false);
    final token = 'token'; // Deberías obtener el token real del usuario

    final response = await comunidadService.agregarComentario(
      widget.idPublicacion,
      _comentarioController.text,
      token,
    );

    // Mostrar un Snackbar con la respuesta
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response['message'] ?? "Error al agregar comentario")),
    );

    // Limpiar el campo de texto si fue exitoso
    if (response['success'] == true) {
      _comentarioController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final comunidadService = Provider.of<ComunidadService>(context);

    return Column(
      children: [
        // Mostrar lista de comentarios
        comunidadService.comentarios.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('No hay comentarios aún'),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: comunidadService.comentarios.length,
                itemBuilder: (context, index) {
                  final comentario = comunidadService.comentarios[index];
                  return ListTile(
                    title: Text(comentario['usuario'] ?? 'Usuario'),
                    subtitle: Text(comentario['contenido'] ?? ''),
                  );
                },
              ),
        // Campo de texto para agregar comentario
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            controller: _comentarioController,
            decoration: InputDecoration(
              labelText: "Escribe un comentario",
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send),
                onPressed: _agregarComentario,
              ),
            ),
            onSubmitted: (_) => _agregarComentario(),
          ),
        ),
      ],
    );
  }
}