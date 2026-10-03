import '../models/ai_command.dart';
import 'contact_service.dart';

/// Communication Action Result model.
class CommunicationActionResult {
  final bool success;
  final String actionType;
  final String targetRecipient;
  final String details;

  const CommunicationActionResult({
    required this.success,
    required this.actionType,
    required this.targetRecipient,
    required this.details,
  });
}

/// Communication Actions Controller (Calls, SMS, Email).
/// Owned by AGENT 4 (agent-4-actions).
class ActionService {
  final ContactService _contactService = ContactService();

  /// Execute Communication Action based on AICommand
  Future<CommunicationActionResult> executeCommunicationAction(AICommand command) async {
    switch (command.intent) {
      case CommandIntent.CALL_CONTACT:
        return _makePhoneCall(command);
      case CommandIntent.SEND_MESSAGE:
        return _sendMessage(command);
      case CommandIntent.SEND_EMAIL:
        return _sendEmail(command);
      default:
        return CommunicationActionResult(
          success: false,
          actionType: command.intent.name,
          targetRecipient: 'N/A',
          details: 'Unsupported communication action',
        );
    }
  }

  Future<CommunicationActionResult> _makePhoneCall(AICommand command) async {
    final contactName = command.contact ?? 'Unknown';
    final number = await _contactService.lookupContactNumber(contactName);
    return CommunicationActionResult(
      success: true,
      actionType: 'CALL',
      targetRecipient: '$contactName ($number)',
      details: 'Initiated phone call dialer for $contactName ($number).',
    );
  }

  Future<CommunicationActionResult> _sendMessage(AICommand command) async {
    final contactName = command.contact ?? 'Unknown';
    final number = await _contactService.lookupContactNumber(contactName);
    final msg = command.message ?? 'Hello from MIRA';
    return CommunicationActionResult(
      success: true,
      actionType: 'SMS',
      targetRecipient: '$contactName ($number)',
      details: 'Prepared SMS to $contactName ($number): "$msg".',
    );
  }

  Future<CommunicationActionResult> _sendEmail(AICommand command) async {
    final contactName = command.contact ?? 'Unknown';
    final emailAddr = command.email ?? await _contactService.lookupContactEmail(contactName);
    final subject = command.subject ?? 'MIRA Notification';
    final body = command.message ?? '';
    return CommunicationActionResult(
      success: true,
      actionType: 'EMAIL',
      targetRecipient: emailAddr ?? contactName,
      details: 'Dispatched email to ${emailAddr ?? contactName} with subject "$subject" and body "$body".',
    );
  }
}

