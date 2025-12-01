import 'package:flutter/material.dart';
import 'dart:convert'; // Para JSON
import 'package:http/http.dart' as http; // Para conectar con Laravel
import 'asistente_cocina.dart'; 
import 'receta_model.dart';
import 'asistente_voz_modal.dart';
import 'screens/chef/chef_profile_screen.dart';

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
            _buildChefInfo(context), 
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
    );
  }

  Widget _buildEmpezarAhoraButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            _mostrarModalAsistenteVoz(context);
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

  void _mostrarModalAsistenteVoz(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return VoiceAssistantModal(
          onDecision: (bool activarVoz) {
            _navegarAAsistenteCocina(context, activarVoz);
          },
        );
      },
    );
  }

  void _navegarAAsistenteCocina(BuildContext context, bool conAsistenteVoz) {
    final recetaObj = Receta.fromJson(receta);
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AsistenteCocinaScreen(
          receta: recetaObj,
          conAsistenteVoz: conAsistenteVoz,
        ),
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

  Widget _buildChefInfo(BuildContext context) {
    final String nombreChef = receta['chef'] ?? 'Chef Nutrichef';
    final String handleChef = receta['chef_username'] ?? '@nutrichef';
    
    final String imagenChef = receta['chef_image'] ?? 
        'https://ui-avatars.com/api/?name=${Uri.encodeComponent(nombreChef)}&background=ff8e00&color=fff&size=256';

    final int chefId = (receta['id_usuario_creador'] is int) 
            ? receta['id_usuario_creador'] 
            : 1;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChefProfileScreen(
              chefId: chefId,
              placeholderName: nombreChef,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[200],
              backgroundImage: NetworkImage(imagenChef),
              onBackgroundImageError: (_, __) {}, 
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    handleChef,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    nombreChef,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            // Botón Seguir Conectado a BD
            BotonSeguirChef(
              chefId: chefId, 
              nombreChef: nombreChef
            ),

            const SizedBox(width: 8),
            IconButton(
               icon: Icon(Icons.more_vert, color: Colors.grey[600]),
               onPressed: () {}, 
               padding: EdgeInsets.zero,
               constraints: const BoxConstraints(),
            ),
          ],
        ),
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
}

// --- BOTÓN CONECTADO A BASE DE DATOS ---

class BotonSeguirChef extends StatefulWidget {
  final int chefId;
  final String nombreChef;

  const BotonSeguirChef({
    Key? key, 
    required this.chefId,
    required this.nombreChef
  }) : super(key: key);

  @override
  _BotonSeguirChefState createState() => _BotonSeguirChefState();
}

class _BotonSeguirChefState extends State<BotonSeguirChef> {
  bool isFollowing = false;
  bool isLoading = false; // Para evitar doble clic

  // CAMBIA ESTO POR TU IP LOCAL (ej: 192.168.1.5 si usas celular real)
  final String baseUrl = 'http://192.168.0.16:18000/api'; 
  
  // SIMULACIÓN DE USUARIO LOGUEADO (Sácalo de tu AuthProvider luego)
  // Usamos el ID 2 que es 'Usuario Prueba' en tu seeder
  final int currentUserId = 2; 

  @override
  void initState() {
    super.initState();
    _checkInitialStatus();
  }

  // 1. Verificar si ya lo sigo al entrar a la pantalla
  Future<void> _checkInitialStatus() async {
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
      print("Error verificando seguidores: $e");
    }
  }

  // 2. Acción de Seguir / Dejar de Seguir
  Future<void> _toggleFollow() async {
    if (isLoading) return;

    // UI Optimista: Cambiamos el diseño INMEDIATAMENTE para que se sienta rápido
    setState(() {
      isFollowing = !isFollowing;
      isLoading = true;
    });

    try {
      final url = Uri.parse('$baseUrl/seguidores/toggle');
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({
          'id_usuario': currentUserId, // Quien sigue
          'id_usuario_seguido': widget.chefId, // A quien sigue
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Confirmamos el estado real que nos devuelve el servidor
        if (mounted) {
           setState(() {
             isFollowing = data['siguiendo'];
           });
        }
        
        // Feedback visual
        final mensaje = isFollowing 
            ? '¡Ahora sigues a ${widget.nombreChef}!' 
            : 'Dejaste de seguir a ${widget.nombreChef}.';

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(mensaje),
            backgroundColor: isFollowing ? Colors.green : Colors.grey,
            duration: const Duration(seconds: 1),
          ),
        );
      } else {
        // Si falló, revertimos el cambio visual
        if (mounted) {
          setState(() {
            isFollowing = !isFollowing; 
          });
        }
      }
    } catch (e) {
      print("Error al seguir: $e");
      // Si hubo error de red, revertimos
      if (mounted) {
        setState(() {
          isFollowing = !isFollowing;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFollow,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
        decoration: BoxDecoration(
          color: isFollowing ? Colors.white : const Color(0xFFFFD700),
          borderRadius: BorderRadius.circular(20),
          border: isFollowing 
              ? Border.all(color: const Color(0xFFFFD700), width: 2) 
              : null,
          boxShadow: isFollowing 
              ? [] 
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  )
                ],
        ),
        child: Row(
          children: [
            if (isLoading) 
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: SizedBox(
                  width: 12, 
                  height: 12, 
                  child: CircularProgressIndicator(strokeWidth: 2, color: isFollowing ? const Color(0xFFFFD700) : Colors.white)
                ),
              ),
            Text(
              isFollowing ? 'Siguiendo' : 'Seguir',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isFollowing ? const Color(0xFFFFD700) : Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}