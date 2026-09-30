import '../models/ai_command.dart';

/// AI Service Interface & Stub.
/// Owned by AGENT 2 (agent-2-ai).
class AIService {
  Future<AICommand> processVoiceInput(String transcript) async {
    // Agent 2 will implement LLM reasoning here.
    return const AICommand(
      intent: CommandIntent.UNSUPPORTED,
      risk: RiskLevel.LOW,
      requiresConfirmation: false,
      response: "AI service initialized stub.",
    );
  }
}
