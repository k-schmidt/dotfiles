---
name: update-docs
description: Reconcile code changes against project documentation (CONTEXT.md, ADRs, CLAUDE.md). Surfaces divergences, interviews the user to classify each as a doc update, a code bug, or something needing deeper design discussion. Use after implementation work to catch documentation drift.
---

Reconcile what the code does with what the docs say. Surface divergences one at a time, and resolve each before moving on.

## Process

### 1. Scope the changes

Determine what changed:

- If on a feature branch, run `git diff main...HEAD` (or the appropriate base branch).
- If on main, use `git log --oneline -20` and `git diff HEAD~5` to find recent work.
- If the user passes a path or commit range as an argument, use that.

Build a list of **what was added, modified, or removed** — focus on domain concepts, architectural patterns, and public interfaces, not line-level edits.

### 2. Read existing docs

Load the documented state:

- `docs/CONTEXT.md` (or `docs/CONTEXT-MAP.md` → per-context docs)
- `docs/adr/*.md`
- `.claude/CLAUDE.md` (project-level instructions)

If none of these exist, say so and ask if the user wants to bootstrap them (suggest `/grill-with-docs` for that).

### 3. Identify divergences

Cross-reference the changes against the docs. Look for:

- **Glossary drift** — new domain terms in the code not in `CONTEXT.md`, or existing terms whose meaning has shifted in the implementation
- **Undocumented decisions** — architectural choices visible in the diff with no corresponding ADR (apply the three-part test: hard to reverse, surprising without context, result of a real trade-off)
- **Stale project instructions** — `CLAUDE.md` references that no longer match reality (changed file structure, renamed modules, deprecated patterns, new conventions)
- **Dead references** — docs that reference code, files, or patterns that no longer exist
- **Resolved issues** — if `specs/issues/` exists, check each open issue's acceptance criteria against the current code. An issue is potentially resolved when its described problem or feature appears addressed by recent changes

### 4. Interview

Present divergences **one at a time**. For each:

> The code now does **X**, but `{doc file}` says **Y**.
> Which is right — the code or the doc?

Wait for the user's answer before continuing. Branch on their response:

- **"Code is right"** → update the doc immediately using the formats in [CONTEXT-FORMAT.md](../grill-with-docs/CONTEXT-FORMAT.md) and [ADR-FORMAT.md](../grill-with-docs/ADR-FORMAT.md).
- **"Doc is right"** → the code has a bug or regression. Draft an issue:
  - Title, description of the divergence, and what the expected behavior should be (per the doc).
  - Ask: create via `gh issue create`, or write to `specs/issues/`?
- **"It's complicated"** → suggest dropping into `/grill-with-docs` to resolve the terminology or design question, then come back.

For resolved issues, present each one:

> Issue `specs/issues/0003-fix-partial-cancellation.md` looks addressed by the recent changes. Close it?

- **Yes** → delete the issue file.
- **Partially** → update the issue to reflect what remains, removing completed acceptance criteria.
- **No** → leave it as-is.

### 5. Summary

After all divergences are resolved, print a short summary:

- Docs updated (with file paths)
- Issues created (with references)
- Issues closed (with file paths)
- Items deferred to `/grill-with-docs`

## Rules

- Use `docs/CONTEXT.md` vocabulary when referring to domain concepts. If a term isn't in the glossary, that's itself a divergence to surface.
- Don't batch updates — write each doc change as it's approved so nothing gets lost.
- Don't suggest ADRs that fail the three-part test (hard to reverse, surprising, real trade-off).
- Don't touch docs that aren't divergent. This is reconciliation, not a rewrite.
- If no divergences are found, say so and stop. Don't invent work.
