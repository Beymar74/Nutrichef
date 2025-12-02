import 'package:flutter/material.dart';
import 'models/chef_receta_model.dart'; // ✅ Importa el modelo correcto

class RecetaCardWidget extends StatelessWidget {
  final Receta receta;
  final VoidCallback onEditar;
  final VoidCallback onEliminar;
  final VoidCallback? onTap;

  const RecetaCardWidget({
    Key? key,
    required this.receta,
    required this.onEditar,
    required this.onEliminar,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.1), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 2))],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      receta.imagenUrl ?? 'https://i.imgur.com/Xqg9f05.png',
                      width: 80, height: 80, fit: BoxFit.cover,
                      errorBuilder: (ctx, err, stack) => Container(width: 80, height: 80, color: Colors.grey[300], child: const Icon(Icons.restaurant, color: Colors.grey)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(child: Text(receta.titulo, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis)),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: receta.colorEstado.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
                              child: Text(receta.textoEstado, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: receta.colorEstado)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(receta.resumen ?? 'Sin descripción', style: TextStyle(fontSize: 12, color: Colors.grey[600]), maxLines: 2, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 8),
                        Row(children: [
                          _iconText(Icons.visibility, '${receta.visualizaciones ?? 0}'), const SizedBox(width: 8),
                          _iconText(Icons.star, '${(receta.calificacion ?? 0).toStringAsFixed(1)}'), const SizedBox(width: 8),
                          _iconText(Icons.favorite, '${receta.totalFavoritos ?? 0}'),
                        ]),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(color: Colors.grey[50], borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16))),
              child: Row(
                children: [
                  Expanded(child: TextButton.icon(onPressed: onTap, icon: const Icon(Icons.visibility, size: 18), label: const Text('Ver'), style: TextButton.styleFrom(foregroundColor: Colors.blue))),
                  Container(width: 1, height: 20, color: Colors.grey[300]),
                  Expanded(child: TextButton.icon(onPressed: onEditar, icon: const Icon(Icons.edit, size: 18), label: const Text('Editar'), style: TextButton.styleFrom(foregroundColor: Colors.orange))),
                  Container(width: 1, height: 20, color: Colors.grey[300]),
                  Expanded(child: TextButton.icon(onPressed: onEliminar, icon: const Icon(Icons.delete, size: 18), label: const Text('Eliminar'), style: TextButton.styleFrom(foregroundColor: Colors.red))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _iconText(IconData i, String t) => Row(children: [Icon(i, size: 12, color: Colors.grey), const SizedBox(width: 2), Text(t, style: const TextStyle(fontSize: 11, color: Colors.grey))]);
}