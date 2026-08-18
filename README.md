# Dotfiles

macOS developer environment managed with **chezmoi**. Optimized for AI Engineering, Data Infrastructure, and high-performance workflows.

> macOS is the only supported target. Every config assumes Homebrew, `pbcopy`, and a local display; there are no `.chezmoi.os` conditionals or `uname` guards left in the tree.

## The Stack

* **Core:** `zsh`, `chezmoi`, `homebrew`
* **Editor:** [Cursor](https://cursor.sh) (AI-native) & VS Code & Neovim
* **Terminal:** iTerm2 with [Powerlevel10k](https://github.com/romkatv/powerlevel10k), `tmux`, `fzf`, `ripgrep`
* **Python:** `uv` (Blazing fast package management)
* **AI Agents:** `claude-code`, `codex`, `cmux`
* **Infra:** `orbstack` (Docker replacement), `direnv`, `gh`, `difftastic`
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

Skills are reusable prompts that extend Claude Code. Pipeline: `/grill-with-docs` → `/to-prd` → `/to-issues`.

* **`/grill-with-docs`** — Interview-style session that stress-tests a plan against the project's domain model. Updates `docs/CONTEXT.md` and `docs/adr/` inline as decisions crystallize.
* **`/to-prd`** — Synthesizes conversation context into a file-based PRD at `specs/PRD-{name}.md`. Captures what to build and why.
* **`/to-issues`** — Breaks a PRD into tracer-bullet vertical slices. Each issue cuts end-to-end through all layers.
* **`/improve-codebase-architecture`** — Surfaces deepening opportunities: refactors that turn shallow modules into deep ones.
* **`/dotfiles`** — Manages dotfiles with chezmoi. Handles adding files, committing, and syncing.

## Structure

* `dot_zshrc` — Shell config (Oh My Zsh, Powerlevel10k, aliases)
* `dot_bashrc` / `dot_bash_profile` — Bash config, kept in step with `dot_zshrc`
* `dot_tmux.conf` — Tmux (Ctrl-a prefix, mouse mode, TPM plugins)
* `dot_gitconfig` / `dot_gitignore_global` — Git user config and global ignores
* `dot_p10k.zsh` — Powerlevel10k prompt theme
* `dot_config/brew/Brewfile` — Master list of Homebrew formulae and casks
* `dot_config/nvim/` — Neovim configuration (lazy.nvim, Catppuccin, Telescope)
* `dot_config/iterm2/` — iTerm2 preferences plist
* `dot_config/cmux/` — cmux settings (editor, Claude Code integration)
* `dot_claude/` — Claude Code global instructions, skills, and config
* `run_once_*.sh` — One-time setup scripts (zsh plugins, TPM, macOS defaults)

### VS Code

VS Code config is **deliberately not in this repo.** Its own Settings Sync (GitHub account) owns `settings.json`, `keybindings.json`, and the extension list. Tracking them here as well would double-own the same three files, and whichever system wrote last would win. Change VS Code settings in VS Code.

### Machine-specific behaviour

Handled by probing, not by branching on the host:

* `dot_gitconfig.tmpl` adds the Meta internal endpoints only when the x509 cert exists.
* `dot_zshrc` aliases `claude` / `codex` to `/usr/local/bin` only when a centrally managed copy is there, and defines `dc` only when the `dev` CLI is present.