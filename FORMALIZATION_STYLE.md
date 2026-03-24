# Catlib Formalization Style

This document records the current style rules for formalizing in Catlib.

It is not meant to capture every possible good idea. It is meant to keep the
repo coherent as it grows.

The main principle is simple:

> Formalization quality is decided mostly before the proof script starts.

The biggest decisions are:
- what exactly to formalize
- how to represent it
- what should be reusable API
- what should stay local scaffolding
- what is a hidden assumption in the source text
- what is a modeling choice made by Catlib

## 1. Start with the real claim

Before writing Lean, state plainly:
- what exact claim from the Catechism or tradition is being formalized
- what would count as a weaker proxy
- whether you are formalizing the claim itself or a model of the claim

Rules:
- Do not silently weaken the claim because the weaker version is easier.
- If you formalize a proxy, label it as a modeling choice.
- If the source text is underdetermined, say so early.

Bad:
- Formalizing a nearby theorem and acting as if it is the same doctrine.

Good:
- "The source claim is X. We encode it as Y because Lean needs explicit Z."

## 2. Distinguish hidden assumptions from modeling choices

Every substantial formalization should say which parts are:
- hidden assumptions in the source text
- modeling choices introduced by Catlib

This distinction matters because they are not the same kind of discovery.

Examples:
- A hidden assumption is something the source text needs but does not say.
- A modeling choice is a representation decision we made because the text does
  not uniquely determine the formal object.

Rules:
- Do not present a Catlib modeling choice as if the Catechism itself explicitly
  taught it.
- Do not downplay a genuine hidden assumption as if it were merely a convenient
  encoding choice.

## 3. Prefer reusable objects plus API over giant witness bundles

If the real downstream artifact is a stable concept, define that concept first.

Often the right pattern is:
1. define the object
2. prove its core properties
3. add bridge lemmas
4. only then add a bundled existence theorem if it is still useful

Rules:
- Do not default to existential/conjunction-heavy theorem statements as the
  main interface.
- A giant witness theorem is acceptable as an internal lemma.
- It is often a poor public interface.

Good candidates for this pattern:
- structured doctrinal states
- recurring forms of authority
- sacramental categories
- comparison objects across denominations

## 4. Let representation follow actual use

Choose the representation that matches how the concept is really used.

Rules:
- If the API wants predicate-style use, prefer predicates.
- If the API wants a stable reusable object, prefer a structure or definition.
- Do not preserve an awkward representation just because it came first.

Ask:
- Are users proving things by membership?
- Are users projecting fields?
- Are users rewriting through a bridge?
- Are we constantly converting between two views?

If the code repeatedly fights the representation, the representation is probably
wrong.

## 5. Build shared concepts in shared places

If a concept is likely to be reused, put it in the shared layer.

Rules:
- Shared theological vocabulary belongs in `Foundations` or a stable shared
  doctrine layer.
- Local proof scaffolding stays local.
- Do not hide a reusable concept inside one doctrine file if several future
  files will need it.

Heuristic:
- If two or more formalizations need the same distinction, that distinction
  probably deserves a shared home.

## 6. Keep scaffolding local

Not every helper theorem should become part of Catlib's public ontology.

Rules:
- File-local helper lemmas should stay local where possible.
- Do not export convenience lemmas just because they helped one proof.
- Public names create maintenance cost and imply project-level endorsement.

Ask before exporting:
- Will another doctrine naturally depend on this?
- Would the article layer or a query system care about it?
- Or is it just proof plumbing?

## 7. Be deliberate about duplicated API

Duplication is not automatically bad.

Sometimes two user-facing formulations are both worth keeping because they make
downstream formalization much easier. But duplication should be justified.

Rules:
- Do not keep duplicate theorems just because they tell the same story
  rhetorically.
- Do allow parallel API when it materially improves user workflow.
- Always identify a preferred canonical formulation when possible.

Ask:
- Does this second interface save real work?
- Is the bridge between the two forms trivial and stable?
- Will users naturally think in both forms?

## 8. Abstract only when the repeated pattern is real

Catlib should not race toward a grand unified framework for all theology.

Rules:
- Abstract when several files share a stable repeated pattern.
- Do not abstract speculative similarities.
- Prefer smaller abstractions over one giant clever one.

Warning signs of premature abstraction:
- the abstraction erases useful doctrinal specifics
- the abstraction makes theorem statements harder to read
- the abstraction exists before there are several real consumers

## 9. Be conservative with `@[simp]`

In a mature Lean library, `@[simp]` does not mean "helpful rewrite".
It means "part of the library's canonical simplification behavior."

Rules:
- Do not mark a theorem `@[simp]` just because it shortens one proof.
- Use `@[simp]` for stable structural normal forms and predictable cleanup.
- Most doctrinal equivalences should not be simp lemmas by default.

Ask:
- Is this the rewrite direction we want everywhere?
- Will this create surprising or lossy rewrites?
- Is this structural normalization or just convenience?

## 10. Naming should follow explicit conventions

Naming churn is expensive.

Rules:
- Do not do broad renaming without a documented rule.
- Do not bundle rename sweeps into unrelated conceptual PRs.
- Respect established patterns unless there is a strong reason to change them.

Before renaming:
- state the naming rule
- explain why the old name is actually misleading
- identify whether deprecations are needed

## 11. Generalize for reuse, not elegance

Generalization is good when it produces real reusable structure.
It is bad when it only makes the file look clever.

Rules:
- Generalize when the broader statement has likely future users.
- Do not generalize only because the abstract version is prettier.
- Do not assume the narrow article-facing version is automatically enough.

Ask:
- What concrete future formalization benefits from this generality?
- Does the generalized version expose a real shared pattern?
- Or are we paying complexity now for hypothetical beauty later?

## 12. Treat docs and readability as part of correctness

A formalization is not done when it merely compiles.

Rules:
- Important definitions should have docstrings or nearby explanation.
- The file should make its modeling decisions legible.
- Reviewability matters.
- A theorem that is technically true but misleadingly named is not high quality.

## 13. Suggested workflow for a new formalization

1. State the source claim in plain English.
2. Predict what the formalization will reveal.
3. List likely hidden assumptions.
4. List likely Catlib modeling choices.
5. Decide what the reusable objects are.
6. Decide what can stay opaque.
7. Choose the smallest reasonable shared abstractions.
8. Prove the core result.
9. Separate structural lemmas from substantive discoveries.
10. Write the finding clearly in prose.

## 14. Questions to ask in review

When reviewing a Catlib formalization, ask:

1. Did we formalize the real claim or a proxy?
2. Are hidden assumptions and modeling choices clearly separated?
3. Is the main interface easy to use downstream?
4. Did we choose the right representation?
5. Is any exported API actually reusable?
6. Is there unjustified duplication?
7. Is there premature abstraction?
8. Did we misuse `@[simp]`?
9. Are names stable, honest, and in scope?
10. Does the writeup say what the proof actually found?

## 15. Current Catlib biases

These are not universal Lean laws. They are current project biases.

- Bias toward explicit ontology over rhetorical convenience.
- Bias toward reusable definitions over one-shot witness theorems.
- Bias toward small abstractions over sweeping frameworks.
- Bias toward honest labeling of modeling choices.
- Bias toward readable public API over maximal local cleverness.

## References

The main input behind these rules came from:
- Lean Zulip design threads
- mathlib PR review discussions
- mathlib contribution and naming guidance

Supporting internal notes:
- `specs/lean-zulip-formalization-notes.md`
- `specs/lean-input-sources.md`
- `specs/mathlib-pr-review-notes.md`
- `specs/mathlib-pr-review-next-pass.md`
