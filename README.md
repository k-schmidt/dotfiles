# Dotfiles

macOS developer environment managed with **chezmoi**. Optimized for software engineering, data infrastructure, AI engineering, and a Codex-centered workflow.

> Apple Silicon macOS is the only supported target. Machine-specific behavior is handled through capability probes rather than OS branches.

## Stack

- **Core:** zsh, chezmoi, Homebrew
- **Primary agent:** Codex in the ChatGPT desktop app
- **Agent fallbacks:** Codex CLI in cmux; Claude Code when explicitly needed
- **Review:** Codex desktop first, VS Code for visual inspection
- **Terminal:** cmux, Ghostty, iTerm2, tmux, Powerlevel10k, fzf, zoxide
- **Editor:** VS Code and Neovim
- **Python:** uv
- **Infrastructure:** OrbStack, direnv, gh, difftastic, lazygit
- **Productivity:** Raycast, Obsidian, Todoist, KeepingYouAwake

## Installation

1. Install Xcode Command Line Tools:

   ```bash
   xcode-select --install
   ```

2. Bootstrap and apply:

   ```bash
   sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply k-schmidt
   ```

3. Sign in to the ChatGPT desktop app, then authenticate terminal tools as needed:

   ```bash
   gh auth login
   codex login
   claude auth login
   ```

4. Configure Touch ID for `sudo` if desired:

   ```bash
   sudo sed -i '' '2i\auth       sufficient     pam_tid.so' /etc/pam.d/sudo
   ```

## Workflow

Codex desktop is the control plane. A **task** owns one coherent outcome; a **managed worktree** provides isolation when implementation should not touch the local checkout. Use Codex handoff to move a task between its worktree and the local checkout.

cmux remains available for terminal-first Codex CLI sessions. Its Codex hooks provide lifecycle state, notifications, and session restoration. VS Code is the fallback review surface for diffs that benefit from a full editor. Claude remains an explicit fallback: cmux keeps its native Claude wrapper for those sessions, but no shell alias or launcher makes Claude the default.

Implementation tasks stop at a tested, review-ready diff. Commit, push, and pull-request creation happen only after explicit approval.

### Planning skills

Personal skills live in `~/.agents/skills` and are shared with Claude through a compatibility link. The planning pipeline narrows decisions before work is divided:

`$grill-with-docs` → `$to-prd` → `$to-tasks`

- **`$grill-with-docs`** challenges terminology, cross-module decisions, interfaces, and ownership one question at a time.
- **`$to-prd`** captures the agreed problem, solution, success criteria, technical decisions, and testing policy.
- **`$to-tasks`** proposes write-disjoint HITL/AFK Codex tasks, freezes their shared contracts, and creates them only after approval.
- **`$improve-codebase-architecture`** finds refactors that turn shallow modules into deep, testable interfaces.
- **`$update-docs`** reconciles implemented behavior with project documentation.

Planning, artifact-generation, handoff, and documentation-reconciliation skills are explicit actions; invoke them by name. Engineering disciplines that should protect ordinary work can be selected automatically:

- **`$diagnosing-bugs`** establishes a tight reproduction, tests falsifiable hypotheses, and stops at root cause unless a fix was requested.
- **`$review-before-publish`** reviews correctness, repository standards, and specification fidelity across committed and uncommitted changes without crossing the publish boundary.
- **`$dotfiles`** manages chezmoi source, application, and synchronization.

## Editing

Always edit source files rather than deployed targets:

```bash
chezmoi edit ~/.zshrc
chezmoi apply
```

To add a Homebrew package:

```bash
chezmoi edit ~/.config/brew/Brewfile
chezmoi apply
```

Publishing remains explicit:

```bash
cd ~/.local/share/chezmoi
git add .
git commit -m "feat: description"
git push
```

## Ownership

- `dot_codex/AGENTS.md` — portable global guidance loaded by Codex
- `AGENTS.md` — repository-only chezmoi rules; excluded from deployment
- `dot_agents/skills/` — canonical personal skill source shared across agents
- `dot_claude/` — minimal Claude fallback import and settings
- `dot_config/brew/Brewfile` — Homebrew formula and cask manifest
- `dot_config/cmux/` — cmux editor and agent-integration settings
- `dot_zshrc`, `dot_bashrc`, `dot_bash_profile` — shell configuration
- `dot_config/nvim/` — Neovim configuration
- `run_onchange_*.sh.tmpl` — idempotent package and integration reconciliation

Codex desktop owns `~/.codex/config.toml`, authentication, plugins, MCP servers, project trust, hooks state, and runtime databases. VS Code Settings Sync owns VS Code settings, keybindings, and extensions. Neither mutable surface is tracked here.

## Optional capabilities

- Optional tools are activated only when their executable or directory exists.
