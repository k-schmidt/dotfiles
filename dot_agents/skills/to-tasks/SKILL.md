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
- **Must not write**: files owned by another task or otherwise reserved, named explicitly whenever the task runs alongside other work
- **Reads**: important context it may inspect but not modify
- **Contracts**: frozen interfaces it consumes or exposes
- **Test seam**: the highest faithful public interface where its outcome is verified
- **Acceptance criteria**
- **Blocked by**
- **When done**: tests to run and the required handoff

Implementation tasks stop at a tested, review-ready diff. They must not commit, push, open a pull request, or merge unless publishing is explicitly included in the approved brief.

## Self-check

Verify the graph before presenting it. Each check has one correct repair; apply it and re-check rather than surfacing a graph with a known defect for the user to catch.

| Check | Repair when it fails |
| --- | --- |
| No file or directory appears in two tasks' **Owns (writes)** | Split along a module seam, or move the shared file to an integration task |
| Reserved surfaces — manifests, generated output, migrations, lockfiles, tracking documents — have exactly one owner | Assign the surface to one task or to integration |
| Every **Contracts** entry resolves to a frozen interface | Mark the interface UNRESOLVED and block the tasks that depend on it |
| Every implementation outcome names a faithful **Test seam** | Say no seam exists and record it as an architectural finding; do not invent a shallow test |
| Dependencies are acyclic and as shallow as the architecture permits | Extract the shared prerequisite into its own task |
| HITL tasks contain the actual human decision, and AFK tasks contain no hidden approval step | Reclassify the task and name the decision it carries |

## Approval checkpoint

Present the complete graph, state the results of the self-check, and wait for the user to approve or revise it.

## Create tasks

After approval, create one Codex task per brief using the current app's task tools when available. Use a managed worktree for tasks that change repository files. Keep judgement-heavy HITL work with the user; dispatch only approved AFK work.

Do not substitute subagents for write-bearing implementation tasks. Subagents may perform bounded read-only exploration while the graph is being drafted; approved implementation outcomes belong in user-visible Codex tasks with managed worktrees.

If task creation is unavailable, output copy-ready briefs in dependency order instead of substituting another tracker. Export to GitHub or another issue tracker only when the user explicitly requests that external write.

When a PRD exists, append a tracking table with task identifiers, type, dependencies, and status. Do not rewrite the PRD's requirements.

## Verify delegated output

Write-disjoint ownership is an invariant, not a hope. Check it against the artifact rather than the worker's account of the artifact.

A completion summary reports what a task intended to do, and usually reports it correctly. The exceptions are the expensive ones — a deleted helper, a reverted unrelated change, a removed test function — and a summary that omits a destructive side effect gives no signal that it did.

For each completed task:

- Run `git diff --stat` on its branch or managed worktree and compare the touched paths against its declared **Owns (writes)** set.
- Treat any path outside that set as a write-ownership violation and resolve it before integration, not at merge time.
- Confirm deletions and removed tests explicitly. `--stat` shows them; a summary often does not.

State the negative constraint in the brief whenever other work is live in the same repository. "Only touch these files" reads as guidance about the goal, while an explicit **Must not write** list reads as a boundary; an instruction like "clean up" is otherwise interpreted broadly.
