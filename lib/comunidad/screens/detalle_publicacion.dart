import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/comunidad_service.dart';
import '../widgets/barra_reacciones.dart';

class DetallePublicacionScreen extends StatefulWidget {
  final int idPublicacion;
  final Map<String, dynamic> usuario;

  const DetallePublicacionScreen({
    Key? key,
    required this.idPublicacion,
    required this.usuario,
  }) : super(key: key);

  @override
  _DetallePublicacionScreenState createState() => _DetallePublicacionScreenState();
}

class _DetallePublicacionScreenState extends State<DetallePublicacionScreen> {
  final TextEditingController _comentarioController = TextEditingController();
  bool _enviandoComentario = false;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final comunidadService = Provider.of<ComunidadService>(context, listen: false);
    final token = widget.usuario['token'] ?? '';
    
    await comunidadService.obtenerPublicacionPorId(widget.idPublicacion, token);
    await comunidadService.obtenerComentarios(widget.idPublicacion, token);
  }

  Future<void> _agregarComentario() async {
    if (_comentarioController.text.trim().isEmpty) return;

    setState(() => _enviandoComentario = true);

    final comunidadService = Provider.of<ComunidadService>(context, listen: false);
    final token = widget.usuario['token'] ?? '';

    final response = await comunidadService.agregarComentario(
      widget.idPublicacion,
      _comentarioController.text.trim(),
      token,
    );

    setState(() => _enviandoComentario = false);

    if (response['success'] == true) {
      _comentarioController.clear();
      FocusScope.of(context).unfocus();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Comentario agregado')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Error al comentar')),
      );
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

    if (comunidadService.loading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Publicación'),
          backgroundColor: const Color(0xFFFF8C21),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (comunidadService.posts.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Publicación'),
          backgroundColor: const Color(0xFFFF8C21),
        ),
        body: const Center(child: Text('Publicación no encontrada')),
      );
    }

    final post = comunidadService.posts.first;
    final comentarios = comunidadService.comentarios;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Publicación'),
        backgroundColor: const Color(0xFFFF8C21),
      ),
      body: Column(
        children: [
          // Contenido scrolleable
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Card de la publicación
                  Card(
                    margin: const EdgeInsets.all(8),
                    elevation: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header: Usuario + Fecha
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: const Color(0xFFFF8C21),
                                child: const Text(
                                  'U',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Usuario',
                                      style: TextStyle(
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
                            ],
                          ),
                        ),

                        // Contenido
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: Text(
                            post['descripcion'] ?? 'Sin descripción',
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                        const SizedBox(height: 12),

                        const Divider(height: 1),

                        // Barra de reacciones
                        BarraReacciones(
                          idPublicacion: post['id'],
                          token: token,
                        ),
                      ],
                    ),
                  ),

                  // Sección de comentarios
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Comentarios (${comentarios.length})',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Lista de comentarios
                  if (comentarios.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          'No hay comentarios aún.\n¡Sé el primero en comentar!',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: comentarios.length,
                      itemBuilder: (context, index) {
                        final comentario = comentarios[index];
                        return _buildComentario(comentario);
                      },
                    ),
                ],
              ),
            ),
          ),

          // Input de comentario (fijo en la parte inferior)
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(8.0),
            child: SafeArea(
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: const Color(0xFFFF8C21),
                    child: Text(
                      widget.usuario['name']?[0].toUpperCase() ?? 'U',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _comentarioController,
                      decoration: InputDecoration(
                        hintText: 'Escribe un comentario...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                      ),
                      maxLines: null,
                      textCapitalization: TextCapitalization.sentences,
                    ),
                  ),
                  const SizedBox(width: 8),
                  _enviandoComentario
                      ? const SizedBox(
                          width: 40,
                          height: 40,
                          child: Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(
                            Icons.send,
                            color: Color(0xFFFF8C21),
                          ),
                          onPressed: _agregarComentario,
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComentario(Map<String, dynamic> comentario) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFFFFD54F),
            child: const Text(
              'U',
              style: TextStyle(color: Colors.black87, fontSize: 12),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Usuario',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    comentario['contenido'] ?? '',
                    style: const TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatearFecha(comentario['created_at']),
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _comentarioController.dispose();
    super.dispose();
  }
}