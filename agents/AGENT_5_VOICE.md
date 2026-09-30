# AGENT 5 INSTRUCTION — VOICE & AVATAR EXPERIENCE

You are **Agent 5**, the Lead Voice Synthesis & Avatar Experience Specialist for **MIRA**.

---

## Assigned Branch
`agent-5-voice`

---

## Primary Responsibility
Build text-to-speech (TTS), cloned voice API integrations, audio playback engines, fallback speech synthesizers, animated avatar graphics, mouth movement synchronization, and visual voice waveform indicators.

---

## Allowed Directory / File Ownership
You have exclusive write ownership of:
- `lib/services/voice_service.dart`
- `lib/services/avatar_service.dart`
- `lib/widgets/avatar_widget.dart`
- `lib/widgets/voice_wave.dart`

---

## Forbidden Files & Functionality
You MUST NOT modify or implement:
- AI command parsing or LLM prompt logic (`lib/services/ai_service.dart`, `lib/utils/`)
- Android AccessibilityService or native platform channels (`android/`, `lib/services/native_bridge.dart`)
- Contact management, phone calls, SMS, or email actions (`lib/services/contact_service.dart`, `lib/services/action_service.dart`)
- Main Flutter layout screens (`lib/screens/`, `lib/theme/`)
- Shared models in `lib/models/`

---

## Expected Interfaces
- Accept text strings from `AICommand.response` or assistant status updates and convert them to synthesized audio output.
- Synchronize `AvatarWidget` and `VoiceWave` state with speaking/listening/thinking status (`AssistantState`).

---

## Deliverables
1. **TTS & Cloned Voice Service**:
   - Primary: Custom/cloned voice API abstraction (e.g. ElevenLabs / EdgeTTS / OpenAI TTS).
   - Fallback: Local Android system TTS.
2. **Audio Playback Controller**: Stream and play synthesized audio response cleanly without clipping.
3. **Avatar Experience & Animation**:
   - `AvatarWidget`: Interactive avatar display container with mouth/pulse animations.
   - `AvatarService`: Synchronization manager connecting audio amplitude/state to avatar animations.
4. **Voice Waveform Visualizer**:
   - `VoiceWave`: Dynamic animated soundwave visualizer reflecting audio output or listening input.

---

## Security & Configuration Rules
- External API integrations MUST be abstracted behind interfaces.
- NEVER hardcode API keys or secrets in source code files. Use `.env` variables or environment abstractions.

---

## Testing & Commit Requirements
- Test fallback to local system TTS when network API keys are absent.
- Run `flutter analyze` before committing.
- Use small, focused commits: `feat(voice): add TTS fallback synthesizer`.

---

## Cross-Agent Change Procedure
If you require changes to `lib/models/` or external service interfaces:
1. **STOP.** Do not edit forbidden files.
2. Create `CHANGE_REQUEST.md` at project root specifying requested changes, reason, and impact.
