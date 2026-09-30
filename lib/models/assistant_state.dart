/// Shared Assistant State Model for MIRA.
/// Owned by system / Frozen contract.
/// Do NOT modify without creating a CHANGE_REQUEST.md.
library;

enum AssistantState {
  idle,
  listening,
  processing,
  confirmation,
  executing,
  success,
  error;

  bool get isBusy =>
      this == AssistantState.listening ||
      this == AssistantState.processing ||
      this == AssistantState.executing;

  String get displayName {
    switch (this) {
      case AssistantState.idle:
        return 'Ready';
      case AssistantState.listening:
        return 'Listening...';
      case AssistantState.processing:
        return 'Thinking...';
      case AssistantState.confirmation:
        return 'Confirmation Required';
      case AssistantState.executing:
        return 'Executing...';
      case AssistantState.success:
        return 'Done';
      case AssistantState.error:
        return 'Error';
    }
  }
}
