class Publicacion {
  int id;
  String descripcion;
  List<String> imagenes; // Lista de URLs de imágenes
  Usuario usuario; // Objeto de Usuario (definir este modelo si no lo tienes)
  int likesCount;
  int comentariosCount;
  bool yaDioLike;
  String createdAt;

  Publicacion({
    required this.id,
    required this.descripcion,
    required this.imagenes,
    required this.usuario,
    required this.likesCount,
    required this.comentariosCount,
    required this.yaDioLike,
    required this.createdAt,
  });

  // Crear una Publicacion desde un JSON
  factory Publicacion.fromJson(Map<String, dynamic> json) {
    return Publicacion(
      id: json['id'],
      descripcion: json['descripcion'],
      imagenes: List<String>.from(json['imagenes']),
      usuario: Usuario.fromJson(json['usuario']),
      likesCount: json['likes_count'],
      comentariosCount: json['comentarios_count'],
      yaDioLike: json['ya_dio_like'],
      createdAt: json['created_at'],
    );
  }

  // Convertir Publicacion a JSON para enviar al backend
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'descripcion': descripcion,
      'imagenes': imagenes,
      'usuario': usuario.toJson(),
      'likes_count': likesCount,
      'comentarios_count': comentariosCount,
      'ya_dio_like': yaDioLike,
      'created_at': createdAt,
    };
  }
}

// Modelo de Usuario (simplificado)
class Usuario {
  int id;
  String name;
  String username;
  String avatar;

  Usuario({
    required this.id,
    required this.name,
    required this.username,
    required this.avatar,
  });

  // Crear un Usuario desde un JSON
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      name: json['name'],
      username: json['username'],
      avatar: json['avatar'],
    );
  }

  // Convertir Usuario a JSON para enviar al backend
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'avatar': avatar,
    };
  }
}
