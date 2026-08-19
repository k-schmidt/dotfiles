---
name: ast-grep
description: Structural code search and rewriting with `ast-grep`. Use when code shape or the relationship between syntax elements matters rather than literal text — finding call sites by argument shape, locating constructs that lack a required sibling or ancestor, auditing a pattern across a codebase, or applying a mechanical refactor. Use `rg` instead when a name, string, or path is the whole query.
---

# ast-grep

Search and rewrite code by syntax tree rather than by text. `rg` answers "where does this name appear." `ast-grep` answers "where does this shape appear," which is the real question behind most audits and mechanical refactors.

## When it earns its cost

Reach for `ast-grep` when the query names a relationship between syntax elements: a call with a particular argument shape, a function containing one construct but not another, a node in a specific position, or a rename whose arity or argument structure changes. Regex cannot express containment, and a regex that appears to work will silently miss multi-line and nested occurrences without reporting a gap.

Stay with `rg` when a name, string, path, or comment is the whole query. `ast-grep` costs a rule-authoring round trip; do not pay it for a lookup.

## Confirm the tool is present

`ast-grep` is optional tooling, not a guaranteed capability. Check `command -v ast-grep` before planning around it. When it is absent, install it with `brew install ast-grep` if that is in scope, and otherwise fall back to `rg` while stating plainly which part of the query the fallback cannot answer — containment, nesting, and arity are exactly what regex loses. Never let a structural question quietly become a textual one; a silent downgrade returns a confident undercount.

## Build the rule incrementally

1. Write one snippet the rule must match and one closely related snippet it must not. The negative case is what proves the rule is actually structural.
2. Start with `pattern`. Escalate to `kind` plus `has`, `inside`, or `not` only when a pattern alone cannot express the relationship.
3. Test against both snippets through `--stdin` before touching the repository.
4. Run against the codebase once the rule separates the two snippets correctly.
5. Report matches as evidence. A rewrite is a code change and stops at a reviewable diff.

```bash
echo 'async function f() { await fetch(); }' | ast-grep scan --stdin --inline-rules 'id: await-without-try
language: javascript
rule:
  kind: function_declaration
  has: { pattern: await $EXPR, stopBy: end }
  not:
    has: { pattern: "try { $$$ } catch ($E) { $$$ }", stopBy: end }'
```

## Gotchas that cost the most time

**Set `stopBy: end` on every relational rule.** `has` and `inside` default to `stopBy: neighbor`, which stops at the first non-matching node instead of traversing the subtree. The rule then matches only the shallowest cases and reports a clean, wrong, low count. This is the most common cause of a false negative.

**Quote inline rules so the shell leaves metavariables alone.** `$EXPR` is a shell variable. Single-quote the whole rule, or escape as `\$EXPR` inside double quotes.

**A metavariable must be the entire text of one AST node.** `obj.on$EVENT`, `"Hello $WORLD"`, `a $OP b`, and `$jq` all fail to parse as captures. Use `$$OP` for unnamed nodes such as operators and punctuation, and `$$$ARGS` for zero or more nodes.

**Confirm the node kind rather than guessing it.** Kind names come from each language's Tree-sitter grammar and differ across languages for the same concept. Dump the tree before writing a `kind` rule:

```bash
ast-grep run --pattern 'your code here' --lang python --debug-query=cst
```

`cst` shows every node, `ast` only named nodes, and `pattern` shows how `ast-grep` parsed the pattern itself.

## Rewriting

Preview first, apply second. `ast-grep run` prints a diff by default; `--update-all` writes it and `--interactive` steps through each hunk.

```bash
ast-grep run --lang typescript --pattern 'foo($A, $B)' --rewrite 'foo({ a: $A, b: $B })' src/
```

A rewrite across many files is a wide mechanical change. Confirm the match set is exactly what was intended before applying, keep the change to one owner's files, and hand back a tested, review-ready diff rather than a commit.

## Reference

Full rule syntax — atomic, relational, and composite rules, plus metavariable semantics — is in [RULE-REFERENCE.md](./RULE-REFERENCE.md). Read it when a `pattern` alone is insufficient. Run `ast-grep --help` for current CLI flags.
