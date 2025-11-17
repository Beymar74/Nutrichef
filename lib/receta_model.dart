import 'dart:convert';

class Receta {
  final int id;
  final String titulo;
  final String? resumen;
  final int? tiempoPreparacion;
  final List<PasoReceta> preparacion;
  final int? porcionesEstimadas;
  final String? imagen;
  final List<dynamic> ingredientes;
  final List<dynamic> dietas;
  final String chef;
  final String chefUsername;

  Receta({
    required this.id,
    required this.titulo,
    this.resumen,
    this.tiempoPreparacion,
    required this.preparacion,
    this.porcionesEstimadas,
    this.imagen,
    this.ingredientes = const [],
    this.dietas = const [],
    this.chef = 'Chef Nutrichef',
    this.chefUsername = '@nutrichef',
  });

  factory Receta.fromJson(Map<String, dynamic> json) {
    List<PasoReceta> pasos = _parsearPreparacion(json['preparacion']);
    

    return Receta(
      id: json['id'] ?? 0,
      titulo: json['titulo'] ?? 'Sin título',
      resumen: json['resumen'],
      tiempoPreparacion: json['tiempo_preparacion'],
      preparacion: pasos,
      porcionesEstimadas: json['porciones_estimadas'],
      imagen: json['imagen'],
      ingredientes: json['ingredientes'] ?? [],
      dietas: json['dietas'] ?? [],
      chef: json['chef'] ?? 'Chef Nutrichef',
      chefUsername: json['chef_username'] ?? '@nutrichef',
    );
  }

  static List<PasoReceta> _parsearPreparacion(dynamic preparacionData) {
    List<PasoReceta> pasos = [];
    
    if (preparacionData == null) return pasos;
      
    try {
      if (preparacionData is List) {
        for (var paso in preparacionData) {
          if (paso is Map) {
            pasos.add(PasoReceta.fromJson(Map<String, dynamic>.from(paso)));
          }
        }
      } 
      else if (preparacionData is String) {
        String jsonCorregido = preparacionData
            .replaceAll('{texto:', '{"texto": "')
            .replaceAll(', tiempo:', '", "tiempo":')
            .replaceAll(', ingredientes:', ', "ingredientes":')
            .replaceAll('}]', '}]');
        
        jsonCorregido = jsonCorregido.replaceAllMapped(
          RegExp(r'"texto": "([^"]*?)(?=", "tiempo")'),
          (match) => '"texto": "${match.group(1)}"'
        );
        
        try {
          final parsed = json.decode(jsonCorregido);
          if (parsed is List) {
            for (var paso in parsed) {
              if (paso is Map) {
                pasos.add(PasoReceta.fromJson(Map<String, dynamic>.from(paso)));
              }
            }
          }
        } catch (e) {
          print('❌ Error parseando JSON corregido: $e');
          pasos = _crearPasosDesdeString(preparacionData);
        }
      }
    } catch (e) {
      print('❌ Error parseando preparacion: $e');
      
      if (preparacionData is String) {
        pasos = _crearPasosDesdeString(preparacionData);
      }
    }
    
    for (int i = 0; i < pasos.length; i++) {
      print('   Paso ${i + 1}: "${pasos[i].texto}" -> Tiempo: ${pasos[i].tiempo} (tipo: ${pasos[i].tiempo?.runtimeType})');
    }
    
    return pasos;
  }

  static List<PasoReceta> _crearPasosDesdeString(String texto) {
    List<PasoReceta> pasos = [];
    
    final regex = RegExp(r'texto:\s*([^,]+)');
    final matches = regex.allMatches(texto);
    
    for (var match in matches) {
      String textoPaso = match.group(1)?.trim() ?? '';
      if (textoPaso.isNotEmpty) {
        textoPaso = textoPaso.replaceAll("'", "").replaceAll('"', '').trim();
        pasos.add(PasoReceta(
          texto: textoPaso,
          tiempo: _extraerTiempo(textoPaso),
          ingredientes: [],
        ));
      }
    }
    
    if (pasos.isEmpty) {
      pasos.add(PasoReceta(
        texto: 'Preparar según instrucciones.',
        tiempo: null,
        ingredientes: [],
      ));
    }
    
    return pasos;
  }

  static int? _extraerTiempo(String texto) {
    var patrones = [
      RegExp(r'(\d+)\s*minutos?', caseSensitive: false),
      RegExp(r'(\d+)\s*min\.?', caseSensitive: false),
      RegExp(r'por\s+(\d+)\s*minutos?', caseSensitive: false),
      RegExp(r'durante\s+(\d+)\s*minutos?', caseSensitive: false),
    ];
    
    for (var patron in patrones) {
      var match = patron.firstMatch(texto);
      if (match != null) {
        int tiempo = int.tryParse(match.group(1) ?? '') ?? 0;
        return tiempo > 0 ? tiempo : null;
      }
    }
    
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'resumen': resumen,
      'tiempo_preparacion': tiempoPreparacion,
      'preparacion': preparacion.map((paso) => paso.toJson()).toList(),
      'porciones_estimadas': porcionesEstimadas,
      'imagen': imagen,
      'ingredientes': ingredientes,
      'dietas': dietas,
      'chef': chef,
      'chef_username': chefUsername,
    };
  }
}

class PasoReceta {
  final String texto;
  final int? tiempo;
  final List<dynamic> ingredientes;

  PasoReceta({
    required this.texto,
    required this.tiempo,
    required this.ingredientes,
  });

  factory PasoReceta.fromJson(Map<String, dynamic> json) {
    int? tiempoParseado;
    
    if (json['tiempo'] != null) {
      if (json['tiempo'] is int) {
        tiempoParseado = json['tiempo'];
      } else if (json['tiempo'] is String) {
        tiempoParseado = int.tryParse(json['tiempo']);
      } else if (json['tiempo'] is double) {
        tiempoParseado = (json['tiempo'] as double).round();
      }
    }

    return PasoReceta(
      texto: json['texto']?.toString() ?? 'Sin instrucción',
      tiempo: tiempoParseado, 
      ingredientes: json['ingredientes'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'texto': texto,
      'tiempo': tiempo,
      'ingredientes': ingredientes,
    };
  }

  String detectarGif() {
    String textoLower = texto.toLowerCase();
    
    if (textoLower.contains('sazonar') || textoLower.contains('comino') || 
        textoLower.contains('moler') || textoLower.contains('especias') ||
        textoLower.contains('pimienta') || textoLower.contains('salpimentar')) {
      return 'assets/gifs/moler-especias-sal-pimienta-comino.gif';
    }
    if (textoLower.contains('cocina') || textoLower.contains('cocinar') || 
        textoLower.contains('cocine') || textoLower.contains('cocer') ||
        textoLower.contains('hervir') || textoLower.contains('hierva') ||
        textoLower.contains('calentar')) {
      return 'assets/gifs/olla-hirviendo.gif';
    }
    if (textoLower.contains('hornear') || textoLower.contains('hornee') || 
        textoLower.contains('horno') || textoLower.contains('precaliente') ||
        textoLower.contains('horneado')) {
      return 'assets/gifs/horno.gif';
    }
    if (textoLower.contains('freir') || textoLower.contains('fría') || 
        textoLower.contains('sartén') || textoLower.contains('saltear') ||
        textoLower.contains('plancha')) {
      return 'assets/gifs/sarten.gif';
    }
    if (textoLower.contains('batir') || textoLower.contains('bata') ||
        textoLower.contains('batido')) {
      return 'assets/gifs/batir-manual.gif';
    }
    if (textoLower.contains('mezclar') || textoLower.contains('mezcle') || 
        textoLower.contains('combine') || textoLower.contains('incorporar') ||
        textoLower.contains('revolver') || textoLower.contains('unir') ||
        textoLower.contains('agrega') || textoLower.contains('añade')) {
      return 'assets/gifs/mover-con-cuchara-cucharon.gif';
    }
    if (textoLower.contains('picar') || textoLower.contains('cortar') || 
        textoLower.contains('pique') || textoLower.contains('rebanar') ||
        textoLower.contains('trocear') || textoLower.contains('filetear')) {
      return 'assets/gifs/cortar-picar-pescado.gif';
    }
    if (textoLower.contains('amasar') || textoLower.contains('amasado') ||
        textoLower.contains('sobar') || textoLower.contains('estirar')) {
      return 'assets/gifs/rodillo-madera-estirar-amasar.gif';
    }
    if (textoLower.contains('licuar') || textoLower.contains('licue') || 
        textoLower.contains('batidora') || textoLower.contains('procesar')) {
      return 'assets/gifs/licuadora.gif';
    }
    if (textoLower.contains('refrigerar') || textoLower.contains('enfriar') || 
        textoLower.contains('congelar') || textoLower.contains('nevera') ||
        textoLower.contains('frio') || textoLower.contains('hielo') ||
        textoLower.contains('enfría') || textoLower.contains('deja enfriar')) {
      return 'assets/gifs/refrigerador.gif';
    }
    if (textoLower.contains('decorar') || textoLower.contains('decoración') ||
        textoLower.contains('adornar') || textoLower.contains('espolvorear')) {
      return 'assets/gifs/decorar.gif';
    }
    if (textoLower.contains('verter') || textoLower.contains('vierta') || 
        textoLower.contains('vaciar') || textoLower.contains('añadir')) {
      return 'assets/gifs/verter-agua.gif';
    }
    if (textoLower.contains('servir') || textoLower.contains('sirva') || 
        textoLower.contains('presentar') || textoLower.contains('plato') ||
        textoLower.contains('sirve')) {
      return 'assets/gifs/servir.gif';
    }
    if (textoLower.contains('exprimir') || textoLower.contains('zumo') ||
        textoLower.contains('jugo') || textoLower.contains('limón')) {
      return 'assets/gifs/exprimidor.gif';
    }
    if (textoLower.contains('derrite') || textoLower.contains('derretir') || 
        textoLower.contains('fusión') || textoLower.contains('baño maría')) {
      return 'assets/gifs/cocinar.gif';
    }

    return 'assets/gifs/cocinar.gif';
  }
}