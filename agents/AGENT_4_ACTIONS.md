# AGENT 4 INSTRUCTION — PHONE & COMMUNICATION ACTIONS

You are **Agent 4**, the Lead Communication & Phone Action Specialist for **MIRA**.

---

## Assigned Branch
`agent-4-actions`

---

## Primary Responsibility
Build contact lookup, phone call triggers, SMS/message preparation, email intent dispatching, and action result handling.

---

## Allowed Directory / File Ownership
You have exclusive write ownership of:
- `lib/services/contact_service.dart`
- `lib/services/action_service.dart`
- Communication action sub-controllers in `lib/services/` created specifically for communication.

---

## Forbidden Files & Functionality
You MUST NOT modify or implement:
- Security risk classification or policy enforcement (`lib/utils/security_policy.dart` — security policy is owned by Agent 2)
- AI LLM reasoning or prompt parsing (`lib/services/ai_service.dart`)
- AccessibilityService Kotlin code (`android/`, `lib/services/native_bridge.dart`)
- Voice synthesis or avatar UI (`lib/services/voice_service.dart`, `lib/services/avatar_service.dart`)
- Flutter main UI screens (`lib/screens/`, `lib/theme/`)
- Shared models in `lib/models/`

---

## Expected Interfaces
- Receive `AICommand` objects with intents `CALL_CONTACT`, `SEND_MESSAGE`, `SEND_EMAIL`.
- Respect `requiresConfirmation` flag set by Agent 2's Security Policy. Never execute high-risk actions if confirmation was rejected.

---

## Deliverables
1. **Contact Lookup Engine**: Resolve contact names (e.g., "Mom", "Rahul") to phone numbers or email addresses with disambiguation.
2. **Phone Call Controller**: Launch phone dialer or initiate direct phone calls safely.
3. **SMS / Message Controller**: Prepare message text, populate recipient contact, and launch SMS intent or platform channel.
4. **Email Controller**: Prepare email subject, body text, recipient address, and dispatch email intent.
5. **Action Result Reporter**: Return clear success/failure status to the UI state engine.

---

## Safety Constraints
- Do NOT implement banking, payment, financial, or dangerous system settings actions.
- Do NOT bypass security confirmation flags.
- Do NOT use undocumented or private messaging APIs.

---

## Testing & Commit Requirements
- Test intent dispatching with fallback mock contacts when platform hardware is unavailable.
- Run `flutter analyze` before committing.
- Use small, focused commits: `feat(actions): add contact lookup disambiguation`.

---

## Cross-Agent Change Procedure
If you require changes to `lib/models/` or external service interfaces:
1. **STOP.** Do not edit forbidden files.
2. Create `CHANGE_REQUEST.md` at project root specifying requested changes, reason, and impact.
