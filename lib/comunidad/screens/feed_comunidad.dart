import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/comunidad_service.dart';
import 'detalle_publicacion.dart';
import 'nueva_publicacion.dart';

class FeedComunidadScreen extends StatefulWidget {
  final Map<String, dynamic> usuario;

  const FeedComunidadScreen({Key? key, required this.usuario}) : super(key: key);

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

  // ======================
  // FORMATEAR FECHA
  // ======================
  String formatearFecha(String fecha) {
    final date = DateTime.parse(fecha);
    final diff = DateTime.now().difference(date);

    if (diff.inDays > 0) return "hace ${diff.inDays} día(s)";
    if (diff.inHours > 0) return "hace ${diff.inHours} hora(s)";
    if (diff.inMinutes > 0) return "hace ${diff.inMinutes} minuto(s)";
    return "hace un momento";
  }

  // ======================
  // TARJETA DE PUBLICACIÓN
  // ======================
  Widget _cardPublicacion(dynamic post) {
    final esPropia = post['usuario']['id'] == widget.usuario['id'];

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      elevation: 2,
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
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        post['usuario']['username'],
                        style:
                            TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),

                // Menú opciones
                PopupMenuButton(
                  onSelected: (value) {
                    if (value == "reportar") {
                      _reportar(post['id']);
                    }
                    if (value == "eliminar") {
                      _eliminar(post['id']);
                    }
                    if (value == "ocultar") {
                      Provider.of<ComunidadService>(context, listen: false)
                          .ocultarPublicacion(post['id']);
                    }
                  },
                  itemBuilder: (context) => [
                    if (!esPropia)
                      const PopupMenuItem(
                        value: "reportar",
                        child: Text("Reportar"),
                      ),
                    const PopupMenuItem(
                      value: "ocultar",
                      child: Text("Ocultar"),
                    ),
                    if (esPropia)
                      const PopupMenuItem(
                        value: "eliminar",
                        child: Text("Eliminar"),
                      ),
                  ],
                )
              ],
            ),

            const SizedBox(height: 10),

            // DESCRIPCIÓN
            Text(post['descripcion'], style: const TextStyle(fontSize: 15)),
            const SizedBox(height: 10),

            // IMÁGENES (máx 3)
            if (post['imagenes'].isNotEmpty)
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

            const Divider(),

            // REACCIONES
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // LIKE
                InkWell(
                  onTap: () =>
                      Provider.of<ComunidadService>(context, listen: false)
                          .likeToggle(post['id'], widget.usuario['token']),
                  child: Row(
                    children: [
                      Icon(
                        post['ya_dio_like'] == true
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 6),
                      Text("${post['likes_count']} Me gusta"),
                    ],
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
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.comment, color: Colors.orange),
                      const SizedBox(width: 6),
                      Text("${post['comentarios_count']} Comentarios"),
                    ],
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ======================
  // ELIMINAR
  // ======================
  void _eliminar(int id) async {
    final service = Provider.of<ComunidadService>(context, listen: false);
    await service.eliminarPublicacion(id, widget.usuario['token']);
    _refresh();
  }

  // ======================
  // REPORTAR
  // ======================
  void _reportar(int id) async {
    final service = Provider.of<ComunidadService>(context, listen: false);
    await service.reportarPublicacion(id, widget.usuario['token']);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Publicación reportada")),
    );
  }

  // ======================
  // BUILD
  // ======================
  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ComunidadService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Comunidad"),
        backgroundColor: Colors.orange,
      ),

      body: service.loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                children: service.posts.map((p) => _cardPublicacion(p)).toList(),
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
}
