import Catlib.Foundations
import Catlib.Creed.OriginalSin
import Catlib.Creed.Soul
import Catlib.MoralTheology.TheologyOfBody

/-!
# CCC §374-379: Original Justice — What Was Lost in the Fall

## The Catechism claims

§374: "The first man was not only created good, but was also established
in friendship with his Creator."

§375: "By the radiance of this grace all dimensions of man's life were
confirmed."

§376: "Man would not have to suffer or die. The inner harmony of the
human person, the harmony between man and woman, and finally the harmony
between the first couple and all of creation, comprised the state called
'original justice.'"

§377: "The 'mastery' over the world that God had offered man from the
beginning was realized above all within man himself: mastery of self."

§378: "The sign of man's familiarity with God is that God places him in
the garden."

§379: "All of this harmony of original justice, foreseen for man in
God's plan, will be lost by the sin of our first parents."

§400: "The harmony in which they had found themselves... is now
destroyed: the control of the soul's spiritual faculties over the body
is shattered; the union of man and woman becomes subject to tensions;
their relations will be marked by lust and domination."

## What we formalize

**Four harmonies** (§376): with God, with self, with others, with creation.
These are the CCC's own structure — four distinct relationships, each
harmonious before the Fall, each broken after it.

**Preternatural gifts** (§376-377): freedom from suffering, death, and
concupiscence. The CCC describes these as features of the original state
but does not decide whether they were NATURAL (owed to human nature) or
SUPERNATURAL (gratuitous additions from grace).

**The Fall broke all four** (§379, §400).

**The Thomistic vs. Baian question**: Were preternatural gifts natural
or supernatural? This is the key open question:
- **Thomistic answer** (ST I q.95, Trent): supernatural additions →
  grace RESTORES what was a gift, not what was owed.
- **Baian answer** (condemned, DS 1901-1980): natural endowments →
  grace HEALS what was naturally owed.
This distinction matters: if the gifts were natural, God owes their
restoration; if supernatural, restoration is pure mercy.

## Hidden assumptions

- The four harmonies are genuinely distinct (the CCC lists them
  separately but does not argue they are irreducible).
- Preternatural gifts can be meaningfully classified as natural vs.
  supernatural (a philosophical framework the CCC inherits but does
  not itself articulate).

## Modeling choices

- We model harmonies as opaque predicates on Person × domain. The CCC
  does not specify the internal structure of "harmony."
- We model the natural/supernatural distinction as a binary classification.
  In reality, Thomistic thought has more nuance (the "natural desire for
  the supernatural" debate), but the CCC does not enter that territory.
- We reuse `AnthropologicalState` from TheologyOfBody.lean for the
  before/after transition.

## Connections

- **OriginalSin.lean**: the_fall, original_integrity — what the Fall did
  to human nature. OriginalJustice describes what was THERE; OriginalSin
  describes what HAPPENED to it.
- **SinEffects.lean**: the three layers of sin's effects correspond to
  the loss of harmonies (original wound = loss of all four harmonies).
- **Freedom.lean**: wounded freedom is the loss of harmony with self
  (mastery of self, §377).
- **HumanNature.lean**: the OriginalWounds structure captures the
  specific wounds (ignorance, concupiscence, suffering, death) that
  correspond to the loss of preternatural gifts.
-/

set_option autoImplicit false

namespace Catlib.Creed.OriginalJustice

open Catlib
open Catlib.MoralTheology.TheologyOfBody
open Catlib.Creed.OriginalSin

-- ============================================================================
-- ## The Four Harmonies of Original Justice
-- ============================================================================

/-!
## The Four Harmonies

CCC §376 describes the state of original justice as comprising four
harmonies. These are the CCC's own categories — we are not inventing
them:

1. **Harmony with God** (§374): friendship, intimacy, communion
2. **Harmony with self** (§377): mastery of self, no concupiscence
3. **Harmony with others** (§378): man and woman in mutual self-gift
4. **Harmony with creation** (§378): placed in the garden, stewardship

These are genuinely distinct relationships. You can lose one without
losing the others (e.g., a hermit might have harmony with God and self
but limited harmony with others). However, the CCC claims that in the
Fall, ALL FOUR were lost simultaneously (§379).
-/

/-- The four domains of harmony in original justice (CCC §376-378).
    MODELING CHOICE: We treat these as an enumeration. The CCC lists
    them as distinct relationships; we formalize that distinction. -/
inductive HarmonyDomain where
  /-- Harmony with God — friendship, communion (§374) -/
  | withGod
  /-- Harmony with self — mastery, no concupiscence (§377) -/
  | withSelf
  /-- Harmony with others — mutual self-gift, no domination (§378) -/
  | withOthers
  /-- Harmony with creation — stewardship, not exploitation (§378) -/
  | withCreation
  deriving DecidableEq, BEq

/-- Whether a person has harmony in a given domain.
    Opaque because the CCC describes the harmonies qualitatively
    without defining their internal structure.

    HONEST OPACITY: The CCC says "harmony" without specifying what
    makes a relationship harmonious vs. disharmonious. We track the
    CCC's own vagueness rather than inventing a definition. -/
opaque hasHarmony : Person → HarmonyDomain → AnthropologicalState → Prop

-- ============================================================================
-- ## Preternatural Gifts
-- ============================================================================

/-!
## Preternatural Gifts (CCC §376-377)

The CCC describes three gifts that Adam and Eve possessed before the
Fall. These are traditionally called "preternatural" — beyond what
natural powers alone provide, but below the strictly supernatural
(beatific vision).

§376: "would not have to suffer or die"
§377: "mastery of self" (no concupiscence)
-/

/-- The preternatural gifts of the original state (CCC §376-377).
    These are the specific immunities that characterize original justice
    beyond the four harmonies.

    MODELING CHOICE: We list the three gifts the CCC explicitly names.
    Thomistic tradition sometimes adds others (e.g., infused knowledge),
    but we stick to what the CCC says. -/
inductive PreternaturalGift where
  /-- Freedom from suffering (§376: "would not have to suffer") -/
  | freedomFromSuffering
  /-- Freedom from death (§376: "would not have to die") -/
  | freedomFromDeath
  /-- Freedom from concupiscence (§377: "mastery of self") -/
  | freedomFromConcupiscence
  deriving DecidableEq, BEq

/-- Whether a person possesses a given preternatural gift in a given state.
    Opaque because the CCC does not define the mechanism by which these
    gifts operated — only that they were present before the Fall.

    HONEST OPACITY: The CCC asserts the gifts existed without explaining
    how (e.g., how exactly was death prevented?). -/
opaque hasGift : Person → PreternaturalGift → AnthropologicalState → Prop

-- ============================================================================
-- ## The Natural vs. Supernatural Classification
-- ============================================================================

/-!
## Were Preternatural Gifts Natural or Supernatural?

This is the key theological question that CCC §374-379 raises but does
not settle. The answer determines whether grace RESTORES or HEALS:

**Thomistic view** (ST I q.95 a.1; Council of Trent background):
The gifts were SUPERNATURAL additions — gratuitous, not owed to human
nature. Therefore:
- Their loss is not an INJUSTICE to human nature
- Grace restores what was a GIFT, not what was naturally owed
- Human nature without these gifts is still "intact" in its natural order

**Baian view** (condemned by Pius V, DS 1901-1980):
The gifts were NATURAL endowments — owed to human nature as created.
Therefore:
- Their loss is a DAMAGE to nature itself
- Grace heals what was naturally owed
- Human nature without these gifts is "unjustly deprived"

The condemnation of Baius (1567) settled this for Catholic theology:
the preternatural gifts were NOT owed to nature. But the formal question
— what makes something "owed to nature" vs. "gratuitous addition" —
remains a live philosophical debate.
-/

/-- Classification of whether a gift is natural (owed to nature) or
    supernatural (gratuitous addition beyond nature's requirements).

    Source: [Aquinas] ST I q.95 a.1; [Council] Pius V, DS 1901-1980.

    HIDDEN ASSUMPTION: This binary classification is meaningful — that
    there is a fact of the matter about whether a gift is "owed" to a
    nature. The CCC inherits this from Scholastic philosophy without
    arguing for it. -/
inductive GiftClassification where
  /-- The gift is owed to human nature as such — its absence would
      be a defect in nature itself. -/
  | natural
  /-- The gift is a gratuitous addition beyond what nature requires —
      its absence leaves nature intact, just without an unowed bonus. -/
  | supernatural
  deriving DecidableEq, BEq

/-- How a given tradition classifies the preternatural gifts.
    Opaque because the classification depends on one's philosophical
    framework (what counts as "owed to a nature").

    MODELING CHOICE: We make this a function from gift to classification,
    allowing different gifts to be classified differently. In practice,
    Thomism classifies ALL preternatural gifts as supernatural. -/
opaque giftClassification : PreternaturalGift → GiftClassification :=
  fun _ => GiftClassification.supernatural

-- ============================================================================
-- ## Axioms: Original Justice
-- ============================================================================

/-- **AXIOM 1 (CCC §374-376): ALL FOUR HARMONIES IN ORIGINAL STATE.**
    In the state of Original Integrity, humans possessed all four
    harmonies simultaneously. This IS what "original justice" means —
    the term is the CCC's own name for this fourfold harmony.

    "The inner harmony of the human person, the harmony between man
    and woman, and finally the harmony between the first couple and
    all of creation, comprised the state called 'original justice.'"
    (CCC §376)

    "The first man was not only created good, but was also established
    in friendship with his Creator." (CCC §374)

    Provenance: [CCC] §374-376.
    Denominational scope: ECUMENICAL — all Christians accept a state
    of original harmony before the Fall. -/
axiom all_harmonies_in_original_state :
  ∀ (p : Person) (d : HarmonyDomain),
    p.hasIntellect = true →
    hasHarmony p d AnthropologicalState.OriginalIntegrity

/-- Denominational tag: ecumenical for original harmony. -/
def all_harmonies_in_original_state_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "All Christians accept fourfold harmony before the Fall; CCC §374-376" }

/-- **AXIOM 2 (CCC §376-377): PRETERNATURAL GIFTS IN ORIGINAL STATE.**
    In the state of Original Integrity, humans possessed all three
    preternatural gifts: freedom from suffering, death, and concupiscence.

    "As long as he had remained in the divine intimacy, man would not
    have to suffer or die." (CCC §376)

    "The 'mastery' over the world that God had offered man from the
    beginning was realized above all within man himself: mastery of
    self." (CCC §377)

    Provenance: [CCC] §376-377.
    Denominational scope: ECUMENICAL — broadly shared, though the
    specifics of "preternatural" vs. "natural" gifts are debated. -/
axiom preternatural_gifts_in_original_state :
  ∀ (p : Person) (g : PreternaturalGift),
    p.hasIntellect = true →
    hasGift p g AnthropologicalState.OriginalIntegrity

/-- Denominational tag: ecumenical for the gifts' existence. -/
def preternatural_gifts_in_original_state_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "All Christians accept pre-Fall immunity from death/suffering; CCC §376-377" }

/-- **AXIOM 3 (CCC §379, §400): THE FALL BROKE ALL FOUR HARMONIES.**
    All four harmonies were lost through sin — not just one or two,
    but ALL of them simultaneously.

    "All of this harmony of original justice, foreseen for man in
    God's plan, will be lost by the sin of our first parents." (§379)

    "The harmony in which they had found themselves... is now destroyed:
    the control of the soul's spiritual faculties over the body is
    shattered; the union of man and woman becomes subject to tensions;
    their relations will be marked by lust and domination." (§400)

    This axiom is stronger than saying "some harmonies were lost" —
    it says ALL FOUR were broken. The Fall was total in scope even
    if not total in severity (nature was wounded, not destroyed).

    Provenance: [CCC] §379, §400.
    Denominational scope: ECUMENICAL — all Christians accept the
    Fall broke the original harmony. -/
axiom fall_breaks_all_harmonies :
  ∀ (p : Person) (d : HarmonyDomain),
    p.hasIntellect = true →
    ¬ hasHarmony p d AnthropologicalState.Fallen

/-- Denominational tag: ecumenical for total scope of the Fall. -/
def fall_breaks_all_harmonies_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "All Christians accept the Fall broke all harmonies; CCC §379, §400" }

/-- **AXIOM 4 (CCC §376-377; cf. §405): PRETERNATURAL GIFTS LOST IN THE FALL.**
    All three preternatural gifts were lost through sin.

    The CCC describes the fallen state as one of suffering (§405:
    "subject to suffering"), death (§405: "the dominion of death"),
    and concupiscence (§405: "inclined to sin"). These are exactly
    the negation of the three preternatural gifts.

    Provenance: [CCC] §376-377 (gifts existed), §405 (their absence
    in the fallen state).
    Denominational scope: ECUMENICAL — all Christians accept mortality,
    suffering, and concupiscence as consequences of the Fall. -/
axiom fall_removes_preternatural_gifts :
  ∀ (p : Person) (g : PreternaturalGift),
    p.hasIntellect = true →
    ¬ hasGift p g AnthropologicalState.Fallen

/-- Denominational tag: ecumenical for gift loss. -/
def fall_removes_preternatural_gifts_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "All Christians accept loss of pre-Fall gifts; CCC §405" }

/-- **AXIOM 5 ([Aquinas] ST I q.95; [Council] Trent; Pius V DS 1901-1980):
    GIFTS ARE SUPERNATURAL, NOT NATURAL.**
    The Thomistic classification, endorsed by the condemnation of Baius:
    preternatural gifts are supernatural additions, not natural endowments.

    This is the CATHOLIC DISTINCTIVE on original justice. It means:
    - The gifts were gratuitous (not owed to nature)
    - Their loss leaves nature wounded but not unjustly deprived
    - Grace RESTORES what was a gift, not what was naturally owed

    The condemned alternative (Baius, DS 1921): "The integrity of the
    first creation was not an undue exaltation of human nature but its
    natural condition." If true, the Fall would be an INJUSTICE to
    nature, and grace would be OWED rather than freely given.

    Provenance: [Aquinas] ST I q.95 a.1; [Council] Pius V condemning
    Baius (1567), DS 1901-1980; Council of Trent background theology.
    Denominational scope: CATHOLIC — this is Thomistic-Tridentine
    theology. Lutherans and Calvinists do not use this framework. -/
axiom gifts_are_supernatural :
  ∀ (g : PreternaturalGift),
    giftClassification g = GiftClassification.supernatural

/-- Denominational tag: Catholic for the supernatural classification. -/
def gifts_are_supernatural_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Catholic/Thomistic: gifts supernatural, not natural. Baius condemned (DS 1901-1980). Aquinas ST I q.95." }

-- ============================================================================
-- ## Theorems: Consequences of Original Justice
-- ============================================================================

/-- **THEOREM: Original justice is a COMPLETE state.**
    All four harmonies AND all three preternatural gifts are present
    in the original state. This combines Axioms 1 and 2 into a single
    witness of the fullness of original justice.

    CONNECTS TO: OriginalSin.lean original_integrity (the same state,
    described from the perspective of what was lost). -/
theorem original_justice_is_complete
    (p : Person)
    (h_intellect : p.hasIntellect = true) :
    -- All four harmonies
    (∀ d : HarmonyDomain, hasHarmony p d AnthropologicalState.OriginalIntegrity)
    -- AND all three preternatural gifts
    ∧ (∀ g : PreternaturalGift, hasGift p g AnthropologicalState.OriginalIntegrity) := by
  exact ⟨fun d => all_harmonies_in_original_state p d h_intellect,
         fun g => preternatural_gifts_in_original_state p g h_intellect⟩

/-- **THEOREM: The Fall is total in scope — NOTHING of original justice survives.**
    All four harmonies AND all three preternatural gifts are lost.
    This combines Axioms 3 and 4.

    Note: "total in scope" does not mean "total in severity." The
    CCC says nature is wounded, not destroyed (§405). What is total
    is the BREADTH of the damage: every relationship, every gift.

    CONNECTS TO: OriginalSin.lean the_fall (nature is wounded),
    SinEffects.lean (the three layers of sin's effects). -/
theorem fall_is_total_in_scope
    (p : Person)
    (h_intellect : p.hasIntellect = true) :
    -- All harmonies lost
    (∀ d : HarmonyDomain, ¬ hasHarmony p d AnthropologicalState.Fallen)
    -- AND all gifts lost
    ∧ (∀ g : PreternaturalGift, ¬ hasGift p g AnthropologicalState.Fallen) := by
  exact ⟨fun d => fall_breaks_all_harmonies p d h_intellect,
         fun g => fall_removes_preternatural_gifts p g h_intellect⟩

/-- **THEOREM: Grace restores what was a GIFT, not what was owed.**
    From gifts_are_supernatural: the preternatural gifts were not
    natural endowments. Therefore, when grace restores them, it is
    giving back something gratuitous — pure mercy, not justice.

    This is the theological payoff of the natural/supernatural
    distinction: it determines the CHARACTER of grace.

    If the gifts were natural (Baius), grace would be a debt.
    Since the gifts are supernatural (Thomism), grace is mercy.

    CONNECTS TO: OriginalSin.lean grace_is_the_healing (grace
    transforms/heals — and this theorem explains WHY that healing
    is merciful rather than obligatory). -/
theorem grace_restores_gift_not_debt
    (g : PreternaturalGift) :
    giftClassification g = GiftClassification.supernatural := by
  exact gifts_are_supernatural g

-- ============================================================================
-- ## The Condemned Alternative: Baius
-- ============================================================================

/-!
## The Baian Error (condemned 1567, DS 1901-1980)

Michael Baius (1513-1589) taught that the preternatural gifts were
NATURAL to humanity — that is, owed to human nature as created by God.
If true, this would mean:
- The Fall was an INJUSTICE to human nature (not just a loss of gifts)
- Grace would be OWED to humanity (restoring what is naturally due)
- The entire economy of salvation would be a matter of JUSTICE, not mercy

Pope Pius V condemned 79 propositions of Baius in "Ex omnibus
afflictionibus" (1567). Key condemned proposition:

DS 1921: "The integrity of the first creation was not an undue
exaltation of human nature but its natural condition."

This was later reinforced against Jansenism (DS 2434: Unigenitus, 1713).

## Why this matters formally

The natural/supernatural classification of preternatural gifts is not
an academic distinction. It determines whether:
- `grace_is_the_healing` (OriginalSin.lean) represents mercy or justice
- The Fall was a loss of GIFTS or a VIOLATION of nature
- Salvation is gratuitous or owed

The Thomistic framework (gifts_are_supernatural) keeps grace as mercy.
The Baian framework (gifts are natural) makes grace a debt. The Catholic
Church condemned the latter.
-/

/-- The Baian classification: gifts are natural (condemned).
    We model this as an alternative axiom that could REPLACE
    gifts_are_supernatural. A denomination that accepted Baius
    would have this instead.

    Source: [Council] Condemned by Pius V (1567), DS 1921. -/
def baian_classification (g : PreternaturalGift) : Prop :=
  giftClassification g = GiftClassification.natural

/-- **THEOREM: Thomism and Baianism are contradictory.**
    If gifts_are_supernatural holds, then the Baian classification
    is false for every gift. You cannot hold both.

    This is the formal content of the condemnation: the Catholic
    axiom set (gifts_are_supernatural) is incompatible with the
    Baian axiom (gifts are natural). -/
theorem thomism_contradicts_baius
    (g : PreternaturalGift) :
    ¬ baian_classification g := by
  unfold baian_classification
  rw [gifts_are_supernatural g]
  exact fun h => by cases h

-- ============================================================================
-- ## Connection: Original Justice and Original Sin
-- ============================================================================

/-!
## How OriginalJustice relates to OriginalSin

OriginalSin.lean formalizes WHAT HAPPENED (the Fall wounded nature).
OriginalJustice.lean formalizes WHAT WAS THERE (the four harmonies
and preternatural gifts that constituted original justice).

The two files are complementary:
- OriginalSin says: nature is wounded, supernatural end unreachable
- OriginalJustice says: four harmonies lost, three gifts lost

OriginalSin's `the_fall` and OriginalJustice's `fall_breaks_all_harmonies`
describe the same event from different angles:
- `the_fall`: focuses on the WOUND to nature's powers
- `fall_breaks_all_harmonies`: focuses on the RELATIONSHIPS broken
-/

/-- **THEOREM: The Fall wounds nature AND breaks all harmonies.**
    Combines OriginalSin.lean's `the_fall` with this file's
    `fall_breaks_all_harmonies` to show the FULL picture of what
    the Fall did: both internal damage and relational rupture.

    CONNECTS TO: OriginalSin.lean the_fall, HumanNature.lean
    fallenNature. -/
theorem fall_complete_picture
    (p : Person)
    (h_intellect : p.hasIntellect = true) :
    -- Nature is wounded (from OriginalSin)
    natureIsWounded p
    -- AND all harmonies are broken (from this file)
    ∧ (∀ d : HarmonyDomain, ¬ hasHarmony p d AnthropologicalState.Fallen) := by
  exact ⟨(the_fall p h_intellect).1,
         fun d => fall_breaks_all_harmonies p d h_intellect⟩

-- ============================================================================
-- ## Connection: Harmonies and the Three Layers of Sin
-- ============================================================================

/-!
## Mapping harmonies to sin effects (SinEffects.lean)

The four harmonies map suggestively to the sin-effect model:

| Harmony lost      | Sin effect        | CCC |
|-------------------|-------------------|-----|
| With God          | Layer 2 (guilt)   | §1472: "deprives us of communion with God" |
| With self         | Layer 1 (wound)   | §405: "inclined to sin — concupiscence" |
| With others       | Layer 3 (attachment) | §400: "lust and domination" |
| With creation     | Layer 1 (wound)   | §400: "harmony is broken" |

This mapping is APPROXIMATE — the CCC does not explicitly align the
four harmonies with the three layers. But the correspondence is
suggestive: the loss of harmony with God IS the loss of communion
(Layer 2), and the loss of harmony with self IS concupiscence
(Layer 1 / OriginalWounds).

MODELING CHOICE: We note this correspondence in documentation but do
not axiomatize it, because the CCC does not make this mapping explicit.
-/

-- ============================================================================
-- ## Connection: Preternatural Gifts and OriginalWounds
-- ============================================================================

/-!
## Preternatural gifts and the wounds of §405

The three preternatural gifts correspond exactly to the wounds named
in §405 (formalized in HumanNature.lean as `OriginalWounds`):

| Gift lost                    | Wound gained          | CCC §405 |
|------------------------------|----------------------|----------|
| Freedom from suffering       | Subject to suffering | ✓        |
| Freedom from death           | Dominion of death    | ✓        |
| Freedom from concupiscence   | Inclined to sin      | ✓        |

Plus §405 names a fourth wound — ignorance — which does not correspond
to a named preternatural gift (though Thomistic tradition includes
"infused knowledge" as an additional preternatural gift, the CCC does
not explicitly list it among the gifts of §376-377).

The formal connection: the ABSENCE of each preternatural gift in the
Fallen state (fall_removes_preternatural_gifts) is the PRESENCE of
the corresponding wound in HumanNature.lean's fallenNature.
-/

/-- **THEOREM: HumanNature's fallenNature has the wounds that correspond
    to the lost preternatural gifts.**
    The fallenNature definition in HumanNature.lean explicitly sets
    suffering, death, and concupiscence to True — matching exactly
    the three preternatural gifts that fall_removes_preternatural_gifts
    says are lost.

    CONNECTS TO: HumanNature.lean fallenNature, OriginalWounds. -/
theorem fallen_nature_has_wounds (p : Person) :
    (fallenNature p).wounds.suffering
    ∧ (fallenNature p).wounds.death
    ∧ (fallenNature p).wounds.concupiscence := by
  simp [fallenNature]

/-- **THEOREM: Original integrity has NO wounds — matching the presence
    of all preternatural gifts.**

    CONNECTS TO: HumanNature.lean originalIntegrity, OriginalWounds. -/
theorem original_integrity_has_no_wounds (p : Person) :
    ¬ (originalIntegrity p).wounds.suffering
    ∧ ¬ (originalIntegrity p).wounds.death
    ∧ ¬ (originalIntegrity p).wounds.concupiscence := by
  simp [originalIntegrity]

-- ============================================================================
-- ## Connection: Harmony with Self and Freedom
-- ============================================================================

/-!
## Harmony with self = mastery = freedom (§377, §1705)

CCC §377 describes harmony with self as "mastery of self." This is
exactly what Freedom.lean models: the capacity for self-governance
that evil diminishes and good increases.

The loss of harmony with self (fall_breaks_all_harmonies for withSelf)
IS the wounding of freedom that Freedom.lean's good_increases_freedom
and OriginalSin.lean's fall_diminishes_freedom describe.
-/

/-- **THEOREM: The Fall breaks harmony with self — connecting to
    the wounded freedom of Freedom.lean.**
    Harmony with self is lost in the Fallen state. This is the formal
    counterpart to Freedom.lean's model of diminished freedom.

    CONNECTS TO: Freedom.lean good_increases_freedom,
    OriginalSin.lean fall_diminishes_freedom. -/
theorem fall_breaks_self_mastery
    (p : Person)
    (h_intellect : p.hasIntellect = true) :
    ¬ hasHarmony p HarmonyDomain.withSelf AnthropologicalState.Fallen := by
  exact fall_breaks_all_harmonies p HarmonyDomain.withSelf h_intellect

/-- **THEOREM: The Fall breaks communion with God — connecting to
    OriginalSin.lean's claim that the supernatural end is unreachable.**

    CONNECTS TO: OriginalSin.lean the_fall (cannot reach supernatural
    end), DivineModes.lean (beatifying communion lost). -/
theorem fall_breaks_communion_with_god
    (p : Person)
    (h_intellect : p.hasIntellect = true) :
    ¬ hasHarmony p HarmonyDomain.withGod AnthropologicalState.Fallen := by
  exact fall_breaks_all_harmonies p HarmonyDomain.withGod h_intellect

-- ============================================================================
-- ## Summary
-- ============================================================================

/-!
## Summary

### Axiom inventory: 5
1. all_harmonies_in_original_state — four harmonies present before Fall
   (CCC §374-376, ecumenical)
2. preternatural_gifts_in_original_state — three gifts present before Fall
   (CCC §376-377, ecumenical)
3. fall_breaks_all_harmonies — all four harmonies lost in Fall
   (CCC §379, §400, ecumenical)
4. fall_removes_preternatural_gifts — all three gifts lost in Fall
   (CCC §376-377, §405, ecumenical)
5. gifts_are_supernatural — gifts were supernatural additions, not natural
   (Aquinas ST I q.95; Pius V DS 1901-1980, Catholic)

### Theorem inventory: 8
1. original_justice_is_complete — combines Axioms 1+2
2. fall_is_total_in_scope — combines Axioms 3+4
3. grace_restores_gift_not_debt — payoff of Axiom 5
4. thomism_contradicts_baius — formal incompatibility with condemned view
5. fall_complete_picture — cross-file: OriginalSin + OriginalJustice
6. fallen_nature_has_wounds — cross-file: HumanNature correspondence
7. original_integrity_has_no_wounds — cross-file: HumanNature correspondence
8. fall_breaks_self_mastery — cross-file: Freedom connection
9. fall_breaks_communion_with_god — cross-file: DivineModes connection

### Cross-file connections
- OriginalSin.lean: the_fall, natureIsWounded (via fall_complete_picture)
- HumanNature.lean: fallenNature, originalIntegrity, OriginalWounds
  (via fallen_nature_has_wounds, original_integrity_has_no_wounds)
- Freedom.lean: good_increases_freedom (via fall_breaks_self_mastery)
- TheologyOfBody.lean: AnthropologicalState (reused throughout)

### Key finding
The natural/supernatural classification of preternatural gifts
(Axiom 5) is the load-bearing axiom. Four of five axioms are
ecumenical; only this one is distinctively Catholic. It determines
whether grace is mercy or justice — whether the economy of salvation
is GRATUITOUS or OWED. The condemnation of Baius (1567) was not a
peripheral ruling but a foundational decision about the character
of grace itself.

### Open question
The CCC inherits the natural/supernatural distinction from Scholastic
philosophy but does not itself argue for it. The HIDDEN ASSUMPTION is
that this binary classification is meaningful — that there is a fact
of the matter about whether a gift is "owed" to a nature. This
assumption deserves further formalization (perhaps connecting to a
formalization of Thomistic metaphysics of nature and grace).
-/

end Catlib.Creed.OriginalJustice
