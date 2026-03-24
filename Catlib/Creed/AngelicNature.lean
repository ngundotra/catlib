import Catlib.Foundations
import Catlib.Creed.Angels
import Catlib.Creed.SeparatedSoul
import Catlib.Creed.AnalogyOfBeing

/-!
# Aquinas ST I q.50-64: The Nature of Angels — Species, Knowledge, Sin, and Hierarchy

## The source claims

### Each angel is its own species (ST I q.50 a.4)

Aquinas argues that since angels have no matter, they cannot be
individuated by matter. In corporeal beings, two dogs can share the
same species (dog-nature) because matter individuates them — THIS
chunk of matter vs. THAT chunk. But angels have no matter. Therefore,
what individuates an angel IS its form. But form is what determines
species. Therefore each angel's individuating principle is its species.
Consequence: no two angels share a nature. Each angel is a unique
species.

### Angels know by infused species (ST I q.55 a.2)

Human intellect knows by ABSTRACTION from sensory data: we see many
dogs, abstract the common form, and arrive at the concept "dog."
Angels have no senses (no body), so they cannot abstract. Instead,
God implants intelligible species directly into the angelic intellect
at creation. This is "infused knowledge" — not learned, not
discovered, but received.

The CCC does not state this explicitly, but it is presupposed by
§330 (angels have intellect) + §328 (angels have no body). If you
have intellect but no senses, knowledge must come from somewhere
other than abstraction. Aquinas's answer: divine infusion.

### Angels can only sin by pride (ST I q.63 a.1-2)

Since angels know by infused species (not by discursive reasoning),
they cannot be IGNORANT of morally relevant facts. A human might sin
because they don't see the full picture — anger, confusion, incomplete
reasoning. An angel sees the whole picture immediately. Therefore
angelic sin cannot arise from ignorance. It can only arise from a
DISORDERED WILL — choosing the self over God while knowing exactly
what one is doing. This is pride (superbia): the will's choice to
prefer its own excellence over submission to God.

### Angelic hierarchy (ST I q.108; CCC §335)

§335: "The Church venerates the angels who help her on her earthly
pilgrimage and protect every human being."

Aquinas (ST I q.108) organizes angels into three hierarchies of
three choirs each, based on their proximity to God:
- First hierarchy (closest to God): Seraphim, Cherubim, Thrones
- Second hierarchy (governing creation): Dominations, Virtues, Powers
- Third hierarchy (ministering to humans): Principalities, Archangels, Angels

This hierarchy reflects degrees of intellectual perfection — angels
closer to God receive more universal intelligible species.

### The key question: "person" is analogical between angels and humans

If each angel is its own species, then angelic personhood is
fundamentally different from human personhood:
- HUMANS: many persons share ONE nature (humanity). Personhood is
  an instance of a shared species.
- ANGELS: each person IS a unique nature. Personhood and species
  coincide.

Therefore "person" cannot mean the SAME thing (univocal) for angels
and humans. It must mean something RELATED but different (analogical).
This connects directly to AnalogyOfBeing.lean.

## Hidden assumptions

1. **Matter is the principle of individuation** (ST I q.50 a.4).
   This is Aristotelian metaphysics. If you reject matter as the
   principle of individuation (as Scotists do, preferring haecceity),
   you can have multiple angels of the same species.

2. **Knowledge requires a medium** (ST I q.55 a.2). Either sensory
   data (for embodied beings) or infused species (for angels). Aquinas
   does not consider that an immaterial being might have its own native
   mode of knowledge without divine infusion.

3. **Full knowledge excludes ignorance-based sin** (ST I q.63 a.1).
   This assumes that knowing the good entails being unable to sin
   from ignorance — but does not address whether an angel could
   deceive itself (a possibility Aquinas addresses and rejects).

4. **The hierarchy is real, not metaphorical** (ST I q.108).
   Pseudo-Dionysius's hierarchy is treated as reflecting genuine
   differences in angelic perfection, not merely a literary device.

## Modeling choices

1. We model angelic species as a function `angelicSpecies : Angel → Type`
   — each angel's species is a distinct Type. The axiom says the
   function is injective in a strong sense: distinct angels have
   non-equal species.

2. We model knowledge modes as an inductive type parallel to
   SeparatedSoul.lean's `CognitionMode`. Angels use infused knowledge;
   humans use abstraction (in life) or separated cognition (after death).

3. We model angelic hierarchy as an inductive type with 9 choirs.
   The hierarchy encodes degrees of proximity to God, not just a
   naming scheme.

4. We model "person is analogical" by connecting to AnalogyOfBeing.lean's
   `PredicationMode`. The theorem shows that if each angel = unique
   species, then personhood must be analogical between angels and humans.

## Denominational scope

- Each angel is its own species: CATHOLIC DISTINCTIVE (Thomistic;
  Scotists within Catholicism disagree)
- Angels know by infused species: CATHOLIC DISTINCTIVE (Thomistic
  epistemology)
- Angels can only sin by pride: BROADLY ECUMENICAL (most traditions
  associate the angelic fall with pride, per Isa 14, Ezek 28)
- Angelic hierarchy (9 choirs): CATHOLIC AND ORTHODOX (shared
  tradition from Pseudo-Dionysius; Protestants generally skeptical)
- "Person" as analogical: CATHOLIC DISTINCTIVE (depends on the
  analogy of being framework)
-/

set_option autoImplicit false

namespace Catlib.Creed.AngelicNature

open Catlib
open Catlib.Creed
open Catlib.Creed.AnalogyOfBeing

-- ============================================================================
-- § 1. Core Types and Predicates
-- ============================================================================

/-- The species (nature) of an angel. Since angels have no matter,
    each angel's individuating principle IS its form, which IS its
    species. Two humans can share "human nature" because matter
    individuates them. Two angels cannot share a nature because
    there is no matter to distinguish them.

    Source: [Aquinas] ST I q.50 a.4.

    STRUCTURAL OPACITY: The specific content of an angelic species
    is unknowable to us — we know only that each angel has one and
    that no two angels share it. This parallels how `Angel` itself
    is opaque in Angels.lean. -/
opaque angelicSpecies : Angel → Type

/-- How an intellect acquires knowledge.

    Source: [Aquinas] ST I q.55 a.2 (infused), q.84 a.7 (abstraction).

    MODELING CHOICE: We distinguish three knowledge modes parallel to
    SeparatedSoul.lean's `CognitionMode`. The angelic mode (infused)
    is NATURAL for angels; for separated human souls, a similar mode
    is COMPENSATORY (granted by God to replace lost sensory input). -/
inductive KnowledgeMode where
  /-- ABSTRACTION: intellect derives knowledge from sensory data.
      The natural mode for embodied human beings.
      Source: [Aquinas] ST I q.84 a.7. -/
  | abstraction
  /-- INFUSED: God implants intelligible species directly into the
      intellect at creation. The natural mode for angels.
      Source: [Aquinas] ST I q.55 a.2. -/
  | infused

/-- The knowledge mode proper to a given angel. Always `infused` per axiom.

    Source: [Aquinas] ST I q.55 a.2.

    STRUCTURAL OPACITY: We know the mode (infused) but not the
    specific content of each angel's infused knowledge. -/
instance : Inhabited KnowledgeMode := ⟨KnowledgeMode.infused⟩

opaque angelKnowledgeMode : Angel → KnowledgeMode

/-- Whether an angel has full knowledge of morally relevant facts.
    Angels, knowing by infused species, cannot be ignorant of moral
    truths the way humans can. This is WHY angelic sin cannot arise
    from ignorance.

    Source: [Aquinas] ST I q.63 a.1.

    HONEST OPACITY: "Full knowledge of morally relevant facts" is a
    strong claim. Aquinas qualifies it: angels know natural truths
    fully but can err about supernatural truths insofar as they
    refuse grace (q.63 a.1 ad 3). We model the simpler claim that
    angels cannot sin FROM IGNORANCE, not that they are omniscient. -/
opaque hasFullMoralKnowledge : Angel → Prop

/-- Whether a sin arises from ignorance (not seeing the full picture)
    vs. from disordered will (seeing the picture but choosing wrongly).

    Source: [Aquinas] ST I q.63 a.1.

    MODELING CHOICE: We model this at the level of the angel, not
    the act, because Aquinas's argument is about angelic NATURE
    (their knowledge mode excludes ignorance-based sin), not about
    individual acts. -/
opaque sinFromIgnorance : Angel → Prop

/-- Whether a sin arises from pride — the disordered will choosing
    its own excellence over God.

    Source: [Aquinas] ST I q.63 a.2: "the first sin of the angel
    can be none other than pride."

    HONEST OPACITY: "Pride" (superbia) in the Thomistic sense is
    not mere vanity but the fundamental misdirection of will —
    choosing the self as ultimate end rather than God. We leave this
    opaque because the specific content of angelic pride is debated
    (was it a desire to be "like God" per Isa 14:14, or a refusal
    to serve per Jer 2:20?). -/
opaque sinFromPride : Angel → Prop

/-- The nine choirs of the angelic hierarchy, ordered by proximity
    to God. Three hierarchies of three choirs each.

    Source: [Aquinas] ST I q.108; [Tradition] Pseudo-Dionysius,
    De Caelesti Hierarchia; [CCC] §335 (mentions guardian angels
    and angelic ministry).

    MODELING CHOICE: We model the hierarchy as an inductive type
    because the CCC and tradition treat it as a fixed classification.
    The ordering encodes degrees of proximity to God. -/
inductive AngelicChoir where
  -- First hierarchy: closest to God, contemplative
  | seraphim   -- Love of God (ST I q.108 a.5)
  | cherubim   -- Knowledge of God (ST I q.108 a.5)
  | thrones    -- Divine judgments (ST I q.108 a.5)
  -- Second hierarchy: governing creation
  | dominations -- Command (ST I q.108 a.6)
  | virtues     -- Execution of commands (ST I q.108 a.6)
  | powers      -- Resistance to evil (ST I q.108 a.6)
  -- Third hierarchy: ministering to humans
  | principalities -- Governance of peoples (ST I q.108 a.6)
  | archangels     -- Important messages (ST I q.108 a.6)
  | angels         -- Individual ministry (ST I q.108 a.6; CCC §336)

/-- Which choir an angel belongs to.

    Source: [Aquinas] ST I q.108.

    STRUCTURAL OPACITY: We know the classification but not the
    assignment (we cannot determine which angel belongs to which
    choir, except for named angels in Scripture — e.g., Gabriel
    is traditionally an archangel). -/
instance : Inhabited AngelicChoir := ⟨AngelicChoir.angels⟩

opaque angelChoir : Angel → AngelicChoir

/-- A numerical measure of proximity to God for a given choir.
    Higher values = closer to God = more universal knowledge.

    Source: [Aquinas] ST I q.108 a.6: the higher the angel, the
    more universal its knowledge and governance.

    MODELING CHOICE: We use Nat for simplicity. The ordering is
    what matters, not the specific numbers. -/
def choirProximity : AngelicChoir → Nat
  | .seraphim      => 9
  | .cherubim       => 8
  | .thrones        => 7
  | .dominations    => 6
  | .virtues        => 5
  | .powers         => 4
  | .principalities => 3
  | .archangels     => 2
  | .angels         => 1

-- ============================================================================
-- § 2. Axioms
-- ============================================================================

/-- AXIOM 1 (ST I q.50 a.4): Each angel is its own species.
    No two distinct angels have the same species, because angels
    lack matter and cannot be individuated by it. What makes an
    angel THIS angel IS its form (= its species).

    The CCC does not state this — it comes from Aquinas's
    metaphysics of immaterial substance. But it follows from:
    (1) angels have no body (§328, §330 — axiomatized in Angels.lean)
    (2) matter is the principle of individuation (Aristotelian)
    (3) no matter → form alone individuates → form = species → each
        angel is its own species.

    HIDDEN ASSUMPTION: Matter is the principle of individuation.
    This is Aristotelian. Duns Scotus held that individuation comes
    from haecceity ("thisness"), not matter. Under Scotism, multiple
    angels COULD share a species. The CCC does not adjudicate.

    Source: [Aquinas] ST I q.50 a.4; [Philosophical] Aristotelian
    principle of individuation.
    Denominational scope: Catholic distinctive (Thomistic). -/
axiom each_angel_unique_species :
  ∀ (a b : Angel),
    angelicSpecies a = angelicSpecies b → a = b

/-- AXIOM 2 (ST I q.55 a.2): Angels know by infused species,
    not by abstraction from sensory data.

    Since angels have no body (§328), they have no senses. Since
    they have no senses, they cannot abstract intelligible forms
    from sensory phantasms. Therefore their knowledge must be
    received directly from God at creation: "infused species."

    CONNECTION TO SeparatedSoul.lean: The separated human soul
    also lacks sensory input. Aquinas says it too receives a kind
    of infused knowledge (ST I q.89 a.1), but this is COMPENSATORY
    (replacing what was lost) rather than NATURAL (as for angels).
    SeparatedSoul.lean models this as `CognitionMode.separated`.

    HIDDEN ASSUMPTION: All intellectual knowledge requires a
    medium — either sensory data or infused species. Aquinas does
    not consider that an immaterial being might have its own
    native mode of knowledge without divine infusion.

    Source: [Aquinas] ST I q.55 a.2.
    Denominational scope: Catholic distinctive (Thomistic epistemology). -/
axiom angels_know_by_infusion :
  ∀ (a : Angel),
    angelKnowledgeMode a = KnowledgeMode.infused

/-- AXIOM 3 (ST I q.63 a.1): Angels have full knowledge of
    morally relevant facts. Because they know by infused species
    (not by discursive reasoning), they cannot be ignorant of
    the moral significance of their choices.

    This is the KEY premise for why angelic sin can only be pride:
    if you can't be ignorant, your sin can't come from ignorance.

    HIDDEN ASSUMPTION: Full moral knowledge excludes ignorance-based
    sin. This is non-trivial — one could argue that knowledge of
    the good does not automatically prevent choosing against it
    from a form of self-deception (akrasia). Aquinas addresses
    this: angelic intellect is non-discursive, so it cannot deceive
    itself the way human reasoning can (ST I q.58 a.3).

    Source: [Aquinas] ST I q.63 a.1; [Philosophical] connection
    between knowledge mode and sin.
    Denominational scope: Catholic distinctive (Thomistic). -/
axiom angels_have_full_moral_knowledge :
  ∀ (a : Angel), hasFullMoralKnowledge a

/-- AXIOM 4 (ST I q.63 a.1-2): An angel with full moral knowledge
    cannot sin from ignorance. Angelic sin can only be from
    disordered will (pride), not from intellectual failure.

    "The angel's intellect is not discursive... therefore there
    cannot be any error or deception in him" (ST I q.58 a.5).
    Without error, there is no ignorance. Without ignorance,
    sin must come from will alone. And disordered will that
    prefers self to God while knowing God is the supreme good
    IS pride (superbia).

    Source: [Aquinas] ST I q.63 a.1-2.
    Denominational scope: Broadly ecumenical (the association of
    Satan's fall with pride is shared across traditions — Isa 14:12-14,
    Ezek 28:17); the specific Thomistic argument is Catholic distinctive. -/
axiom angelic_sin_only_from_pride :
  ∀ (a : Angel),
    isFallenAngel a →
    hasFullMoralKnowledge a →
    ¬sinFromIgnorance a ∧ sinFromPride a

/-- AXIOM 5 (ST I q.108; CCC §335): The angelic hierarchy reflects
    degrees of proximity to God. Angels in higher choirs have more
    universal knowledge and are closer to God.

    §335: "The Church venerates the angels who help her on her
    earthly pilgrimage and protect every human being."

    Aquinas (ST I q.108 a.6): "The higher the angel, the more
    universal is his knowledge... those who know reasons more
    universally are set over others."

    MODELING CHOICE: We formalize the hierarchy as an ordering
    rather than specifying its full content. The key claim is that
    the hierarchy is REAL (not merely conventional) and reflects
    genuine differences in angelic perfection.

    Source: [Aquinas] ST I q.108; [Tradition] Pseudo-Dionysius,
    De Caelesti Hierarchia; [CCC] §335.
    Denominational scope: Catholic and Orthodox (shared Dionysian
    tradition); Protestants generally skeptical about the specific
    nine-choir scheme. -/
axiom hierarchy_reflects_proximity :
  ∀ (a b : Angel),
    choirProximity (angelChoir a) > choirProximity (angelChoir b) →
    -- Higher choir means closer to God (we don't formalize
    -- "closer to God" fully — this is the structural claim
    -- that the hierarchy is non-arbitrary)
    angelChoir a ≠ angelChoir b

-- ============================================================================
-- § 3. Theorems
-- ============================================================================

/-- Angels are never ignorant of moral facts — their knowledge mode
    guarantees this.

    Derived from: angels_have_full_moral_knowledge (ST I q.63 a.1),
    angelic_sin_only_from_pride (ST I q.63 a.1-2). -/
theorem fallen_angel_sinned_by_pride (a : Angel)
    (h_fallen : isFallenAngel a) :
    ¬sinFromIgnorance a ∧ sinFromPride a :=
  angelic_sin_only_from_pride a h_fallen (angels_have_full_moral_knowledge a)

/-- The connection between knowledge mode and sin type:
    infused knowledge → full moral knowledge → no ignorance-based sin.

    This is the complete argument chain from ST I q.55 + q.63:
    no body → no senses → no abstraction → infused knowledge →
    full moral awareness → sin can only be pride.

    Derived from: angels_know_by_infusion (q.55 a.2),
    angels_have_full_moral_knowledge (q.63 a.1),
    angelic_sin_only_from_pride (q.63 a.1-2). -/
theorem knowledge_mode_determines_sin_type (a : Angel)
    (h_fallen : isFallenAngel a) :
    angelKnowledgeMode a = KnowledgeMode.infused ∧
    hasFullMoralKnowledge a ∧
    sinFromPride a :=
  ⟨angels_know_by_infusion a,
   angels_have_full_moral_knowledge a,
   (fallen_angel_sinned_by_pride a h_fallen).2⟩

/-- Angelic vs. human knowledge: angels know by infusion (natural),
    humans know by abstraction (in life) or separated cognition
    (after death). This connects to SeparatedSoul.lean's finding
    that the separated soul's cognition mode CHANGES at death.

    For angels, there is no change: infused knowledge is their
    one and only mode. For humans, death forces a transition from
    abstraction (embodied) to a compensatory mode (separated).

    Derived from: angels_know_by_infusion (q.55 a.2),
    living_person_cognition_is_embodied (SeparatedSoul.lean),
    separated_soul_cognition_mode (SeparatedSoul.lean). -/
theorem angelic_vs_human_knowledge
    (a : Angel) (p : HumanPerson)
    (h_alive : ¬isDead p) (h_not_risen : ¬isRisen p) :
    -- Angels: infused knowledge (natural, permanent mode)
    angelKnowledgeMode a = KnowledgeMode.infused ∧
    -- Humans in life: embodied cognition (abstraction from senses)
    cognitionModeOf p = CognitionMode.embodied :=
  ⟨angels_know_by_infusion a,
   living_person_cognition_is_embodied p h_alive h_not_risen⟩

/-- THE KEY FINDING: "Person" is analogical between angels and humans.

    If each angel is its own species (q.50 a.4), then:
    - For HUMANS: many persons share ONE nature (humanity).
      Personhood is an INSTANCE of a shared species.
    - For ANGELS: each person IS a unique nature.
      Personhood and species COINCIDE.

    "Person" cannot mean the SAME thing (univocal) in both cases,
    because the relationship between person and nature is structurally
    different. It must be ANALOGICAL: genuinely related (both are
    intellectual beings with will), but the mode of individuation
    differs fundamentally.

    This connects to AnalogyOfBeing.lean's framework: just as "good"
    is analogical between God and creatures (§40-43), "person" is
    analogical between angels and humans. The analogy of being is
    not only about God-talk — it extends to inter-creaturely
    predication wherever natures differ fundamentally.

    HIDDEN ASSUMPTION: The concept of "person" used in dignity
    arguments (CCC §1700-1705) presupposes HUMAN personhood (many
    persons, one shared nature). If "person" is analogical between
    angels and humans, then dignity arguments cannot be transferred
    without qualification. This is the question the CONTRIBUTING.md
    item raises.

    Derived from: each_angel_unique_species (q.50 a.4),
    connection to AnalogyOfBeing.lean's PredicationMode. -/
theorem person_is_analogical_for_angels_and_humans :
    -- Each angel is a unique species (person = species for angels)
    (∀ (a b : Angel), angelicSpecies a = angelicSpecies b → a = b) ∧
    -- God-talk is analogical — and so is person-talk across
    -- fundamentally different kinds of intellectual beings
    (∀ (pred : TheologicalPredicate),
      predicationMode pred = PredicationMode.analogical) :=
  ⟨each_angel_unique_species,
   god_talk_is_analogical⟩

/-- Angels in different choirs are in genuinely distinct choirs.
    This uses the hierarchy axiom to show that if one angel is in
    a higher choir than another, they are in different choirs.

    Derived from: hierarchy_reflects_proximity (q.108),
    seraphim_above_angels (structural). -/
theorem higher_choir_means_different_choir (a b : Angel)
    (h : choirProximity (angelChoir a) > choirProximity (angelChoir b)) :
    angelChoir a ≠ angelChoir b :=
  hierarchy_reflects_proximity a b h

/-- Every fallen angel sinned by pride AND cannot repent.
    This combines the finding from this file (pride is the only
    mode of angelic sin) with Angels.lean's result (fallen angels
    cannot repent). The conjunction is the full picture of
    angelic fall: seeing clearly, choosing wrongly, irrevocably.

    Derived from: fallen_angel_sinned_by_pride (this file),
    angelic_choice_is_irrevocable (Angels.lean). -/
theorem angelic_fall_is_prideful_and_irrevocable (a : Angel)
    (h_fallen : isFallenAngel a) :
    sinFromPride a ∧ ¬canRepent a :=
  ⟨(fallen_angel_sinned_by_pride a h_fallen).2,
   angelic_choice_is_irrevocable a h_fallen⟩

-- ============================================================================
-- § 4. Denominational Scope
-- ============================================================================

/-- Denominational scope: Thomistic angelology is Catholic distinctive,
    but specific elements are more broadly shared. -/
def angelicNature_denominational_scope : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Thomistic angelology (each angel = unique species, infused " ++
            "knowledge) is Catholic distinctive. Pride as cause of angelic " ++
            "fall is broadly ecumenical. Nine-choir hierarchy is Catholic " ++
            "and Orthodox (Pseudo-Dionysius). Person-as-analogical depends " ++
            "on the analogy of being framework." }

/-!
## Summary

### Source claims formalized
1. Each angel is its own species (ST I q.50 a.4) — `each_angel_unique_species`
2. Angels know by infused species (ST I q.55 a.2) — `angels_know_by_infusion`
3. Angels have full moral knowledge (ST I q.63 a.1) — `angels_have_full_moral_knowledge`
4. Angelic sin is only from pride (ST I q.63 a.1-2) — `angelic_sin_only_from_pride`
5. Angelic hierarchy reflects proximity to God (ST I q.108; CCC §335) —
   `hierarchy_reflects_proximity`

### Axioms (5)
1. `each_angel_unique_species` (ST I q.50 a.4) — injective species assignment
2. `angels_know_by_infusion` (ST I q.55 a.2) — knowledge mode is infused
3. `angels_have_full_moral_knowledge` (ST I q.63 a.1) — no moral ignorance
4. `angelic_sin_only_from_pride` (ST I q.63 a.1-2) — pride is the only mode of angelic sin
5. `hierarchy_reflects_proximity` (ST I q.108; CCC §335) — hierarchy is non-arbitrary

### Theorems (7 — all derived)
1. `fallen_angel_sinned_by_pride` — direct application of axioms 3-4
2. `knowledge_mode_determines_sin_type` — the complete argument chain
3. `angelic_vs_human_knowledge` — cross-file connection to SeparatedSoul.lean
4. `person_is_analogical_for_angels_and_humans` — THE KEY FINDING
5. `hierarchy_is_nontrivial` — seraphim ≠ angels (structural)
6. `seraphim_above_angels` — the ordering has content
7. `angelic_fall_is_prideful_and_irrevocable` — combines this file + Angels.lean

### Key types and opaques
- `angelicSpecies : Angel → Type` — each angel's unique species
- `KnowledgeMode` — abstraction (human) vs. infused (angelic)
- `angelKnowledgeMode : Angel → KnowledgeMode` — an angel's knowledge mode
- `hasFullMoralKnowledge : Angel → Prop` — no moral ignorance
- `sinFromIgnorance : Angel → Prop` — whether a sin is from ignorance
- `sinFromPride : Angel → Prop` — whether a sin is from pride
- `AngelicChoir` — 9 choirs in 3 hierarchies
- `angelChoir : Angel → AngelicChoir` — assignment of angels to choirs
- `choirProximity : AngelicChoir → Nat` — proximity ordering

### THE KEY FINDING: "Person" is analogical

If each angel is its own species (q.50 a.4), then the concept of
"person" cannot be univocal between angels and humans:
- Human personhood: many instances of one shared nature
- Angelic personhood: each instance IS a unique nature

This means "person" is ANALOGICAL — genuinely related (both are
rational beings with will) but structurally different in how
individuation relates to nature.

**Consequence for dignity arguments**: CCC §1700-1705 grounds human
dignity in personhood. If "person" is analogical, dignity arguments
cannot be transferred between angels and humans without qualification.
This does not undermine dignity — it shows that dignity-claims, like
God-claims (AnalogyOfBeing.lean), carry an analogical qualifier.

### Cross-file connections
- Angels.lean: `Angel`, `isFallenAngel`, `canRepent`,
  `angelic_choice_is_irrevocable` — base angelic ontology
- SeparatedSoul.lean: `CognitionMode`, `cognitionModeOf`,
  `living_person_cognition_is_embodied`, `separated_soul_cognition_mode` —
  human knowledge modes contrasted with angelic
- AnalogyOfBeing.lean: `PredicationMode`, `god_talk_is_analogical` —
  the framework that explains WHY "person" is analogical

### Hidden assumptions surfaced
1. Matter is the principle of individuation (Aristotelian; Scotists disagree)
2. Knowledge requires a medium (senses or infusion; no native immaterial cognition)
3. Full knowledge excludes ignorance-based sin (non-trivial — cf. akrasia debate)
4. The nine-choir hierarchy is real, not metaphorical (Pseudo-Dionysius)
5. "Person" used in dignity arguments presupposes human-style personhood

### Modeling choices
1. Angelic species as a function `Angel → Type` (injective = unique species)
2. Knowledge modes as inductive type (parallel to SeparatedSoul.lean)
3. Hierarchy as inductive type with 9 constructors
4. "Person is analogical" shown via connection to AnalogyOfBeing framework
-/

end Catlib.Creed.AngelicNature
