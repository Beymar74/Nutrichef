import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/comunidad_service.dart';

class BarraReacciones extends StatelessWidget {
  final int idPublicacion;
  final String token;

  const BarraReacciones({Key? key, required this.idPublicacion, required this.token}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final comunidadService = Provider.of<ComunidadService>(context, listen: false);

    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.thumb_up),
          onPressed: () {
            comunidadService.likeToggle(idPublicacion, token);  // Llama al método para dar like
          },
        ),
        const SizedBox(width: 8),
        Text("0"), // Aquí puedes usar el contador real de likes
        const SizedBox(width: 16),
        IconButton(
          icon: const Icon(Icons.comment),
          onPressed: () {
            // Llamar a la pantalla de comentarios (esto lo harías según tu lógica)
          },
        ),
        const SizedBox(width: 8),
        Text("0 comentarios"), // Contador de comentarios
      ],
    );
  }
}
