import 'package:flutter/material.dart';
import 'ia_camara_page.dart'; // ← Importa la siguiente pantalla

class AppColors {
  static const Color primary = Color(0xFFFF8C21);
  static const Color textDark = Color(0xFF1E1E1E);
  static const Color textLight = Color(0xFF707070);
  static const Color background = Colors.white;
}

class IaInicioPage extends StatelessWidget {
  const IaInicioPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // --- TEXTO PRINCIPAL ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
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
                    SizedBox(height: 10),
                    Text(
                      'Puedes identificar ingredientes y obtener sugerencias para preparar recetas con los ingredientes que tienes a mano, solo proporcionanos una fotografía.',
                      textAlign: TextAlign.left,
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

              // --- IMAGEN DIFUMINADA ---
              Stack(
                children: [
                  SizedBox(
                    width: size.width,
                    height: 270,
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
                    height: 80,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.white, Colors.white10],
                        ),
                      ),
                    ),
                  ),

                  // Degradado inferior
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 80,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [Colors.white, Colors.white10],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // --- NUEVO ESPACIADO ENTRE IMAGEN Y BOTONES ---
              const SizedBox(height: 70),

              // --- BOTONES ---
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    // Botón principal
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const IaCamaraPage(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 3,
                        ),
                        child: const Text(
                          'Tomar Fotografía',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 18, // ← texto más grande
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),

                    // Botón secundario
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(
                            color: AppColors.primary,
                            width: 2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Seleccionar De Galeria',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 18, // ← texto más grande
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
