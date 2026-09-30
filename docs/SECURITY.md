# MIRA SECURITY MODEL & POLICY ENGINE

## Core Security Philosophy

MIRA operates under a strict **Policy-First AI Architecture**. The AI Reasoning Engine (LLM) generates intent proposals, but **CANNOT** directly execute platform actions or bypass security policy rules.

```text
  ┌─────────────────┐
  │   User Input    │
  └────────┬────────┘
           │
           ▼
  ┌─────────────────┐
  │   AI Service    │
  └────────┬────────┘
           │ (Proposes Command JSON)
           ▼
  ┌─────────────────┐
  │ Security Policy │ ◄── IMPERMEABLE POLICY BOUNDARY
  └────────┬────────┘
           │
  ┌────────┴────────┐
  ▼                 ▼
ALLOWED          BLOCKED / CONFIRMATION REQUIRED
```

---

## Security Tiers

### Tier 1 — LOW RISK (Automatic Execution)
- **Intents**: `OPEN_APP`, `SEARCH_YOUTUBE`, `PLAY_VIDEO`, `PAUSE_VIDEO`, `SCROLL`, `GO_BACK`
- **Behavior**: Executed immediately without user prompt.
- **Scope**: Non-destructive navigation and UI control.

### Tier 2 — MEDIUM RISK (Logged / Monitored Execution)
- **Intents**: `READ_SCREEN`
- **Behavior**: User visual indicator displayed during screen reading.
- **Scope**: Reading active accessibility node text.

### Tier 3 — HIGH RISK (Explicit User Confirmation Required)
- **Intents**: `CALL_CONTACT`, `SEND_MESSAGE`, `SEND_EMAIL`
- **Behavior**: Requires explicit modal confirmation on Agent 1 UI before Agent 4 dispatches action.
- **Scope**: Communication actions involving external individuals.

### Tier 4 — BLOCKED (Prohibited Actions)
- **Blocked Operations**:
  - Financial, Banking, & Payment apps/intents.
  - Money transfers or crypto operations.
  - Password, PIN, or credential changes.
  - System security settings or device wipe.
  - Account deletion or in-app purchases.
- **Behavior**: Rejected immediately by Policy Engine before reaching execution agents.

---

## Multi-Agent Boundary Protection

- **Agent 2 (AI)**: Only classifies risk and formats intent JSON. Does NOT execute actions.
- **Agent 1 (UI)**: Displays confirmation modals for HIGH risk commands.
- **Agent 4 (Actions)**: Re-verifies `requiresConfirmation` flag before executing any call/SMS/email.
- **Agent 3 (Android)**: Restricts native accessibility actions to inspected safe UI nodes (`AccessibilityNodeInfo`). Coordinate tapping is forbidden.
