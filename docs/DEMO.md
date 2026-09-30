# MIRA HACKATHON DEMO SPECIFICATION

This document outlines the step-by-step hackathon demonstration scenarios, expected system behaviors, and error handling edge cases.

---

## Standard Demo Flow Commands

### Demo Scenario 1: YouTube Navigation & Control
1. **User Voice Input**: *"Open YouTube."*
   - Intent: `OPEN_APP` (App: "YouTube")
   - Action: Android AccessibilityService opens YouTube.
   - Voice/Avatar: *"Opening YouTube."*

2. **User Voice Input**: *"Search YouTube for relaxing music."*
   - Intent: `SEARCH_YOUTUBE` (Query: "relaxing music")
   - Action: Types search query into YouTube search box.
   - Voice/Avatar: *"Searching YouTube for relaxing music."*

3. **User Voice Input**: *"Play the first video."*
   - Intent: `PLAY_VIDEO`
   - Action: Clicks first search result node.
   - Voice/Avatar: *"Playing video."*

4. **User Voice Input**: *"Pause."*
   - Intent: `PAUSE_VIDEO`
   - Action: Clicks video player pause node.
   - Voice/Avatar: *"Paused."*

5. **User Voice Input**: *"Scroll down."*
   - Intent: `SCROLL`
   - Action: Performs vertical scroll gesture.

6. **User Voice Input**: *"Go back."*
   - Intent: `GO_BACK`
   - Action: Triggers system Back button.

---

### Demo Scenario 2: High-Risk Phone Communication (With Confirmation)
1. **User Voice Input**: *"Call Mom."*
   - Intent: `CALL_CONTACT` (Contact: "Mom")
   - Policy: HIGH Risk. `requiresConfirmation = true`.
   - UI: Confirmation dialog pops up on screen: *"Call Mom (+1-555-0192)?"*
   - User clicks **Confirm** -> Phone dialer initiates call.

2. **User Voice Input**: *"Send Rahul a message saying I'll reach by six."*
   - Intent: `SEND_MESSAGE` (Contact: "Rahul", Message: "I'll reach by six")
   - Policy: HIGH Risk. `requiresConfirmation = true`.
   - UI: Confirmation modal displays message preview.
   - User clicks **Confirm** -> SMS intent dispatched.

3. **User Voice Input**: *"Send an email to Rahul saying I'll reach by six."*
   - Intent: `SEND_EMAIL` (Contact: "Rahul", Subject: "Arrival", Message: "I'll reach by six")
   - Policy: HIGH Risk. `requiresConfirmation = true`.
   - UI: Confirmation modal displays email preview.

---

### Demo Scenario 3: Screen Understanding
1. **User Voice Input**: *"What is on my screen?"*
   - Intent: `READ_SCREEN`
   - Policy: MEDIUM Risk.
   - Action: Scans visible `AccessibilityNodeInfo` text elements.
   - Voice/Avatar: Reads synthesized text summary of screen content.

---

## Edge Case & Error Handling Demos

1. **Unknown Command**: *"Do a backflip."*
   - Intent: `UNSUPPORTED`
   - System response: *"I'm sorry, I don't know how to do that yet."*

2. **Unknown Contact**: *"Call UnknownPersonX."*
   - System response: *"Could not find UnknownPersonX in your contacts."*

3. **Multiple Contacts Disambiguation**: *"Call Alex."* (Alex Smith vs Alex Johnson)
   - System response: *"Which Alex would you like to call? Alex Smith or Alex Johnson?"*

4. **Permission Denied**: User revokes Accessibility permission.
   - System response: Displays interactive Permission Setup UI page with instructions.

5. **Network Unavailable / API Failure**:
   - System response: Gracefully falls back to local Android TTS and offline intent cache.
