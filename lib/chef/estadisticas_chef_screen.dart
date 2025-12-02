import 'package:flutter/material.dart';
import 'models/chef_receta_model.dart'; // ✅ Importa el modelo correcto

class EstadisticasChefScreen extends StatelessWidget {
  final List<Receta> misRecetas;
  final List<Receta> recetasPublicadas;
  final int totalVisualizaciones;
  final double calificacionPromedio;
  final int totalComentarios;
  final int totalFavoritos;

  const EstadisticasChefScreen({
    Key? key,
    required this.misRecetas,
    required this.recetasPublicadas,
    required this.totalVisualizaciones,
    required this.calificacionPromedio,
    required this.totalComentarios,
    required this.totalFavoritos,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Estadísticas', style: TextStyle(color: Colors.white)), backgroundColor: Colors.orange),
      body: Center(child: Text("Estadísticas (Implementación visual completa en archivo anterior)")),
    );
  }
}