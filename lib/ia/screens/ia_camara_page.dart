import 'package:flutter/material.dart';
import 'ia_ingredientes_page.dart'; // ← para navegar luego al siguiente paso (simulado)

class AppColors {
  static const Color primary = Color(0xFFFF8C21);
  static const Color textDark = Color(0xFF1E1E1E);
  static const Color textLight = Color(0xFF707070);
  static const Color background = Colors.white;
}

class IaCamaraPage extends StatelessWidget {
  const IaCamaraPage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Stack(
          children: [
            // Imagen de fondo (simulación de cámara)
            SizedBox(
              width: size.width,
              height: size.height,
              child: Image.asset(
                'assets/images/CamaraSimulada.png',
                fit: BoxFit.cover,
              ),
            ),

            // Degradado superior
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 200,
              child: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.white,
                      Colors.white10,
                    ],
                  ),
                ),
              ),
            ),

            // Texto superior
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

            // Controles inferiores (botones)
            Positioned(
              bottom: 35,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Botón cámara
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

                  // Botón flash
                  GestureDetector(
                    onTap: () {},
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
                          'assets/images/FlashLogo.png',
                          width: 30,
                          height: 30,
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
