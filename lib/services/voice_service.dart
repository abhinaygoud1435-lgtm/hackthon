import 'dart:async';

/// Voice Output and TTS Engine.
/// Owned by AGENT 5 (agent-5-voice).
class VoiceService {
  bool _isSpeaking = false;
  bool get isSpeaking => _isSpeaking;

  void Function()? onSpeechStart;
  void Function()? onSpeechComplete;

  /// Synthesize and speak text output
  Future<void> speak(String text) async {
    _isSpeaking = true;
    onSpeechStart?.call();

    // Simulate speech playback duration proportional to length
    final durationMs = (text.length * 50).clamp(1200, 5000);
    await Future.delayed(Duration(milliseconds: durationMs));

    _isSpeaking = false;
    onSpeechComplete?.call();
  }

  /// Stop active speech playback
  Future<void> stop() async {
    _isSpeaking = false;
    onSpeechComplete?.call();
  }
}

