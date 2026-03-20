# Findings Tracker

## Completed (12/12 — all Tier 3)

### Moral Theology (7)

| # | Passage | Key Finding | Lean File |
|---|---------|-------------|-----------|
| 1 | §1750–1756 Sources of Morality | Object independence axiom — "intrinsically evil" needs an unstated rule that actions have fixed moral natures | `MoralTheology/SourcesOfMorality.lean` |
| 2 | §1849–1864 Sin | Binary ontology — 5 binary assumptions (knowledge, consent, gravity, grace, sin→grace causation) | `MoralTheology/Sin.lean` |
| 6 | §1954–1957 Natural Law | Rational convergence — disagreement is always a failure of reason; divine grounding tension | `MoralTheology/NaturalLaw.lean` |
| 7 | §1776–1791 Conscience | Culpability asymmetry — acting against conscience categorically worse than following an erring one | `MoralTheology/Conscience.lean` |
| 10 | §1730–1738 Freedom | Perfect freedom paradox — the freest being cannot sin; teleological vs. liberal freedom | `MoralTheology/Freedom.lean` |
| 11 | §2263–2267 Legitimate Defense | Epistemic gap — proportionality assumes accurate threat assessment; 2 of 4 double-effect conditions invisible | `MoralTheology/LegitimateDefense.lean` |
| 12 | §1987–1993 Justification | Axiom-set-as-denomination — Catholic vs. Protestant = 4-axis axiom difference | `MoralTheology/Justification.lean` |

### Creed (5)

| # | Passage | Key Finding | Lean File |
|---|---------|-------------|-----------|
| 3 | §1033+1037 Hell | Libertarian free will required — "self-exclusion" needs genuine alternatives; love-requires-freedom unstated | `Creed/Hell.lean` |
| 4 | §2001–2002 Grace | Bootstrapping problem — you need grace to get grace; resolution requires typed grace hierarchy | `Creed/Grace.lean` |
| 5 | §253–255 Trinity | Non-standard logic — requires relative identity; "same God" ≠ "same person" | `Creed/Trinity.lean` |
| 8 | §302–311 Providence | Good/evil causation asymmetry — God operates through good, only permits evil; privation theory invisible | `Creed/Providence.lean` |
| 9 | §355–365 Soul | Hylomorphism — soul as "form" is Aristotelian; incompatible with common-sense dualism | `Creed/Soul.lean` |

## Patterns across findings

1. **Binary assumptions are everywhere.** The Catechism repeatedly assumes binary distinctions (mortal/venial, full/partial knowledge, in grace/not) where spectra are possible.

2. **The Catechism compresses centuries of debate.** Grace bootstrapping (Pelagian controversy), justification (Reformation), conscience (Aquinas's quaestiones) — each compressed into a few paragraphs with the hard parts invisible.

3. **Philosophical frameworks are adopted without naming.** Hylomorphism, libertarian free will, relative identity, moral realism, Platonic realism about moral laws — all assumed, none announced.

4. **The axiom set IS the denomination.** The justification finding confirmed this most clearly, but it's visible throughout: change the axioms, change the theology.

5. **The proofs are always trivial; the models are always interesting.** Every theorem was easy to prove. The work — and the finding — was always in the modeling choices.

## Future targets (not yet formalized)

| § | Claim | Expected outcome |
|---|-------|-----------------|
| §198–231 | Attributes of God (omnipotence, omniscience, simplicity) | Hidden structure — divine simplicity may resist formalization productively |
| §232–260 | Trinity (extended) — processions, missions | Extends Trinity formalization with relational details |
| §1210–1211 | Seven sacraments — validity conditions | Structural claims about what makes a sacrament valid |
| §2514–2533 | Purity of heart / concupiscence | May reveal assumptions about human nature and desire |
