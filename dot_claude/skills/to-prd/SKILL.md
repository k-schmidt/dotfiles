---
name: to-prd
description: Turn the current conversation context into a file-based PRD, including the worktree plan that parallel workers will be fanned out across. Use when user wants to create a PRD from the current context, write a spec, or document requirements for handoff.
---

This skill takes the current conversation context and codebase understanding and produces a PRD. Do NOT interview the user — just synthesize what you already know. Never use the AskUserQuestion tool.

The PRD is the last document written while one agent still holds the whole picture. Downstream, `/to-issues` splits it and you hand each lane to a separate agent in its own worktree, so any decision left unmade here gets made independently — and incompatibly — by several agents at once. Settle the seams now.

## Process

1. Explore the repo to understand the current state of the codebase, if you haven't already. Use the project's domain glossary vocabulary from `docs/CONTEXT.md` throughout the PRD, and respect any ADRs in `docs/adr/`.

2. Sketch out the major modules you will need to build or modify to complete the implementation. Actively look for opportunities to extract deep modules that can be tested in isolation.

   A deep module (as opposed to a shallow module) is one which encapsulates a lot of functionality in a simple, testable interface which rarely changes.

   Check with the user that these modules match their expectations. Check with the user which modules they want tests written for.

3. **Freeze the interfaces between modules.** For every seam where one module calls another, write the contract down: function signatures, event shapes, table columns, HTTP payloads. This is the single highest-value thing in the PRD, because a frozen contract is what lets two workers build both sides of a seam at the same time without talking to each other. If a contract is genuinely unresolved, say so explicitly and mark the work that depends on it as blocked rather than guessing.

4. **Plan the worktrees.** Group the work into worktrees that parallel workers can each own outright.

   <worktree-rules>
   - **No two worktrees may write the same file.** This is the only hard rule. A file written from two worktrees is a merge conflict you will resolve by hand, and it defeats the point of isolating them.
   - Derive boundaries from the module seams in step 2 — a deep module with a frozen interface is the natural unit of ownership.
   - List the concrete file paths and directories each worktree owns. Reads may overlap freely; only writes are exclusive.
   - Name shared files that no worktree may touch (lockfiles, generated code, root config, migration sequence files). Assign each to exactly one worktree, or reserve it for the integration step.
   - Mark each worktree **HITL** or **AFK**. HITL work needs a human in the loop — an architectural call, a design review, a judgement about product behaviour. AFK work can be implemented and merged without one. Prefer AFK.
   - Prefer fewer, well-separated worktrees over many overlapping ones. Three clean lanes beat eight that collide.
   - Sequence matters: if worktree B needs an interface that worktree A introduces, record that dependency so you know to start A's lane first.
   </worktree-rules>

   Check the worktree plan with the user before writing the PRD. This split is what the whole downstream pipeline is built on, and it is much cheaper to change here than after workers are running.

5. Write the PRD using the template in [PRD-TEMPLATE.md](./PRD-TEMPLATE.md).

6. **Safety check:** Before writing, check if `specs/PRD-*.md` files already exist. If they do, list them and ask whether to overwrite or use a different name.

7. Write the PRD to `specs/PRD-{feature-name}.md` in the current project. Create the `specs/` directory if it doesn't exist.

8. **If inside Meta's codebase**, also create a GSD parent task:
   - Title: `PRD: {feature-name}`
   - Description: The full PRD content (markdown)
   - Tags: `prd`, `commitClose`, `closeDependents`
   - Owner: `kyleschmidt`
   - Use the `/tasks` skill to create the task
   - `commitClose` auto-closes this task when the attached diff lands; `closeDependents` cascades the close to all child tasks

9. After writing, tell the user:
   - The file path of the PRD
   - The GSD task number and link (if created)
   - The worktree count and which are HITL vs AFK
   - Suggest next step: run `/to-issues` to break it into implementation tasks grouped by worktree (which will be nested under the GSD parent task if one was created)
