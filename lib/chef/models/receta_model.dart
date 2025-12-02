class Receta {
  int? id;
  int idUsuarioCreador;
  int idEstado; // FK a subdominios
  int idTipoAlimento; // FK a subdominios
  String titulo;
  String? resumen;
  int? tiempoPreparacion; // en minutos
  String preparacion;
  int? porcionesEstimadas;
  String? imagenUrl; // Mapeado desde multimedia_recetas o lógica interna
  DateTime? createdAt;

  // Propiedades virtuales (para facilitar la UI)
  String? nombreEstado; // Ej: "Publicada", "Borrador"
  String? nombreTipoAlimento; // Ej: "Desayuno", "Italiana"

  Receta({
    this.id,
    required this.idUsuarioCreador,
    required this.idEstado,
    required this.idTipoAlimento,
    required this.titulo,
    this.resumen,
    this.tiempoPreparacion,
    required this.preparacion,
    this.porcionesEstimadas,
    this.imagenUrl,
    this.createdAt,
    this.nombreEstado,
    this.nombreTipoAlimento,
  });

  // Factory para crear una instancia desde el JSON de Laravel
  factory Receta.fromJson(Map<String, dynamic> json) {
    return Receta(
      id: json['id'],
      idUsuarioCreador: int.tryParse(json['id_usuario_creador'].toString()) ?? 0,
      idEstado: int.tryParse(json['id_estado'].toString()) ?? 0,
      idTipoAlimento: int.tryParse(json['id_tipo_alimento'].toString()) ?? 0,
      titulo: json['titulo'] ?? '',
      resumen: json['resumen'],
      tiempoPreparacion: int.tryParse(json['tiempo_preparacion'].toString()),
      preparacion: json['preparacion'] ?? '',
      porcionesEstimadas: int.tryParse(json['porciones_estimadas'].toString()),
      // Laravel a veces envía la imagen completa o null
      imagenUrl: json['imagen_url'], 
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      // Si usas 'with()' en Laravel, vendrán estos objetos anidados
      nombreEstado: json['estado']?['descripcion'], 
      nombreTipoAlimento: json['tipo_alimento']?['descripcion'],
    );
  }

  // Convertir a JSON para enviar a Laravel
  Map<String, dynamic> toJson() {
    return {
      'id_usuario_creador': idUsuarioCreador,
      'id_estado': idEstado,
      'id_tipo_alimento': idTipoAlimento,
      'titulo': titulo,
      'resumen': resumen,
      'tiempo_preparacion': tiempoPreparacion,
      'preparacion': preparacion,
      'porciones_estimadas': porcionesEstimadas,
    };
  }
}

// Modelo para los selectores (Subdominios del PDF)
class CatalogoOpcion {
  int id;
  String descripcion;

  CatalogoOpcion({required this.id, required this.descripcion});

  factory CatalogoOpcion.fromJson(Map<String, dynamic> json) {
    return CatalogoOpcion(
      id: json['id'],
      descripcion: json['descripcion'],
    );
  }
}