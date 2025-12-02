import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/comunidad_service.dart';
import '../screens/editar_publicacion.dart';
import '../screens/reportar_publicacion.dart';

class MenuOpcionesPost extends StatelessWidget {
  final int idPublicacion;
  final int idUsuarioPost;
  final Map<String, dynamic> usuario;
  final VoidCallback? onUpdate;

  const MenuOpcionesPost({
    Key? key,
    required this.idPublicacion,
    required this.idUsuarioPost,
    required this.usuario,
    this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ Verificar si es publicación propia
    final esPropia = idUsuarioPost == usuario['id'];

    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) async {
        if (value == 'editar') {
          await _editar(context);
        } else if (value == 'eliminar') {
          await _eliminar(context);
        } else if (value == 'reportar') {
          await _reportar(context);
        } else if (value == 'ocultar') {
          _ocultar(context);
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          // ✅ Reportar (solo si NO es propia)
          if (!esPropia)
            const PopupMenuItem<String>(
              value: 'reportar',
              child: Row(
                children: [
                  Icon(Icons.flag, size: 20, color: Colors.orange),
                  SizedBox(width: 10),
                  Text("Reportar"),
                ],
              ),
            ),

          // ✅ Ocultar (siempre disponible)
          const PopupMenuItem<String>(
            value: 'ocultar',
            child: Row(
              children: [
                Icon(Icons.visibility_off, size: 20, color: Colors.grey),
                SizedBox(width: 10),
                Text("Ocultar"),
              ],
            ),
          ),

          // ✅ Editar (solo si es propia)
          if (esPropia)
            const PopupMenuItem<String>(
              value: 'editar',
              child: Row(
                children: [
                  Icon(Icons.edit, size: 20, color: Colors.blue),
                  SizedBox(width: 10),
                  Text("Editar"),
                ],
              ),
            ),

          // ✅ Eliminar (solo si es propia)
          if (esPropia)
            const PopupMenuItem<String>(
              value: 'eliminar',
              child: Row(
                children: [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  SizedBox(width: 10),
                  Text("Eliminar"),
                ],
              ),
            ),
        ];
      },
    );
  }

  // ===============================
  // EDITAR PUBLICACIÓN
  // ===============================
  Future<void> _editar(BuildContext context) async {
    final editado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EditarPublicacionScreen(
          idPublicacion: idPublicacion,
          usuario: usuario,
        ),
      ),
    );

    if (editado == true && onUpdate != null) {
      onUpdate!();
    }
  }

  // ===============================
  // ELIMINAR PUBLICACIÓN
  // ===============================
  Future<void> _eliminar(BuildContext context) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar publicación?'),
        content: const Text(
          'Esta acción no se puede deshacer. Se eliminarán también todos los comentarios y reacciones.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    final service = Provider.of<ComunidadService>(context, listen: false);
    final success = await service.eliminarPublicacion(
      idPublicacion,
      usuario['token'],
    );

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? "Publicación eliminada correctamente"
                : "Error al eliminar publicación",
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );

      if (success && onUpdate != null) {
        onUpdate!();
      }
    }
  }

  // ===============================
  // REPORTAR PUBLICACIÓN
  // ===============================
  Future<void> _reportar(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ReportarPublicacionScreen(
          idPublicacion: idPublicacion,
          usuario: usuario,
        ),
      ),
    );
  }

  // ===============================
  // OCULTAR PUBLICACIÓN (local)
  // ===============================
  void _ocultar(BuildContext context) {
    final service = Provider.of<ComunidadService>(context, listen: false);
    service.ocultarPublicacion(idPublicacion);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Publicación ocultada"),
        duration: Duration(seconds: 2),
      ),
    );
  }
}