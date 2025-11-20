import 'dart:io'; // Necesario para File
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/ia_controller.dart'; // Importa tu controlador
import 'ia_camara_page.dart';
import 'ia_ingredientes_page.dart';

class AppColors {
  static const Color primary = Color(0xFFFF8C21);
  static const Color textDark = Color(0xFF1E1E1E);
  static const Color textLight = Color(0xFF707070);
  static const Color background = Colors.white;
}

// Convertimos a StatefulWidget para manejar el estado de "Cargando"
class IaInicioPage extends StatefulWidget {
  const IaInicioPage({super.key});

  @override
  State<IaInicioPage> createState() => _IaInicioPageState();
}

class _IaInicioPageState extends State<IaInicioPage> {
  // Instancia del controlador
  final IaController _iaController = IaController();
  
  // Variable para controlar el spinner de carga
  bool _cargando = false;

  Future<void> _abrirGaleria(BuildContext context) async {
    final picker = ImagePicker();
    // TRUCO: Bajar calidad para evitar timeouts o errores de memoria
    final XFile? imagen = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 60, // Calidad media
        maxWidth: 1200,   // Max ancho decente
    );

    if (imagen == null) return;

    setState(() {
      _cargando = true;
    });

    try {
      final ingredientesDetectados = await _iaController.identificarIngredientes(File(imagen.path));

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => IaIngredientesPage(ingredientesIniciales: ingredientesDetectados),
        ),
      );

    } catch (e) {
      print("ERROR GALERÍA: $e"); // Mira la consola para ver el error real
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al analizar: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5), // Más tiempo para leer
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _cargando = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack( // Usamos Stack para poner el Loading encima de todo si es necesario
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  // --- Texto ---
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 35, 30, 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Utiliza Nuestra IA',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        SizedBox(height: 12),
                        Text(
                          'Puedes identificar ingredientes y obtener sugerencias para preparar recetas con los ingredientes que tienes a mano, solo proporcionanos una fotografía.',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 15,
                            color: AppColors.textLight,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // --- Imagen con degradados ---
                  SizedBox(
                    width: size.width,
                    height: 270,
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child: Image.asset(
                            'assets/images/ia_bienvenida.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                        // Degradado superior
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          height: 20,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [Colors.white, Colors.white70, Colors.transparent],
                              ),
                            ),
                          ),
                        ),
                        // Degradado inferior
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          height: 20,
                          child: Container(
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                colors: [Colors.white, Colors.white70, Colors.transparent],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 80),

                  // --- BOTONES ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      children: [
                        // Tomar foto
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            // Deshabilitamos el botón si está cargando
                            onPressed: _cargando ? null : () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => const IaCamaraPage()),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              disabledBackgroundColor: AppColors.primary.withOpacity(0.6),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: const Text(
                              'Tomar Fotografía',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // Galería
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: OutlinedButton(
                            // Deshabilitamos el botón si está cargando
                            onPressed: _cargando ? null : () => _abrirGaleria(context),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: AppColors.primary, width: 2),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            child: _cargando 
                              ? const SizedBox( // Spinner pequeño si está cargando
                                  height: 24, 
                                  width: 24, 
                                  child: CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2)
                                )
                              : const Text(
                                  'Seleccionar De Galeria',
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: AppColors.primary,
                                  ),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 60),
                ],
              ),
            ),
            
            // Overlay de carga opcional (pantalla completa semi-transparente)
            if (_cargando)
              Container(
                color: Colors.black.withOpacity(0.3),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        CircularProgressIndicator(color: AppColors.primary),
                        SizedBox(height: 15),
                        Text("Analizando imagen...", style: TextStyle(fontFamily: 'Poppins')),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}