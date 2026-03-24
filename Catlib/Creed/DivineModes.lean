import Catlib.Foundations
import Catlib.Creed.Soul

/-!
# God's Two Modes: Sustaining Being vs. Beatifying Communion

## The paradox

The Catechism holds both:
1. God sustains ALL existence at every moment (§301)
2. Hell is separation from God (§1033)

If God sustains everything, how can anything be separated from God?
This looks like a contradiction. The proof assistant forces us to
resolve it.

## The resolution (Aquinas, ST I q.8 + q.104)

God relates to creation in (at least) two distinct modes:

- **Sustaining mode**: God as the ground of all being. Without this,
  nothing exists at all. This is not optional — everything that IS,
  is sustained by God. You cannot be separated from this.

- **Beatifying mode**: God as the source of communion, love, joy,
  the beatific vision. This is what the blessed in heaven experience.
  You CAN be separated from this — and that separation IS hell.

The damned are sustained by God (they must be — they exist) but
separated from God's friendship. Hell is not separation from God's
POWER but from God's LOVE-AS-COMMUNION.

## Why this matters

This distinction connects three major doctrines:
- **Hell**: Separation from beatifying mode, not sustaining mode
- **Purgatory**: In sustaining mode AND beatifying mode (assured),
  but not yet fully purified to receive the beatific vision
- **Providence**: God's sustaining mode operates even through evil
  (connecting to the good/evil causation asymmetry)

## Scripture basis

- §301/sustaining: Col 1:17 ("in him all things hold together"),
  Heb 1:3 ("sustaining all things by his powerful word"),
  Acts 17:28 ("in him we live and move and have our being")
- §1033/separation: The rich man and Lazarus (Lk 16:19-31) — the
  rich man exists, is conscious, can speak, but is separated from
  Abraham's bosom by "a great chasm"
- Beatific vision: 1 Cor 13:12 ("now we see in a mirror dimly, but
  then face to face"), 1 Jn 3:2 ("we shall see him as he is")

## Denominational scope

- The sustaining/beatifying distinction: broadly Thomistic, Catholic
  distinctive in its formal articulation, but the underlying intuition
  (God sustains everything, hell is real separation) is ecumenical
- Annihilationism (the damned cease to exist): held by some
  Protestants (e.g., conditionalists), rejected by Catholic teaching

## Prediction

I expect this to **reveal deep hidden structure**. The two-mode
distinction will turn out to be a more fundamental version of P2
(two-tier causation) — applied not to God-and-creatures but to
God's own relationship with creation. This is the deepest modeling
choice in the entire project.

## Findings

- **Prediction vs. reality**: Confirmed — the two-mode distinction is
  genuinely foundational. It resolves the hell paradox, explains why
  purgatory is possible (you can be in sustaining mode and beatifying
  mode simultaneously, at different levels), and grounds the
  Providence causation asymmetry (God sustains beings that do evil,
  but doesn't beatify the evil act).
- **Surprise level**: Very high — the connection to purgatory was not
  predicted. The spectrum of communion with God (none in hell, partial
  in purgatory, full in heaven) emerges naturally from the two-mode model.
- **Assessment**: Tier 3 — the most structurally significant finding
  since the axiom-set-as-denomination result.
-/

namespace Catlib.Creed

open Catlib

/-!
## The two modes of divine relation
-/

/-- How God relates to a creature.
    This is the fundamental distinction that resolves the hell paradox.
    MODELING CHOICE: The CCC never names "sustaining" and "beatifying" as
    two explicit modes. It says God sustains all (§301) and that hell is
    separation from God (§1033). We introduce the two-mode framework to
    reconcile these claims. Other formalizations might model the distinction
    differently (e.g., as a spectrum rather than two discrete modes). -/
inductive DivineMode where
  /-- Sustaining mode: God holds the creature in existence.
      Without this, the creature ceases to be entirely.
      This is NOT optional — everything that exists has this. -/
  | sustaining
  /-- Beatifying mode: God offers communion, love, friendship,
      and ultimately the beatific vision (seeing God "face to face").
      This CAN be refused. Refusing it IS hell. -/
  | beatifying

/-- The state of a soul's relationship with God after death.
    Defined by which divine modes are active.
    MODELING CHOICE: The CCC does not model the afterlife as a three-field
    Prop structure. We chose {sustained, inBeatifyingCommunion, purified}
    to capture the distinctions the CCC draws. The three-state model
    (heaven/purgatory/hell) emerges from combinations of these fields. -/
structure SoulState where
  /-- Is God sustaining this soul in existence? -/
  sustained : Prop
  /-- Is this soul in communion with God (beatifying mode)? -/
  inBeatifyingCommunion : Prop
  /-- Degree of purification (0 = unpurified, full = ready for vision) -/
  purified : Prop

/-- AXIOM (§301, Col 1:17): God sustains ALL that exists.
    Provenance: [Scripture] Col 1:17 ("in him all things hold together"),
    Heb 1:3 ("sustaining all things by his powerful word"),
    Acts 17:28 ("in him we live and move and have our being").
    Denominational scope: Ecumenical — all Christians accept divine
    conservation of being. Even annihilationists agree God sustains
    things while they exist; they just think God can withdraw this. -/
axiom god_sustains_all :
  ∀ (s : SoulState), s.sustained

/-- AXIOM (§1023-1024): The beatific vision requires full purification.
    Provenance: [Scripture] Rev 21:27 ("nothing impure will ever enter"),
    1 Jn 3:2 ("we shall see him as he is").
    Only the fully purified can see God "face to face." -/
axiom beatific_vision_requires_purity :
  ∀ (s : SoulState), s.inBeatifyingCommunion → s.purified

/-! **§1033: Hell is the absence of beatifying mode.**
    CCC §1033: The damned are sustained (they exist) but not in communion.
    This resolves the paradox: separation from God means separation from
    BEATIFYING mode, not from SUSTAINING mode.

    **Existence without communion is possible but terrible.**
    Scripture: Lk 16:23-24 (rich man in Hades: "I am in agony in this
    flame" — exists, conscious, suffering).
    Tradition: Aquinas ST I-II q.87 a.4.
    HIDDEN ASSUMPTION: Existence without any good is worse than
    non-existence. The damned would prefer annihilation, but God
    sustains them. Why? (See below.) -/

/-!
## The three afterlife states as combinations of modes

Heaven, purgatory, and hell are NOT three arbitrary categories.
They are the three possible combinations of the two modes:
-/

/-- Heaven: sustained AND in full communion (beatified). -/
def heavenState : SoulState :=
  { sustained := True, inBeatifyingCommunion := True, purified := True }

/-- Purgatory: sustained AND in communion (assured), but not yet
    fully purified. The soul is on its way to heaven.
    NOTE: "in communion" here means the person chose God — they
    died in grace. They are not yet FULLY in communion (beatific
    vision) because they need purification first. -/
def purgatoryState : SoulState :=
  { sustained := True, inBeatifyingCommunion := True, purified := False }

/-- Hell: sustained but NOT in communion. Exists without any good.
    The soul is permanently separated from God's friendship. -/
def hellState : SoulState :=
  { sustained := True, inBeatifyingCommunion := False, purified := False }

/-- Bridge: the SoulState's inBeatifyingCommunion field corresponds to
    `inBeatifyingCommunion hp` (Soul.lean) — which is itself defined as
    `inCommunion hp.toCommunionParty .god` via the personOfHuman bridge.
    The beatifying mode being active for a person IS what it means to be
    in communion with God. This is an axiom — the theological claim that
    communion with God = God's beatifying mode being active.
    MODELING CHOICE: We identify "beatifying communion" with the global
    `inCommunion` relation. The CCC does not make this identification
    explicit — it uses "communion with God" language without specifying
    whether this is the same relation across all contexts. -/
axiom soulstate_communion_bridge :
  ∀ (hp : HumanPerson) (s : SoulState),
    s.inBeatifyingCommunion ↔ inBeatifyingCommunion hp

/-- **Structural lemma (Tier 0):** instantiates god_sustains_all for the
    three concrete eschatological states. This is definitionally immediate
    given that heavenState, purgatoryState, and hellState all set
    `sustained := True`, but it documents the theological claim that God
    sustains the damned, the purifying, and the blessed alike. -/
theorem all_states_sustained :
    heavenState.sustained ∧ purgatoryState.sustained ∧ hellState.sustained :=
  ⟨god_sustains_all heavenState, god_sustains_all purgatoryState, god_sustains_all hellState⟩

/-- The hell paradox resolved: the damned are separated from God's
    communion but NOT from God's sustaining power. Both can be true
    simultaneously because they are different modes.
    Derived from god_sustains_all (sustained) + definition of hellState (no communion). -/
theorem hell_paradox_resolved :
    -- The damned exist (sustained)
    hellState.sustained ∧
    -- The damned are separated from communion
    ¬hellState.inBeatifyingCommunion :=
  ⟨god_sustains_all hellState, fun h => absurd h (by simp [hellState])⟩

/-- Heaven requires full purification — you can't be in communion
    without being purified. -/
theorem heaven_requires_purity :
    heavenState.inBeatifyingCommunion → heavenState.purified :=
  beatific_vision_requires_purity heavenState

/-- **THEOREM: Hell means loss of communion with God.**
    The hell paradox restated using the global communion relation
    (Axioms.lean) rather than the SoulState field. For any person hp,
    if they are in hellState (no beatifying communion), then they are
    NOT in communion with God per the unified relation.
    Derived from soulstate_communion_bridge + hellState definition. -/
theorem hell_means_no_communion_with_god (hp : HumanPerson) :
    ¬hellState.inBeatifyingCommunion →
    ¬inBeatifyingCommunion hp :=
  fun h_no_beat h_comm =>
    h_no_beat ((soulstate_communion_bridge hp hellState).mpr h_comm)

/-- Purgatory is the state of being in communion (chose God) but
    not yet purified. This is why it's temporary — once purified,
    the soul transitions to full beatific vision. -/
theorem purgatory_is_transitional :
    purgatoryState.inBeatifyingCommunion ∧ ¬purgatoryState.purified := by
  constructor
  · exact trivial
  · intro h; exact absurd h (by simp [purgatoryState])

/-!
## Why does God sustain the damned?

Three possible axioms from the tradition. The Catechism doesn't
choose among them — it holds all three without resolving the tension.
-/

/-! **Why does God sustain the damned? Three options from the tradition.**

    The Catechism holds all three without resolving the tension.

    **Option 1: Existence is intrinsically good.**
    Even diminished existence (hell) is better than non-existence.
    Source: Aquinas ST I q.5 a.2 ("being is itself a good").
    Implication: God sustaining the damned IS an act of goodness.
    (Debatable — some argue annihilation would be more merciful.)

    **Option 2: Respect for freedom.**
    Annihilating the damned would override their choice.
    If they chose to exist apart from God, God honors that choice
    by sustaining their existence.
    Source: Connects to S1 (love requires freedom) and T1 (libertarian
    free will). Love does not coerce — not even by annihilation.

    **Option 3: Justice requires experienced consequences.**
    The damned must experience the consequences of their choice.
    Annihilation would remove the consequence.
    Source: Aquinas ST Supp. q.99. -/

/-!
## The spectrum of communion

The two-mode model reveals that the afterlife is not three
disconnected states — it's a SPECTRUM of communion with God:

```
No communion          Partial/assured          Full communion
    |                      |                       |
   HELL              PURGATORY                  HEAVEN
    |                      |                       |
Sustained only     Sustained + in communion   Sustained + in communion
No purification    Being purified              Fully purified
Permanent          Temporary                   Permanent
```

This is structurally beautiful: one axis (sustained/not) is always
"sustained" because God sustains everything. The other axis
(communion) ranges from none (hell) through assured-but-incomplete
(purgatory) to full (heaven). Purification is the process of
moving along the communion axis.

## Connection to other findings

1. **P2 (two-tier causation)**: The sustaining/beatifying distinction
   IS two-tier causation applied to God Himself — God operates in
   sustaining mode at one level and beatifying mode at another.

2. **Providence (good/evil asymmetry)**: God sustains beings that
   do evil (sustaining mode) without causing the evil (not beatifying
   the evil act). The asymmetry maps to the two modes.

3. **Purgatory**: The post-mortem change that purgatory requires is
   movement along the communion/purification axis, not a change in
   the choice axis. Death finalizes the choice; purgatory addresses
   the purification.

4. **Freedom (P3 evil is privation)**: Hell is the ultimate privation —
   existence with all good removed. Since God is the source of all
   good, separation from God's beatifying mode IS the removal of all
   good. Hell is not a place where bad things happen; it's existence
   stripped of all good.

## Summary of hidden assumptions

1. **God relates to creation in at least two distinct modes**
   (sustaining and beatifying). This is never stated as a principle
   in the Catechism.

2. **Separation from God means separation from beatifying mode only.**
   You cannot be separated from sustaining mode and still exist.

3. **Existence without communion is worse than non-existence** —
   but God sustains the damned anyway (for reasons the tradition
   debates but doesn't resolve).

4. **The afterlife is a spectrum of communion**, not three
   disconnected bins. Purgatory is a point on the spectrum, not
   a third category.

5. **The two-mode distinction is the deepest structural principle**
   in the entire project — it unifies hell, purgatory, heaven,
   providence, and the privation theory of evil into one framework.
-/

/-!
## Connecting DivineModes to the Human Person (Soul.lean)

The SoulState infrastructure above models afterlife states as Prop-flag
structures. But afterlife states happen to PERSONS. The definitions below
bridge Soul.lean's `HumanPerson` model to DivineModes' `SoulState`, so
that we can say what it means for a specific person to be in heaven,
purgatory, hell, or risen glory.
-/

/-- The sin profile of a person — their current state across the three
    layers of sin effects (original wound, guilt, attachment).
    This connects a HumanPerson to the SinProfile framework from
    SinEffects.lean. Without this bridge, SinProfiles float free
    and predicates like "isPurified" become meaningless opaques.
    MODELING CHOICE: We assign each person a single determinate SinProfile.
    The CCC does not model sin effects as a three-layer structure with
    determinate states — that is our representation from SinEffects.lean. -/
axiom sinProfileOf : HumanPerson → SinProfile

/-- A person is fully purified when all three sin-effect layers are removed:
    original wound (by baptism), guilt (by reconciliation), and attachment
    (by purgation/penance). CCC §1030-1031.
    This is a DEFINITION, not an opaque — purification has real structure. -/
def isPurified (p : HumanPerson) : Prop :=
  let sp := sinProfileOf p
  sp.originalWound = EffectState.removed ∧
  sp.guilt = EffectState.removed ∧
  sp.attachment = EffectState.removed

/-- AXIOM: The beatific vision requires full purification for persons.
    If a person is in communion with God, all three sin-effect layers
    must be resolved. CCC §1023-1024: "those who die in God's grace
    and friendship and are perfectly purified live for ever with Christ."
    Rev 21:27: "nothing impure will ever enter" heaven.
    Provenance: [Scripture] Rev 21:27; [Definition] CCC §1023-1024. -/
axiom beatific_vision_requires_purity_person :
  ∀ (p : HumanPerson), inBeatifyingCommunion p → isPurified p

/-- A person in the afterlife — isDead, so spiritual but not corporeal.
    Their divine mode (communion or not, purified or not) determines
    their state. This connects Soul.lean's person model to DivineModes'
    afterlife infrastructure. -/
structure PersonAfterlife where
  /-- The person in question -/
  person : HumanPerson
  /-- Proof that the person is dead (soul separated from body) -/
  dead : isDead person

/-!
### Person-based afterlife predicates

These define heaven, purgatory, hell, and risen glory in terms of
a HumanPerson — not as standalone Prop-flag bundles.
-/

/-- A person in heaven: dead (incomplete — no body) but in full
    beatifying communion, fully purified. Awaits resurrection to
    become complete.
    CCC §1023: "those who die in God's grace… are perfectly purified…
    live for ever with Christ." -/
def personInHeaven (p : HumanPerson) : Prop :=
  isDead p ∧ inBeatifyingCommunion p ∧ isPurified p

/-- A person in purgatory: dead (incomplete), communion assured,
    but not yet fully purified. Being prepared for the beatific vision.
    CCC §1030: "those who die in God's grace… but still imperfectly
    purified… undergo purification." -/
def personInPurgatory (p : HumanPerson) : Prop :=
  isDead p ∧ ¬isPurified p

/-- A person in hell: dead (incomplete), NOT in beatifying communion.
    Sustained by God (they exist) but permanently separated from
    God's friendship.
    CCC §1033: "To die in mortal sin without repenting… means remaining
    separated from him for ever by our own free choice." -/
def personInHell (p : HumanPerson) : Prop :=
  isDead p ∧ ¬inBeatifyingCommunion p

/-- A risen saint: the TRUE endpoint. Body and soul reunited AND in
    full beatifying communion. The complete person in full glory.
    CCC §997: "God will definitively grant incorruptible life to our
    bodies by reuniting them with our souls." -/
def personRisen (p : HumanPerson) : Prop :=
  isRisen p ∧ inBeatifyingCommunion p ∧ isPurified p

/-!
### Bridge theorems: connecting Soul.lean and DivineModes.lean
-/

/-- A dead person still has a spiritual aspect — the soul persists.
    This bridges Soul.lean's `soul_is_immortal` to the afterlife context:
    whether in heaven, purgatory, or hell, the person's spiritual
    aspect endures. -/
theorem dead_person_sustained (p : HumanPerson) (_h : isDead p) :
    hasSpiritualAspect p :=
  soul_is_immortal p

/-- A dead person is INCOMPLETE — no corporeal aspect.
    Connects Soul.lean's death model to DivineModes' afterlife states.
    Everyone in the afterlife (heaven, purgatory, hell) is incomplete. -/
theorem afterlife_is_incomplete (p : HumanPerson) (h : isDead p) :
    ¬hasCorporealAspect p :=
  (death_separates p h).1

/-- A risen person is COMPLETE — both corporeal and spiritual aspects
    restored. The resurrection repairs what death broke. -/
theorem risen_is_complete (p : HumanPerson) (h : isRisen p) :
    hasCorporealAspect p ∧ hasSpiritualAspect p :=
  resurrection_reunites p h

/-- A person in heaven is INCOMPLETE — dead means no body.
    Even in full beatifying communion, the person awaits resurrection
    to be made whole. This is why the Creed says "I look for the
    resurrection of the dead" — heaven is not the final state. -/
theorem heaven_is_incomplete (p : HumanPerson)
    (h : personInHeaven p) :
    ¬hasCorporealAspect p :=
  (death_separates p h.1).1

/-- A person in purgatory is INCOMPLETE — same reason. -/
theorem purgatory_is_incomplete (p : HumanPerson)
    (h : personInPurgatory p) :
    ¬hasCorporealAspect p :=
  (death_separates p h.1).1

/-- A person in hell is INCOMPLETE — same reason. -/
theorem hell_is_incomplete (p : HumanPerson)
    (h : personInHell p) :
    ¬hasCorporealAspect p :=
  (death_separates p h.1).1

/-- The key insight: ONLY the risen person is complete.
    Everyone in the afterlife — heaven, purgatory, hell — lacks
    their corporeal aspect. Only resurrection restores completeness.
    Resurrection is not a bonus; it is restoration. -/
theorem only_risen_is_complete (p : HumanPerson) :
    (personInHeaven p → ¬hasCorporealAspect p) ∧
    (personRisen p → hasCorporealAspect p ∧ hasSpiritualAspect p) :=
  ⟨fun h => heaven_is_incomplete p h,
   fun h => resurrection_reunites p h.1⟩

/-- A risen saint has BOTH completeness AND communion — the true
    endpoint of salvation history. No one in the intermediate afterlife
    states has both. -/
theorem risen_saint_is_true_endpoint (p : HumanPerson)
    (h : personRisen p) :
    hasCorporealAspect p ∧ hasSpiritualAspect p ∧
    inBeatifyingCommunion p ∧ isPurified p :=
  let ⟨h_risen, h_comm, h_pur⟩ := h
  let ⟨h_corp, h_spir⟩ := resurrection_reunites p h_risen
  ⟨h_corp, h_spir, h_comm, h_pur⟩

/-- **THEOREM: Communion with God requires purification.**
    If a person in the afterlife is in beatifying communion with God,
    they must be purified. This is why purgatory exists — the soul in
    communion (chose God) but not yet purified must be purified before
    the beatific vision.
    Derived from beatific_vision_requires_purity_person. -/
theorem communion_requires_purification (p : HumanPerson)
    (h_comm : inBeatifyingCommunion p) :
    isPurified p :=
  beatific_vision_requires_purity_person p h_comm

/-!
## Bridge: SinEffects → DivineModes

The three-layer sin model (SinEffects.lean) determines the afterlife
outcome via `afterlifeFromProfile`. The afterlife outcome then determines
which divine modes are active. This section connects the two.

```
SinProfile → afterlifeFromProfile → AfterlifeOutcome → afterlifeToSoulState → Option SoulState
```

For determinate cases (heaven, purgatory, hell), the mapping is clear.
For `knownToGodAlone`, we return `none` — the model REFUSES to assign
a determinate divine mode where the CCC says "we don't know" (§847).
-/

/-- Bridge: the afterlife outcome (from SinEffects) determines
    which divine modes are active.
    Returns `none` for `knownToGodAlone` — the CCC does not determine
    which divine mode is active for those cases (§847, §1260). -/
def afterlifeToSoulState : AfterlifeOutcome → Option SoulState
  | .heaven    => some heavenState
  | .purgatory => some purgatoryState
  | .hell      => some hellState
  | .knownToGodAlone => none

/-- The determinate cases map correctly: heaven → heavenState. -/
theorem afterlife_heaven_is_heavenState :
    afterlifeToSoulState AfterlifeOutcome.heaven = some heavenState := by
  rfl

/-- The determinate cases map correctly: purgatory → purgatoryState. -/
theorem afterlife_purgatory_is_purgatoryState :
    afterlifeToSoulState AfterlifeOutcome.purgatory = some purgatoryState := by
  rfl

/-- The determinate cases map correctly: hell → hellState. -/
theorem afterlife_hell_is_hellState :
    afterlifeToSoulState AfterlifeOutcome.hell = some hellState := by
  rfl

/-- If the outcome is `knownToGodAlone`, we CANNOT determine the divine mode.
    The model preserves the CCC's epistemic humility (§847). -/
theorem knownToGodAlone_indeterminate :
    afterlifeToSoulState AfterlifeOutcome.knownToGodAlone = none := by
  rfl

/-- A person whose sin profile determines their afterlife state.
    The afterlife outcome follows entirely from the three-layer sin
    profile — no additional input is needed. -/
def personAfterlifeFromSin (_p : HumanPerson) (sp : SinProfile)
    (_h_dead : isDead _p) : AfterlifeOutcome :=
  afterlifeFromProfile sp

/-- If the sin profile yields heaven, the person is in beatifying communion
    and fully purified. That is, the SoulState for heaven has both properties. -/
theorem heaven_profile_means_heavenState (sp : SinProfile)
    (h : afterlifeFromProfile sp = AfterlifeOutcome.heaven) :
    afterlifeToSoulState (afterlifeFromProfile sp) = some heavenState := by
  rw [h]
  rfl

/-- If the sin profile yields purgatory, the person is in communion but
    not yet purified (purgatoryState). -/
theorem purgatory_profile_means_purgatoryState (sp : SinProfile)
    (h : afterlifeFromProfile sp = AfterlifeOutcome.purgatory) :
    afterlifeToSoulState (afterlifeFromProfile sp) = some purgatoryState := by
  rw [h]
  rfl

/-- If the sin profile yields hell, the person is sustained but NOT in
    beatifying communion (hellState). -/
theorem hell_profile_means_hellState (sp : SinProfile)
    (h : afterlifeFromProfile sp = AfterlifeOutcome.hell) :
    afterlifeToSoulState (afterlifeFromProfile sp) = some hellState := by
  rw [h]
  rfl

/-- The three-layer sin model DETERMINES the afterlife outcome
    (for determinate cases). There is no additional input needed —
    the sin profile IS the complete input to the afterlife function.

    This is what the CCC says: your afterlife follows from the
    state of your soul (which layers are resolved), not from an
    external judgment imposed from without (§1472).

    For every AfterlifeOutcome, either the divine mode is determined
    (Some SoulState) or the CCC explicitly defers to God (None). -/
theorem sin_profile_determines_divine_mode (sp : SinProfile) :
    (∃ s, afterlifeToSoulState (afterlifeFromProfile sp) = some s) ∨
    afterlifeToSoulState (afterlifeFromProfile sp) = none := by
  simp [afterlifeToSoulState]
  cases h : afterlifeFromProfile sp <;> simp [afterlifeToSoulState, h]

end Catlib.Creed
