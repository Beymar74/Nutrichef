import 'package:flutter/material.dart';
import '../models/receta_model.dart';

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
        title: const Text(
          'Estadísticas Detalladas',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFFFF8C21),
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Resumen general
            _buildResumenGeneral(),
            
            const SizedBox(height: 25),
            
            // Receta más destacada
            const Text(
              'Recetas Destacadas',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFFEC888D),
              ),
            ),
            const SizedBox(height: 15),
            
            _buildEstadisticaDetalle(
              'Receta más vista',
              recetasPublicadas.isNotEmpty ? 
                recetasPublicadas.first.titulo : 'N/A',
              '${recetasPublicadas.isNotEmpty ? 
                recetasPublicadas.first.visualizaciones : 0} vistas',
              Icons.trending_up,
              const Color(0xFF4CAF50),
            ),
            const SizedBox(height: 15),
            
            _buildEstadisticaDetalle(
              'Mejor calificada',
              recetasPublicadas.isNotEmpty ? 
                recetasPublicadas.first.titulo : 'N/A',
              '⭐ ${calificacionPromedio.toStringAsFixed(1)}',
              Icons.star,
              const Color(0xFFFFA726),
            ),
            const SizedBox(height: 15),
            
            _buildEstadisticaDetalle(
              'Más comentada',
              recetasPublicadas.isNotEmpty ? 
                recetasPublicadas.first.titulo : 'N/A',
              '${recetasPublicadas.isNotEmpty ? 
                recetasPublicadas.first.totalComentarios : 0} comentarios',
              Icons.comment,
              const Color(0xFF2196F3),
            ),
            const SizedBox(height: 15),
            
            _buildEstadisticaDetalle(
              'Más favoritos',
              recetasPublicadas.isNotEmpty ? 
                recetasPublicadas.first.titulo : 'N/A',
              '${recetasPublicadas.isNotEmpty ? 
                recetasPublicadas.first.totalFavoritos : 0} favoritos',
              Icons.favorite,
              const Color(0xFFEC888D),
            ),
            
            const SizedBox(height: 30),
            
            // Gráfico de distribución (placeholder)
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
        gradient: const LinearGradient(
          colors: [Color(0xFFFF8C21), Color(0xFFFFB84D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF8C21).withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            'Resumen General',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildEstadistica(
                Icons.visibility,
                totalVisualizaciones.toString(),
                'Vistas',
              ),
              _buildEstadistica(
                Icons.star,
                calificacionPromedio.toStringAsFixed(1),
                'Rating',
              ),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildEstadistica(
                Icons.comment,
                totalComentarios.toString(),
                'Comentarios',
              ),
              _buildEstadistica(
                Icons.favorite,
                totalFavoritos.toString(),
                'Favoritos',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEstadistica(IconData icon, String valor, String titulo) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          valor,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          titulo,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildEstadisticaDetalle(
    String titulo,
    String subtitulo,
    String valor,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitulo,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            valor,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
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
        border: Border.all(
          color: Colors.grey[200]!,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Distribución de Recetas',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildDistribucionItem(
                'Total',
                misRecetas.length,
                const Color(0xFFFF8C21),
              ),
              _buildDistribucionItem(
                'Publicadas',
                recetasPublicadas.length,
                const Color(0xFF4CAF50),
              ),
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
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
            border: Border.all(
              color: color,
              width: 3,
            ),
          ),
          child: Center(
            child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }
}