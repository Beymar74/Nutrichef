import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/comunidad_service.dart';

class NuevaPublicacionScreen extends StatefulWidget {
  final Map<String, dynamic> usuario;

  const NuevaPublicacionScreen({Key? key, required this.usuario}) : super(key: key);

  @override
  _NuevaPublicacionScreenState createState() => _NuevaPublicacionScreenState();
}

class _NuevaPublicacionScreenState extends State<NuevaPublicacionScreen> {
  final TextEditingController _contenidoController = TextEditingController();
  bool _creando = false;

  Future<void> _crearPublicacion() async {
    if (_contenidoController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escribe algo antes de publicar')),
      );
      return;
    }

    setState(() => _creando = true);

    final comunidadService = Provider.of<ComunidadService>(context, listen: false);
    final token = widget.usuario['token'] ?? '';

    final response = await comunidadService.crearPublicacion(
      '', // titulo (no lo usamos, solo descripcion)
      _contenidoController.text.trim(),
      token,
    );

    setState(() => _creando = false);

    if (mounted) {
      if (response['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Publicación creada exitosamente')),
        );
        Navigator.pop(context, true); // Retornar true para recargar el feed
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Error al crear publicación')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear publicación'),
        backgroundColor: const Color(0xFFFF8C21),
        actions: [
          if (_creando)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 16.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          else
            TextButton(
              onPressed: _crearPublicacion,
              child: const Text(
                'PUBLICAR',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Header con usuario
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  backgroundColor: const Color(0xFFFF8C21),
                  child: Text(
                    widget.usuario['name']?[0].toUpperCase() ?? 'U',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.usuario['name'] ?? 'Usuario',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.public, size: 14, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          'Público',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // Área de texto
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _contenidoController,
                maxLines: null,
                expands: true,
                autofocus: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: '¿Qué estás pensando?',
                  border: InputBorder.none,
                  hintStyle: TextStyle(fontSize: 18, color: Colors.grey),
                ),
                style: const TextStyle(fontSize: 16),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
          ),

          // Nota de ayuda
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              border: Border(
                top: BorderSide(color: Colors.grey[300]!),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Usa el teclado para agregar emojis 😊',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[600],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _contenidoController.dispose();
    super.dispose();
  }
}