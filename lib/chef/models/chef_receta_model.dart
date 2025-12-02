import 'package:flutter/material.dart';

class Receta {
  int? id;
  int idUsuarioCreador;
  int idEstado;
  int idTipoAlimento;
  String titulo;
  String? resumen;
  int? tiempoPreparacion;
  String preparacion;
  int? porcionesEstimadas;
  String? imagenUrl;
  DateTime? createdAt;

  // Propiedades Virtuales
  String? nombreEstado;
  String? nombreTipoAlimento;
  
  // Estadísticas
  int? visualizaciones;
  double? calificacion;
  int? totalComentarios;
  int? totalFavoritos;

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
    this.visualizaciones,
    this.calificacion,
    this.totalComentarios,
    this.totalFavoritos,
  });

  // Getter seguro para el estado
  String get estado {
    return nombreEstado?.toUpperCase() ?? 'BORRADOR';
  }

  // Color del badge de estado
  Color get colorEstado {
    String e = estado;
    if (e.contains('PUBLICAD')) return Colors.green;
    if (e.contains('PENDIENTE')) return Colors.orange;
    if (e.contains('RECHAZAD')) return Colors.red;
    return Colors.grey; // Borrador
  }

  // Texto amigable del estado
  String get textoEstado {
    String e = estado;
    if (e.contains('PENDIENTE')) return 'EN REVISIÓN';
    return e;
  }

  factory Receta.fromJson(Map<String, dynamic> json) {
    // 🔍 Lógica inteligente para encontrar la imagen
    String? img;
    if (json['imagen_url'] != null) {
      img = json['imagen_url'];
    } else if (json['imagen'] != null) {
      img = json['imagen'];
    } else if (json['multimedia'] != null && (json['multimedia'] is List) && (json['multimedia'] as List).isNotEmpty) {
      img = json['multimedia'][0]['archivo'];
    }

    return Receta(
      id: json['id'],
      idUsuarioCreador: int.tryParse(json['id_usuario_creador'].toString()) ?? 0,
      idEstado: int.tryParse(json['id_estado'].toString()) ?? 0,
      idTipoAlimento: int.tryParse(json['id_tipo_alimento'].toString()) ?? 0,
      titulo: json['titulo'] ?? '',
      resumen: json['resumen'],
      tiempoPreparacion: int.tryParse(json['tiempo_preparacion'].toString()),
      preparacion: json['preparacion']?.toString() ?? '',
      porcionesEstimadas: int.tryParse(json['porciones_estimadas'].toString()),
      imagenUrl: img, 
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      
      // Mapeo robusto de relaciones
      nombreEstado: json['estado'] is Map 
          ? json['estado']['descripcion'] 
          : (json['estado_descripcion'] ?? 'BORRADOR'),
      nombreTipoAlimento: json['tipo_alimento'] is Map 
          ? json['tipo_alimento']['descripcion'] 
          : (json['tipo_alimento_descripcion'] ?? 'OTRO'),

      // Estadísticas
      visualizaciones: int.tryParse(json['visualizaciones'].toString()) ?? 0,
      calificacion: double.tryParse(json['calificacion_promedio'].toString()) ?? 0.0,
      totalComentarios: int.tryParse(json['total_comentarios'].toString()) ?? 0,
      totalFavoritos: int.tryParse(json['total_favoritos'].toString()) ?? 0,
    );
  }

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