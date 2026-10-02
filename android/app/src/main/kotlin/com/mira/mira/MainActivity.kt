package com.mira.mira

import android.content.Intent
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private const val CHANNEL = "com.mira.app/native"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "executeCommand" -> {
                    val arguments = call.arguments as? Map<String, Any>
                    val action = arguments?.get("action") as? String ?: ""
                    val target = arguments?.get("target") as? String
                    @Suppress("UNCHECKED_CAST")
                    val payload = arguments?.get("payload") as? Map<String, Any>

                    val service = AssistantAccessibilityService.instance
                    if (service != null) {
                        val success = service.executeCommand(action, target, payload ?: arguments)
                        result.success(success)
                    } else {
                        // Service not enabled or connected
                        result.success(false)
                    }
                }
                "readScreen" -> {
                    val service = AssistantAccessibilityService.instance
                    if (service != null) {
                        val text = service.readScreenContent()
                        result.success(text)
                    } else {
                        result.success("")
                    }
                }
                "inspectNodes" -> {
                    val service = AssistantAccessibilityService.instance
                    if (service != null) {
                        val nodes = service.inspectScreenNodes()
                        result.success(nodes)
                    } else {
                        result.success(emptyList<Map<String, Any>>())
                    }
                }
                "isAccessibilityEnabled" -> {
                    result.success(AssistantAccessibilityService.isServiceRunning())
                }
                "openAccessibilitySettings" -> {
                    try {
                        val intent = Intent(Settings.ACTION_ACCESSIBILITY_SETTINGS)
                        intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.success(false)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
}
