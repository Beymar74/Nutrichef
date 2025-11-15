import 'package:flutter/material.dart';
import 'recetas.dart';
import 'detalles-receta.dart';
import 'services/receta_service.dart';
import 'models/receta_model.dart';

class Home extends StatefulWidget {
  final String nombreUsuario;

  const Home({super.key, required this.nombreUsuario});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  final Set<String> _favoritos = {};
  
  // API Service
  final RecetaService _recetaService = RecetaService();
  List<Receta> _todasLasRecetas = []; // Todas las recetas
  List<Receta> _recetasFiltradas = []; // Recetas filtradas
  Receta? _recetaDestacada;
  bool _isLoading = true;
  
  // Categoría seleccionada
  String _categoriaSeleccionada = 'Todas';

  @override
  void initState() {
    super.initState();
    _cargarRecetas();
  }

  Future<void> _cargarRecetas() async {
    try {
      setState(() => _isLoading = true);
      
      final recetas = await _recetaService.obtenerRecetas();
      
      setState(() {
        _todasLasRecetas = recetas;
        _recetasFiltradas = recetas;
        _recetaDestacada = recetas.isNotEmpty ? recetas.first : null;
        _isLoading = false;
      });
    } catch (e) {
      print('❌ Error al cargar recetas: $e');
      setState(() => _isLoading = false);
    }
  }

  void _filtrarPorCategoria(String categoria) {
    setState(() {
      _categoriaSeleccionada = categoria;
      
      if (categoria == 'Todas') {
        _recetasFiltradas = _todasLasRecetas;
      } else if (categoria == 'Vegano') {
        // Filtrar recetas veganas
        _recetasFiltradas = _todasLasRecetas.where((receta) {
          return receta.dietas.any((dieta) => 
            dieta.toLowerCase().contains('vegan'));
        }).toList();
      } else {
        // Para otras categorías, mostrar todas por ahora
        // Puedes agregar más filtros según tu base de datos
        _recetasFiltradas = _todasLasRecetas;
      }
      
      // Actualizar receta destacada
      _recetaDestacada = _recetasFiltradas.isNotEmpty 
          ? _recetasFiltradas.first 
          : null;
    });
  }

  void _toggleFavorito(String recetaId) {
    setState(() {
      if (_favoritos.contains(recetaId)) {
        _favoritos.remove(recetaId);
      } else {
        _favoritos.add(recetaId);
      }
    });
  }

  void _navigateToRecetas() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RecetasModaScreen(),
      ),
    );
  }

  void _onNavBarTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Ya estamos en Home
        break;
      case 1:
        // Community (por implementar)
        break;
      case 2:
        // Navegar a Recetas
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const RecetasModaScreen(),
          ),
        );
        break;
      case 3:
        // Perfil (por implementar)
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Color(0xFFFF8C21),
                ),
              )
            : RefreshIndicator(
                onRefresh: _cargarRecetas,
                color: const Color(0xFFFF8C21),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),

                        // HEADER CON SALUDO Y MONEDAS
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hola! ${widget.nombreUsuario}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFEC888D),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Que te gustaría cocinar hoy',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFD54F),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Color(0xFFFF8C21),
                                        size: 20,
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '0',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFD54F),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: const Row(
                                    children: [
                                      Text(
                                        '🪙',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(width: 4),
                                      Text(
                                        '0',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 25),

                        // CHIPS DE CATEGORÍAS - AHORA FUNCIONALES
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildCategoriaChip('Todas', _categoriaSeleccionada == 'Todas'),
                              const SizedBox(width: 10),
                              _buildCategoriaChip('Desayuno', _categoriaSeleccionada == 'Desayuno'),
                              const SizedBox(width: 10),
                              _buildCategoriaChip('Almuerzo', _categoriaSeleccionada == 'Almuerzo'),
                              const SizedBox(width: 10),
                              _buildCategoriaChip('Cena', _categoriaSeleccionada == 'Cena'),
                              const SizedBox(width: 10),
                              _buildCategoriaChip('Vegano', _categoriaSeleccionada == 'Vegano'),
                              const SizedBox(width: 10),
                              _buildCategoriaChip('Dulce', _categoriaSeleccionada == 'Dulce'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 15),

                        // Mostrar cantidad de recetas filtradas
                        Text(
                          '${_recetasFiltradas.length} recetas disponibles',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                          ),
                        ),

                        const SizedBox(height: 15),

                        // RECETA DE MODA
                        const Text(
                          'Receta De Moda',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFEC888D),
                          ),
                        ),

                        const SizedBox(height: 15),

                        // CARD RECETA DE MODA (Usando datos filtrados)
                        if (_recetaDestacada != null)
                          _buildRecetaDestacada(_recetaDestacada!)
                        else
                          _buildRecetaDestacadaPlaceholder(),

                        const SizedBox(height: 25),

                        // TUS RECETAS (Usando datos filtrados)
                        if (_recetasFiltradas.length > 1)
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF8C21),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Más Recetas',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  children: [
                                    if (_recetasFiltradas.length > 1)
                                      Expanded(
                                        child: _buildRecetaCardFromAPI(_recetasFiltradas[1]),
                                      ),
                                    if (_recetasFiltradas.length > 2)
                                      const SizedBox(width: 15),
                                    if (_recetasFiltradas.length > 2)
                                      Expanded(
                                        child: _buildRecetaCardFromAPI(_recetasFiltradas[2]),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                        const SizedBox(height: 25),

                        // TOP CHEF
                        const Text(
                          'Top Chef',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFEC888D),
                          ),
                        ),

                        const SizedBox(height: 15),

                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildChefCard('joseph.png', 'Joseph'),
                              const SizedBox(width: 12),
                              _buildChefCard('andrew.png', 'Andrew'),
                              const SizedBox(width: 12),
                              _buildChefCard('emily.png', 'Emily'),
                              const SizedBox(width: 12),
                              _buildChefCard('jessica.png', 'Jessica'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),

                        // RECETAS RECIENTES
                        if (_recetasFiltradas.length > 3) ...[
                          const Text(
                            'Recetas Recientes',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFEC888D),
                            ),
                          ),
                          const SizedBox(height: 15),
                          ..._recetasFiltradas.skip(3).take(3).map((receta) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: _buildRecetaHorizontalCard(receta),
                              )),
                        ],

                        const SizedBox(height: 100),
                      ],
                    ),
                  ),
                ),
              ),
      ),

      // BOTTOM NAVIGATION BAR - CUSTOM
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
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
          GestureDetector(
            onTap: () => _onNavBarTap(0),
            child: _buildNavItem(Icons.home, _selectedIndex == 0),
          ),
          GestureDetector(
            onTap: () => _onNavBarTap(1),
            child: _buildNavItem(Icons.restaurant_menu, _selectedIndex == 1),
          ),
          GestureDetector(
            onTap: () => _onNavBarTap(2),
            child: _buildNavItem(Icons.layers, _selectedIndex == 2),
          ),
          GestureDetector(
            onTap: () => _onNavBarTap(3),
            child: _buildNavItem(Icons.person, _selectedIndex == 3),
          ),
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

  // WIDGET: Chip de categoría - AHORA CON onTap
  Widget _buildCategoriaChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => _filtrarPorCategoria(label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFFF8C21) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFFFF8C21) : Colors.grey[300]!,
            width: 1.5,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey[700],
          ),
        ),
      ),
    );
  }

  // ... (Resto de los widgets sin cambios)
  
  Widget _buildRecetaDestacada(Receta receta) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetallesRecetaScreen(
              receta: receta.toMap(),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            children: [
              Image.network(
                receta.imagen ??
                    'https://images.unsplash.com/photo-1513104890138-7c749659a591?w=800',
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.restaurant,
                      size: 60,
                      color: Colors.grey,
                    ),
                  );
                },
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () => _toggleFavorito(receta.id.toString()),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                        ),
                      ],
                    ),
                    child: Icon(
                      _favoritos.contains(receta.id.toString())
                          ? Icons.favorite
                          : Icons.favorite_border,
                      color: _favoritos.contains(receta.id.toString())
                          ? const Color(0xFFEC888D)
                          : Colors.grey[400],
                      size: 20,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              receta.titulo,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.grey,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${receta.tiempoPreparacion}min',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        receta.resumen,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 14,
                            color: Color(0xFFFF8C21),
                          ),
                          const SizedBox(width: 4),
                          const Text(
                            '5',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFEC888D),
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.favorite,
                            size: 14,
                            color: Color(0xFFEC888D),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecetaDestacadaPlaceholder() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(
        child: Text('No hay recetas disponibles para esta categoría'),
      ),
    );
  }

  Widget _buildRecetaCardFromAPI(Receta receta) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetallesRecetaScreen(
              receta: receta.toMap(),
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    receta.imagen ??
                        'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
                    height: 120,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 120,
                        color: Colors.grey[300],
                        child: const Icon(Icons.restaurant, size: 40),
                      );
                    },
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () => _toggleFavorito(receta.id.toString()),
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _favoritos.contains(receta.id.toString())
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: _favoritos.contains(receta.id.toString())
                            ? const Color(0xFFEC888D)
                            : Colors.grey[400],
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    receta.titulo,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 12,
                        color: Color(0xFFFF8C21),
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        '5',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFEC888D),
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.access_time,
                        size: 12,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${receta.tiempoPreparacion}min',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecetaHorizontalCard(Receta receta) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetallesRecetaScreen(
              receta: receta.toMap(),
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                receta.imagen ??
                    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(Icons.restaurant, size: 30),
                  );
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    receta.titulo,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    receta.resumen,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 14,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${receta.tiempoPreparacion}min',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChefCard(String imageName, String nombre) {
    return Column(
      children: [
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFFF8C21),
              width: 2,
            ),
          ),
          child: ClipOval(
            child: Image.asset(
              'assets/images/$imageName',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(Icons.person, size: 35),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          nombre,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}