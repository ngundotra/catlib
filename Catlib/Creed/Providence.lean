import Catlib.Foundations

/-!
# CCC §302–311: Divine Providence and Free Will

## The Catechism claims

"We call 'divine providence' the dispositions by which God guides his
creation toward this perfection." (§302)

"All are open and laid bare to his eyes, even those things which are
yet to come into existence through the free action of creatures." (§302)

"God is the sovereign master of his plan. But to carry it out he also
makes use of his creatures' co-operation." (§306)

"God is the first cause who operates in and through secondary causes:
'For God is at work in you, both to will and to work for his good
pleasure.'" (§308)

"God is in no way, directly or indirectly, the cause of moral evil.
He permits it, however, because he respects the freedom of his
creatures." (§311)

## The compatibility problem

These paragraphs assert ALL of the following:
1. God guides ALL of creation toward its end (§302)
2. God knows ALL future events, including free actions (§302)
3. Creatures act on their own, as genuine causes (§306)
4. God operates IN AND THROUGH all creature actions (§308)
5. God is NOT the cause of moral evil (§311)
6. Creatures have genuine freedom (§311)

The tension: how can God operate "in and through" all actions (#4)
while creatures are genuine causes (#3) and God is not responsible
for evil (#5)? This is the classic primary/secondary causation
framework of Thomistic metaphysics — but the Catechism doesn't
spell out how it works.

## Prediction

I expect this to **reveal hidden structure**. The compatibility of
divine sovereignty and human freedom is the central puzzle of
Christian theology. The Catechism asserts both without a mechanism.
Formalization should expose what model of causation is required.

## Findings

- **Prediction vs. reality**: Confirmed — reveals hidden structure.
  The compatibility requires: (1) a two-tier causation model where
  God causes AS primary cause and creatures cause AS secondary causes
  — these are not competing causes at the same level, (2) a
  permission model for evil — God permits but doesn't cause, which
  requires a specific asymmetry between good and evil causation,
  (3) divine foreknowledge is compatible with freedom — asserted
  without mechanism, (4) the dignity of creaturely causation is
  GRANTED by God, not independent — creatures are causes only because
  God made them so.
- **Catholic reading axioms used**: [Definition] CCC §302-311;
  [Tradition] Aquinas, ST I q.22-23, q.105
- **Surprise level**: Significant — the asymmetry between God's
  relationship to good and evil was not predicted. God "operates
  in and through" good actions but only "permits" evil ones. This
  asymmetry is doing enormous metaphysical work and is never argued for.
- **Assessment**: Tier 3 — the causation asymmetry is a genuine
  structural finding.
-/

namespace Catlib.Creed

open Catlib

/-!
## Two-tier causation

The Catechism's resolution to the providence/freedom tension is
the primary/secondary causation framework. God and creatures don't
compete for causal credit — they cause at different levels.
-/

/-- A cause can operate at different levels.
    This is the key modeling choice that resolves the tension. -/
inductive CausalLevel where
  /-- Primary (divine) causation — the ultimate ground of all being -/
  | primary
  /-- Secondary (creaturely) causation — genuine but dependent -/
  | secondary

/-- An event in the world with its causal structure. -/
structure CausedEvent where
  /-- What happened -/
  event : Prop
  /-- The creature's role as secondary cause -/
  secondaryCause : Person
  /-- Was this a free act? -/
  isFreeAct : Prop

/-- The moral character of an event. -/
inductive MoralCharacter where
  | good
  | evil
  | neutral

/-! ### §302: Divine providence is universal

"We call 'divine providence' the dispositions by which God guides his
creation toward this perfection." (CCC §302)

Divine providence is universal — nothing escapes it, even events resulting
from free creaturely action.

*Deleted axiom*: `providence_universal` had a vacuous body (`True`).
The real content is carried by base axiom `s4_universal_providence`
and its bridge theorem `universal_providence_from_s4` below.

### §302: Foreknowledge is compatible with freedom

"All are open and laid bare to his eyes, even those things which are yet
to come into existence through the free action of creatures." (CCC §302)

Foreknowledge is compatible with freedom. The Catechism asserts this
without explaining how. This is one of the deepest problems in
philosophical theology.

*Deleted axiom*: `foreknowledge_compatible_with_freedom` had an identity
body (`e.isFreeAct → e.isFreeAct`). The compatibility is asserted as a
mystery — the base axiom `s4_universal_providence` captures the universal
scope, and `t1_libertarian_free_will` captures the freedom side. -/

/-- AXIOM (§306): Creatures are genuine secondary causes.
    Provenance: [Definition] CCC §306
    "God grants his creatures not only their existence, but also the
    dignity of acting on their own."
    HIDDEN ASSUMPTION: The dignity of creaturely causation is GRANTED
    by God. Creatures don't cause independently — they cause because
    God gave them the capacity to cause. Their causation is real but
    derived. -/
axiom creaturely_causation_genuine :
  ∀ (e : CausedEvent),
    e.secondaryCause.hasFreeWill = true →
    -- The creature genuinely caused this event
    -- (not merely an instrument — a real cause)
    e.isFreeAct

/-! ### §308: Primary and secondary causes do not compete

"God is at work in you, both to will and to work for his good pleasure."
(CCC §308; Phil 2:13)

Primary and secondary causation don't compete. God causing something at
the primary level doesn't prevent the creature from genuinely causing it
at the secondary level. This is a NON-STANDARD causation model — normally
if A causes X and B causes X, they're competitors. Here they're not.

*Deleted axiom*: `primary_secondary_non_competing` had a trivially true body
(exhaustive disjunction on `CausalLevel`). The real content is in base axiom
`p2_two_tier_causation` (`¬ causesCompete p s`) and its bridge theorem
`two_tier_causation_from_p2` below. -/

/-!
## The good/evil asymmetry

§311 introduces a crucial asymmetry: God "operates in and through"
good actions (§308) but only "permits" evil ones (§311). This means
God's causal relationship to good and evil is fundamentally different.
-/

/-- God's relationship to an event depends on its moral character. -/
inductive DivineRelation where
  /-- God operates in and through this event -/
  | operatesThrough
  /-- God merely permits this event -/
  | permits

/-! ### §308 + §311: The causation asymmetry

God operates through good acts but only permits evil acts (CCC §308, §311).

This asymmetry is HUGE and never argued for. Why does God's relationship
to causation change based on the moral character of the effect? This
requires evil to be a privation (absence of good) rather than a positive
reality — otherwise God would need to cause it just as he causes good.
The privation theory of evil is doing invisible work.

*Deleted axiom*: `causation_asymmetry` had a vacuous body (each match branch
was reflexivity or `True`). The `DivineRelation` type above captures the
structural distinction; the base axiom `p3_evil_is_privation` provides the
non-vacuous grounding.

### §311: God is not the cause of moral evil

"God is in no way, directly or indirectly, the cause of moral evil."
(CCC §311)

This requires that "permitting" is not "causing." But if God knows evil
will happen, has the power to prevent it, and chooses not to — is that
really not causing it? The Catechism says yes: permission ≠ causation.
This distinction requires the primary/secondary causation framework to
be coherent.

*Deleted axiom*: `god_not_cause_of_evil` had a vacuous body (`True`).
The real content is in base axiom `p3_evil_is_privation`
(`∀ e, isEvil e → isDueGoodAbsent e`) and its bridge theorem
`evil_is_privation_from_p3` below. -/

/-!
## Bridge theorems to base axioms
-/

/-- Bridge to P2: primary and secondary causes do not compete.
    The base axiom uses opaque `PrimaryCause`/`SecondaryCause` types;
    this makes the non-competition principle available in the Providence
    namespace. -/
theorem two_tier_causation_from_p2 (p : PrimaryCause) (s : SecondaryCause) :
    ¬ causesCompete p s :=
  p2_two_tier_causation p s

/-- Bridge to P3: evil is privation, not positive reality.
    This grounds the causation asymmetry — God causes being, evil is
    the absence of due being, so God does not cause evil. -/
theorem evil_is_privation_from_p3 (e : Prop) (h : isEvil e) :
    isDueGoodAbsent e :=
  p3_evil_is_privation e h

/-- Bridge to S4: universal providence.
    The base axiom asserts every event is divinely governed. -/
theorem universal_providence_from_s4 (event : Prop) :
    divinelyGoverned event :=
  s4_universal_providence event

/-!
## The permission problem

The deepest question: if God is omnipotent and omniscient, and
permits evil he could prevent, is the distinction between "causing"
and "permitting" morally relevant?

The Catechism's answer (from §311): God "respects the freedom of
his creatures" and "knows how to derive good from it." This means:

1. Freedom is so valuable that it's worth the evil it enables
2. God can bring good even from evil
3. Therefore, permitting evil is justified

But this requires a VALUE JUDGMENT: freedom > the evil freedom enables.
This is an axiom the Catechism doesn't argue for.
-/

/-! ### The freedom-justifies-permission principle

Freedom is valuable enough to justify God's permitting the evil that free
creatures do (CCC §311).

1. Freedom is so valuable that it's worth the evil it enables
2. God can bring good even from evil
3. Therefore, permitting evil is justified

But this requires a VALUE JUDGMENT: freedom > the evil freedom enables.
This is an axiom the Catechism doesn't argue for.

*Deleted axiom*: `freedom_justifies_permission` had a vacuous body (`True`).
The value judgment is acknowledged as a hidden assumption. The base axioms
`t1_libertarian_free_will` and `p3_evil_is_privation` provide the structural
framework without encoding this particular value claim. -/

/-!
## Summary of hidden assumptions

Formalizing §302-311 required these assumptions the text doesn't state:

1. **Two-tier causation** — primary and secondary causes don't compete.
   God causing something doesn't prevent the creature from genuinely
   causing it. This is a non-standard causation model.

2. **Granted causation** — creaturely causation is real but derived.
   Creatures cause only because God gave them the capacity.

3. **Foreknowledge-freedom compatibility** — asserted, no mechanism.
   One of the deepest problems in philosophical theology.

4. **Good/evil causation asymmetry** — God "operates through" good
   but only "permits" evil. This requires evil to be a privation, not
   a positive reality.

5. **Permission ≠ causation** — God knowing about, having power over,
   and permitting evil is different from causing it. This distinction
   is an axiom, not a derivation.

6. **Freedom > evil** — the value of creaturely freedom justifies
   God's permitting the evil freedom enables. A value judgment the
   text doesn't argue for.

The Catechism compresses the entire Thomistic doctrine of providence
into ten paragraphs. Six hidden assumptions were identified — five had
vacuous formalizations and were converted to module docs. One local axiom
(`creaturely_causation_genuine`) has real content. The remaining theological
claims are grounded by base axioms P2, P3, S4, and T1 via bridge theorems.
-/

end Catlib.Creed
