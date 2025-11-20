import 'dart:io'; // Importante para File
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import '../controllers/ia_controller.dart'; // Importa tu controlador
import 'ia_ingredientes_page.dart';

class AppColors {
  static const Color primary = Color(0xFFFF8C21);
  static const Color textDark = Color(0xFF1E1E1E);
  static const Color textLight = Color(0xFF707070);
  static const Color background = Colors.white;
}

class IaCamaraPage extends StatefulWidget {
  const IaCamaraPage({super.key});

  @override
  State<IaCamaraPage> createState() => _IaCamaraPageState();
}

class _IaCamaraPageState extends State<IaCamaraPage> {
  CameraController? controller;
  bool flashOn = false;
  bool _isCameraInitialized = false;
  
  // Controlador de IA y estado de carga
  final IaController _iaController = IaController();
  bool _procesandoImagen = false;

  @override
  void initState() {
    super.initState();
    iniciarCamara();
  }

  Future<void> iniciarCamara() async {
    try {
      final cameras = await availableCameras();
      // Intentar buscar la cámara trasera, si no hay, usa la primera disponible
      final backCamera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      controller = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller!.initialize();
      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      debugPrint("Error al iniciar cámara: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No se pudo iniciar la cámara')),
        );
      }
    }
  }

  Future<void> toggleFlash() async {
    if (controller == null || !controller!.value.isInitialized) return;

    try {
      flashOn = !flashOn;
      await controller!.setFlashMode(
        flashOn ? FlashMode.torch : FlashMode.off,
      );
      setState(() {});
    } catch (e) {
      debugPrint("Error cambiando flash: $e");
    }
  }

  Future<void> _tomarYProcesarFoto() async {
    if (controller == null || !controller!.value.isInitialized || _procesandoImagen) return;

    try {
      // 1. Mostrar carga
      setState(() {
        _procesandoImagen = true;
      });

      // 2. Tomar la foto
      final XFile photo = await controller!.takePicture();
      
      // 3. Enviar al Backend (IA)
      // Nota: Convertimos XFile a File
      final ingredientesDetectados = await _iaController.identificarIngredientes(File(photo.path));

      if (!mounted) return;

      // 4. Navegar a la pantalla de resultados
      // Usamos pushReplacement para que al volver atrás no regrese a la cámara congelada
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => IaIngredientesPage(ingredientesIniciales: ingredientesDetectados),
        ),
      );

    } catch (e) {
      debugPrint("Error procesando foto: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      }
    } finally {
      // Solo desactivamos la carga si seguimos en esta pantalla (por si hubo error)
      if (mounted) {
        setState(() {
          _procesandoImagen = false;
        });
      }
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Si no está lista o hay error, pantalla negra de carga
    if (!_isCameraInitialized || controller == null) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // 1. Vista de Cámara (Ocupa todo)
            SizedBox(
              width: size.width,
              height: size.height,
              child: CameraPreview(controller!),
            ),

            // 2. Degradado superior (Estético)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 150,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black54,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),

            // 3. Texto Superior
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Botón atrás pequeño
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 24),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Toma Una Fotografía',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Asegúrate de que todos los ingredientes estén visibles.',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 13,
                      color: Colors.white70,
                      shadows: [Shadow(color: Colors.black, blurRadius: 4)],
                    ),
                  ),
                ],
              ),
            ),

            // 4. Controles Inferiores (Flash y Disparador)
            Positioned(
              bottom: 30,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Espacio vacío para equilibrar
                  const SizedBox(width: 65),

                  // BOTÓN DISPARADOR
                  GestureDetector(
                    onTap: _tomarYProcesarFoto,
                    child: Container(
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        color: _procesandoImagen ? Colors.grey : AppColors.primary,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 4),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _procesandoImagen
                          ? const Padding(
                              padding: EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
                            )
                          : const Center(
                              child: Icon(Icons.camera_alt, color: Colors.white, size: 35),
                            ),
                    ),
                  ),

                  // BOTÓN FLASH
                  GestureDetector(
                    onTap: toggleFlash,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.black45,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white30, width: 1),
                      ),
                      child: Icon(
                        flashOn ? Icons.flash_on : Icons.flash_off,
                        color: flashOn ? Colors.yellow : Colors.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // 5. Overlay de "Procesando" (Pantalla completa)
            if (_procesandoImagen)
              Container(
                color: Colors.black54,
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      CircularProgressIndicator(color: AppColors.primary),
                      SizedBox(height: 20),
                      Text(
                        "Analizando Ingredientes...",
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Poppins',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}