import '../models/ai_command.dart';

/// Security Policy Engine.
/// Owned by AGENT 2 (agent-2-ai).
class SecurityPolicy {
  static RiskLevel classifyRisk(CommandIntent intent) {
    switch (intent) {
      case CommandIntent.OPEN_APP:
      case CommandIntent.SEARCH_YOUTUBE:
      case CommandIntent.PLAY_VIDEO:
      case CommandIntent.PAUSE_VIDEO:
      case CommandIntent.SCROLL:
      case CommandIntent.GO_BACK:
        return RiskLevel.LOW;
      case CommandIntent.READ_SCREEN:
        return RiskLevel.MEDIUM;
      case CommandIntent.CALL_CONTACT:
      case CommandIntent.SEND_MESSAGE:
      case CommandIntent.SEND_EMAIL:
        return RiskLevel.HIGH;
      case CommandIntent.UNSUPPORTED:
        return RiskLevel.BLOCKED;
    }
  }

  static bool requiresConfirmation(RiskLevel risk) {
    return risk == RiskLevel.HIGH;
  }
}
