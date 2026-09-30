import 'package:flutter/services.dart';

/// Native Bridge for Android Accessibility and System Commands.
/// Owned by AGENT 3 (agent-3-android).
class NativeBridge {
  static const MethodChannel _channel = MethodChannel('com.mira.app/native');

  /// Execute an accessible Android command via MethodChannel
  Future<bool> executeAndroidCommand(Map<String, dynamic> commandData) async {
    try {
      final bool? result = await _channel.invokeMethod<bool>('executeCommand', commandData);
      return result ?? false;
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Read current visible screen nodes
  Future<String> readScreenContent() async {
    try {
      final String? text = await _channel.invokeMethod<String>('readScreen');
      return text ?? '';
    } on PlatformException catch (_) {
      return '';
    }
  }
}
