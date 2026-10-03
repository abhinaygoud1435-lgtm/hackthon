import 'package:flutter/material.dart';
import 'assistant_screen.dart';

/// Onboarding Screen for MIRA Assistant.
/// Owned by AGENT 1 (agent-1-ui).
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF7B2CBF).withValues(alpha: 0.2),
                ),
                child: const Icon(Icons.psychology, size: 100, color: Color(0xFF00F5D4)),
              ),
              const SizedBox(height: 32),
              const Text(
                'Welcome to MIRA',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Your AI Voice Assistant capable of controlling Android native apps, making calls, sending messages, and reading your screen.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 15, color: Colors.white70, height: 1.4),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const AssistantScreen()),
                    );
                  },
                  child: const Text('Get Started'),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
