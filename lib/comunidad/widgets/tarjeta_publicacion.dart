import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/comunidad_service.dart';
import 'barra_reacciones.dart';

class TarjetaPublicacion extends StatelessWidget {
  final int idPublicacion;
  final String token; // ✅ Agregar token

  const TarjetaPublicacion({
    Key? key, 
    required this.idPublicacion,
    required this.token, // ✅ Requerir token
  }) : super(key: key);

  // Helper para formatear fecha
  String _formatearFecha(String? fecha) {
    if (fecha == null) return 'Fecha desconocida';
    
    try {
      final dateTime = DateTime.parse(fecha);
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      
      if (difference.inDays > 0) {
        return 'hace ${difference.inDays} día${difference.inDays > 1 ? 's' : ''}';
      } else if (difference.inHours > 0) {
        return 'hace ${difference.inHours} hora${difference.inHours > 1 ? 's' : ''}';
      } else if (difference.inMinutes > 0) {
        return 'hace ${difference.inMinutes} minuto${difference.inMinutes > 1 ? 's' : ''}';
      } else {
        return 'hace un momento';
      }
    } catch (e) {
      return 'Fecha desconocida';
    }
  }

  @override
  Widget build(BuildContext context) {
    final comunidadService = Provider.of<ComunidadService>(context);

    // Buscar la publicación
    final post = comunidadService.posts.firstWhere(
      (post) => post['id'] == idPublicacion,
      orElse: () => {}, // ✅ Evitar error si no se encuentra
    );

    // ✅ Si no se encuentra la publicación
    if (post.isEmpty) {
      return const Card(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Publicación no encontrada'),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ Descripción (en lugar de titulo y contenido)
            Text(
              post['descripcion'] ?? 'Sin descripción',
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            
            // Fecha
            Text(
              'Publicado el ${_formatearFecha(post['created_at'])}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            
            // ✅ Barra de reacciones con token
            BarraReacciones(
              idPublicacion: idPublicacion,
              token: token,
            ),
          ],
        ),
      ),
    );
  }
}