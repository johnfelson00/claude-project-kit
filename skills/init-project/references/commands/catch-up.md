# /catch-up — Load project state from memory/

Run at the start of a session to get oriented before doing work.

## When this fires
- User types `/catch-up` or asks "where were we" / "what's the state" / "co było ostatnio".
- A session is starting in a project that has a `memory/` folder.

## Workflow

1. **Read the memory/ files.**
   - Read `memory/current-strategy.md`, `memory/next-actions.md`, the latest entry of `memory/session-summaries.md`, and `memory/bugs-and-risks.md`.
   - Checkpoint: the four files are read.

2. **Summarize the project state.**
   - State concisely: the current focus, the top next actions, any open bugs/risks, and where the last session left off.
   - Checkpoint: the summary covers focus + next actions + open risks + last-session state.

3. **Tell the user.**
   - Deliver the summary in one compact block, then ask what to work on.
   - Checkpoint: user has the state summary and a prompt for direction.

## Exit criterion
- The user receives a summary drawn from `memory/`: current focus, next actions, open risks, last-session state.

## Out of scope
- Editing any `memory/` file — that is `/update-memory`.
- Doing project work — `/catch-up` orients, it does not execute.
