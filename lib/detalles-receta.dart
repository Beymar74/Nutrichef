import 'package:flutter/material.dart';
import 'asistente_cocina.dart'; 
import 'receta_model.dart'; 

class DetallesRecetaScreen extends StatelessWidget {
  final Map<String, dynamic> receta;

  const DetallesRecetaScreen({Key? key, required this.receta})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFFF8C00)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Recetas De Moda',
          style: TextStyle(
            color: Color(0xFFFF8C00),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFFF69B4),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite,
                color: Colors.white,
                size: 20,
              ),
            ),
            onPressed: () {},
          ),
          IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFFF8C00),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.share,
                color: Colors.white,
                size: 20,
              ),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMainVideo(),
            const SizedBox(height: 16),
            _buildChefInfo(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Divider(color: Color(0xFFFFD700), thickness: 2),
            ),
            const SizedBox(height: 16),
            _buildDetallesSection(),
            const SizedBox(height: 24),
            _buildIngredientesSection(),
            _buildEmpezarAhoraButton(context),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildEmpezarAhoraButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            _navegarAAsistenteCocina(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF8C00),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 5,
            shadowColor: const Color(0xFFFF8C00).withOpacity(0.3),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 24,
              ),
              SizedBox(width: 8),
              Text(
                'Empezar Ahora',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navegarAAsistenteCocina(BuildContext context) {
    final recetaObj = Receta.fromJson(receta);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsistenteCocinaScreen(receta: recetaObj),
      ),
    );
  }
  Widget _buildMainVideo() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      height: 280,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(
          image: NetworkImage(
            receta['imagen'] ?? 'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800',
          ),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFFFF8C00).withOpacity(0.9),
                    const Color(0xFFFFB84D).withOpacity(0.9),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      receta['titulo'] ?? 'Sin título',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.remove_red_eye,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '5',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons.access_time,
                        color: Colors.white,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${receta['tiempo_preparacion'] ?? 'N/A'} min',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChefInfo() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(
              'https://images.unsplash.com/photo-1577219491135-ce391730fb2c?w=200',
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  receta['chef_username'] ?? '@nutrichef',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
                Text(
                  receta['chef'] ?? 'Chef Nutrichef',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFFD700),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Seguir',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.more_vert,
            color: Colors.grey[600],
          ),
        ],
      ),
    );
  }

  Widget _buildDetallesSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                'Detalles',
                style: TextStyle(
                  color: Color(0xFFFF8C00),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.access_time,
                color: Colors.grey,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '${receta['tiempo_preparacion'] ?? 'N/A'} min',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            receta['resumen'] ?? 'Descripción no disponible.',
            style: TextStyle(
              color: Colors.grey[800],
              fontSize: 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIngredientesSection() {
    final List<dynamic> ingredientesData = receta['ingredientes'] ?? [];
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ingredientes',
            style: TextStyle(
              color: Color(0xFFFF8C00),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          if (ingredientesData.isEmpty)
            const Text(
              'No hay ingredientes disponibles',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            )
          else
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: ingredientesData.length,
              itemBuilder: (context, index) {
                final ingrediente = ingredientesData[index];
                final descripcion = ingrediente['descripcion']?.toString() ?? '';
                final cantidad = ingrediente['cantidad']?.toString() ?? '';
                final unidad = ingrediente['unidad_medida']?.toString() ?? '';
                
                String textoIngrediente = _formatearIngrediente(cantidad, unidad, descripcion);
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '• ',
                        style: TextStyle(
                          color: Color(0xFFFF8C00),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          textoIngrediente,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
    );
  }

  String _formatearIngrediente(String cantidad, String unidad, String descripcion) {
    double? cantidadNum = double.tryParse(cantidad);
    String cantidadLimpia = cantidad;
    if (cantidadNum != null) {
      if (cantidadNum == cantidadNum.floor()) {
        cantidadLimpia = cantidadNum.toInt().toString();
      } else {
        cantidadLimpia = cantidadNum.toString();
      }
    }

    String unidadLimpia = _obtenerUnidadApropiada(unidad, descripcion);

    if (unidadLimpia.isEmpty) {
      return '$cantidadLimpia de $descripcion';
    } else {
      return '$cantidadLimpia $unidadLimpia de $descripcion';
    }
  }

  String _obtenerUnidadApropiada(String unidad, String descripcion) {
    if (unidad != 'ELIMINADA' && unidad != 'PUBLICADA') {
      return unidad;
    }

    String descripcionLower = descripcion.toLowerCase();
    
    if (descripcionLower.contains('arroz') || 
        descripcionLower.contains('espinaca') ||
        descripcionLower.contains('salmón') ||
        descripcionLower.contains('pollo') ||
        descripcionLower.contains('carne') ||
        descripcionLower.contains('pescado')) {
      return 'g';
    } else if (descripcionLower.contains('aguacate') ||
               descripcionLower.contains('tomate') ||
               descripcionLower.contains('cebolla') ||
               descripcionLower.contains('pimiento') ||
               descripcionLower.contains('limón') ||
               descripcionLower.contains('naranja')) {
      return 'unidad';
    } else if (descripcionLower.contains('aceite') ||
               descripcionLower.contains('agua') ||
               descripcionLower.contains('leche') ||
               descripcionLower.contains('vinagre')) {
      return 'ml';
    } else if (descripcionLower.contains('taza') ||
               descripcionLower.contains('cucharada') ||
               descripcionLower.contains('cucharadita')) {
      return '';
    } else {
      return 'g';
    }
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF8C00), Color(0xFFFFB84D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF8C00).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home, true),
          _buildNavItem(Icons.restaurant_menu, false),
          _buildNavItem(Icons.layers, false),
          _buildNavItem(Icons.person, false),
        ],
      ),
    );
  }

  Widget _buildNavItem(IconData icon, bool isActive) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: isActive ? Colors.white.withOpacity(0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 28,
      ),
    );
  }
}