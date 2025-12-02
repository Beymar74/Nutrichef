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
  _EditarPublicacionScreenState createState() =>
      _EditarPublicacionScreenState();
}

class _EditarPublicacionScreenState extends State<EditarPublicacionScreen> {
  final TextEditingController _descripcionCtrl = TextEditingController();
  bool _enviando = false;
  bool _cargando = true;

  // ✅ Separar imágenes existentes de nuevas imágenes
  List<String> _imagenesExistentes = []; // URLs de imágenes ya subidas
  List<File> _imagenesNuevas = []; // Archivos nuevos a subir

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  @override
  void dispose() {
    _descripcionCtrl.dispose();
    super.dispose();
  }

  Future<void> _cargarDatos() async {
    setState(() => _cargando = true);

    final comunidadService =
        Provider.of<ComunidadService>(context, listen: false);
    final token = widget.usuario['token'];

    final publicacion = await comunidadService.obtenerPublicacionPorId(
      widget.idPublicacion,
      token,
    );

    if (publicacion != null && mounted) {
      setState(() {
        _descripcionCtrl.text = publicacion['descripcion'] ?? '';
        // ✅ Guardar URLs de imágenes existentes
        if (publicacion['imagenes'] != null) {
          _imagenesExistentes = List<String>.from(publicacion['imagenes']);
        }
        _cargando = false;
      });
    } else {
      setState(() => _cargando = false);
    }
  }

  // ✅ Total de imágenes (existentes + nuevas)
  int get totalImagenes => _imagenesExistentes.length + _imagenesNuevas.length;

  Future<void> _seleccionarImagen() async {
    if (totalImagenes >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Solo puedes tener hasta 3 imágenes"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Mostrar opciones: cámara o galería
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.orange),
              title: const Text("Tomar foto"),
              onTap: () => Navigator.pop(context, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.orange),
              title: const Text("Elegir de galería"),
              onTap: () => Navigator.pop(context, ImageSource.gallery),
            ),
          ],
        ),
      ),
    );

    if (source == null) return;

    final picker = ImagePicker();
    final XFile? img = await picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 1080,
    );

    if (img != null) {
      setState(() {
        _imagenesNuevas.add(File(img.path));
      });
    }
  }

  // ✅ Guardar cambios (solo descripción por ahora)
  Future<void> _guardar() async {
    if (_descripcionCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Escribe una descripción"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    if (_descripcionCtrl.text.trim().length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("La descripción debe tener al menos 10 caracteres"),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() => _enviando = true);

    final comunidadService =
        Provider.of<ComunidadService>(context, listen: false);
    final token = widget.usuario['token'];

    // ⚠️ NOTA: Por ahora solo actualizamos la descripción
    // Laravel no soporta PUT con imágenes multipart nativamente
    final success = await comunidadService.actualizarPublicacion(
      widget.idPublicacion,
      _descripcionCtrl.text.trim(),
      token,
    );

    setState(() => _enviando = false);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("¡Publicación actualizada!"),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true); // Volver y refrescar feed
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Error al actualizar publicación"),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Editar Publicación"),
          backgroundColor: Colors.orange,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text("Editar Publicación"),
        backgroundColor: Colors.orange,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: _enviando
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : TextButton(
                      onPressed: _guardar,
                      child: const Text(
                        "Guardar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          // ✅ Avatar del usuario
          Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.orange,
                child: Text(
                  widget.usuario['name'][0].toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.usuario['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    "Editando publicación",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Campo de descripción
          TextField(
            controller: _descripcionCtrl,
            maxLines: 5,
            maxLength: 500,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: "Actualiza tu descripción...",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              counterText: "${_descripcionCtrl.text.length}/500",
            ),
            onChanged: (value) {
              setState(() {}); // Actualizar contador
            },
          ),

          const SizedBox(height: 20),

          // ⚠️ Mensaje informativo
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange[200]!),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.orange[700], size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Por ahora solo puedes editar la descripción. Las imágenes no se pueden modificar.",
                    style: TextStyle(
                      color: Colors.orange[900],
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ✅ Mostrar imágenes existentes (solo lectura)
          if (_imagenesExistentes.isNotEmpty) ...[
            const Text(
              "Imágenes actuales:",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 10),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _imagenesExistentes.length,
              itemBuilder: (context, i) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    _imagenesExistentes[i],
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(Icons.broken_image),
                      );
                    },
                  ),
                );
              },
            ),
          ],

          const SizedBox(height: 30),

          // Indicador de carga
          if (_enviando)
            const Center(
              child: Column(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text(
                    "Guardando cambios...",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}