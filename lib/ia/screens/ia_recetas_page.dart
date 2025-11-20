import 'package:flutter/material.dart';
import '../widgets/barra_inferior.dart';
import '../widgets/card_receta.dart';

class IaRecetasPage extends StatefulWidget {
  // Recibimos la lista real del backend
  final List<dynamic> recetas;

  const IaRecetasPage({
    super.key,
    required this.recetas, // Ahora es obligatorio
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
              Text("No encontramos recetas con esos ingredientes", 
                style: TextStyle(fontFamily: 'Poppins', color: Colors.grey)
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

              // Mapeo de datos del Backend a la UI
              // El backend devuelve: titulo, resumen, tiempo_preparacion, porciones_estimadas, imagen
              return CardReceta(
                imagen: receta['imagen'] ?? 'assets/images/1im.png', // Fallback si es null
                titulo: receta['titulo'] ?? 'Sin título',
                descripcion: receta['resumen'] ?? 'Sin descripción',
                // El backend no devuelve rating aún, simulamos uno o lo sacas si no lo tienes
                rating: 4.5, 
                tiempo: "${receta['tiempo_preparacion']} min",
                // El backend no devuelve favorito aún, asumimos false
                favorito: false, 
                
                onTapFavorito: () {
                  // Lógica local visual (no guarda en BD aún)
                  setState(() {
                    // Aquí podrías implementar la llamada al backend para guardar favorito
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