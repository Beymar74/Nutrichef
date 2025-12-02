import 'package:flutter/material.dart';
import 'editar_perfil_chef_screen.dart';
import 'configuracion_chef_screen.dart';

class PerfilChefScreen extends StatelessWidget {
  final String nombreChef;
  final int chefId;
  final String emailChef;
  final int totalRecetas;
  final int recetasPublicadas;
  final double calificacionPromedio;

  const PerfilChefScreen({
    Key? key,
    required this.nombreChef,
    required this.chefId,
    required this.emailChef,
    required this.totalRecetas,
    required this.recetasPublicadas,
    required this.calificacionPromedio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Mi Perfil',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFFF8C21),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Avatar grande
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF8C21), Color(0xFFFFB84D)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF8C21).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.restaurant_menu,
                color: Colors.white,
                size: 60,
              ),
            ),
            const SizedBox(height: 20),
            
            // Nombre
            Text(
              nombreChef,
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFFEC888D),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            
            // Email
            Text(
              emailChef,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            
            // Badge de chef
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD54F),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Text(
                '👨‍🍳 Chef Profesional',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 40),
            
            // Información del usuario
            _buildInfoTile(
              Icons.badge,
              'ID de Chef',
              chefId.toString(),
            ),
            _buildInfoTile(
              Icons.restaurant,
              'Recetas Totales',
              totalRecetas.toString(),
            ),
            _buildInfoTile(
              Icons.check_circle,
              'Recetas Publicadas',
              recetasPublicadas.toString(),
            ),
            _buildInfoTile(
              Icons.star,
              'Calificación Promedio',
              calificacionPromedio.toStringAsFixed(1),
            ),
            
            const SizedBox(height: 30),
            
            // Botones de acción
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _mostrarEditarPerfil(context);
                },
                icon: const Icon(Icons.edit),
                label: const Text('Editar Perfil'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF8C21),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 15),
            
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  _mostrarConfiguracion(context);
                },
                icon: const Icon(Icons.settings),
                label: const Text('Configuración'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFFF8C21),
                  side: const BorderSide(
                    color: Color(0xFFFF8C21),
                    width: 2,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 15),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  _cerrarSesion(context);
                },
                icon: const Icon(Icons.logout),
                label: const Text('Cerrar Sesión'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF44336),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF8C21).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: const Color(0xFFFF8C21),
              size: 20,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[700],
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEC888D),
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarEditarPerfil(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarPerfilChefScreen(
          nombreChef: nombreChef,
          emailChef: emailChef,
        ),
      ),
    ).then((actualizado) {
      if (actualizado == true) {
        // Aquí podrías recargar los datos del perfil si se actualizó
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perfil actualizado'),
            backgroundColor: Color(0xFF4CAF50),
          ),
        );
      }
    });
  }

  void _mostrarConfiguracion(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ConfiguracionChefScreen(),
      ),
    );
  }

  void _cerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.logout,
              color: Color(0xFFF44336),
              size: 28,
            ),
            SizedBox(width: 10),
            Text('Cerrar Sesión'),
          ],
        ),
        content: const Text(
          '¿Estás seguro de que deseas cerrar sesión?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              // Aquí iría la lógica de cerrar sesión
              // Por ahora solo navegamos de vuelta al login
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF44336),
            ),
            child: const Text(
              'Cerrar Sesión',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}