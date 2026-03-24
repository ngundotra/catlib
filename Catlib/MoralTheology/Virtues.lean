import Catlib.Foundations
import Catlib.MoralTheology.Freedom

/-!
# CCC §1803–1845: Cardinal and Theological Virtues

## The Catechism claims

"A virtue is a habitual and firm disposition to do the good. It allows the
person not only to perform good acts, but to give the best of himself."
(§1803)

"Four virtues play a pivotal role and accordingly are called 'cardinal';
all the others are grouped around them. They are: prudence, justice,
fortitude, and temperance." (§1805)

"Human virtues acquired by education, by deliberate acts and by a
perseverance ever-renewed in repeated efforts are purified and elevated
by divine grace." (§1810)

"It is not easy for man, wounded by sin, to maintain moral balance.
Christ's gift of salvation offers us the grace necessary to persevere
in the pursuit of the virtues." (§1811)

"The theological virtues are the foundation of Christian moral activity;
they animate it and give it its special character. They inform and give
life to all the moral virtues. They are infused by God into the souls
of the faithful to make them capable of acting as his children and of
meriting eternal life." (§1813)

"Faith is the theological virtue by which we believe in God and believe
all that he has said and revealed to us." (§1814)

"Hope is the theological virtue by which we desire the kingdom of heaven
and eternal life as our happiness." (§1817)

"Charity is the theological virtue by which we love God above all things
for his own sake, and our neighbor as ourselves for the love of God."
(§1822)

## Two categories of virtue

The Catechism distinguishes:

1. **Cardinal virtues** (prudence, justice, fortitude, temperance) —
   "acquired by education, by deliberate acts" (§1810). These are
   NATURAL virtues: accessible to human effort without special revelation.

2. **Theological virtues** (faith, hope, charity) — "infused by God
   into the souls of the faithful" (§1813). These are SUPERNATURAL
   virtues: not attainable by human effort alone.

## The key tension: §1811

The Catechism says cardinal virtues are "acquired by human effort" (§1810)
but ALSO says "it is not easy for man, wounded by sin, to maintain moral
balance" and that "Christ's gift of salvation offers us the grace necessary
to persevere" (§1811).

This creates a three-position spectrum:
- **Pelagianism** (condemned): humans can achieve ALL virtue by nature alone
- **Catholic** (§1810-1811): cardinal virtues are POSSIBLE by nature but
  DIFFICULT without grace after the Fall; theological virtues require grace
- **Total depravity** (Calvin): NO virtue is possible without grace

## Findings

- **The cardinal/theological distinction does NOT cleanly map to
  natural/supernatural.** §1811 says even cardinal virtues need grace
  for perseverance after the Fall. The distinction is about ORIGIN
  (how you get the virtue) not about INDEPENDENCE from grace.

- **Cardinal virtues have a dual acquisition mode.** They can be acquired
  naturally (§1810) but are "purified and elevated by divine grace" (§1810)
  and difficult to sustain without it (§1811). This is a BOTH/AND: natural
  acquisition is real but insufficient for perseverance.

- **Theological virtues animate all moral virtues.** §1813 says theological
  virtues "inform and give life to ALL the moral virtues." This means
  charity is not just one virtue among seven — it is the FORM of all virtue.
  Without charity, the cardinal virtues lack their supernatural orientation.

- **The denominational split is precisely about §1811.** Pelagians say
  grace is unnecessary (nature suffices). Catholics say grace is necessary
  for perseverance but not for initial acquisition. Calvinists say grace
  is necessary for any virtue whatsoever (total depravity).

- **Connection to existing axioms:** S8 (grace transformative) grounds
  why theological virtues transform the person. S7 (teleological freedom)
  grounds why virtue is ordered toward the good. The Freedom.lean model
  of graded freedom maps onto the gradual acquisition of virtue.
-/

set_option autoImplicit false

namespace Catlib.MoralTheology.Virtues

open Catlib
open Catlib.Foundations.Love (TypedLove LoveKind)

-- ============================================================================
-- ## Core Types
-- ============================================================================

/-- The four cardinal virtues. CCC §1805: "Four virtues play a pivotal role."
    Source: [CCC] §1805-1809.
    These are the "hinge" virtues (Latin: cardo = hinge) around which all
    other moral virtues are grouped. -/
inductive CardinalVirtue where
  /-- Prudence: "the virtue that disposes practical reason to discern our
      true good in every circumstance." CCC §1806. -/
  | prudence
  /-- Justice: "the moral virtue that consists in the constant and firm will
      to give their due to God and neighbor." CCC §1807. -/
  | justice
  /-- Fortitude: "the moral virtue that ensures firmness in difficulties and
      constancy in the pursuit of the good." CCC §1808. -/
  | fortitude
  /-- Temperance: "the moral virtue that moderates the attraction of pleasures
      and provides balance in the use of created goods." CCC §1809. -/
  | temperance

/-- The three theological virtues. CCC §1812-1813.
    Source: [CCC] §1812-1829.
    These "relate directly to God" (§1812) and are "infused by God into the
    souls of the faithful" (§1813). -/
inductive TheologicalVirtue where
  /-- Faith: "the theological virtue by which we believe in God and believe
      all that he has said and revealed to us." CCC §1814. -/
  | faith
  /-- Hope: "the theological virtue by which we desire the kingdom of heaven
      and eternal life as our happiness." CCC §1817. -/
  | hope
  /-- Charity: "the theological virtue by which we love God above all things
      for his own sake, and our neighbor as ourselves for the love of God."
      CCC §1822. Charity = agape in the Love.lean taxonomy. -/
  | charity

/-- A virtue — either cardinal or theological.
    Source: [Modeling] Our formalization choice to unify the two categories
    under a common type for reasoning about virtue in general. -/
inductive Virtue where
  | cardinal (v : CardinalVirtue)
  | theological (v : TheologicalVirtue)

/-- Whether a person possesses a given virtue (as a habitual disposition).
    Source: [CCC] §1803 ("A virtue is a habitual and firm disposition to do
    the good"). Opaque because the CCC treats possession of virtue as a
    real but not directly observable state.
    HONEST OPACITY: The CCC defines virtue as "habitual and firm disposition"
    (§1803) but does not specify a measurement criterion. -/
opaque hasVirtue : Person → Virtue → Prop

/-- Whether a virtue was acquired through natural human effort (education,
    deliberate acts, perseverance).
    Source: [CCC] §1810 ("Human virtues acquired by education, by deliberate
    acts and by a perseverance ever-renewed in repeated efforts").
    HIDDEN ASSUMPTION: The CCC assumes a clear distinction between natural
    acquisition and supernatural infusion. -/
opaque naturallyAcquired : Person → Virtue → Prop

/-- Whether a virtue was infused by God (supernatural gift).
    Source: [CCC] §1813 ("They are infused by God into the souls of the
    faithful").
    HIDDEN ASSUMPTION: "Infusion" implies a real ontological change in the
    person, not merely an external imputation — this depends on S8 (grace
    is transformative). -/
opaque divinelyInfused : Person → Virtue → Prop

/-- Whether a person can sustain (persevere in) a virtue over time.
    Source: [CCC] §1811 ("Christ's gift of salvation offers us the grace
    necessary to persevere in the pursuit of the virtues").
    HONEST OPACITY: The CCC does not define what "perseverance" requires
    beyond continued effort aided by grace. -/
opaque canPersevereIn : Person → Virtue → Prop

/-- Whether a person is "wounded by sin" — in the post-Fall condition.
    Source: [CCC] §1811 ("It is not easy for man, wounded by sin, to
    maintain moral balance").
    MODELING CHOICE: We treat this as a binary predicate. The CCC describes
    a universal human condition (original sin) but the degree of wounding
    varies. Connects to OriginalSin.lean. -/
opaque woundedBySin : Person → Prop

/-- Whether a virtue informs (gives life to) another virtue.
    Source: [CCC] §1813 ("They inform and give life to all the moral
    virtues"). Charity "informs" the cardinal virtues by orienting them
    toward their supernatural end.
    HIDDEN ASSUMPTION: "Informing" is a real causal relationship, not
    merely rhetorical. Aquinas (ST II-II q.23 a.8): charity is the
    "form of the virtues." -/
opaque informs : Virtue → Virtue → Prop

-- ============================================================================
-- ## Axioms
-- ============================================================================

/-- **A1. Cardinal virtues are naturally acquirable.**
    Source: [CCC] §1810.
    "Human virtues acquired by education, by deliberate acts and by a
    perseverance ever-renewed in repeated efforts."
    Cardinal virtues CAN be acquired by natural human effort — they do not
    strictly require divine infusion for their initial acquisition. -/
axiom cardinal_naturally_acquirable :
  ∀ (p : Person) (v : CardinalVirtue),
    p.hasFreeWill = true →
    p.hasIntellect = true →
    -- A person with reason and will CAN acquire cardinal virtues naturally
    naturallyAcquired p (Virtue.cardinal v)

/-- **A2. Theological virtues are divinely infused, not naturally acquired.**
    Source: [CCC] §1813.
    "They are infused by God into the souls of the faithful to make them
    capable of acting as his children and of meriting eternal life."
    Theological virtues CANNOT be acquired by natural effort alone. -/
axiom theological_require_infusion :
  ∀ (p : Person) (v : TheologicalVirtue),
    hasVirtue p (Virtue.theological v) →
    divinelyInfused p (Virtue.theological v)

/-- **A3. Theological virtues cannot be naturally acquired.**
    Source: [CCC] §1812-1813.
    "The theological virtues... are infused by God." The converse of A2:
    natural effort alone does not produce theological virtues. -/
axiom theological_not_naturally_acquired :
  ∀ (p : Person) (v : TheologicalVirtue),
    naturallyAcquired p (Virtue.theological v) → False

/-- **A4. Grace is necessary for perseverance after the Fall.**
    Source: [CCC] §1811.
    "It is not easy for man, wounded by sin, to maintain moral balance.
    Christ's gift of salvation offers us the grace necessary to persevere
    in the pursuit of the virtues."
    For a person wounded by sin, perseverance in ANY virtue (even cardinal)
    requires grace. This is the key §1811 claim. -/
axiom grace_needed_for_perseverance :
  ∀ (p : Person) (v : Virtue) (g : Grace),
    woundedBySin p →
    canPersevereIn p v →
    graceGiven p g

/-- **A5. Charity informs all cardinal virtues.**
    Source: [CCC] §1827.
    "The practice of all the virtues is animated and inspired by charity.
    Charity upholds and purifies our human ability to love, and raises it
    to the supernatural perfection of divine love."
    Charity is the "form of the virtues" (Aquinas ST II-II q.23 a.8) —
    it orients all cardinal virtues toward their supernatural end. -/
axiom charity_informs_cardinal :
  ∀ (v : CardinalVirtue),
    informs (Virtue.theological TheologicalVirtue.charity) (Virtue.cardinal v)

/-- **A6. Charity is agape.**
    Source: [CCC] §1822 + Love.lean taxonomy.
    "Charity is the theological virtue by which we love God above all things
    for his own sake." This is precisely the definition of agape in Love.lean.
    MODELING CHOICE: We identify charity with agape. The CCC does not use the
    Greek term, but the definition matches exactly. -/
axiom charity_is_agape :
  ∀ (p : Person),
    hasVirtue p (Virtue.theological TheologicalVirtue.charity) →
    ∃ (tl : TypedLove),
      tl.kind = LoveKind.agape ∧
      tl.lover = p ∧
      tl.degree > 0

/-- **A7. All persons are wounded by sin.**
    Source: [CCC] §1811 + OriginalSin doctrine.
    "It is not easy for man, wounded by sin..." — the universal human
    condition after the Fall. This is what makes §1811 apply to everyone,
    not just some.
    CONNECTION TO BASE AXIOM: This instantiates the doctrine of original sin
    (CCC §388-389) for the virtue context. -/
axiom universal_woundedness :
  ∀ (p : Person), p.isMoralAgent = true → woundedBySin p

-- ============================================================================
-- ## Theorems
-- ============================================================================

/-!
### Theorem 1: Cardinal virtues need grace for perseverance

The key §1811 result: even though cardinal virtues CAN be acquired
naturally (A1), a fallen person cannot PERSEVERE in them without grace (A4).
This is the Catholic middle position between Pelagianism and total depravity.
-/

/-- Cardinal virtues are acquirable by nature but require grace for
    perseverance after the Fall.

    Derivation:
    1. A1: Cardinal virtues CAN be acquired naturally
    2. A4: Perseverance after the Fall requires grace
    3. A7: All moral agents are wounded by sin
    Therefore: a moral agent who perseveres in a cardinal virtue has grace.

    This is the formal content of §1810-1811 together. -/
theorem cardinal_need_grace_for_perseverance
    (p : Person) (v : CardinalVirtue) (g : Grace)
    (h_moral : p.isMoralAgent = true)
    (h_persevere : canPersevereIn p (Virtue.cardinal v)) :
    graceGiven p g := by
  have h_wounded := universal_woundedness p h_moral
  exact grace_needed_for_perseverance p (Virtue.cardinal v) g h_wounded h_persevere

/-!
### Theorem 2: Theological virtues are strictly supernatural

Theological virtues cannot come from nature — they must come from God.
This follows directly from A2 and A3 but the conjunction makes the
claim precise: possession IMPLIES infusion, and natural acquisition
is IMPOSSIBLE.
-/

/-- Theological virtues are obtainable ONLY by divine infusion.

    Derivation:
    1. A2: Having a theological virtue implies it was divinely infused
    2. A3: Natural acquisition of theological virtues is impossible
    Therefore: the only path to a theological virtue is divine infusion. -/
theorem theological_only_by_infusion
    (p : Person) (v : TheologicalVirtue) :
    (hasVirtue p (Virtue.theological v) → divinelyInfused p (Virtue.theological v)) ∧
    (naturallyAcquired p (Virtue.theological v) → False) :=
  ⟨theological_require_infusion p v, theological_not_naturally_acquired p v⟩

/-!
### Theorem 3: Charity connects to Love.lean

Charity (the theological virtue) IS agape (the love-kind from Love.lean).
A person with charity has agape with positive degree. This bridges the
Virtues formalization to the Love formalization.
-/

/-- A person with charity has agape-love (positive degree).
    This bridges Virtues.lean to Love.lean: charity = agape.

    Derivation: Direct from A6 (charity_is_agape). -/
theorem charity_entails_agape
    (p : Person)
    (h : hasVirtue p (Virtue.theological TheologicalVirtue.charity)) :
    ∃ (tl : TypedLove),
      tl.kind = LoveKind.agape ∧
      tl.lover = p ∧
      tl.degree > 0 :=
  charity_is_agape p h

/-!
### Theorem 4: The acquisition distinction does NOT mean independence from grace

The cardinal/theological distinction is about ORIGIN (how you get the virtue),
not about whether grace is ever needed. After the Fall, even cardinal virtues
need grace — not for initial acquisition but for sustained practice.

This collapses the naive reading that "cardinal = natural = no grace needed."
-/

/-- Even a naturally-acquired cardinal virtue requires grace for perseverance
    in a fallen person.

    Derivation:
    1. Cardinal virtues can be naturally acquired (A1) — this is REAL
    2. But perseverance requires grace (A4) — this is ALSO real
    3. All moral agents are wounded by sin (A7)
    Therefore: natural acquisition and grace-dependence coexist.

    This is the formal content of the §1810-1811 tension: the CCC says
    BOTH that cardinal virtues are "acquired by human effort" AND that
    grace is "necessary to persevere." Both are true simultaneously. -/
theorem natural_acquisition_compatible_with_grace_dependence
    (p : Person) (v : CardinalVirtue) (g : Grace)
    (h_moral : p.isMoralAgent = true)
    (h_will : p.hasFreeWill = true)
    (h_intel : p.hasIntellect = true)
    (h_persevere : canPersevereIn p (Virtue.cardinal v)) :
    -- Natural acquisition is possible...
    naturallyAcquired p (Virtue.cardinal v) ∧
    -- ...AND grace is given for perseverance
    graceGiven p g := by
  exact ⟨cardinal_naturally_acquirable p v h_will h_intel,
         cardinal_need_grace_for_perseverance p v g h_moral h_persevere⟩

/-!
### Theorem 5: Charity is the form of all virtue

§1827 + §1813: Charity "informs and gives life to all the moral virtues."
Every cardinal virtue is informed by charity. This means the cardinal
virtues without charity are INCOMPLETE — they function at the natural level
but lack their supernatural orientation.
-/

/-- Every cardinal virtue is informed by charity.

    Derivation: Direct from A5 — charity informs each cardinal virtue.
    The conjunction makes the universal claim explicit. -/
theorem charity_is_form_of_all_cardinal :
    informs (Virtue.theological TheologicalVirtue.charity) (Virtue.cardinal CardinalVirtue.prudence) ∧
    informs (Virtue.theological TheologicalVirtue.charity) (Virtue.cardinal CardinalVirtue.justice) ∧
    informs (Virtue.theological TheologicalVirtue.charity) (Virtue.cardinal CardinalVirtue.fortitude) ∧
    informs (Virtue.theological TheologicalVirtue.charity) (Virtue.cardinal CardinalVirtue.temperance) :=
  ⟨charity_informs_cardinal CardinalVirtue.prudence,
   charity_informs_cardinal CardinalVirtue.justice,
   charity_informs_cardinal CardinalVirtue.fortitude,
   charity_informs_cardinal CardinalVirtue.temperance⟩

-- ============================================================================
-- ## Denominational Positions
-- ============================================================================

/-!
### The Three-Position Spectrum

The virtue question creates a clear three-position denominational spectrum:

1. **Pelagianism** (condemned by Council of Carthage, 418 AD):
   Nature suffices for ALL virtue. Grace is helpful but not necessary.
   Formally: drop A4 (grace for perseverance) and A2 (infusion required).

2. **Catholic** (CCC §1810-1811):
   Cardinal virtues: acquirable by nature, need grace for perseverance.
   Theological virtues: require divine infusion.
   Formally: accept A1-A7.

3. **Total depravity** (Calvin, Institutes II.3):
   NO virtue is possible without grace. The Fall destroyed the capacity
   for any genuine good. Even apparently virtuous acts by the unregenerate
   are "splendid vices" (Augustine, as read by Calvin).
   Formally: reject A1 (cardinal virtues naturally acquirable).
-/

/-- The Catholic position excludes Pelagianism: grace IS needed for
    perseverance (§1811).
    Under Catholic axioms, a Pelagian who claims fallen persons can
    persevere without grace contradicts A4 + A7.

    Source: [Council] Council of Carthage, 418 AD; CCC §1811. -/
theorem catholic_excludes_pelagianism
    (p : Person) (v : Virtue) (g : Grace)
    (h_moral : p.isMoralAgent = true)
    (h_persevere : canPersevereIn p v)
    -- Pelagian claim: perseverance without grace
    (h_pelagian : ¬ graceGiven p g) :
    False := by
  have h_wounded := universal_woundedness p h_moral
  have h_grace := grace_needed_for_perseverance p v g h_wounded h_persevere
  exact h_pelagian h_grace

/-- The Catholic position also differs from total depravity: cardinal
    virtues CAN be acquired naturally (§1810).
    Under Catholic axioms, the Calvinist claim that NO virtue is possible
    without grace is too strong — A1 says cardinal virtues are naturally
    acquirable.

    Note: the disagreement is about INITIAL ACQUISITION, not perseverance.
    Both positions agree grace is needed eventually; they disagree about
    whether any genuine good can START without it.

    Source: [CCC] §1810 vs. [Calvin] Institutes II.3. -/
theorem catholic_differs_from_total_depravity
    (p : Person) (v : CardinalVirtue)
    (h_will : p.hasFreeWill = true)
    (h_intel : p.hasIntellect = true) :
    -- Under Catholic axioms, natural acquisition of cardinal virtues is possible
    naturallyAcquired p (Virtue.cardinal v) :=
  cardinal_naturally_acquirable p v h_will h_intel

-- ============================================================================
-- ## Bridge to Freedom.lean
-- ============================================================================

/-!
### Connection to Teleological Freedom

Freedom.lean establishes that freedom is ordered toward the good (S7).
Virtue is the habitual disposition to do the good (§1803). Therefore
virtue is the STABLE REALIZATION of what freedom aims at.

The connection: virtue is to freedom what flourishing is to capacity.
Freedom provides the capacity for good; virtue is the actualization
of that capacity into a stable disposition.
-/

/-- Virtue connects to teleological freedom: a person with virtue who is
    oriented toward the good has positive freedom.

    Derivation: Freedom.lean's good_increases_freedom says orientation
    toward good implies positive freedom level. A virtuous person, being
    habitually disposed to the good, satisfies this condition.

    Source: [CCC] §1803 + §1733 (virtue as habitual good + "the more one
    does what is good, the freer one becomes"). -/
theorem virtue_increases_freedom
    (fd : FreedomDegree)
    (h_oriented : fd.orientedToGood) :
    fd.level > 0 :=
  Catlib.MoralTheology.good_increases_freedom fd h_oriented

-- ============================================================================
-- ## Denominational Tags
-- ============================================================================

/-- The cardinal/theological distinction: broadly ecumenical.
    All Christians recognize some version of this distinction, though
    they may describe it differently. -/
def virtue_distinction_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "Cardinal/theological distinction broadly shared; specific claims about grace vary" }

/-- The §1811 claim (grace for perseverance): Catholic distinctive.
    This is the PRECISE point where the Catholic position separates
    from both Pelagianism and total depravity. -/
def grace_for_perseverance_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "CCC §1811; nuanced middle between Pelagianism and total depravity" }

/-- Theological virtues require infusion: broadly ecumenical.
    Both Catholic and Protestant traditions agree that faith, hope,
    and charity come from God, not from human effort alone. -/
def theological_infusion_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "All traditions agree theological virtues are gifts of God" }

end Catlib.MoralTheology.Virtues
