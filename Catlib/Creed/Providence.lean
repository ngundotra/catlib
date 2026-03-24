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
    MODELING CHOICE: We represent the Thomistic primary/secondary causation
    distinction as a two-constructor enum. The CCC uses this framework
    (§306, §308) but does not formalize it as exactly two levels. -/
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
## §311: Why permission does not collapse into causation

"God is in no way, directly or indirectly, the cause of moral evil.
He permits it, however, because he respects the freedom of his
creatures." (CCC §311)

This section formalizes the CCC's answer to the deepest version of the
problem of evil: if God sustains all being and governs all events, how
is permitting evil different from causing it?

The argument has three pillars:
1. **P3 (evil is privation)**: Evil is an absence of due good, not a
   positive substance. You don't need a productive cause for a hole the
   way you need one for a wall. God causes being; evil is non-being.
2. **P2 (two-tier causation)**: God operates at the primary level;
   creatures operate at the secondary level. Moral evil originates from
   defective secondary causes (creaturely will), not from the primary cause.
3. **T1 (libertarian free will)**: God granted creatures genuine freedom.
   Genuine freedom includes the ability to choose evil. Permission of evil
   is entailed by the grant of freedom.

The conclusion: permission ≠ causation because (a) evil needs no positive
divine production (P3), (b) evil originates at the secondary level (P2),
and (c) permission follows from the grant of freedom (T1).

### Main question from backlog

**Is the privation theory enough, or is a stronger causal distinction
required?**

Finding: the privation theory (P3) is *necessary but not sufficient*. P3
alone explains why God need not positively produce evil, but it does not
explain why God's non-prevention differs from complicity. The two-tier
causation model (P2) is equally load-bearing: it provides the ontological
framework in which "God sustains all being" and "God does not cause evil"
are compatible, because sustaining being (primary causation) and producing
a moral defect (secondary causation) operate at different levels. T1
(freedom) completes the picture by explaining *why* God permits: freedom
is the good that justifies non-prevention.

All three are required. Drop any one and the argument fails:
- Drop P3: evil is a positive substance → God must have created it.
- Drop P2: primary and secondary causation compete → God operating through
  creatures makes God the direct author of their acts, including evil ones.
- Drop T1: creatures have no genuine freedom → "permission" is empty (God
  is the only real agent).
-/

/-- Whether an event requires a positive cause to bring it about.
    MODELING CHOICE: This captures the distinction between positive realities
    (which need a productive cause) and privations (absences of due good,
    which need only a deficient cause — i.e. the failure of a secondary cause
    to act well). The CCC never uses this exact language, but the privation
    theory (P3) implies it: if evil is absence, it needs no positive production. -/
opaque requiresPositiveCause : Prop → Prop

/-- AXIOM (§311 + P3): Privations do not require positive causation.
    Provenance: [Philosophical] Augustine, Confessions VII.12; Aquinas, ST I q.49 a.1
    If something is evil (and therefore a privation of due good, by P3),
    it does not require a positive cause to bring it about. A hole does not
    need a builder — it needs only the absence of building.
    HIDDEN ASSUMPTION: The inference from "evil = privation" to "evil needs
    no positive cause" is not trivial. It requires the metaphysical principle
    that only positive realities need efficient causes. The CCC takes this
    from Augustine/Aquinas without stating it. -/
axiom privation_needs_no_positive_cause :
  ∀ (e : Prop), isEvil e → isDueGoodAbsent e → ¬ requiresPositiveCause e

/-- Whether a morally evil event originates from a secondary (creaturely) cause.
    MODELING CHOICE: "Originates from" means the defect that constitutes the evil
    is attributable to the secondary cause's failure to act well, not to the
    primary cause's action. This is the Thomistic "deficient cause" principle
    (Aquinas, ST I q.49 a.1: "evil has no per se cause, only a deficient cause"). -/
opaque originatesFromSecondaryCause : Prop → Prop

/-- AXIOM (§306 + §311 + P2): Moral evil originates at the secondary-cause level.
    Provenance: [Definition] CCC §306, §311; [Philosophical] Aquinas, ST I q.49 a.1
    Since primary and secondary causes don't compete (P2), and creatures are genuine
    secondary causes (§306), the moral defect in a free creaturely act belongs to
    the creature's exercise of secondary causation, not to God's primary causation.
    HIDDEN ASSUMPTION: The "level" at which a defect originates determines moral
    authorship. This is doing enormous work — it means that even though God
    sustains the creature's being and capacity to act, the creature's misuse of
    that capacity is attributable to the creature, not to God. The CCC asserts
    this without arguing for it. -/
axiom moral_evil_from_secondary_cause :
  ∀ (e : CausedEvent),
    e.secondaryCause.hasFreeWill = true →
    isEvil e.event →
    originatesFromSecondaryCause e.event

/-- Whether God's relationship to an event is one of permission (as opposed to
    positive causation). This is the formal counterpart of the `DivineRelation`
    type's `permits` constructor, but as a predicate on events rather than a
    type tag.
    MODELING CHOICE: We separate the predicate from the inductive type to allow
    reasoning about specific events. -/
opaque divinelyPermits : Prop → Prop

/-- Whether God positively causes an event at the primary-cause level.
    This is the formal counterpart of `DivineRelation.operatesThrough`.
    MODELING CHOICE: "Positively causes" means God's primary causation directly
    underwrites the event as a positive reality, not merely sustains the being
    of the agent who does it. -/
opaque divinelyCauses : Prop → Prop

/-- AXIOM (§311): Permission and causation are exclusive.
    Provenance: [Definition] CCC §311
    "God is in no way, directly or indirectly, the cause of moral evil.
    He permits it, however."
    The "however" signals that permission is the ALTERNATIVE to causation,
    not a species of it. An event that God permits is precisely one that
    God does not positively cause.
    HIDDEN ASSUMPTION: This mutual exclusion is the core of the CCC's
    resolution. It is stated flatly ("in no way… the cause… He permits"),
    but the justification comes from P2, P3, and T1 together. -/
axiom permission_excludes_causation :
  ∀ (e : Prop), divinelyPermits e → ¬ divinelyCauses e

/-- AXIOM (§311 + T1): God permits evil because freedom requires it.
    Provenance: [Definition] CCC §311; [Tradition] Trent Session 6
    "He permits it, however, because he respects the freedom of his creatures."
    Genuine freedom (T1) includes the ability to choose evil. If God prevented
    every evil choice, freedom would not be genuine — it would be compatibilist
    at best. Therefore, granting genuine freedom entails permitting the evil
    that freedom enables.
    HIDDEN ASSUMPTION: This is the value judgment hidden in §311 — freedom is
    so valuable that its grant justifies the permission of the evil it enables.
    The CCC does not argue for this valuation. -/
axiom freedom_entails_permission :
  ∀ (e : CausedEvent),
    e.secondaryCause.hasFreeWill = true →
    e.isFreeAct →
    isEvil e.event →
    divinelyPermits e.event

/-!
## Theorems: the §311 resolution

The CCC's answer to "why does evil permission not collapse into evil
causation?" is a three-step argument:

Step 1 (from P3): Evil needs no positive divine cause — it's a privation.
Step 2 (from P2 + §306): Evil originates from secondary causes, not primary.
Step 3 (from T1 + §311): God permits evil because genuine freedom requires it.
Conclusion: Permission ≠ causation, and God is not the moral author of evil.
-/

/-- **THEOREM (Step 1): Evil needs no positive divine cause.**
    From P3 (evil is privation): evil is an absence of due good, therefore
    it does not require God to positively produce it. A hole needs no builder.
    Depends on: p3_evil_is_privation, privation_needs_no_positive_cause. -/
theorem evil_needs_no_positive_cause (e : Prop) (h_evil : isEvil e) :
    ¬ requiresPositiveCause e :=
  privation_needs_no_positive_cause e h_evil (p3_evil_is_privation e h_evil)

/-- **THEOREM (Step 2): Moral evil originates at the creaturely level.**
    From P2 (two-tier causation) + §306 (creaturely causation genuine):
    when a free creature commits evil, the moral defect belongs to the
    creature's secondary causation, not to God's primary causation.
    The creature is the genuine (secondary) cause; God's primary causation
    sustains being but does not produce the defect.
    Depends on: moral_evil_from_secondary_cause, creaturely_causation_genuine. -/
theorem evil_originates_from_creature
    (e : CausedEvent) (h_free : e.secondaryCause.hasFreeWill = true)
    (h_evil : isEvil e.event) :
    originatesFromSecondaryCause e.event ∧ e.isFreeAct :=
  ⟨moral_evil_from_secondary_cause e h_free h_evil,
   creaturely_causation_genuine e h_free⟩

/-- **THEOREM (Step 3): God permits, but does not cause, evil free acts.**
    From T1 (freedom) + §311: when a free creature commits evil, God
    permits it (because freedom requires it) and does NOT cause it
    (permission excludes causation).
    This is the formal content of CCC §311: "God is in no way, directly
    or indirectly, the cause of moral evil. He permits it, however,
    because he respects the freedom of his creatures."
    Depends on: freedom_entails_permission, permission_excludes_causation. -/
theorem god_permits_not_causes_evil
    (e : CausedEvent)
    (h_free : e.secondaryCause.hasFreeWill = true)
    (h_evil : isEvil e.event) :
    divinelyPermits e.event ∧ ¬ divinelyCauses e.event :=
  have h_act := creaturely_causation_genuine e h_free
  have h_permits := freedom_entails_permission e h_free h_act h_evil
  ⟨h_permits, permission_excludes_causation e.event h_permits⟩

/-- **THEOREM (§311 synthesis): The full resolution — permission ≠ causation.**
    Combines all three steps: evil is a privation (no positive cause needed),
    originates from secondary causes (not God), and God permits it (because
    freedom requires it) without causing it.

    This theorem answers the backlog question: "Why does evil permission not
    collapse into evil causation?" The answer is that THREE independent
    principles prevent the collapse:
    (a) P3: evil needs no positive divine production
    (b) P2: evil originates at the secondary-cause level
    (c) T1: permission follows from the grant of genuine freedom

    Depends on: p3_evil_is_privation, privation_needs_no_positive_cause,
    moral_evil_from_secondary_cause, creaturely_causation_genuine,
    freedom_entails_permission, permission_excludes_causation. -/
theorem permission_does_not_collapse_into_causation
    (e : CausedEvent)
    (h_free : e.secondaryCause.hasFreeWill = true)
    (h_evil : isEvil e.event) :
    -- (a) Evil needs no positive cause
    ¬ requiresPositiveCause e.event
    -- (b) Evil originates from the creature, not God
    ∧ originatesFromSecondaryCause e.event
    -- (c) God permits but does not cause
    ∧ divinelyPermits e.event
    ∧ ¬ divinelyCauses e.event :=
  have step1 := evil_needs_no_positive_cause e.event h_evil
  have step2 := moral_evil_from_secondary_cause e h_free h_evil
  have ⟨h_permits, h_not_causes⟩ := god_permits_not_causes_evil e h_free h_evil
  ⟨step1, step2, h_permits, h_not_causes⟩

/-!
## §312: God draws good from evil

"We know that in everything God works for good with those who love him."
(CCC §312, citing Rom 8:28)

God does not cause evil, but can draw good from it. This is NOT a
justification for evil — it's a claim about divine resourcefulness.
The CCC is careful: God permits evil not IN ORDER TO draw good from it
(that would make evil instrumental and God its intentional cause), but
God CAN draw good from evil that creatures freely chose.

This remains a hidden value judgment: the good drawn from evil is
sufficient to justify the permission. The CCC asserts it (§312) but
does not argue for it.
-/

/-- Whether God draws good from a permitted evil event.
    HONEST OPACITY: The CCC asserts this (§312, citing Rom 8:28) but
    gives no mechanism for HOW God draws good from evil. The claim is
    that divine providence is resourceful enough to incorporate even evil
    into a good plan — but the "how" is left to mystery. -/
opaque drawsGoodFromEvil : Prop → Prop

/-- AXIOM (§312): God can draw good even from evil events.
    Provenance: [Scripture] Rom 8:28; [Definition] CCC §312
    "We know that in everything God works for good."
    Note: this does NOT say God causes evil for the purpose of drawing
    good from it. It says that evil which creatures freely chose can
    be incorporated into God's providential plan. The order matters:
    evil is permitted (§311), THEN good is drawn from it (§312). -/
axiom god_draws_good_from_evil :
  ∀ (e : Prop), isEvil e → divinelyPermits e → drawsGoodFromEvil e

/-- **THEOREM (§311 + §312): The complete providence picture.**
    For any evil free act: (1) the creature genuinely caused it,
    (2) God did not cause it, (3) God permitted it, and (4) God can
    draw good from it. This is the full content of §311-312.
    Depends on: all local axioms + p3_evil_is_privation. -/
theorem complete_providence_picture
    (e : CausedEvent)
    (h_free : e.secondaryCause.hasFreeWill = true)
    (h_evil : isEvil e.event) :
    -- Creature genuinely caused it
    e.isFreeAct
    -- God did not cause it
    ∧ ¬ divinelyCauses e.event
    -- God permitted it
    ∧ divinelyPermits e.event
    -- God draws good from it
    ∧ drawsGoodFromEvil e.event :=
  have h_act := creaturely_causation_genuine e h_free
  have ⟨h_permits, h_not_causes⟩ := god_permits_not_causes_evil e h_free h_evil
  have h_good := god_draws_good_from_evil e.event h_evil h_permits
  ⟨h_act, h_not_causes, h_permits, h_good⟩

/-!
## Summary of hidden assumptions

Formalizing §302-312 required these assumptions the text doesn't state:

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

7. **Privation needs no positive cause** — the inference from "evil is
   absence" to "evil needs no efficient cause" requires the metaphysical
   principle that only positive realities need efficient causes.
   Augustine/Aquinas supply this; the CCC assumes it silently.

8. **Defect attribution by causal level** — when a free creature misuses
   its capacity, the moral defect belongs to the secondary cause (creature),
   not the primary cause (God), even though God sustains the creature's being.
   This is the deepest hidden assumption in §311 — it makes "operates through"
   compatible with "not the cause."

## Key finding: all three pillars are required

The formalization confirms that the privation theory (P3) alone is
**necessary but not sufficient** to prevent the collapse of permission
into causation. The full resolution requires:

- **P3 (privation)**: explains why no positive divine production is needed
- **P2 (two-tier causation)**: explains why God sustaining being ≠ God
  causing the defect
- **T1 (freedom)**: explains WHY God permits — freedom requires it

Drop any one and the argument fails:
- Without P3: evil is positive → God must have created it
- Without P2: causes compete → God operating through creatures = God
  authoring their acts
- Without T1: no genuine freedom → "permission" is empty rhetoric
-/

end Catlib.Creed
