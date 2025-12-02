import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../services/comunidad_service.dart';

class NuevaPublicacionScreen extends StatefulWidget {
  final Map<String, dynamic> usuario;

  const NuevaPublicacionScreen({Key? key, required this.usuario})
    : super(key: key);

  @override
  _NuevaPublicacionScreenState createState() => _NuevaPublicacionScreenState();
}

class _NuevaPublicacionScreenState extends State<NuevaPublicacionScreen> {
  final TextEditingController _descripcionCtrl = TextEditingController();
  final List<File> _imagenes = [];
  bool _enviando = false;

  @override
  void dispose() {
    _descripcionCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nueva Publicación"),
        backgroundColor: Colors.orange,
        actions: [
          // ✅ Botón de publicar mejorado
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
                        "Publicar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
            ),
          ),
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
                  Text(
                    widget.usuario['username'] ?? '@usuario',
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
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
              hintText: "¿Qué quieres compartir?",
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

          // Botones de acción
          Row(
            children: [
              // ✅ Botón de imagen con icono mejorado
              ElevatedButton.icon(
                onPressed: _enviando ? null : _seleccionarImagen,
                icon: const Icon(Icons.add_photo_alternate),
                label: const Text("Agregar fotos"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                "${_imagenes.length}/3 imágenes",
                style: TextStyle(
                  color: _imagenes.length >= 3 ? Colors.red : Colors.grey[600],
                  fontWeight: _imagenes.length >= 3
                      ? FontWeight.bold
                      : FontWeight.normal,
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // ✅ Previsualizar imágenes mejorado
          if (_imagenes.isNotEmpty)
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _imagenes.length,
              itemBuilder: (context, i) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.file(_imagenes[i], fit: BoxFit.cover),
                    ),
                    // Botón eliminar
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
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 16,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

          const SizedBox(height: 20),

          // ✅ Indicador de progreso con mensaje
          if (_enviando)
            Center(
              child: Column(
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 10),
                  Text(
                    _imagenes.isEmpty
                        ? "Publicando..."
                        : "Subiendo imágenes...",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  // ✅ Seleccionar imagen con opciones de cámara y galería
  Future<void> _seleccionarImagen() async {
    if (_imagenes.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Solo puedes subir hasta 3 imágenes"),
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
        _imagenes.add(File(img.path));
      });
    }
  }

  // ✅ Función para guardar con validación mejorada
  // Solo la función _guardar() mejorada
  // El resto del código queda igual

  Future<void> _guardar() async {
    // Validar descripción
    if (_descripcionCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Escribe una descripción para tu publicación"),
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

    final comunidadService = Provider.of<ComunidadService>(
      context,
      listen: false,
    );
    final token = widget.usuario['token'];

    // ✅ Verificar que el token existe
    if (token == null || token.isEmpty) {
      setState(() => _enviando = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Error: No hay sesión activa. Inicia sesión nuevamente.",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    print("🔍 DEBUG: Iniciando publicación");
    print(
      "📝 Descripción length: ${_descripcionCtrl.text.trim().length} caracteres",
    );
    print("🖼️ Imágenes: ${_imagenes.length}");

    bool success;

    try {
      if (_imagenes.isEmpty) {
        print("📤 Publicando sin imágenes...");
        success = await comunidadService.crearPublicacion(
          _descripcionCtrl.text.trim(),
          token,
        );
      } else {
        print("📤 Publicando con ${_imagenes.length} imágenes...");
        success = await comunidadService.crearPublicacionConImagenes(
          _descripcionCtrl.text.trim(),
          _imagenes,
          token,
        );
      }

      setState(() => _enviando = false);

      if (success) {
        print("✅ Publicación exitosa");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("¡Publicación creada exitosamente!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context, true);
      } else {
        // ❌ Mostrar error específico del servicio
        final errorMsg =
            comunidadService.ultimoError ??
            "Error desconocido al crear publicación";

        print("❌ Error: $errorMsg");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMsg),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: "Reintentar",
              textColor: Colors.white,
              onPressed: _guardar,
            ),
          ),
        );
      }
    } catch (e) {
      setState(() => _enviando = false);

      print("❌ EXCEPCIÓN CRÍTICA: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error crítico: $e"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }
  }
}
