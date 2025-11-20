class Publicacion {
  final int id;
  final String titulo;
  final String? imagen;
  final String? autor;
  final int likes;
  final int comentarios;
  final String? resumen;
  final String? contenido;

  Publicacion({
    required this.id,
    required this.titulo,
    this.imagen,
    this.autor,
    this.likes = 0,
    this.comentarios = 0,
    this.resumen,
    this.contenido,
  });

  factory Publicacion.fromJson(Map<String, dynamic> json) {
    return Publicacion(
      id: json['id'],
      titulo: json['titulo'] ?? '',
      imagen: json['imagen'],
      autor: json['autor'],
      likes: json['likes'] ?? 0,
      comentarios: json['comentarios'] ?? 0,
      resumen: json['resumen'],
      contenido: json['contenido'],
    );
  }
}
