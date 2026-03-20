# CCC §1750–1756: The Sources of Morality

## The Catechism claim

The Catechism says the morality of human acts depends on three things:
the object chosen (what you do), the intention (why you do it), and the
circumstances. A good act requires all three to be good. It then claims
that some acts are "intrinsically evil" — always wrong regardless of
intention or circumstances (§1756).

## How we modeled it

- **MoralEvaluation**: A structure with three propositional fields
  (objectIsGood, intentionIsGood, circumstancesAppropriate)
- **isGood**: Conjunction of all three
- **isEvil**: Disjunction of their negations
- **IntrinsicallyEvil**: A predicate asserting the object is never good

## What we found

The three-source framework works cleanly for the general case: good
requires all three, evil requires any one to be bad. The proof that
"good ↔ not evil" is straightforward classical logic.

But the "intrinsically evil" claim (§1756) requires an additional
assumption: **the moral character of an action's object can be
evaluated independently of its circumstances.**

The three-source framework alone is compatible with a view where the
object's goodness depends on context. To get intrinsic evil, you need
to add: "the object has a fixed moral nature." This is the deontological
core of Catholic ethics, and the Catechism assumes it without stating it.

### Hidden assumptions

1. **Object independence**: The object of an act has a moral character
   that is independent of the agent's intention and circumstances.

### Catholic reading axioms

- [Definition] CCC §1750 — three sources of morality
- [Definition] CCC §1755 — goodness requires all three
- [Definition] CCC §1756 — intrinsically evil acts (+ hidden
  independence axiom)

### Prediction vs. reality

Predicted: would reveal hidden structure. Confirmed — the independence
axiom was the finding.

### Assessment

**Tier 3** — Hidden premise exposed. The proof assistant wouldn't let us
state "intrinsically evil" without committing to object independence.
