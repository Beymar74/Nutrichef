import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/comunidad_service.dart';

class DetallePublicacionScreen extends StatefulWidget {
  final int idPublicacion;
  final Map<String, dynamic> usuario;

  const DetallePublicacionScreen({
    Key? key,
    required this.idPublicacion,
    required this.usuario,
  }) : super(key: key);

  @override
  State<DetallePublicacionScreen> createState() =>
      _DetallePublicacionScreenState();
}

class _DetallePublicacionScreenState extends State<DetallePublicacionScreen> {
  final TextEditingController _comentarioCtrl = TextEditingController();
  bool enviando = false;
  Map<String, dynamic>? post;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  @override
  void dispose() {
    _comentarioCtrl.dispose();
    // ✅ Limpiar comentarios al salir
    Provider.of<ComunidadService>(context, listen: false).limpiarComentarios();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    final service = Provider.of<ComunidadService>(context, listen: false);
    final token = widget.usuario['token'];

    final data = await service.obtenerPublicacionPorId(
      widget.idPublicacion,
      token,
    );

    if (mounted) {
      setState(() => post = data);
    }

    await service.obtenerComentarios(widget.idPublicacion, token);
  }

  String formatFecha(String fecha) {
    final date = DateTime.parse(fecha);
    final diff = DateTime.now().difference(date);

    if (diff.inDays > 0) return "hace ${diff.inDays} día(s)";
    if (diff.inHours > 0) return "hace ${diff.inHours} hora(s)";
    if (diff.inMinutes > 0) return "hace ${diff.inMinutes} minuto(s)";
    return "hace un momento";
  }

  Future<void> enviarComentario() async {
    if (_comentarioCtrl.text.trim().isEmpty) return;

    setState(() => enviando = true);

    final success = await Provider.of<ComunidadService>(context, listen: false)
        .agregarComentario(
          widget.idPublicacion,
          _comentarioCtrl.text.trim(),
          widget.usuario['token'],
        );

    if (success) {
      _comentarioCtrl.clear();
      FocusScope.of(context).unfocus();

      // ✅ Actualizar contador en la publicación
      if (post != null) {
        setState(() {
          post!['comentarios_count'] = (post!['comentarios_count'] ?? 0) + 1;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al agregar comentario")),
      );
    }

    setState(() => enviando = false);
  }

  // ✅ ELIMINAR COMENTARIO
  Future<void> _eliminarComentario(int idComentario) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("¿Eliminar comentario?"),
        content: const Text("Esta acción no se puede deshacer"),
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
    final success = await service.eliminarComentario(
      idComentario,
      widget.idPublicacion,
      widget.usuario['token'],
    );

    if (success && mounted) {
      // ✅ Actualizar contador local
      setState(() {
        post!['comentarios_count'] = (post!['comentarios_count'] ?? 0) - 1;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Comentario eliminado")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final service = Provider.of<ComunidadService>(context);
    final comentarios = service.comentarios;

    if (post == null) {
      return Scaffold(
        appBar: _appbar(),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: _appbar(),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: _cargarDatos,
              child: ListView(
                padding: const EdgeInsets.all(10),
                children: [
                  _cardPublicacion(post!),
                  const SizedBox(height: 10),

                  Text(
                    "Comentarios (${comentarios.length})",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 10),

                  if (comentarios.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          "No hay comentarios.\n¡Sé el primero!",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ...comentarios.map((c) => _cardComentario(c)).toList(),
                ],
              ),
            ),
          ),

          _inputComentario(),
        ],
      ),
    );
  }

  AppBar _appbar() {
    return AppBar(
      title: const Text("Publicación"),
      backgroundColor: Colors.orange,
    );
  }

  Widget _cardPublicacion(Map<String, dynamic> p) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Usuario + avatar
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundImage: p["usuario"]["avatar"] != null
                      ? NetworkImage(p["usuario"]["avatar"])
                      : null,
                  child: p["usuario"]["avatar"] == null
                      ? const Icon(Icons.person)
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p["usuario"]["name"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        p["usuario"]["username"],
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            Text(p["descripcion"], style: const TextStyle(fontSize: 15)),

            const SizedBox(height: 12),

            // IMÁGENES
            if (p["imagenes"] != null && p["imagenes"].isNotEmpty)
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: p["imagenes"].length,
                  itemBuilder: (_, i) => Container(
                    width: 200,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(p["imagenes"][i]),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 10),

            Text(
              formatFecha(p['created_at']),
              style: TextStyle(color: Colors.grey[600], fontSize: 12),
            ),

            const Divider(),

            // LIKE - COMENTAR
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () async {
                    await Provider.of<ComunidadService>(
                      context,
                      listen: false,
                    ).likeToggle(p['id'], widget.usuario['token']);
                    // ✅ Actualizar estado local
                    setState(() {
                      final yaDioLike = p['ya_dio_like'] ?? false;
                      p['ya_dio_like'] = !yaDioLike;
                      p['likes_count'] =
                          (p['likes_count'] ?? 0) + (yaDioLike ? -1 : 1);
                    });
                  },
                  child: Row(
                    children: [
                      Icon(
                        p['ya_dio_like'] == true
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: Colors.orange,
                      ),
                      const SizedBox(width: 5),
                      Text("${p['likes_count']} Me gusta"),
                    ],
                  ),
                ),
                Row(
                  children: [
                    const Icon(Icons.comment, color: Colors.orange),
                    const SizedBox(width: 5),
                    Text("${p['comentarios_count']} Comentarios"),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _cardComentario(dynamic c) {
    final esPropio = c["usuario"]["id"] == widget.usuario["id"];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundImage: c["usuario"]["avatar"] != null
                ? NetworkImage(c["usuario"]["avatar"])
                : null,
            child: c["usuario"]["avatar"] == null
                ? const Icon(Icons.person, size: 18)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          c["usuario"]["name"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      // ✅ Botón eliminar (solo si es propio)
                      if (esPropio)
                        InkWell(
                          onTap: () => _eliminarComentario(c["id"]),
                          child: Icon(
                            Icons.delete_outline,
                            size: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(c["contenido"]),
                  const SizedBox(height: 4),
                  Text(
                    formatFecha(c["created_at"]),
                    style: TextStyle(color: Colors.grey[600], fontSize: 11),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _inputComentario() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.orange,
              child: Text(
                widget.usuario['name'][0].toUpperCase(),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: _comentarioCtrl,
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  hintText: "Escribe un comentario...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            enviando
                ? const SizedBox(
                    width: 25,
                    height: 25,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : IconButton(
                    icon: const Icon(Icons.send, color: Colors.orange),
                    onPressed: enviarComentario,
                  ),
          ],
        ),
      ),
    );
  }
}
