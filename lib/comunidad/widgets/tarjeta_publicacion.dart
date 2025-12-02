import 'package:flutter/material.dart';
import 'barra_reacciones.dart';
import 'menu_opciones_post.dart';

class TarjetaPublicacion extends StatelessWidget {
  final Map<String, dynamic> publicacion;

  const TarjetaPublicacion({Key? key, required this.publicacion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Cabecera de la publicación
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.orange,
                  child: Text(publicacion['usuario']['name'][0].toUpperCase(), style: const TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(publicacion['usuario']['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      Text(publicacion['created_at'], style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    ],
                  ),
                ),
                MenuOpcionesPost(idPublicacion: publicacion['id'], idUsuarioPost: publicacion['usuario']['id']),
              ],
            ),
          ),

          // Descripción de la publicación
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Text(publicacion['descripcion'], style: const TextStyle(fontSize: 15)),
          ),
          const SizedBox(height: 8),

          // Barra de reacciones
          BarraReacciones(idPublicacion: publicacion['id'], token: 'user_token'), // Referenciado directamente

          // Mostrar imágenes si hay
          if (publicacion['imagenes'] != null && publicacion['imagenes'].isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(publicacion['imagenes'][0]), // Asegúrate de que 'imagenes' sea una lista
            ),
        ],
      ),
    );
  }
}
