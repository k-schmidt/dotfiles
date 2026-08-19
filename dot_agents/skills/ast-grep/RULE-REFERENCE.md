# ast-grep Rule Reference

Rule syntax for `ast-grep scan`. Read this when a bare `pattern` cannot express the query.

- [Rule object](#rule-object)
- [Atomic rules](#atomic-rules)
- [Relational rules](#relational-rules)
- [Composite rules](#composite-rules)
- [Metavariables](#metavariables)
- [Worked examples](#worked-examples)

## Rule object

A rule is YAML. Every field is optional, but at least one positive field (`pattern`, `kind`, `nthChild`, `range`) must be present — `regex` and `not` alone do not constitute a rule. Fields within one object are combined with an implicit AND.

```yaml
id: rule-name
language: python
rule:
  kind: call
  has: { pattern: await $EXPR, stopBy: end }
```

| Field | Category | Purpose |
| --- | --- | --- |
| `pattern` | atomic | Match by code shape |
| `kind` | atomic | Match by Tree-sitter node kind |
| `regex` | atomic | Match the node's text (Rust regex) |
| `nthChild` | atomic | Match by index among a parent's named children |
| `range` | atomic | Match by line and column span |
| `inside` | relational | Node sits within a match of the sub-rule |
| `has` | relational | Node contains a match of the sub-rule |
| `precedes` / `follows` | relational | Node appears before / after a match |
| `all` / `any` / `not` | composite | AND / OR / NOT over sub-rules |
| `matches` | composite | Reference a named utility rule |

When a sub-rule depends on a metavariable bound by an earlier sub-rule, wrap them in `all` — it is the only construct that guarantees evaluation order.

## Atomic rules

### pattern

The string form takes code with metavariables: `pattern: console.log($ARG)`.

The object form disambiguates fragments that do not parse on their own. `context` supplies surrounding code, `selector` names the part of the parsed context to match against, and `strictness` (`cst`, `smart`, `ast`, `relaxed`, `signature`) loosens how much of the tree must correspond.

```yaml
pattern:
  context: class X { $FIELD = $VALUE }
  selector: field_definition
```

### kind

Matches a Tree-sitter node kind: `kind: function_declaration`. Kind names are grammar-specific and vary between languages for equivalent concepts — verify with `--debug-query=cst` rather than guessing.

### regex

Matches the node's full text against a Rust regex. Not a positive field, so pair it with `kind` or `pattern`.

### nthChild

Matches by 1-based position among named siblings. Accepts a number, an `An+B` string such as `2n+1`, or an object with `position`, `reverse: true` to count from the end, and `ofRule` to filter the sibling list before counting.

### range

Matches an exact span: `start` and `end`, each with 0-based `line` and `column`. `start` is inclusive, `end` exclusive. Useful for scripted edits against known coordinates, rarely for search.

## Relational rules

`inside` and `has` are the workhorses. Both accept `stopBy` and `field`; `precedes` and `follows` accept only `stopBy`.

**`stopBy` decides how far the search travels.** The default, `neighbor`, stops at the first non-matching node — it will miss anything nested. `end` searches to the root for `inside` and to the leaves for `has`. A rule object stops at the first surrounding node the rule matches, inclusively.

Default to `stopBy: end` and narrow only when a shallow match is what the query actually means.

```yaml
rule:
  pattern: console.log($$$)
  inside:
    kind: method_definition
    stopBy: end
```

**`field`** restricts the relation to a named field of the node, e.g. the `operator` field of a binary expression. Available on `inside` and `has` only.

## Composite rules

`all` takes a list and requires every entry to match, in order. `any` requires one. `not` takes a single sub-rule and inverts it.

```yaml
rule:
  all:
    - kind: function_declaration
    - has: { pattern: await $EXPR, stopBy: end }
    - not:
        has: { pattern: "try { $$$ } catch ($E) { $$$ }", stopBy: end }
```

`matches: rule-id` references a utility rule defined under `utils`, which enables reuse and recursion.

## Metavariables

| Form | Captures |
| --- | --- |
| `$VAR` | one named node |
| `$$VAR` | one unnamed node — operators, punctuation, keywords |
| `$$$VAR` | zero or more nodes, non-greedy |
| `$_VAR` | matches without capturing; repeated uses may differ |

Names must be uppercase, digits, or underscore: `$META` and `$META_VAR` are valid; `$invalid`, `$123`, and `$KEBAB-CASE` are not. Reusing a name constrains equality — `$A == $A` matches `a == a` but not `a == b`.

The binding text must be the whole content of one AST node. These do not work: `obj.on$EVENT`, `"Hello $WORLD"`, `a $OP b`, `$jq`. For the operator in `a + b`, capture the field instead:

```yaml
rule:
  kind: binary_expression
  has: { field: operator, pattern: $$OP }
```

## Worked examples

Functions that await without handling failure:

```yaml
rule:
  all:
    - kind: function_declaration
    - has: { pattern: await $EXPR, stopBy: end }
    - not:
        has: { pattern: "try { $$$ } catch ($E) { $$$ }", stopBy: end }
```

Any console method, as one rule:

```yaml
rule:
  any:
    - pattern: console.log($$$)
    - pattern: console.warn($$$)
    - pattern: console.error($$$)
```

Calls that appear only inside a class body:

```yaml
rule:
  pattern: self.$METHOD($$$ARGS)
  inside: { kind: class_definition, stopBy: end }
```

## When a rule does not match

1. Dump the tree with `--debug-query=cst` and read the actual kind names.
2. Add `stopBy: end` to every relational rule.
3. Confirm each metavariable occupies a whole node.
4. Check the rule's `language` matches the files being scanned.
5. Split a complex rule into `all` entries and remove them one at a time until it matches, to find the failing clause.
