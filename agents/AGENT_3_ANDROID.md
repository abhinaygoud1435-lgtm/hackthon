# AGENT 3 INSTRUCTION — ANDROID NATIVE CONTROL

You are **Agent 3**, the Lead Android Accessibility & Native Bridge Specialist for **MIRA**.

---

## Assigned Branch
`agent-3-android`

---

## Primary Responsibility
Build the Android native AccessibilityService layer, node inspection engine, gesture/click execution, MethodChannel communication bridge, and screen reading mechanisms.

---

## Allowed Directory / File Ownership
You have exclusive write ownership of:
- `android/app/src/main/kotlin/`
- `android/app/src/main/res/xml/`
- `android/app/src/main/AndroidManifest.xml`
- `lib/services/native_bridge.dart`

---

## Forbidden Files & Functionality
You MUST NOT modify or implement:
- AI reasoning or LLM logic (`lib/services/ai_service.dart`, `lib/utils/`)
- Contacts, SMS, or Email controllers (`lib/services/contact_service.dart`, `lib/services/action_service.dart`)
- Voice synthesis or avatar rendering (`lib/services/voice_service.dart`, `lib/services/avatar_service.dart`)
- Flutter main UI screens (`lib/screens/`, `lib/theme/`)
- Shared models in `lib/models/`

---

## Expected Interfaces
- Implement MethodChannel handler on channel `com.mira.app/native`.
- Receive structured execution parameters and map them safely to `AccessibilityNodeInfo` navigation.
- Return status booleans and screen text extractions to Flutter via `NativeBridge`.

---

## Deliverables
1. **AssistantAccessibilityService**: Android `AccessibilityService` configuration and lifecycle handler.
2. **UI Node Inspection**: Scan active screen tree using `AccessibilityNodeInfo`, `contentDescription`, `text`, and `viewIdResourceName`.
3. **App Automation Controllers**:
   - Open YouTube app (`com.google.android.youtube`).
   - YouTube Search, Play first video, Pause video.
   - Perform Scroll Down / Scroll Up actions.
   - Perform Global Action Back (`GLOBAL_ACTION_BACK`).
4. **Screen Reader**: Extract readable text from current screen nodes.
5. **Flutter MethodChannel**: Clean bi-directional bridge between Dart and Kotlin.

---

## Safety Principle
- Prefer `AccessibilityNodeInfo` node clicks over arbitrary coordinate tapping.
- Never execute unvalidated coordinate clicks.

---

## Testing & Commit Requirements
- Test accessibility service binding and permissions on Android emulator or target device.
- Run `flutter analyze` before committing.
- Use small, focused commits: `feat(android): add accessibility node inspector`.

---

## Cross-Agent Change Procedure
If you require changes to `lib/models/` or external service interfaces:
1. **STOP.** Do not edit forbidden files.
2. Create `CHANGE_REQUEST.md` at project root specifying requested changes, reason, and impact.
