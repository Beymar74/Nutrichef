import 'package:flutter/material.dart';
import '../services/publicaciones_service.dart';

class NuevaPublicacionScreen extends StatefulWidget {
  const NuevaPublicacionScreen({Key? key}) : super(key: key);

  @override
  _NuevaPublicacionScreenState createState() => _NuevaPublicacionScreenState();
}

class _NuevaPublicacionScreenState extends State<NuevaPublicacionScreen> {
  final _tituloController = TextEditingController();
  final _contenidoController = TextEditingController();
  final _resumenController = TextEditingController();
  bool _isLoading = false;

  void _crearPublicacion() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await PublicacionesService.crearPublicacion(
        _tituloController.text,
        _contenidoController.text,
        _resumenController.text,
      );
      // Navegar hacia el feed
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al crear publicación')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Publicación'),
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
              onPressed: _isLoading ? null : _crearPublicacion,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text('Crear Publicación'),
            ),
          ],
        ),
      ),
    );
  }
}
