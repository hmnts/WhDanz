import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused }

class VoiceFeedbackService {
  final FlutterTts _flutterTts = FlutterTts();
  TtsState _state = TtsState.stopped;
  bool _isEnabled = true;
  double _speechRate = 0.5;
  double _pitch = 1.0;
  double _volume = 1.0;

  bool get isEnabled => _isEnabled;
  TtsState get state => _state;

  Future<void> initialize() async {
    await _flutterTts.setLanguage('es-ES');
    await _flutterTts.setSpeechRate(_speechRate);
    await _flutterTts.setPitch(_pitch);
    await _flutterTts.setVolume(_volume);

    _flutterTts.setStartHandler(() {
      _state = TtsState.playing;
    });

    _flutterTts.setCompletionHandler(() {
      _state = TtsState.stopped;
    });

    _flutterTts.setErrorHandler((msg) {
      _state = TtsState.stopped;
    });

    _flutterTts.setCancelHandler(() {
      _state = TtsState.stopped;
    });
  }

  Future<void> speak(String text) async {
    if (!_isEnabled || text.isEmpty) return;
    
    if (_state == TtsState.playing) {
      await stop();
    }
    
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    _state = TtsState.stopped;
  }

  Future<void> pause() async {
    await _flutterTts.pause();
    _state = TtsState.paused;
  }

  void toggleEnabled() {
    _isEnabled = !_isEnabled;
  }

  void setEnabled(bool enabled) {
    _isEnabled = enabled;
  }

  Future<void> setSpeechRate(double rate) async {
    _speechRate = rate.clamp(0.0, 1.0);
    await _flutterTts.setSpeechRate(_speechRate);
  }

  Future<void> setPitch(double pitch) async {
    _pitch = pitch.clamp(0.5, 2.0);
    await _flutterTts.setPitch(_pitch);
  }

  Future<void> setVolume(double volume) async {
    _volume = volume.clamp(0.0, 1.0);
    await _flutterTts.setVolume(_volume);
  }

  String generateFeedbackMessage(String jointName, double deviation, String direction) {
    final jointNamesSpanish = {
      'left_elbow': 'codo izquierdo',
      'right_elbow': 'codo derecho',
      'left_knee': 'rodilla izquierda',
      'right_knee': 'rodilla derecha',
      'left_hip_flexion': 'cadera izquierda',
      'right_hip_flexion': 'cadera derecha',
      'spine_lateral': 'columna',
      'left_shoulder_abduction': 'brazo izquierdo',
      'right_shoulder_abduction': 'brazo derecho',
    };

    final spanishName = jointNamesSpanish[jointName] ?? jointName;
    final magnitude = deviation > 30 ? 'considerablemente' : 'un poco';

    if (direction == 'up' || direction == 'raise') {
      return 'Levanta $spanishName $magnitude';
    } else if (direction == 'down' || direction == 'lower') {
      return 'Baja $spanishName $magnitude';
    } else if (direction == 'straighten') {
      return 'Endereza $spanishName';
    } else if (direction == 'bend') {
      return 'Dobla $spanishName';
    }
    return 'Ajusta $spanishName';
  }

  Future<void> speakInitialFeedback(String poseName) async {
    await speak('Comenzando práctica de $poseName. Prepárate en posición inicial.');
  }

  Future<void> speakScoreFeedback(double score) async {
    String message;
    if (score >= 90) {
      message = '¡Excelente! Puntuación de $score por ciento';
    } else if (score >= 70) {
      message = 'Muy bien. Puntuación de $score por ciento';
    } else if (score >= 50) {
      message = 'Continúa practicando. Puntuación de $score por ciento';
    } else {
      message = 'Necesitas mejorar. Puntuación de $score por ciento';
    }
    await speak(message);
  }

  Future<void> speakEncouragement() async {
    final encouragements = [
      '¡Sigue así!',
      '¡Buen trabajo!',
      '¡Muy bien!',
      '¡Continúa!',
      '¡Vas muy bien!',
    ];
    final random = DateTime.now().millisecondsSinceEpoch % encouragements.length;
    await speak(encouragements[random]);
  }

  void dispose() {
    _flutterTts.stop();
  }
}
