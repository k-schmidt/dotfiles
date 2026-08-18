---
name: update-docs
description: Reconcile code changes against project documentation and AGENTS.md. Surface divergences for classification as documentation updates, code bugs, or design questions. Use after implementation work to catch documentation drift.
---

Reconcile what the code does with what the docs say. Surface divergences one at a time, and resolve each before moving on.

## Process

### 1. Scope the changes

Determine what changed:

- If the user passes a path, commit, or range, use exactly that scope.
- Otherwise inspect `git status` and include relevant staged, unstaged, and untracked changes. This working-tree scope takes precedence even on the default branch.
- If the working tree is clean, compare the current branch with its upstream or the repository's default branch.
- If neither comparison contains changes, ask for the historical range instead of guessing one.

Build a list of **what was added, modified, or removed** — focus on domain concepts, architectural patterns, and public interfaces, not line-level edits.

### 2. Read existing docs

Load the documented state:

- The applicable domain glossary: follow `docs/CONTEXT-MAP.md` when present; otherwise use the nearest `docs/CONTEXT.md` governing the changed code.
- All persistent documentation under `docs/` — including `adr/*.md`, data models, system designs, UI specifications, guides, and any other documentation.
- PRDs and issue files under `specs/`, when present. This directory is reserved for planning and issue tracking rather than persistent design documentation.
- Root and nested `AGENTS.md` files that govern the changed code

If none of these exist, say so and ask if the user wants to bootstrap them (suggest `$grill-with-docs` for that).

### 3. Identify divergences

Cross-reference the changes against the docs. Look for:

- **Glossary drift** — new domain terms in the code not in the applicable `docs/CONTEXT.md`, or existing terms whose meaning has shifted in the implementation
- **Undocumented decisions** — architectural choices visible in the diff with no corresponding ADR (apply the three-part test: hard to reverse, surprising without context, result of a real trade-off)
- **Stale project instructions** — `AGENTS.md` references that no longer match reality (changed structure, renamed modules, deprecated patterns, or new conventions)
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
- **"It's complicated"** → suggest dropping into `$grill-with-docs` to resolve the terminology or design question, then come back.

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
- Items deferred to `$grill-with-docs`

## Rules

- Use the applicable `docs/CONTEXT.md` vocabulary when referring to domain concepts. If a term isn't in the glossary, that's itself a divergence to surface.
- Don't batch updates — write each doc change as it's approved so nothing gets lost.
- Don't suggest ADRs that fail the three-part test (hard to reverse, surprising, real trade-off).
- Don't touch docs that aren't divergent. This is reconciliation, not a rewrite.
- If no divergences are found, say so and stop. Don't invent work.
