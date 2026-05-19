---
name: review-skill
description: Use when an existing skill needs a quality audit against Osmani's six skill-design principles — produces an audit report; does not create or rewrite the skill. Triggers: user runs `/review-skill`; user asks to "review this skill", "audit this SKILL.md", or "is this skill well-built"; a skill needs vetting before use; a skill misfires and its design is suspect. NOT for: creating a skill (skill-smith / the SDLC); writing trigger test cases (/verify); auditing non-skill code or docs.
---

# review-skill — Audit a Skill Against Osmani's Six Principles

## When this fires

- User runs `/review-skill`.
- User asks to "review this skill", "audit this SKILL.md", or "is this skill well-built".
- A skill — especially one from outside the factory — needs vetting before use.
- A skill misfires or underperforms and its design is suspect.
- NOT when: the request is to create a new skill (skill-smith / the SDLC); the request is to write trigger test cases (`/verify`); the target is non-skill code or documentation.

## Workflow

1. **Resolve and read the target.**
   - Identify the target skill and read its `SKILL.md` in full; read `SPEC.md` too if present.
   - Confirm the target is a skill (a skill's shape: frontmatter description + workflow). If it is not a skill, decline and stop.
   - Checkpoint: target SKILL.md loaded; confirmed a skill, or declined with a reason.

2. **Audit against the six principles.**
   - **Process over prose** — are sections checkpointed steps, not essays? Test: a section with a 3+ sentence paragraph and zero checkpoints is prose.
   - **Anti-rationalization table** — is an ART present, with specific lie→rebuttal rows, not generic filler?
   - **Verification** — is there an exit criterion, and does every workflow step end in a checkable artifact? Test: a step verifiable only by "look at it" is incomplete.
   - **Progressive disclosure** — is the skill scoped to one job (not a bloated everything-skill), with explicit triggers a router can disclose on?
   - **Scope discipline** — are out-of-scope boundaries explicit (a MUST NOT / Out of scope section)?
   - **Senior scaffolding** — does the skill make the senior work an agent skips by default (spec, evidence, scope) impossible to skip?
   - For each principle: assign a verdict — pass / weak / fail — and cite the specific text in the target that supports it.
   - Checkpoint: six verdicts recorded, each with a citation; every weak or fail has a concrete fix drafted.

3. **Compile and deliver the audit report.**
   - Assemble the six verdicts and a fix list ordered worst-first (fails before weaks).
   - Deliver the report to the user. Leave the target skill's files untouched.
   - Checkpoint: report delivered with six cited verdicts and a prioritized fix list; target files unchanged.

## Anti-rationalization table

| Lie | Rebuttal |
|-----|----------|
| "The skill looks fine — skip the per-principle checks, write a summary." | A summary is prose. The six verdicts each citing text are the audit. Generic praise is not a review. |
| "No anti-rationalization table, but the workflow is clear — call it a pass." | Missing ART is a fail on that principle, not a pass. Report it; a clear workflow is a different principle. |
| "This skill was built by the factory — it must be fine, skip the audit." | Provenance is not evidence. Audit the text in front of you, not its pedigree. |
| "The skill has a weak spot — just fix it inline while reviewing." | review-skill reports, it does not rewrite. Fixing inline destroys the before/after the report exists to show. |
| "The user called this README a 'skill' — close enough, audit it." | The six principles are skill-design-specific. A non-skill input gets a decline, not a misapplied audit. |

## Exit criterion

All hold:

1. The report carries a verdict for each of the six principles, every verdict citing specific text from the target skill.
2. Every "weak" or "fail" verdict is paired with a concrete, actionable fix.
3. The target skill's files are byte-identical after the review — the audit is read-only.
4. On a non-skill input, the skill declined rather than producing a misapplied audit.

## Out of scope

- Creating or writing a new skill — that is skill-smith and the factory SDLC.
- Rewriting or editing the target skill — review-skill reports findings; applying fixes is a separate action.
- Writing trigger test cases — that is `/verify`.
- Auditing non-skill artifacts — general code or documentation; the six principles are skill-design-specific.
