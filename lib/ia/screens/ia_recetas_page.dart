import 'package:flutter/material.dart';
import '../../screens/home/widgets/custom_bottom_nav.dart';
import '../widgets/card_receta.dart';
// IMPORTANTE: Ajusta esta ruta si tu archivo está en otra carpeta
import '../../detalles-receta.dart'; 
import '../../ia/screens/ia_inicio_page.dart';  // Para la Cámara
import '../../recetas.dart';                    // Para RecetasModaScreen

class IaRecetasPage extends StatefulWidget {
  // Recibimos la lista real del backend
  final List<dynamic> recetas;

  const IaRecetasPage({
    super.key,
    required this.recetas,
  });

  @override
  State<IaRecetasPage> createState() => _IaRecetasPageState();
}

class _IaRecetasPageState extends State<IaRecetasPage>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 2;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;

  static const Color naranja = Color(0xFFFF8C21);

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
    // Si no hay recetas, mostramos mensaje
    if (widget.recetas.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: naranja),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.search_off, size: 60, color: Colors.grey),
              SizedBox(height: 10),
              Text(
                "No encontramos recetas con esos ingredientes",
                style: TextStyle(fontFamily: 'Poppins', color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

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
            itemCount: widget.recetas.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.72,
            ),
            itemBuilder: (context, index) {
              final receta = widget.recetas[index];

              // --- AQUI ESTA LA MAGIA DE LA NAVEGACION ---
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetallesRecetaScreen(
                        // Convertimos el objeto dynamic a Map seguro
                        receta: Map<String, dynamic>.from(receta),
                      ),
                    ),
                  );
                },
                child: CardReceta(
                  imagen: receta['imagen'] ?? 'assets/images/1im.png', // Fallback si es null
                  titulo: receta['titulo'] ?? 'Sin título',
                  descripcion: receta['resumen'] ?? 'Sin descripción',
                  // El backend no devuelve rating aún, simulamos uno
                  rating: 4.5,
                  tiempo: "${receta['tiempo_preparacion']} min",
                  // El backend no devuelve favorito aún, asumimos false
                  favorito: false,
                  onTapFavorito: () {
                    // Lógica local visual
                    setState(() {
                      // Aquí implementación futura de favorito
                    });
                  },
                ),
              );
            },
          ),
        ),
      ),

      // --- BARRA INFERIOR CON NAVEGACIÓN REAL ---
      bottomNavigationBar: CustomBottomNav(
        selectedIndex: selectedIndex,
        onTap: (index) {
          // 1. Actualizamos visualmente
          setState(() => selectedIndex = index);

          // 2. Lógica de navegación basada en tu HomeScreen
          switch (index) {
            case 0:
              // Botón Home:
              // Como estamos en una sub-pantalla, la forma más lógica de "ir al home"
              // es cerrar esta pantalla y volver atrás.
              Navigator.pop(context);
              break;

            case 1:
              // Botón Chat:
              // Igual que en tu HomeScreen, aún está pendiente de implementar.
              // Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen()));
              break;

            case 2:
              // Botón Capas / Recetas:
              // Navega a la pantalla de Recetas de Moda
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const RecetasModaScreen()),
              );
              break;

            case 3:
              // Botón Perfil:
              // NOTA: Para usar la lógica completa de _abrirPerfil de tu HomeScreen,
              // necesitaríamos tener el objeto 'usuario' aquí. 
              // Por ahora, podrías dejarlo vacío o hacer un pop también.
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Accede al perfil desde el Inicio"))
              );
              break;
          }
        },
        onCameraPressed: () {
          // Acción del botón central (Cámara) -> Abre el módulo IA
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const IaInicioPage(),
            ),
          );
        },
      ),

    );
  }
}