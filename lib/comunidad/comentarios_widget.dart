import 'package:flutter/material.dart';
import '../models/comentario_model.dart';
import '../services/comentarios_service.dart';  // El servicio para manejar comentarios

class ComentariosWidget extends StatefulWidget {
  final int publicacionId;

  const ComentariosWidget({Key? key, required this.publicacionId}) : super(key: key);

  @override
  _ComentariosWidgetState createState() => _ComentariosWidgetState();
}

class Comentario {
  final String usuario;  // Usuario que realiza el comentario
  final String contenido;  // Contenido del comentario

  Comentario({
    required this.usuario,
    required this.contenido,
  });

  // Método para crear un comentario desde JSON
  factory Comentario.fromJson(Map<String, dynamic> json) {
    return Comentario(
      usuario: json['usuario'] ?? 'Usuario anónimo',  // Valor predeterminado
      contenido: json['contenido'] ?? 'No hay contenido',  // Valor predeterminado
    );
  }
}

class _ComentariosWidgetState extends State<ComentariosWidget> {
  List<Comentario> comentarios = [];
  bool _isLoading = true;

  final TextEditingController _comentarioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cargarComentarios();
  }

  // Método para cargar comentarios desde el servicio
  Future<void> _cargarComentarios() async {
    try {
      final data = await ComentariosService.getComentarios(widget.publicacionId);
      setState(() {
        comentarios = List<Comentario>.from(data.map((comentarioData) {
        return Comentario.fromJson(comentarioData);
      }));
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Método para agregar un comentario
  void _agregarComentario() async {
    if (_comentarioController.text.isEmpty) return;

    try {
      await ComentariosService.agregarComentario(widget.publicacionId, _comentarioController.text);
      setState(() {
        comentarios.add(Comentario(usuario: 'Usuario', contenido: _comentarioController.text)); // Simula un comentario
      });
      _comentarioController.clear();
    } catch (e) {
      // Manejo de errores
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al agregar comentario')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                shrinkWrap: true,  // Esto permite que el ListView se ajuste a su contenido
                itemCount: comentarios.length,
                itemBuilder: (context, index) {
                  final comentario = comentarios[index];
                  return ListTile(
                    title: Text(comentario.usuario),
                    subtitle: Text(comentario.contenido),
                  );
                },
              ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _comentarioController,
                  decoration: const InputDecoration(
                    hintText: 'Escribe un comentario...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: _agregarComentario,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
