---
name: to-ui-spec
description: Generate a UI specification with navigation flows and screen definitions from a PRD or conversation context. Produces Mermaid state diagrams and structured markdown expanding on a PRD's user stories. Use when user says 'to-ui-spec', 'ui spec', 'wireframe', 'screen flow', or wants to define what the user sees before breaking into tasks.
---

# To UI Spec

Generate a UI specification with navigation flows and screen definitions. This is an optional expansion of a PRD's user stories — invoke it when the feature has enough screens or interaction complexity that the user stories alone don't make the UX clear.

## Input

One of:
1. **PRD** — a `specs/PRD-*.md` file or GSD task with PRD content
2. **Conversation context** — if invoked after a grill session or discussion
3. **Standalone prompt** — "spec the UI for X"

If a PRD exists, read it for user stories and technical decisions. Reference those; don't restate them.

## Process

### 1. Gather requirements

From the PRD or context, extract:
- User stories that imply distinct screens or views
- Navigation paths between screens
- Data displayed on each screen
- User actions and where they lead
- Edge cases (empty states, errors, permissions)

If context is insufficient to produce a meaningful spec, say what's missing and suggest running `/grill` or `/to-prd` first. Do NOT interrogate — this skill synthesizes, it doesn't interview.

### 2. Identify screens and navigation

Map out:
- Distinct screens the user will encounter
- How the user navigates between them (actions, links, back navigation)
- Entry points (where the user first lands)

### 3. Checkpoint with the user

Present a bullet-point summary:
- Screens identified
- Navigation flow between them
- Whether a Shared Patterns section is needed

**One confirmation only.** Once approved, generate the full document immediately.

### 4. Generate the UI spec document

Using the template in [UI-SPEC-TEMPLATE.md](./UI-SPEC-TEMPLATE.md), produce:

**Always included:**
- **Navigation Flow** (Mermaid `stateDiagram-v2`) — screen-to-screen transitions triggered by user actions
- **Screen Definitions** — one section per screen covering purpose, layout, content, actions, and states

**Included when relevant:**
- **Shared Patterns** — when multiple screens reuse the same layout pattern (e.g., a common card layout, a standard list item format)

Stay technology-agnostic. Use generic terms — "screen", "list", "input field", "modal", "toast notification". The UI spec describes what the user experiences, not how it's built.

Use the project's domain vocabulary from `docs/CONTEXT.md` throughout. If the PRD introduced terms, carry those forward into screen names and content descriptions.

### 5. Write the document

1. **Safety check:** Check if `specs/UI-SPEC-*.md` files already exist. If they do, list them and ask whether to overwrite or use a different name.
2. Write to `specs/UI-SPEC-{feature-name}.md`. Create the `specs/` directory if needed.
3. Cross-link to the PRD: include `**PRD:** [PRD-{feature-name}](./PRD-{feature-name}.md)` in the header.

### 6. Update the PRD

If a PRD file exists (`specs/PRD-{feature-name}.md`), append a reference to the UI spec under a `## Related Documents` section (create it if it doesn't exist):

```md
## Related Documents

- [UI-SPEC-{feature-name}](./UI-SPEC-{feature-name}.md)
```

If other references already exist in that section, add to the list rather than replacing.

### 7. GSD integration

If inside Meta's codebase and a GSD parent task exists for the PRD, update the PRD task description to append the UI spec content below the existing PRD content. This keeps the full context in the task where people read it.

### 8. Suggest next steps

- "Run `/to-issues` to break this into implementation tasks"

## Rules

- **Do NOT interrogate.** One checkpoint, then generate.
- **Do NOT duplicate the PRD.** Reference user stories, don't restate them.
- **Stay abstract.** No framework-specific terms, component names, or CSS.
- **Be opinionated.** Recommend layout approaches, don't just list options.
- **Cover all states.** Every screen must address loading, empty, error, and success. If a state is trivial, say "standard error toast" — don't omit it.
- **Keep it practical.** Focus on what an engineer needs to build the screen without guessing at the UX.
- **Omit Shared Patterns** unless multiple screens genuinely reuse the same layout.
