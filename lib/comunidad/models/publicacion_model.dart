class Publicacion {
  final int id;
  final String descripcion;
  final List<String> imagenes;
  final Usuario usuario;
  final int likesCount;
  final int comentariosCount;
  final bool yaDioLike;
  final String createdAt;

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

  // ✅ Crear una Publicacion desde un JSON con manejo de nulos
  factory Publicacion.fromJson(Map<String, dynamic> json) {
    return Publicacion(
      id: json['id'] ?? 0,
      descripcion: json['descripcion'] ?? '',
      imagenes: (json['imagenes'] as List?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      usuario: Usuario.fromJson(json['usuario'] ?? {}),
      likesCount: json['likes_count'] ?? 0,
      comentariosCount: json['comentarios_count'] ?? 0,
      yaDioLike: json['ya_dio_like'] ?? false,
      createdAt: json['created_at'] ?? '',
    );
  }

  // ✅ Convertir Publicacion a JSON
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

  // ✅ Método copyWith para actualizaciones inmutables
  Publicacion copyWith({
    int? id,
    String? descripcion,
    List<String>? imagenes,
    Usuario? usuario,
    int? likesCount,
    int? comentariosCount,
    bool? yaDioLike,
    String? createdAt,
  }) {
    return Publicacion(
      id: id ?? this.id,
      descripcion: descripcion ?? this.descripcion,
      imagenes: imagenes ?? this.imagenes,
      usuario: usuario ?? this.usuario,
      likesCount: likesCount ?? this.likesCount,
      comentariosCount: comentariosCount ?? this.comentariosCount,
      yaDioLike: yaDioLike ?? this.yaDioLike,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

// ===============================
// MODELO DE USUARIO
// ===============================
class Usuario {
  final int id;
  final String name;
  final String username;
  final String? avatar; // ✅ Nullable porque puede no tener avatar

  Usuario({
    required this.id,
    required this.name,
    required this.username,
    this.avatar,
  });

  // ✅ Crear un Usuario desde un JSON con manejo de nulos
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Usuario desconocido',
      username: json['username'] ?? '@usuario',
      avatar: json['avatar'], // Puede ser null
    );
  }

  // ✅ Convertir Usuario a JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'username': username,
      'avatar': avatar,
    };
  }

  // ✅ Método copyWith para actualizaciones inmutables
  Usuario copyWith({
    int? id,
    String? name,
    String? username,
    String? avatar,
  }) {
    return Usuario(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      avatar: avatar ?? this.avatar,
    );
  }
}

// ===============================
// MODELO DE COMENTARIO (OPCIONAL)
// ===============================
class Comentario {
  final int id;
  final String contenido;
  final Usuario usuario;
  final String createdAt;
  final bool esPropio;

  Comentario({
    required this.id,
    required this.contenido,
    required this.usuario,
    required this.createdAt,
    this.esPropio = false,
  });

  factory Comentario.fromJson(Map<String, dynamic> json) {
    return Comentario(
      id: json['id'] ?? 0,
      contenido: json['contenido'] ?? '',
      usuario: Usuario.fromJson(json['usuario'] ?? {}),
      createdAt: json['created_at'] ?? '',
      esPropio: json['es_propio'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'contenido': contenido,
      'usuario': usuario.toJson(),
      'created_at': createdAt,
      'es_propio': esPropio,
    };
  }
}