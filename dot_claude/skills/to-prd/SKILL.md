---
name: to-prd
description: Turn the current conversation context into a file-based PRD. Use when user wants to create a PRD from the current context, write a spec, or document requirements for handoff.
---

This skill takes the current conversation context and codebase understanding and produces a PRD. Do NOT interview the user — just synthesize what you already know. Never use the AskUserQuestion tool.

## Process

1. Explore the repo to understand the current state of the codebase, if you haven't already. Use the project's domain glossary vocabulary from `docs/CONTEXT.md` throughout the PRD, and respect any ADRs in `docs/adr/`.

2. Sketch out the major modules you will need to build or modify to complete the implementation. Actively look for opportunities to extract deep modules that can be tested in isolation.

   A deep module (as opposed to a shallow module) is one which encapsulates a lot of functionality in a simple, testable interface which rarely changes.

   Check with the user that these modules match their expectations. Check with the user which modules they want tests written for.

3. Write the PRD using the template in [PRD-TEMPLATE.md](./PRD-TEMPLATE.md).

4. **Safety check:** Before writing, check if `specs/PRD-*.md` files already exist. If they do, list them and ask whether to overwrite or use a different name.

5. Write the PRD to `specs/PRD-{feature-name}.md` in the current project. Create the `specs/` directory if it doesn't exist.

6. **If inside Meta's codebase**, also create a GSD parent task:
   - Title: `PRD: {feature-name}`
   - Description: The full PRD content (markdown)
   - Tags: `prd`, `commitClose`
   - Use the `/tasks` skill to create the task
   - The `commitClose` tag means this task will auto-close when the attached diff lands

7. After writing, tell the user:
   - The file path of the PRD
   - The GSD task number and link (if created)
   - Suggest next step: run `/to-issues` to break it into vertical-slice implementation tasks (which will be nested under the GSD parent task if one was created)
