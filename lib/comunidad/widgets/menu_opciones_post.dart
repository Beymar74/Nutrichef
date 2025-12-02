import 'package:flutter/material.dart';

class MenuOpcionesPost extends StatelessWidget {
  final int idPublicacion;
  final int idUsuarioPost;

  const MenuOpcionesPost({Key? key, required this.idPublicacion, required this.idUsuarioPost}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        // Acción basada en la opción seleccionada
        if (value == 'editar') {
          // Aquí puedes navegar a una pantalla de edición (si la tienes)
          // Por ejemplo:
          // Navigator.push(context, MaterialPageRoute(builder: (_) => EditarPublicacionScreen(idPublicacion: idPublicacion)));
        } else if (value == 'eliminar') {
          // Llamar a la lógica de eliminación
          _confirmarEliminar(context);
        } else if (value == 'reportar') {
          // Aquí puedes navegar a la pantalla de reporte de publicación
          // Por ejemplo:
          // Navigator.push(context, MaterialPageRoute(builder: (_) => ReportarPublicacionScreen(idPublicacion: idPublicacion)));
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          const PopupMenuItem<String>(
            value: 'editar',
            child: Text("Editar publicación"),
          ),
          const PopupMenuItem<String>(
            value: 'eliminar',
            child: Text("Eliminar publicación"),
          ),
          const PopupMenuItem<String>(
            value: 'reportar',
            child: Text("Reportar publicación"),
          ),
        ];
      },
    );
  }

  void _confirmarEliminar(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar publicación'),
        content: const Text('¿Estás seguro de que deseas eliminar esta publicación?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cierra el diálogo
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Cierra el diálogo
              // Llamar a la lógica para eliminar la publicación
              // Eliminar la publicación desde el servicio o backend
              // comunidadService.eliminarPublicacion(idPublicacion);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
