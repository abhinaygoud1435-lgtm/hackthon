import 'package:flutter/material.dart';
import 'screens/assistant_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const MiraApp());
}

class MiraApp extends StatelessWidget {
  const MiraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MIRA AI Assistant',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const AssistantScreen(),
    );
  }
}
