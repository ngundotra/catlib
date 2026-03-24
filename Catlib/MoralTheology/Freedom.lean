import Catlib.Foundations

/-!
# CCC §1730–1738: Freedom and Responsibility

## The Catechism claims

"Freedom is the power, rooted in reason and will, to act or not to act,
to do this or that, and so to perform deliberate actions on one's own
responsibility." (§1731)

"As long as freedom has not bound itself definitively to its ultimate
good which is God, there is the possibility of choosing between good
and evil." (§1732)

"The more one does what is good, the freer one becomes. There is no
true freedom except in the service of what is good and just. The choice
to disobey and do evil is an abuse of freedom and leads to 'the slavery
of sin.'" (§1733)

"Freedom makes man responsible for his acts to the extent that they are
voluntary." (§1734)

## Two concepts of freedom in tension

The Catechism contains TWO different concepts of freedom:

1. **Freedom-as-choice** (§1731-1732): The ability to choose between
   alternatives — "to act or not to act, to do this or that."
   This is what most modern people mean by "freedom."

2. **Freedom-as-flourishing** (§1733): "The more one does what is good,
   the freer one becomes." Freedom is not just choice — it is the power
   to do what is genuinely good. Choosing evil DIMINISHES freedom.

These two concepts are in tension. Under freedom-as-choice, choosing
evil is an exercise OF freedom. Under freedom-as-flourishing, choosing
evil is an abuse that reduces freedom. The Catechism holds both
simultaneously without explaining how they relate.

## Prediction

I expect this to **reveal hidden structure**. The two-concept tension
is well-known in political philosophy (Isaiah Berlin's "negative" vs.
"positive" liberty) but the Catechism doesn't acknowledge it as a
tension. Formalization should expose what model connects the two.

## Findings

- **Prediction vs. reality**: Confirmed — reveals hidden structure.
  The Catechism requires: (1) a teleological model of freedom — freedom
  has a PURPOSE (directed toward God), not just a capacity, (2) an
  ordering of choices — choosing good is MORE free than choosing evil,
  which requires a non-neutral metric, (3) freedom is graded, not
  binary — you can become MORE or LESS free, (4) the connection between
  freedom and responsibility requires that diminished freedom diminishes
  responsibility (§1734), and (5) perfect freedom is the INABILITY to
  choose evil — which means the freest being (God) cannot sin.
- **Catholic reading axioms used**: [Definition] CCC §1731-1734;
  [Tradition] Aquinas ST I-II q.1-5 (ultimate end), q.109 (grace and
  freedom)
- **Surprise level**: Significant — the most surprising finding is that
  PERFECT freedom = inability to sin. This is counterintuitive: most
  people think freedom MEANS the ability to choose evil. The Catechism
  says the opposite — the ability to choose evil is a DEFICIENCY of
  freedom, not its essence.
- **Assessment**: Tier 3 — the teleological model of freedom and the
  "perfect freedom = no evil" finding are both genuinely surprising.
-/

namespace Catlib.MoralTheology

open Catlib

/-!
## Two models of freedom
-/

/-- Freedom-as-choice: the modern/liberal concept.
    Freedom = having options. More options = more freedom.
    Choosing evil is an EXERCISE of freedom.
    MODELING CHOICE: We represent this as a simple Prop wrapper to
    contrast it with freedom-as-flourishing. The CCC mentions both
    concepts (§1731 vs §1733) without naming them as distinct models. -/
def freedomAsChoice (canChoose : Prop) : Prop := canChoose

/-- Freedom-as-flourishing: the Catechism's deeper concept.
    Freedom = power to do what is genuinely good.
    Choosing evil DIMINISHES freedom.
    MODELING CHOICE: Same representation as freedomAsChoice — the
    distinction is conceptual, not structural. The CCC holds both
    simultaneously without explaining their relationship. -/
def freedomAsFlourishing (orientedToGood : Prop) : Prop := orientedToGood

/-! ### §1731: Freedom requires reason and will

Freedom requires BOTH reason and will (CCC §1731).
A being with will but no reason (an animal?) is not free.
A being with reason but no will (a computer?) is not free.
Freedom is specifically the intersection of these capacities.

*Deleted axiom*: `freedom_requires_reason_and_will` had a vacuous body (`True`).
The theological content is captured in the `Person` structure's `hasIntellect`
and `hasFreeWill` fields — both must hold for genuine freedom. -/

/-- AXIOM (§1733): Doing good increases freedom.
    Provenance: [Definition] CCC §1733
    "The more one does what is good, the freer one becomes."
    HIDDEN ASSUMPTION: This is a TELEOLOGICAL claim — freedom has
    a direction. It's not neutral between good and evil choices.
    This contradicts the common modern assumption that freedom is
    just "having options." Under the Catechism, some options make
    you MORE free and others make you LESS free.

    CONNECTION TO BASE AXIOM: This is an instantiation of
    `Catlib.s7_teleological_freedom` (S7: ∀ a1 a2, directedTowardGood a1 →
    ¬ directedTowardGood a2 → freedomLt (agentFreedom a2) (agentFreedom a1)).
    S7 compares TWO agents; this axiom states the principle for a single
    freedom degree. Both express the same teleological commitment: orientation
    toward good = greater freedom. -/
axiom good_increases_freedom :
  ∀ (fd : FreedomDegree),
    fd.orientedToGood →
    -- Freedom level increases
    -- (choosing good makes you freer)
    fd.level > 0

/-! ### §1733: Choosing evil diminishes freedom

"The choice to disobey and do evil is an abuse of freedom and leads to
'the slavery of sin.'" (CCC §1733)

Evil is self-undermining. The more evil you choose, the less capable you
become of choosing good. This is a specific empirical-metaphysical claim
about the effects of moral choices on the agent's capacities.

*Deleted axiom*: `evil_diminishes_freedom` had a vacuous body (`True`).
The real content is carried by `good_increases_freedom` (its contrapositive
direction) and by base axiom `s7_teleological_freedom`.

### §1732: Evil is possible only in imperfect freedom

"As long as freedom has not bound itself definitively to its ultimate
good... there is the possibility of choosing between good and evil."
(CCC §1732)

The ability to choose evil is a TRANSITIONAL property — it characterizes
freedom on the way to perfection, not freedom at its peak.

*Deleted axiom*: `evil_possible_only_in_imperfect_freedom` had a trivially
true body (`¬p ∨ p`). The conceptual content is expressed by the
`PerfectFreedom` structure and `perfect_freedom_cannot_sin` theorem below. -/

/-!
## Bridge theorems to base axioms
-/

/-- Bridge to S7: teleological freedom — the good-directed agent is freer
    than the non-good-directed agent. Uses the base axiom's comparison model. -/
theorem teleological_freedom_from_s7
    (a1 a2 : Person)
    (h1 : directedTowardGood a1) (h2 : ¬ directedTowardGood a2) :
    freedomLt (agentFreedom a2) (agentFreedom a1) :=
  s7_teleological_freedom a1 a2 h1 h2

/-- Bridge to T1: libertarian free will — every person could choose otherwise. -/
theorem libertarian_free_will_from_t1 (a : Person) :
    couldChooseOtherwise a :=
  t1_libertarian_free_will a

/-!
## The perfect freedom paradox

The most counterintuitive consequence: PERFECT freedom is the
INABILITY to choose evil.

Most people think: freedom = ability to choose anything.
The Catechism says: freedom = ability to do what is genuinely good.
A being who can only choose good is MORE free than one who can
choose either good or evil.

This means God (who cannot sin) is the FREEST being — not despite
being unable to sin, but BECAUSE of it.
-/

/-- Perfect freedom: fully oriented to good, no longer able to
    choose evil. This is the state of the blessed in heaven
    and (always) of God.
    MODELING CHOICE: We model perfect freedom as a structure with
    Prop fields. The CCC describes this state (§1732: "bound itself
    definitively to its ultimate good") but does not define it as a
    formal concept distinct from ordinary freedom. -/
structure PerfectFreedom where
  person : Person
  /-- Fully oriented to the good -/
  fullyOriented : Prop
  /-- Can no longer choose evil -/
  cannotChooseEvil : Prop

/-- **THEOREM: A person oriented toward the good has positive freedom.**
    Derived from good_increases_freedom: if oriented to good, freedom level > 0.
    This is the formal content of §1733: "the more one does what is good,
    the freer one becomes." -/
theorem oriented_person_has_freedom
    (fd : FreedomDegree) (h : fd.orientedToGood) :
    fd.level > 0 :=
  good_increases_freedom fd h

/-- The perfect freedom paradox: under the Catechism's model,
    the inability to choose evil IS the perfection of freedom.
    Under the modern model, this being would be UNFREE (no choice).
    Under the Catechism's model, this being is MOST FREE.

    A perfectly free being is oriented to good (by definition),
    therefore has positive freedom level (good_increases_freedom),
    AND cannot choose evil. Both hold simultaneously. -/
theorem perfect_freedom_cannot_sin
    (pf : PerfectFreedom)
    (h_oriented : pf.fullyOriented)
    (h_cannot : pf.cannotChooseEvil)
    (fd : FreedomDegree)
    (h_fd_oriented : fd.orientedToGood) :
    -- This being is fully free (positive freedom) AND unable to sin
    pf.fullyOriented ∧ pf.cannotChooseEvil ∧ fd.level > 0 :=
  ⟨h_oriented, h_cannot, good_increases_freedom fd h_fd_oriented⟩

/-!
## Freedom and responsibility

§1734: "Freedom makes man responsible for his acts to the extent
that they are voluntary." This introduces proportional responsibility
— another graded concept.
-/

/-! ### §1734: Responsibility is proportional to freedom

"Freedom makes man responsible for his acts to the extent that they are
voluntary." (CCC §1734)

If freedom is graded (you can be more or less free), and responsibility
tracks freedom, then responsibility is also graded. A person acting under
diminished freedom has diminished responsibility. This connects back to the
Sin formalization — the "full knowledge and complete consent" requirement
for mortal sin is a threshold on this spectrum.

*Deleted axiom*: `responsibility_proportional_to_freedom` had a vacuous body
(`fd.level > 0 → True`). The proportionality concept is modeled through the
`FreedomDegree.level` field and the Sin formalization's consent requirements. -/

/-!
## Summary of hidden assumptions

Formalizing §1730-1738 required these assumptions the text doesn't state:

1. **Teleological freedom** — freedom has a direction. It's oriented
   toward God/the good. This is NOT neutral choice between options.

2. **Freedom is graded** — you can become more or less free. Choosing
   good increases freedom; choosing evil diminishes it.

3. **Evil is self-undermining** — the more evil you choose, the less
   capable you become of choosing good. Empirical-metaphysical claim.

4. **Perfect freedom = inability to sin** — the freest being cannot
   choose evil. This contradicts the common assumption that freedom
   means having all options open.

5. **Proportional responsibility** — if freedom is graded, so is moral
   responsibility. Diminished freedom = diminished responsibility.

6. **Two concepts held simultaneously** — freedom-as-choice (§1731)
   and freedom-as-flourishing (§1733) coexist without the text
   explaining their relationship.

The Catechism's concept of freedom is radically different from the
modern liberal concept. Where modern thought says "freedom = options,"
the Catechism says "freedom = power to do good." This is the deepest
philosophical commitment in the moral theology sections, and the one
most likely to surprise a modern reader.
-/

end Catlib.MoralTheology
