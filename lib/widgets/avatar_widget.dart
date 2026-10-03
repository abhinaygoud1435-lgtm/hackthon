import 'package:flutter/material.dart';
import '../models/assistant_state.dart';

/// Interactive Animated Avatar Display Container.
/// Owned by AGENT 5 (agent-5-voice).
class AvatarWidget extends StatefulWidget {
  final AssistantState state;
  final bool isSpeaking;
  final bool isListening;

  const AvatarWidget({
    super.key,
    this.state = AssistantState.idle,
    this.isSpeaking = false,
    this.isListening = false,
  });

  @override
  State<AvatarWidget> createState() => _AvatarWidgetState();
}

class _AvatarWidgetState extends State<AvatarWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isActive = widget.isSpeaking || widget.isListening || widget.state.isBusy;
    
    return ScaleTransition(
      scale: isActive ? _pulseAnimation : const AlwaysStoppedAnimation(1.0),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        width: 170,
        height: 170,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: _getColorsForState(widget.state),
          ),
          boxShadow: [
            BoxShadow(
              color: _getColorsForState(widget.state).first.withValues(alpha: 0.45),
              blurRadius: isActive ? 28 : 14,
              spreadRadius: isActive ? 8 : 2,
            ),
          ],
        ),
        child: Center(
          child: Icon(
            _getIconForState(widget.state),
            size: 84,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  List<Color> _getColorsForState(AssistantState state) {
    switch (state) {
      case AssistantState.listening:
        return [const Color(0xFF00E5FF), const Color(0xFF0052D4)];
      case AssistantState.processing:
        return [const Color(0xFF7B1FA2), const Color(0xFFE91E63)];
      case AssistantState.confirmation:
        return [const Color(0xFFFF9800), const Color(0xFFFF5722)];
      case AssistantState.executing:
        return [const Color(0xFF00E676), const Color(0xFF00B0FF)];
      case AssistantState.success:
        return [const Color(0xFF4CAF50), const Color(0xFF009688)];
      case AssistantState.error:
        return [const Color(0xFFF44336), const Color(0xFFB71C1C)];
      case AssistantState.idle:
        return [const Color(0xFF3F51B5), const Color(0xFF2196F3)];
    }
  }

  IconData _getIconForState(AssistantState state) {
    switch (state) {
      case AssistantState.listening:
        return Icons.graphic_eq;
      case AssistantState.processing:
        return Icons.psychology;
      case AssistantState.confirmation:
        return Icons.verified_user;
      case AssistantState.executing:
        return Icons.bolt;
      case AssistantState.success:
        return Icons.check_circle_outline;
      case AssistantState.error:
        return Icons.warning_amber_rounded;
      case AssistantState.idle:
        return Icons.face_retouching_natural;
    }
  }
}

