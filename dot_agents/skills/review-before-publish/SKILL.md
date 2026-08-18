---
name: review-before-publish
description: Review local or branch changes before commit, push, or pull-request creation. Use when the user asks for a code review, diff review, pre-publish check, or verification that an implementation matches its task or specification. Report findings without changing or publishing code unless separately requested.
---

# Review Before Publish

Review the complete intended change and return evidence-backed findings. This is a read-only boundary: do not fix, stage, commit, push, or open a pull request unless the user separately requests that action.

## Pin the review scope

Resolve the fixed point the user supplied. When none is supplied, inspect repository state and choose the comparison that covers the intended work:

- branch work: the merge base with the repository's default branch;
- uncommitted work: unstaged, staged, and relevant untracked files;
- an explicitly named commit, tag, branch, range, or path: exactly that scope.

List the files included and confirm the diff is non-empty. Include both committed and working-tree changes when both belong to the implementation; do not let a clean `git diff <base>...HEAD` hide uncommitted work.

Read applicable `AGENTS.md` files, repository standards, relevant domain documentation, and the originating PRD, issue, or Codex task brief when one exists.

## Review through independent lenses

Keep these lenses separate so strength in one does not mask failure in another. Review a small or cohesive diff in the primary task with distinct passes. When a substantial diff contains two or more independently reviewable areas or lenses, assign each to a read-only subagent with a fixed scope and evidence requirements. Subagents do not edit; the primary task verifies every finding against the complete diff and synthesizes the final review.

### Correctness and safety

Look for incorrect behavior, missing edge cases, broken error semantics, concurrency hazards, unsafe input handling, permission mistakes, secret exposure, data loss, backward-compatibility failures, and tests that cannot detect the regression they claim to cover. Trace suspicious changes through their callers and consumers before reporting them.

### Repository standards and architecture

Check the change against documented project rules, established types and patterns, domain vocabulary, module interfaces, ownership boundaries, and maintainability expectations. Treat general code smells as judgement calls, and omit style complaints that automated tooling already enforces.

### Specification fidelity

Compare the implementation with its PRD, issue, or task brief. Report missing or partial requirements, behavior that contradicts the source, and meaningful scope creep. If no specification exists, state that this lens was unavailable rather than inventing one.

## Report findings

Verify every finding against the actual diff and enough surrounding code to support it. Order findings by severity and include:

- a short title and priority (`P0` critical through `P3` minor);
- the tightest useful file and line reference;
- the concrete failure or maintenance risk;
- the condition that triggers it;
- the smallest credible direction for correction.

Do not inflate uncertain possibilities into defects. Label residual uncertainty and name the evidence needed to resolve it. If there are no actionable findings, say so and note any verification gaps or unreviewed lens.

End with a compact count by lens and the checks that were actually run. Stop before the publish boundary.
