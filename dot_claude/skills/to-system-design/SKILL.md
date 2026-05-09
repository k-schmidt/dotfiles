---
name: to-system-design
description: Generate a system design document with architecture diagrams from a PRD or conversation context. Produces Mermaid diagrams and structured markdown expanding on a PRD's Technical Decisions. Use when user says 'to-system-design', 'system design', 'architecture diagram', or wants to visualize how components interact before breaking into tasks.
---

# To System Design

Generate a system design document with architecture diagrams. This is an optional expansion of a PRD's Technical Decisions section — invoke it when the system is complex enough that bullet points aren't sufficient and diagrams would clarify how the pieces fit together.

## Input

One of:
1. **PRD** — a `specs/PRD-*.md` file or GSD task with PRD content
2. **Conversation context** — if invoked after a grill session or discussion
3. **Standalone prompt** — "design a system that does X"

If a PRD exists, read it for requirements and technical decisions. Reference those decisions; don't restate them.

## Process

### 1. Gather requirements

From the PRD or context, extract:
- Functional requirements (what the system does)
- Non-functional requirements (scale, performance, latency)
- Existing systems it integrates with
- Constraints (team size, timeline, tech stack)

If context is insufficient to produce a meaningful design, say what's missing and suggest running `/grill` or `/to-prd` first. Do NOT interrogate — this skill synthesizes, it doesn't interview.

### 2. Identify components

Break the system into logical components:
- Services / modules
- Data stores
- External dependencies
- Async workers / queues
- Caches

Aim for 3-8 components. If you have more, consider whether you're decomposing below the abstraction level useful at this stage — group related pieces into a single component with a note about internal structure.

### 3. Checkpoint with the user

Present a bullet-point summary:
- Components identified
- Key interactions between them
- Which optional sections (see below) you plan to include and why

**One confirmation only.** Once approved, generate the full document immediately.

### 4. Generate the system design document

Using the template in [SYSTEM-DESIGN-TEMPLATE.md](./SYSTEM-DESIGN-TEMPLATE.md), produce:

**Always included:**
- **Component Diagram** (Mermaid `flowchart TD`) — all components and their relationships
- **Key Flows** (Mermaid `sequenceDiagram`) — the 2-3 most critical flows from the PRD's user stories

**Included when relevant:**
- **Data Flow Diagram** — when data moves through multiple stages or transforms
- **API Contracts** — when the system exposes or consumes APIs
- **Trade-off Analysis** — when the PRD's Technical Decisions captured real alternatives worth expanding on
- **Failure Modes** — when the system has distributed components or external dependencies
- **Scalability Notes** — when the PRD mentions scale or performance requirements

Use the project's domain vocabulary from `docs/CONTEXT.md` throughout. If the PRD introduced terms in its Technical Decisions, carry those forward into diagram labels and section headings.

### 5. Write the document

1. **Safety check:** Check if `specs/SYSTEM-DESIGN-*.md` files already exist. If they do, list them and ask whether to overwrite or use a different name.
2. Write to `specs/SYSTEM-DESIGN-{feature-name}.md`. Create the `specs/` directory if needed.
3. Cross-link to the PRD: include `**PRD:** [PRD-{feature-name}](./PRD-{feature-name}.md)` in the header.

### 6. Update the PRD

If a PRD file exists (`specs/PRD-{feature-name}.md`), append a reference to the system design under a `## Related Documents` section (create it if it doesn't exist):

```md
## Related Documents

- [SYSTEM-DESIGN-{feature-name}](./SYSTEM-DESIGN-{feature-name}.md)
```

If other references already exist in that section, add to the list rather than replacing.

### 7. GSD integration

If inside Meta's codebase and a GSD parent task exists for the PRD, update the PRD task description to append the system design content below the existing PRD content. This keeps the full context in the task where people read it.

### 8. Suggest next steps

- "Run `/to-issues` to break this into implementation tasks"

## Diagram guidelines

- Use `flowchart TD` for component and data flow diagrams
- Use `sequenceDiagram` for interaction flows
- Use meaningful node IDs (no spaces)
- Quote labels with special characters
- Use `subgraph` to group related components
- Use domain terms from `docs/CONTEXT.md` as node labels, not generic names

## Rules

- **Do NOT interrogate.** One checkpoint, then generate.
- **Do NOT duplicate the PRD.** Reference decisions, don't restate them.
- **Be opinionated.** Recommend trade-offs, don't just list options.
- **No file paths or code snippets.** Describe modules abstractly.
- **Keep it practical.** Focus on what an engineer needs to start implementing.
- **Omit irrelevant sections.** Only include optional sections that add value for this specific system.
