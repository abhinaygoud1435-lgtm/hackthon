// ignore_for_file: constant_identifier_names

/// Shared Command Contract for MIRA AI Assistant.
/// Owned by system / Frozen contract.
/// Do NOT modify without creating a CHANGE_REQUEST.md.
library;

enum CommandIntent {
  OPEN_APP,
  SEARCH_YOUTUBE,
  PLAY_VIDEO,
  PAUSE_VIDEO,
  SCROLL,
  GO_BACK,
  CALL_CONTACT,
  SEND_MESSAGE,
  SEND_EMAIL,
  READ_SCREEN,
  UNSUPPORTED;

  static CommandIntent fromString(String value) {
    return CommandIntent.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => CommandIntent.UNSUPPORTED,
    );
  }
}

enum RiskLevel {
  LOW,
  MEDIUM,
  HIGH,
  BLOCKED;

  static RiskLevel fromString(String value) {
    return RiskLevel.values.firstWhere(
      (e) => e.name.toUpperCase() == value.toUpperCase(),
      orElse: () => RiskLevel.MEDIUM,
    );
  }
}

class AICommand {
  final CommandIntent intent;
  final RiskLevel risk;
  final bool requiresConfirmation;
  final String? app;
  final String? contact;
  final String? message;
  final String? email;
  final String? subject;
  final String? query;
  final Map<String, dynamic> parameters;
  final String? response;

  const AICommand({
    required this.intent,
    required this.risk,
    required this.requiresConfirmation,
    this.app,
    this.contact,
    this.message,
    this.email,
    this.subject,
    this.query,
    this.parameters = const {},
    this.response,
  });

  factory AICommand.fromJson(Map<String, dynamic> json) {
    return AICommand(
      intent: json['intent'] is String
          ? CommandIntent.fromString(json['intent'])
          : CommandIntent.UNSUPPORTED,
      risk: json['risk'] is String
          ? RiskLevel.fromString(json['risk'])
          : RiskLevel.MEDIUM,
      requiresConfirmation: json['requiresConfirmation'] as bool? ?? false,
      app: json['app'] as String?,
      contact: json['contact'] as String?,
      message: json['message'] as String?,
      email: json['email'] as String?,
      subject: json['subject'] as String?,
      query: json['query'] as String?,
      parameters: json['parameters'] is Map<String, dynamic>
          ? Map<String, dynamic>.from(json['parameters'] as Map)
          : const {},
      response: json['response'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'intent': intent.name,
      'risk': risk.name,
      'requiresConfirmation': requiresConfirmation,
      if (app != null) 'app': app,
      if (contact != null) 'contact': contact,
      if (message != null) 'message': message,
      if (email != null) 'email': email,
      if (subject != null) 'subject': subject,
      if (query != null) 'query': query,
      'parameters': parameters,
      if (response != null) 'response': response,
    };
  }

  AICommand copyWith({
    CommandIntent? intent,
    RiskLevel? risk,
    bool? requiresConfirmation,
    String? app,
    String? contact,
    String? message,
    String? email,
    String? subject,
    String? query,
    Map<String, dynamic>? parameters,
    String? response,
  }) {
    return AICommand(
      intent: intent ?? this.intent,
      risk: risk ?? this.risk,
      requiresConfirmation: requiresConfirmation ?? this.requiresConfirmation,
      app: app ?? this.app,
      contact: contact ?? this.contact,
      message: message ?? this.message,
      email: email ?? this.email,
      subject: subject ?? this.subject,
      query: query ?? this.query,
      parameters: parameters ?? this.parameters,
      response: response ?? this.response,
    );
  }

  @override
  String toString() {
    return 'AICommand(intent: $intent, risk: $risk, requiresConfirmation: $requiresConfirmation, app: $app, contact: $contact, query: $query)';
  }
}
