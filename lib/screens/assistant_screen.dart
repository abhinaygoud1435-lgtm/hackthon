import 'package:flutter/material.dart';
import '../models/assistant_state.dart';
import '../widgets/avatar_widget.dart';
import '../widgets/voice_wave.dart';

/// Main Assistant Interface Screen.
/// Owned by AGENT 1 (agent-1-ui).
class AssistantScreen extends StatefulWidget {
  const AssistantScreen({super.key});

  @override
  State<AssistantScreen> createState() => _AssistantScreenState();
}

class _AssistantScreenState extends State<AssistantScreen> {
  final AssistantState _state = AssistantState.idle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MIRA Assistant'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const Spacer(),
            const Center(
              child: AvatarWidget(),
            ),
            const SizedBox(height: 24),
            Text(
              _state.displayName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            const VoiceWave(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}
