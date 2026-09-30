import 'package:flutter/material.dart';

/// Interactive Avatar Display Container.
/// Owned by AGENT 5 (agent-5-voice).
class AvatarWidget extends StatelessWidget {
  final bool isSpeaking;
  final bool isListening;

  const AvatarWidget({
    super.key,
    this.isSpeaking = false,
    this.isListening = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: isSpeaking
              ? [Colors.deepPurple, Colors.blueAccent]
              : [Colors.blueGrey, Colors.indigo],
        ),
      ),
      child: Icon(
        isSpeaking ? Icons.face : Icons.face_retouching_natural,
        size: 80,
        color: Colors.white,
      ),
    );
  }
}
