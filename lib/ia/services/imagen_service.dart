import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ImagenService {
  static final ImagePicker _picker = ImagePicker();

  /// Seleccionar desde la cámara
  static Future<File?> tomarFoto() async {
    final XFile? foto = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 85, // compresión ligera
    );

    if (foto == null) return null;
    return File(foto.path);
  }

  /// Seleccionar desde la galería
  static Future<File?> seleccionarGaleria() async {
    final XFile? imagen = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (imagen == null) return null;
    return File(imagen.path);
  }
}
