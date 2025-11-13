import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  final Map<String, dynamic> usuario; // ahora recibe todo el usuario

  const Home({super.key, required this.usuario});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;
  
  // Lista de favoritos (recetas marcadas)
  final Set<String> _favoritos = {};

  void _toggleFavorito(String recetaId) {
    setState(() {
      if (_favoritos.contains(recetaId)) {
        _favoritos.remove(recetaId);
      } else {
        _favoritos.add(recetaId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
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
                          'Hola! ${widget.usuario['name'] ?? 'Usuario'}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFFEC888D),
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
                          child: Row(
                            children: [
                              Image.asset(
                                'assets/images/estrella.png',
                                width: 20,
                                height: 20,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(
                                    Icons.star,
                                    color: Color(0xFFFF8C21),
                                    size: 20,
                                  );
                                },
                              ),
                              const SizedBox(width: 4),
                              const Text(
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

                // CHIPS DE CATEGORÍAS
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildCategoriaChip('Desayuno', true),
                      const SizedBox(width: 10),
                      _buildCategoriaChip('Almuerzo', false),
                      const SizedBox(width: 10),
                      _buildCategoriaChip('Cena', false),
                      const SizedBox(width: 10),
                      _buildCategoriaChip('Vegano', false),
                      const SizedBox(width: 10),
                      _buildCategoriaChip('Dulce', false),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

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

                // CARD RECETA DE MODA
                Container(
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
                        Image.asset(
                          'assets/images/pizzasal.png',
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
                            onTap: () => _toggleFavorito('pizza'),
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
                              child: Image.asset(
                                'assets/images/corazon.png',
                                width: 20,
                                height: 20,
                                color: _favoritos.contains('pizza')
                                    ? const Color(0xFFEC888D)
                                    : Colors.grey[400],
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    _favoritos.contains('pizza')
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: _favoritos.contains('pizza')
                                        ? const Color(0xFFEC888D)
                                        : Colors.grey[400],
                                    size: 20,
                                  );
                                },
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
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: const BorderRadius.only(
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
                                    const Text(
                                      'Pizza de Salami y Queso',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/tiempo.png',
                                          width: 16,
                                          height: 16,
                                          errorBuilder: (context, error, stackTrace) {
                                            return const Icon(
                                              Icons.access_time,
                                              size: 16,
                                              color: Colors.grey,
                                            );
                                          },
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '30min',
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
                                  'Este es un breve resumen de los ingredientes...',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    Image.asset(
                                      'assets/images/estrella.png',
                                      width: 14,
                                      height: 14,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.star,
                                          size: 14,
                                          color: Color(0xFFFF8C21),
                                        );
                                      },
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
                                    Image.asset(
                                      'assets/images/corazon.png',
                                      width: 14,
                                      height: 14,
                                      color: Color(0xFFEC888D),
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.favorite,
                                          size: 14,
                                          color: Color(0xFFEC888D),
                                        );
                                      },
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

                const SizedBox(height: 25),

                // TUS RECETAS
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
                        'Tus Recetas',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: _buildRecetaCard(
                              'hamburguesa.png',
                              'Hamburguesa de pollo',
                              '16min',
                              'hamburguesa',
                            ),
                          ),
                          const SizedBox(width: 15),
                          Expanded(
                            child: _buildRecetaCard(
                              'tiramisu.png',
                              'Tiramisu',
                              '18min',
                              'tiramisu',
                            ),
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
                const Text(
                  'Recetas Recientes',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEC888D),
                  ),
                ),

                const SizedBox(height: 15),

                // Aquí puedes agregar más recetas recientes
                const SizedBox(height: 100), // Espacio para el bottom nav
              ],
            ),
          ),
        ),
      ),

      // BOTTOM NAVIGATION BAR
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFFF8C21),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
            backgroundColor: const Color(0xFFFF8C21),
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/Home.png',
                  width: 28,
                  height: 28,
                  color: _selectedIndex == 0 ? Colors.white : Colors.white70,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.home,
                      color: _selectedIndex == 0 ? Colors.white : Colors.white70,
                    );
                  },
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/Community.png',
                  width: 28,
                  height: 28,
                  color: _selectedIndex == 1 ? Colors.white : Colors.white70,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.chat_bubble,
                      color: _selectedIndex == 1 ? Colors.white : Colors.white70,
                    );
                  },
                ),
                label: 'Community',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/vector.png',
                  width: 28,
                  height: 28,
                  color: _selectedIndex == 2 ? Colors.white : Colors.white70,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.layers,
                      color: _selectedIndex == 2 ? Colors.white : Colors.white70,
                    );
                  },
                ),
                label: 'Recetas',
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/Profile.png',
                  width: 28,
                  height: 28,
                  color: _selectedIndex == 3 ? Colors.white : Colors.white70,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.person,
                      color: _selectedIndex == 3 ? Colors.white : Colors.white70,
                    );
                  },
                ),
                label: 'Perfil',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoriaChip(String label, bool isSelected) {
    return Container(
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
    );
  }

  Widget _buildRecetaCard(String imageName, String titulo, String tiempo, String id) {
    return Container(
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
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(
                  'assets/images/$imageName',
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
                  onTap: () => _toggleFavorito(id),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Image.asset(
                      'assets/images/corazon.png',
                      width: 16,
                      height: 16,
                      color: _favoritos.contains(id)
                          ? const Color(0xFFEC888D)
                          : Colors.grey[400],
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          _favoritos.contains(id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: _favoritos.contains(id)
                              ? const Color(0xFFEC888D)
                              : Colors.grey[400],
                          size: 16,
                        );
                      },
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
                  titulo,
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
                    Image.asset(
                      'assets/images/estrella.png',
                      width: 12,
                      height: 12,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.star,
                          size: 12,
                          color: Color(0xFFFF8C21),
                        );
                      },
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
                    Image.asset(
                      'assets/images/tiempo.png',
                      width: 12,
                      height: 12,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(
                          Icons.access_time,
                          size: 12,
                          color: Colors.grey,
                        );
                      },
                    ),
                    const SizedBox(width: 4),
                    Text(
                      tiempo,
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