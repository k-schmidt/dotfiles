# Deep Architect Workflow

## Description
A rigorous planning mode for complex features. It forces the creation of a persistent design document before coding begins.

## Triggers
- "Architect a solution for..."
- "Plan this feature..."
- "Deep plan for..."
- "Design the [X] module"

## Procedure

1.  **Context Audit:**
    * Scan the current directory for `README.md`, `TECH_STACK.md`, or existing file structure to understand conventions.

2.  **Drafting:**
    * Read the template at `~/.claude/skills/architect/TEMPLATE.md`.
    * Create a new file in the current repo: `specs/PLAN-[feature-name].md`.
    * Fill out the template based on the user's request.

3.  **The Critique (Self-Correction):**
    * *Internal Check:* Does this plan account for edge cases? Does it follow the project's existing style?
    * *Refinement:* Update the `specs/PLAN-[feature-name].md` file with improvements derived from the critique.

4.  **Presentation:**
    * Present the plan summary to the user.
    * **STOP.** detailed execution is forbidden until the user types "Approved".

5.  **Execution (Post-Approval):**
    * Once approved, execute the "Implementation Steps" from the plan one by one.
    * After every step, run the verification command listed in the plan.