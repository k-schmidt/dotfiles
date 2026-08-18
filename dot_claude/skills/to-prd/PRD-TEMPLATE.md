# PRD Template

The PRD captures **what** to build, **why**, and **how the work divides across parallel workers**. Issue-level breakdown is handled by `/to-issues`; spawning the workers is handled by `/fan-out`.

```md
# PRD: {Feature Name}
**Status:** DRAFT | **Date:** {YYYY-MM-DD}

## Problem Statement

The problem that the user is facing, from the user's perspective.

## Solution

The solution to the problem, from the user's perspective.

## Success Criteria

- {Measurable outcome 1}
- {Measurable outcome 2}
- {Measurable outcome 3}

## User Stories

A LONG, numbered list of user stories. Each user story should be in the format of:

1. As an <actor>, I want a <feature>, so that <benefit>

This list should be extremely extensive and cover all aspects of the feature.

## Technical Decisions

A list of technical decisions that were made. This can include:

- The modules that will be built/modified
- Schema changes
- Constraints not visible in the code

Capture the "why" behind each choice, not just the "what."

## Frozen Interfaces

The contract at every seam where one module calls another. One subsection per seam.

### {Module A} → {Module B}

The exact signature, event shape, table columns, or payload. Concrete enough that
two workers can build opposite sides of this seam without talking to each other.

Mark anything genuinely undecided as **UNRESOLVED** and note which worktrees are
blocked by it. Do not guess — a guessed contract is worse than a blocked task,
because the guess gets built twice in two incompatible ways.

## Worktree Plan

How the work divides across parallel workers. `/fan-out` reads this directly.

### {worktree-name} — HITL | AFK

- **Owns (writes):** `path/to/module/`, `path/to/other.ts`
- **Reads:** anything, no restriction
- **Depends on:** {other worktree}, or "nothing — can start immediately"
- **Scope:** one or two sentences on what lands here

Repeat per worktree. Then:

### Reserved files

Files no worktree may write, because two would collide. Assign each to exactly one
worktree, or hold it for the integration step.

| File | Owner |
|------|-------|
| `package.json` | integration only |
| `db/migrations/` | {worktree-name} |

## Testing Decisions

A list of testing decisions that were made. Include:

- A description of what makes a good test (only test external behavior, not implementation details)
- Which modules will be tested
- Prior art for the tests (i.e. similar types of tests in the codebase)

## Out of Scope

A description of the things that are out of scope for this PRD. Be explicit to prevent scope creep.

## Further Notes

Any further notes about the feature.
```

## Rules

- Use the project's domain glossary vocabulary from `docs/CONTEXT.md` throughout.
- User stories should be extensive. Cover the happy path, edge cases, error states, and administrative flows.
- Out of scope is mandatory. If nothing is excluded, the scope is too vague.
- Be concrete. "Improve performance" is not a success criterion. "P95 latency under 200ms for queries with <1000 results" is.

### On file paths

File paths belong in **Worktree Plan** and **Reserved files** only — they are load-bearing there, because exclusive write ownership is what keeps parallel workers from colliding, and it cannot be expressed without naming paths.

Keep them out of Problem Statement, Solution, User Stories, and Technical Decisions. Paths rot faster than intent does, and a stale path in a requirements section quietly misleads long after the feature ships. Prose describes modules; only the worktree plan names files.

When a path in the worktree plan goes stale, fix it — that section is a live routing table for `/fan-out`, not a historical record.

### On the two hard invariants

Everything else in this template is guidance. These two are not:

1. **No two worktrees write the same file.** Violating this guarantees a hand-merge.
2. **No worktree starts against an UNRESOLVED interface it depends on.** Violating this guarantees a rewrite.
