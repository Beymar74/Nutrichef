import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/comunidad_service.dart';
import 'detalle_publicacion.dart';
import 'nueva_publicacion.dart';
import 'editar_publicacion.dart';
import 'reportar_publicacion.dart';


class FeedComunidadScreen extends StatefulWidget {
  final Map<String, dynamic> usuario;

  const FeedComunidadScreen({Key? key, required this.usuario})
    : super(key: key);

  @override
  State<FeedComunidadScreen> createState() => _FeedComunidadScreenState();
}

class _FeedComunidadScreenState extends State<FeedComunidadScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final service = Provider.of<ComunidadService>(context, listen: false);
      service.cargarFeed(widget.usuario['token']);
    });
  }

  Future<void> _refresh() async {
    final service = Provider.of<ComunidadService>(context, listen: false);
    await service.cargarFeed(widget.usuario['token']);
  }

  String formatearFecha(String fecha) {
    final date = DateTime.parse(fecha);
    final diff = DateTime.now().difference(date);

    if (diff.inDays > 0) return "hace ${diff.inDays} día(s)";
    if (diff.inHours > 0) return "hace ${diff.inHours} hora(s)";
    if (diff.inMinutes > 0) return "hace ${diff.inMinutes} minuto(s)";
    return "hace un momento";
  }

  Widget _TarjetaPublicacion(dynamic post) {
    final esPropia = post['usuario']['id'] == widget.usuario['id'];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 2,
      child: InkWell(
        // ✅ Hacer toda la tarjeta clickeable para ir al detalle
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetallePublicacionScreen(
              idPublicacion: post['id'],
              usuario: widget.usuario,
            ),
          ),
        ).then((_) => _refresh()), // ✅ Refrescar al volver
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER: avatar + nombre + menú
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: post['usuario']['avatar'] != null
                        ? NetworkImage(post['usuario']['avatar'])
                        : null,
                    child: post['usuario']['avatar'] == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  const SizedBox(width: 12),

                  // Nombre y username
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post['usuario']['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          post['usuario']['username'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Menú opciones
                  PopupMenuButton(
                    onSelected: (value) async {
                      if (value == "reportar") {
                        // ✅ Navegar a pantalla de reporte
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ReportarPublicacionScreen(
                              idPublicacion: post['id'],
                              usuario: widget.usuario,
                            ),
                          ),
                        );
                      }
                      if (value == "editar") {
                        // ✅ Navegar a pantalla de editar
                        final editado = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditarPublicacionScreen(
                              idPublicacion: post['id'],
                              usuario: widget.usuario,
                            ),
                          ),
                        );
                        if (editado == true) _refresh();
                      }
                      if (value == "eliminar") {
                        await _eliminar(post['id']);
                      }
                      if (value == "ocultar") {
                        Provider.of<ComunidadService>(
                          context,
                          listen: false,
                        ).ocultarPublicacion(post['id']);
                      }
                    },
                    itemBuilder: (context) => [
                      if (!esPropia)
                        const PopupMenuItem(
                          value: "reportar",
                          child: Row(
                            children: [
                              Icon(Icons.flag, size: 20, color: Colors.orange),
                              SizedBox(width: 10),
                              Text("Reportar"),
                            ],
                          ),
                        ),
                      const PopupMenuItem(
                        value: "ocultar",
                        child: Row(
                          children: [
                            Icon(
                              Icons.visibility_off,
                              size: 20,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 10),
                            Text("Ocultar"),
                          ],
                        ),
                      ),
                      // ✅ EDITAR (solo si es propia)
                      if (esPropia)
                        const PopupMenuItem(
                          value: "editar",
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 20, color: Colors.blue),
                              SizedBox(width: 10),
                              Text("Editar"),
                            ],
                          ),
                        ),
                      if (esPropia)
                        const PopupMenuItem(
                          value: "eliminar",
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 20, color: Colors.red),
                              SizedBox(width: 10),
                              Text("Eliminar"),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // DESCRIPCIÓN
              Text(
                post['descripcion'],
                style: const TextStyle(fontSize: 15),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 10),

              // IMÁGENES (máx 3)
              if (post['imagenes'] != null && post['imagenes'].isNotEmpty)
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: post['imagenes'].length,
                    itemBuilder: (context, index) => Container(
                      margin: const EdgeInsets.only(right: 10),
                      width: 160,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(post['imagenes'][index]),
                        ),
                      ),
                    ),
                  ),
                ),

              const SizedBox(height: 10),

              // FECHA
              Text(
                formatearFecha(post['created_at']),
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),

              const Divider(height: 20),

              // REACCIONES
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // LIKE
                  InkWell(
                    onTap: () {
                      // ✅ Evitar propagación del tap al card
                      Provider.of<ComunidadService>(
                        context,
                        listen: false,
                      ).likeToggle(post['id'], widget.usuario['token']);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            post['ya_dio_like'] == true
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: Colors.orange,
                            size: 22,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "${post['likes_count']} Me gusta",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // COMENTAR
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DetallePublicacionScreen(
                          idPublicacion: post['id'],
                          usuario: widget.usuario,
                        ),
                      ),
                    ).then((_) => _refresh()), // ✅ Refrescar al volver
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.comment,
                            color: Colors.orange,
                            size: 22,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "${post['comentarios_count']} Comentarios",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ ELIMINAR CON CONFIRMACIÓN
  Future<void> _eliminar(int id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¿Eliminar publicación?"),
        content: const Text(
          "Esta acción no se puede deshacer. Se eliminarán también todos los comentarios y reacciones.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    final service = Provider.of<ComunidadService>(context, listen: false);
    final success = await service.eliminarPublicacion(
      id,
      widget.usuario['token'],
    );

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Publicación eliminada correctamente"),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Error al eliminar publicación"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // ✅ REPORTAR CON CONFIRMACIÓN
  Future<void> _reportar(int id) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¿Reportar publicación?"),
        content: const Text(
          "El contenido será revisado por nuestro equipo de moderación.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.orange),
            child: const Text("Reportar"),
          ),
        ],
      ),
    );

    if (confirmar != true) return;

    final service = Provider.of<ComunidadService>(context, listen: false);
    final success = await service.reportarPublicacion(
      id,
      widget.usuario['token'],
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? "Publicación reportada correctamente"
                : "Error al reportar publicación",
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ComunidadService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Comunidad"),
        backgroundColor: Colors.orange,
        // ✅ Agregar acción para refrescar manualmente
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refresh),
        ],
      ),

      body: service.loading
          ? const Center(child: CircularProgressIndicator())
          : service.posts.isEmpty
          ? _emptyState()
          : RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                itemCount: service.posts.length,
                itemBuilder: (context, index) {
                  return _TarjetaPublicacion(service.posts[index]);
                },
              ),
            ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
        onPressed: () async {
          final creado = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => NuevaPublicacionScreen(usuario: widget.usuario),
            ),
          );
          if (creado == true) _refresh();
        },
      ),
    );
  }

  // ✅ Estado vacío cuando no hay publicaciones
  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.forum_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 20),
          Text(
            "No hay publicaciones",
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "¡Sé el primero en compartir algo!",
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () async {
              final creado = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      NuevaPublicacionScreen(usuario: widget.usuario),
                ),
              );
              if (creado == true) _refresh();
            },
            icon: const Icon(Icons.add),
            label: const Text("Crear publicación"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
