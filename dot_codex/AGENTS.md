# User Context

- **User:** Kyle, Senior Staff Data Engineer, Analytics Professional, Data Platform Engineer.
- **Focus:** Software engineering, data engineering, AI engineering, agent evaluation, data science, machine learning, and system design.
- **Aesthetic:** Minimal, clean, functional, and strongly typed.

# Engineering Principles

1. Analyze architectural and system-level impact before implementation.
2. Instrument AI components with useful logs or traces so their behavior can be evaluated.
3. Keep prompts in template files rather than embedding them in application logic.
4. Follow the repository's declared package manager, commands, conventions, and verification steps when they differ from personal defaults.

# Communication

- Keep output concise, concrete, and free of clutter.
- Surface architectural trade-offs and evidence rather than hiding them behind implementation detail.

# Codex Workflow

- Codex desktop is the primary control plane for planning, implementation, managed worktrees, review, and handoff.
- A **task** is the unit of conversation and ownership. A **managed worktree** is its optional isolated execution environment.
- cmux with Codex CLI is the terminal fallback. VS Code is the visual-inspection fallback. Claude Code is an explicitly invoked compatibility fallback.
- Use normal Codex sandbox and approval defaults. Do not create shortcuts that bypass them.
- Classify work as **HITL** when it requires human judgement and **AFK** when it can reach a review-ready result autonomously.
- Before parallel tasks start, freeze shared vocabulary, interfaces, shared-file ownership, and cross-boundary error semantics.
- Parallel tasks may read overlapping files but must not write the same file. If ownership overlaps, restructure the task split first.
- Implementation tasks stop at a tested, review-ready diff with a concise handoff. Do not commit, push, open a PR, or merge unless publishing is explicitly requested.
- Before an explicitly requested publish action, use `$review-before-publish` on the complete intended change and surface any blocking findings before proceeding.

# Delegation

- Default to the primary task. Keep user interviews, evolving diagnosis, architectural decisions, integration, final validation, and publishing there.
- Use subagents for bounded, independent, primarily read-only investigations whose evidence the primary task can verify and synthesize. Give each subagent a narrow scope, explicit output, and stopping condition.
- Subagents must not write shared files or act as implementation lanes.
- Use separate Codex tasks with managed worktrees for independent implementation outcomes only after shared interfaces are frozen, write ownership is disjoint, and each task has its own faithful test seam.
- Do not delegate work to avoid resolving an interface, ownership conflict, or missing product decision.
- The primary task owns cross-task integration and the final review-before-publish boundary.

# Git

- Use Conventional Commit prefixes when a repository does not specify another convention.
- Preserve unrelated user changes in dirty worktrees.
- Treat commits, pushes, pull requests, merges, and destructive history operations as explicit publishing actions.
