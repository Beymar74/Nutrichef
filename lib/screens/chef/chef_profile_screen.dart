import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; // Habilitamos http para la API

// --- MODELOS ---
class ChefData {
  final String name;
  final String handle;
  final String imageUrl;
  final String bio;
  final int followers;
  final int following;
  final int recipesCount;
  final List<RecetaSummary> recetas;

  ChefData({
    required this.name,
    required this.handle,
    required this.imageUrl,
    required this.bio,
    required this.followers,
    required this.following,
    required this.recipesCount,
    required this.recetas,
  });

  factory ChefData.fromJson(Map<String, dynamic> json) {
    final chef = json['chef'];
    final stats = chef['stats'];
    return ChefData(
      name: chef['name'],
      handle: chef['handle'],
      imageUrl: chef['imagen'],
      bio: chef['bio'],
      followers: stats['seguidores'],
      following: stats['siguiendo'],
      recipesCount: stats['recetas'],
      recetas: (json['recetas'] as List)
          .map((r) => RecetaSummary.fromJson(r))
          .toList(),
    );
  }
}

class RecetaSummary {
  final int id;
  final String title;
  final String time;
  final double rating;
  final String imageUrl;

  RecetaSummary({
    required this.id,
    required this.title,
    required this.time,
    required this.rating,
    required this.imageUrl,
  });

  factory RecetaSummary.fromJson(Map<String, dynamic> json) {
    return RecetaSummary(
      id: json['id'],
      title: json['titulo'],
      time: json['tiempo'],
      // Manejo seguro de números (puede venir int o double)
      rating: (json['rating'] is int) 
          ? (json['rating'] as int).toDouble() 
          : (json['rating'] as double),
      imageUrl: json['imagen'],
    );
  }
}

// --- PANTALLA ---
class ChefProfileScreen extends StatefulWidget {
  final int chefId;
  final String? placeholderName;

  const ChefProfileScreen({
    Key? key, 
    required this.chefId, 
    this.placeholderName
  }) : super(key: key);

  @override
  _ChefProfileScreenState createState() => _ChefProfileScreenState();
}

class _ChefProfileScreenState extends State<ChefProfileScreen> {
  late Future<ChefData> _chefFuture;
  final Color brandColor = const Color(0xFFFF8E00);

  // ESTADO PARA SEGUIR/DEJAR DE SEGUIR
  bool isFollowing = false;
  bool isFollowLoading = false;
  
  // CONFIGURACIÓN API (Tu IP corregida)
  final String baseUrl = 'http://192.168.0.16:18000/api'; 
  final int currentUserId = 2; // ID simulado del usuario logueado

  @override
  void initState() {
    super.initState();
    _chefFuture = _fetchChefData(widget.chefId);
    _checkFollowStatus(); 
  }

  // --- 1. VERIFICAR ESTADO INICIAL ---
  Future<void> _checkFollowStatus() async {
    try {
      final url = Uri.parse('$baseUrl/seguidores/status?id_usuario=$currentUserId&id_usuario_seguido=${widget.chefId}');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            isFollowing = data['siguiendo'];
          });
        }
      }
    } catch (e) {
      print("Error verificando estado follow en perfil: $e");
    }
  }

  // --- 2. ACCIÓN DE SEGUIR (TOGGLE) ---
  Future<void> _toggleFollow(String chefName) async {
    if (isFollowLoading) return;

    setState(() {
      isFollowing = !isFollowing;
      isFollowLoading = true;
    });

    try {
      final url = Uri.parse('$baseUrl/seguidores/toggle');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'id_usuario': currentUserId,
          'id_usuario_seguido': widget.chefId,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
           setState(() {
             isFollowing = data['siguiendo'];
           });
        }
        
        final mensaje = isFollowing 
            ? '¡Ahora sigues a $chefName!' 
            : 'Dejaste de seguir a $chefName.';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(mensaje),
            backgroundColor: isFollowing ? Colors.green : Colors.grey,
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        if (mounted) setState(() => isFollowing = !isFollowing);
      }
    } catch (e) {
      print("Error al seguir en perfil: $e");
      if (mounted) setState(() => isFollowing = !isFollowing);
    } finally {
      if (mounted) setState(() => isFollowLoading = false);
    }
  }

  // --- 3. CARGA DE DATOS REALES (CHEF + RECETAS) ---
  Future<ChefData> _fetchChefData(int id) async {
    final url = Uri.parse('$baseUrl/chefs/$id');
    print("Obteniendo datos del chef: $url");

    try {
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        // Convertimos el JSON real de Laravel a nuestro modelo
        return ChefData.fromJson(json.decode(response.body));
      } else {
        print("Error del servidor: ${response.statusCode} - ${response.body}");
        throw Exception('Error al cargar perfil del chef');
      }
    } catch (e) {
      print("Excepción de red: $e");
      // Opcional: Retornar datos mock si falla la red para pruebas offline
      // return _getMockData(id); 
      throw e; 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Perfil del Chef",
          style: TextStyle(color: brandColor, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: brandColor),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<ChefData>(
        future: _chefFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: brandColor));
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 48, color: Colors.grey),
                  SizedBox(height: 16),
                  Text("No se pudo cargar el perfil"),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _chefFuture = _fetchChefData(widget.chefId);
                      });
                    }, 
                    child: Text("Reintentar", style: TextStyle(color: brandColor))
                  )
                ],
              )
            );
          } else if (!snapshot.hasData) {
            return Center(child: Text("Chef no encontrado"));
          }

          final chef = snapshot.data!;

          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 10),
                // 1. Foto
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: brandColor, width: 3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(chef.imageUrl),
                      backgroundColor: Colors.grey[200],
                      onBackgroundImageError: (_, __) {},
                    ),
                  ),
                ),
                SizedBox(height: 16),

                // 2. Info
                Text(
                  chef.name,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
                ),
                Text(
                  chef.handle,
                  style: TextStyle(fontSize: 16, color: Colors.grey, fontWeight: FontWeight.w500),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  child: Text(
                    chef.bio,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),

                SizedBox(height: 24),

                // 3. Stats
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildStatItem("Recetas", chef.recipesCount.toString()),
                    Container(height: 30, width: 1, color: Colors.grey[300]),
                    _buildStatItem("Seguidores", chef.followers.toString()), 
                    Container(height: 30, width: 1, color: Colors.grey[300]),
                    _buildStatItem("Siguiendo", chef.following.toString()),
                  ],
                ),

                SizedBox(height: 24),

                // 4. Botones DE ACCIÓN
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => _toggleFollow(chef.name),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isFollowing ? Colors.white : brandColor,
                            foregroundColor: isFollowing ? brandColor : Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: isFollowing ? BorderSide(color: brandColor, width: 2) : BorderSide.none,
                            ),
                            padding: EdgeInsets.symmetric(vertical: 12),
                            elevation: isFollowing ? 0 : 4,
                          ),
                          child: isFollowLoading 
                            ? SizedBox(
                                width: 20, 
                                height: 20, 
                                child: CircularProgressIndicator(strokeWidth: 2, color: isFollowing ? brandColor : Colors.white)
                              )
                            : Text(
                                isFollowing ? "Siguiendo" : "Seguir", 
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                              ),
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

                // 5. Lista de Recetas (Dinámica)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(top: 24),
                  decoration: BoxDecoration(
                    color: Colors.grey[50],
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40),
                    ),
                    boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -5))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
                        child: Text(
                          "Recetas del Chef (${chef.recipesCount})",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 16),
                      
                      chef.recetas.isEmpty 
                      ? Padding(
                          padding: EdgeInsets.all(30),
                          child: Center(
                            child: Column(
                              children: [
                                Icon(Icons.restaurant_menu, size: 40, color: Colors.grey[400]),
                                SizedBox(height: 8),
                                Text("Este chef aún no tiene recetas.", style: TextStyle(color: Colors.grey[600])),
                              ],
                            )
                          ),
                        )
                      : ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: chef.recetas.length,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          itemBuilder: (context, index) {
                            return _buildRecipeCard(chef.recetas[index]);
                          },
                        ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 14, color: brandColor, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildRecipeCard(RecetaSummary receta) {
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      height: 110,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
              image: DecorationImage(
                image: NetworkImage(receta.imageUrl),
                fit: BoxFit.cover,
                onError: (_, __) {}, // Manejo de error de imagen
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
                    receta.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(receta.time, style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: brandColor),
                      Text(" ${receta.rating}", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}