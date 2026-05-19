---
name: init-project
description: Use when initializing a new or empty project folder. Creates CLAUDE.md (six-section schema), memory/ (six files), and `.claude/` config: `settings.json` with a SessionStart hook, an optional command pack, and optional bundled skills. Triggers: user runs `/init-project`; "init this folder" / "inicjuj projekt" / "bootstrap project"; opening an empty folder asking "what do I do first" / "co teraz". NOT for: folders that already have `CLAUDE.md` (refuse); authoring skills (the SDLC); git/CI/build tooling.
---

# init-project — Bootstrap a Project Folder

## When this fires

- Current working directory has no `CLAUDE.md` at root.
- User runs `/init-project` explicitly.
- User says one of: "init this folder", "inicjuj projekt", "bootstrap project", "set up CLAUDE.md here", "what do I do first" / "co teraz" (in an empty folder).
- NOT when: `CLAUDE.md` already exists (refuse, route to manual edit); user is inside the `fabryka skilli` workspace (different SDLC); the request is about scaffolding code/tooling/git.

## Workflow

1. **Detect target folder state.**
   - Check `CLAUDE.md` at folder root — must NOT exist.
   - Check `memory/` and `.claude/` — if either is present with files, stop and ask the user before any write.
   - Checkpoint: target is bootstrap-ready (no `CLAUDE.md`; `memory/` and `.claude/` absent or user-confirmed).

2. **Ask the bootstrap questions in one batched message.**
   - Q1 Project name. Q2 Stage: `idea` / `sandbox` / `shipped` / `paused` / `sunset`. Q3 Goal: (a) why this folder exists, (b) what "done" looks like, (c) what is out of scope. Q4 Stack. Q5 References. Q6 Project-specific override of global identity (default none).
   - Q7 Command pack — which of `/update-memory`, `/catch-up`, `/decision` to install (default all). If `/update-memory` is chosen, ask the Obsidian export path or "skip Obsidian sync".
   - Q8 Install the bundled skills `coding-discipline` and `review-skill` into the project (yes/no, default no — both are also available globally).
   - Checkpoint: eight answers collected. Any unknown gets `TBD: <one-line note>`, never a silent default.

3. **Draft `CLAUDE.md` from the six-section schema.**
   - Header: `# <Project Name> — CLAUDE.md` and `*Last updated: <today YYYY-MM-DD>*`.
   - Sections A·What / B·Goal / C·Stack / D·Decisions / E·Memory Map / F·References; add G·Overrides only if Q6 produced content.
   - Checkpoint: draft ≤200 lines, six sections present, date in header, no voice/tone wording.

4. **Lint the draft.**
   - If >200 lines, push the longest section's overflow to `memory/project-brief.md` and replace it with a one-line summary + link.
   - Strip any voice/tone phrasing — that belongs in global `~/.claude/CLAUDE.md`.
   - Replace any blank section with explicit `TBD: <what's missing>`.
   - Checkpoint: line count ≤200, no voice phrases, no blank sections.

5. **Write `<target>/CLAUDE.md`.**
   - Checkpoint: file exists at folder root.

6. **Create `<target>/memory/` and the six files.**
   - Render `project-brief.md`, `current-strategy.md`, `decisions.md` (one init entry), `next-actions.md` (one stub), `session-summaries.md` (header), `bugs-and-risks.md` (empty sections), substituting the Q1-Q3 answers.
   - Checkpoint: `<target>/memory/` contains exactly six `.md` files with the standard names.

7. **Generate `<target>/.claude/settings.json`.**
   - Render `references/settings.json.template` — a `SessionStart` hook that surfaces `memory/current-strategy.md` + `memory/next-actions.md` at session start.
   - Checkpoint: `<target>/.claude/settings.json` exists with a `SessionStart` hook entry.

8. **Install the chosen command pack.**
   - For each command chosen in Q7, render `references/commands/<name>.md` to `<target>/.claude/commands/<name>.md`. For `/update-memory`, resolve the `{{OBSIDIAN_*}}` placeholders from Q7 (or strip the Obsidian parts if the user said "skip").
   - Checkpoint: one file per chosen command exists in `<target>/.claude/commands/`, placeholders resolved.

9. **Install the chosen bundled skills.**
   - If Q8 = yes, copy the `coding-discipline` and `review-skill` `SKILL.md` to `<target>/.claude/skills/<name>/SKILL.md`. If Q8 = no, skip this step explicitly.
   - Checkpoint: if chosen, each skill's `SKILL.md` exists under `<target>/.claude/skills/`; if not, the skip is stated.

10. **Verify line count one more time.**
    - Re-count `CLAUDE.md`. If >200, abort with a clear error naming the long section and what to move to `memory/`.
    - Checkpoint: confirmed ≤200.

11. **Tell the user.**
    - One line: `→ initialized: CLAUDE.md (<N> lines), memory/ (6 files), settings.json (SessionStart hook), commands: <list>, skills: <list or none>. Next: open a session, /update-memory at the end.`
    - Checkpoint: user received the one-line confirmation.

## Anti-rationalization table

| Lie | Rebuttal |
|-----|----------|
| "User pressed Enter on the stage question — assume 'sandbox'." | If a question was not answered, write `TBD`. Silent defaults lie about state. |
| "settings.json is optional polish — skip it to save a step." | The SessionStart hook is what keeps the memory loop alive across sessions. It is a MUST-do, not polish. |
| "Install all three commands and both skills by default — completeness." | Every command and skill is opt-in. A project that wants only `/update-memory` gets only that. Auto-install creates clutter. |
| "The folder has a `.claude/` already — overwrite settings.json, mine is newer." | Refuse and ask. An existing `.claude/` may carry hooks or config the user depends on. |
| "Generated CLAUDE.md is 220 lines but reads well — keep it." | The 200-line cap is enforceable. Push overflow to `memory/project-brief.md`. |
| "Bundled skills are global already — installing them per-project is redundant, skip it." | Per-project copies make the project portable and let a kit carry the skills. The user chose; honor the choice. |
| "While bootstrapping, also author a project-specific skill — the user will want it." | init-project copies finished skills; it does not author. Skill creation is the SDLC. |

## Exit criterion

All hold:

1. `<target>/CLAUDE.md` exists, ≤200 lines, header has `Last updated: <today>`, six sections present (G only if Q6 had content).
2. `<target>/memory/` exists with exactly six files.
3. `<target>/.claude/settings.json` exists with a `SessionStart` hook entry.
4. Each command chosen in Q7 exists at `<target>/.claude/commands/<name>.md` with placeholders resolved.
5. If Q8 = yes, each bundled skill exists at `<target>/.claude/skills/<name>/SKILL.md`.
6. No voice/tone phrasing in `CLAUDE.md`; every unanswered question landed as an explicit `TBD`.
7. A second invocation of `/init-project` in the same folder refuses (does not overwrite).
8. User received the one-line confirmation.

## Out of scope

- Updating an existing `CLAUDE.md` (separate refactor flow, not this skill).
- Creating `git`, `package.json`, `requirements.txt`, `.gitignore`, build or CI tooling.
- Voice and tone instructions (those live in global `~/.claude/CLAUDE.md`).
- Authoring new skills — init-project copies the two finished bundled skills; skill creation is the fabryka skilli SDLC.
- Auto-installing any command or skill — the command pack and bundled skills are opt-in via Q7/Q8.
- Bootstrapping more than one folder per command run.
