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

# Dotfiles (chezmoi)
- Always edit source files in `~/.local/share/chezmoi/`, never targets directly.
- Push after commit.
- **macOS (Apple Silicon) is the only supported target.** No `.chezmoi.os` conditionals, no `uname` guards. Still probe for optional things (`if [[ -d /opt/homebrew/bin ]]; then ... fi`) so an Intel Mac or a missing tool degrades quietly.
- PATH order: Homebrew > Volta > system. Homebrew block must appear after Volta in the file so it prepends last.
- Homebrew owns anything with a formula or cask; Volta owns npm-only tools. Never install the same tool through both — the Homebrew copy wins and silently shadows the newer one.
- **Do not track VS Code config in chezmoi.** VS Code Settings Sync owns `settings.json`, `keybindings.json`, and extensions. Adding them here double-owns the same files and last writer wins.