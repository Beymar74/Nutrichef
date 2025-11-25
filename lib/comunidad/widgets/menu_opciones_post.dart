import 'package:flutter/material.dart';

class MenuOpcionesPost extends StatelessWidget {
  final int idPublicacion;

  const MenuOpcionesPost({Key? key, required this.idPublicacion}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert), // Icono de tres puntos
      onSelected: (value) {
        switch (value) {
          case 'editar':
            // Navegar a la pantalla de editar
            Navigator.pushNamed(context, '/editar_publicacion', arguments: idPublicacion);
            break;
          case 'eliminar':
            // Llamar a la función para eliminar la publicación
            print('Eliminar publicación');
            break;
          case 'reportar':
            // Llamar a la función para reportar la publicación
            print('Reportar publicación');
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'editar',
            child: Row(
              children: [
                Icon(Icons.edit),
                SizedBox(width: 8),
                Text('Editar'),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'eliminar',
            child: Row(
              children: [
                Icon(Icons.delete),
                SizedBox(width: 8),
                Text('Eliminar'),
              ],
            ),
          ),
          const PopupMenuItem<String>(
            value: 'reportar',
            child: Row(
              children: [
                Icon(Icons.report),
                SizedBox(width: 8),
                Text('Reportar'),
              ],
            ),
          ),
        ];
      },
    );
  }
}