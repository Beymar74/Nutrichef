import 'package:flutter/material.dart';
import 'login.dart';

class Bienvenida extends StatelessWidget {
  const Bienvenida({super.key});

  @override
  Widget build(BuildContext context) {
    print('✅ Pantalla BIENVENIDA cargada'); // Para debugging

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFF8C21), Color(0xFFFF9F4D), Color(0xFFFFB366)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),

              // Imagen principal CON MANEJO DE ERROR
              Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: Image.asset(
                    'assets/images/sand.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      print('❌ ERROR: No se pudo cargar sand.png');
                      // Muestra un ícono si falla la imagen
                      return Container(
                        color: Colors.white,
                        child: const Icon(
                          Icons.restaurant,
                          size: 100,
                          color: Color(0xFFFF9800),
                        ),
                      );
                    },
                  ),
                ),
              ),

              const Spacer(flex: 1),

              // Título
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  '¡Bienvenido a NutriChef!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Subtítulo
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: Text(
                  'Descubre recetas deliciosas y saludables para tu día a día',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                    height: 1.5,
                  ),
                ),
              ),

              const Spacer(flex: 2),

              // Botón continuar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      print('➡️ Navegando a Login'); // Para debugging
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (_) => const Login()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFFF9800),
                      elevation: 8,
                      shadowColor: Colors.black38,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
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
