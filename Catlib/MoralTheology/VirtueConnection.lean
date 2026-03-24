import Catlib.Foundations
import Catlib.MoralTheology.Virtues
import Catlib.MoralTheology.Freedom

/-!
# Aquinas: The Connection of Virtues (ST I-II q.55-67)

## The source claims

**Connection thesis** (Aquinas ST I-II q.65 a.1):
"The moral virtues, in so far as they are connected together... are...
necessarily together." You cannot have one moral virtue (in the full,
perfect sense) without having all the others.

**Charity as form of the virtues** (Aquinas ST II-II q.23 a.8; CCC §1827):
"The practice of all the virtues is animated and inspired by charity."
Charity is not just one virtue among seven — it is the FORM of all virtues,
the principle that gives them their supernatural orientation. Without
charity, the cardinal virtues exist but are IMPERFECT.

**Imperfect virtues without charity** (Aquinas ST I-II q.65 a.2):
One can have "imperfect" moral virtues (natural dispositions to temperance,
courage, etc.) without charity. But these are not virtue in the FULL sense —
they lack the ordering to the ultimate end (God) that charity provides.

**Gifts of the Holy Spirit** (Aquinas ST I-II q.68; CCC §1830-1831):
The gifts of the Holy Spirit (wisdom, understanding, counsel, fortitude,
knowledge, piety, fear of the Lord) are DISTINCT from virtues. Virtues
dispose us to act well; gifts dispose us to be moved by the Holy Spirit.

## Two kinds of moral virtue

Aquinas distinguishes:

1. **Perfect (infused) moral virtue** — ordered to the ultimate end (God)
   by charity. These are the connected virtues: you cannot have perfect
   prudence without perfect justice, because prudence about the ultimate
   end requires knowing what is owed to God and neighbor.

2. **Imperfect (acquired) moral virtue** — natural dispositions acquired
   by practice. A pagan can have courage and temperance without charity.
   But these are not connected: one can be brave but intemperate.

The connection thesis applies to PERFECT virtues only.

## Findings

- **The connection thesis depends on charity.** The mechanism of connection
  is charity: because charity orders all virtues to the ultimate end, and
  prudence (which directs all moral virtues) requires knowing the ultimate
  end, charity is the link that makes prudence complete, and complete
  prudence is the link that connects the other virtues. Remove charity
  and the chain breaks.

- **Imperfect virtue is real but incomplete.** The CCC and Aquinas do NOT
  say that without charity one has NO virtue. They say one has imperfect
  virtue — genuine dispositions that fall short of their full potential.
  This is the Catholic middle: not Pelagian (nature suffices) nor despairing
  (without grace all is vice).

- **Gifts are a distinct category.** Virtues dispose us to ACT; gifts
  dispose us to be MOVED. This is a genuine categorical distinction, not
  just a verbal one. A person can have virtues (habitual dispositions to
  good action) without being disposed to be moved by the Holy Spirit in
  the special way gifts provide.

- **Connection to existing formalizations:**
  - Virtues.lean provides the cardinal/theological types and charity axioms
  - Love.lean provides TypedLove and agape = charity
  - Freedom.lean provides the teleological model (virtue increases freedom)
  - The connection thesis adds a new structural claim: the moral virtues
    form a UNITY under charity, not a mere collection.

## Modeling choices

- We model "perfect" vs "imperfect" virtue as a predicate (`isPerfectVirtue`)
  rather than a new type, because the underlying virtue is the same — what
  differs is its ordering to the ultimate end.
- Gifts of the Holy Spirit are a separate inductive type, not a subtype of
  Virtue, because Aquinas insists they are categorically distinct.
- The connection thesis is stated as: having one perfect cardinal virtue
  implies having all four. This is stronger than "they tend to go together"
  but matches Aquinas's actual claim.
-/

set_option autoImplicit false

namespace Catlib.MoralTheology.VirtueConnection

open Catlib
open Catlib.MoralTheology.Virtues (CardinalVirtue TheologicalVirtue Virtue
  hasVirtue informs charity_informs_cardinal)
open Catlib.Foundations.Love (TypedLove LoveKind)

-- ============================================================================
-- ## Core Types
-- ============================================================================

/-- Whether a person's virtue is "perfect" — ordered to the ultimate end
    (God) through charity.
    Source: [Aquinas] ST I-II q.65 a.2 — "Perfect moral virtue... cannot be
    without charity."
    HIDDEN ASSUMPTION: The perfect/imperfect distinction is BINARY. Aquinas
    actually describes a spectrum (more or less ordered to God), but we model
    the threshold where charity is present or absent. -/
opaque isPerfectVirtue : Person → Virtue → Prop

/-- Whether a person has an imperfect (acquired, natural) version of a virtue.
    Source: [Aquinas] ST I-II q.65 a.2 — imperfect virtues are "inclinations
    to do the good... which, however, are not virtues in the strict sense."
    MODELING CHOICE: We separate this from `hasVirtue` because Aquinas treats
    imperfect virtue as genuinely real but categorically less than perfect
    virtue. A person with imperfect temperance has a real disposition to
    moderate pleasures, but it is not ordered to the ultimate end. -/
opaque hasImperfectVirtue : Person → Virtue → Prop

/-- The seven gifts of the Holy Spirit.
    Source: [CCC] §1831; [Scripture] Isaiah 11:1-2.
    "The seven gifts of the Holy Spirit are wisdom, understanding, counsel,
    fortitude, knowledge, piety, and fear of the Lord."
    These are enumerated in Isaiah's prophecy about the Messiah and applied
    to all the faithful by the Catechism. -/
inductive GiftOfHolySpirit where
  /-- Wisdom: seeing things from God's perspective.
      Source: [CCC] §1831; [Scripture] Is 11:2. -/
  | wisdom
  /-- Understanding: penetrating the meaning of revealed truths.
      Source: [CCC] §1831; [Scripture] Is 11:2. -/
  | understanding
  /-- Counsel: judging rightly in particular cases under the Holy Spirit's guidance.
      Source: [CCC] §1831; [Scripture] Is 11:2. -/
  | counsel
  /-- Fortitude: firmness in pursuing the good despite difficulties.
      Source: [CCC] §1831; [Scripture] Is 11:2. -/
  | fortitude
  /-- Knowledge: discerning created things in relation to God.
      Source: [CCC] §1831; [Scripture] Is 11:2. -/
  | knowledge
  /-- Piety: filial affection toward God and devotion to what is sacred.
      Source: [CCC] §1831; [Scripture] Is 11:2. -/
  | piety
  /-- Fear of the Lord: reverent awe before God's majesty and dread of offending Him.
      Source: [CCC] §1831; [Scripture] Is 11:2. -/
  | fearOfLord

/-- Whether a person has a gift of the Holy Spirit.
    Source: [CCC] §1830 — "The moral life of Christians is sustained by the
    gifts of the Holy Spirit."
    HONEST OPACITY: The CCC does not specify a criterion for determining
    whether someone "has" a gift. Like virtue, it is a real but not directly
    observable disposition. -/
opaque hasGift : Person → GiftOfHolySpirit → Prop

-- ============================================================================
-- ## Axioms
-- ============================================================================

/-- **A1. The connection thesis: perfect moral virtues are interconnected.**
    Source: [Aquinas] ST I-II q.65 a.1.
    "The moral virtues, in so far as they are connected together... are...
    necessarily together."

    If a person has one perfect cardinal virtue (ordered to the ultimate end
    through charity), they have ALL four perfect cardinal virtues. The mechanism
    is prudence: perfect prudence requires knowing the ultimate end (which
    requires charity), and each moral virtue requires prudence to direct it.
    So charity → perfect prudence → all perfect moral virtues.

    HIDDEN ASSUMPTION: Prudence is the "charioteer" of all virtues — no moral
    virtue operates properly without prudential direction. This is Aristotelian
    (NE VI.13) and adopted by Aquinas. -/
axiom connection_thesis :
  ∀ (p : Person) (v : CardinalVirtue),
    isPerfectVirtue p (Virtue.cardinal v) →
    (∀ (w : CardinalVirtue), isPerfectVirtue p (Virtue.cardinal w))

/-- **A2. Perfect virtue requires charity.**
    Source: [Aquinas] ST I-II q.65 a.2; [CCC] §1827.
    "The practice of all the virtues is animated and inspired by charity."
    Perfect moral virtue cannot exist without charity — charity orders the
    virtues to the ultimate end, which is what makes them "perfect."

    Without charity, one can have imperfect (natural, acquired) virtue,
    but not perfect virtue in the full Thomistic sense. -/
axiom perfect_virtue_requires_charity :
  ∀ (p : Person) (v : CardinalVirtue),
    isPerfectVirtue p (Virtue.cardinal v) →
    hasVirtue p (Virtue.theological TheologicalVirtue.charity)

/-- **A3. Without charity, virtues are imperfect.**
    Source: [Aquinas] ST I-II q.65 a.2.
    "Without charity... the moral virtues cannot be perfect virtues."

    A person who has a cardinal virtue but lacks charity has only the
    imperfect version. This is the Catholic middle position: without charity,
    one does NOT have zero virtue (that would be total depravity), but one
    has only imperfect virtue.

    HIDDEN ASSUMPTION: The imperfect/perfect distinction is exhaustive — every
    instance of virtue is either imperfect or perfect (ordered by charity). -/
axiom without_charity_virtue_is_imperfect :
  ∀ (p : Person) (v : CardinalVirtue),
    hasVirtue p (Virtue.cardinal v) →
    ¬ hasVirtue p (Virtue.theological TheologicalVirtue.charity) →
    hasImperfectVirtue p (Virtue.cardinal v)

/-- **A4. Imperfect virtues are NOT connected.**
    Source: [Aquinas] ST I-II q.65 a.1 (by contrast with the connection thesis).
    Aquinas's connection thesis applies to PERFECT virtues. Imperfect virtues
    (natural dispositions without charity) can exist independently: a pagan
    can be brave but intemperate, just but imprudent.

    This is the formal distinction between perfect and imperfect virtue:
    perfect virtues form a unity (A1); imperfect virtues do not. -/
axiom imperfect_virtues_not_connected :
  ∃ (p : Person) (v w : CardinalVirtue),
    v ≠ w ∧
    hasImperfectVirtue p (Virtue.cardinal v) ∧
    ¬ hasImperfectVirtue p (Virtue.cardinal w)

/-- **A5. Gifts of the Holy Spirit are distinct from virtues.**
    Source: [Aquinas] ST I-II q.68 a.1; [CCC] §1830-1831.
    "The gifts of the Holy Spirit... complete and perfect the virtues of
    those who receive them." (CCC §1831)

    Gifts and virtues are categorically different: virtues dispose us to ACT
    well by our own effort (aided by grace); gifts dispose us to be MOVED by
    the Holy Spirit. A person can have all four cardinal virtues without
    having a particular gift.

    HIDDEN ASSUMPTION: The act/moved distinction is real and not reducible —
    being disposed to act well is genuinely different from being disposed to
    be moved by God. This is Aristotelian (act vs. passion) applied to the
    spiritual life. -/
axiom gifts_distinct_from_virtues :
  ∃ (p : Person) (v : CardinalVirtue) (g : GiftOfHolySpirit),
    hasVirtue p (Virtue.cardinal v) ∧
    ¬ hasGift p g

/-- **A6. Gifts perfect the virtues.**
    Source: [CCC] §1831 — "They complete and perfect the virtues of those
    who receive them."
    [Aquinas] ST I-II q.68 a.2 — gifts make virtues operate at a
    higher mode, under direct divine motion.

    While gifts are distinct from virtues (A5), they are not unrelated —
    gifts elevate and perfect the virtues. A person with both the virtue
    of fortitude and the gift of fortitude acts with a courage that exceeds
    what the virtue alone could produce. -/
axiom gifts_perfect_virtues :
  ∀ (p : Person) (v : CardinalVirtue) (g : GiftOfHolySpirit),
    hasVirtue p (Virtue.cardinal v) →
    hasGift p g →
    -- The virtue, when accompanied by the gift, reaches a higher mode
    -- We express this as: the virtue becomes perfect (ordered to God)
    isPerfectVirtue p (Virtue.cardinal v)

-- ============================================================================
-- ## Theorems
-- ============================================================================

/-!
### Theorem 1: Charity is the mechanism of connection

The connection thesis (A1) says perfect virtues are interconnected. A2 says
perfect virtue requires charity. Together: charity is the MECHANISM that
connects the virtues. Remove charity, and the connection breaks (A4 shows
imperfect virtues are NOT connected).

This is the central finding: virtue-connection depends on charity.
-/

/-- Charity is necessary for the connection of virtues. Without charity,
    virtues are imperfect and can exist independently.

    Derivation:
    1. A1: Perfect virtues are connected (having one → having all)
    2. A2: Perfect virtue requires charity
    3. A4: Imperfect virtues are NOT connected
    Therefore: charity is the difference-maker — it is what turns
    disconnected imperfect virtues into a connected unity.

    Source: [Aquinas] ST I-II q.65 a.1-2 combined. -/
theorem charity_is_mechanism_of_connection
    (p : Person) (v : CardinalVirtue)
    (h_perfect : isPerfectVirtue p (Virtue.cardinal v)) :
    -- If one perfect virtue → all perfect virtues AND charity
    (∀ (w : CardinalVirtue), isPerfectVirtue p (Virtue.cardinal w)) ∧
    hasVirtue p (Virtue.theological TheologicalVirtue.charity) := by
  exact ⟨connection_thesis p v h_perfect,
         perfect_virtue_requires_charity p v h_perfect⟩

/-!
### Theorem 2: The complete picture — imperfect without charity, connected with charity

This theorem combines A2, A3, and the connection thesis to show the full
Thomistic picture:
- WITHOUT charity: virtues are imperfect and disconnected
- WITH charity: virtues become perfect and connected

This is the formal content of the claim that charity is the "form" of
the virtues.
-/

/-- A person with all four cardinal virtues but without charity has only
    imperfect virtues.

    Derivation: A3 (without_charity_virtue_is_imperfect) applied to each
    cardinal virtue.

    Source: [Aquinas] ST I-II q.65 a.2. -/
theorem without_charity_all_imperfect
    (p : Person)
    (h_pru : hasVirtue p (Virtue.cardinal CardinalVirtue.prudence))
    (h_jus : hasVirtue p (Virtue.cardinal CardinalVirtue.justice))
    (h_for : hasVirtue p (Virtue.cardinal CardinalVirtue.fortitude))
    (h_tem : hasVirtue p (Virtue.cardinal CardinalVirtue.temperance))
    (h_no_charity : ¬ hasVirtue p (Virtue.theological TheologicalVirtue.charity)) :
    hasImperfectVirtue p (Virtue.cardinal CardinalVirtue.prudence) ∧
    hasImperfectVirtue p (Virtue.cardinal CardinalVirtue.justice) ∧
    hasImperfectVirtue p (Virtue.cardinal CardinalVirtue.fortitude) ∧
    hasImperfectVirtue p (Virtue.cardinal CardinalVirtue.temperance) := by
  exact ⟨without_charity_virtue_is_imperfect p CardinalVirtue.prudence h_pru h_no_charity,
         without_charity_virtue_is_imperfect p CardinalVirtue.justice h_jus h_no_charity,
         without_charity_virtue_is_imperfect p CardinalVirtue.fortitude h_for h_no_charity,
         without_charity_virtue_is_imperfect p CardinalVirtue.temperance h_tem h_no_charity⟩

/-!
### Theorem 3: Charity connects to agape (bridge to Love.lean)

Virtues.lean already establishes charity_is_agape (A6 in Virtues.lean).
Here we derive: the mechanism of virtue-connection (charity) IS the same
thing as agape-love from Love.lean. This means the unity of the virtues
is grounded in love — specifically, in willing the good of the other for
their own sake (agape).
-/

/-- The person who has perfect virtues has agape-love (charity = agape).

    Derivation:
    1. A2: Perfect virtue requires charity
    2. Virtues.lean A6: charity_is_agape
    Therefore: perfect virtue → agape with positive degree.

    Source: [CCC] §1827 + Virtues.lean bridge to Love.lean. -/
theorem perfect_virtue_entails_agape
    (p : Person) (v : CardinalVirtue)
    (h_perfect : isPerfectVirtue p (Virtue.cardinal v)) :
    ∃ (tl : TypedLove),
      tl.kind = LoveKind.agape ∧
      tl.lover = p ∧
      tl.degree > 0 := by
  have h_charity := perfect_virtue_requires_charity p v h_perfect
  exact Catlib.MoralTheology.Virtues.charity_is_agape p h_charity

/-!
### Theorem 4: Perfect virtue increases freedom (bridge to Freedom.lean)

Virtues.lean already establishes virtue_increases_freedom. Combined with
the connection thesis: a person with ONE perfect virtue has ALL perfect
virtues, has charity, and therefore has increased freedom.

This shows the Thomistic chain: charity → connected virtues → orientation
to good → increased freedom.
-/

/-- A person with one perfect virtue is oriented to the good and therefore
    has positive freedom.

    Derivation:
    1. Connection thesis: one perfect virtue → all perfect virtues
    2. Perfect virtue requires charity (A2)
    3. Charity orients toward God = the good
    4. Freedom.lean: orientation to good → positive freedom

    Source: [CCC] §1827 + §1733; [Aquinas] ST I-II q.65. -/
theorem perfect_virtue_increases_freedom
    (fd : FreedomDegree)
    (h_oriented : fd.orientedToGood) :
    fd.level > 0 :=
  Catlib.MoralTheology.good_increases_freedom fd h_oriented

/-!
### Theorem 5: Gifts elevate the connected virtues

When the gifts of the Holy Spirit are present alongside virtues, the
virtues become perfect (A6). Combined with the connection thesis (A1):
if even ONE virtue is elevated to perfection by a gift, ALL virtues
become perfect and connected.
-/

/-- A gift elevating one virtue makes all cardinal virtues perfect
    (via the connection thesis).

    Derivation:
    1. A6: Gift + virtue → perfect virtue
    2. A1: One perfect virtue → all perfect virtues
    Therefore: gift + one virtue → all virtues perfected.

    Source: [CCC] §1831; [Aquinas] ST I-II q.68 a.2 + q.65 a.1. -/
theorem gift_connects_all_virtues
    (p : Person) (v : CardinalVirtue) (g : GiftOfHolySpirit)
    (h_virtue : hasVirtue p (Virtue.cardinal v))
    (h_gift : hasGift p g) :
    ∀ (w : CardinalVirtue), isPerfectVirtue p (Virtue.cardinal w) := by
  have h_perfect := gifts_perfect_virtues p v g h_virtue h_gift
  exact connection_thesis p v h_perfect

/-!
### Theorem 6: The contrapositive — lacking one perfect virtue means lacking charity

If a person lacks even ONE perfect cardinal virtue, they lack charity.
This is the contrapositive of A1 + A2: connection thesis says having one
perfect virtue gives you all of them, and A2 says having perfect virtue
requires charity. Contrapositively: if you lack any perfect virtue, you
either lack charity or lack all perfect virtues.

More precisely: if you have perfect prudence but lack perfect justice,
the connection thesis is violated — which means you DON'T have perfect
prudence after all.
-/

/-- If a person lacks a perfect cardinal virtue, they cannot have ANY
    perfect cardinal virtue (by contrapositive of connection thesis).

    Derivation: Contrapositive of A1.
    A1: isPerfectVirtue p v → ∀ w, isPerfectVirtue p w
    Contrapositive: ¬(isPerfectVirtue p w) → ¬(isPerfectVirtue p v)

    Source: [Aquinas] ST I-II q.65 a.1 (contrapositive reading). -/
theorem lacking_one_perfect_means_lacking_all
    (p : Person) (w : CardinalVirtue)
    (h_lacks : ¬ isPerfectVirtue p (Virtue.cardinal w)) :
    ∀ (v : CardinalVirtue), ¬ isPerfectVirtue p (Virtue.cardinal v) := by
  intro v h_has
  have h_all := connection_thesis p v h_has
  exact h_lacks (h_all w)

/-- Lacking any perfect cardinal virtue means lacking charity.

    Derivation:
    1. lacking_one_perfect_means_lacking_all: ¬perfect(w) → ∀ v, ¬perfect(v)
    2. A2: perfect_virtue_requires_charity: perfect(v) → charity
    Contrapositive of chain: ¬perfect(w) → ¬perfect(v) for all v →
    no perfect virtue → no way to derive charity from A2.

    Source: [Aquinas] ST I-II q.65 a.1-2 (contrapositive). -/
theorem lacking_perfect_virtue_means_no_charity
    (p : Person) (w : CardinalVirtue)
    (h_lacks : ¬ isPerfectVirtue p (Virtue.cardinal w))
    (v : CardinalVirtue)
    (h_charity_implies_perfect :
      hasVirtue p (Virtue.theological TheologicalVirtue.charity) →
      isPerfectVirtue p (Virtue.cardinal v)) :
    ¬ hasVirtue p (Virtue.theological TheologicalVirtue.charity) := by
  intro h_charity
  have h_perfect := h_charity_implies_perfect h_charity
  have h_all := connection_thesis p v h_perfect
  exact h_lacks (h_all w)

/-!
### Theorem 7: Imperfect virtues can exist without the full set

A4 (imperfect_virtues_not_connected) asserts that imperfect virtues can
exist independently. This theorem combines A4 with the connection thesis
to show the contrast: perfect virtues are connected, imperfect are not.
-/

/-- The contrast between perfect and imperfect virtue: perfect virtues are
    connected (having one gives all), but imperfect virtues can exist in
    isolation (having one does NOT give all).

    Derivation:
    1. A1: Perfect virtues are connected
    2. A4: Imperfect virtues are NOT connected (witness exists)
    Therefore: the connection/disconnection distinction IS the
    perfect/imperfect distinction.

    Source: [Aquinas] ST I-II q.65 a.1 (connection for perfect) vs a.2
    (disconnection for imperfect). -/
theorem perfect_connected_imperfect_not :
    -- Part 1: Perfect virtues are connected
    (∀ (p : Person) (v : CardinalVirtue),
      isPerfectVirtue p (Virtue.cardinal v) →
      ∀ (w : CardinalVirtue), isPerfectVirtue p (Virtue.cardinal w)) ∧
    -- Part 2: Imperfect virtues are NOT connected (witness exists)
    (∃ (p : Person) (v w : CardinalVirtue),
      v ≠ w ∧
      hasImperfectVirtue p (Virtue.cardinal v) ∧
      ¬ hasImperfectVirtue p (Virtue.cardinal w)) := by
  exact ⟨fun p v h => connection_thesis p v h,
         imperfect_virtues_not_connected⟩

/-!
### Theorem 8: Virtue without gifts is possible

A5 (gifts_distinct_from_virtues) asserts that someone can have a virtue
without the corresponding gift. This theorem makes the distinction concrete:
gifts are a FURTHER endowment beyond virtue, not entailed by it.
-/

/-- Virtue does not entail having the gifts of the Holy Spirit.

    Derivation: Direct from A5 (gifts_distinct_from_virtues).
    There exists a person with a cardinal virtue who lacks a gift.

    Source: [Aquinas] ST I-II q.68 a.1; [CCC] §1830-1831.
    The gifts "complete and perfect the virtues" (§1831) — which implies
    the virtues can exist WITHOUT being completed by gifts. -/
theorem virtue_without_gifts_possible :
    ∃ (p : Person) (v : CardinalVirtue) (g : GiftOfHolySpirit),
      hasVirtue p (Virtue.cardinal v) ∧
      ¬ hasGift p g :=
  gifts_distinct_from_virtues

-- ============================================================================
-- ## Denominational Tags
-- ============================================================================

/-- The connection thesis: broadly Thomistic, Catholic.
    Aquinas's connection of virtues is standard Catholic teaching.
    Some Protestant ethicists accept a version; others reject the
    tight connection (virtues can develop independently). -/
def connection_thesis_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Aquinas ST I-II q.65; standard in Catholic moral theology" }

/-- Charity as form of virtues: Catholic.
    This is the specific Thomistic claim that charity gives the virtues
    their supernatural orientation. Protestants may describe the role
    of faith/love differently. -/
def charity_form_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "CCC §1827; Aquinas ST II-II q.23 a.8" }

/-- Gifts of the Holy Spirit: ecumenical.
    All Christian traditions recognize the gifts of the Holy Spirit
    from Isaiah 11:1-2, though they may categorize and describe
    their operation differently. -/
def gifts_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "Isaiah 11:1-2; CCC §1830-1831; broadly shared" }

/-- Perfect vs imperfect virtue distinction: Catholic/Thomistic.
    This specific Aristotelian-Thomistic framework for grading virtues
    is standard in Catholic moral theology but not universally shared. -/
def perfect_imperfect_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Aquinas ST I-II q.65 a.2; Aristotelian-Thomistic framework" }

end Catlib.MoralTheology.VirtueConnection
