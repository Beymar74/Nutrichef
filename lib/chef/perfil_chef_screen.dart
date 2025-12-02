import 'package:flutter/material.dart';
import '../../login.dart'; // ✅ Importamos la pantalla de Login (ajusta el nombre del archivo si es necesario)
import 'editar_perfil_chef_screen.dart';
import 'configuracion_chef_screen.dart';

class PerfilChefScreen extends StatefulWidget {
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
  State<PerfilChefScreen> createState() => _PerfilChefScreenState();
}

class _PerfilChefScreenState extends State<PerfilChefScreen> {
  late String _nombreActual;
  late String _emailActual;

  @override
  void initState() {
    super.initState();
    _nombreActual = widget.nombreChef;
    _emailActual = widget.emailChef;
  }

  void _regresarConDatos() {
    Navigator.pop(context, {
      'nombre': _nombreActual,
      'email': _emailActual,
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) {
        if (didPop) return;
        _regresarConDatos();
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Mi Perfil', style: TextStyle(color: Colors.white)),
          backgroundColor: const Color(0xFFFF8C21),
          iconTheme: const IconThemeData(color: Colors.white),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: _regresarConDatos,
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Container(
                width: 120, height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(colors: [Color(0xFFFF8C21), Color(0xFFFFB84D)]),
                  boxShadow: [BoxShadow(color: const Color(0xFFFF8C21).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))],
                ),
                child: const Icon(Icons.restaurant_menu, color: Colors.white, size: 60),
              ),
              const SizedBox(height: 20),
              
              Text(_nombreActual, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFFEC888D)), textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text(_emailActual, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
              
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: const Color(0xFFFFD54F), borderRadius: BorderRadius.circular(20)),
                child: const Text('👨‍🍳 Chef Profesional', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 40),
              _buildInfoTile(Icons.badge, 'ID de Chef', widget.chefId.toString()),
              _buildInfoTile(Icons.restaurant, 'Recetas Totales', widget.totalRecetas.toString()),
              _buildInfoTile(Icons.check_circle, 'Recetas Publicadas', widget.recetasPublicadas.toString()),
              _buildInfoTile(Icons.star, 'Calificación Promedio', widget.calificacionPromedio.toStringAsFixed(1)),
              const SizedBox(height: 30),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _mostrarEditarPerfil(context),
                  icon: const Icon(Icons.edit),
                  label: const Text('Editar Perfil'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF8C21), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _mostrarConfiguracion(context),
                  icon: const Icon(Icons.settings),
                  label: const Text('Configuración'),
                  style: OutlinedButton.styleFrom(foregroundColor: const Color(0xFFFF8C21), side: const BorderSide(color: Color(0xFFFF8C21), width: 2), padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _cerrarSesion(context),
                  icon: const Icon(Icons.logout),
                  label: const Text('Cerrar Sesión'),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF44336), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(color: Colors.grey[50], borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey[200]!)),
      child: Row(children: [
        Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: const Color(0xFFFF8C21).withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: const Color(0xFFFF8C21), size: 20)),
        const SizedBox(width: 15),
        Expanded(child: Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[700]))),
        Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFFEC888D))),
      ]),
    );
  }

  void _mostrarEditarPerfil(BuildContext context) async {
    final resultado = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditarPerfilChefScreen(
          chefId: widget.chefId,
          nombreChef: _nombreActual,
          emailChef: _emailActual,
        ),
      ),
    );

    if (resultado != null && resultado is Map) {
      setState(() {
        if (resultado.containsKey('nombre')) _nombreActual = resultado['nombre'];
        if (resultado.containsKey('email')) _emailActual = resultado['email'];
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Perfil actualizado'), backgroundColor: Color(0xFF4CAF50)));
    }
  }

  void _mostrarConfiguracion(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) => const ConfiguracionChefScreen()));
  }

  void _cerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(children: [Icon(Icons.logout, color: Color(0xFFF44336)), SizedBox(width: 10), Text('Cerrar Sesión')]),
        content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Cerrar diálogo
              
              // ✅ Redirigir a Login y eliminar historial
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const Login()), // Asegúrate que LoginScreen es el nombre correcto de tu clase en login.dart
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFF44336)),
            child: const Text('Cerrar Sesión', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}