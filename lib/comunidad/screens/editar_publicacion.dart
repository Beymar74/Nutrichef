import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/comunidad_service.dart';

class EditarPublicacionScreen extends StatefulWidget {
  final Map<String, dynamic> usuario;
  final int idPublicacion;

  const EditarPublicacionScreen({
    Key? key,
    required this.usuario,
    required this.idPublicacion,
  }) : super(key: key);

  @override
  _EditarPublicacionScreenState createState() => _EditarPublicacionScreenState();
}

class _EditarPublicacionScreenState extends State<EditarPublicacionScreen> {
  final TextEditingController _descripcionCtrl = TextEditingController();
  final List<File> _imagenes = [];
  bool _enviando = false;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  Future<void> _cargarDatos() async {
    final comunidadService = Provider.of<ComunidadService>(context, listen: false);
    final token = widget.usuario['token'];

    final publicacion =
        await comunidadService.obtenerPublicacionPorId(widget.idPublicacion, token);

    if (publicacion != null) {
      setState(() {
        _descripcionCtrl.text = publicacion['descripcion'];
        _imagenes.clear();
        _imagenes.addAll(publicacion['imagenes'].map((img) => File(img)));
      });
    }
  }

  Future<void> _seleccionarImagen() async {
    if (_imagenes.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Solo puedes subir hasta 3 imágenes")),
      );
      return;
    }

    final picker = ImagePicker();
    final XFile? img = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (img != null) {
      setState(() {
        _imagenes.add(File(img.path));
      });
    }
  }

  Future<void> _guardar() async {
    if (_descripcionCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Escribe una descripción")),
      );
      return;
    }

    setState(() => _enviando = true);

    final comunidadService = Provider.of<ComunidadService>(context, listen: false);
    final token = widget.usuario['token'];

    final success = await comunidadService.actualizarPublicacionConImagenes(
      widget.idPublicacion,
      _descripcionCtrl.text.trim(),
      _imagenes,
      token,
    );

    setState(() => _enviando = false);

    if (success) {
      Navigator.pop(context, true); // Volver al feed
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error al actualizar publicación")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Publicación"),
        backgroundColor: Colors.orange,
        actions: [
          TextButton(
            onPressed: _enviando ? null : _guardar,
            child: Text(
              "Guardar",
              style: TextStyle(
                color: _enviando ? Colors.grey[300] : Colors.white,
                fontSize: 16,
              ),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          // Campo de descripción
          TextField(
            controller: _descripcionCtrl,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "Escribe una nueva descripción...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),

          const SizedBox(height: 20),

          // Agregar imágenes
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _seleccionarImagen,
                icon: const Icon(Icons.image),
                label: const Text("Agregar imagen"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                ),
              ),
              const SizedBox(width: 10),
              Text("(${_imagenes.length}/3)"),
            ],
          ),

          const SizedBox(height: 15),

          // Previsualizar imágenes
          if (_imagenes.isNotEmpty)
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(_imagenes.length, (i) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(
                        _imagenes[i],
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 5,
                      top: 5,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _imagenes.removeAt(i);
                          });
                        },
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.black54,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),

          const SizedBox(height: 30),

          // Indicador de carga
          if (_enviando)
            const Center(
              child: CircularProgressIndicator(),
            ),
        ],
      ),
    );
  }
}
