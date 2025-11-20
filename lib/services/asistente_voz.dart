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
              print('🔄 Reiniciando por estado notListening');
              startListening();
            }
          });
        }
      },
      onError: (error) {
        print('Error en reconocimiento de voz: $error');
        if (error.errorMsg != 'error_speech_timeout' && 
            error.errorMsg != 'error_no_match') {
          _isListening = false;
          _listeningController.add(false);
        }
        if (!_isSpeaking) {
          Future.delayed(const Duration(milliseconds: 1500), () {
            if (_isInitialized && !_isListening && !_isSpeaking) {
              print('Reiniciando después de error');
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
      Future.delayed(const Duration(milliseconds: 800), () {
        if (_isInitialized && !_isListening && !_isSpeaking) {
          print('Reactivando micrófono automáticamente después de TTS');
          startListening();
        }
      });
    });
    
    _flutterTts.setErrorHandler((msg) {
      print(' Error en TTS: $msg');
      _isSpeaking = false;
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
      print('🔊 Hablando: $text');
      await _flutterTts.speak(text);
      
      await _flutterTts.awaitSpeakCompletion(true);
      
      await Future.delayed(const Duration(milliseconds: 500));
      
      _isSpeaking = false;
      
      if (_isInitialized && !_isListening) {
        print('Reactivando micrófono después de hablar');
        startListening();
      }
    }
  }

  Future<void> stopSpeaking() async {
    await _flutterTts.stop();
    _isSpeaking = false;
  }

  void startListening() {
    if (!_isListening && _isInitialized && !_isSpeaking) {
      print('🎤 Iniciando escucha...');
      _speech.listen(
        onResult: (result) {
          String speech = result.recognizedWords.toLowerCase().trim();
          //consola para ver resultados
          if (result.finalResult) {
            print('FINAL: $speech');
            
            if (speech.length > 2 && interpretarComando(speech)) {
              print('Comando válido detectado: $speech');
              _speechController.add(speech);
            } else {
              print('Comando no reconocido o ruido: $speech');
            }
            
            Future.delayed(const Duration(milliseconds: 800), () {
              if (!_isListening && _isInitialized && !_isSpeaking) {
                print('🔄 Reiniciando escucha automática');
                startListening();
              }
            });
          } else {
            if (speech.isNotEmpty) {
              print('🔊 Escuchando: $speech');
            }
          }
        },
        listenFor: const Duration(seconds: 20),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        localeId: 'es-ES',
        cancelOnError: false,
        listenMode: stt.ListenMode.confirmation,
      );
      _isListening = true;
      _listeningController.add(true);
      print('✅ Micrófono activado');
    } else {
      if (_isSpeaking) {
        print('⏸️ No se inicia escucha porque está hablando');
      }
    }
  }

  void stopListening() {
    if (_isListening) {
      print('🛑 Deteniendo micrófono');
      _speech.stop();
      _isListening = false;
      _listeningController.add(false);
    }
  }

  bool interpretarComando(String comando) {
    comando = comando.toLowerCase().trim();
    
    final List<String> palabrasClave = [
      'empezar', 'empezar', 'iniciar', 'inicio',
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
    
    if (comando.contains('empezar') || comando.contains('empezar')) {
      return 'empezar';
    }
    if (comando.contains('iniciar') && !comando.contains('temporizador')) {
      return 'empezar';
    }
    if (comando.contains('siguiente') || comando.contains('continuar') || comando.contains('continua')) {
      return 'siguiente';
    }
    if (comando.contains('anterior') || comando.contains('atrás') || comando.contains('atras')) {
      return 'anterior';
    }
    if (comando.contains('temporizador') || comando.contains('cronómetro') || comando.contains('cronometro')) {
      return 'temporizador';
    }
    if (comando.contains('listo') || comando.contains('terminado')) {
      return 'listo';
    }
    if (comando.contains('pausar') || comando.contains('pausa') || comando.contains('detener')) {
      return 'pausar';
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
    stopListening();
    stopSpeaking();
    _speechController.close();
    _listeningController.close();
  }

  bool get isListening => _isListening;
  bool get isInitialized => _isInitialized;
  bool get isSpeaking => _isSpeaking;
}