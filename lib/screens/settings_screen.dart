import 'package:flutter/material.dart';

/// Settings & Configuration Screen.
/// Owned by AGENT 1 (agent-1-ui).
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _voiceFeedback = true;
  bool _confirmHighRisk = true;
  final String _selectedVoice = 'Standard Neural (Female)';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MIRA Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Voice & Audio', style: TextStyle(color: Color(0xFF00F5D4), fontWeight: FontWeight.bold)),
          SwitchListTile(
            title: const Text('Voice Feedback (TTS)'),
            subtitle: const Text('Speak AI command results aloud'),
            value: _voiceFeedback,
            onChanged: (val) => setState(() => _voiceFeedback = val),
          ),
          ListTile(
            title: const Text('Voice Engine'),
            subtitle: Text(_selectedVoice),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {
              // Voice selection options
            },
          ),
          const Divider(height: 32),
          const Text('Security Policy', style: TextStyle(color: Color(0xFF00F5D4), fontWeight: FontWeight.bold)),
          SwitchListTile(
            title: const Text('Confirm High Risk Actions'),
            subtitle: const Text('Prompt for approval before calls, SMS, or emails'),
            value: _confirmHighRisk,
            onChanged: (val) => setState(() => _confirmHighRisk = val),
          ),
        ],
      ),
    );
  }
}
