import 'package:flutter/material.dart';
import '../models/ai_command.dart';

/// Conversation Item model for chat UI.
class ChatMessage {
  final String text;
  final bool isUser;
  final AICommand? command;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    this.command,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// Conversation Screen showing Chat History.
/// Owned by AGENT 1 (agent-1-ui).
class ConversationScreen extends StatelessWidget {
  final List<ChatMessage> messages;

  const ConversationScreen({super.key, required this.messages});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Conversation Log')),
      body: messages.isEmpty
          ? const Center(
              child: Text(
                'No conversation history yet.\nSpeak to MIRA on the main screen!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white54),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                return Align(
                  alignment: msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    padding: const EdgeInsets.all(14),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.78),
                    decoration: BoxDecoration(
                      color: msg.isUser ? const Color(0xFF7B2CBF) : const Color(0xFF161B33),
                      borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(16),
                        topRight: const Radius.circular(16),
                        bottomLeft: Radius.circular(msg.isUser ? 16 : 4),
                        bottomRight: Radius.circular(msg.isUser ? 4 : 16),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg.text,
                          style: const TextStyle(color: Colors.white, fontSize: 15),
                        ),
                        if (msg.command != null) ...[
                          const SizedBox(height: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.black26,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'Intent: ${msg.command!.intent.name} (${msg.command!.risk.name} Risk)',
                              style: const TextStyle(color: Color(0xFF00F5D4), fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
