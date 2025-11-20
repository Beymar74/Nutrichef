import 'package:flutter/material.dart';
import '../services/reportes_service.dart';  // Servicio para manejar reportes

class ReportarPublicacionScreen extends StatelessWidget {
  final int publicacionId;

  const ReportarPublicacionScreen({Key? key, required this.publicacionId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _descripcionController = TextEditingController();

    void _reportar() async {
      try {
        await ReportesService.reportarPublicacion(publicacionId, _descripcionController.text);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Publicación reportada')));
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al reportar publicación')));
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reportar Publicación'),
        backgroundColor: const Color(0xFFFF8C21),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _descripcionController,
              decoration: const InputDecoration(hintText: 'Descripción del reporte'),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _reportar,
              child: const Text('Reportar'),
            ),
          ],
        ),
      ),
    );
  }
}
