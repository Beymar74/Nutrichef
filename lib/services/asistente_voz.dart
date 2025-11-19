/*import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class VoiceAssistantService {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  StreamController<String> _speechController = StreamController<String>.broadcast();
  StreamController<bool> _listeningController = StreamController<bool>.broadcast();

  Stream<String> get speechStream => _speechController.stream;
  Stream<bool> get listeningStream => _listeningController.stream;

  Future<bool> initialize() async {
    // Solicitar permisos de micrófono
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      return false;
    }

    bool available = await _speech.initialize(
      onStatus: (status) {
        print('Estado del micrófono: $status');
        _isListening = status == 'listening';
        _listeningController.add(_isListening);
      },
      onError: (error) {
        print('Error en reconocimiento de voz: $error');
        _isListening = false;
        _listeningController.add(false);
      },
    );

    return available;
  }

  void startListening() {
    if (!_isListening) {
      _speech.listen(
        onResult: (result) {
          if (result.finalResult) {
            String speech = result.recognizedWords.toLowerCase();
            print('Comando de voz reconocido: $speech');
            _speechController.add(speech);
          }
        },
        listenFor: Duration(seconds: 10),
        pauseFor: Duration(seconds: 3),
        partialResults: true,
        localeId: 'es-ES',
      );
      _isListening = true;
      _listeningController.add(true);
    }
  }

  void stopListening() {
    if (_isListening) {
      _speech.stop();
      _isListening = false;
      _listeningController.add(false);
    }
  }

  void dispose() {
    stopListening();
    _speechController.close();
    _listeningController.close();
  }

  bool get isListening => _isListening;
}*/