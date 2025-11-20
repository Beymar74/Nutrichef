import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'receta_model.dart';
import 'services/asistente_voz.dart';

class AsistenteCocinaScreen extends StatefulWidget {
  final Receta receta;
  final bool conAsistenteVoz;

  const AsistenteCocinaScreen({
    Key? key,
    required this.receta,
    this.conAsistenteVoz = false,
  }) : super(key: key);

  @override
  State<AsistenteCocinaScreen> createState() => _AsistenteCocinaScreenState();
}

class _AsistenteCocinaScreenState extends State<AsistenteCocinaScreen> {
  int _pasoActual = 0;
  VoiceAssistantService? _voiceService;
  bool _isVoiceActive = false;
  bool _isListening = false;
  StreamSubscription? _speechSubscription;
  StreamSubscription? _listeningSubscription;

  @override
  void initState() {
    super.initState();
    print('RECETA CARGADA: ${widget.receta.titulo}');
    print('TOTAL PASOS: ${widget.receta.preparacion.length}');
    
    if (widget.conAsistenteVoz) {
      _inicializarAsistenteVoz();
    }
  }

  Future<void> _inicializarAsistenteVoz() async {

    final status = await Permission.microphone.request();
    
    if (status == PermissionStatus.granted) {
      _voiceService = VoiceAssistantService();
      bool initialized = await _voiceService!.initialize();
      
      if (initialized) {
        setState(() {
          _isVoiceActive = true;
        });
        
        await _voiceService!.speak(
          "Hola, soy tu asistente de cocina. Vamos a preparar ${widget.receta.titulo}. Di 'empezar' cuando estés listo."
        );
        
        _escucharComandos();
      } else {
        _mostrarErrorVoz('No se pudo inicializar el reconocimiento de voz');
      }
    } else if (status == PermissionStatus.permanentlyDenied) {
      _mostrarDialogoPermisos();
    } else {
      _mostrarErrorVoz('Se necesita permiso de micrófono para usar el asistente de voz');
    }
  }

  void _escucharComandos() {
    if (_voiceService == null) return;
    
    _voiceService!.startListening();
    
    _speechSubscription = _voiceService!.speechStream.listen((comando) {
      print('Comando recibido: $comando');
      _procesarComando(comando);
    });
    
    _listeningSubscription = _voiceService!.listeningStream.listen((listening) {
      setState(() {
        _isListening = listening;
      });
    });
  }

  void _procesarComando(String comando) {
    comando = _voiceService!.normalizarComando(comando);
    print('Comando normalizado: $comando');
    
    switch (comando) {
      case 'empezar':
      case 'iniciar':
        _empezarReceta();
        break;
      case 'siguiente':
        _siguientePaso();
        break;
      case 'anterior':
        _pasoAnterior();
        break;
      case 'temporizador':
        _iniciarTemporizador();
        break;
      case 'repetir':
        _repetirPaso();
        break;
      case 'pausar':
        _pausarAsistente();
        break;
      case 'continuar':
        _continuarAsistente();
        break;
      case 'listo':
        _siguientePaso();
        break;
      case 'finalizar':
        _finalizarReceta();
        break;
      default:
        _voiceService?.speak('No entendí ese comando. Intenta decir siguiente, anterior, o repetir.');
    }
  }

  void _empezarReceta() async {
    if (_pasoActual == 0) {
      await _voiceService?.speak('Perfecto, empecemos con el primer paso.');
      await Future.delayed(const Duration(seconds: 2));
      _leerPasoActual();
    }
  }

  void _leerPasoActual() async {
    if (_pasoActual < widget.receta.preparacion.length) {
      final paso = widget.receta.preparacion[_pasoActual];
      
      String mensaje = 'Paso ${_pasoActual + 1} de ${widget.receta.preparacion.length}. ${paso.texto}';
      
      if (paso.ingredientes.isNotEmpty) {
        mensaje += '. Los ingredientes que necesitas son: ';
        for (var ing in paso.ingredientes) {
          mensaje += '${ing.textoCompleto}, ';
        }
      }
      
      if (paso.tiempo != null) {
        mensaje += '. Este paso requiere ${paso.tiempo} minutos. Di "iniciar temporizador" si lo necesitas.';
      }
      
      mensaje += '. Cuando termines, di "siguiente" o "listo".';
      
      await _voiceService?.speak(mensaje);
    }
  }

  void _siguientePaso() async {
    if (_pasoActual < widget.receta.preparacion.length - 1) {
      setState(() {
        _pasoActual++;
      });
      await _voiceService?.speak('Muy bien, pasemos al siguiente paso.');
      await Future.delayed(const Duration(seconds: 1));
      _leerPasoActual();
    } else {
      await _voiceService?.speak('Has completado todos los pasos. Di finalizar para terminar.');
    }
  }

  void _pasoAnterior() async {
    if (_pasoActual > 0) {
      setState(() {
        _pasoActual--;
      });
      await _voiceService?.speak('Volviendo al paso anterior.');
      await Future.delayed(const Duration(seconds: 1));
      _leerPasoActual();
    } else {
      await _voiceService?.speak('Ya estás en el primer paso.');
    }
  }

  void _repetirPaso() async {
    await _voiceService?.speak('Claro, te repito el paso.');
    await Future.delayed(const Duration(seconds: 1));
    _leerPasoActual();
  }

  void _iniciarTemporizador() async {
    final paso = widget.receta.preparacion[_pasoActual];
    if (paso.tiempo != null) {
      await _voiceService?.speak('Iniciando temporizador de ${paso.tiempo} minutos.');
    } else {
      await _voiceService?.speak('Este paso no tiene un tiempo definido.');
    }
  }

  void _pausarAsistente() async {
    _voiceService?.stopListening();
    await _voiceService?.speak('Pausando el asistente. Di continuar cuando quieras reanudar.');
  }

  void _continuarAsistente() async {
    await _voiceService?.speak('Continuemos.');
    _voiceService?.startListening();
  }

  void _finalizarReceta() {
    if (_pasoActual == widget.receta.preparacion.length - 1) {
      _voiceService?.speak('¡Felicitaciones! Has completado la receta. Espero que disfrutes tu comida.');
      Future.delayed(const Duration(seconds: 3), () {
        Navigator.pop(context);
      });
    }
  }

  void _mostrarDialogoPermisos() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permiso de Micrófono'),
        content: const Text(
          'Para usar el asistente de voz, necesitas habilitar el permiso de micrófono en la configuración de la aplicación.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Abrir Configuración'),
          ),
        ],
      ),
    );
  }

  void _mostrarErrorVoz(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _speechSubscription?.cancel();
    _listeningSubscription?.cancel();
    _voiceService?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.receta.preparacion.isEmpty) {
      return _buildSinPasos();
    }

    final paso = widget.receta.preparacion[_pasoActual];
    final progreso = (_pasoActual + 1) / widget.receta.preparacion.length;
    final gifPath = paso.detectarGif();

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
        actions: [
          if (_isVoiceActive)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _isListening ? Colors.red : Colors.green,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _isListening ? Icons.mic : Icons.mic_off,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _isListening ? 'Escuchando' : 'Voz activa',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
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
                  
                  // Imagen/GIF del paso
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
                  
                  // Ingredientes del paso
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
                      child: _Temporizador(
                        minutos: paso.tiempo!,
                        onComplete: () async {
                          if (_isVoiceActive) {
                            await _voiceService?.speak('El temporizador ha terminado. Di siguiente cuando estés listo.');
                          }
                        },
                      ),
                    ),
                  ],

                  if (_isVoiceActive) ...[
                    const SizedBox(height: 24),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.mic, color: Colors.blue[700], size: 20),
                              const SizedBox(width: 8),
                              Text(
                                'Comandos de voz disponibles:',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue[700],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '• "Siguiente" o "Listo"\n'
                            '• "Anterior"\n'
                            '• "Repetir" o "Explica otra vez"\n'
                            '• "Iniciar temporizador"\n'
                            '• "Pausar" / "Continuar"\n'
                            '• "Finalizar"',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue[700],
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
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
                  onPressed: () {
                    _pasoAnterior();
                  },
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
                  onPressed: () {
                    _siguientePaso();
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
          Icon(icon, size: 80, color: color),
          const SizedBox(height: 12),
          Text(
            tipoAccion,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  String _obtenerTipoAccion(String texto) {
    String textoLower = texto.toLowerCase();
    
    if (textoLower.contains('horno') || textoLower.contains('hornear')) return 'Hornear';
    if (textoLower.contains('derrite') || textoLower.contains('derretir')) return 'Derretir';
    if (textoLower.contains('mezcla') || textoLower.contains('mezclar')) return 'Mezclar';
    if (textoLower.contains('batir')) return 'Batir';
    if (textoLower.contains('cortar') || textoLower.contains('picar')) return 'Cortar';
    if (textoLower.contains('verter')) return 'Verter';
    if (textoLower.contains('enfriar')) return 'Enfriar';
    if (textoLower.contains('servir')) return 'Servir';
    
    return 'Preparar';
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
  final VoidCallback? onComplete;

  const _Temporizador({
    required this.minutos,
    this.onComplete,
  });

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
          widget.onComplete?.call();
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