---
name: coding-discipline
description: Use when about to start a non-trivial coding change — applies the four Karpathy principles before code is written (a discipline pass — not the code itself). Triggers: user runs `/coding-discipline`; an imperative coding request with no success criteria ("add validation", "fix the bug", "refactor X"); starting a multi-file or non-trivial edit; an ambiguous coding request. NOT for: trivial edits (typos, one-liners, obvious renames); non-coding tasks; skill authoring in fabryka skilli.
---

# coding-discipline — Discipline Pass Before Non-Trivial Coding

## When this fires

- User runs `/coding-discipline`.
- User gives an imperative coding instruction with no success criteria — "add validation", "fix the bug", "refactor X", "make it work".
- The agent is about to start a multi-file or architecturally non-trivial edit.
- A coding request whose interpretation is ambiguous.
- NOT when: the change is trivial (typo fix, one-liner, obvious rename); the task is non-coding; the task is authoring a skill inside fabryka skilli (that is the SDLC).

## Workflow

1. **Triage triviality.**
   - Classify the change: trivial (typo, one-liner, obvious rename) or non-trivial.
   - Checkpoint: if trivial — state that the discipline pass is skipped, and stop here. If non-trivial — continue to step 2.

2. **Surface assumptions.**
   - List every assumption and ambiguity the request leaves open. For each ambiguity, resolve it with a stated assumption or escalate it.
   - If genuinely confused — stop and ask, do not guess.
   - Checkpoint: assumptions written; no ambiguity left silently picked.

3. **Reframe the task as a verifiable goal.**
   - Apply the imperative-to-goal rewrite: convert the request into a goal with a concrete success criterion (e.g. "add validation" → "tests for invalid inputs pass").
   - Checkpoint: a success criterion exists that is observable or testable — not "make it work".

4. **Declare minimal scope.**
   - Name the files/areas that will change. Name, explicitly, what is out of scope.
   - Checkpoint: both the in-scope and out-of-scope lists are written before any edit.

5. **State a step→verify plan for multi-step work.**
   - If the task has more than one step, write each step paired with the check that confirms it.
   - Checkpoint: every step has a verify check; single-step tasks skip this step explicitly.

6. **Audit the diff after implementation.**
   - Once the code is written (by the normal flow, not this skill), walk the diff: every changed line traces to the request; no speculative features or abstractions were added; pre-existing dead code is mentioned, not deleted.
   - Checkpoint: each changed line traced to the request or flagged; bloat and dead-code checks recorded.

## Anti-rationalization table

| Lie | Rebuttal |
|-----|----------|
| "The request is clear enough — skip stating assumptions." | If it were clear, the goal reframe would be trivial to write. State assumptions anyway: cost is one paragraph, the save is a whole rewrite. |
| "This change is small — but run the full pass anyway, to be safe." | Trivial changes are explicitly out of scope. Full rigor on a typo fix is the overcomplication this skill exists to prevent. |
| "While auditing the diff I found unrelated dead code — removing it is just cleanup." | Surgical Changes: pre-existing dead code is mentioned, not deleted. That deletion is its own task. |
| "Success criteria are obvious — no need to write them down." | Unwritten criteria cannot be looped against. "Make it work" is exactly the weak criterion this skill replaces. |
| "Add a small abstraction now — it will help later." | Simplicity First: no speculative abstraction for single-use code. "Later" is hypothetical; the abstraction is liability now. |

## Exit criterion

All hold:

1. On an ambiguous or imperative request, the first output is the stated assumptions plus a goal-reframed task with a success criterion — produced before any code.
2. The discipline pass names in-scope files/areas and an explicit out-of-scope list.
3. After implementation, a diff self-audit is produced; any changed line that does not trace to the request is flagged.
4. On a trivial change, the pass is skipped and the skill records that it stayed out of the way.

## Out of scope

- Trivial edits — typo fixes, one-line changes, obvious renames. Judgment over rigor for trivial work.
- Writing or editing the implementation code. The skill produces the discipline pass; the coding happens in the normal flow.
- Authoring skills inside fabryka skilli — that is the SDLC's scope.
- Expanding scope during the pass — no proposing speculative features, abstractions, or adjacent refactors.
