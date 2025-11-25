import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/comunidad_service.dart'; // Importamos el servicio para gestionar las reacciones y reportes

class BarraReacciones extends StatelessWidget {
  final int idPublicacion; // Recibimos el ID de la publicación
  const BarraReacciones({Key? key, required this.idPublicacion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final comunidadService = Provider.of<ComunidadService>(context);

    // Método para manejar la reacción de like
    void _darReaccion() async {
      final token = 'tu_token_aqui'; // Aquí obtienes el token real del usuario
      final response = await comunidadService.darReaccion(idPublicacion, token);

      // Mostrar un Snackbar con la respuesta
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Error al agregar reacción")),
      );
    }

    // Método para manejar el reporte de la publicación
    void _reportarPublicacion() async {
      final token = 'tu_token_aqui'; // Aquí obtienes el token real del usuario
      final response = await comunidadService.reportarPublicacion(idPublicacion, token);

      // Mostrar un Snackbar con la respuesta
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? "Error al reportar publicación")),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: const Icon(Icons.thumb_up),
          onPressed: _darReaccion,
        ),
        IconButton(
          icon: const Icon(Icons.report),
          onPressed: _reportarPublicacion,
        ),
      ],
    );
  }
}
