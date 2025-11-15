// lib/models/receta_model.dart

class Receta {
  final int id;
  final String titulo;
  final String resumen;
  final int tiempoPreparacion;
  final String preparacion;
  final int porcionesEstimadas;
  final String? imagen;
  final String chef;
  final String chefUsername;
  final List<Ingrediente> ingredientes;
  final List<String> dietas;

  // Campos opcionales que antes simulabas en una extensión
  final String estado; // 'PUBLICADA', 'PENDIENTE_REVISION', 'RECHAZADA', 'BORRADOR'
  final int visualizaciones;
  final double calificacion;
  final int totalComentarios;
  final int totalFavoritos;

  Receta({
    required this.id,
    required this.titulo,
    required this.resumen,
    required this.tiempoPreparacion,
    required this.preparacion,
    required this.porcionesEstimadas,
    this.imagen,
    required this.chef,
    required this.chefUsername,
    required this.ingredientes,
    required this.dietas,
    this.estado = 'BORRADOR',
    this.visualizaciones = 0,
    this.calificacion = 0.0,
    this.totalComentarios = 0,
    this.totalFavoritos = 0,
  });

  factory Receta.fromJson(Map<String, dynamic> json) {
    // Helper to safely parse ints/doubles
    int parseInt(dynamic v, [int fallback = 0]) {
      if (v == null) return fallback;
      if (v is int) return v;
      if (v is double) return v.toInt();
      return int.tryParse(v.toString()) ?? fallback;
    }

    double? parseDouble(dynamic v, [double? fallback]) {
      if (v == null) return fallback;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      return double.tryParse(v.toString()) ?? fallback;
    }

    return Receta(
      id: parseInt(json['id'], 0),
      titulo: json['titulo']?.toString() ?? '',
      resumen: json['resumen']?.toString() ?? '',
      tiempoPreparacion: parseInt(json['tiempo_preparacion'], 0),
      preparacion: json['preparacion']?.toString() ?? '',
      porcionesEstimadas: parseInt(json['porciones_estimadas'], 1),
      imagen: json['imagen']?.toString(),
      chef: json['chef']?.toString() ?? 'Chef Nutrichef',
      chefUsername: json['chef_username']?.toString() ?? '@nutrichef',
      ingredientes: (json['ingredientes'] as List?)
              ?.map((i) => i is Map ? Ingrediente.fromJson(Map<String, dynamic>.from(i)) : Ingrediente.fromJson({}))
              .toList() ??
          [],
      dietas: (json['dietas'] as List?)?.map((d) => d.toString()).toList() ?? [],
      estado: json['estado']?.toString() ?? json['estado_receta']?.toString() ?? 'BORRADOR',
      visualizaciones: parseInt(json['visualizaciones'], 0),
      calificacion: parseDouble(json['calificacion'], 0.0) ?? 0.0,
      totalComentarios: parseInt(json['totalComentarios'] ?? json['comentarios_count'], 0),
      totalFavoritos: parseInt(json['totalFavoritos'] ?? json['favoritos_count'], 0),
    );
  }

  /// toMap produce un Map con las keys que usa la UI
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'resumen': resumen,
      'tiempo_preparacion': tiempoPreparacion,
      'preparacion': preparacion,
      'porciones_estimadas': porcionesEstimadas,
      'imagen': imagen ?? 'https://images.unsplash.com/photo-1546069901-ba9599a7e63c?w=800',
      'chef': chef,
      'chef_username': chefUsername,
      'ingredientes': ingredientes.map((i) => i.toMap()).toList(),
      'dietas': dietas,
      'estado': estado,
      'visualizaciones': visualizaciones,
      'calificacion': calificacion,
      'totalComentarios': totalComentarios,
      'totalFavoritos': totalFavoritos,
    };
  }
}

class Ingrediente {
  final String descripcion;
  final double cantidad;
  final String unidadMedida;

  Ingrediente({
    required this.descripcion,
    required this.cantidad,
    required this.unidadMedida,
  });

  factory Ingrediente.fromJson(Map<String, dynamic>? json) {
    final data = json ?? {};
    double parseDouble(dynamic v, [double fallback = 0]) {
      if (v == null) return fallback;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      return double.tryParse(v.toString()) ?? fallback;
    }

    return Ingrediente(
      descripcion: data['descripcion']?.toString() ?? data['name']?.toString() ?? '',
      cantidad: parseDouble(data['cantidad'] ?? data['amount'] ?? 0),
      unidadMedida: data['unidad_medida']?.toString() ?? data['unidad']?.toString() ?? 'unidad',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'descripcion': descripcion,
      'cantidad': cantidad,
      'unidad_medida': unidadMedida,
    };
  }
}
