import 'package:flutter/material.dart';

// --- MODELO (Puedes moverlo a un archivo separado si prefieres) ---
class Chef {
  final String name;
  final String handle;
  final String imageUrl;
  final String bio;
  final int followers;
  final int following;
  final int recipesCount;

  Chef({
    required this.name,
    required this.handle,
    required this.imageUrl,
    required this.bio,
    required this.followers,
    required this.following,
    required this.recipesCount,
  });
}

// --- PANTALLA DE PERFIL DEL CHEF ---
class ChefProfileScreen extends StatelessWidget {
  final Chef chef;

  const ChefProfileScreen({Key? key, required this.chef}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // EL COLOR DE TU MARCA (#ff8e00)
    final Color brandColor = const Color(0xFFFF8E00);
    // Un amarillo para botones secundarios (basado en tus capturas),
    // o puedes cambiarlo a brandColor si prefieres todo naranja.
    final Color actionButtonColor = const Color(0xFFFFC107);

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
          icon: Icon(Icons.arrow_back_ios, color: brandColor), // Flecha naranja
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
            // 1. Foto de Perfil Grande con borde de tu color
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: brandColor, width: 3), // Borde Naranja
              ),
              child: Padding(
                padding: const EdgeInsets.all(4.0), // Espacio blanco entre borde y foto
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(chef.imageUrl),
                  onBackgroundImageError: (_, __) {},
                  backgroundColor: Colors.grey[200],
                ),
              ),
            ),
            SizedBox(height: 16),

            // 2. Nombre y Handle
            Text(
              chef.name,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            Text(
              chef.handle,
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
                _buildStatItem("Recetas", chef.recipesCount.toString(), brandColor),
                Container(height: 30, width: 1, color: Colors.grey[300]),
                _buildStatItem("Seguidores", "${chef.followers}k", brandColor),
                Container(height: 30, width: 1, color: Colors.grey[300]),
                _buildStatItem("Siguiendo", chef.following.toString(), brandColor),
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
                        backgroundColor: brandColor, // Botón Seguir NARANJA
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
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: 4,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    itemBuilder: (context, index) {
                      return _buildRecipeCard(index, brandColor);
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
            color: color, // Etiqueta en Naranja
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildRecipeCard(int index, Color brandColor) {
    // Nombres falsos para la demo
    final titles = ["Ensalada Quinoa", "Pasta al Pesto", "Tacos Veganos", "Smoothie Tropical"];
    final times = ["20 min", "15 min", "25 min", "10 min"];

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
          Container(
            width: 110,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                bottomLeft: Radius.circular(20),
              ),
              image: DecorationImage(
                image: NetworkImage("https://picsum.photos/300/300?random=$index"),
                fit: BoxFit.cover,
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
                    titles[index],
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Icon(Icons.access_time, size: 14, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        times[index],
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                    ],
                  ),
                  Spacer(),
                  Row(
                    children: [
                      Icon(Icons.star, size: 16, color: brandColor), // Estrella naranja
                      Text(" 4.8", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
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