@~/.codex/AGENTS.md

<!--
The line above is a live Claude Code import, not a reference. It must stay
unbackticked and outside any code fence, or Claude reads it as literal text and
loads none of the shared rules. See `~/.codex/AGENTS.md` for why that file is
canonical rather than this one.
-->

# Claude Code

Everything above is shared with Codex. Only Claude-specific rules belong below.

## Skills

The planning pipeline narrows from open questions to a set of lanes:

`/grill-with-docs` → `/to-prd` → `/to-issues`

- **`/grill-with-docs`** settles pre-fan-out decisions, one question at a time. HITL by construction — never delegate it to a subagent or run it inside a worktree.
- **`/to-prd`** freezes the interfaces and plans the worktrees.
- **`/to-issues`** assigns every issue to exactly one worktree, verifies the split is write-disjoint, and hands over the per-lane launch commands.

No skill spawns agents. `/to-issues` stops at the commands; running them is manual.

## Worktrees

Where lanes live and how to launch them is in `AGENTS.md`. Claude-only additions:

- **Auto memory is shared across every worktree of a repository** — the storage path derives from the git repo, not the checkout. Parallel lanes in the same repo write to one memory directory, so a note saved in one lane surfaces in the others.
- A subagent's auto memory is a separate directory from the main conversation's, and a `fork` inherits the parent conversation while a fresh subagent does not.
