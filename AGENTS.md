# Dotfiles Repository

This repository is the source of truth for Kyle's macOS dotfiles. It is managed by chezmoi and supports Apple Silicon macOS only.

## Ownership

- Edit source files in this repository, never deployed targets directly.
- Stable Codex guidance and personal skills are managed here. Codex desktop owns `~/.codex/config.toml`, authentication, plugins, MCP servers, trusted projects, hooks state, and runtime databases.
- VS Code Settings Sync owns VS Code settings, keybindings, and extensions. Do not add them here.
- Personal skills live under `dot_agents/skills/`. Claude consumes the same tree through a compatibility link.
- Root `AGENTS.md` and `CLAUDE.md` are repository instructions and must remain excluded from home-directory deployment.

## Platform and packages

- macOS on Apple Silicon is the only supported target. Do not add OS conditionals or `uname` branches.
- Probe for optional or managed-machine capabilities at runtime so missing tools degrade quietly.
- Homebrew owns every tool with a formula or cask. Volta owns npm-only tools. Never install the same executable through both.
- PATH precedence is Homebrew, then Volta, then the system. The Homebrew block appears after the Volta block so it prepends last.
- Codex desktop and CLI are primary; Claude remains installed as an explicit fallback.

## Change rules

- Use `apply_patch` for intentional file edits and preserve unrelated changes.
- Package removal and target cleanup must be guarded, explicit, and idempotent.
- Do not run `chezmoi apply` when the user has requested review before live mutation. A dry run is safe and expected.
- Stop at a tested, review-ready diff. Commit and push only when explicitly requested; when publishing dotfiles, use a Conventional Commit and push the resulting commit.

## Verification

- Render changed templates with `chezmoi execute-template` or inspect them through `chezmoi apply --dry-run --verbose`.
- Parse shell files with the matching shell and validate generated JSON where applicable.
- Confirm `chezmoi managed` and `chezmoi source-path` reflect the intended ownership boundaries.
- Search for stale agent names, paths, skills, aliases, and package-manager references after workflow changes.
- Apply twice only during the approved live rollout; the second apply must be idempotent.
