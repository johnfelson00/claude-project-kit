---
name: update-memory
description: Use at end of session to sync the memory/ folder and bump the CLAUDE.md date. Triggers user runs /update-memory; user says 'wrap up' / 'we are done' / 'see you tomorrow' / 'end of session' / 'save state'; assistant finished non-trivial work and no memory update has happened yet. NOT for mid-session note capture; arbitrary file edits; folders without memory/ (route to /init-project).
---

# update-memory — End-of-Session Sync

## When this fires

- User runs `/update-memory` (explicit slash invocation).
- User says any session-end phrase: "wrap up", "we're done", "see you tomorrow", "end of session", "save state".
- Assistant produced ≥1 file write/edit in current session and no `memory/session-summaries.md` entry exists for today yet.
- NOT when: user says "just a quick note", "not done yet", "wait" (mid-session signals — acknowledge, do not run); folder lacks `memory/` (route to `/init-project`); user is asking ABOUT memory rather than ending session.

## Workflow

1. **Detect project state.**
   - Check `<cwd>/memory/` — if absent → refuse and tell user: "No `memory/` found. Run `/init-project` first."
   - Checkpoint: `<cwd>/memory/` exists and is the project being synced.

2. **Gather session deltas.**
   - If `<cwd>` is a git repo: `git status --short` and `git diff --stat HEAD` to list changed files.
   - Else: ask user "Files changed this session?" — accept "(none)" if zero.
   - Scan transcript for decision phrases ("decided to", "let's go with", "we'll use", "switched to", "chose X over Y").
   - Cross-reference `memory/next-actions.md` — note completed items.
   - Checkpoint: have `{files_changed: [...], decisions: [...], completed_actions: [...]}`.

3. **Halt-or-continue check.**
   - If `files_changed` is empty AND `decisions` is empty AND `completed_actions` is empty:
     - Tell user: "No changes since last update. Nothing to log."
     - Exit without writing.
   - Else continue.
   - Checkpoint: there is something worth logging.

4. **Update `memory/session-summaries.md`.**
   - Pick a 2-4 word topic summarizing the session's largest artifact.
   - Insert at top (after header), under newest dated section:
     ```markdown
     ## YYYY-MM-DD — <topic>
     **What was done:**
     - <concrete item, file:line if relevant>

     **End-of-session state:**
     - <component A>: 🔴/🟡/🟢

     **Next step:** <one sentence>
     ```
   - Checkpoint: today's section exists with all three sub-sections, body non-empty.

5. **Update `memory/next-actions.md`.**
   - For each item in `completed_actions`: change `[ ]` → `[x] YYYY-MM-DD`.
   - Append any new actions discovered this session at the top of the open list.
   - Checkpoint: file reflects state — at least one change OR explicit "(no changes)" sticky note if applicable.

6. **Update `memory/current-strategy.md` only if focus shifted.**
   - Compare current `## Focus this week` line against today's actual work. If different → edit. Else skip.
   - Checkpoint: file matches reality OR was deliberately untouched (note in run summary which one).

7. **Append to `memory/decisions.md` for each decision.**
   - Format:
     ```markdown
     ## YYYY-MM-DD — <decision name>
     **What:** <one sentence>
     **Why:** <one sentence>
     **Implications:** <one sentence>
     ```
   - One section per decision. Insert at top under header.
   - Checkpoint: count of new sections == `len(decisions)`.

8. **Update `memory/bugs-and-risks.md`.**
   - Move newly fixed bugs to "## ✅ Fixed" with date.
   - Add bugs/risks discovered this session to "## Open" with `file:line` if known.
   - Checkpoint: file reflects current state.

9. **If decisions were made — bump CLAUDE.md.**
   - Open `<cwd>/CLAUDE.md`.
   - In section D, append: `- YYYY-MM-DD — <decision> because <reason>` for each new decision (max 3 lines added per session).
   - In header, replace `*Last updated: ...*` with today's date.
   - Checkpoint: D has new lines, header date == today.

10. **Tell user.**
    ```
    ✅ Memory updated.

    Updated:
    - memory/session-summaries.md ← <what was added>
    - memory/next-actions.md ← <X done, Y new>
    - <other files if changed>
    [- CLAUDE.md ← D entry + date bumped (if decisions)]

    See you next session.
    ```
   - Checkpoint: closeout printed; exit.

## Anti-rationalization table

| Lie | Rebuttal |
|-----|----------|
| "Session was short — skip the report." | One sentence in session-summaries is the floor. Even 10 minutes of work leaves a trail. |
| "Decision was minor — skip the log." | If you justified the call in chat, it was a decision. Log it. |
| "I'll do this tomorrow." | Tomorrow's session loads stale memory and rebuilds wrong. Now or never. |
| "Topic is hard — pick 'work' or 'session'." | Topic is the searchable anchor. 2-4 specific words. Generic = unfindable in three weeks. |
| "Skip CLAUDE.md date bump — D entry is enough." | Bump the date on every touch. A D edit is a touch. Bump. |
| "User said 'we're done' but did nothing — log empty session anyway." | If no work was done, say "no changes since last update" and exit. Do not fabricate. |
| "Edit one source file while I'm here." | Scope discipline. Bookkeeping only. Source edits get their own task. |
| "Strategy reads stale — refresh the wording." | Only edit current-strategy when focus actually shifted. Cosmetic = churn. |
| "User said 'just a quick note' — capture it." | Not a session-end signal. Acknowledge, do not run. |
| "Project-brief.md needs a fix — patch it now." | Frozen by /init-project. Out of scope. Raise as bug, do not edit. |
| "Skip step 3's halt check — there's always something to log." | If all three deltas are empty, logging fabricates state. Exit clean. |

## Exit criterion

All hold:

1. `memory/session-summaries.md` has an entry dated today with three sub-sections (What/State/Next), body non-empty.
2. `memory/next-actions.md` has at least one change OR the run was correctly halted at step 3 with "no changes" message.
3. If `decisions` non-empty: `memory/decisions.md` has matching new sections AND CLAUDE.md section D has matching one-liners AND CLAUDE.md header `Last updated:` is today.
4. User received closeout summary listing exactly what was updated.
5. Re-running 5 minutes later with no new work outputs "no changes since last update" and writes nothing.

## Out of scope

- Mid-session note capture — that's manual editing or a separate `note` skill, not this one.
- Editing source/code files — bookkeeping only.
- Creating new memory/ files (only updates the existing six).
- Editing `memory/project-brief.md` (frozen by /init-project).
- Running in folders without `memory/` (refuse and route to `/init-project`).
- Multi-folder bookkeeping in one run — operates on `<cwd>` only.
