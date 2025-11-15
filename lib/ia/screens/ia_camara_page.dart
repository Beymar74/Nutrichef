import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    iniciarCamara();
  }

  Future<void> iniciarCamara() async {
    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
        (cam) => cam.lensDirection == CameraLensDirection.back,
      );

      controller = CameraController(
        backCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await controller!.initialize();
      if (!mounted) return;

      setState(() {});
    } catch (e) {
      debugPrint("Error al iniciar cámara: $e");
    }
  }

  Future<void> toggleFlash() async {
    if (controller == null) return;

    flashOn = !flashOn;
    await controller!.setFlashMode(
      flashOn ? FlashMode.torch : FlashMode.off,
    );
    setState(() {});
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: controller == null || !controller!.value.isInitialized
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primary),
              )
            : Stack(
                children: [
                  // Cámara
                  SizedBox(
                    width: size.width,
                    height: size.height,
                    child: CameraPreview(controller!),
                  ),

                  // Degradado superior
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    height: 450,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white,
                            Colors.white70,
                            Colors.white30,
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Texto
                  Positioned(
                    top: 40,
                    left: 25,
                    right: 25,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Toma Una Fotografía',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Asegúrate de que todos los ingredientes que quieras identificar se encuentren dentro de la imagen',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 13,
                            height: 1.4,
                            color: AppColors.textLight,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Botones inferiores
                  Positioned(
                    bottom: 35,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // CAPTURAR — solo navega
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const IaIngredientesPage(),
                              ),
                            );
                          },
                          child: Container(
                            width: 65,
                            height: 65,
                            margin: const EdgeInsets.symmetric(horizontal: 25),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Image.asset(
                                'assets/images/CamaraLogo.png',
                                width: 32,
                                height: 32,
                              ),
                            ),
                          ),
                        ),

                        // FLASH usando tus ASSETS
                        GestureDetector(
                          onTap: toggleFlash,
                          child: Container(
                            width: 65,
                            height: 65,
                            margin: const EdgeInsets.symmetric(horizontal: 25),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Center(
                              child: Image.asset(
                                flashOn
                                    ? 'assets/images/FlashLogo.png'
                                    : 'assets/images/FlashLogo.png',
                                width: 28,
                                height: 28,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
