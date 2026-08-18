# PRD Template

```md
# PRD: {Feature Name}
**Status:** DRAFT | **Date:** {YYYY-MM-DD}

## Problem Statement

The problem from the user's perspective.

## Solution

The intended user-visible outcome.

## Success Criteria

- {Measurable outcome}

## User Stories

1. As an {actor}, I want {capability}, so that {benefit}.

## Technical Decisions

The modules, constraints, schemas, APIs, and trade-offs already decided. Capture why each consequential choice was made.

## Frozen Interfaces

### {Producer} → {Consumer}

The concrete contract at the seam. Mark a genuinely undecided contract **UNRESOLVED** and name the tasks it blocks.

## Task Plan

### {task-name} — HITL | AFK

- **Outcome:** {verifiable capability}
- **Owns (writes):** `{path}`
- **Reads:** `{path}` or "anything"
- **Depends on:** {task-name} or "nothing"
- **Contracts:** {frozen interface references}

### Reserved files

| File or directory | Owner |
|-------------------|-------|
| `{shared-path}` | {task-name or integration} |

## Testing Decisions

The observable behaviors to test, modules covered, and relevant prior art.

## Out of Scope

Explicit exclusions.

## Further Notes

Only information that does not fit above.
```

## Rules

- Use the project's glossary vocabulary.
- Keep implementation paths out of requirements and decisions; name paths only in task ownership and reserved-file tables.
- Cover happy paths, edge cases, errors, and administrative behavior when they are relevant.
- Make success criteria measurable.
- No two tasks may write the same file.
- No task may start against an unresolved interface it depends on.
