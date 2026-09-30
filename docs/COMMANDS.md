# MIRA SUPPORTED INTENT & COMMAND SPECIFICATION

This document details all supported intents, expected JSON payload structures, risk levels, and handling agents.

---

## Intent Registry

| Intent | Description | Risk Level | Requires Confirmation | Primary Executing Agent |
|---|---|---|---|---|
| `OPEN_APP` | Launch target Android application | LOW | No | Agent 3 (Android) |
| `SEARCH_YOUTUBE` | Search query in YouTube app | LOW | No | Agent 3 (Android) |
| `PLAY_VIDEO` | Play active or first YouTube video | LOW | No | Agent 3 (Android) |
| `PAUSE_VIDEO` | Pause currently playing media | LOW | No | Agent 3 (Android) |
| `SCROLL` | Scroll down or up on screen | LOW | No | Agent 3 (Android) |
| `GO_BACK` | Perform system Back navigation | LOW | No | Agent 3 (Android) |
| `READ_SCREEN` | Read visible text content on screen | MEDIUM | No | Agent 3 (Android) |
| `CALL_CONTACT` | Initiate phone call to named contact | HIGH | **YES** | Agent 4 (Actions) |
| `SEND_MESSAGE` | Send SMS/chat message to contact | HIGH | **YES** | Agent 4 (Actions) |
| `SEND_EMAIL` | Prepare/send email to contact | HIGH | **YES** | Agent 4 (Actions) |
| `UNSUPPORTED` | Intent not supported or invalid | BLOCKED | N/A | Agent 2 (AI) |

---

## JSON Command Payloads

### 1. `OPEN_APP`
```json
{
  "intent": "OPEN_APP",
  "app": "YouTube",
  "risk": "LOW",
  "requiresConfirmation": false,
  "response": "Opening YouTube."
}
```

### 2. `SEARCH_YOUTUBE`
```json
{
  "intent": "SEARCH_YOUTUBE",
  "app": "YouTube",
  "query": "relaxing music",
  "risk": "LOW",
  "requiresConfirmation": false,
  "response": "Searching YouTube for relaxing music."
}
```

### 3. `PLAY_VIDEO`
```json
{
  "intent": "PLAY_VIDEO",
  "app": "YouTube",
  "risk": "LOW",
  "requiresConfirmation": false,
  "response": "Playing video."
}
```

### 4. `CALL_CONTACT`
```json
{
  "intent": "CALL_CONTACT",
  "contact": "Mom",
  "risk": "HIGH",
  "requiresConfirmation": true,
  "response": "Should I place a call to Mom?"
}
```

### 5. `SEND_MESSAGE`
```json
{
  "intent": "SEND_MESSAGE",
  "contact": "Rahul",
  "message": "I'll reach by six.",
  "risk": "HIGH",
  "requiresConfirmation": true,
  "response": "Should I send this message to Rahul: 'I'll reach by six'?"
}
```

### 6. `SEND_EMAIL`
```json
{
  "intent": "SEND_EMAIL",
  "contact": "Rahul",
  "subject": "Arrival Update",
  "message": "I'll reach by six.",
  "risk": "HIGH",
  "requiresConfirmation": true,
  "response": "Should I send an email to Rahul with subject 'Arrival Update'?"
}
```

### 7. `READ_SCREEN`
```json
{
  "intent": "READ_SCREEN",
  "risk": "MEDIUM",
  "requiresConfirmation": false,
  "response": "Reading screen content."
}
```
