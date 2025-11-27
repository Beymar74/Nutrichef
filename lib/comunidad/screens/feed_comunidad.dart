import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/comunidad_service.dart';
import '../widgets/barra_reacciones.dart';
import 'detalle_publicacion.dart';
import 'nueva_publicacion.dart';

class FeedComunidadScreen extends StatefulWidget {
  final Map<String, dynamic> usuario;

  const FeedComunidadScreen({Key? key, required this.usuario})
    : super(key: key);

  @override
  _FeedComunidadScreenState createState() => _FeedComunidadScreenState();
}

class _FeedComunidadScreenState extends State<FeedComunidadScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final comunidadService = Provider.of<ComunidadService>(
        context,
        listen: false,
      );
      final token = widget.usuario['token'] ?? '';

      if (comunidadService.posts.isEmpty && !comunidadService.loading) {
        comunidadService.cargarFeed(token);
      }
    });
  }

  Future<void> _refrescarFeed() async {
    final comunidadService = Provider.of<ComunidadService>(
      context,
      listen: false,
    );
    final token = widget.usuario['token'] ?? '';
    await comunidadService.cargarFeed(token);
  }

  void _mostrarMenuOpciones(int idPublicacion, int idUsuarioPost) {
    final token = widget.usuario['token'] ?? '';
    final esPropia = widget.usuario['id'] == idUsuarioPost;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (esPropia) ...[
                ListTile(
                  leading: const Icon(Icons.edit, color: Color(0xFFFF8C21)),
                  title: const Text('Editar publicación'),
                  onTap: () {
                    Navigator.pop(context);
                    _editarPublicacion(idPublicacion);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete, color: Colors.red),
                  title: const Text('Eliminar publicación'),
                  onTap: () {
                    Navigator.pop(context);
                    _confirmarEliminar(idPublicacion);
                  },
                ),
              ],
              ListTile(
                leading: const Icon(Icons.visibility_off, color: Colors.grey),
                title: const Text('Ocultar publicación'),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Publicación ocultada')),
                  );
                },
              ),
              if (!esPropia)
                ListTile(
                  leading: const Icon(Icons.flag, color: Colors.orange),
                  title: const Text('Reportar publicación'),
                  onTap: () {
                    Navigator.pop(context);
                    _reportarPublicacion(idPublicacion);
                  },
                ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  void _confirmarEliminar(int idPublicacion) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar publicación'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar esta publicación?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _eliminarPublicacion(idPublicacion);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _eliminarPublicacion(int idPublicacion) async {
    final comunidadService = Provider.of<ComunidadService>(
      context,
      listen: false,
    );
    final token = widget.usuario['token'] ?? '';

    final response = await comunidadService.eliminarPublicacion(
      idPublicacion,
      token,
    );

    if (mounted) {
      if (response['success'] == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Publicación eliminada")));
        comunidadService.cargarFeed(token);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? "Error al eliminar")),
        );
      }
    }
  }

  void _editarPublicacion(int idPublicacion) {
    // TODO: Implementar navegación a pantalla de edición
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Función de editar en desarrollo')),
    );
  }

  void _reportarPublicacion(int idPublicacion) async {
    final comunidadService = Provider.of<ComunidadService>(
      context,
      listen: false,
    );
    final token = widget.usuario['token'] ?? '';

    final response = await comunidadService.reportarPublicacion(
      idPublicacion,
      token,
    );

    if (mounted) {
      if (response['success'] == true) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Publicación reportada")));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? "Error al reportar")),
        );
      }
    }
  }

  String _formatearFecha(String? fecha) {
    if (fecha == null) return 'Fecha desconocida';

    try {
      final dateTime = DateTime.parse(fecha);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inDays > 0) {
        return 'hace ${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
      } else if (difference.inHours > 0) {
        return 'hace ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
      } else if (difference.inMinutes > 0) {
        return 'hace ${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
      } else {
        return 'hace un momento';
      }
    } catch (e) {
      return 'Fecha desconocida';
    }
  }

  @override
  Widget build(BuildContext context) {
    final comunidadService = Provider.of<ComunidadService>(context);
    final token = widget.usuario['token'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Comunidad'),
        backgroundColor: const Color(0xFFFF8C21),
        elevation: 1,
      ),
      body: comunidadService.loading
          ? const Center(child: CircularProgressIndicator())
          : comunidadService.posts.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.forum_outlined, size: 64, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'No hay publicaciones disponibles',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: _refrescarFeed,
                    icon: const Icon(Icons.refresh),
                    label: const Text('Recargar'),
                  ),
                ],
              ),
            )
          : RefreshIndicator(
              onRefresh: _refrescarFeed,
              color: const Color(0xFFFF8C21),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: comunidadService.posts.length,
                itemBuilder: (context, index) {
                  final post = comunidadService.posts[index];

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => DetallePublicacionScreen(
                            idPublicacion: post['id'],
                            usuario: widget.usuario,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 8,
                      ),
                      elevation: 1,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header: Usuario + Fecha + Menú
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                // Avatar
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: const Color(0xFFFF8C21),
                                  child: Text(
                                    widget.usuario['name']?[0].toUpperCase() ??
                                        'U',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),

                                // Nombre y fecha
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        widget.usuario['name'] ?? 'Usuario',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        _formatearFecha(post['created_at']),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // Menú de opciones
                                IconButton(
                                  icon: const Icon(Icons.more_horiz),
                                  onPressed: () {
                                    _mostrarMenuOpciones(
                                      post['id'],
                                      post['id_usuario'] ?? 0,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                          // Contenido de la publicación
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            child: Text(
                              post['descripcion'] ?? 'Sin descripción',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Contadores (likes y comentarios)
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12.0,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.thumb_up,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '0',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Icon(
                                  Icons.comment,
                                  size: 16,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '0 comentarios',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),

                          const Divider(height: 1),

                          // Barra de reacciones
                          BarraReacciones(
                            idPublicacion: post['id'],
                            token: token,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
      // Botón flotante para crear nueva publicación
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final resultado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NuevaPublicacionScreen(usuario: widget.usuario),
            ),
          );

          // Si se creó una publicación, recargar el feed
          if (resultado == true) {
            _refrescarFeed();
          }
        },
        backgroundColor: const Color(0xFFFF8C21),
        child: const Icon(Icons.add),
      ),
    );
  }
}
