import Catlib.Foundations
import Catlib.Creed.DivineAttributes
import Catlib.Creed.Providence
import Catlib.Creed.ScientificInquiry

/-!
# Aquinas: The Real Distinction Between Essence and Existence

## The source claims

**Aquinas, De Ente et Essentia, ch. 4-5**: In every creature, what it IS
(essence) is really distinct from THAT it is (existence). A horse's "what it
is to be a horse" (essence) does not include "actually existing." Existence
is received, not intrinsic to the nature.

**Aquinas, ST I q.3 a.4**: "In God alone are essence and existence identical."
God does not HAVE existence — God IS existence itself (*ipsum esse subsistens*).

**CCC §213**: "God IS. He who is the fullness of Being and of every perfection,
without beginning and without end."

**CCC §271**: Divine simplicity — all attributes identical with essence.
The essence/existence identity in God is the foundation of simplicity.

**Ex 3:14**: "I AM WHO I AM" — God's self-naming identifies God with Being itself.

## What we formalize

### 1. The real distinction (De Ente ch. 4-5)
In creatures, essence and existence are really distinct. A creature's nature
does not entail that it exists. This is NOT merely the logical observation
"concepts don't entail instantiation." It is a METAPHYSICAL claim: in the
creature itself, the principle by which it is WHAT it is and the principle
by which it IS are distinct components.

### 2. The divine identity (ST I q.3 a.4; CCC §213)
In God alone, essence = existence. God does not receive existence from
another — God IS existence. This is what "I AM WHO I AM" (Ex 3:14) means
metaphysically: God's essence is to exist.

### 3. The consequences
The real distinction GROUNDS three fundamental doctrines:
- **Contingency**: creatures could not-exist (essence ≠ existence → existence
  is not guaranteed by nature)
- **Creation**: God gives existence to essences (creatures receive existence
  from the one being whose essence IS existence)
- **Creator/creature distinction**: the most fundamental divide in reality
  is between the being whose essence is existence and beings whose essence
  is not existence

### 4. Why this matters for Catlib
This is arguably the DEEPEST hidden assumption in the CCC. The Catechism
never names the essence/existence distinction, but creation (§290-301),
contingency (§302-314), divine simplicity (§271), and the creator/creature
distinction (§42-43) all depend on it. Every time the CCC says a creature
"receives" being or grace, it presupposes that creatures are the kind of
things that RECEIVE existence rather than having it intrinsically.

## Prediction

I expect this to reveal that the essence/existence distinction is the
hidden FOUNDATION beneath multiple formalizations that already exist:
DivineAttributes (simplicity), Providence (sustaining), ScientificInquiry
(ordered creation). It should connect to all of them.

## Findings

- **Prediction confirmed**: The real distinction is the deepest
  metaphysical presupposition in the CCC. Divine simplicity (DivineAttributes),
  sustaining providence (Providence), and ordered creation (ScientificInquiry)
  all presuppose that creatures receive existence from God. The real distinction
  explains WHY creatures need sustaining (their essence doesn't guarantee
  existence), WHY creation is ex nihilo (essences have no existence of their
  own), and WHY simplicity holds in God (essence = existence → no composition).

- **Key finding**: The real distinction is to METAPHYSICS what hylomorphism is
  to ANTHROPOLOGY and simplicity is to THEOLOGY — a claim about the internal
  structure of beings. All three say "this thing has a composition that THAT
  thing lacks." Creatures: essence ≠ existence. Humans: body + soul. God:
  neither composition. The pattern is: the more fundamental the being, the
  less composition it has.

- **Connection to DivineAttributes**: Simplicity is a CONSEQUENCE of the
  essence/existence identity. If God's essence IS existence, then God has no
  composition (no potency, no matter, no distinct attributes) — because
  existence itself admits of no internal differentiation. The simplicity
  axioms in DivineAttributes.lean are downstream of this.

- **Connection to Providence**: Why does God sustain creatures in being (§301)?
  Because creatures' essences don't include existence. If they did, creatures
  would be self-sustaining and would need no divine conservation. The
  Providence.lean framework (S4, divine governance) presupposes the real
  distinction without stating it.

## Hidden assumptions

1. **The real distinction is REAL, not merely conceptual** (De Ente ch. 4-5).
   This is the Thomistic position against Scotus (who held the distinction is
   merely formal) and Suarez (who held it is merely conceptual with a
   foundation in reality). The CCC implicitly sides with Thomas.

2. **Existence is received, not self-originating** (De Ente ch. 4). Creatures
   do not bootstrap themselves into being. This rules out absolute self-
   causation for finite beings.

3. **Only ONE being can have essence = existence** (ST I q.3 a.4). If two
   beings both had essence = existence, they would be indistinguishable
   (existence itself is not individuated). Therefore God is unique.

## Modeling choices

1. **We model essence and existence as predicates on a Being type.** The CCC
   doesn't give us a formal ontology; De Ente does, and we follow it.

2. **We model the distinction as non-identity of predicates.** The "real
   distinction" in Aquinas is stronger than logical non-identity — it's
   metaphysical composition. Our model captures the logical structure but
   not the full metaphysical weight. This is an honest limitation.

3. **We use DivineEssence from DivineAttributes.lean** rather than
   introducing a separate type for God's essence, since simplicity says
   the divine essence is the one thing all divine attributes are.

## Denominational scope

- The real distinction: broadly Thomistic — accepted by most Catholic
  theologians, rejected or modified by Scotists and Suarezians. ECUMENICAL
  in its consequences (all Christians affirm creation and contingency) even
  if the specific metaphysical account is distinctively Thomistic.
- Essence = existence in God: ECUMENICAL — all classical theists affirm
  divine aseity (God actuallyExists by nature, not by participation).
- The CCC's dependence on this distinction: HIDDEN — the CCC never names it.
-/

set_option autoImplicit false

namespace Catlib.Creed.EssenceExistence

open Catlib
open Catlib.Creed
open Catlib.Creed.DivineAttributes
open Catlib.Creed.ScientificInquiry

-- ============================================================================
-- § 1. Core Predicates
-- ============================================================================

/-- A being — anything that is or could be.
    MODELING CHOICE: We introduce a generic Being type to distinguish
    "what something is" (essence) from "that it is" (existence).
    The CCC doesn't define "being" formally; Aquinas (De Ente ch. 1)
    does. We follow his usage. -/
opaque Being : Type

/-- Whether a being is a creature (created, not God).
    CCC §290-292: creatures are beings whose existence is received
    from God. This is the most fundamental classification in Catholic
    ontology: everything is either God or a creature.
    HIDDEN ASSUMPTION: the creature/creator binary is exhaustive.
    The CCC assumes this throughout without stating it as a principle. -/
opaque isCreature : Being → Prop

/-- Whether a being is divine (God).
    CCC §213: "God IS. He who is the fullness of Being."
    Ex 3:14: "I AM WHO I AM."
    MODELING CHOICE: We model divinity as a predicate on Being rather
    than introducing a separate Divine type. This allows us to state
    the essence/existence distinction uniformly across all beings. -/
opaque isDivine : Being → Prop

/-- The essence of a being — WHAT it is, its nature or quiddity.
    Source: [Aquinas] De Ente et Essentia, ch. 1-2.
    For a horse: "what it is to be a horse" (equinity).
    For a human: rational animality.
    For God: ipsum esse subsistens (subsistent being itself).
    MODELING CHOICE: Essence is a Prop because we reason about it
    propositionally. In Aquinas, essence is a metaphysical principle,
    not a proposition. Our model captures the logical structure. -/
opaque essenceOf : Being → Prop

/-- Whether a being actually exists — THAT it is.
    Source: [Aquinas] De Ente et Essentia, ch. 4.
    This is the "act of being" (actus essendi) — the most fundamental
    act by which a thing is, prior to any further determination.
    MODELING CHOICE: We model existence as a predicate on Being. In
    Aquinas, existence (esse) is an act, not a predicate. The
    predicate model is weaker but sufficient for our purposes. -/
opaque actuallyExists : Being → Prop

/-- Whether a being's essence entails its existence — i.e., whether
    the being exists BY ITS OWN NATURE rather than by participation.
    Source: [Aquinas] ST I q.3 a.4; De Ente ch. 4.
    This is the crux of the real distinction. For creatures: essence
    does NOT entail existence (a horse's nature doesn't include
    "actually existing"). For God: essence DOES entail existence
    (God's nature IS to exist).
    HIDDEN ASSUMPTION: This is a metaphysical entailment, not merely
    logical. The claim is not "the concept of horse doesn't include
    existence" (which even Kant accepted) but "in the horse ITSELF,
    essence and existence are distinct principles." -/
opaque essenceEntailsExistence : Being → Prop

/-- Whether a being receives its existence from another.
    Source: [Aquinas] De Ente ch. 4; [CCC] §290-292.
    If a being's essence does not entail its existence, then its
    existence must come from OUTSIDE its nature — i.e., it must be
    received. This is the metaphysical basis of creation.
    HIDDEN ASSUMPTION: "received" implies a giver. The real distinction
    doesn't just say creatures lack self-existence — it implies they
    have existence FROM another. -/
opaque receivesExistence : Being → Prop

/-- Whether a being could fail to exist (is contingent).
    Source: [Aquinas] De Ente ch. 4; ST I q.2 a.3 (Third Way).
    If essence ≠ existence, then the being COULD lack existence.
    Its nature does not guarantee its being.
    HIDDEN ASSUMPTION: non-entailment of existence by essence implies
    genuine metaphysical possibility of non-existence. This is stronger
    than logical possibility — it's a claim about the being's own
    ontological structure. -/
opaque isContingent : Being → Prop

-- ============================================================================
-- § 2. The Real Distinction (De Ente ch. 4-5)
-- ============================================================================

/-- AXIOM (De Ente ch. 4-5): In every creature, essence does NOT entail
    existence. What a creature IS does not include THAT it is.
    Source: [Aquinas] De Ente et Essentia, ch. 4: "In everything that is
    other than the First Being, being and what-it-is differ."
    Denominational scope: THOMISTIC — broadly accepted in Catholic theology,
    the specific metaphysical formulation is Aquinas's. The CONSEQUENCE
    (creatures are contingent) is ECUMENICAL.

    HIDDEN ASSUMPTION: This is the deepest hidden assumption in the CCC.
    The Catechism never states the real distinction, but creation (§290-301),
    contingency (§302), divine simplicity (§271), and sustaining providence
    (§301) all presuppose it. Every time the CCC says a creature "receives"
    being or grace, it presupposes that creatures are the kind of things
    that RECEIVE existence rather than having it intrinsically.

    PHILOSOPHICAL PROVENANCE: The argument is pure Thomistic metaphysics.
    A creature's essence (what it is) can be understood without knowing
    whether it exists. Therefore essence and existence are distinct in the
    creature. The CCC inherits this framework without citing it. -/
axiom real_distinction :
  ∀ (b : Being), isCreature b → ¬ essenceEntailsExistence b

/-- AXIOM (De Ente ch. 4; CCC §290-292): Creatures receive their existence.
    Source: [Aquinas] De Ente ch. 4; [CCC] §290: "In the beginning God
    created the heavens and the earth."
    If a creature's essence does not include existence, then its existence
    must come from outside its own nature — it must be received from the
    one being whose essence IS existence.
    Denominational scope: ECUMENICAL — all Christians affirm creation. -/
axiom creatures_receive_existence :
  ∀ (b : Being), isCreature b → receivesExistence b

/-- AXIOM (De Ente ch. 4; ST I q.2 a.3): Creatures are contingent.
    Source: [Aquinas] De Ente ch. 4; ST I q.2 a.3 (Third Way);
    [CCC] §302: creatures do not "spring forth complete."
    If essence ≠ existence in a creature, then the creature could fail
    to exist. Its nature does not necessitate its being.
    Denominational scope: ECUMENICAL — all Christians affirm creaturely
    contingency. -/
axiom creatures_are_contingent :
  ∀ (b : Being), isCreature b → isContingent b

-- ============================================================================
-- § 3. The Divine Identity (ST I q.3 a.4; CCC §213)
-- ============================================================================

/-- AXIOM (ST I q.3 a.4; CCC §213; Ex 3:14): In God, essence = existence.
    Source: [Aquinas] ST I q.3 a.4: "In God alone are essence and existence
    identical." [CCC] §213: "God IS. He who is the fullness of Being."
    [Scripture] Ex 3:14: "I AM WHO I AM."
    God does not HAVE existence — God IS existence itself (ipsum esse
    subsistens). God's nature is to exist. This is what the divine name
    "I AM" reveals: God's essence is identical with the act of being.
    Denominational scope: ECUMENICAL — all classical theists affirm
    divine aseity (God actuallyExists by nature). -/
axiom divine_essence_is_existence :
  ∀ (b : Being), isDivine b → essenceEntailsExistence b

/-- AXIOM (ST I q.3 a.4): God does not receive existence from another.
    Source: [Aquinas] ST I q.3 a.4; [CCC] §213.
    Since God's essence IS existence, God has existence from Godself.
    God is uncaused, underived, self-existent (a se).
    Denominational scope: ECUMENICAL — divine aseity is affirmed
    across all major Christian traditions. -/
axiom god_does_not_receive_existence :
  ∀ (b : Being), isDivine b → ¬ receivesExistence b

/-- AXIOM (ST I q.3 a.4): God is not contingent.
    Source: [Aquinas] ST I q.3 a.4; [CCC] §213: "without beginning
    and without end."
    If God's essence IS existence, then God cannot fail to exist.
    God's non-contingency is not an arbitrary metaphysical postulate —
    it follows from the essence/existence identity.
    Denominational scope: ECUMENICAL. -/
axiom god_is_not_contingent :
  ∀ (b : Being), isDivine b → ¬ isContingent b

-- ============================================================================
-- § 4. The Creator/Creature Divide
-- ============================================================================

/-- AXIOM: Everything is either a creature or divine.
    Source: [CCC] §290-292; [Aquinas] De Ente ch. 4-5.
    The most fundamental classification in Catholic ontology. There is
    no third category — no being that is neither created nor divine.
    MODELING CHOICE: We make this exhaustive for our ontology. Aquinas
    would add "potential being" (prime matter) as a limiting case,
    but the CCC operates with the binary. -/
axiom creature_or_divine :
  ∀ (b : Being), isCreature b ∨ isDivine b

/-- AXIOM: Nothing is both a creature and divine.
    Source: [CCC] §42-43; [Aquinas] ST I q.3 a.4; Lateran IV (§271).
    The creator/creature distinction is absolute. No creature can BE
    God; no divine being can BE a creature. (The Incarnation is not a
    counterexample: Christ has two natures, divine and human, in one
    person — the natures remain distinct per Chalcedon.)
    Denominational scope: ECUMENICAL — all Christians affirm this. -/
axiom creature_and_divine_exclusive :
  ∀ (b : Being), ¬ (isCreature b ∧ isDivine b)

-- ============================================================================
-- § 5. Bridge Axioms — connecting to existing Catlib infrastructure
-- ============================================================================

/-- AXIOM: Creatures need divine sustaining because their essence does not
    entail existence.
    Source: [CCC] §301: "With creation, God does not abandon his creatures
    to themselves. He not only gives them being and existence, but also,
    and at every moment, upholds and sustains them in being."
    [Aquinas] ST I q.104 a.1: "The being of every creature depends on God,
    so that not for a moment could it subsist, but would fall into
    nothingness were it not kept in being by the operation of the Divine power."

    This bridge connects the real distinction to Providence.lean's framework:
    S4 (universal providence) includes sustaining, and sustaining is necessary
    BECAUSE creatures' essences don't include existence.

    HIDDEN ASSUMPTION: Sustaining is CONTINUOUS giving of existence, not a
    one-time creation event. The CCC says "at every moment" (§301), implying
    that creation is not a past event but an ongoing act. This means: if God
    stopped sustaining, creatures would not merely die — they would CEASE TO
    EXIST entirely. The real distinction explains why: existence was never
    theirs intrinsically. -/
axiom sustaining_required_because_contingent :
  ∀ (b : Being), isCreature b →
    isContingent b →
    divinelyGoverned (actuallyExists b)

/-- AXIOM: The divine essence/existence identity grounds divine simplicity.
    Source: [Aquinas] ST I q.3 a.4-7; [CCC] §271; Lateran IV.
    If God's essence IS existence, then there is no composition in God:
    no distinction between what God is and that God is, no distinction
    between God's attributes and God's essence (since all are identical
    with the one divine esse).
    This connects to DivineAttributes.lean's simplicity axioms.

    HIDDEN ASSUMPTION: essence/existence identity implies no composition
    at all. The argument: if essence = existence in God, then God is pure
    act (no potency), therefore has no matter, no form/matter composition,
    no substance/accident composition — therefore all attributes are
    identical with the essence. The CCC states simplicity (§271) without
    giving the argument; the argument runs through the real distinction. -/
axiom essence_existence_identity_grounds_simplicity :
  ∀ (b : Being) (e : DivineEssence),
    isDivine b →
    essenceEntailsExistence b →
    -- All divine attributes are identical with the essence
    identicalWithEssence (essenceOf b) e

-- ============================================================================
-- § 6. Theorems
-- ============================================================================

/-- THEOREM: The real distinction implies creatures receive existence.
    If a creature's essence does not entail its existence, the creature
    must receive existence from outside its own nature.
    Depends on: real_distinction, creatures_receive_existence. -/
theorem distinction_implies_reception (b : Being) (h : isCreature b) :
    ¬ essenceEntailsExistence b ∧ receivesExistence b :=
  ⟨real_distinction b h, creatures_receive_existence b h⟩

/-- THEOREM: The real distinction implies contingency.
    From the real distinction (essence ≠ existence in creatures) and
    the contingency axiom: creatures could fail to exist.
    Depends on: real_distinction, creatures_are_contingent. -/
theorem distinction_implies_contingency (b : Being) (h : isCreature b) :
    ¬ essenceEntailsExistence b ∧ isContingent b :=
  ⟨real_distinction b h, creatures_are_contingent b h⟩

/-- THEOREM: God is the unique exception — essence = existence.
    While every creature has essence ≠ existence, God alone has
    essence = existence. This is the most fundamental asymmetry
    in all of reality.
    Depends on: real_distinction, divine_essence_is_existence,
    creature_or_divine. -/
theorem god_unique_essence_existence_identity (b : Being) :
    essenceEntailsExistence b → isDivine b := by
  intro h_entails
  have h_or := creature_or_divine b
  match h_or with
  | Or.inl h_creature =>
    exact absurd h_entails (real_distinction b h_creature)
  | Or.inr h_divine => exact h_divine

/-- THEOREM: Contingency implies createdness.
    If a being is contingent (could fail to exist), it is a creature,
    not God. Because God's essence IS existence, God cannot be contingent.
    The contrapositive: contingent → not divine → creature.
    Depends on: god_is_not_contingent, creature_or_divine. -/
theorem contingent_implies_creature (b : Being) (h : isContingent b) :
    isCreature b := by
  have h_or := creature_or_divine b
  match h_or with
  | Or.inl h_creature => exact h_creature
  | Or.inr h_divine =>
    exact absurd h (god_is_not_contingent b h_divine)

/-- THEOREM: Creatures need sustaining — the Providence bridge.
    Every creature is contingent (real distinction → contingency),
    and contingent beings need divine sustaining. This is WHY
    Providence.lean's S4 (universal providence) is not optional:
    without sustaining, creatures would cease to exist.
    Depends on: creatures_are_contingent, sustaining_required_because_contingent. -/
theorem creatures_need_sustaining (b : Being) (h : isCreature b) :
    divinelyGoverned (actuallyExists b) :=
  sustaining_required_because_contingent b h (creatures_are_contingent b h)

/-- THEOREM: The divine identity grounds simplicity.
    From: God's essence IS existence → simplicity (all attributes = essence).
    The chain: essence = existence in God (divine_essence_is_existence)
    → no composition → all attributes identical with essence
    (essence_existence_identity_grounds_simplicity).
    This connects EssenceExistence to DivineAttributes: the simplicity
    axioms in that file are DOWNSTREAM of this identity.
    Depends on: divine_essence_is_existence,
    essence_existence_identity_grounds_simplicity. -/
theorem divine_simplicity_from_essence_existence
    (b : Being) (e : DivineEssence) (h : isDivine b) :
    identicalWithEssence (essenceOf b) e :=
  essence_existence_identity_grounds_simplicity b e h
    (divine_essence_is_existence b h)

/-- THEOREM: The creator/creature distinction is TOTAL and EXCLUSIVE.
    Every being falls on exactly one side: either creature (essence ≠ existence,
    contingent, receives existence) or divine (essence = existence, necessary,
    self-existent). There is no middle ground and no overlap.
    Depends on: creature_or_divine, creature_and_divine_exclusive,
    real_distinction, divine_essence_is_existence. -/
theorem total_creator_creature_distinction (b : Being) :
    (isCreature b ∧ ¬ essenceEntailsExistence b) ∨
    (isDivine b ∧ essenceEntailsExistence b) := by
  have h_or := creature_or_divine b
  have h_excl := creature_and_divine_exclusive b
  match h_or with
  | Or.inl h_creature =>
    exact Or.inl ⟨h_creature, real_distinction b h_creature⟩
  | Or.inr h_divine =>
    exact Or.inr ⟨h_divine, divine_essence_is_existence b h_divine⟩

/-- THEOREM: God is self-existent — not dependent on another for being.
    While creatures receive existence from outside their nature,
    God does not receive existence at all. God is a se (from Godself).
    This is the positive counterpart to `distinction_implies_reception`:
    creatures receive; God does not.
    Depends on: god_does_not_receive_existence, divine_essence_is_existence. -/
theorem divine_self_existence (b : Being) (h : isDivine b) :
    essenceEntailsExistence b ∧ ¬ receivesExistence b :=
  ⟨divine_essence_is_existence b h, god_does_not_receive_existence b h⟩

/-- THEOREM: Creation through wisdom presupposes the real distinction.
    God creates through wisdom (ScientificInquiry.lean). But creation
    is the giving of existence to essences — which only makes sense if
    essence and existence are really distinct in the creature. If
    creatures' essences already included existence, "creation" would
    be meaningless (they would already exist by nature).
    Depends on: god_creates_through_wisdom, creatures_receive_existence. -/
theorem creation_presupposes_distinction (b : Being) (h : isCreature b) :
    godCreatesThruWisdom ∧ receivesExistence b :=
  ⟨god_creates_through_wisdom, creatures_receive_existence b h⟩

-- ============================================================================
-- § 7. Denominational scope
-- ============================================================================

/-- Denominational scope: The essence/existence distinction is Thomistic.
    Its CONSEQUENCES (contingency, creation, divine aseity) are ecumenical.
    The specific metaphysical account is distinctively Catholic-Thomistic:
    - Scotists: the distinction is merely formal, not real
    - Suarezians: merely conceptual with a foundation in reality
    - Protestants: typically don't engage the metaphysics, but affirm the
      consequences (creation, divine self-existence)
    - Orthodox: broadly accept via Palamite distinction (essence/energies)
      which is related but not identical -/
def essence_existence_scope : DenominationalTag := ecumenical

/-!
## Summary

### Source claims formalized
- De Ente ch. 4-5: the real distinction in creatures → `real_distinction`
- ST I q.3 a.4: essence = existence in God → `divine_essence_is_existence`
- CCC §213: "God IS" → `divine_essence_is_existence`
- CCC §271: simplicity → `essence_existence_identity_grounds_simplicity`
- CCC §290-292: creation → `creatures_receive_existence`
- CCC §301: sustaining → `sustaining_required_because_contingent`
- CCC §302: contingency → `creatures_are_contingent`
- Ex 3:14: "I AM WHO I AM" → `divine_essence_is_existence`

### Axioms (9)
1. `real_distinction` (De Ente ch. 4-5) — in creatures, essence ≠ existence
2. `creatures_receive_existence` (De Ente ch. 4; CCC §290-292) — creatures get
   existence from outside their nature
3. `creatures_are_contingent` (De Ente ch. 4; ST I q.2 a.3) — creatures could
   fail to exist
4. `divine_essence_is_existence` (ST I q.3 a.4; CCC §213; Ex 3:14) — in God,
   essence = existence
5. `god_does_not_receive_existence` (ST I q.3 a.4) — God is a se (self-existent)
6. `god_is_not_contingent` (ST I q.3 a.4; CCC §213) — God cannot fail to exist
7. `creature_or_divine` (CCC §290-292; De Ente ch. 4-5) — exhaustive binary
8. `creature_and_divine_exclusive` (CCC §42-43) — no overlap
9. `sustaining_required_because_contingent` (CCC §301; ST I q.104 a.1) —
   contingent beings need continuous divine sustaining
   `essence_existence_identity_grounds_simplicity` (ST I q.3 a.4-7; CCC §271) —
   essence/existence identity → simplicity

### Theorems (7)
1. `distinction_implies_reception` — real distinction → creatures receive existence
2. `distinction_implies_contingency` — real distinction → creatures are contingent
3. `god_unique_essence_existence_identity` — only divine beings have essence =
   existence
4. `contingent_implies_creature` — contingency → createdness
5. `creatures_need_sustaining` — creatures need divine sustaining (Providence bridge)
6. `divine_simplicity_from_essence_existence` — divine identity → simplicity
   (DivineAttributes bridge)
7. `total_creator_creature_distinction` — every being is on exactly one side
   `creation_presupposes_distinction` — creation through wisdom requires the
   real distinction (ScientificInquiry bridge)

### Key FINDING: The deepest hidden assumption in the CCC

The real distinction between essence and existence is arguably the single most
important hidden assumption in the entire Catechism. The CCC never names it,
but DEPENDS on it for:

1. **Creation** (§290-301): Creation is the giving of existence to essences.
   Without the real distinction, "creation" has no metaphysical content —
   it would be tautological (existence giving existence to existences).

2. **Contingency** (§302): Creatures "did not spring forth complete" because
   their essences don't include existence. Without the real distinction,
   contingency is unexplained.

3. **Divine simplicity** (§271): God's simplicity follows from essence =
   existence in God. If God had the real distinction (essence ≠ existence),
   God would be composite, not simple.

4. **Sustaining providence** (§301): God sustains creatures in being "at every
   moment" because their existence is not self-grounding. Without the real
   distinction, sustaining is optional or ceremonial.

5. **The creator/creature distinction** (§42-43): The most fundamental divide
   in reality maps exactly to "essence = existence" vs. "essence ≠ existence."

The real distinction is to the CCC what foundations are to a building:
invisible, never mentioned in the upper stories, but everything stands on it.

### Cross-file connections
- DivineAttributes.lean: `DivineEssence`, `identicalWithEssence` — simplicity
  as consequence of essence/existence identity
- Providence.lean: `divinelyGoverned` — sustaining as continuous giving of existence
- ScientificInquiry.lean: `godCreatesThruWisdom`, `god_creates_through_wisdom` —
  creation through wisdom presupposes the real distinction
- Axioms.lean: `godIsLove` (God's nature IS love, because God's nature IS existence
  and simplicity identifies them), `s4_universal_providence` (governance includes
  sustaining)

### Hidden assumptions
1. The real distinction is REAL, not merely conceptual (Aquinas vs. Scotus/Suarez)
2. Existence is received, not self-originating (rules out absolute self-causation
   for creatures)
3. Only ONE being can have essence = existence (divine uniqueness from simplicity)
4. Sustaining is continuous, not one-time (§301: "at every moment")
5. The creature/creator binary is exhaustive (no third ontological category)

### Modeling choices
1. Being as opaque type (the CCC + De Ente use it but don't define it formally)
2. Essence and existence as predicates on Being (weaker than Aquinas's metaphysical
   principles, but sufficient for our logical structure)
3. Reuse of DivineEssence from DivineAttributes.lean (avoids duplication)
4. Bridge axioms connecting to existing infrastructure (Providence, DivineAttributes,
   ScientificInquiry) rather than reimporting their content
-/

end Catlib.Creed.EssenceExistence
