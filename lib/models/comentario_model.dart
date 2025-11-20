class Comentario {
  final int id;
  final String texto;
  final String autor;
  final String fecha;

  Comentario({
    required this.id,
    required this.texto,
    required this.autor,
    required this.fecha,
  });

  factory Comentario.fromJson(Map<String, dynamic> json) {
    return Comentario(
      id: json['id'],
      texto: json['texto'] ?? '',
      autor: json['autor'] ?? '',
      fecha: json['fecha'] ?? '',
    );
  }
}
