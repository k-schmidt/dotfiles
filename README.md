# Dotfiles

Cross-platform developer environment (macOS + Linux devvms) managed with **chezmoi**. Optimized for AI Engineering, Data Infrastructure, and high-performance workflows.

## The Stack

* **Core:** `zsh`, `chezmoi`, `homebrew` (macOS), `fwdproxy` (Linux devvms)
* **Editor:** [Cursor](https://cursor.sh) (AI-native) & VS Code & Neovim
* **Terminal:** iTerm2 with [Powerlevel10k](https://github.com/romkatv/powerlevel10k), `tmux`, `fzf`, `ripgrep`
* **Python:** `uv` (Blazing fast package management)
* **AI Agents:** `claude-code`
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

### Linux Devvm

1. Clone and bootstrap (proxy required for GitHub access):
```bash
export http_proxy=http://fwdproxy:8080 https_proxy=http://fwdproxy:8080
git clone https://github.com/k-schmidt/dotfiles.git ~/dotfiles
cd ~/dotfiles && ./executable_chezmoi_install.sh
```

2. Symlink chezmoi source to the git repo:
```bash
rm -rf ~/.local/share/chezmoi
ln -s ~/dotfiles ~/.local/share/chezmoi
```

3. Future updates:
```bash
cd ~/dotfiles && git pull && ~/.local/bin/chezmoi apply
```

### Post-Install (macOS only)

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

### Adding a Brew package (macOS)

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
* `dot_bashrc` / `dot_bash_profile` — Bash config (auto-launches zsh, proxy detection for devvms)
* `dot_tmux.conf` — Tmux (Ctrl-a prefix, mouse mode, TPM plugins)
* `dot_gitconfig` / `dot_gitignore_global` — Git user config and global ignores
* `dot_p10k.zsh` — Powerlevel10k prompt theme
* `dot_config/brew/Brewfile` — Master list of Homebrew packages (macOS only)
* `dot_config/nvim/` — Neovim configuration (lazy.nvim, Catppuccin, Telescope)
* `dot_config/iterm2/` — iTerm2 preferences plist (macOS only)
* `dot_claude/` — Claude Code global instructions, skills, and config
* `run_once_*.sh` — One-time setup scripts (zsh plugins, TPM, macOS defaults)

### Cross-platform notes

macOS-only scripts (`set_macos_defaults.sh`, `activate_key_remapping.sh`) exit early on Linux. The `bash_profile` auto-detects Meta devvms and sets the GitHub proxy.