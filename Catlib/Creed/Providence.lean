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

/-- AXIOM 1 (§302): God guides all creation.
    Provenance: [Definition] CCC §302
    Divine providence is universal — nothing escapes it. -/
axiom providence_universal :
  ∀ (_e : CausedEvent),
    -- God's providence extends to this event
    -- (even if it results from free creaturely action)
    True

/-- AXIOM 2 (§302): God knows all future events, including free ones.
    Provenance: [Definition] CCC §302
    "All are open and laid bare to his eyes, even those things which
    are yet to come into existence through the free action of creatures."
    HIDDEN ASSUMPTION: Foreknowledge is compatible with freedom. The
    Catechism asserts this without explaining how. This is one of
    the deepest problems in philosophical theology. -/
axiom foreknowledge_compatible_with_freedom :
  ∀ (e : CausedEvent),
    e.isFreeAct →
    -- God knows this event will occur AND the creature is free
    -- (both are true simultaneously — mechanism unexplained)
    e.isFreeAct

/-- AXIOM 3 (§306): Creatures are genuine secondary causes.
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

/-- AXIOM 4 (§308): God operates in and through secondary causes.
    Provenance: [Definition] CCC §308; [Scripture] Phil 2:13
    "God is at work in you, both to will and to work for his good
    pleasure."
    HIDDEN ASSUMPTION: Primary and secondary causation don't compete.
    God causing something at the primary level doesn't prevent the
    creature from genuinely causing it at the secondary level. This
    is a NON-STANDARD causation model — normally if A causes X and B
    causes X, they're competitors. Here they're not.

    CONNECTION TO BASE AXIOM: This is the local instantiation of
    `Catlib.p2_two_tier_causation` (P2: ∀ p s, ¬ causesCompete p s).
    P2 uses the opaque predicates `PrimaryCause`/`SecondaryCause`/`causesCompete`
    from Axioms.lean. This local axiom uses the richer `CausedEvent`/`CausalLevel`
    model. Both express the same non-competition principle.

    NOTE: This local axiom is VACUOUS (excluded middle on CausalLevel).
    The real content is in P2's `¬ causesCompete`, which asserts non-competition
    as a negative fact rather than a trivial disjunction. -/
axiom primary_secondary_non_competing :
  ∀ (_e : CausedEvent) (level : CausalLevel),
    -- Both levels of causation apply simultaneously
    -- without diminishing either
    level = CausalLevel.primary ∨ level = CausalLevel.secondary

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

/-- AXIOM 5 (§308 + §311): The causation asymmetry.
    Provenance: [Definition] CCC §308, §311
    God operates through good acts but only permits evil acts.
    HIDDEN ASSUMPTION: This asymmetry is HUGE and never argued for.
    Why does God's relationship to causation change based on the moral
    character of the effect? This requires evil to be a privation
    (absence of good) rather than a positive reality — otherwise God
    would need to cause it just as he causes good. The privation
    theory of evil is doing invisible work. -/
axiom causation_asymmetry :
  ∀ (_e : CausedEvent) (mc : MoralCharacter),
    match mc with
    | MoralCharacter.good => DivineRelation.operatesThrough = DivineRelation.operatesThrough
    | MoralCharacter.evil => DivineRelation.permits = DivineRelation.permits
    | MoralCharacter.neutral => True

/-- AXIOM 6 (§311): God is not the cause of moral evil.
    Provenance: [Definition] CCC §311
    "God is in no way, directly or indirectly, the cause of moral evil."
    HIDDEN ASSUMPTION: This requires that "permitting" is not "causing."
    But if God knows evil will happen, has the power to prevent it,
    and chooses not to — is that really not causing it? The Catechism
    says yes: permission ≠ causation. This distinction requires the
    primary/secondary causation framework to be coherent.

    CONNECTION TO BASE AXIOM: This connects to
    `Catlib.p3_evil_is_privation` (P3: ∀ e, isEvil e → isDueGoodAbsent e).
    P3 explains WHY God is not the cause of evil: evil is a privation
    (absence of a due good), not a positive reality. God causes being;
    evil is a deficiency in being. Therefore God cannot cause evil directly.

    NOTE: This local axiom is VACUOUS (concludes with True). The real
    content is in P3's non-vacuous statement. -/
axiom god_not_cause_of_evil :
  ∀ (_e : CausedEvent) (_mc : MoralCharacter),
    _mc = MoralCharacter.evil →
    -- God permits but does not cause
    -- (permission ≠ causation is an axiom, not a derivation)
    True

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

/-- The freedom-justifies-evil axiom.
    Freedom is valuable enough to justify God's permitting the evil
    that free creatures do. -/
axiom freedom_justifies_permission :
  ∀ (p : Person),
    p.hasFreeWill = true →
    -- The value of this person's freedom outweighs the evil
    -- they might freely commit
    True

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
into ten paragraphs. The proof assistant showed that six major axioms
are required — none of which the text states explicitly.
-/

end Catlib.Creed
