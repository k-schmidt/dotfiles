# PRD Template

The PRD captures **what** to build and **why**. Implementation breakdown is handled by `/to-issues`.

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
- The interfaces of those modules
- Schema changes
- API contracts
- Constraints not visible in the code

Do NOT include specific file paths or code snippets. They may end up being outdated very quickly.

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
- Do NOT include specific file paths or code snippets — they rot.
- User stories should be extensive. Cover the happy path, edge cases, error states, and administrative flows.
- Technical decisions should capture the "why" behind choices, not just the "what."
- Out of scope is mandatory. If nothing is excluded, the scope is too vague.
- Be concrete. "Improve performance" is not a success criterion. "P95 latency under 200ms for queries with <1000 results" is.
