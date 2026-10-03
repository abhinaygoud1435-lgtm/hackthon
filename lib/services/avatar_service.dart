import 'dart:async';
import '../models/assistant_state.dart';

/// Avatar Animation and Mouth Sync Service.
/// Owned by AGENT 5 (agent-5-voice).
class AvatarService {
  final _stateController = StreamController<AssistantState>.broadcast();
  Stream<AssistantState> get stateStream => _stateController.stream;

  bool _isSpeaking = false;
  bool get isSpeaking => _isSpeaking;

  void updateState(AssistantState state) {
    _isSpeaking = (state == AssistantState.executing || state == AssistantState.processing);
    _stateController.add(state);
  }

  void setSpeakingState(bool isSpeaking) {
    _isSpeaking = isSpeaking;
  }

  void dispose() {
    _stateController.close();
  }
}

