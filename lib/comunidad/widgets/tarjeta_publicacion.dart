import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/comunidad_service.dart';
import 'barra_reacciones.dart'; // Ya tenemos el widget BarraReacciones

class TarjetaPublicacion extends StatelessWidget {
  final int idPublicacion;

  const TarjetaPublicacion({Key? key, required this.idPublicacion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final comunidadService = Provider.of<ComunidadService>(context);

    // Método para obtener la publicación
    final post = comunidadService.posts.firstWhere((post) => post['id'] == idPublicacion);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(post['titulo']),
            subtitle: Text(post['contenido']),
          ),
          BarraReacciones(idPublicacion: idPublicacion),
        ],
      ),
    );
  }
}
