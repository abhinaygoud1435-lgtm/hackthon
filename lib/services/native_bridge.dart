import 'package:flutter/services.dart';
import '../models/ai_command.dart';

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

  /// Read current visible screen text contents
  Future<String> readScreenContent() async {
    try {
      final String? text = await _channel.invokeMethod<String>('readScreen');
      return text ?? '';
    } on PlatformException catch (_) {
      return '';
    }
  }

  /// Inspect screen nodes tree with viewIdResourceName, bounds, text, contentDescription
  Future<List<Map<String, dynamic>>> inspectScreenNodes() async {
    try {
      final List<dynamic>? nodes = await _channel.invokeMethod<List<dynamic>>('inspectNodes');
      if (nodes == null) return [];
      return nodes.map((node) => Map<String, dynamic>.from(node as Map)).toList();
    } on PlatformException catch (_) {
      return [];
    }
  }

  /// Helper to open YouTube app
  Future<bool> openYouTube() async {
    return executeAndroidCommand({
      'action': 'OPEN_APP',
      'target': 'com.google.android.youtube',
    });
  }

  /// Helper to search YouTube
  Future<bool> searchYouTube(String query) async {
    return executeAndroidCommand({
      'action': 'SEARCH_YOUTUBE',
      'payload': {'query': query},
    });
  }

  /// Helper to play first video in search results
  Future<bool> playFirstVideo() async {
    return executeAndroidCommand({
      'action': 'PLAY_FIRST_VIDEO',
    });
  }

  /// Helper to play video
  Future<bool> playVideo() async {
    return executeAndroidCommand({
      'action': 'PLAY_VIDEO',
    });
  }

  /// Helper to pause video
  Future<bool> pauseVideo() async {
    return executeAndroidCommand({
      'action': 'PAUSE_VIDEO',
    });
  }

  /// Helper to scroll down
  Future<bool> scrollDown() async {
    return executeAndroidCommand({
      'action': 'SCROLL_DOWN',
    });
  }

  /// Helper to scroll up
  Future<bool> scrollUp() async {
    return executeAndroidCommand({
      'action': 'SCROLL_UP',
    });
  }

  /// Helper to perform global back button action
  Future<bool> goBack() async {
    return executeAndroidCommand({
      'action': 'GO_BACK',
    });
  }

  /// Execute a validated AICommand directly on Android native accessibility bridge
  Future<bool> executeAICommand(AICommand command) async {
    switch (command.intent) {
      case CommandIntent.OPEN_APP:
        return executeAndroidCommand({
          'action': 'OPEN_APP',
          'target': command.app ?? 'com.google.android.youtube',
        });
      case CommandIntent.SEARCH_YOUTUBE:
        return searchYouTube(command.query ?? '');
      case CommandIntent.PLAY_VIDEO:
        return playFirstVideo();
      case CommandIntent.PAUSE_VIDEO:
        return pauseVideo();
      case CommandIntent.SCROLL:
        final direction = command.parameters['direction'] as String? ?? 'DOWN';
        return direction.toUpperCase() == 'UP' ? scrollUp() : scrollDown();
      case CommandIntent.GO_BACK:
        return goBack();
      case CommandIntent.READ_SCREEN:
        final text = await readScreenContent();
        return text.isNotEmpty;
      default:
        return false;
    }
  }

  /// Check if the Android Accessibility Service is enabled and active
  Future<bool> isAccessibilityPermissionGranted() async {
    try {
      final bool? result = await _channel.invokeMethod<bool>('isAccessibilityEnabled');
      return result ?? false;
    } on PlatformException catch (_) {
      return false;
    }
  }

  /// Open Android Accessibility Settings to allow user activation
  Future<bool> requestAccessibilityPermission() async {
    try {
      final bool? result = await _channel.invokeMethod<bool>('openAccessibilitySettings');
      return result ?? false;
    } on PlatformException catch (_) {
      return false;
    }
  }
}


