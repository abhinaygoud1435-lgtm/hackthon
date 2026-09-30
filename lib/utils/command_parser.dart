import 'dart:convert';
import '../models/ai_command.dart';
import 'security_policy.dart';

/// Command Parser Utility.
/// Owned by AGENT 2 (agent-2-ai).
class CommandParser {
  static AICommand parseJsonResponse(String rawJson) {
    try {
      final Map<String, dynamic> data = jsonDecode(rawJson) as Map<String, dynamic>;
      final command = AICommand.fromJson(data);
      final risk = SecurityPolicy.classifyRisk(command.intent);
      return command.copyWith(
        risk: risk,
        requiresConfirmation: SecurityPolicy.requiresConfirmation(risk),
      );
    } catch (_) {
      return const AICommand(
        intent: CommandIntent.UNSUPPORTED,
        risk: RiskLevel.BLOCKED,
        requiresConfirmation: false,
        response: "Failed to parse command.",
      );
    }
  }
}
