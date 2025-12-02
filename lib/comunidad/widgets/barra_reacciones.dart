import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/comunidad_service.dart';
import '../screens/detalle_publicacion.dart';

class BarraReacciones extends StatelessWidget {
  final int idPublicacion;
  final Map<String, dynamic> usuario;
  final int likesCount;
  final int comentariosCount;
  final bool yaDioLike;

  const BarraReacciones({
    Key? key,
    required this.idPublicacion,
    required this.usuario,
    required this.likesCount,
    required this.comentariosCount,
    required this.yaDioLike,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // ===============================
        // BOTÓN DE LIKE
        // ===============================
        InkWell(
          onTap: () {
            final service =
                Provider.of<ComunidadService>(context, listen: false);
            service.likeToggle(idPublicacion, usuario['token']);
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(
                  yaDioLike ? Icons.favorite : Icons.favorite_border,
                  color: Colors.orange,
                  size: 22,
                ),
                const SizedBox(width: 6),
                Text(
                  "$likesCount Me gusta",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),

        // ===============================
        // BOTÓN DE COMENTARIOS
        // ===============================
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetallePublicacionScreen(
                  idPublicacion: idPublicacion,
                  usuario: usuario,
                ),
              ),
            );
          },
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                const Icon(
                  Icons.comment,
                  color: Colors.orange,
                  size: 22,
                ),
                const SizedBox(width: 6),
                Text(
                  "$comentariosCount Comentarios",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}