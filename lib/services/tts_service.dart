import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  TtsService._privateConstructor();

  static final TtsService instance = TtsService._privateConstructor();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;

  Future<void> init() async {
    await _flutterTts.setLanguage("en-US");
    await _flutterTts.setSpeechRate(0.5);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setPitch(1.0);

    _flutterTts.setStartHandler(() {
      _isSpeaking = true;
    });

    _flutterTts.setCompletionHandler(() {
      _isSpeaking = false;
    });

    _flutterTts.setCancelHandler(() {
      _isSpeaking = false;
    });
  }

  Future<void> speak(String text) async {
    await _flutterTts.speak(text);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    _isSpeaking = false;
  }

  bool get isSpeaking => _isSpeaking;
}
