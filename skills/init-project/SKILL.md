---
name: init-project
description: Use when initializing an empty project folder. Creates folder-level CLAUDE.md (six-section schema), memory/ with six standard files, optionally installs /update-memory. Triggers: user runs /init-project; user says 'init this folder' / 'bootstrap project' / 'set up CLAUDE.md here'; user opens an empty folder asking 'what do I do first'. NOT for: folders that already have CLAUDE.md (refuse); creating skills; git/CI/build tooling.
---

# init-project — Bootstrap a Project Folder

## When this fires

- Current working directory has no `CLAUDE.md` at root.
- User runs `/init-project` explicitly.
- User says one of: "init this folder", "bootstrap project", "set up CLAUDE.md here", "what do I do first" (in an empty folder).
- NOT when: `CLAUDE.md` already exists (refuse, route to manual edit); request is about scaffolding code/tooling/git.

## Workflow

1. **Detect target folder state.**
   - Check `CLAUDE.md` at folder root — must NOT exist.
   - Check `memory/` folder — if present with files, stop and ask user before any write.
   - Checkpoint: target is bootstrap-ready (no CLAUDE.md, no populated memory/).

2. **Ask the bootstrap questions in one batched message.**
   - Q1 — Project name (used as title and slug-ish).
   - Q2 — Stage: `idea` / `sandbox` / `shipped` / `paused` / `sunset` (pick one).
   - Q3 — Goal: (a) why this folder exists in one sentence, (b) what "done" looks like, (c) what is deliberately out of scope.
   - Q4 — Stack: languages, frameworks, hosting, run command, key files. "TBD" allowed.
   - Q5 — References: repo URL, Notion, Linear/Jira, production URL, dashboards. "TBD" allowed.
   - Q6 — Any project-specific override of your global identity? (e.g. "this repo uses Python 3.12 instead of TS"). Default: none → skip G section.
   - Q7 — Install `/update-memory` command for end-of-session sync? (yes/no, default yes).
   - Checkpoint: 7 answers collected. Any unknown gets `TBD: <one-line note>`, never silent default.

3. **Draft `CLAUDE.md` from the six-section schema.**
   - Header: `# <Project Name> — CLAUDE.md` and `*Last updated: <today YYYY-MM-DD>*`.
   - Section A — What this folder is: paragraph derived from name + stage.
   - Section B — Goal: three bullets from Q3 (why / done / out of scope).
   - Section C — Stack: bullets from Q4. If all TBD, write `TBD — fill before first session ends.`
   - Section D — Decisions: single line `<today> — initialized via /init-project because <one-line reason from Q3a>`.
   - Section E — Memory Map: list the six standard `memory/` files with one-line description each.
   - Section F — References: bullets from Q5; `TBD` where unknown.
   - Section G — Only if Q6 produced overrides; otherwise omit entirely.
   - Checkpoint: draft ≤200 lines, six sections present, date in header, no voice/tone wording.

4. **Lint the draft.**
   - Count lines. If >200, push the longest section's overflow to `memory/project-brief.md` and replace with a one-line summary + `[see memory/project-brief.md]`.
   - Scan for voice/tone phrases ("write in a friendly tone", "be concise", "use markdown") — if present, remove. Voice belongs in global `~/.claude/CLAUDE.md`.
   - Scan for empty sections — replace any blank with explicit `TBD: <what's missing>`.
   - Checkpoint: line count ≤200, no voice phrases, no blank sections.

5. **Write `<target>/CLAUDE.md`.**
   - Use Write tool with the linted draft.
   - Checkpoint: file exists at folder root.

6. **Create `<target>/memory/` and the six files.**
   - For each of the six file names, render the corresponding template from `references/memory/<name>.md`, substituting `{{PROJECT_NAME}}`, `{{TODAY}}`, `{{GOAL_WHY}}`, `{{GOAL_DONE}}` from Q1/Q3.
   - Files: `project-brief.md` (frozen — full Q1-Q5 answers), `current-strategy.md` (Phase: bootstrap; Focus: derived from Q3), `decisions.md` (single init entry), `next-actions.md` (one stub: `[ ] Define first concrete deliverable`), `session-summaries.md` (header only), `bugs-and-risks.md` (Open / Risks / Fixed empty sections).
   - Checkpoint: `<target>/memory/` contains exactly six `.md` files with the standard names.

7. **If Q7 was yes — install `/update-memory`.**
   - Create `<target>/.claude/commands/`.
   - Copy `references/commands/update-memory.md` to `<target>/.claude/commands/update-memory.md`.
   - Checkpoint: command file exists.

8. **Verify line count one more time.**
   - Run `wc -l CLAUDE.md` (or count internally).
   - If >200, abort with a clear error: which section is too long, what to move to memory/.
   - Checkpoint: confirmed ≤200.

9. **Tell user.**
   - One line: `→ initialized: CLAUDE.md (<N> lines), memory/ (6 files), /update-memory: yes/no. Next: open a session, /update-memory at the end.`

## Anti-rationalization table

| Lie | Rebuttal |
|-----|----------|
| "User pressed Enter on Q2 — assume 'sandbox'." | If a question was not answered, write `TBD`. Silent defaults lie about state. |
| "User mentioned voice preference in Q6 — capture it in G section." | Voice goes in global `~/.claude/CLAUDE.md`. G is for project-specific *contradictions* of global, not redundant restatements. |
| "Generated CLAUDE.md is 220 lines but reads well — keep it." | The 200-line cap is enforceable, not aspirational. Push overflow to `memory/project-brief.md`. |
| "User has no answer for Q3a — skip section B." | Section stays. Value is `TBD: <one-sentence note>`. Empty section breaks the schema. |
| "Existing CLAUDE.md is one paragraph — overwrite, mine is better." | Refuse and ask. Existing file may carry context not in the user's prompt. |
| "Auto-install `/update-memory` to save a question." | Offer in Q7, never auto. Some projects already have memory tooling and double-install creates conflicts. |
| "While I'm here, also create `/init-skill` or `git init` — completeness." | Out of scope. Skill creation and git/CI/tooling are separate tasks. |
| "Stage 'experimenting' is what user wants — accept free-form." | Map to one of the five: `idea`/`sandbox`/`shipped`/`paused`/`sunset`. Free-form drifts; the vocabulary keeps cross-project comparisons readable. |
| "Render G section with empty bullets so the schema looks complete." | If Q6 produced no overrides, omit G entirely. Empty G is noise. |
| "Skip the second line-count check — first one passed." | After step 6 wrote `memory/`, `CLAUDE.md` is unchanged but final state matters. Re-check. |

## Exit criterion

All hold:

1. `<target>/CLAUDE.md` exists, ≤200 lines, header has `Last updated: <today>`.
2. Six sections (A·What / B·Goal / C·Stack / D·Decisions / E·Memory Map / F·References) all present and non-blank. G present only if Q6 had content.
3. `<target>/memory/` exists with exactly six files: `project-brief.md`, `current-strategy.md`, `decisions.md`, `next-actions.md`, `session-summaries.md`, `bugs-and-risks.md`.
4. `decisions.md` contains one entry dated today citing `/init-project`.
5. If Q7 = yes: `<target>/.claude/commands/update-memory.md` exists.
6. No voice/tone phrasing in `CLAUDE.md`.
7. No silent defaults — every unanswered question landed as explicit `TBD: ...`.
8. User received the one-line confirmation showing line count, file count, and next step.
9. A second invocation of `/init-project` in the same folder refuses (does not overwrite).

## Out of scope

- Updating an existing `CLAUDE.md` (separate refactor flow, not this skill).
- Creating `git`, `package.json`, `requirements.txt`, `.gitignore`, build tooling, CI config.
- Voice and tone instructions (those live in global `~/.claude/CLAUDE.md`).
- Creating `.claude/skills/` subfolders (skill creation is a separate task).
- Bootstrapping more than one folder per command run — if user has multiple, they invoke per folder.
- Filling `decisions.md` with anything beyond the single init entry — let the user log decisions as they're made.
