---
name: dotfiles
description: Manage dotfiles with `chezmoi` — add local config files to the source repo, apply changes from the repo to the local system, and sync via Git. Use when the user says "save this config", "update my dotfiles", "sync my settings", "add [file] to chezmoi", or edits a config file they want tracked.
---

# Dotfile Manager (Chezmoi)

Manage dotfiles through chezmoi while preserving ownership boundaries and the user's review-before-publish policy.

## Procedure
1. **Analyze Request:** Determine if the user wants to *add* a local file to chezmoi or *apply* changes from the repo to the local system.

2. **Capture a local change:**
   - Check if the file is already managed: `chezmoi managed [filename]`.
   - Inspect `chezmoi diff` before importing it.
   - If approved, add or refresh it with `chezmoi add [filename]`.

3. **Apply an approved source change:**
   - Pull latest: `chezmoi git pull`.
   - Preview with `chezmoi apply --dry-run --verbose`.
   - Apply changes: `chezmoi apply`.

4. **Publish only when explicitly requested:**
   - Review `git diff` and run the repository's validation.
   - Commit with a Conventional Commit message.
   - Push the reviewed commit.

## Safety Rules
- Never overwrite or apply a target without previewing the change first.
- If a secret or private key is detected, stop and ask for confirmation before pushing to Git.
- Do not manage application-owned mutable state such as Codex `config.toml` or VS Code Settings Sync files.
