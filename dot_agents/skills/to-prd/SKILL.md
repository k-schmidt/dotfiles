---
name: to-prd
description: Turn settled conversation context into a file-backed PRD with frozen interfaces and a write-disjoint Codex task plan. Use for implementation specifications and handoffs after material product or architecture decisions are resolved.
---

# To PRD

Synthesize the existing conversation and repository evidence into a decision-complete PRD. Do not reopen settled decisions or add unrequested product scope.

## Process

1. Explore the repository when needed. Use the applicable `docs/CONTEXT.md` vocabulary, resolving it through `docs/CONTEXT-MAP.md` when present, and respect existing ADRs.
2. Identify the deep modules or coherent capabilities the change affects. Capture observable behavior and the reason for each boundary.
3. Freeze every interface that separate tasks must share: signatures, payloads, schemas, events, shared-file ownership, and cross-boundary failure semantics. Identify the highest faithful public seams where observable behavior will be verified. Mark genuinely undecided contracts **UNRESOLVED** and block dependent work.
4. Draft a task plan whose write ownership is disjoint. Each task lists the files or directories it owns, important read-only context, dependencies, HITL/AFK type, and a verifiable outcome. Reserve shared files for exactly one task or integration.
5. If a critical module, test, interface, or ownership decision is still missing, ask only for that decision. Otherwise synthesize without interviewing.
6. Follow a repository-specific planning layout when its instructions declare one. Otherwise check for existing `specs/PRD-*.md` files and avoid overwriting one without approval.
7. By default, write `specs/PRD-{feature-name}.md` using [PRD-TEMPLATE.md](./PRD-TEMPLATE.md).
8. Report the path, unresolved blockers, HITL/AFK task count, and the next step: `$to-tasks`.

## Invariants

- `specs/` is reserved for PRDs and issue files; persistent design documentation belongs under `docs/`.
- No two planned tasks write the same file.
- No task starts against an unresolved interface it depends on.
- Requirements describe intent; file paths appear only where ownership must be concrete.
- Implementation tasks stop at a tested, review-ready diff unless publishing is explicitly in scope.
