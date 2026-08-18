# Dotfiles

macOS developer environment managed with **chezmoi**. Optimized for AI Engineering, Data Infrastructure, and high-performance workflows.

> macOS is the only supported target. Every config assumes Homebrew, `pbcopy`, and a local display; there are no `.chezmoi.os` conditionals or `uname` guards left in the tree.

## The Stack

* **Core:** `zsh`, `chezmoi`, `homebrew`
* **Editor:** [Cursor](https://cursor.sh) (AI-native) & VS Code & Neovim
* **Terminal:** [Ghostty](https://ghostty.org) & iTerm2, [Powerlevel10k](https://github.com/romkatv/powerlevel10k), `tmux`, `fzf`, `zoxide`, `ripgrep`, `fd`
* **Python:** `uv` (Blazing fast package management)
* **AI Agents:** `claude-code`, `codex`, and [cmux](https://github.com/manaflow-ai/cmux) as the workspace shell around them
* **Infra:** `orbstack` (Docker replacement), `direnv`, `gh`, `difftastic`, `lazygit`
* **Productivity:** Raycast, Obsidian, Todoist, KeepingYouAwake

## Installation

### macOS (Fresh Machine)

1. Install Xcode Command Line Tools:
```bash
xcode-select --install
```

2. Bootstrap & apply:
```bash
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply k-schmidt
```

### Post-Install

1. **Authenticate:** `gh auth login` and `claude auth login`
2. **Fonts:** iTerm2 → Settings → Profiles → Text → **JetBrainsMono Nerd Font**
3. **Touch ID for sudo:**
```bash
sudo sed -i '' '2i\auth       sufficient     pam_tid.so' /etc/pam.d/sudo
```

## Workflow

### Editing configs

Always edit source files, never targets:

```bash
chezmoi edit ~/.zshrc
chezmoi apply
```

### Adding a Brew package

```bash
chezmoi edit ~/.config/brew/Brewfile
chezmoi apply
```

### Saving changes

```bash
cd ~/.local/share/chezmoi
git add . && git commit -m "feat: description"
git push
```

## Claude Code Skills

Skills are reusable prompts that extend Claude Code. The pipeline runs
`/grill-with-docs` → `/to-prd` → `/to-issues`, narrowing from open questions to a
set of lanes you drive yourself — one cmux pane per worktree:

* **`/grill-with-docs`** — Interview-style session that stress-tests a plan against the project's domain model. Prioritizes *pre-fan-out* decisions — the ones two isolated workers would otherwise answer differently. Updates `docs/CONTEXT.md` and `docs/adr/` inline as decisions crystallize. HITL by construction; never delegated.
* **`/to-prd`** — Synthesizes context into a PRD at `specs/PRD-{name}.md`: what to build, why, the frozen interfaces at each module seam, and **the worktree plan** the work divides across.
* **`/to-issues`** — Breaks the PRD into issues, each assigned to exactly one worktree and writing only that worktree's files. Prefers vertical slices, but the worktree boundary wins when they conflict. Verifies the split is write-disjoint and hands you the per-lane launch commands.
* **`/improve-codebase-architecture`** — Surfaces deepening opportunities: refactors that turn shallow modules into deep ones.
* **`/dotfiles`** — Manages dotfiles with chezmoi. Handles adding files, committing, and syncing.

The two invariants the pipeline exists to protect: **no two worktrees write the same
file**, and **no lane starts against an unresolved interface.** Violating the first
guarantees a hand-merge; violating the second guarantees a rewrite.

Execution is manual on purpose. cmux is the control plane — one pane per worktree,
running `claude` or `codex` as the lane calls for — and VS Code is the review
surface you open against whichever worktree needs your attention. No skill spawns
agents on your behalf.

## Structure

* `dot_zshrc` — Shell config (Oh My Zsh, Powerlevel10k, aliases)
* `dot_bashrc` / `dot_bash_profile` — Bash config, kept in step with `dot_zshrc`
* `dot_tmux.conf` — Tmux (**Ctrl+Space** prefix, vi copy mode, mouse on, TPM plugins)
* `dot_gitconfig` / `dot_gitignore_global` — Git user config and global ignores
* `dot_p10k.zsh` — Powerlevel10k prompt theme
* `dot_config/brew/Brewfile` — Master list of Homebrew formulae and casks
* `dot_config/nvim/` — Neovim configuration (lazy.nvim, Catppuccin, Telescope)
* `dot_config/ghostty/` — Ghostty terminal config
* `dot_config/iterm2/` — iTerm2 preferences plist
* `dot_config/cmux/` — cmux settings (editor, Claude Code integration)
* `dot_claude/` — Claude Code global instructions, skills, and config
* `dot_local/bin/ralph` — Autonomous Claude loop driven by a local `PRD.md`
* `Library/LaunchAgents/` — Caps Lock → Control remap
* `.chezmoidata.toml` — Volta package list consumed by the install scripts
* `run_once_*.sh` — Once per machine: macOS defaults, dark mode, Caps Lock remap
* `run_after_*.sh` — Every apply, guarded and idempotent: oh-my-zsh, p10k, TPM. Deliberately not `run_once_`, which chezmoi marks done even when the script fails, so one flaky clone would strand them forever.
* `run_onchange_*.sh.tmpl` — On manifest change: Homebrew packages, Volta packages

### VS Code

VS Code config is **deliberately not in this repo.** Its own Settings Sync (GitHub account) owns `settings.json`, `keybindings.json`, and the extension list. Tracking them here as well would double-own the same three files, and whichever system wrote last would win. Change VS Code settings in VS Code.

### Machine-specific behaviour

Handled by probing, not by branching on the host:

* `dot_gitconfig.tmpl` adds the Meta internal endpoints only when the x509 cert exists.
* `dot_zshrc` aliases `claude` / `codex` to `/usr/local/bin` only when a centrally managed copy is there, and defines `dc` only when the `dev` CLI is present.