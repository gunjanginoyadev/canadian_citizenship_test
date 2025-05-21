import 'package:flutter_tts/flutter_tts.dart';

class TTSHelper {
  final FlutterTts _tts = FlutterTts();
  bool isSpeaking = false;

  TTSHelper() {
    _init();
  }

  void _init() {
    _tts.setStartHandler(() {
      isSpeaking = true;
    });

    _tts.setCompletionHandler(() {
      isSpeaking = false;
    });

    _tts.setCancelHandler(() {
      isSpeaking = false;
    });

    _tts.setErrorHandler((msg) {
      isSpeaking = false;
    });

    _tts.setLanguage("en-US");
    _tts.setPitch(1.0);
  }

  Future<void> speak(String text) async {
    if (text.isEmpty) return;
    if (isSpeaking) {
      await stop();
    }
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
    isSpeaking = false;
  }

  void dispose() {
    _tts.stop();
  }
}
