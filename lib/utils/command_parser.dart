import 'dart:convert';
import '../models/ai_command.dart';
import 'security_policy.dart';

/// Command Parser Utility.
/// Owned by AGENT 2 (agent-2-ai).
class CommandParser {
  /// Parse raw JSON or fallback to natural language text classification
  static AICommand parseInput(String rawInput) {
    final trimmed = rawInput.trim();
    if (trimmed.startsWith('{') && trimmed.endsWith('}')) {
      return parseJsonResponse(trimmed);
    }
    return parseNaturalLanguage(trimmed);
  }

  /// Parse structured JSON output from LLM
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
      return parseNaturalLanguage(rawJson);
    }
  }

  /// Heuristic & Pattern-based Natural Language Intent & Entity Parser
  static AICommand parseNaturalLanguage(String text) {
    final lower = text.toLowerCase();

    // 1. CALL CONTACT
    if (lower.contains('call ') || lower.startsWith('dial ')) {
      final contact = _extractTarget(text, ['call ', 'dial ']);
      return _buildValidatedCommand(
        intent: CommandIntent.CALL_CONTACT,
        contact: contact.isNotEmpty ? contact : 'Unknown',
        response: 'Calling $contact...',
      );
    }

    // 2. SEND MESSAGE / SMS
    if (lower.contains('send message') || lower.contains('send sms') || lower.contains('text ')) {
      final contact = _extractContactFromText(text);
      final msg = _extractMessageContent(text);
      return _buildValidatedCommand(
        intent: CommandIntent.SEND_MESSAGE,
        contact: contact,
        message: msg,
        response: 'Sending message to $contact: "$msg"',
      );
    }

    // 3. SEND EMAIL
    if (lower.contains('send email') || lower.contains('email ')) {
      final contact = _extractContactFromText(text);
      final subject = _extractEmailSubject(text);
      final body = _extractMessageContent(text);
      return _buildValidatedCommand(
        intent: CommandIntent.SEND_EMAIL,
        contact: contact,
        email: contact.contains('@') ? contact : '$contact@example.com',
        subject: subject,
        message: body,
        response: 'Preparing email to $contact with subject "$subject".',
      );
    }

    // 4. SEARCH YOUTUBE
    if (lower.contains('search youtube') || lower.contains('find on youtube') || lower.contains('search for ')) {
      final query = _extractTarget(text, ['search youtube for ', 'search youtube ', 'find on youtube ', 'search for ']);
      return _buildValidatedCommand(
        intent: CommandIntent.SEARCH_YOUTUBE,
        query: query,
        app: 'com.google.android.youtube',
        response: 'Searching YouTube for "$query"...',
      );
    }

    // 5. OPEN APP
    if (lower.contains('open ') || lower.contains('launch ')) {
      final appName = _extractTarget(text, ['open ', 'launch ']);
      return _buildValidatedCommand(
        intent: CommandIntent.OPEN_APP,
        app: appName.toLowerCase() == 'youtube' ? 'com.google.android.youtube' : appName,
        response: 'Opening $appName...',
      );
    }

    // 6. PLAY / PAUSE VIDEO
    if (lower.contains('play video') || lower.contains('play first video') || lower.contains('play')) {
      return _buildValidatedCommand(
        intent: CommandIntent.PLAY_VIDEO,
        response: 'Playing video...',
      );
    }
    if (lower.contains('pause video') || lower.contains('pause') || lower.contains('stop video')) {
      return _buildValidatedCommand(
        intent: CommandIntent.PAUSE_VIDEO,
        response: 'Pausing video...',
      );
    }

    // 7. SCROLL DOWN / UP
    if (lower.contains('scroll')) {
      final isUp = lower.contains('up');
      return _buildValidatedCommand(
        intent: CommandIntent.SCROLL,
        parameters: {'direction': isUp ? 'UP' : 'DOWN'},
        response: isUp ? 'Scrolling up...' : 'Scrolling down...',
      );
    }

    // 8. GO BACK
    if (lower.contains('go back') || lower == 'back') {
      return _buildValidatedCommand(
        intent: CommandIntent.GO_BACK,
        response: 'Going back...',
      );
    }

    // 9. READ SCREEN
    if (lower.contains('read screen') || lower.contains('what is on screen') || lower.contains('scan screen')) {
      return _buildValidatedCommand(
        intent: CommandIntent.READ_SCREEN,
        response: 'Scanning screen contents...',
      );
    }

    // FALLBACK: UNSUPPORTED
    return const AICommand(
      intent: CommandIntent.UNSUPPORTED,
      risk: RiskLevel.BLOCKED,
      requiresConfirmation: false,
      response: 'Sorry, I did not understand that request.',
    );
  }

  static AICommand _buildValidatedCommand({
    required CommandIntent intent,
    String? app,
    String? contact,
    String? message,
    String? email,
    String? subject,
    String? query,
    Map<String, dynamic> parameters = const {},
    String? response,
  }) {
    final risk = SecurityPolicy.classifyRisk(intent);
    return AICommand(
      intent: intent,
      risk: risk,
      requiresConfirmation: SecurityPolicy.requiresConfirmation(risk),
      app: app,
      contact: contact,
      message: message,
      email: email,
      subject: subject,
      query: query,
      parameters: parameters,
      response: response,
    );
  }

  static String _extractTarget(String text, List<String> prefixes) {
    final lower = text.toLowerCase();
    for (final p in prefixes) {
      final index = lower.indexOf(p);
      if (index != -1) {
        return text.substring(index + p.length).trim();
      }
    }
    return text.trim();
  }

  static String _extractContactFromText(String text) {
    final lower = text.toLowerCase();
    final toIndex = lower.indexOf(' to ');
    if (toIndex != -1) {
      final afterTo = text.substring(toIndex + 4).trim();
      final spaceIndex = afterTo.indexOf(' ');
      if (spaceIndex != -1) {
        return afterTo.substring(0, spaceIndex).trim();
      }
      return afterTo;
    }
    return 'Mom';
  }

  static String _extractMessageContent(String text) {
    final lower = text.toLowerCase();
    final sayingIndex = lower.indexOf('saying ');
    if (sayingIndex != -1) {
      return text.substring(sayingIndex + 7).trim();
    }
    final textIndex = lower.indexOf('text ');
    if (textIndex != -1) {
      return text.substring(textIndex + 5).trim();
    }
    return 'Hello, sent from MIRA Voice Assistant.';
  }

  static String _extractEmailSubject(String text) {
    final lower = text.toLowerCase();
    final subjectIndex = lower.indexOf('subject ');
    if (subjectIndex != -1) {
      final afterSubject = text.substring(subjectIndex + 8).trim();
      final textIndex = afterSubject.toLowerCase().indexOf(' text ');
      if (textIndex != -1) {
        return afterSubject.substring(0, textIndex).trim();
      }
      return afterSubject;
    }
    return 'Notification from MIRA';
  }
}

