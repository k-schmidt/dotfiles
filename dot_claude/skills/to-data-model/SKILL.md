---
name: to-data-model
description: Generate a data model document with ER diagrams from a PRD or conversation context. Produces Mermaid ER diagrams and structured markdown expanding on a PRD's schema decisions. Use when user says 'to-data-model', 'data model', 'schema design', 'entity relationship', or wants to define the data shape before breaking into tasks.
---

# To Data Model

Generate a data model document with ER diagrams and entity definitions. This is an optional expansion of a PRD's Technical Decisions section — invoke it when the data shape is complex enough that a bullet point about "schema changes" isn't sufficient.

## Input

One of:
1. **PRD** — a `specs/PRD-*.md` file or GSD task with PRD content
2. **Conversation context** — if invoked after a grill session or discussion
3. **Standalone prompt** — "model the data for X"

If a PRD exists, read it for requirements and technical decisions. Reference those decisions; don't restate them.

## Process

### 1. Gather requirements

From the PRD or context, extract:
- What entities the system manages
- Relationships between them (ownership, association, hierarchy)
- Access patterns implied by user stories (filtering, sorting, aggregation)
- Whether this modifies existing entities or is greenfield
- Scale expectations if stated

If context is insufficient to produce a meaningful model, say what's missing and suggest running `/grill` or `/to-prd` first. Do NOT interrogate — this skill synthesizes, it doesn't interview.

### 2. Identify entities and relationships

Map out:
- Entities and their key attributes
- Relationship cardinality (one-to-one, one-to-many, many-to-many)
- Ownership and lifecycle dependencies (cascade deletes, orphan rules)

### 3. Checkpoint with the user

Present a bullet-point summary:
- Entities identified
- Key relationships between them
- Which optional sections (see below) you plan to include and why

**One confirmation only.** Once approved, generate the full document immediately.

### 4. Generate the data model document

Using the template in [DATA-MODEL-TEMPLATE.md](./DATA-MODEL-TEMPLATE.md), produce:

**Always included:**
- **ER Diagram** (Mermaid `erDiagram`) — entities, key attributes, and relationship cardinality
- **Entity Definitions** (markdown tables) — full attribute lists with types, constraints, nullable/default

**Included when relevant:**
- **Access Patterns** — when the PRD implies non-trivial query needs (filtering, sorting, aggregation)
- **Indexes** — when access patterns warrant them
- **Migration Strategy** — when existing entities are being modified (not for greenfield)
- **Denormalization / Derived Data** — when performance requirements suggest pre-computed or duplicated data

Use abstract types (`string`, `integer`, `timestamp`, `boolean`, `json`) — not dialect-specific types. Note the intended storage system if the PRD or context specifies one, but don't lock into a specific dialect.

Use the project's domain vocabulary from `docs/CONTEXT.md` throughout. If the PRD introduced terms in its Technical Decisions, carry those forward into entity and attribute names.

### 5. Write the document

1. **Safety check:** Check if `specs/DATA-MODEL-*.md` files already exist. If they do, list them and ask whether to overwrite or use a different name.
2. Write to `specs/DATA-MODEL-{feature-name}.md`. Create the `specs/` directory if needed.
3. Cross-link to the PRD: include `**PRD:** [PRD-{feature-name}](./PRD-{feature-name}.md)` in the header.

### 6. Update the PRD

If a PRD file exists (`specs/PRD-{feature-name}.md`), append a reference to the data model under a `## Related Documents` section (create it if it doesn't exist):

```md
## Related Documents

- [DATA-MODEL-{feature-name}](./DATA-MODEL-{feature-name}.md)
```

If other references already exist in that section, add to the list rather than replacing.

### 7. GSD integration

If inside Meta's codebase and a GSD parent task exists for the PRD, update the PRD task description to append the data model content below the existing PRD content. This keeps the full context in the task where people read it.

### 8. Suggest next steps

- "Run `/to-issues` to break this into implementation tasks"

## Rules

- **Do NOT interrogate.** One checkpoint, then generate.
- **Do NOT duplicate the PRD.** Reference decisions, don't restate them.
- **Stay abstract.** Use generic types, not SQL dialect-specific types.
- **Be opinionated.** Recommend index strategies and denormalization choices, don't just list options.
- **No file paths or code snippets.** Describe the data shape, not the implementation.
- **Keep it practical.** Focus on what an engineer needs to write the migration and queries.
- **Omit irrelevant sections.** Only include optional sections that add value for this specific model.
