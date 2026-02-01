# Dotfile Manager (Chezmoi)

## Description
This skill helps the user manage their dotfiles using `chezmoi`. It automates adding configuration files, applying changes, and syncing the dotfile repository with Git.

## Triggers
- "Save this config"
- "Update my dotfiles"
- "Sync my settings"
- "Add [file] to chezmoi"

## Procedure
1. **Analyze Request:** Determine if the user wants to *add* a local file to chezmoi or *apply* changes from the repo to the local system.

2. **Add & Sync (If user edited a local file):**
   - Check if the file is already managed: `chezmoi managed [filename]`.
   - If not managed or needs updating: `chezmoi add [filename]`.
   - Navigate to the source directory: `cd $(chezmoi source-path)`.
   - Commit the change: `git add . && git commit -m "chore: update [filename] settings"`.
   - Push to remote: `git push`.
   - Return to original directory.

3. **Apply (If user wants to pull changes):**
   - Pull latest: `chezmoi git pull`.
   - Apply changes: `chezmoi apply`.

## Safety Rules
- NEVER overwrite a file without running `chezmoi diff` first to show the user what will change.
- If a secret or private key is detected, stop and ask for confirmation before pushing to Git.