import 'package:flutter/material.dart';
import '../models/ai_command.dart';
import '../models/assistant_state.dart';
import '../services/ai_service.dart';
import '../services/speech_service.dart';
import '../services/native_bridge.dart';
import '../services/action_service.dart';
import '../services/voice_service.dart';
import '../widgets/avatar_widget.dart';
import '../widgets/voice_wave.dart';
import '../widgets/confirmation_modal.dart';
import 'conversation_screen.dart';
import 'permission_screen.dart';
import 'settings_screen.dart';

/// Main Assistant Interface Screen.
/// Central Integration Hub connecting all Agent services.
/// Owned by AGENT 1 (agent-1-ui).
class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  // Service instances from Agents 2, 3, 4, 5
  final AIService _aiService = AIService();
  final SpeechService _speechService = SpeechService();
  final NativeBridge _nativeBridge = NativeBridge();
  final ActionService _actionService = ActionService();
  final VoiceService _voiceService = VoiceService();

  AssistantState _state = AssistantState.idle;
  String _statusText = "Tap microphone to speak";
  final List<ChatMessage> _messages = [];

  final TextEditingController _textInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _speechService.initialize();
  }

  void _setState(AssistantState newState, String statusMsg) {
    setState(() {
      _state = newState;
      _statusText = statusMsg;
    });
  }

  Future<void> _startListening() async {
    _setState(AssistantState.listening, "Listening...");
    await _speechService.startListening(
      onResult: (transcript) {
        _processInput(transcript);
      },
    );
  }

  Future<void> _processInput(String input) async {
    if (input.trim().isEmpty) {
      _setState(AssistantState.idle, "Tap microphone to speak");
      return;
    }

    _messages.add(ChatMessage(text: input, isUser: true));
    _setState(AssistantState.processing, "Thinking...");

    final command = await _aiService.processVoiceInput(input);
    _messages.add(ChatMessage(
      text: command.response ?? "Command processed.",
      isUser: false,
      command: command,
    ));

    if (command.requiresConfirmation) {
      _setState(AssistantState.confirmation, "Confirmation required");
      _showConfirmationDialog(command);
    } else {
      await _executeCommand(command);
    }
  }

  void _showConfirmationDialog(AICommand command) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ConfirmationModal(
        command: command,
        onConfirm: () {
          Navigator.of(context).pop();
          _executeCommand(command);
        },
        onCancel: () {
          Navigator.of(context).pop();
          _setState(AssistantState.idle, "Action cancelled by user.");
          _voiceService.speak("Action cancelled.");
        },
      ),
    );
  }

  Future<void> _executeCommand(AICommand command) async {
    _setState(AssistantState.executing, "Executing ${command.intent.name}...");

    bool success = false;
    String feedback = command.response ?? "Executed successfully.";

    // Route to Native Bridge (Agent 3) or Communication Actions (Agent 4)
    if (command.intent == CommandIntent.CALL_CONTACT ||
        command.intent == CommandIntent.SEND_MESSAGE ||
        command.intent == CommandIntent.SEND_EMAIL) {
      final actionResult = await _actionService.executeCommunicationAction(command);
      success = actionResult.success;
      feedback = actionResult.details;
    } else {
      success = await _nativeBridge.executeAICommand(command);
    }

    if (success) {
      _setState(AssistantState.success, feedback);
      await _voiceService.speak(feedback);
      await Future.delayed(const Duration(seconds: 2));
      _setState(AssistantState.idle, "Ready for next command");
    } else {
      _setState(AssistantState.error, "Failed to execute action.");
      await _voiceService.speak("Action failed.");
      await Future.delayed(const Duration(seconds: 2));
      _setState(AssistantState.idle, "Ready for next command");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MIRA Assistant'),
        actions: [
          IconButton(
            icon: const Icon(Icons.forum_outlined),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => ConversationScreen(messages: _messages)),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.accessibility_new),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const PermissionScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            Center(
              child: AvatarWidget(
                state: _state,
                isSpeaking: _voiceService.isSpeaking,
                isListening: _state == AssistantState.listening,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _state.displayName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFF00F5D4),
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Text(
                _statusText,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ),
            const SizedBox(height: 20),
            VoiceWave(isActive: _state.isBusy),
            const Spacer(),

            // Quick text input box for testing commands
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _textInputController,
                      decoration: InputDecoration(
                        hintText: 'Type voice command (e.g. Call Mom)...',
                        filled: true,
                        fillColor: const Color(0xFF161B33),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (val) {
                        _processInput(val);
                        _textInputController.clear();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.send, color: Color(0xFF00F5D4)),
                    onPressed: () {
                      _processInput(_textInputController.text);
                      _textInputController.clear();
                    },
                  ),
                ],
              ),
            ),

            // Voice Activation Floating Mic Button
            GestureDetector(
              onTap: () {
                if (_state == AssistantState.listening) {
                  _speechService.stopListening();
                  _setState(AssistantState.idle, "Tap microphone to speak");
                } else if (!_state.isBusy) {
                  _startListening();
                  // Simulate receiving voice transcript after 1.5 seconds if on desktop/emulator
                  Future.delayed(const Duration(milliseconds: 1500), () {
                    if (_state == AssistantState.listening) {
                      _speechService.simulateSpeechInput("Search YouTube for Flutter tutorials", _processInput);
                    }
                  });
                }
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 24, top: 12),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _state == AssistantState.listening ? Colors.redAccent : const Color(0xFF7B2CBF),
                  boxShadow: [
                    BoxShadow(
                      color: (_state == AssistantState.listening ? Colors.redAccent : const Color(0xFF7B2CBF))
                          .withValues(alpha: 0.5),
                      blurRadius: 18,
                      spreadRadius: 4,
                    ),
                  ],
                ),
                child: Icon(
                  _state == AssistantState.listening ? Icons.mic_off : Icons.mic,
                  size: 36,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
