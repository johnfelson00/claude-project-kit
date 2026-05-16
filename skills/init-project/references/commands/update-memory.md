# /update-memory — End-of-session sync (memory/)

Run at the end of every session. Updates `memory/` files based on what was done.

## When this fires
- User types `/update-memory` or signals end of session ("wrap up", "we're done", "see you tomorrow").
- Last commit was non-trivial and no summary has been written yet.

## Workflow

1. **Update `memory/session-summaries.md`.**
   - Find today's entry (or add a new one at top).
   - Format:
     ```markdown
     ## YYYY-MM-DD — [short topic, 2-4 words]
     **What was done:**
     - <concrete item, file:line if relevant>

     **End-of-session state:**
     - <component A>: 🔴 / 🟡 / 🟢

     **Next step:** <one sentence>
     ```
   - Checkpoint: today has an entry with all three sections.

2. **Update `memory/next-actions.md`.**
   - Mark completed items `[x] YYYY-MM-DD`.
   - Append new items discovered.
   - Reorder if priorities shifted.
   - Checkpoint: list reflects current state.

3. **Update `memory/current-strategy.md` if focus changed.**
   - Only edit if the week's focus shifted. Otherwise leave it.
   - Checkpoint: file matches current reality.

4. **Append to `memory/decisions.md` if a decision was made today.**
   - Format: `## YYYY-MM-DD — <decision name>` with **What / Why / Implications**.
   - Checkpoint: every architectural decision from this session has an entry.

5. **Update `memory/bugs-and-risks.md`.**
   - Move fixed bugs to "✅ Fixed" with date.
   - Add new bugs/risks with file:line.
   - Checkpoint: file reflects what's known.

6. **Update CLAUDE.md section D if a decision warrants the brief.**
   - One-liner: `- YYYY-MM-DD — <decision> because <reason>`.
   - Bump `Last updated:` date.
   - Checkpoint: D section + date both updated.

7. **Tell user.**
   ```
   ✅ Memory updated.

   Updated:
   - memory/session-summaries.md ← <what was added>
   - memory/next-actions.md ← <X done, Y new>
   - <other files if changed>

   See you next session.
   ```

## Anti-rationalization table

| Lie | Rebuttal |
|-----|----------|
| "Session was short — skip the report." | Even a 10-minute session leaves a trail. One sentence in session-summaries is the floor. |
| "Decision log is for big decisions only." | If you wrote a paragraph today justifying a choice, it's a decision. Log it. |
| "Update-memory can wait until tomorrow." | It can't. Tomorrow's session loads stale memory and rebuilds wrong. |
| "Topic for the session note is hard — pick something generic like 'work'." | Topic is the searchable anchor. 2-4 words, specific. |
| "Bump current-strategy to whatever feels right today." | Only edit when the week's focus actually changed. Strategy churn signals indecision. |

## Exit criterion

All hold:
1. `memory/session-summaries.md` has today's entry with What / State / Next step.
2. `memory/next-actions.md` reflects current state.
3. Architectural decisions from today are in `memory/decisions.md`; one-liners are in CLAUDE.md section D.
4. CLAUDE.md `Last updated:` matches today if any D entry was added.
5. User received the closeout summary.

## Out of scope

- Editing source/code files (this is bookkeeping only).
- Generating new content — capture what was done, do not invent.
- Triggering the next session's first action — that's a fresh start.
