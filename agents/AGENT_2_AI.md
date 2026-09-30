# AGENT 2 INSTRUCTION — AI & COMMAND ENGINE

You are **Agent 2**, the Lead AI Reasoning & Command Architect for **MIRA**.

---

## Assigned Branch
`agent-2-ai`

---

## Primary Responsibility
Build the speech-to-text processing, LLM integration, command parsing, security policy engine, and structured intent extraction.

---

## Allowed Directory / File Ownership
You have exclusive write ownership of:
- `lib/services/ai_service.dart`
- `lib/services/speech_service.dart`
- `lib/utils/security_policy.dart`
- `lib/utils/command_parser.dart`

---

## Forbidden Files & Functionality
You MUST NOT modify or implement:
- Actual Android native accessibility execution (`android/`, `lib/services/native_bridge.dart`)
- Contact lookup or direct phone dialer logic (`lib/services/contact_service.dart`, `lib/services/action_service.dart`)
- Voice synthesis or avatar rendering (`lib/services/voice_service.dart`, `lib/services/avatar_service.dart`, `lib/widgets/avatar_widget.dart`)
- Flutter UI screens or layout themes (`lib/screens/`, `lib/theme/`)
- Shared models in `lib/models/`

---

## Expected Interfaces
- Output strongly typed `AICommand` objects (`lib/models/ai_command.dart`).
- Classify intents into `LOW`, `MEDIUM`, `HIGH`, or `BLOCKED` risk levels according to `SecurityPolicy`.
- Ensure `requiresConfirmation` flag is set correctly on high-risk commands (Calls, Messages, Emails).

---

## Deliverables
1. **Speech-to-Text Abstraction**: Capture raw user audio/transcript.
2. **LLM Command Engine**: Prompt LLM to output valid JSON matching `AICommand` schema.
3. **Command Parser**: Parse raw LLM JSON with fallback handling for malformed JSON, hallucinated fields, or unknown intents.
4. **Security Policy Engine**: Classify actions according to strict risk tiers.
5. **Error & Fallback Handling**: Gracefully handle network timeouts, API errors, and unrecognized user requests.

---

## Testing & Commit Requirements
- Test JSON parsing against all supported intents: `OPEN_APP`, `SEARCH_YOUTUBE`, `PLAY_VIDEO`, `PAUSE_VIDEO`, `SCROLL`, `GO_BACK`, `CALL_CONTACT`, `SEND_MESSAGE`, `SEND_EMAIL`, `READ_SCREEN`, `UNSUPPORTED`.
- Run `flutter analyze` before committing.
- Use small, focused commits: `feat(ai): implement command parser fallback`.

---

## Cross-Agent Change Procedure
If you require changes to `lib/models/` or external service interfaces:
1. **STOP.** Do not edit forbidden files.
2. Create `CHANGE_REQUEST.md` at project root specifying requested changes, reason, and impact.
