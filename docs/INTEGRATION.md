# MIRA MULTI-AGENT BRANCH INTEGRATION WORKFLOW

This document outlines how the 5 independent development branches are integrated into `main`.

---

## Branch Structure

```text
main (Integration Branch - Controlled by Human Developer)
 │
 ├── agent-1-ui        (Agent 1: UI / UX)
 ├── agent-2-ai        (Agent 2: AI & Command Engine)
 ├── agent-3-android   (Agent 3: Android Native Control)
 ├── agent-4-actions   (Agent 4: Phone & Communication Actions)
 └── agent-5-voice     (Agent 5: Voice Output & Avatar)
```

---

## Integration Rules

1. **Strict Non-Interference**:
   - Agents NEVER merge their branches into `main` directly.
   - Agents NEVER merge across each other's branches.
   - Only the Human Developer performs merges into `main`.

2. **Pre-Merge Validation**:
   - Before requesting a merge into `main`, the agent must run:
     ```bash
     flutter analyze
     flutter test
     ```
   - All tests must pass and no analyzer errors should remain.

3. **Contract Stability**:
   - Shared models in `lib/models/` (`ai_command.dart`, `assistant_state.dart`) are frozen interfaces.
   - If an agent requires a contract amendment, they must submit a `CHANGE_REQUEST.md` file rather than modifying the contract directly.

---

## Recommended Merge Sequence for Human Developer

```text
1. Merge agent-1-ui      (Establishes layout framework & visual state containers)
2. Merge agent-5-voice   (Integrates TTS and avatar visual widgets into UI)
3. Merge agent-2-ai      (Connects speech parsing and intent policy engine)
4. Merge agent-4-actions (Connects communication & contact action services)
5. Merge agent-3-android (Connects native AccessibilityService bridge)
```
