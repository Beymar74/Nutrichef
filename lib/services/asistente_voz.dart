import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';
import 'package:permission_handler/permission_handler.dart';

class VoiceAssistantService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();
  
  bool _isListening = false;
  bool _isInitialized = false;
  bool _isSpeaking = false;
  
  final StreamController<String> _speechController = StreamController<String>.broadcast();
  final StreamController<bool> _listeningController = StreamController<bool>.broadcast();

  Stream<String> get speechStream => _speechController.stream;
  Stream<bool> get listeningStream => _listeningController.stream;

  Future<bool> initialize() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      print('Permiso de micrófono denegado');
      return false;
    }

    bool available = await _speech.initialize(
      onStatus: (status) {
        print('Estado del micrófono: $status');
        _isListening = status == 'listening';
        _listeningController.add(_isListening);
        
        if (status == 'notListening' && _isInitialized && !_isListening && !_isSpeaking) {
          Future.delayed(const Duration(milliseconds: 1000), () {
            if (_isInitialized && !_isListening && !_isSpeaking) {
              startListening();
            }
          });
        }
      },
      onError: (error) {
        print('Error en reconocimiento de voz: $error');
        
        // Manejo ESPECÍFICO para error_speech_timeout
        if (error.errorMsg == 'error_speech_timeout') {
          print('Timeout de reconocimiento - reactivando micrófono...');
          _isListening = false;
          _listeningController.add(false);
          
          // Reactivar más rápido para este error
          Future.delayed(const Duration(milliseconds: 500), () {
            if (_isInitialized && !_isListening && !_isSpeaking) {
              startListening();
            }
          });
        } else if (error.errorMsg != 'error_no_match') {
          _isListening = false;
          _listeningController.add(false);
          
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (_isInitialized && !_isListening && !_isSpeaking) {
              startListening();
            }
          });
        }
      },
    );

    if (!available) {
      print('Reconocimiento de voz no disponible');
      return false;
    }

    await _flutterTts.setLanguage("es-ES");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);
    
    _flutterTts.setCompletionHandler(() {
      print('TTS completado');
      _isSpeaking = false;
      
      // Esperar 1.2 segundos ANTES de reactivar
      Future.delayed(const Duration(milliseconds: 1200), () {
        if (_isInitialized && !_isListening && !_isSpeaking) {
          print('Reactivando micrófono después de hablar');
          startListening();
        }
      });
    });
    
    _flutterTts.setErrorHandler((msg) {
      print('Error en TTS: $msg');
      _isSpeaking = false;
      
      // Reactivar micrófono si hay error en TTS
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (_isInitialized && !_isListening && !_isSpeaking) {
          startListening();
        }
      });
    });

    _isInitialized = true;
    return true;
  }

  Future<void> speak(String text) async {
    if (_isInitialized) {
      if (_isListening) {
        print('Pausando micrófono para hablar');
        stopListening();
      }
      
      _isSpeaking = true;
      print('Hablando: $text');
      await _flutterTts.speak(text);
      
      // El micrófono se reactivará automáticamente en el completion handler
    }
  }

  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
    _isSpeaking = false;
  }

  void startListening() {
    if (!_isListening && _isInitialized && !_isSpeaking) {
      print('Iniciando escucha...');
      _speech.listen(
        onResult: (result) {
          String speech = result.recognizedWords.trim();
          
          if (result.finalResult) {
            _procesarResultadoFinal(speech);
          } else {
            if (speech.isNotEmpty) {
              print('Escuchando: $speech');
            }
          }
        },
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        localeId: 'es-ES',
        cancelOnError: false,
        listenMode: stt.ListenMode.confirmation,
      );
      _isListening = true;
      _listeningController.add(true);
      print('Micrófono activado');
    }
  }

  void _procesarResultadoFinal(String speech) {
    speech = speech.toLowerCase().trim();
    print('Resultado final recibido: "$speech"');
    
    if (speech.isEmpty || speech.length < 4) {
      print('Ignorado: texto muy corto');
      return;
    }
    
    if (interpretarComando(speech)) {
      print('Comando válido detectado: $speech');
      _speechController.add(speech);
    } else {
      print('No es un comando válido: $speech');
    }
  }

  void stopListening() {
    if (_isListening) {
      print('Deteniendo micrófono');
      _speech.stop();
      _isListening = false;
      _listeningController.add(false);
    }
  }

  bool interpretarComando(String comando) {
    comando = comando.toLowerCase().trim();
    
    final List<String> palabrasClave = [
      'empezar', 'iniciar', 'inicio',
      'siguiente', 'continuar', 'continua', 'sigue',
      'anterior', 'atrás', 'atras', 'volver',
      'temporizador', 'cronómetro', 'cronometro', 'timer',
      'listo', 'terminado', 'terminé', 'termine',
      'pausar', 'pausa', 'detener', 'para',
      'repetir', 'otra vez', 'de nuevo', 'explica',
      'finalizar', 'terminar', 'salir', 'acabar'
    ];
    
    bool tieneComando = palabrasClave.any((palabra) => comando.contains(palabra));
    
    if (comando.length < 3) return false;
    if (RegExp(r'^\d+$').hasMatch(comando)) return false;
    
    return tieneComando;
  }

  String normalizarComando(String comando) {
    comando = comando.toLowerCase().trim();
    
    if (comando.contains('temporizador') || 
        comando.contains('cronómetro') || 
        comando.contains('cronometro') || 
        comando.contains('timer')) {
      
      if (comando.contains('pausar') || comando.contains('pausa') || 
          comando.contains('detener') || comando.contains('para')) {
        return 'pausar temporizador';
      }
      
      if (comando.contains('reiniciar') || comando.contains('reinicia')) {
        return 'reiniciar temporizador';
      }
      
      // "iniciar temporizador" retorna "temporizador"
      if (comando.contains('iniciar') || comando.contains('comenzar') || 
          comando.contains('empezar') || comando.contains('arrancar')) {
        return 'temporizador';
      }
      
      return 'temporizador';
    }
    
    // Solo si NO es comando de temporizador
    if ((comando.contains('empezar') || comando.contains('iniciar')) && 
        !comando.contains('temporizador')) {
      return 'empezar';
    }
    
    if (comando.contains('siguiente') || comando.contains('continuar') || comando.contains('continua')) {
      return 'siguiente';
    }
    
    if (comando.contains('anterior') || comando.contains('atrás') || comando.contains('atras')) {
      return 'anterior';
    }
    
    if (comando.contains('listo') || comando.contains('terminado')) {
      return 'listo';
    }
    
    if (comando.contains('pausar') || comando.contains('pausa') || comando.contains('detener')) {
      if (!comando.contains('temporizador')) {
        return 'pausar';
      }
    }
    
    if (comando.contains('repetir') || comando.contains('otra vez') || comando.contains('de nuevo')) {
      return 'repetir';
    }
    
    if (comando.contains('finalizar') || comando.contains('terminar') || comando.contains('salir')) {
      return 'finalizar';
    }
    
    return comando;
  }

  void dispose() {
    // Solo detener completamente al final
    stopListening();
    stopSpeaking();
    _speechController.close();
    _listeningController.close();
  }

  bool get isListening => _isListening;
  bool get isInitialized => _isInitialized;
  bool get isSpeaking => _isSpeaking;
}
