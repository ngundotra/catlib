# Agent notes for Catlib

This file records project-specific guidance for agents working in this repo.

## Formalization design rules

These are derived from Lean Zulip discussions about theorem statements, API
design, naming, abstraction, and library conventions.

1. Do not default to a giant existential or conjunction-heavy theorem statement
   if the real artifact should be a reusable object. Prefer:
   - a definition for the stable concept
   - separate lemmas for its properties
   - a final theorem only when a bundled existence statement is genuinely the
     right public interface

2. Model concepts according to how they are actually used in downstream code.
   If the API wants predicate-style use, prefer predicates. If the API wants a
   reusable structure or function, prefer that. Do not preserve an awkward
   representation just because it was first.

3. Distinguish clearly between:
   - hidden assumptions in the source text
   - modeling choices made by Catlib
   Every substantial formalization should make this distinction explicit.

4. Do not keep duplicate formalizations merely because they tell the same story
   in different rhetorical ways. If two lines of reasoning matter, they should
   normally differ by:
   - generalization
   - abstraction boundary
   - axiom choice
   - or theorem interface

5. When you see two nearby notions, decide deliberately whether both deserve
   first-class API or whether one should be canonical with bridge lemmas.
   Relevant Catlib examples:
   - doctrine vs discipline
   - claim vs formal object
   - communion vs beatifying communion
   - article phrasing vs Lean-facing ontology

6. Abstract only when the repeated pattern is stable and real. Avoid speculative
   grand-unified abstractions that erase useful theological specifics or make
   proofs harder to use.

7. Prefer idiomatic Lean/formal-library structure over overly literal surface
   translation, but do not weaken the substance of the claim silently. If a
   translation choice changes the shape of the statement, say so.

8. Keep file-local scaffolding local. Helper definitions that are not reusable
   should not be exported as if they were part of the project ontology.

9. Treat naming, docstrings, visibility, and reviewability as part of the
   formalization itself. "Compiles" is not a sufficient quality bar.

10. Before broad refactors or naming sweeps, put the rule into docs first.
    Local cleanup without an explicit convention tends to create drift.

11. Generalize when it yields genuine reusable structure. Do not generalize only
    for elegance. But do not assume the narrower version is enough merely
    because it fits the current article.

## Useful reference threads

- Looking for feedback on a theorem statement
  https://leanprover-community.github.io/archive/stream/287929-mathlib4/topic/Looking.20for.20feedback.20on.20a.20theorem.20statement.html
- Presieve: set or predicate?
  https://leanprover-community.github.io/archive/stream/287929-mathlib4/topic/Presieve.3A.20set.20or.20predicate.3F.html
- How much redundancy should Mathlib have?
  https://leanprover-community.github.io/archive/stream/287929-mathlib4/topic/How.20much.20redundancy.20should.20Mathlib.20have.3F.html
- Stating theorems in terms of degree vs natDegree
  https://leanprover-community.github.io/archive/stream/287929-mathlib4/topic/Stating.20theorems.20in.20terms.20of.20degree.20vs.20natDegree.html
- Naming conventions for `Prop`-valued defs and classes
  https://leanprover-community.github.io/archive/stream/287929-mathlib4/topic/Naming.20conventions.20for.20.60Prop.60-valued.20defs.20and.20classes.html
- Abstracting the substructure lattice construction
  https://leanprover-community.github.io/archive/stream/287929-mathlib4/topic/Abstracting.20the.20substructure.20lattice.20construction.html
- Mathlib: the Missing Manuals
  https://leanprover-community.github.io/archive/stream/287929-mathlib4/topic/Mathlib.3A.20the.20Missing.20Manuals.html
- How many lines for mathematical meaningless generalizations
  https://leanprover-community.github.io/archive/stream/287929-mathlib4/topic/How.20many.20lines.20for.20mathematical.20meaningless.20generalizations.html

For a more narrative summary, see the private notes file
`specs/lean-zulip-formalization-notes.md`.
