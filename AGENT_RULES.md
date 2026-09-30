# MULTI-AGENT DEVELOPMENT RULES

This repository is being developed by five independent AI agents.

Each agent has a strictly defined ownership area.

## RULE 1 — BRANCH

Always verify your Git branch before making changes.

Never switch branches.

Never modify main.

## RULE 2 — FILE OWNERSHIP

Modify only files belonging to your assigned agent.

Do not modify another agent's files.

## RULE 3 — NO OVERWRITING

Never overwrite another agent's implementation.

Never reset another agent's work.

Never use destructive Git commands.

## RULE 4 — CROSS-AGENT REQUESTS

If another agent's file must change:

STOP.

Create CHANGE_REQUEST.md.

Do not make the cross-boundary change yourself.

## RULE 5 — SHARED CONTRACTS

Respect shared models and interfaces.

Do not silently change them.

## RULE 6 — NO FEATURE CREEP

Implement only your assigned responsibility.

Do not implement another agent's features.

## RULE 7 — NO FAKE SUCCESS

Never pretend an action succeeded if it did not.

Use real implementations or clearly marked fallbacks.

## RULE 8 — TEST

Before committing:

* run analyzer/build
* fix errors caused by your work
* test your feature
* document limitations

## RULE 9 — COMMITS

Use small focused commits.

Examples:

feat(ui): add assistant screen

feat(ai): add command parser

feat(android): add accessibility service

feat(actions): add contact controller

feat(voice): add TTS service

## RULE 10 — MAIN

Only the human developer merges into main.

Agents must never merge themselves.

## RULE 11 — PRESERVE EXISTING WORK

Inspect before modifying.

Do not recreate working code unnecessarily.

## RULE 12 — RELIABILITY

Reliability is more important than feature count.

Do not over-engineer.
