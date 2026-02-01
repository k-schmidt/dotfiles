# User Context
- **User**: Kyle (Tech Lead, Data Engineering Manager @ Meta).
- **Focus**: Infrastructure, Capacity Planning, AI Engineering (Agents/Evals), System Design.
- **Aesthetic**: Minimalist, clean, functional (Code should reflect "Japandi" simplicity: strict types, no clutter).

# Core Principles
1. **Architectural First**: Always analyze the broader system impact before writing code.
2. **Type Safety**: Python must use `pydantic` and `typeguard`. TypeScript is preferred over JavaScript.
3. **Observability**: AI components must be instrumented (logs/traces) for evaluation.
4. **Tool Awareness**: Be aware this environment uses `chezmoi` for dotfiles, `uv` for Python, and `Raycast` for scripting.

# Tech Stack & Standards

## Python (Primary)
- **Version**: 3.10+
- **Style**: Black formatter, Ruff linter, Google-style docstrings.
- **Data Engineering**:
    - Prefer `polars` over `pandas` for performance where possible.
    - Use `pydantic` for all data validation and schema definitions.
- **Testing**: `pytest` with `pytest-asyncio` for async agents.

## AI Engineering
- **Patterns**: Prefer "Agentic" workflows (LangGraph/LangChain) over raw API calls.
- **Evals**: All prompts must be separated from logic (template files) to allow for evaluation.
- **Security**: Never hardcode API keys. Use environment variables.

## JavaScript / TypeScript
- **Runtime**: Node.js (LTS).
- **Style**: Prettier, ESLint (Airbnb config).
- **Structure**: Functional components, distinct separation of concerns (API vs. UI).

## Productivity Tools
- **Obsidian**: Markdown output should be Obsidian-friendly (use `[[WikiLinks]]` if referencing knowledge base concepts).
- **Raycast**: If asked to write a script, prefer a Raycast Script Command (Bash/Python) with proper metadata headers.

# Common Commands & Workflows

## Python
- **Install/Sync**: `uv sync` or `poetry install`
- **Test**: `pytest -v --durations=5` (Show slow tests)
- **Lint**: `ruff check . --fix`
- **Format**: `ruff format .`

## JavaScript
- **Install**: `npm ci` (clean install)
- **Dev**: `npm run dev`
- **Build**: `npm run build`

## Git Workflow
- **Commit Style**: Conventional Commits (`feat:`, `fix:`, `chore:`).
- **Pre-Commit**: Always run `pre-commit run --all-files` before finalizing.

# Plan Mode Protocols
*Trigger: When tasks involve >2 files or architectural changes.*
1. **Explore**: Map dependencies and potential side effects.
2. **Propose**: detailed bullet points of changes.
3. **Critique**: Self-correct for "Over-engineering" or "Security risks".
4. **Execute**: Implement iteratively.