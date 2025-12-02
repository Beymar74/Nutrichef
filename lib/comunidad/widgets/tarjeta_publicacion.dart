import 'package:flutter/material.dart';
import 'barra_reacciones.dart';
import 'menu_opciones_post.dart';
import '../screens/detalle_publicacion.dart';

class TarjetaPublicacion extends StatelessWidget {
  final Map<String, dynamic> publicacion;
  final Map<String, dynamic> usuario;
  final VoidCallback? onUpdate;

  const TarjetaPublicacion({
    Key? key,
    required this.publicacion,
    required this.usuario,
    this.onUpdate,
  }) : super(key: key);

  String _formatearFecha(String fecha) {
    final date = DateTime.parse(fecha);
    final diff = DateTime.now().difference(date);

    if (diff.inDays > 0) return "hace ${diff.inDays} día(s)";
    if (diff.inHours > 0) return "hace ${diff.inHours} hora(s)";
    if (diff.inMinutes > 0) return "hace ${diff.inMinutes} minuto(s)";
    return "hace un momento";
  }

  @override
  Widget build(BuildContext context) {
    final imagenes = publicacion['imagenes'] as List? ?? [];

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
      elevation: 2,
      child: InkWell(
        // ✅ Toda la tarjeta es clickeable para ir al detalle
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DetallePublicacionScreen(
                idPublicacion: publicacion['id'],
                usuario: usuario,
              ),
            ),
          ).then((_) {
            // ✅ Refrescar al volver
            if (onUpdate != null) onUpdate!();
          });
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===============================
              // CABECERA: Avatar + Usuario + Menú
              // ===============================
              Row(
                children: [
                  CircleAvatar(
                    radius: 22,
                    backgroundImage: publicacion['usuario']['avatar'] != null
                        ? NetworkImage(publicacion['usuario']['avatar'])
                        : null,
                    backgroundColor: Colors.orange,
                    child: publicacion['usuario']['avatar'] == null
                        ? Text(
                            publicacion['usuario']['name'][0].toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : null,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          publicacion['usuario']['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          publicacion['usuario']['username'] ?? '@usuario',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // ✅ Menú de opciones mejorado
                  MenuOpcionesPost(
                    idPublicacion: publicacion['id'],
                    idUsuarioPost: publicacion['usuario']['id'],
                    usuario: usuario,
                    onUpdate: onUpdate,
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // ===============================
              // DESCRIPCIÓN
              // ===============================
              Text(
                publicacion['descripcion'],
                style: const TextStyle(fontSize: 15),
                maxLines: 5,
                overflow: TextOverflow.ellipsis,
              ),

              const SizedBox(height: 12),

              // ===============================
              // IMÁGENES (Galería horizontal)
              // ===============================
              if (imagenes.isNotEmpty)
                SizedBox(
                  height: 160,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: imagenes.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: const EdgeInsets.only(right: 10),
                        width: 160,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image: NetworkImage(imagenes[index]),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 10),

              // ===============================
              // FECHA
              // ===============================
              Text(
                _formatearFecha(publicacion['created_at']),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),

              const Divider(height: 20),

              // ===============================
              // BARRA DE REACCIONES
              // ===============================
              BarraReacciones(
                idPublicacion: publicacion['id'],
                usuario: usuario,
                likesCount: publicacion['likes_count'] ?? 0,
                comentariosCount: publicacion['comentarios_count'] ?? 0,
                yaDioLike: publicacion['ya_dio_like'] ?? false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}