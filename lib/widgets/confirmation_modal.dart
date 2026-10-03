import 'package:flutter/material.dart';
import '../models/ai_command.dart';

/// Confirmation Modal Dialog for High-Risk Actions.
/// Owned by AGENT 1 (agent-1-ui).
class ConfirmationModal extends StatelessWidget {
  final AICommand command;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;

  const ConfirmationModal({
    super.key,
    required this.command,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF161B33),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.amber, size: 28),
          const SizedBox(width: 10),
          Text(
            'Confirm ${command.intent.name}',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'This command is categorized as a High Risk action:',
            style: TextStyle(color: Colors.white70, fontSize: 14),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (command.contact != null) Text('Contact: ${command.contact}', style: const TextStyle(color: Colors.cyanAccent)),
                if (command.email != null) Text('Email: ${command.email}', style: const TextStyle(color: Colors.cyanAccent)),
                if (command.subject != null) Text('Subject: ${command.subject}', style: const TextStyle(color: Colors.white)),
                if (command.message != null) Text('Message: "${command.message}"', style: const TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Do you authorize MIRA to perform this action?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onCancel,
          child: const Text('Cancel', style: TextStyle(color: Colors.redAccent)),
        ),
        ElevatedButton(
          onPressed: onConfirm,
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
          child: const Text('Authorize'),
        ),
      ],
    );
  }
}
