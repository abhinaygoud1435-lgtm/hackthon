import 'dart:async';

/// Speech Recognition Abstraction.
/// Owned by AGENT 2 (agent-2-ai).
class SpeechService {
  bool _isListening = false;
  bool get isListening => _isListening;

  Future<bool> initialize() async {
    return true;
  }

  Future<void> startListening({
    required Function(String text) onResult,
    Function(String error)? onError,
  }) async {
    _isListening = true;
  }

  Future<void> stopListening() async {
    _isListening = false;
  }

  /// Simulate receiving spoken voice input for testing or voice triggers
  void simulateSpeechInput(String text, Function(String text) onResult) {
    if (_isListening) {
      onResult(text);
      _isListening = false;
    }
  }
}

