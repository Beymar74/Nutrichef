import 'dart:async';
import 'package:flutter/material.dart';
import 'receta_model.dart';

class AsistenteCocinaScreen extends StatefulWidget {
  final Receta receta;

  const AsistenteCocinaScreen({Key? key, required this.receta}) : super(key: key);

  @override
  State<AsistenteCocinaScreen> createState() => _AsistenteCocinaScreenState();
}

class _AsistenteCocinaScreenState extends State<AsistenteCocinaScreen> {
  int _pasoActual = 0;
  
  @override
  void initState() {
    super.initState();
    print('RECETA CARGADA: ${widget.receta.titulo}');
    print('TOTAL PASOS: ${widget.receta.preparacion.length}');
    for (int i = 0; i < widget.receta.preparacion.length; i++) {
      print('   Paso ${i + 1}: ${widget.receta.preparacion[i].texto}');
    }
  }
  
  void _siguientePaso() {
    if (_pasoActual < widget.receta.preparacion.length - 1) {
      setState(() {
        _pasoActual++;
      });
      print('AVANZANDO AL PASO: ${_pasoActual + 1}');
    }
  }

  void _pasoAnterior() {
    if (_pasoActual > 0) {
      setState(() {
        _pasoActual--;
      });
      print('RETROCEDIENDO AL PASO: ${_pasoActual + 1}');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.receta.preparacion.isEmpty) {
      return _buildSinPasos();
    }

    final paso = widget.receta.preparacion[_pasoActual];
    final progreso = (_pasoActual + 1) / widget.receta.preparacion.length;

    print('MOSTRANDO PASO ${_pasoActual + 1}: ${paso.texto}');
    final gifPath = paso.detectarGif();
    print('GIF SELECCIONADO: $gifPath');

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.receta.titulo,
          style: const TextStyle(
            color: Color(0xFFFF8C42),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Paso ${_pasoActual + 1} de ${widget.receta.preparacion.length}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: LinearProgressIndicator(
                    value: progreso,
                    backgroundColor: Colors.grey[200],
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF8C42)),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 200,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: _buildGifWidget(gifPath, paso),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  if (paso.ingredientes.isNotEmpty) ...[
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF8C42).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.shopping_basket,
                                  color: Color(0xFFFF8C42),
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Ingredientes para este paso',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFF8C42),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: paso.ingredientes.map((ingrediente) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 8,
                                      height: 8,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFF8C42),
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        ingrediente.textoCompleto,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          height: 1.4,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF8C42).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.lightbulb_outline,
                                color: Color(0xFFFF8C42),
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'Preparación',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF8C42),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          paso.texto,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.6,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (paso.tiempo != null) ...[
                    const SizedBox(height: 24),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: _Temporizador(minutos: paso.tiempo!),
                    ),
                  ],

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          children: [
            if (_pasoActual > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: _pasoAnterior,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Color(0xFFFF8C42), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.arrow_back, color: Color(0xFFFF8C42)),
                      SizedBox(width: 8),
                      Text(
                        'Anterior',
                        style: TextStyle(
                          color: Color(0xFFFF8C42),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            
            if (_pasoActual > 0 && _pasoActual < widget.receta.preparacion.length - 1)
              const SizedBox(width: 12),           

            if (_pasoActual < widget.receta.preparacion.length - 1)
              Expanded(
                child: ElevatedButton(
                  onPressed: _siguientePaso,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8C42),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Siguiente',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_forward, color: Colors.white),
                    ],
                  ),
                ),
              ),
              if (_pasoActual == widget.receta.preparacion.length - 1)
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        title: const Row(
                          children: [
                            Icon(Icons.celebration, color: Color(0xFFFF8C42)),
                            SizedBox(width: 8),
                            Text('¡Felicitaciones! 🎉'),
                          ],
                        ),
                        content: const Text('Has completado la receta con éxito.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text(
                              'Finalizar',
                              style: TextStyle(color: Color(0xFFFF8C42)),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF8C42),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Finalizar',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.check_circle, color: Colors.white),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  Widget _buildGifWidget(String gifPath, PasoReceta paso) {
    return Image.asset(
      gifPath,
      height: 200,
      width: double.infinity,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        print('ERROR CARGANDO GIF: $gifPath - $error');
        return _buildFallbackIcon(paso);
      },
    );
  }

  Widget _buildFallbackIcon(PasoReceta paso) {
    final tipoAccion = _obtenerTipoAccion(paso.texto);
    IconData icon;
    Color color = const Color(0xFFFF8C42);
    
    switch (tipoAccion) {
      case 'Hornear':
        icon = Icons.local_fire_department;
        color = Colors.orange;
        break;
      case 'Derretir':
        icon = Icons.whatshot;
        color = Colors.red;
        break;
      case 'Mezclar':
        icon = Icons.blender;
        color = Colors.green;
        break;
      case 'Batir':
        icon = Icons.electric_bolt;
        color = Colors.blue;
        break;
      case 'Cortar':
        icon = Icons.content_cut;
        color = Colors.purple;
        break;
      case 'Verter':
        icon = Icons.opacity;
        color = Colors.cyan;
        break;
      case 'Enfriar':
        icon = Icons.ac_unit;
        color = Colors.blue;
        break;
      case 'Servir':
        icon = Icons.room_service;
        color = Colors.green;
        break;
      default:
        icon = Icons.restaurant_menu;
        color = const Color(0xFFFF8C42);
    }
    
    return Container(
      color: color.withOpacity(0.1),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: color,
          ),
          const SizedBox(height: 12),
          Text(
            tipoAccion,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '(GIF no disponible)',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
  String _obtenerTipoAccion(String texto) {
    String textoLower = texto.toLowerCase();
    
    if (textoLower.contains('horno') || textoLower.contains('hornear') || textoLower.contains('precalienta')) {
      return 'Hornear';
    } else if (textoLower.contains('derrite') || textoLower.contains('derretir') || textoLower.contains('baño maría')) {
      return 'Derretir';
    } else if (textoLower.contains('mezcla') || textoLower.contains('mezclar') || textoLower.contains('incorpora') || textoLower.contains('añade')) {
      return 'Mezclar';
    } else if (textoLower.contains('batir') || textoLower.contains('batiendo')) {
      return 'Batir';
    } else if (textoLower.contains('cortar') || textoLower.contains('picar')) {
      return 'Cortar';
    } else if (textoLower.contains('verter') || textoLower.contains('vierta')) {
      return 'Verter';
    } else if (textoLower.contains('enfriar') || textoLower.contains('enfría') || textoLower.contains('deja enfriar')) {
      return 'Enfriar';
    } else if (textoLower.contains('servir') || textoLower.contains('sirve')) {
      return 'Servir';
    } else {
      return 'Preparar';
    }
  }
  Widget _buildSinPasos() {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.receta.titulo,
          style: const TextStyle(
            color: Color(0xFFFF8C42),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 60, color: Colors.orange[300]),
            const SizedBox(height: 16),
            const Text(
              'Receta sin instrucciones',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Esta receta no tiene pasos de preparación disponibles.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF8C42),
              ),
              child: const Text('Volver a la lista'),
            ),
          ],
        ),
      ),
    );
  }
}
class _Temporizador extends StatefulWidget {
  final int minutos;

  const _Temporizador({required this.minutos});

  @override
  State<_Temporizador> createState() => _TemporizadorState();
}

class _TemporizadorState extends State<_Temporizador> {
  late int _segundosRestantes;
  Timer? _timer;
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _segundosRestantes = widget.minutos * 60;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _iniciarPausar() {
    if (_isRunning) {
      _timer?.cancel();
      setState(() => _isRunning = false);
    } else {
      setState(() => _isRunning = true);
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_segundosRestantes > 0) {
          setState(() => _segundosRestantes--);
        } else {
          timer.cancel();
          setState(() => _isRunning = false);
          _mostrarAlerta();
        }
      });
    }
  }

  void _reiniciar() {
    _timer?.cancel();
    setState(() {
      _segundosRestantes = widget.minutos * 60;
      _isRunning = false;
    });
  }

  void _mostrarAlerta() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.timer, color: Color(0xFFFF8C42)),
            SizedBox(width: 8),
            Text('⏰ ¡Tiempo completado!'),
          ],
        ),
        content: const Text('El temporizador ha finalizado.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: Color(0xFFFF8C42))),
          ),
        ],
      ),
    );
  }

  String _formatearTiempo() {
    int minutos = _segundosRestantes ~/ 60;
    int segundos = _segundosRestantes % 60;
    return '${minutos.toString().padLeft(2, '0')}:${segundos.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    double progreso = _segundosRestantes / (widget.minutos * 60);

    return Column(
      children: [
        const Row(
          children: [
            Icon(Icons.access_time, color: Color(0xFFFF8C42), size: 24),
            SizedBox(width: 12),
            Text(
              'Temporizador',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFFFF8C42),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: 180,
          height: 180,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 180,
                height: 180,
                child: CircularProgressIndicator(
                  value: progreso,
                  strokeWidth: 8,
                  backgroundColor: Colors.grey[200],
                  valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFF8C42)),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatearTiempo(),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  Text(
                    '${widget.minutos} min',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFFF8C42),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF8C42).withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                onPressed: _iniciarPausar,
                icon: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                color: Colors.white,
                iconSize: 32,
              ),
            ),
            const SizedBox(width: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: _reiniciar,
                icon: const Icon(Icons.refresh),
                color: const Color(0xFFFF8C42),
                iconSize: 28,
              ),
            ),
          ],
        ),
      ],
    );
  }
}