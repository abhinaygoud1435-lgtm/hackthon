/// Speech Recognition Abstraction.
/// Owned by AGENT 2 (agent-2-ai).
class SpeechService {
  Future<bool> initialize() async {
    return true;
  }

  Future<void> startListening({required Function(String text) onResult}) async {
    // Agent 2 speech-to-text implementation stub
  }

  Future<void> stopListening() async {}
}
