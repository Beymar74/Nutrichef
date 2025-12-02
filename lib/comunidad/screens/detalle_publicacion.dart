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

    await Provider.of<ComunidadService>(context, listen: false)
        .agregarComentario(
      widget.idPublicacion,
      _comentarioCtrl.text.trim(),
      widget.usuario['token'],
    );

    _comentarioCtrl.clear();
    FocusScope.of(context).unfocus();

    setState(() => enviando = false);
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
                  ...comentarios.map((c) => _cardComentario(c)).toList()
              ],
            ),
          ),

          _inputComentario(),
        ],
      ),
    );
  }

  // ===============================
  // APPBAR
  // ===============================
  AppBar _appbar() {
    return AppBar(
      title: const Text("Publicación"),
      backgroundColor: Colors.orange,
    );
  }

  // ===============================
  // CARD DE PUBLICACIÓN
  // ===============================
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      p["usuario"]["name"],
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    Text(
                      p["usuario"]["username"],
                      style: TextStyle(color: Colors.grey[600]),
                    )
                  ],
                )
              ],
            ),

            const SizedBox(height: 12),

            Text(
              p["descripcion"],
              style: const TextStyle(fontSize: 15),
            ),

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
                  onTap: () =>
                      Provider.of<ComunidadService>(context, listen: false)
                          .likeToggle(
                    p['id'],
                    widget.usuario['token'],
                  ),
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

  // ===============================
  // CARD DE COMENTARIO
  // ===============================
  Widget _cardComentario(dynamic c) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.orange[200],
            child: const Icon(Icons.person),
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
                  Text(
                    c["usuario"]["name"],
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
          )
        ],
      ),
    );
  }

  // ===============================
  // INPUT DE COMENTARIO
  // ===============================
  Widget _inputComentario() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, -2))
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
                decoration: InputDecoration(
                  hintText: "Escribe un comentario...",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                ),
              ),
            ),
            const SizedBox(width: 10),
            enviando
                ? const SizedBox(
                    width: 25,
                    height: 25,
                    child:
                        CircularProgressIndicator(strokeWidth: 2),
                  )
                : IconButton(
                    icon: const Icon(Icons.send, color: Colors.orange),
                    onPressed: enviarComentario,
                  )
          ],
        ),
      ),
    );
  }
}
