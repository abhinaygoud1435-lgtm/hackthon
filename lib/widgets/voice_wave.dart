import 'package:flutter/material.dart';

/// Audio Visualizer Waveform Widget.
/// Owned by AGENT 5 (agent-5-voice).
class VoiceWave extends StatelessWidget {
  final bool isActive;

  const VoiceWave({super.key, this.isActive = false});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(
          5,
          (index) => AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 6,
            height: isActive ? (15.0 + (index % 3) * 10) : 8.0,
            decoration: BoxDecoration(
              color: isActive ? Colors.cyanAccent : Colors.grey,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ),
    );
  }
}
