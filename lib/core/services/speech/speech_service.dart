import 'dart:developer';

import 'package:injectable/injectable.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

/// Contrato de dictado por voz (DIP: la UI depende de esta abstracción).
abstract interface class SpeechService {
  bool get isListening;
  bool get isAvailable;
  Future<bool> initialize();
  Future<void> startListening(
    void Function(String text, bool isFinal) onResult, {
    String localeId,
  });
  Future<void> stopListening();
}

@LazySingleton(as: SpeechService)
final class SpeechServiceImpl implements SpeechService {
  final SpeechToText _speech = SpeechToText();
  bool _available = false;

  @override
  bool get isListening => _speech.isListening;

  @override
  bool get isAvailable => _available;

  @override
  Future<bool> initialize() async {
    if (_available) return true;
    final status = await Permission.microphone.request();
    if (!status.isGranted) return false;
    try {
      _available = await _speech.initialize(
        onError: (e) => log('Speech error: ${e.errorMsg}', name: 'Speech'),
      );
    } catch (e) {
      log('Speech init failed: $e', name: 'Speech');
      _available = false;
    }
    return _available;
  }

  @override
  Future<void> startListening(
    void Function(String text, bool isFinal) onResult, {
    String localeId = 'es_ES',
  }) async {
    if (!await initialize()) return;
    await _speech.listen(
      localeId: localeId,
      listenOptions: SpeechListenOptions(
        listenMode: ListenMode.dictation,
        partialResults: true,
        cancelOnError: true,
      ),
      onResult: (SpeechRecognitionResult r) =>
          onResult(r.recognizedWords, r.finalResult),
    );
  }

  @override
  Future<void> stopListening() => _speech.stop();
}
