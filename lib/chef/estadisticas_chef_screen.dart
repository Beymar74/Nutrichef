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
      appBar: AppBar(
        title: const Text('Estadísticas', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFFF8C21),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen General
            _buildResumenGeneral(),
            
            const SizedBox(height: 25),
            const Text(
              'Recetas Destacadas',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFFEC888D)),
            ),
            const SizedBox(height: 15),
            
            // Lógica para encontrar la mejor receta (si hay publicadas)
            if (recetasPublicadas.isNotEmpty) ...[
              // Receta más vista (ordenamos y tomamos la primera)
              Builder(builder: (context) {
                var masVista = List<Receta>.from(recetasPublicadas)
                  ..sort((a, b) => (b.visualizaciones ?? 0).compareTo(a.visualizaciones ?? 0));
                var top = masVista.first;
                return _buildEstadisticaDetalle(
                  'Más popular (Vistas)',
                  top.titulo,
                  '${top.visualizaciones ?? 0} vistas',
                  Icons.trending_up,
                  const Color(0xFF4CAF50),
                );
              }),
              const SizedBox(height: 15),

              // Receta con más likes/favoritos
              Builder(builder: (context) {
                var masLikes = List<Receta>.from(recetasPublicadas)
                  ..sort((a, b) => (b.totalFavoritos ?? 0).compareTo(a.totalFavoritos ?? 0));
                var top = masLikes.first;
                return _buildEstadisticaDetalle(
                  'Favorita del público',
                  top.titulo,
                  '${top.totalFavoritos ?? 0} ❤️',
                  Icons.favorite,
                  const Color(0xFFEC888D),
                );
              }),
            ] else
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(20),
                  child: Text("Publica recetas para ver destacados", style: TextStyle(color: Colors.grey)),
                ),
              ),

            const SizedBox(height: 30),
            _buildDistribucionRecetas(),
          ],
        ),
      ),
    );
  }

  Widget _buildResumenGeneral() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFF8C21), Color(0xFFFFB84D)]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: const Color(0xFFFF8C21).withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8)),
        ],
      ),
      child: Column(
        children: [
          const Text('Resumen General', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildEstadistica(Icons.visibility, totalVisualizaciones.toString(), 'Vistas'),
              _buildEstadistica(Icons.star, calificacionPromedio.toStringAsFixed(1), 'Rating'),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildEstadistica(Icons.comment, totalComentarios.toString(), 'Comentarios'),
              _buildEstadistica(Icons.favorite, totalFavoritos.toString(), 'Favoritos'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEstadistica(IconData icon, String valor, String titulo) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        Text(valor, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold)),
        Text(titulo, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildEstadisticaDetalle(String titulo, String subtitulo, String valor, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(titulo, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                Text(subtitulo, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Text(valor, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
        ],
      ),
    );
  }

  Widget _buildDistribucionRecetas() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Distribución', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDistribucionItem('Total', misRecetas.length, const Color(0xFFFF8C21)),
              _buildDistribucionItem('Publicadas', recetasPublicadas.length, const Color(0xFF4CAF50)),
              _buildDistribucionItem('Borradores', misRecetas.length - recetasPublicadas.length, Colors.grey),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDistribucionItem(String label, int value, Color color) {
    return Column(
      children: [
        Container(
          width: 60, height: 60,
          decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle, border: Border.all(color: color, width: 3)),
          child: Center(child: Text(value.toString(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color))),
        ),
        const SizedBox(height: 8),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      ],
    );
  }
}