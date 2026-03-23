import Catlib.Foundations
import Catlib.Creed.Providence
import Catlib.MoralTheology.TheologyOfBody

/-!
# What Makes Scientific Inquiry Worthwhile?

## The question

Before you go interrogate the world — run experiments, build theories,
test predictions — you need two core beliefs:

**A. The world is logical.** Nature has stable, discoverable order.
Not random, not arbitrary, not constantly shifting by divine whim.

**B. Humans can understand that logic.** Our minds are fitted to
the world's order. Reason is a reliable instrument, not a defective
one projecting patterns onto chaos.

These are not obvious. Many worldviews deny one or both:
- **Chaos mythology** (Babylonian): the world emerged from conflict
  between gods. No reason to expect stable order.
- **Hard occasionalism** (al-Ghazali): God directly causes every event.
  Fire doesn't burn — God burns. No "laws of nature," only divine habits.
- **Radical skepticism** (Hume, Kant): we can't know the world as it is.
  Our minds impose categories that may not match reality.
- **Nihilism**: there is no order. Apparent patterns are projections.

The CCC provides premises that establish both A and B. Can we DERIVE
them from what the CCC actually says?

## The derivation strategy

### Proposition A: The world is logical

The chain:
1. God creates through wisdom, not chaos (§299)
2. What is created through wisdom has order (definitional)
3. That order is stable because its source is unchanging (§302)
4. Creatures have genuine causal powers — P2 (§306)
5. Therefore: nature has real, stable laws (not divine whims)

### Proposition B: Humans can understand that logic

The chain:
1. Humans are made in God's image — imago_dei (§1700, Gen 1:27)
2. Being God's image means having intellect (§1700)
3. God's intellect is the SOURCE of creation's order (§299)
4. A rational creature made by the rational source of order is
   FITTED to that order — the knower matches the known
5. Therefore: human reason can grasp creation's logic (§36)

## What this exposes

The CCC never makes argument B explicit. It just ASSERTS in §36 that
God "can be known with certainty from the created world by the natural
light of human reason." But WHY? The answer requires combining imago_dei
(§1700) with creation through wisdom (§299) — the same rational nature
that structured the world also structured the mind that studies it.

This is the "adequation of intellect to reality" (adaequatio rei et
intellectus) — Aquinas's definition of truth. The CCC assumes it;
formalization shows what it costs.

## Denominational scope

Both propositions are ECUMENICAL — Protestants, Orthodox, and Catholics
all accept these premises. The one exception: some Reformed theologians
(following Barth) reject natural theology entirely, denying that human
reason can reliably know God from creation. They'd accept A but question
B. The CCC (following Vatican I) insists on both.
-/

set_option autoImplicit false

namespace Catlib.Creed.ScientificInquiry

open Catlib
open Catlib.Creed
open Catlib.MoralTheology.TheologyOfBody

-- ============================================================================
-- § 1. The Two Propositions
-- ============================================================================

/-- **Proposition A**: The world has stable, discoverable order —
    nature operates by genuine laws, not arbitrary divine whims.

    This is what makes empirical investigation worthwhile. If the world
    has no stable order, there's nothing to discover.

    OPEN QUESTION: What does "logical" actually mean here? This is
    opaque because we haven't defined it — and that's honest, because
    the CCC doesn't define it either. Candidate meanings:

    1. **Same causes produce same effects** (regularity).
       The weakest claim. Even an occasionalist can observe regularities
       — they just ground them in God's habits, not in things' natures.

    2. **Things have stable natures with causal powers** (essentialism).
       Stronger: fire burns BECAUSE OF WHAT FIRE IS, not because God
       happens to make burning happen near fire. This is Aristotelian.

    3. **The world's order is mathematically describable** (Galileo's
       "book of nature is written in mathematics"). Strongest claim —
       requires a specific relationship between mathematical structure
       and physical reality.

    The CCC's §299 ("arranged all things by measure and number and
    weight") leans toward meaning 3 — but the Catechism never commits
    to a philosophy of science. We use opaque because we don't want to
    smuggle in a specific philosophy of science that the CCC doesn't
    endorse. The derivation works regardless of which meaning you pick.

    This is itself a finding: the CCC grounds science metaphysically
    (ordered creation + imago dei) without committing to a specific
    account of what natural order IS. -/
-- TODO: Replace this opaque with a real definition once we settle
-- what "logical" means. See CONTRIBUTING.md backlog item
-- "Define what 'the world is logical' means."
opaque worldIsLogical : Prop

/-- **Proposition B**: Human reason is fitted to the world's order —
    we can understand how nature works.

    This is what makes empirical investigation possible. Even if the
    world has order, if our minds can't grasp it, science is futile.

    The CCC's ground for this (§36 + §1700) is the Thomistic
    *adaequatio rei et intellectus* — the intellect is adequate to
    reality because both participate in divine wisdom. See the
    README's "Philosophical machinery" section. -/
opaque humansCanUnderstandIt : Prop

-- ============================================================================
-- § 2. What the CCC gives us to work with
-- ============================================================================

/-!
### Existing infrastructure we'll use

From Axioms.lean:
- `s1_god_is_love` — God's nature is love (and implicitly: rational)
- `p2_two_tier_causation` — primary and secondary causes don't compete

From TheologyOfBody.lean:
- `imago_dei` — persons with intellect are images of God
- `isImageOfGod` — the image-of-God predicate

From Providence.lean:
- `creaturely_causation_genuine` — creatures genuinely cause events
- `PrimaryCause`, `SecondaryCause` — the two causal levels

### What we need to ADD
-/

/-- Whether God creates through wisdom (rationality) rather than
    through chaos, arbitrary will, or blind force.

    §299: "Because God creates through wisdom, his creation is ordered."
    This is the SOURCE of the world's order — not brute fact, not
    chance, not warring deities, but rational wisdom. -/
opaque godCreatesThruWisdom : Prop

/-- Whether something created through wisdom inherits that wisdom's
    order — the product reflects the producer's rationality. -/
opaque creationReflectsWisdom : Prop

/-- Whether the image of a rational being shares in that rationality.
    If God is rational, and humans are God's image, then humans
    participate in rationality — their minds are structured by the
    same logic that structured the world. -/
opaque imageSharesRationality : Person → Prop

-- ============================================================================
-- § 3. Axioms for Proposition A: The world is logical
-- ============================================================================

/-- AXIOM (§299): God creates through wisdom.
    "Because God creates through wisdom, his creation is ordered:
    'You have arranged all things by measure and number and weight.'"
    (Wis 11:20, cited in CCC §299)

    Provenance: [Scripture] Wis 11:20; [Definition] CCC §299.
    Denominational scope: ECUMENICAL. -/
axiom god_creates_through_wisdom :
  godCreatesThruWisdom

/-- AXIOM (§299): What is created through wisdom has order.
    The product reflects the producer. A wise creator produces an
    ordered creation — not chaos, not randomness, but "measure and
    number and weight."

    Provenance: [Definition] CCC §299 (creation is ordered BECAUSE
    God creates through wisdom — the "because" is the CCC's).
    Denominational scope: ECUMENICAL. -/
axiom wisdom_produces_order :
  godCreatesThruWisdom → creationReflectsWisdom

/-- AXIOM (§306, P2): Creatures have genuine causal powers.
    The world's order isn't just a pattern in God's behavior —
    creatures ACT ON THEIR OWN. Natural causes are real.

    "God grants his creatures not only their existence, but also
    the dignity of acting on their own." (CCC §306)

    Without this, you get occasionalism: the world looks orderly,
    but the order is in GOD, not in THINGS. Fire doesn't have a
    nature that burns — God burns at the moment of fire.

    Provenance: [Definition] CCC §306; connects to P2.
    Denominational scope: ECUMENICAL in substance. -/
axiom creatures_have_genuine_natures :
  creationReflectsWisdom →
  (∀ (p : PrimaryCause) (s : SecondaryCause), ¬ causesCompete p s) →
  worldIsLogical

-- ============================================================================
-- § 4. Axioms for Proposition B: Humans can understand it
-- ============================================================================

/-- AXIOM (§1700, Gen 1:27 + §299): The image of a rational God
    shares in that rationality.

    If God is rational (creates through wisdom), and humans are made
    in God's image (imago_dei), then the human mind PARTICIPATES in
    the same rationality that ordered the world.

    The knower is fitted to the known because BOTH come from the
    same rational source.

    This is the "adequation of intellect to reality" — Aquinas's
    definition of truth (ST I q.16 a.1).

    Provenance: [Definition] CCC §1700 + §299; [Philosophy] Aquinas.
    Denominational scope: ECUMENICAL (most Christians accept natural
    theology; Barth is the major exception). -/
axiom image_of_rational_god_is_rational :
  ∀ (p : Person),
    isImageOfGod p →
    godCreatesThruWisdom →
    imageSharesRationality p

/-- AXIOM (§36): A rational creature in a rational world can understand
    that world. The mind is fitted to reality because both are structured
    by the same divine wisdom.

    "God, the first principle and last end of all things, can be known
    with certainty from the created world by the natural light of
    human reason." (CCC §36, citing Vatican I, Dei Filius 2)

    §36 says we can know GOD from creation. A fortiori, we can know
    CREATION ITSELF — you can't read the Author's signature without
    reading the book.

    Provenance: [Tradition] Vatican I, Dei Filius 2; [Definition] CCC §36.
    Denominational scope: ECUMENICAL (Barth dissents). -/
axiom rational_creature_understands_rational_world :
  ∀ (p : Person),
    imageSharesRationality p →
    worldIsLogical →
    humansCanUnderstandIt

-- ============================================================================
-- § 5. Theorems
-- ============================================================================

/-- THEOREM (Proposition A): The world is logical.

    Derivation:
    1. God creates through wisdom (§299) — `god_creates_through_wisdom`
    2. Wisdom produces order (§299) — `wisdom_produces_order`
    3. Creatures have genuine natures, not occasionalist shadows (§306, P2)
       — `creatures_have_genuine_natures` + `p2_two_tier_causation`
    4. Therefore: the world has stable, discoverable order.

    Uses: 3 axioms + P2 base axiom.
    The CCC never states "the world is logical" in these words. But
    it follows from §299 (ordered creation) + §306 (real causation). -/
theorem the_world_is_logical : worldIsLogical := by
  have h_wisdom := god_creates_through_wisdom
  have h_order := wisdom_produces_order h_wisdom
  have h_p2 := p2_two_tier_causation
  exact creatures_have_genuine_natures h_order h_p2

/-- THEOREM (Proposition B): Humans can understand the world's logic.

    Derivation:
    1. Humans have intellect (Person.human.hasIntellect = true)
    2. Persons with intellect are God's image (imago_dei, §1700)
    3. The image of a rational God shares rationality (§1700 + §299)
    4. A rational creature in a rational world can understand it (§36)
    5. Therefore: humans can understand the world's order.

    Uses: imago_dei + image_of_rational_god_is_rational +
          rational_creature_understands_rational_world +
          the_world_is_logical.

    This is the deeper theorem — it chains through imago_dei from
    TheologyOfBody.lean and connects to §36 via §299. The CCC
    asserts §36 without explaining WHY reason is reliable. This
    theorem shows why: the same wisdom that ordered the world
    also structured the mind that studies it. -/
theorem humans_can_understand_the_world : humansCanUnderstandIt := by
  -- Step 1: A human person has intellect
  have h_intellect : Person.human.hasIntellect = true := rfl
  -- Step 2: Persons with intellect are God's image (imago_dei)
  have h_image := imago_dei Person.human h_intellect
  -- Step 3: God creates through wisdom
  have h_wisdom := god_creates_through_wisdom
  -- Step 4: Image of rational God → shares rationality
  have h_rational := image_of_rational_god_is_rational Person.human h_image h_wisdom
  -- Step 5: The world is logical (Proposition A)
  have h_logical := the_world_is_logical
  -- Step 6: Rational creature + logical world → understanding
  exact rational_creature_understands_rational_world Person.human h_rational h_logical

/-- THEOREM: Both propositions together — science is grounded.

    The world is logical (A) AND humans can understand it (B).
    Together, these are the metaphysical preconditions for scientific
    inquiry. The CCC provides both — scattered across §36, §299,
    §306, and §1700. -/
theorem science_is_grounded :
    worldIsLogical ∧ humansCanUnderstandIt :=
  ⟨the_world_is_logical, humans_can_understand_the_world⟩

-- ============================================================================
-- § 6. What breaks without each axiom
-- ============================================================================

/-- THEOREM: Providence.lean's creaturely causation bridges to our model.
    If creatures genuinely cause free events (Providence), then creatures
    have real causal powers — supporting Proposition A.

    Uses: creaturely_causation_genuine (Providence.lean). -/
theorem providence_supports_proposition_a
    (e : CausedEvent)
    (h_free : e.secondaryCause.hasFreeWill = true) :
    e.isFreeAct :=
  creaturely_causation_genuine e h_free

/-- THEOREM: P2 from Axioms.lean means science and theology study
    different levels of the same reality — they don't compete.

    Uses: p2_two_tier_causation (Axioms.lean).
    This is why "God did it" and "natural causes did it" are not
    rival explanations under the CCC's model. -/
theorem science_and_theology_compatible
    (p : PrimaryCause) (s : SecondaryCause) :
    ¬ causesCompete p s :=
  p2_two_tier_causation p s

/-!
### The failure modes

Each axiom rules out a worldview that would undermine science:

| Drop this axiom | You get | Science status |
|-----------------|---------|---------------|
| god_creates_through_wisdom | Chaos mythology | No reason to expect order |
| wisdom_produces_order | Voluntarism (God's will is arbitrary) | Order exists but could change at whim |
| creatures_have_genuine_natures (P2) | Occasionalism | Patterns exist but are divine habits, not laws |
| imago_dei | Humans not special | No reason our minds match reality |
| rational_creature_understands | Radical skepticism | Order exists but we can't know it |

P2 is still load-bearing: it's what makes the world's order reside IN
THINGS (discoverable by experiment) rather than in God's will (knowable
only by revelation). But now we see that imago_dei is EQUALLY important
for Proposition B — without it, the world could be logical but we'd
have no reason to think our minds can grasp it.

The CCC's argument for science thus rests on TWO pillars:
- **Rational creation** (§299 + P2) → the world is logical
- **Rational creature** (§1700 + §36) → we can understand it

Both pillars come from the SAME source: divine wisdom. The world is
rational because God created it through wisdom. The mind is rational
because God created it in His image. The match between mind and world
is not a coincidence — it's a design feature.
-/

/-!
## Summary

Axioms (6 — from CCC, connected to existing infrastructure):
1. god_creates_through_wisdom (§299) — God creates through wisdom
2. wisdom_produces_order (§299) — wisdom → order
3. creatures_have_genuine_natures (§306 + P2) — real causes, not occasions
4. image_of_rational_god_is_rational (§1700 + §299) — imago dei → rationality
5. rational_creature_understands_rational_world (§36) — rational + logical → understanding
6. (P2 from Axioms.lean used directly — not a new axiom)

Theorems (3):
1. the_world_is_logical — Proposition A: DERIVED from §299 + §306 + P2
2. humans_can_understand_the_world — Proposition B: DERIVED from §1700 + §299 + §36 + Prop A
3. science_is_grounded — A ∧ B

Key FINDING: The CCC asserts §36 (reason can know God from creation)
without explaining WHY. This formalization shows why: the same wisdom
that ordered the world (§299) also structured the mind that studies it
(§1700, imago_dei). The match between knower and known is not accidental
— it's because both are products of the same rational source.

Key FINDING: Two axioms are EQUALLY load-bearing:
- P2 (two-tier causation) for Proposition A — without it, occasionalism
- imago_dei for Proposition B — without it, no reason to trust reason

Cross-file connections:
- Axioms.lean: p2_two_tier_causation (base axiom P2)
- TheologyOfBody.lean: imago_dei, isImageOfGod
- Providence.lean: PrimaryCause, SecondaryCause, causesCompete
-/

end Catlib.Creed.ScientificInquiry
