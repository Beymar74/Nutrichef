import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/comunidad_service.dart';

class BarraReacciones extends StatelessWidget {
  final int idPublicacion;
  final String token; // ✅ Recibir el token
  
  const BarraReacciones({
    Key? key, 
    required this.idPublicacion,
    required this.token, // ✅ Agregar token
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final comunidadService = Provider.of<ComunidadService>(context, listen: false);

    void _darReaccion() async {
      final response = await comunidadService.darReaccion(idPublicacion, token);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? "Error al agregar reacción"),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }

    void _reportarPublicacion() async {
      final response = await comunidadService.reportarPublicacion(idPublicacion, token);
      
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response['message'] ?? "Error al reportar publicación"),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }

    // ✅ Cambiar a mainAxisSize: MainAxisSize.min
    return Row(
      mainAxisSize: MainAxisSize.min, // ✅ Esto es clave
      children: [
        IconButton(
          icon: const Icon(Icons.thumb_up_outlined),
          onPressed: _darReaccion,
          tooltip: 'Me gusta',
        ),
        IconButton(
          icon: const Icon(Icons.comment_outlined),
          onPressed: () {
            // TODO: Navegar a comentarios
          },
          tooltip: 'Comentarios',
        ),
        IconButton(
          icon: const Icon(Icons.flag_outlined),
          onPressed: _reportarPublicacion,
          tooltip: 'Reportar',
        ),
      ],
    );
  }
}