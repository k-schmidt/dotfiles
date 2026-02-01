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
    * ASK: "Shall I generate the `PRD.md` for Ralph?"

5.  **Handoff (Post-Approval):**
    * **Safety Check:**
        * Check if `PRD.md` exists in the project root.
        * If it exists, check for unchecked tasks (`[ ]`).
        * **CRITICAL:** If unchecked tasks exist, STOP. Ask the user: *"Active PRD detected. Do you want to (A)ppend these new tasks or (O)verwrite?"*
    
    * **File Generation:**
        * If (O)verwrite or new file: Create `PRD.md` with the "Ralph Execution Plan" checkboxes.
        * If (A)ppend: Add a newline and `### Phase [X]: [Feature Name]` to `PRD.md`, then append the new checkboxes.
    
    * **Confirmation:**
        * Inform the user: "PRD generated. Run `ralph` to execute."