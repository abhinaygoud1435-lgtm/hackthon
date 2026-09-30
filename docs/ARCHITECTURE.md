# MIRA ARCHITECTURE OVERVIEW

## System Data Flow

```text
USER SPEAKS
    │
    ▼
SPEECH TO TEXT (Agent 2 - speech_service.dart)
    │
    ▼
AI UNDERSTANDS & PARSES INTENT (Agent 2 - ai_service.dart & command_parser.dart)
    │
    ▼
STRUCTURED AI COMMAND (lib/models/ai_command.dart)
    │
    ▼
SECURITY / POLICY CHECK (Agent 2 - security_policy.dart)
    │
    ├─────────────── HIGH RISK? ───────────────┐
    ▼                                          ▼
NO CONFIRMATION NEEDED                 CONFIRMATION REQUIRED (Agent 1 UI Modal)
    │                                          │ (User Approves)
    ├──────────────────────────────────────────┘
    ▼
ACTION ROUTING
    ├── Android UI Control ──────────► AccessibilityService (Agent 3 - native_bridge.dart)
    └── Phone / Comm Actions ────────► Contact & Phone Controllers (Agent 4 - action_service.dart)
    │
    ▼
RESPONSE SYNTHESIS & PRESENTATION
    ├── Voice Output ────────────────► TTS Engine (Agent 5 - voice_service.dart)
    └── Avatar Feedback ─────────────► Avatar Animation (Agent 5 - avatar_widget.dart)
```

## Layer Architecture & Agent Separation

1. **Presentation Layer (`agent-1-ui`)**
   - Flutter UI, Onboarding, Assistant Screen, Chat Bubbles, Confirmation Dialogs, Theme.

2. **Reasoning & Policy Layer (`agent-2-ai`)**
   - STT Abstraction, LLM Integration, Structured Command Generation, Security Risk Classification, Policy Engine.

3. **Android Platform Control Layer (`agent-3-android`)**
   - Android `AccessibilityService`, Node Inspection (`AccessibilityNodeInfo`), YouTube Controller, Screen Reading, MethodChannel `com.mira.app/native`.

4. **Communication & Phone Layer (`agent-4-actions`)**
   - Contact Lookup & Disambiguation, Phone Call Execution, SMS/Messaging Preparation, Email Intent Dispatcher.

5. **Voice Synthesis & Visual Experience Layer (`agent-5-voice`)**
   - TTS Engine & Voice Cloning Backend, Fallback Android TTS, Audio Playback, Animated Avatar Container (`AvatarWidget`), Waveform Visualizer (`VoiceWave`).

6. **Shared Immutable Contracts (`lib/models/`)**
   - `AICommand` schema (intents, risk tiers, payload parameters).
   - `AssistantState` enum (`idle`, `listening`, `processing`, `confirmation`, `executing`, `success`, `error`).
