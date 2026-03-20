# CCC §1849–1864: Sin

## The Catechism claim

Sin is an offense against reason and truth (§1849). It comes in two kinds:
mortal and venial. Mortal sin requires three things simultaneously: grave
matter, full knowledge, and complete consent (§1859). Everything else is
venial. Mortal sin causes loss of sanctifying grace (§1861).

## How we modeled it

- **MoralKnowledge**: Binary enum — full or not-full
- **MoralConsent**: Binary enum — complete or incomplete
- **MatterGravity**: Binary enum — grave or less serious
- **GraceState**: Binary enum — in grace or not in grace
- **SinfulAct**: Structure combining action with knowledge, consent, gravity
- **isMortal**: Conjunction of all three being at their "full" value
- **isVenial**: Disjunction of any being at their "not-full" value
- **mortal_sin_causes_loss_of_grace**: Axiom (not provable)

## What we found

### The binary ontology

To make the mortal/venial partition work, every relevant property must be
binary. The proof of `mortal_or_venial` (every sin is one or the other)
goes through by case analysis — but only because each enum has exactly
two values. If knowledge, consent, or gravity were modeled as a spectrum
(say, a real number between 0 and 1), you'd need an additional threshold
axiom to partition sins into exactly two categories.

The Catechism's binary framing isn't stated as an assumption — it's
embedded in the language ("full" vs. not, "complete" vs. not, "grave"
vs. "less serious"). The proof assistant forced us to make this choice
explicit.

### The causal axiom

The claim that mortal sin "causes" loss of grace (§1861) required a
bare axiom. The Catechism presents this causation as a fact, but it's
not derivable from anything else in the moral framework. It connects
a human act (sinning) to a divine state (grace) through an unspecified
mechanism. This is a major metaphysical commitment the text treats
as obvious.

### Hidden assumptions

1. **Knowledge is binary** — full or not-full, no spectrum
2. **Consent is binary** — complete or not-complete, no spectrum
3. **Matter gravity is binary** — grave or less serious, no spectrum
4. **Grace state is binary** — present or absent, no spectrum
5. **Mortal sin causally removes grace** — brute axiom, no mechanism

### Catholic reading axioms

- [Definition] CCC §1849 — definition of sin
- [Definition] CCC §1857 — conditions for mortal sin
- [Definition] CCC §1862 — definition of venial sin
- [Tradition] CCC §1861 — mortal sin causes loss of grace (axiom)

### Prediction vs. reality

Predicted: would require stronger premises. Confirmed — five hidden
binary assumptions plus a causal axiom.

### Assessment

**Tier 3** — Multiple hidden premises exposed. The binary ontology
finding was anticipated; the causal axiom connecting sin to grace
was a genuine surprise.
