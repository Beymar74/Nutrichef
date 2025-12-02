import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/comunidad_service.dart';

class ReportarPublicacionScreen extends StatelessWidget {
  final int idPublicacion;

  const ReportarPublicacionScreen({Key? key, required this.idPublicacion})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final comunidadService = Provider.of<ComunidadService>(
      context,
      listen: false,
    );
    final token = "user_token"; // Reemplazar con el token real

    return Scaffold(
      appBar: AppBar(
        title: const Text("Reportar Publicación"),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "¿Por qué estás reportando esta publicación?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                // Llamamos al método para reportar la publicación
                await comunidadService.reportarPublicacion(
                  idPublicacion,
                  token,
                );
                Navigator.pop(
                  context,
                ); // Cierra la pantalla después de reportar
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Publicación reportada")),
                );
              },
              child: const Text("Reportar como inapropiado"),
              style: TextButton.styleFrom(
                backgroundColor:
                    Colors.red, // Cambiar primary por backgroundColor
                foregroundColor: Colors.white, // Establecer el color del texto aquí
              ),
            ),
          ],
        ),
      ),
    );
  }
}
