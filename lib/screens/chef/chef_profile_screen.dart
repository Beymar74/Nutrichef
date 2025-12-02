import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart'; // Asegúrate de tener esta dependencia

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
  final bool isFollowing;

  Chef({
    required this.id,
    required this.name,
    required this.handle,
    required this.imageUrl,
    required this.bio,
    required this.followers,
    required this.following,
    required this.recipesCount,
    this.isFollowing = false,
  });

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
      isFollowing: json['is_following'] ?? false,
    );
  }

  // Método para clonar y modificar el estado (optimistic UI update)
  Chef copyWith({
    int? id,
    String? name,
    String? handle,
    String? imageUrl,
    String? bio,
    int? followers,
    int? following,
    int? recipesCount,
    bool? isFollowing,
  }) {
    return Chef(
      id: id ?? this.id,
      name: name ?? this.name,
      handle: handle ?? this.handle,
      imageUrl: imageUrl ?? this.imageUrl,
      bio: bio ?? this.bio,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      recipesCount: recipesCount ?? this.recipesCount,
      isFollowing: isFollowing ?? this.isFollowing,
    );
  }
}

// --- MODELO RECETA ---
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
  final int chefId;

  const ChefProfileScreen({Key? key, this.chefId = 1}) : super(key: key);

  @override
  State<ChefProfileScreen> createState() => _ChefProfileScreenState();
}

class _ChefProfileScreenState extends State<ChefProfileScreen> {
  final Color brandColor = const Color(0xFFFF8E00);
  
  // Estado de la pantalla
  bool _isLoading = true;
  bool _hasError = false;
  bool _isFollowLoading = false;
  
  late Chef _chef;
  List<Recipe> _recipes = [];

  // Datos del usuario logueado (quien sigue)
  int? _currentUserId;
  String? _authToken;

  // CONFIGURACIÓN API
  final String baseUrl = 'http://192.168.0.12:18000/api'; 

  @override
  void initState() {
    super.initState();
    _loadUserAndFetchData();
  }

  // 1. Cargar ID del usuario logueado desde SharedPreferences
  Future<void> _loadUserAndFetchData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        // Obtenemos el ID guardado en el Login. Si no existe, es null.
        _currentUserId = prefs.getInt('auth_user_id');
        _authToken = prefs.getString('auth_token');
      });
      
      // Una vez tenemos el ID, pedimos los datos del chef
      await _fetchChefData();
    } catch (e) {
      print("Error cargando preferencias: $e");
      // Intentamos cargar de todas formas
      await _fetchChefData();
    }
  }

  // 2. Obtener datos del Chef y Recetas
  Future<void> _fetchChefData() async {
    try {
      // Enviamos 'follower_id' para que el backend sepa si ya lo seguimos
      String urlStr = '$baseUrl/chefs/${widget.chefId}';
      if (_currentUserId != null) {
        urlStr += '?follower_id=$_currentUserId';
      }

      final response = await http.get(Uri.parse(urlStr));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            _chef = Chef.fromJson(data['chef']);
            _recipes = (data['recetas'] as List).map((r) => Recipe.fromJson(r)).toList();
            _isLoading = false;
          });
        }
      } else {
        throw Exception('Error al cargar perfil: ${response.statusCode}');
      }
    } catch (e) {
      print("Error de conexión: $e");
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
    }
  }

  // 3. Lógica del Botón Seguir
  Future<void> _toggleFollow() async {
    // Validaciones previas
    if (_isFollowLoading) return;
    if (_currentUserId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Debes iniciar sesión para seguir a un chef.")),
      );
      return;
    }

    setState(() => _isFollowLoading = true);

    try {
      final url = Uri.parse('$baseUrl/chefs/${widget.chefId}/follow');
      
      final response = await http.post(
        url,
        body: {
          'follower_id': _currentUserId.toString(),
        },
        // headers: {'Authorization': 'Bearer $_authToken'}, // Si usas headers auth
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Éxito: Actualizamos la UI con los datos reales del servidor
        final bool newStatus = responseData['is_following'];
        final int newFollowersCount = responseData['followers_count'];

        setState(() {
          _chef = _chef.copyWith(
            isFollowing: newStatus,
            followers: newFollowersCount
          );
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? (newStatus ? "Siguiendo" : "Dejaste de seguir")),
            backgroundColor: brandColor,
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        // Error de lógica (ej: seguirse a sí mismo)
        String errorMsg = responseData['message'] ?? 'Error desconocido';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("⚠️ $errorMsg"), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      print("Excepción follow: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error de conexión al intentar seguir.")),
      );
    } finally {
      if (mounted) {
        setState(() => _isFollowLoading = false);
      }
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios, color: brandColor),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 10),
              const Text("No se pudo cargar el perfil"),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _isLoading = true;
                    _hasError = false;
                  });
                  _loadUserAndFetchData();
                },
                style: ElevatedButton.styleFrom(backgroundColor: brandColor),
                child: const Text("Reintentar"),
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
            icon: const Icon(Icons.more_vert, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            
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
            const SizedBox(height: 16),

            // 2. Nombre y Handle
            Text(
              _chef.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              _chef.handle,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),

            const SizedBox(height: 24),

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

            const SizedBox(height: 24),

            // 4. Botones de Acción
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: _toggleFollow, // Función conectada
                      style: ElevatedButton.styleFrom(
                        // Cambia visualmente si ya sigues al usuario
                        backgroundColor: _chef.isFollowing ? Colors.white : brandColor, 
                        foregroundColor: _chef.isFollowing ? brandColor : Colors.white,
                        side: _chef.isFollowing ? BorderSide(color: brandColor, width: 2) : null,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        elevation: _chef.isFollowing ? 0 : 4,
                        shadowColor: brandColor.withOpacity(0.4),
                      ),
                      child: _isFollowLoading 
                        ? SizedBox(
                            height: 20, width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2, 
                              color: _chef.isFollowing ? brandColor : Colors.white
                            )
                          )
                        : Text(
                            _chef.isFollowing ? "Siguiendo" : "Seguir",
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                          ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.mail_outline, color: Colors.black54),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 5. Sección de Recetas
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 24),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    offset: const Offset(0, -5),
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
                        const Text(
                          "Recetas del Chef",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const Icon(Icons.filter_list, color: Colors.grey),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  
                  // Lista Dinámica de Recetas
                  _recipes.isEmpty 
                    ? const Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Center(child: Text("Este chef aún no tiene recetas.")),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _recipes.length,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemBuilder: (context, index) {
                          return _buildRecipeCard(_recipes[index], brandColor);
                        },
                      ),
                  const SizedBox(height: 20),
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
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 4),
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
      margin: const EdgeInsets.only(bottom: 16),
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Imagen de la receta
          Container(
            width: 110,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              child: Image.network(
                recipe.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (ctx, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  child: const Icon(Icons.restaurant, color: Colors.grey),
                ),
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
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(Icons.access_time, size: 14, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(
                        "${recipe.timeMinutes} min",
                        style: const TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: brandColor),
                      Text(" ${recipe.rating}", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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
                padding: const EdgeInsets.all(6),
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