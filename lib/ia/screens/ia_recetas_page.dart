import 'package:flutter/material.dart';
import '../widgets/barra_inferior.dart';
import '../widgets/card_receta.dart';

class IaRecetasPage extends StatefulWidget {
  const IaRecetasPage({super.key});

  @override
  State<IaRecetasPage> createState() => _IaRecetasPageState();
}

class _IaRecetasPageState extends State<IaRecetasPage>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 2; // Barra inferior seleccionada

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  static const Color naranja = Color(0xFFFF8C21);

  // Lista de recetas simuladas
  final List<Map<String, dynamic>> recetas = [
    {
      'imagen': 'assets/images/1im.png',
      'titulo': 'Grilled Skewers (2 porciones)',
      'descripcion': 'Jugosos pinchos con vegetales frescos y salsa casera.',
      'rating': 4.8,
      'tiempo': '30min',
      'favorito': true,
    },
    {
      'imagen': 'assets/images/2im.png',
      'titulo': 'Nut brownie (1 porción)',
      'descripcion': 'Postre suave de chocolate con trozos de nuez tostada.',
      'rating': 4.6,
      'tiempo': '20min',
      'favorito': false,
    },
    {
      'imagen': 'assets/images/3im.png',
      'titulo': 'Oatmeal pancakes (3 porciones)',
      'descripcion': 'Panqueques de avena con miel natural y fresas frescas.',
      'rating': 4.9,
      'tiempo': '25min',
      'favorito': true,
    },
    {
      'imagen': 'assets/images/4im.png',
      'titulo': 'Iced Coffee (3 porciones)',
      'descripcion': 'Refrescante mezcla de café espresso y leche fría.',
      'rating': 4.5,
      'tiempo': '10min',
      'favorito': false,
    },
    {
      'imagen': 'assets/images/5im.png',
      'titulo': 'Tofu and Noodles (1 porción)',
      'descripcion':
          'Salteado de tofu con fideos de arroz y verduras crujientes.',
      'rating': 4.4,
      'tiempo': '35min',
      'favorito': false,
    },
    {
      'imagen': 'assets/images/6im.png',
      'titulo': 'Fruit Bowl (2 porciones)',
      'descripcion': 'Mezcla de frutas tropicales con yogurt natural.',
      'rating': 4.7,
      'tiempo': '15min',
      'favorito': true,
    },
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );
    _fadeAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeInOut,
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: naranja),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Recetas Recomendadas',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: naranja,
          ),
        ),
      ),

      // --- CUERPO PRINCIPAL ---
      body: FadeTransition(
        opacity: _fadeAnim,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: GridView.builder(
            itemCount: recetas.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              // un poquito más alto cada card para evitar cualquier overflow
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, index) {
              final receta = recetas[index];

              return CardReceta(
                imagen: receta['imagen'],
                titulo: receta['titulo'],
                descripcion: receta['descripcion'],
                rating: receta['rating'],
                tiempo: receta['tiempo'],
                favorito: receta['favorito'],
                onTapFavorito: () {
                  setState(() {
                    receta['favorito'] = !receta['favorito'];
                  });
                },
              );
            },
          ),
        ),
      ),

      // --- BARRA INFERIOR ---
      bottomNavigationBar: SizedBox(
        height: 90,
        child: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: BarraInferior(
                selectedIndex: selectedIndex,
                onTap: (i) {
                  setState(() => selectedIndex = i);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
