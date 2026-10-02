package com.mira.mira

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.GestureDescription
import android.content.Intent
import android.graphics.Path
import android.graphics.Rect
import android.net.Uri
import android.util.Log
import android.view.accessibility.AccessibilityEvent
import android.view.accessibility.AccessibilityNodeInfo

class AssistantAccessibilityService : AccessibilityService() {

    companion object {
        private const val TAG = "MiraAccessibility"
        var instance: AssistantAccessibilityService? = null
            private set

        fun isServiceRunning(): Boolean = instance != null
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        instance = this
        Log.d(TAG, "AssistantAccessibilityService Connected")
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        // Events monitored for active context awareness if needed
    }

    override fun onInterrupt() {
        Log.w(TAG, "AssistantAccessibilityService Interrupted")
    }

    override fun onDestroy() {
        super.onDestroy()
        if (instance == this) {
            instance = null
        }
        Log.d(TAG, "AssistantAccessibilityService Destroyed")
    }

    /// Reads readable text from all visible nodes in active window
    fun readScreenContent(): String {
        val rootNode = rootInActiveWindow ?: return ""
        val textList = mutableListOf<String>()
        extractTextFromNode(rootNode, textList)
        rootNode.recycle()
        return textList.distinct().joinToString("\n")
    }

    private fun extractTextFromNode(node: AccessibilityNodeInfo?, result: MutableList<String>) {
        if (node == null || !node.isVisibleToUser) return

        val text = node.text?.toString()?.trim()
        val description = node.contentDescription?.toString()?.trim()

        if (!text.isNullOrEmpty()) {
            result.add(text)
        } else if (!description.isNullOrEmpty()) {
            result.add(description)
        }

        for (i in 0 until node.childCount) {
            val child = node.getChild(i)
            extractTextFromNode(child, result)
            child?.recycle()
        }
    }

    /// Inspect screen nodes tree with detailed properties
    fun inspectScreenNodes(): List<Map<String, Any>> {
        val rootNode = rootInActiveWindow ?: return emptyList()
        val nodesList = mutableListOf<Map<String, Any>>()
        traverseAndInspectNode(rootNode, nodesList)
        rootNode.recycle()
        return nodesList
    }

    private fun traverseAndInspectNode(node: AccessibilityNodeInfo?, result: MutableList<Map<String, Any>>) {
        if (node == null || !node.isVisibleToUser) return

        val text = node.text?.toString()?.trim()
        val description = node.contentDescription?.toString()?.trim()
        val viewId = node.viewIdResourceName?.toString()?.trim()
        val className = node.className?.toString()?.trim()

        if (!text.isNullOrEmpty() || !description.isNullOrEmpty() || !viewId.isNullOrEmpty()) {
            val bounds = Rect()
            node.getBoundsInScreen(bounds)

            val nodeMap = mutableMapOf<String, Any>(
                "text" to (text ?: ""),
                "contentDescription" to (description ?: ""),
                "viewIdResourceName" to (viewId ?: ""),
                "className" to (className ?: ""),
                "isClickable" to node.isClickable,
                "isScrollable" to node.isScrollable,
                "isEditable" to node.isEditable,
                "bounds" to mapOf(
                    "left" to bounds.left,
                    "top" to bounds.top,
                    "right" to bounds.right,
                    "bottom" to bounds.bottom
                )
            )
            result.add(nodeMap)
        }

        for (i in 0 until node.childCount) {
            val child = node.getChild(i)
            traverseAndInspectNode(child, result)
            child?.recycle()
        }
    }

    /// Perform global back action
    fun performGlobalBack(): Boolean {
        return performGlobalAction(GLOBAL_ACTION_BACK)
    }

    /// Scroll active window or focused scrollable node
    fun performScroll(direction: String): Boolean {
        val rootNode = rootInActiveWindow ?: return false
        val scrollableNode = findScrollableNode(rootNode)

        val success = if (scrollableNode != null) {
            val action = if (direction.equals("UP", ignoreCase = true)) {
                AccessibilityNodeInfo.ACTION_SCROLL_BACKWARD
            } else {
                AccessibilityNodeInfo.ACTION_SCROLL_FORWARD
            }
            scrollableNode.performAction(action)
        } else {
            // Fallback gesture scroll
            performScrollGesture(direction)
        }

        scrollableNode?.recycle()
        rootNode.recycle()
        return success
    }

    private fun findScrollableNode(node: AccessibilityNodeInfo?): AccessibilityNodeInfo? {
        if (node == null) return null
        if (node.isScrollable) return node

        for (i in 0 until node.childCount) {
            val child = node.getChild(i)
            val found = findScrollableNode(child)
            if (found != null) {
                if (child != found) child?.recycle()
                return found
            }
            child?.recycle()
        }
        return null
    }

    private fun performScrollGesture(direction: String): Boolean {
        val displayMetrics = resources.displayMetrics
        val width = displayMetrics.widthPixels
        val height = displayMetrics.heightPixels

        val path = Path()
        val startX = (width / 2).toFloat()
        val startY: Float
        val endY: Float

        if (direction.equals("UP", ignoreCase = true)) {
            startY = (height * 0.3).toFloat()
            endY = (height * 0.8).toFloat()
        } else {
            startY = (height * 0.8).toFloat()
            endY = (height * 0.3).toFloat()
        }

        path.moveTo(startX, startY)
        path.lineTo(startX, endY)

        val gestureBuilder = GestureDescription.Builder()
        gestureBuilder.addStroke(GestureDescription.StrokeDescription(path, 0, 300))
        return dispatchGesture(gestureBuilder.build(), null, null)
    }

    /// Execute command payload passed from Flutter
    fun executeCommand(action: String, target: String?, payload: Map<String, Any>?): Boolean {
        Log.d(TAG, "Executing command action: $action, target: $target")
        return when (action.uppercase()) {
            "OPEN_APP" -> openApp(target ?: payload?.get("packageName") as? String ?: "")
            "SEARCH_YOUTUBE" -> searchYouTube(payload?.get("query") as? String ?: target ?: "")
            "PLAY_FIRST_VIDEO" -> playFirstYouTubeVideo()
            "PLAY_VIDEO" -> controlMedia("PLAY")
            "PAUSE_VIDEO" -> controlMedia("PAUSE")
            "SCROLL", "SCROLL_DOWN" -> performScroll("DOWN")
            "SCROLL_UP" -> performScroll("UP")
            "GO_BACK", "GLOBAL_ACTION_BACK" -> performGlobalBack()
            "CLICK" -> clickNodeByTextOrId(target ?: payload?.get("target") as? String ?: "")
            else -> false
        }
    }

    private fun openApp(packageNameOrLabel: String): Boolean {
        if (packageNameOrLabel.isEmpty()) return false
        return try {
            val pm = packageManager
            var launchIntent = pm.getLaunchIntentForPackage(packageNameOrLabel)

            if (launchIntent == null && packageNameOrLabel.equals("YOUTUBE", ignoreCase = true)) {
                launchIntent = pm.getLaunchIntentForPackage("com.google.android.youtube")
            }

            if (launchIntent != null) {
                launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                startActivity(launchIntent)
                true
            } else {
                false
            }
        } catch (e: Exception) {
            Log.e(TAG, "Failed to open app: $packageNameOrLabel", e)
            false
        }
    }

    private fun searchYouTube(query: String): Boolean {
        return try {
            val intent = Intent(Intent.ACTION_VIEW, Uri.parse("https://www.youtube.com/results?search_query=${Uri.encode(query)}"))
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
            intent.setPackage("com.google.android.youtube")
            startActivity(intent)
            true
        } catch (e: Exception) {
            try {
                val intent = Intent(Intent.ACTION_VIEW, Uri.parse("https://www.youtube.com/results?search_query=${Uri.encode(query)}"))
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                startActivity(intent)
                true
            } catch (ex: Exception) {
                false
            }
        }
    }

    private fun playFirstYouTubeVideo(): Boolean {
        val rootNode = rootInActiveWindow ?: return false
        val result = clickFirstPlayableVideoNode(rootNode)
        rootNode.recycle()
        return result
    }

    private fun clickFirstPlayableVideoNode(node: AccessibilityNodeInfo?): Boolean {
        if (node == null) return false

        val viewId = node.viewIdResourceName?.toString() ?: ""
        val contentDesc = node.contentDescription?.toString() ?: ""

        if (node.isClickable && (viewId.contains("thumbnail") || viewId.contains("title") || (contentDesc.isNotEmpty() && !contentDesc.contains("Go to channel")))) {
            if (node.performAction(AccessibilityNodeInfo.ACTION_CLICK)) {
                return true
            }
        }

        for (i in 0 until node.childCount) {
            val child = node.getChild(i)
            val clicked = clickFirstPlayableVideoNode(child)
            child?.recycle()
            if (clicked) return true
        }

        return false
    }

    private fun controlMedia(command: String): Boolean {
        val rootNode = rootInActiveWindow ?: return false
        val targetTexts = if (command == "PLAY") {
            listOf("Play", "Play video", "Resume")
        } else {
            listOf("Pause", "Pause video")
        }

        for (text in targetTexts) {
            val nodes = rootNode.findAccessibilityNodeInfosByText(text)
            if (!nodes.isNullOrEmpty()) {
                for (node in nodes) {
                    if (performClickOnNodeOrParent(node)) {
                        rootNode.recycle()
                        return true
                    }
                }
            }
        }
        rootNode.recycle()
        return false
    }

    private fun clickNodeByTextOrId(target: String): Boolean {
        if (target.isEmpty()) return false
        val rootNode = rootInActiveWindow ?: return false

        if (target.contains(":id/")) {
            val nodesById = rootNode.findAccessibilityNodeInfosByViewId(target)
            if (!nodesById.isNullOrEmpty()) {
                for (node in nodesById) {
                    if (performClickOnNodeOrParent(node)) {
                        rootNode.recycle()
                        return true
                    }
                }
            }
        }

        val nodesByText = rootNode.findAccessibilityNodeInfosByText(target)
        if (!nodesByText.isNullOrEmpty()) {
            for (node in nodesByText) {
                if (performClickOnNodeOrParent(node)) {
                    rootNode.recycle()
                    return true
                }
            }
        }

        rootNode.recycle()
        return false
    }

    private fun performClickOnNodeOrParent(node: AccessibilityNodeInfo?): Boolean {
        if (node == null) return false
        if (node.isClickable && node.performAction(AccessibilityNodeInfo.ACTION_CLICK)) {
            return true
        }
        var parent = node.parent
        while (parent != null) {
            if (parent.isClickable && parent.performAction(AccessibilityNodeInfo.ACTION_CLICK)) {
                return true
            }
            val prevParent = parent
            parent = parent.parent
            prevParent.recycle()
        }
        return false
    }
}

