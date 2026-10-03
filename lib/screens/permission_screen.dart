import 'package:flutter/material.dart';
import '../services/native_bridge.dart';

/// Permission Setup UI Screen.
/// Owned by AGENT 1 (agent-1-ui).
class PermissionScreen extends StatefulWidget {
  const PermissionScreen({super.key});

  @override
  State<PermissionScreen> createState() => _PermissionScreenState();
}

class _PermissionScreenState extends State<PermissionScreen> {
  final NativeBridge _nativeBridge = NativeBridge();
  bool _isGranted = false;

  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final granted = await _nativeBridge.isAccessibilityPermissionGranted();
    setState(() {
      _isGranted = granted;
    });
  }

  Future<void> _requestPermission() async {
    await _nativeBridge.requestAccessibilityPermission();
    await _checkPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Permissions Setup')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.accessibility_new, size: 80, color: Color(0xFF00F5D4)),
            const SizedBox(height: 20),
            const Text(
              'Android Accessibility Service',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 12),
            const Text(
              'MIRA requires Accessibility Service permissions to read app screens and execute Android automation controls like YouTube playback and scrolling.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 30),
            Card(
              child: ListTile(
                leading: Icon(
                  _isGranted ? Icons.check_circle : Icons.warning,
                  color: _isGranted ? Colors.green : Colors.amber,
                ),
                title: Text(_isGranted ? 'Permission Active' : 'Permission Required'),
                subtitle: Text(_isGranted ? 'MIRA Accessibility Service enabled' : 'Tap below to grant settings access'),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _requestPermission,
                child: Text(_isGranted ? 'Re-check Permission' : 'Enable in Accessibility Settings'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
