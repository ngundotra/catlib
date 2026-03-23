# Catlib Lean Style Guide

## Naming

All declarations use `snake_case`. No exceptions.

| Declaration kind | Example | Notes |
|-----------------|---------|-------|
| `axiom` | `axiom grace_is_transformative` | Never SCREAMING_CASE |
| `theorem` | `theorem sin_separates_from_s5` | |
| `def` | `def heaven_state` | |
| `structure` | `structure SoulState` | PascalCase for types |
| `inductive` | `inductive GraceType` | PascalCase for types |
| `opaque` (types) | `opaque HumanPerson : Type` | PascalCase for types |
| `opaque` (predicates) | `opaque hasOriginalSin : HumanPerson -> Prop` | camelCase for predicates |
| Fields | `sustained : Prop` | snake_case |

**Types** (structure, inductive, opaque types) use `PascalCase`.
**Opaque predicates and functions** use `camelCase` (e.g., `inCommunion`, `graceGiven`, `hasOriginalSin`).
**Everything else** (axioms, theorems, defs, fields) uses `snake_case`.

This follows Lean 4 / Mathlib conventions.

## Base axiom prefixes

The 14 base axioms in `Axioms.lean` use a prefix indicating provenance:

- `p2_`, `p3_` — Philosophical axioms (Aristotle/Aquinas)
- `s1_` through `s9_` — Scriptural axioms (with verse references)
- `t1_`, `t2_`, `t3_` — Tradition axioms (Council references)

## Docstrings

Every `axiom` and `theorem` must have a `/-- ... -/` docstring containing:

- **What it says** (1-2 sentence description)
- **Source**: CCC paragraph, Scripture reference, or Council
- **Denominational scope**: Ecumenical, Catholic, Lutheran, etc.
- **CONNECTION TO BASE AXIOM** (if applicable): which of the 14 base axioms this derives from or instantiates
- **HIDDEN ASSUMPTION** (if applicable): unstated premises the formalization reveals

## File structure

```
/-! Module docstring: what this file formalizes, predictions, findings -/

namespace Catlib.Category.FileName

-- § 1. Core Types
-- § 2. Axioms (with docstrings)
-- § 3. Theorems (with proofs from axioms, not hypotheses)
-- § 4. Bridge theorems (connecting to base axioms)
-- § 5. Denominational tags

end Catlib.Category.FileName
```

## Proof style

- **Derive from axioms, not hypotheses.** If an axiom exists for a fact, use it in the proof rather than taking the fact as a hypothesis. A theorem with zero hypotheses that chains through axioms is more valuable than one that takes its conclusions as assumptions.
- **No vacuous axioms.** An axiom whose body is `True` or `claim -> claim` does no logical work. Either give it real content or delete it.
- **No sorry.** If a proof can't be completed, leave it as an axiom with a docstring explaining why.

## Definitions vs axioms vs opaques

- **`def`**: Use when the concept has a computable definition (e.g., `def heaven_state : SoulState := ...`)
- **`axiom`**: Use for claims that are asserted without proof — doctrinal commitments, scriptural claims, philosophical premises
- **`opaque`**: Use for vocabulary — types and predicates whose internal structure is deliberately hidden (e.g., `opaque inCommunion : CommunionParty -> CommunionParty -> Prop`). Opaque types use PascalCase; opaque predicates/functions use camelCase
- **`structure`/`inductive`**: Use when the internal structure IS the definition (e.g., `structure Grace where ...`)
