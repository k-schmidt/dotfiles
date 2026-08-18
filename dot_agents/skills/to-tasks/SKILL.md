---
name: to-tasks
description: Turn an approved plan or PRD into decision-complete, write-disjoint Codex tasks. Use when the user wants implementation tasks, parallel task fan-out, or managed-worktree execution briefs. Use GitHub issues only when explicitly requested.
---

# To Tasks

Convert an approved plan into Codex-native task briefs, validate their boundaries, and create the tasks only after the user approves the fan-out.

## Build the task graph

1. Read the referenced PRD or use the current conversation context. Explore the repository when ownership, interfaces, or verification commands are not already known.
2. Carry forward every **Frozen Interface**. An unresolved interface blocks every task that depends on it; never let parallel tasks guess the contract independently.
3. Prefer thin, end-to-end outcomes. Split along module seams when a vertical slice would make two tasks write the same file.
   - **Wide-refactor exception:** a mechanical change with broad blast radius, such as a schema, protocol, or shared-symbol migration, may be impossible to land as independent vertical slices. Plan it as **expand → migrate → contract**: introduce the compatible new form, migrate callers in bounded batches, then remove the old form after every batch is complete. Keep each intermediate state verifiable; use an integration task when batches cannot be independently green.
4. Classify each task:
   - **HITL:** requires product, architecture, design, security, or rollout judgement.
   - **AFK:** can reach a tested, review-ready diff autonomously.
5. Give every file or directory that will be modified exactly one owner. Reads may overlap. Reserve shared manifests, generated outputs, migrations, lockfiles, and tracking documents for one task or for integration.
6. Record real dependencies only. A task with an unresolved contract or unavailable prerequisite is blocked rather than guessed.

## Task brief

For every task provide:

- **Title**
- **Outcome**: one verifiable behavior or capability
- **Why**
- **Type**: HITL or AFK
- **Owns (writes)**: exclusive files or directories
- **Reads**: important context it may inspect but not modify
- **Contracts**: frozen interfaces it consumes or exposes
- **Test seam**: the highest faithful public interface where its outcome is verified
- **Acceptance criteria**
- **Blocked by**
- **When done**: tests to run and the required handoff

Implementation tasks stop at a tested, review-ready diff. They must not commit, push, open a pull request, or merge unless publishing is explicitly included in the approved brief.

## Approval checkpoint

Present the complete graph and verify:

- No two tasks own the same file.
- Every shared interface is frozen or explicitly unresolved.
- Every implementation outcome has a faithful test seam or an explicit explanation of why none exists.
- Dependencies are acyclic and as shallow as the architecture permits.
- HITL tasks contain the actual human decision; AFK tasks contain no hidden approval step.
- Reserved files have one owner.

Wait for the user to approve or revise the graph.

## Create tasks

After approval, create one Codex task per brief using the current app's task tools when available. Use a managed worktree for tasks that change repository files. Keep judgement-heavy HITL work with the user; dispatch only approved AFK work.

Do not substitute subagents for write-bearing implementation tasks. Subagents may perform bounded read-only exploration while the graph is being drafted; approved implementation outcomes belong in user-visible Codex tasks with managed worktrees.

If task creation is unavailable, output copy-ready briefs in dependency order instead of substituting another tracker. Export to GitHub or another issue tracker only when the user explicitly requests that external write.

When a PRD exists, append a tracking table with task identifiers, type, dependencies, and status. Do not rewrite the PRD's requirements.
