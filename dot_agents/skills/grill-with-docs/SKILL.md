---
name: grill-with-docs
description: Grilling session that challenges your plan against the existing domain model, sharpens terminology, and updates persistent documentation under docs/ inline as decisions crystallise. Use when user wants to stress-test a plan against their project's language and documented decisions.
---

<what-to-do>

Interview me relentlessly about every aspect of this plan until we reach a shared understanding. Walk down each branch of the design tree, resolving dependencies between decisions one-by-one. For each question, provide your recommended answer.

Ask questions directly in the conversation, one at a time, and wait for feedback before continuing. Keep each question open-ended rather than presenting a structured multiple-choice form.

If a question can be answered by exploring the codebase, explore the codebase instead.

This session is **HITL by construction** — its value is a human answering one question at a time. Never delegate the interview. Run it in the primary task with the user before implementation tasks are created.

</what-to-do>

<supporting-info>

## Domain awareness

During codebase exploration, also look for existing documentation:

### File structure

Most repos have a single context:

```
/
├── docs/
│   ├── CONTEXT.md
│   └── adr/
│       ├── 0001-event-sourced-orders.md
│       └── 0002-postgres-for-write-model.md
└── src/
```

If `docs/CONTEXT-MAP.md` exists, the repo has multiple contexts. The map points to where each one lives:

```
/
├── docs/
│   ├── CONTEXT-MAP.md
│   └── adr/                          ← system-wide decisions
├── src/
│   ├── ordering/
│   │   └── docs/
│   │       ├── CONTEXT.md
│   │       └── adr/                  ← context-specific decisions
│   └── billing/
│       └── docs/
│           ├── CONTEXT.md
│           └── adr/
```

Create files lazily — only when you have something to write. If no applicable `docs/CONTEXT.md` exists, create one when the first term is resolved. If no applicable `docs/adr/` exists, create it when the first ADR is needed.

## During the session

### Challenge against the glossary

When the user uses a term that conflicts with the existing language in the applicable `docs/CONTEXT.md`, call it out immediately. "Your glossary defines 'cancellation' as X, but you seem to mean Y — which is it?"

### Sharpen fuzzy language

When the user uses vague or overloaded terms, propose a precise canonical term. "You're saying 'account' — do you mean the Customer or the User? Those are different things."

### Discuss concrete scenarios

When domain relationships are being discussed, stress-test them with specific scenarios. Invent scenarios that probe edge cases and force the user to be precise about the boundaries between concepts.

### Cross-reference with code

When the user states how something works, check whether the code agrees. If you find a contradiction, surface it: "Your code cancels entire Orders, but you just said partial cancellation is possible — which is right?"

### Update docs/CONTEXT.md inline

When a term is resolved, update the applicable `docs/CONTEXT.md` right there. Don't batch these up — capture them as they happen. Use the format in [CONTEXT-FORMAT.md](./CONTEXT-FORMAT.md).

`docs/CONTEXT.md` should be totally devoid of implementation details. Do not treat it as a spec, a scratch pad, or a repository for implementation decisions. It is a glossary and nothing else.

### Prioritise the decisions that must be settled before the work divides

This plan is likely headed for `$to-prd` and `$to-tasks`, where separate Codex tasks may implement it in parallel. That changes which open questions are urgent.

A decision is **pre-fan-out** if two workers who never speak to each other would each have to answer it, and could answer it differently. Those are the expensive ones — not because they are hard, but because the cost of getting them wrong is discovered at merge time, when both sides are already built. Chase them first:

- **Shared vocabulary.** Two workers naming the same concept differently produces two half-right glossaries and an API that reads like it was designed by strangers.
- **Interfaces at the seams.** Any signature, event shape, payload, or table column that one module exposes and another consumes.
- **Ownership of shared surfaces.** Schema, migration ordering, root config, generated files, lockfiles. Who writes them, and who merely reads them.
- **Error and edge-case semantics that cross a seam.** What a caller receives on failure is part of the contract, not an implementation detail.

Everything else — naming inside a module, local structure, test organisation — is safely deferrable to whichever worker owns it. Do not spend the user's attention on decisions a single worker can make alone and reverse cheaply.

When you resolve a pre-fan-out decision, note it as one. `$to-prd` needs to list it under **Frozen Interfaces**, and a contract that was settled here but not written down there gets re-litigated by every worker independently.

### Offer ADRs sparingly

Only offer to create an ADR when all three are true:

1. **Hard to reverse** — the cost of changing your mind later is meaningful
2. **Surprising without context** — a future reader will wonder "why did they do it this way?"
3. **The result of a real trade-off** — there were genuine alternatives and you picked one for specific reasons

If any of the three is missing, skip the ADR. Use the format in [ADR-FORMAT.md](./ADR-FORMAT.md).

### Wrap up

When the grilling is complete, summarise the **pre-fan-out decisions** you settled — the shared vocabulary, interfaces at the seams, and ownership of shared surfaces — separately from the rest. That list is the raw material for the PRD's Frozen Interfaces and Task Plan sections.

Then offer to hand off to `$to-prd`, which captures the refined plan and its task boundaries. Do not offer to implement changes from this skill.

If any pre-fan-out decision is still unresolved when the session ends, name it plainly. `$to-prd` marks it UNRESOLVED and blocks the work that depends on it; a guessed contract gets built twice, incompatibly.

</supporting-info>
