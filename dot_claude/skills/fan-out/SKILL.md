---
name: fan-out
description: Spawn parallel worker agents across the worktrees planned in a PRD, then review and integrate their branches in dependency order. Use when a PRD and its issues exist and the user wants the AFK work executed in parallel, or says "fan out", "spawn workers", "run these in parallel", or "orchestrate the issues".
---

# Fan Out

Take a PRD's worktree plan and its published issues, and run the AFK work as parallel workers in isolated worktrees. You are the orchestrator: you approve the split, spawn the workers, and integrate what comes back. You do not implement the AFK slices yourself.

## Before anything else: is this worth fanning out?

Fan-out buys **isolation**, not speed. Every fresh worker starts cold and re-derives context you already hold, so a small or serial change is genuinely cheaper and better done in this session.

Say so and stop if any of these hold:

- There is only one AFK worktree — nothing to parallelise, just do the work.
- The worktrees are not file-disjoint — fix the PRD first, or you are scheduling a hand-merge.
- Any worktree depends on an **UNRESOLVED** interface — resolve it with `/grill-with-docs` first, or a worker will guess and you will rebuild.
- The whole change is a handful of files — the coordination overhead exceeds the work.

Recommend the cheaper path plainly rather than fanning out because you were asked to.

## Process

### 1. Read the plan

Read the PRD's **Worktree Plan**, **Frozen Interfaces**, and tracking table. Read the published issues. If there is no worktree plan, stop and offer `/to-prd`; if there are no issues, stop and offer `/to-issues`. Do not invent either here.

### 2. Verify the split before spawning anything

Check the plan mechanically. These are cheap to check now and expensive to discover later:

- **Write-disjointness.** Take the `Writes` field of every issue and confirm no file or directory appears under two different worktrees. Report any overlap and stop — this is the one failure that guarantees manual merge work.
- **Reserved files.** Confirm every file in the PRD's reserved table is owned by exactly one worktree, or held for integration.
- **Contract readiness.** Confirm no worktree you are about to start depends on an UNRESOLVED interface.
- **Dependency depth.** If cross-worktree dependencies run more than two deep, report it — the split is too entangled to be worth parallelising.

### 3. Get explicit approval

Present the fan-out plan and **wait for the user to approve it**. Nothing is spawned before this. Show:

- Each worktree, HITL or AFK, what it owns, what it depends on
- Which worktrees start in wave one (AFK, no unmet dependencies)
- Which are held back, and what unblocks them
- Which are HITL and will stay in this session with the user

### 4. Build the task graph

Create one task per issue with `TaskCreate`, then encode the dependency graph with `TaskUpdate`'s `addBlockedBy`. The graph is what lets you land work in a correct order later without re-deriving it, and it survives this session.

Set each task's owner as you assign it, so `TaskList` shows what is claimed and what is free.

### 5. Spawn wave one

For each AFK worktree with no unmet dependency, spawn one worker with its own checkout:

- Use the `Agent` tool with `isolation: "worktree"` — the agent gets an isolated git worktree, and an unchanged one is cleaned up automatically on exit.
- Give it a `name` so you can reach it later with `SendMessage`.
- One worker per worktree, not per issue. Issues inside a worktree run serially, in the order `/to-issues` listed them.

<worker-brief>
Every worker starts cold. It has none of this conversation. Its brief must therefore carry, in full:

- The worktree's name, and the exact paths it owns and may write
- **An explicit prohibition on writing outside those paths**, including reserved files
- The frozen interfaces it must build against, quoted verbatim from the PRD — not referenced
- Its issues in order, with acceptance criteria
- The project's conventions: `uv sync`, `ruff check . --fix`, `ruff format .`, `pytest -v --durations=5`; Conventional Commits
- Instructions to commit on its own branch and stop — never merge to the default branch, never push
- Instructions to report which files it actually wrote, so you can verify the boundary held
</worker-brief>

Workers run in the background and their tool output stays out of your context. You will be re-invoked when each finishes — do not poll for them.

### 6. Run the HITL work yourself

While workers run, work the HITL issues in this session with the user. That is the whole point of separating HITL from AFK: the human-attention work and the parallel work happen at the same time instead of queueing behind each other.

### 7. Review each branch before it lands

As each worker reports back:

- Confirm it wrote only files its worktree owns. If it escaped its boundary, that is the finding — deal with it before reviewing anything else.
- Run `/code-review` against its branch. Use `--fix` to apply findings, or review and hand corrections back to the worker with `SendMessage` if the work needs its author's context.
- Run `/security-review` if the branch touched auth, input handling, secrets, or permissions.
- Use `difft` for semantic diffs when a change is large or mechanical.

Review before merge, not after. A branch that lands unreviewed removes your ability to reject it cheaply.

### 8. Integrate in dependency order

Merge in the order the task graph implies — unblocked worktrees first, then whatever they unblock. After each merge:

- Run the test suite. A worktree's tests passing in isolation does not mean they pass together.
- Mark the task completed with `TaskUpdate`, which surfaces newly unblocked work in `TaskList`.
- Spawn the next wave for worktrees whose dependencies are now satisfied, repeating from step 5.

Handle the reserved files during integration, once, rather than letting any worker touch them.

### 9. Close out

When every worktree has landed:

- Update the PRD tracking table to reflect completion
- Report what landed, what was rejected or redone, and any boundary violations worth fixing in the next PRD's worktree plan
- Confirm no stray worktrees remain

## Notes

- **`subagent_type: "fork"`** inherits your full context instead of starting cold, and always runs your model. Use it when a worker genuinely needs the conversation so far; prefer a cold worker with a good brief otherwise, since forks are expensive.
- **Do not spawn a worker to plan.** Planning is `/grill-with-docs` and `/to-prd`, with the user present. A worker that plans is a worker guessing at intent.
- **Never delegate `/grill-with-docs`** — it is HITL by construction.
- If a worker stalls or goes wrong, `SendMessage` to steer it before killing and respawning. Respawning pays the cold-start cost again.
