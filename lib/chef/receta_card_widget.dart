import 'package:flutter/material.dart';
import '../models/receta_model.dart';
import 'ver_receta_chef.dart';
import 'editar_receta.dart';

class RecetaCardWidget extends StatelessWidget {
  final Receta receta;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;

  const RecetaCardWidget({
    Key? key,
    required this.receta,
    required this.onEditar,
    required this.onEliminar,
  }) : super(key: key);

  Color get estadoColor {
    String estadoTexto = receta.estado ?? 'BORRADOR';
    switch (estadoTexto) {
      case 'PUBLICADA':
        return const Color(0xFF4CAF50);
      case 'PENDIENTE_REVISION':
        return const Color(0xFFFFA726);
      case 'RECHAZADA':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  IconData get estadoIcon {
    String estadoTexto = receta.estado ?? 'BORRADOR';
    switch (estadoTexto) {
      case 'PUBLICADA':
        return Icons.check_circle;
      case 'PENDIENTE_REVISION':
        return Icons.schedule;
      case 'RECHAZADA':
        return Icons.cancel;
      default:
        return Icons.edit;
    }
  }

  @override
  Widget build(BuildContext context) {
    String estadoTexto = receta.estado ?? 'BORRADOR';

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Contenido principal
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                // Imagen
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    receta.imagen ?? 
                    'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.restaurant, size: 30),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                
                // Información
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              receta.titulo,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8, 
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: estadoColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  estadoIcon,
                                  size: 14,
                                  color: estadoColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  estadoTexto,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: estadoColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        receta.resumen,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _buildInfoChip(
                            Icons.visibility,
                            '${receta.visualizaciones ?? 0}',
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            Icons.star,
                            '${receta.calificacion ?? 0}',
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            Icons.comment,
                            '${receta.totalComentarios ?? 0}',
                          ),
                          const SizedBox(width: 8),
                          _buildInfoChip(
                            Icons.favorite,
                            '${receta.totalFavoritos ?? 0}',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Acciones
          Container(
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VerRecetaChefScreen(
                          receta: receta,
                        ),
                      ),
                    ),
                    icon: const Icon(Icons.visibility, size: 18),
                    label: const Text('Ver'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF2196F3),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 20,
                  color: Colors.grey[300],
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: onEditar,
                    icon: const Icon(Icons.edit, size: 18),
                    label: const Text('Editar'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFFFA726),
                    ),
                  ),
                ),
                Container(
                  width: 1,
                  height: 20,
                  color: Colors.grey[300],
                ),
                Expanded(
                  child: TextButton.icon(
                    onPressed: onEliminar,
                    icon: const Icon(Icons.delete, size: 18),
                    label: const Text('Eliminar'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFFF44336),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 12,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 3),
        Text(
          text,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

// Extensión para el modelo Receta
extension RecetaExtensions on Receta {
  String get estado => 'PUBLICADA';
  int? get visualizaciones => 324;
  double? get calificacion => 4.5;
  int? get totalComentarios => 12;
  int? get totalFavoritos => 45;
}