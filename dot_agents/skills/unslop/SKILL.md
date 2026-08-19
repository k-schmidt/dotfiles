---
name: unslop
description: Remove AI writing patterns from human-facing prose. Use for READMEs, guides, blog posts, essays, release notes, announcements, commit messages, and pull request bodies. Triggers on "unslop", "humanize", "make this sound human", "clean up this writing", "edit for voice", "de-AI this text". Skips agent-facing text such as AGENTS.md, skills, prompts, ADRs, PRDs, docstrings, and code comments.
---

# Unslop

Edit human-facing prose so it reads like a person wrote it. Two gates run before any edit, and both get stated out loud so the user can override them.

## Gate 1: who reads this

Classify the primary reader first.

**Agent-facing, so skip.** `AGENTS.md`, `CLAUDE.md`, `SKILL.md`, prompt templates, ADRs, PRDs, task briefs, issue specs, docstrings, code comments, frontmatter, and fenced code. Imperative density, bold label lists, and terse fragments are correct in instruction text. Say which file was skipped and why, then stop. If the user names the file and asks anyway, edit it.

**Human-facing, so edit.** README narrative, guides and tutorials written for people, blog posts, essays, announcements, release notes, changelog entries, commit messages, and pull request descriptions.

**Mixed files.** A README is narrative wrapped around reference material. Edit the narrative. Leave installation commands, configuration tables, flag lists, API references, and label lists of the form `- **Editor:** VS Code and Neovim` alone. That shape is reference, not a sentence in disguise.

## Gate 2: which register

Register controls voice, never pattern removal. Every pattern below gets stripped in both.

**Technical.** README, guide, changelog, release notes, commit message, pull request body. Plain and direct. No first person unless it was already there, no manufactured opinion, no rhetorical flourish. The floor is clarity, not personality.

**Personal.** Blog post, essay, announcement, anything with a byline. Strip the patterns, then add voice as described under [Adding voice](#adding-voice).

## Process

1. State the classification in one line: file, audience, register, and what is out of scope inside it.
2. Run the scan for the deterministic floor:

   ```bash
   ~/.agents/skills/unslop/scan.sh path/to/file.md
   ```

   It excludes code, frontmatter, inline code, URLs, and link targets on its own. Rules ending in `?` are candidates that need a reading, not verdicts. Pipe text on stdin when there is no file.
3. Read the text for what the scan cannot see: significance inflation, notability name-dropping, formulaic challenge framing, forced rules of three, synonym cycling, false ranges, generic conclusions, and uniform sentence rhythm.
4. Rewrite the file in place. Return the rewritten text instead when the input was pasted, or when the file is untracked and outside a repository.
5. Self-audit the result. Ask what still marks it as generated, and fix what turns up.
6. Report what changed, grouped by pattern, with counts.

## Authority and limits

Restructure, re-punctuate, merge, split, and cut empty words freely. The skeleton is not sacred.

Every factual claim survives the edit in some form. Cutting a claim is a content decision, so it belongs to the user. An unsourced attribution gets flagged for them to source or drop, never deleted quietly.

Never touch fenced or indented code, inline code spans, frontmatter, URLs, link targets, file paths, identifiers, command output, license text, or anything quoted from another person. Changing someone else's words inside quotation marks is a fabrication, not an edit.

Do not pad to a length or trim to one. Do not commit, push, or open a pull request. Stop at edited files and a report.

## Adding voice

Personal register only. Removing patterns is half the job, because voiceless prose is its own tell.

- Have opinions. React to a fact instead of listing its pros and cons.
- Vary rhythm. Short sentences. Then longer ones that take their time.
- Acknowledge complexity. "Impressive and slightly unsettling" beats "impressive."
- Use "I" where it fits. First person is not unprofessional.
- Let some mess in. Perfectly parallel structure reads as generated.
- Be specific. Not "this is concerning" but "there is something unsettling about agents grinding away at 3am."

## Patterns

### Content

1. **Significance inflation.** "pivotal moment", "a testament to", "evolving landscape", "setting the stage for", "indelible mark", "deeply rooted". Cut the puffery and state what happened.
2. **Notability name-dropping.** Outlets or logos listed without context. Pick one and say what it actually said.
3. **Superficial participles.** Trailing "highlighting...", "ensuring...", "reflecting...", "showcasing...", "fostering...". Delete, or replace with the fact the clause was standing in for.
4. **Promotional language.** "nestled", "vibrant", "breathtaking", "groundbreaking", "renowned", "stunning", "must-visit". Describe neutrally.
5. **Vague attribution.** "Experts believe", "Industry reports suggest", "Some critics argue". Name the source, or flag it for the user.
6. **Formulaic challenge framing.** "Despite challenges, X continues to thrive." Replace with specific facts.

### Language

7. **AI vocabulary.** additionally, crucial, delve, enduring, enhance, fostering, garner, interplay, intricate, landscape as an abstraction, pivotal, showcase, tapestry as an abstraction, testament, underscore, vibrant. Use plain words.
8. **Copula avoidance.** "serves as", "stands as", "boasts", "is home to". Say "is" or "has".
9. **Negative parallelism.** "It is not just X, it is Y." State the point once.
10. **Rule of three.** Ideas forced into threes. Use the number the material actually has.
11. **Synonym cycling.** protagonist, main character, central figure, hero in one paragraph. Pick one and repeat it.
12. **False ranges.** "from X to Y" where X and Y sit on no shared scale. List the items.

### Style

13. **Em dashes.** Banned as a mid-sentence connector or dramatic pause, where a period, comma, or pair of parentheses does the job better. Allowed once as the separator in a list item, which is this repository's house style: `- **Term** — what it means`. Never two in one sentence.
14. **Mid-sentence colons.** A colon before a list or an example is fine. As a connector it is a crutch: it borrows tension the sentence has not earned. Rewrite so the point stands on its own.
15. **Boldface overuse.** Do not bold every proper noun, acronym, or key term. Three bold spans in a line is a signal that none of them matter.
16. **Inline-header lists.** "**Performance:** Performance improved because..." is a paragraph wearing a label. Convert to prose. A short label list of reference values is not this and stays.
17. **Title case headings.** Use sentence case.
18. **Decorative emoji.** Remove from headings, bullets, and callouts.
19. **Curly quotes and typographic dashes.** Replace with straight quotes and plain hyphens.

### Communication artifacts

20. **Chatbot phrases.** "I hope this helps", "Let me know if", "Feel free to", "Of course", "Certainly". Remove.
21. **Cutoff disclaimers.** "While specific details are limited", "As of my last update". Find the fact or cut the sentence.
22. **Sycophancy.** "Great question", "You're absolutely right". Answer without the compliment.

### Filler

23. **Filler phrases.** "in order to" becomes "to". "due to the fact that" becomes "because". "It is important to note that" gets deleted whole.
24. **Stacked hedges.** "could potentially possibly be argued that it might" becomes "may". One hedge at most.
25. **Generic conclusions.** "The future looks bright." State a specific plan, a number, or nothing.

## Report

Close with the classification, then the counts, then anything left for the user:

```text
README.md, human-facing, technical register. Install block and flag table untouched.

  vocab          7   leveraging, robust, seamless, comprehensive
  em-dash        3   connectors rewritten as periods
  inflation      2   era framing removed
  filler         4
  colon          1

Flagged, not changed:
  line 42  "industry reports suggest" has no source
```
