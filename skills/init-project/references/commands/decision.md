# /decision — Log a decision to memory/decisions.md

Run when a decision is made, to capture it before it is forgotten.

## When this fires
- User types `/decision <text>` or says "log this decision" / "zapisz decyzję".
- A non-trivial choice was just made and is not yet recorded.

## Workflow

1. **Capture the decision.**
   - Take the decision text from the user, or summarize the choice just made in one sentence.
   - Checkpoint: a one-sentence decision statement exists.

2. **Append to `memory/decisions.md`.**
   - Append a dated entry: `## YYYY-MM-DD — <decision name>` with **What** / **Why** / **Implications** — one line each.
   - Checkpoint: `decisions.md` has the new entry, dated today.

3. **Tell the user.**
   - Confirm in one line what was logged.
   - Checkpoint: user sees the confirmation.

## Exit criterion
- `memory/decisions.md` has a new dated entry with What / Why / Implications.

## Out of scope
- Editing other `memory/` files — that is `/update-memory`.
- Making the decision — `/decision` records a choice already made.
