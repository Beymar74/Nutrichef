import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

// --- MODELO CHEF ---
class Chef {
  final int id;
  final String name;
  final String handle;
  final String imageUrl;
  final String bio;
  final int followers;
  final int following;
  final int recipesCount;

  Chef({
    required this.id,
    required this.name,
    required this.handle,
    required this.imageUrl,
    required this.bio,
    required this.followers,
    required this.following,
    required this.recipesCount,
  });

  // Factory para crear un Chef desde el JSON de Laravel
  factory Chef.fromJson(Map<String, dynamic> json) {
    return Chef(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Chef Desconocido',
      handle: json['handle'] ?? '@chef',
      imageUrl: json['avatar_url'] ?? 'https://via.placeholder.com/150',
      bio: json['descripcion_perfil'] ?? '',
      followers: json['followers_count'] ?? 0,
      following: json['following_count'] ?? 0,
      recipesCount: json['recipes_count'] ?? 0,
    );
  }
}

// --- MODELO RECETA (Para la lista inferior) ---
class Recipe {
  final int id;
  final String title;
  final String imageUrl;
  final int timeMinutes;
  final double rating;

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.timeMinutes,
    required this.rating,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Receta',
      imageUrl: json['imageUrl'] ?? 'https://via.placeholder.com/150',
      timeMinutes: json['timeMinutes'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
    );
  }
}

// --- PANTALLA PRINCIPAL ---
class ChefProfileScreen extends StatefulWidget {
  final int chefId; // ID del chef que queremos ver

  // Por defecto probamos con el ID 1 si no se pasa nada
  const ChefProfileScreen({Key? key, this.chefId = 1}) : super(key: key);

  @override
  State<ChefProfileScreen> createState() => _ChefProfileScreenState();
}

class _ChefProfileScreenState extends State<ChefProfileScreen> {
  // Colores de tu marca
  final Color brandColor = const Color(0xFFFF8E00);
  final Color actionButtonColor = const Color(0xFFFFC107);

  // Estado
  bool _isLoading = true;
  bool _hasError = false;
  late Chef _chef;
  List<Recipe> _recipes = [];

  @override
  void initState() {
    super.initState();
    _fetchChefData();
  }

  // Lógica para obtener datos del backend Laravel
  Future<void> _fetchChefData() async {
    // ⚠️ IMPORTANTE: Cambia esta IP por la de tu servidor Laravel
    // Si usas emulador Android: 10.0.2.2:8000
    // Si usas dispositivo físico: Tu IP local (ej. 192.168.1.X:8000)
    final String baseUrl = 'http://192.168.0.16:18000/api'; 

    try {
      final response = await http.get(Uri.parse('$baseUrl/chefs/${widget.chefId}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _chef = Chef.fromJson(data['chef']);
          _recipes = (data['recetas'] as List).map((r) => Recipe.fromJson(r)).toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Error al cargar perfil');
      }
    } catch (e) {
      print("Error de conexión: $e");
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: brandColor)),
      );
    }

    if (_hasError) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.red),
              SizedBox(height: 10),
              Text("No se pudo conectar con el servidor"),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _hasError = false;
                  });
                  _fetchChefData();
                },
                style: ElevatedButton.styleFrom(backgroundColor: brandColor),
                child: Text("Reintentar"),
              )
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Perfil del Chef",
          style: TextStyle(
            color: brandColor, 
            fontWeight: FontWeight.bold
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: brandColor), 
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            
            // 1. Foto de Perfil
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: brandColor, width: 3), 
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0), 
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(_chef.imageUrl),
                  onBackgroundImageError: (_, __) {},
                  backgroundColor: Colors.grey[200],
                ),
              ),
            ),
            SizedBox(height: 16),

            // 2. Nombre y Handle
            Text(
              _chef.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              _chef.handle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),

            SizedBox(height: 24),

            // 3. Estadísticas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildStatItem("Recetas", _chef.recipesCount.toString(), brandColor),
                Container(height: 30, width: 1, color: Colors.grey[300]),
                _buildStatItem("Seguidores", _chef.followers.toString(), brandColor),
                Container(height: 30, width: 1, color: Colors.grey[300]),
                _buildStatItem("Siguiendo", _chef.following.toString(), brandColor),
              ],
            ),

            SizedBox(height: 24),

            // 4. Botones de Acción
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: brandColor, 
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 12),
                        elevation: 4,
                        shadowColor: brandColor.withOpacity(0.4),
                      ),
                      child: Text("Seguir", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ),
                  ),
                  SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(Icons.mail_outline, color: Colors.black54),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 30),

            // 5. Sección de Recetas
            Container(
              width: double.infinity,
              padding: EdgeInsets.only(top: 24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    offset: Offset(0, -5),
                    blurRadius: 10,
                  )
                ]
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Recetas del Chef",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Icon(Icons.filter_list, color: Colors.grey),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  
                  // Lista Dinámica de Recetas
                  _recipes.isEmpty 
                    ? Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(child: Text("Este chef aún no tiene recetas.")),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _recipes.length,
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          return _buildRecipeCard(_recipes[index], brandColor);
                        },
                      ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: color, 
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeCard(Recipe recipe, Color brandColor) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Imagen de la receta
          Container(
            width: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              image: DecorationImage(
                image: NetworkImage(recipe.imageUrl),
                fit: BoxFit.cover,
                // Manejo de error si la imagen no carga
                onError: (exception, stackTrace) {
                  // Puedes poner un placeholder aquí si quieres
                }
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    recipe.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        "${recipe.timeMinutes} min",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: brandColor),
                      Text(" ${recipe.rating}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: brandColor.withOpacity(0.1),
                  shape: BoxShape.circle
                ),
                child: Icon(Icons.arrow_forward_ios, size: 12, color: brandColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}