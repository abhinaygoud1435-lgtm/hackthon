import '../models/ai_command.dart';
import '../utils/command_parser.dart';

/// AI Service Interface & Engine.
/// Owned by AGENT 2 (agent-2-ai).
class AIService {
  /// Process voice input transcript or JSON string into structured AICommand
  Future<AICommand> processVoiceInput(String transcript) async {
    // Simulate brief processing delay for LLM reasoning
    await Future.delayed(const Duration(milliseconds: 300));
    
    final command = CommandParser.parseInput(transcript);
    return command;
  }
}

