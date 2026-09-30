# MIRA

> **Personalized AI Presence & Phone Assistant**

MIRA is a personalized AI assistant that uses a familiar face/avatar and voice while understanding natural voice commands and safely performing selected actions on an Android phone.

---

## Architecture Flow

```text
USER SPEAKS ──► SPEECH TO TEXT ──► AI INTENT PARSER ──► SECURITY POLICY ──► CONFIRMATION (IF HIGH RISK) ──► ANDROID / PHONE ACTION ──► VOICE & AVATAR RESPONSE
```

---

## Tech Stack

- **Frontend & App Framework**: Flutter (Dart 3.8 / Flutter 3.32)
- **Native Android Layer**: Kotlin, Android `AccessibilityService`, `AccessibilityNodeInfo`
- **AI & Reasoning Engine**: LLM API, Structured JSON Parsing, Policy Engine
- **Voice & Synthesis**: Speech-To-Text (STT), Text-To-Speech (TTS), Cloned Voice API
- **Avatar Experience**: Animated Custom Widgets & Audio Synchronization

---

## Multi-Agent Architecture & Ownership

This repository is structured for parallel development by 5 independent AI coding agents:

| Agent | Ownership Scope | Assigned Branch |
|---|---|---|
| **Agent 1 — UI / UX** | `lib/screens/`, `lib/theme/`, `lib/ui/`, layout `lib/widgets/` | `agent-1-ui` |
| **Agent 2 — AI / Command Engine** | `lib/services/ai_service.dart`, `speech_service.dart`, `security_policy.dart`, `command_parser.dart` | `agent-2-ai` |
| **Agent 3 — Android Control** | `android/`, `lib/services/native_bridge.dart` | `agent-3-android` |
| **Agent 4 — Phone / Actions** | `lib/services/contact_service.dart`, `action_service.dart` | `agent-4-actions` |
| **Agent 5 — Voice / Avatar** | `lib/services/voice_service.dart`, `avatar_service.dart`, `avatar_widget.dart`, `voice_wave.dart` | `agent-5-voice` |

---

## Git Branches

- `main` *(Controlled Integration Branch)*
- `agent-1-ui`
- `agent-2-ai`
- `agent-3-android`
- `agent-4-actions`
- `agent-5-voice`

---

## Security Model

MIRA enforces a policy boundary that prevents the AI from directly executing unvalidated platform actions.

- **LOW RISK (Auto Executed)**: Open App, YouTube Search, Play/Pause Video, Scroll, Go Back.
- **MEDIUM RISK (Visual Feedback)**: Read Screen Text.
- **HIGH RISK (User Confirmation Modal)**: Phone Calls, SMS Messages, Emails.
- **BLOCKED**: Banking, Money Transfer, Password Changes, Security Settings, Account Deletion, Purchases.

---

## Supported MVP Commands

- *"Open YouTube."*
- *"Search YouTube for relaxing music."*
- *"Play the first video."*
- *"Pause."*
- *"Scroll down."*
- *"Go back."*
- *"Call Mom."*
- *"Send Rahul a message saying I'll reach by six."*
- *"Send an email to Rahul saying I'll reach by six."*
- *"What is on my screen?"*

---

## Future Roadmap

- **Phase 1**: Hackathon MVP Architecture (Current)
- **Phase 2**: Live Face Verification, Speaker Verification, Anti-spoofing Liveness
- **Phase 3**: WhatsApp, Gmail, Uber, & Multi-app Accessibility Control
- **Phase 4**: Autonomous Proactive Personal AI Agent with Edge SLM

---

## Setup & Getting Started

1. Copy `.env.example` to `.env` and fill in optional API keys:
   ```bash
   cp .env.example .env
   ```
2. Fetch Flutter dependencies:
   ```bash
   flutter pub get
   ```
3. Run static analyzer:
   ```bash
   flutter analyze
   ```
4. Refer to `AGENT_RULES.md` and specific agent instruction files in `agents/` before modifying code.
