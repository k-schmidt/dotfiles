# User Context
- **User**: Kyle (Tech Lead, Data Engineering Manager @ Meta).
- **Focus**: Software Engineering, Data Engineering, Infrastructure, AI Engineering (Agents/Evals), System Design.
- **Aesthetic**: Minimalist, clean, functional — strict types, no clutter.

# Core Principles
1. **Architectural First**: Analyze broader system impact before writing code.
2. **Type Safety**: Python uses `pydantic` and `typeguard`. Prefer TypeScript over JavaScript.
3. **Observability**: AI components must be instrumented (logs/traces) for evaluation.
4. **Prompt/Logic Separation**: All prompts live in template files, never inline — enables eval workflows.

# Preferences
- Markdown output should be Obsidian-friendly (`[[WikiLinks]]`).

# Commands
- **Python**: `uv sync` (never pip/Poetry/requirements.txt), `ruff check . --fix`, `ruff format .`, `pytest -v --durations=5`
- **Git**: Conventional Commits (`feat:`, `fix:`, `chore:`). Run `pre-commit run --all-files` before finalizing.

# This file is canonical
This is the single rulebook for every coding agent on this machine. Codex reads it
directly. Claude Code cannot read `AGENTS.md`, so `~/.claude/CLAUDE.md` is a one-line
import of this file plus a short Claude-only tail.

**Put shared rules here, not in `CLAUDE.md`.** Two hand-maintained copies drift: the
previous copy of this file still described a Linux devserver that had been deleted,
so a Codex session was following instructions about a machine that no longer existed.

Per project, mirror the same shape: a committed `AGENTS.md` holds the conventions,
and a committed `CLAUDE.md` imports it and adds Claude-only notes below.

Caveat: `/init` and `/doctor` write to `CLAUDE.md`. Move anything shared that lands
there down into `AGENTS.md`.

# Parallel lane workflow
Work is split so several agents can run at once without coordinating. Vocabulary,
used consistently across all of these skills and docs:

- **Lane** — one unit of parallel work: a git worktree, a branch, one cmux pane, and
  one agent (`claude` or `codex`). Lanes run in parallel; issues inside a lane run
  serially.
- **HITL** — needs a human in the loop (an architectural call, a design review, a
  product judgement). Stays in the main session.
- **AFK** — implementable and mergeable without a human. Prefer AFK.
- **Pre-fan-out decision** — one that two agents who never speak would each have to
  answer, and could answer differently: shared vocabulary, interfaces at a seam,
  ownership of a shared surface, error semantics that cross a seam. Settle these
  before lanes start; everything else is deferrable to whoever owns the lane.
- **Frozen interface** — a contract at a seam, written concretely enough that two
  agents can build opposite sides of it without talking.

Two invariants:

1. **No two lanes write the same file.** Violating this guarantees a hand-merge.
2. **No lane starts against an unresolved interface.** Violating this guarantees a
   rewrite, because the guess gets built twice, incompatibly.

Execution is manual and deliberately so. cmux is the control plane — one pane per
lane. VS Code is the review surface, opened against whichever worktree needs
attention. No skill spawns agents; the human creates the worktrees and drives them.

# Where lanes live

Worktrees stay at Claude Code's default, `.claude/worktrees/<name>/` inside the repo,
on a branch named `worktree-<name>`. Sibling directories outside the repo were
considered and rejected: they forfeit two things that only apply to worktrees Claude
Code creates itself.

- **Write isolation is enforced, not just conventional.** In a `--worktree` session,
  Claude Code blocks edits targeting the main checkout, Bash commands whose working
  directory resolves there, and git redirects into it. That is the guard against
  editing `main` while believing you are in a lane.
- **`.worktreeinclude` copies gitignored files** such as `.env` into every new
  worktree. A manually created worktree starts without them and breaks on startup.

One-time setup per repo, both committed:

```gitignore
# .gitignore
.claude/worktrees/
```

```text
# .worktreeinclude — gitignored files each lane needs
.env
.env.local
```

Without the `.gitignore` line, every `rg`, `fd`, and telescope search in the main
checkout returns one hit per lane on top of the real one, and `git status` fills with
untracked noise.

Launching a lane:

```bash
lane <lane>                                       # Claude lane (zsh helper)
CLAUDE_CODE_DISABLE_AUTO_MEMORY=1 claude -w <lane>   # ...what it expands to
git worktree add .claude/worktrees/<lane> -b worktree-<lane> \
  && cd .claude/worktrees/<lane> && codex         # Codex lane
```

Skip `--tmux` — it targets iTerm2 native panes, and cmux is already the pane manager.
Codex has no worktree flag, so its lane is created with git directly, but kept in the
same location so one `.gitignore` line covers both.

**Auto memory is off in lanes, on in the orchestrator session.** Auto memory is keyed
to the git repository, not the checkout, so every lane in a repo reads and writes one
memory directory. During a fan-out the lanes deliberately hold divergent views of the
same code, so a note that is true in one lane loads into the others as fact. Anything a
lane learns that is genuinely durable belongs in this file, added during integration
where it gets reviewed.

New worktrees branch from the remote default branch, not your current work. To branch
lanes off in-progress work instead, set `worktree.baseRef` to `"head"` in settings.

# Landing a lane

**If you are running in a lane:** commit on your own branch and stop. Never merge to
the default branch, never push, never touch a file outside your worktree's declared
ownership. Report which files you actually wrote. A lane that self-merges removes the
human's ability to reject it cheaply, which is the whole point of isolating it.

**If you are integrating lanes**, per branch, in this order:

1. Confirm the lane wrote only files it owned. An escaped boundary is the finding —
   deal with it before reviewing anything else.
2. Review before merge, not after. `/code-review` on the branch; `difft` for semantic
   diffs when the change is large or mechanical.
3. `/security-review` if the branch touched auth, input handling, secrets, or
   permissions.
4. Merge in dependency order — lanes nothing depends on first.
5. Run the suite after each merge. A lane's tests passing in isolation does not mean
   they pass together.
6. Handle reserved files once, here, rather than letting any lane touch them.

# Dotfiles (chezmoi)
- Always edit source files in `~/.local/share/chezmoi/`, never targets directly.
- Push after commit.
- **macOS (Apple Silicon) is the only supported target.** No `.chezmoi.os` conditionals, no `uname` guards. Still probe for optional things (`if [[ -d /opt/homebrew/bin ]]; then ... fi`) so an Intel Mac or a missing tool degrades quietly.
- PATH order: Homebrew > Volta > system. Homebrew block must appear after Volta in the file so it prepends last.
- Homebrew owns anything with a formula or cask; Volta owns npm-only tools. Never install the same tool through both — the Homebrew copy wins and silently shadows the newer one.
- **Do not track VS Code config in chezmoi.** VS Code Settings Sync owns `settings.json`, `keybindings.json`, and extensions. Adding them here double-owns the same files and last writer wins.
