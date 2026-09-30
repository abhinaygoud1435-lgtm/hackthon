import 'package:flutter/material.dart';

/// Application Dark/Light Theme Configuration.
/// Owned by AGENT 1 (agent-1-ui).
class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData.dark(useMaterial3: true).copyWith(
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF6366F1),
        secondary: Color(0xFF06B6D4),
        surface: Color(0xFF1E293B),
      ),
    );
  }
}
