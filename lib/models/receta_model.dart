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

  final String estado;
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
    int parseInt(dynamic v, [int fallback = 0]) {
      if (v == null) return fallback;
      if (v is int) return v;
      if (v is double) return v.toInt();
      return int.tryParse(v.toString()) ?? fallback;
    }

    double parseDouble(dynamic v, [double fallback = 0]) {
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

      // 🔥 Backend actual NO envía estos datos → ponemos valores por defecto
      chef: json['chef']?.toString() ?? 'Chef Nutrichef',
      chefUsername: json['chef_username']?.toString() ?? '@nutrichef',

      // 🔥 Asegurado: si la API NO manda ingredientes, esto NO explota
      ingredientes: (json['ingredientes'] is List)
          ? (json['ingredientes'] as List)
              .map((i) => Ingrediente.fromJson(i))
              .toList()
          : [],

      dietas: (json['dietas'] is List)
          ? (json['dietas'] as List).map((d) => d.toString()).toList()
          : [],

      estado: json['estado']?.toString() ?? 'PUBLICADA',
      visualizaciones: parseInt(json['visualizaciones'], 0),
      calificacion: parseDouble(json['calificacion'], 0),
      totalComentarios: parseInt(json['totalComentarios'], 0),
      totalFavoritos: parseInt(json['totalFavoritos'], 0),
    );
  }

  get categoria => null;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'titulo': titulo,
      'resumen': resumen,
      'tiempo_preparacion': tiempoPreparacion,
      'preparacion': preparacion,
      'porciones_estimadas': porcionesEstimadas,
      'imagen': imagen,
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

  factory Ingrediente.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic v, [double fallback = 0]) {
      if (v == null) return fallback;
      if (v is double) return v;
      if (v is int) return v.toDouble();
      return double.tryParse(v.toString()) ?? fallback;
    }

    return Ingrediente(
      descripcion: json['descripcion']?.toString() ?? '',
      cantidad: parseDouble(json['cantidad'], 0),
      unidadMedida: json['unidad_medida']?.toString() ?? 'unidad',
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
