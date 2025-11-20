import 'package:flutter/material.dart';
import '../services/publicaciones_service.dart';

class EditarPublicacionScreen extends StatefulWidget {
  final int publicacionId;
  final String titulo;
  final String contenido;
  final String resumen;

  const EditarPublicacionScreen({
    Key? key,
    required this.publicacionId,
    required this.titulo,
    required this.contenido,
    required this.resumen,
  }) : super(key: key);

  @override
  _EditarPublicacionScreenState createState() => _EditarPublicacionScreenState();
}

class _EditarPublicacionScreenState extends State<EditarPublicacionScreen> {
  late TextEditingController _tituloController;
  late TextEditingController _contenidoController;
  late TextEditingController _resumenController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _tituloController = TextEditingController(text: widget.titulo);
    _contenidoController = TextEditingController(text: widget.contenido);
    _resumenController = TextEditingController(text: widget.resumen);
  }

  void _editarPublicacion() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await PublicacionesService.editarPublicacion(
        widget.publicacionId,
        _tituloController.text,
        _contenidoController.text,
        _resumenController.text,
      );
      Navigator.pop(context);  // Volver a la pantalla anterior (feed)
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al editar publicación')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Publicación'),
        backgroundColor: const Color(0xFFFF8C21),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tituloController,
              decoration: const InputDecoration(hintText: 'Título'),
            ),
            TextField(
              controller: _resumenController,
              decoration: const InputDecoration(hintText: 'Resumen'),
            ),
            TextField(
              controller: _contenidoController,
              decoration: const InputDecoration(hintText: 'Contenido'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _editarPublicacion,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Editar Publicación'),
            ),
          ],
        ),
      ),
    );
  }
}
