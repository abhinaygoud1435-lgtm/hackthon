import 'package:flutter/material.dart';

/// Audio Visualizer Waveform Widget.
/// Owned by AGENT 5 (agent-5-voice).
class VoiceWave extends StatefulWidget {
  final bool isActive;
  final Color? color;

  const VoiceWave({super.key, this.isActive = false, this.color});

  @override
  State<VoiceWave> createState() => _VoiceWaveState();
}

class _VoiceWaveState extends State<VoiceWave> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = widget.color ?? Colors.cyanAccent;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          height: 48,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(7, (index) {
              final double factor = widget.isActive
                  ? ((index % 2 == 0 ? _controller.value : 1.0 - _controller.value) * 28.0 + 8.0)
                  : 6.0;

              return AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                margin: const EdgeInsets.symmetric(horizontal: 3),
                width: 6,
                height: factor,
                decoration: BoxDecoration(
                  color: widget.isActive ? baseColor : Colors.white24,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: widget.isActive
                      ? [
                          BoxShadow(
                            color: baseColor.withValues(alpha: 0.6),
                            blurRadius: 6,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
              );
            }),
          ),
        );
      },
    );
  }
}

