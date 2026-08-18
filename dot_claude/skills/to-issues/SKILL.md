---
name: to-issues
description: Break a plan, spec, or PRD into independently-grabbable issues, grouped by the worktree that will own them. Use when user wants to convert a plan into issues, create implementation tickets, or break down work into tasks.
---

# To Issues

Break a plan into independently-grabbable issues, grouped by worktree so `/fan-out` can hand each group to a worker. Never use the AskUserQuestion tool.

## Process

### 1. Gather context

Work from whatever is already in the conversation context. If the user passes a PRD path or issue reference as an argument, read it.

Read the PRD's **Worktree Plan** and **Frozen Interfaces** sections in full. The worktree plan is the primary organizing principle for everything below. If the PRD has no worktree plan, say so and offer to run `/to-prd` first — inventing a split here duplicates work `/to-prd` owns, and the two will disagree.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code. Issue titles and descriptions should use the project's domain glossary vocabulary from `docs/CONTEXT.md`, and respect ADRs in `docs/adr/`.

### 3. Assign every issue to exactly one worktree

Group the work by the worktree that will own it. Each issue belongs to exactly one worktree from the PRD, and writes only files that worktree owns.

<grouping-rules>
- **An issue that needs to write files owned by two worktrees is malformed.** Split it along the seam, using the frozen interface as the boundary, so each half writes only its own worktree's files. If the interface is UNRESOLVED, the work is blocked — mark it and move on rather than guessing.
- Issues inside one worktree run **serially**, in the order you list them. Worktrees run in **parallel**. So dependencies within a worktree are cheap; dependencies across worktrees are what constrain the whole fan-out.
- If you find yourself wanting a cross-worktree dependency chain more than two deep, the worktree split is wrong. Say so and recommend a revision to the PRD rather than encoding the chain.
- Mark each issue HITL or AFK, matching its worktree. A HITL issue in an otherwise AFK worktree makes the whole worktree HITL — flag it, because it costs the parallelism.
</grouping-rules>

### 4. Shape each issue

Prefer **vertical slices** — a thin path that cuts through every layer it touches (schema, API, UI, tests), so the issue is demoable or verifiable on its own.

Prefer, not require. When a worktree boundary and a vertical slice disagree, **the worktree boundary wins**: parallel isolation is the thing being optimized for, and a slice that reaches across two worktrees cannot be isolated.

Be aware of what that costs. An issue shaped by ownership rather than by user-visible behaviour may not be demoable alone — it may only be verifiable once its sibling worktrees land. Where that happens:

- Say so in the issue's acceptance criteria ("verifiable after {other worktree} lands").
- Keep the issue's own tests passing in isolation regardless, even if the end-to-end behaviour is not yet reachable.
- Still avoid the pure horizontal split *within* a worktree — "all migrations", then "all handlers", then "all tests" leaves nothing working until the last one lands, and that failure mode is unchanged by parallelism.

<shape-rules>
- Prefer many thin issues over few thick ones
- Within a worktree, vertical beats horizontal:
  - ❌ "Write all migrations" → "Write all handlers" → "Write all tests"
  - ✅ "Implement user creation (migration + handler + test)" → "Implement user deletion (migration + handler + test)"
- Every issue names the files it expects to write, so `/fan-out` can verify no collision survived the breakdown
</shape-rules>

### 5. Quiz the user

Present the proposed breakdown grouped by worktree. For each worktree, show its name, HITL/AFK, and what it depends on. Under it, for each issue:

- **Title**: short descriptive name
- **Type**: HITL / AFK
- **Writes**: the files this issue expects to touch
- **Blocked by**: which other issues (if any) must complete first
- **User stories covered**: which user stories this addresses (if the source material has them)

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the dependency relationships correct?
- Should any issues be merged or split further?
- Are the correct issues marked as HITL and AFK?
- Does any issue write outside its worktree's ownership?

Iterate until the user approves the breakdown.

### 6. Publish issues

Detect the issue tracker:

- If inside Meta's codebase → use the `/tasks` skill to create GSD tasks via `meta tasks.task create` with `--owner=kyleschmidt`. If a GSD parent task exists for the PRD (created by `/to-prd`), nest each issue as a sub-task under it. The PRD parent task has `commitClose` and `closeDependents` — when the attached diff lands, it closes the parent, and `closeDependents` cascades the close to all child tasks. Add comments to tasks if they are blocked or have open questions.
- If `.github/` exists or `git remote -v` points to GitHub → use `gh issue create`
- Otherwise → write issues as local markdown files under `specs/issues/` (one file per issue)
- The user can override by stating their preference

Publish issues in dependency order (blockers first) so you can reference real issue identifiers in the "Blocked by" field.

<issue-template>
## Parent

A reference to the parent PRD or issue (if applicable).

## Worktree

The worktree that owns this issue, from the PRD's Worktree Plan. One only.

## What to build

A concise description of the work. Describe the end-to-end behavior, not layer-by-layer implementation.

## Why

Brief context — why this task exists and what it enables.

## Writes

The files and directories this issue expects to modify. Must fall entirely within
the owning worktree's declared ownership.

## Contracts

The frozen interfaces from the PRD that this issue must build against, quoted or
referenced. If any is UNRESOLVED, this issue is blocked.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

Note here if end-to-end verification requires a sibling worktree to land first.

## Blocked by

- A reference to the blocking issue (if any)

Or "None - can start immediately" if no blockers.

## When done

- Close this issue
- Update the PRD tracking table to reflect completion

</issue-template>

Do NOT close or modify any parent issue or PRD — except to append the tracking table below.

### 7. Update the PRD

If the issues were created to address a PRD, append a tracking table to the end of the PRD:

| Issue | Worktree | Description | Type | Blocked by |
|-------|----------|-------------|------|------------|
| Link or ID | Worktree name | One-line summary | HITL / AFK | Link(s) or "None" |

One row per issue, grouped by worktree, in dependency order (blockers first).

### 8. Hand off to /fan-out

After publishing, report the shape of the fan-out: how many worktrees, which are AFK and can be handed to workers immediately, which are HITL and stay with the user, and which are blocked on an unresolved interface.

Then offer to run `/fan-out` to create the worktrees and spawn workers.

Do not spawn workers from this skill, and do not begin implementation here. Breakdown and orchestration are kept separate so a failed fan-out can be retried without redoing the breakdown.
