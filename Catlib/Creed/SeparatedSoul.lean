import Catlib.Foundations
import Catlib.Creed.Soul
import Catlib.Creed.DivineModes

/-!
# CCC §366, §1023, §1030-1037: Can a Separated Soul Think and Will?

## The source claims

§366: "The soul does not perish when it separates from the body at death."

§1023: "Those who die in God's grace and friendship and are perfectly
purified live for ever with Christ." (Implies awareness — living with
someone requires knowing them.)

§1030-1032: Purgatory involves "purification, so as to achieve the
holiness necessary to enter the joy of heaven." (Implies the soul
DOES something — is acted upon, responds, changes state.)

§1033-1037: Hell involves "definitive self-exclusion from communion
with God" and "the state of definitive self-exclusion from communion
with God and the blessed." (Implies awareness of separation.)

§997: "The soul goes to meet God, while awaiting its reunion with
its glorified body." (Implies activity — going, meeting, awaiting.)

## The puzzle

Under hylomorphism (§365), the soul is the "form" of the body. If the
soul is separated from the body at death, can it still think and will?

This matters because:
- If the separated soul CANNOT think or will, then purgatory (progressive
  purification), hell (awareness of separation), and heaven (beatific
  vision) are all impossible in the intermediate state.
- If the separated soul CAN think and will, we need to explain HOW —
  since in life, intellect works through sensory data (Aquinas, ST I q.84).

## The CCC's implicit answer: YES

The CCC never explicitly addresses HOW the separated soul cognizes.
But it IMPLIES cognition in all three afterlife states:

1. **Purgatory** involves progressive purification (§1030-1031).
   Progressive change requires some form of activity — the soul is
   not inert but undergoing transformation.

2. **Hell** involves awareness of separation from God (§1033-1037).
   Awareness requires intellect. Suffering requires will (to experience
   loss, you must have desired the good).

3. **Heaven** involves the beatific vision — seeing God "face to face"
   (§1023, 1 Cor 13:12). Vision requires intellect. Joy requires will.

## Aquinas's explicit answer (ST I q.89)

Aquinas argues that the separated soul CAN know, but DIFFERENTLY:

- **In the body**: intellect knows through sensory data (abstraction
  from phantasms). The soul uses the body as an instrument of knowledge.
- **Separated**: intellect knows through direct divine illumination
  (like angels know). God supplies intelligible species directly.
- The separated soul knows MORE DIRECTLY but LESS RICHLY — no sensory
  detail, no imagination, no embodied experience.

This is why the separated soul is INCOMPLETE (Soul.lean) but not INERT.
The powers persist; the MODE changes.

## Hidden assumptions

1. **Intellect and will are powers of the SOUL, not the body** (§1705).
   This is the load-bearing claim. If intellect were a power of the
   body (materialism) or of the body-soul composite (strict hylomorphism
   without subsistent soul), separation would destroy cognition.

2. **The soul is subsistent** — it can exist and operate (imperfectly)
   without the body. This goes beyond minimal hylomorphism. Aquinas
   calls the soul a "subsistent form" (ST I q.75 a.2) — a form that
   can exist on its own, unlike the form of a stone.

3. **Divine illumination compensates for lost sensory input**. The
   separated soul cannot abstract from phantasms (no body → no senses →
   no phantasms). Something must replace this. Aquinas says God supplies
   intelligible species directly. The CCC does not specify the mechanism.

## Modeling choices

1. We model cognition modes as an inductive type (`CognitionMode`) rather
   than a graded quantity. The CCC implies a qualitative difference
   (embodied vs. separated), not just a quantitative one.

2. We define `separated_soul_is_active` as deriving from the DivineModes
   infrastructure: all three afterlife states imply some form of awareness.
   This is a modeling choice — we could instead take activity as a new
   axiom.

3. We do NOT formalize the mechanism of divine illumination. The CCC
   does not commit to Aquinas's specific account (ST I q.89). We only
   formalize that cognition PERSISTS, not HOW.

## Denominational scope

- Soul's immortality: ECUMENICAL (§366)
- Intellect/will as soul's powers: broadly ECUMENICAL (§1705), though
  the precise Thomistic analysis is Catholic distinctive
- Separated soul cognition: CATHOLIC distinctive (Aquinas ST I q.89),
  though most Christians implicitly accept it (prayers for the dead,
  saints interceding, etc. all presuppose aware separated souls)
- The specific Thomistic account (divine illumination replacing
  phantasms): PHILOSOPHICAL INFRASTRUCTURE, not dogma

## Prediction

I expect this to reveal that our existing model ALREADY supports
separated soul cognition — because `SpiritualPower` (intellect/will)
is defined on the soul side, and `soul_is_immortal` ensures the soul
persists. The interesting finding will be that the CCC requires MORE
than minimal hylomorphism: it needs a SUBSISTENT soul that retains
its powers, not just a form that vanishes when matter is absent.
-/

namespace Catlib.Creed

open Catlib

/-!
## Cognition modes: embodied vs. separated
-/

/-- How a soul exercises its spiritual powers (intellect and will).
    In life, the soul operates THROUGH the body — intellect abstracts
    from sensory data. After death, the soul operates WITHOUT the body —
    a different mode, not a loss of power.

    HIDDEN ASSUMPTION: The soul has at least two modes of cognition.
    The CCC does not state this explicitly, but it follows from:
    (1) the soul thinks in life (through the body), and
    (2) the soul is aware after death (without the body).
    If the soul does BOTH, it must have (at least) two modes. -/
inductive CognitionMode where
  /-- Embodied cognition: intellect works through sensory data.
      The natural mode for the body-soul composite.
      Aquinas: "the proper object of the human intellect... is the
      nature of a material thing" (ST I q.84 a.7). -/
  | embodied
  /-- Separated cognition: intellect works without sensory data.
      The mode of the separated soul after death.
      Aquinas: the separated soul knows through "intelligible species
      infused by God" (ST I q.89 a.1) — like angelic cognition.
      The CCC does not specify the mechanism but implies the soul
      IS aware (§1023, §1030-1037). -/
  | separated

/-- Whether a soul is currently exercising its spiritual powers
    (intellect and will) in some mode.
    This is the minimal claim: the soul is not inert.
    We do NOT claim to know the mechanism — only that awareness,
    purification, and vision all require some form of activity.

    Opaque because what "exercising spiritual powers" means for a
    separated soul is precisely the question Aquinas investigates
    (ST I q.89) and the CCC leaves unspecified.

    HONEST OPACITY: The CCC implies activity (purgatory changes state,
    hell involves awareness, heaven involves vision) without explaining
    the mechanism. We track this gap. -/
opaque isExercisingPowers : HumanPerson → Prop

/-- The cognition mode currently active for a person.
    Living persons use embodied cognition; separated souls use
    separated cognition. After resurrection, embodied cognition
    is restored (but glorified — we do not model glorification here).

    Opaque because the transition mechanism is not specified by the CCC.
    We only axiomatize which mode is active in which state.

    STRUCTURAL OPACITY: The assignment of mode to state is clear
    (alive → embodied, dead → separated, risen → embodied again),
    but the internal content of each mode is not fully specified. -/
instance : Inhabited CognitionMode := ⟨CognitionMode.embodied⟩

opaque cognitionModeOf : HumanPerson → CognitionMode

/-!
## Axioms: what the CCC implies about separated soul cognition
-/

/-- AXIOM 1 (§1705): Intellect and will are powers of the SOUL.
    "By virtue of his soul and his spiritual powers of intellect and
    will, man is endowed with freedom."
    This is the load-bearing claim: spiritual powers belong to the
    soul, not the body. Therefore they persist when the body is absent.

    HIDDEN ASSUMPTION in the CCC: §1705 says intellect and will are
    spiritual powers of the soul, but does not explicitly address what
    happens to them after death. The persistence claim follows from
    combining §1705 (powers of the soul) with §366 (soul is immortal).

    Provenance: [Definition] CCC §1705; [Philosophical] Aquinas ST I q.77 a.5.
    Denominational scope: Ecumenical (§1705 language), Catholic distinctive
    (the Thomistic analysis of separated soul cognition). -/
axiom spiritual_powers_persist_through_death :
  ∀ (p : HumanPerson),
    isDead p →
    hasSpiritualAspect p →
    isExercisingPowers p

/-- AXIOM 2: A living person exercises spiritual powers in embodied mode.
    In life, the soul operates THROUGH the body. Intellect abstracts
    from sensory data; will moves the body.

    Provenance: [Philosophical] Aquinas ST I q.84 a.7 ("the proper object
    of the human intellect is the nature of a material thing"); [Definition]
    CCC §365 (soul is form of body — the soul's natural operation is
    through matter).
    Denominational scope: Catholic distinctive (Thomistic epistemology). -/
axiom living_person_cognition_is_embodied :
  ∀ (p : HumanPerson),
    ¬isDead p →
    ¬isRisen p →
    cognitionModeOf p = CognitionMode.embodied

/-- AXIOM 3: A separated soul exercises spiritual powers in separated mode.
    After death, the soul operates WITHOUT the body. The mode changes
    but the powers persist.

    Provenance: [Philosophical] Aquinas ST I q.89 a.1 ("the soul,
    when separated from the body, understands by turning to simply
    intelligible objects"); [Scripture] implied by CCC §1023 (beatific
    vision), §1030-1032 (purgatorial purification), §1033-1037
    (awareness in hell).
    Denominational scope: Catholic distinctive (the Thomistic mechanism),
    but broadly ecumenical in IMPLICATION (all Christians who pray for
    the dead or believe in saints' intercession presuppose aware
    separated souls). -/
axiom separated_soul_cognition_mode :
  ∀ (p : HumanPerson),
    isDead p →
    cognitionModeOf p = CognitionMode.separated

/-- AXIOM 4: All three afterlife states imply the soul is exercising
    its powers. Heaven involves vision (intellect), purgatory involves
    purification (the soul is acted upon and responds), hell involves
    awareness of separation (intellect) and suffering (will).

    This is NOT a single CCC paragraph but a consequence of what the
    CCC says about each state:
    - §1023: "live for ever with Christ" → awareness, relationship
    - §1030: "undergo purification" → change, activity
    - §1033: "definitive self-exclusion" → awareness of what is lost

    HIDDEN ASSUMPTION: Purification, vision, and awareness all require
    the exercise of spiritual powers. The CCC never says "the separated
    soul exercises intellect and will" — it describes states that are
    only possible IF the soul exercises intellect and will.

    Provenance: [Definition] CCC §1023, §1030-1032, §1033-1037.
    Denominational scope: Catholic (purgatory is Catholic distinctive;
    heaven and hell as conscious states is broadly ecumenical). -/
axiom afterlife_states_imply_activity :
  ∀ (p : HumanPerson),
    (personInHeaven p → isExercisingPowers p) ∧
    (personInPurgatory p → isExercisingPowers p) ∧
    (personInHell p → isExercisingPowers p)

/-!
## Derived results
-/

/-- The separated soul retains its spiritual powers.
    Combines soul_is_immortal (§366, Soul.lean) with
    spiritual_powers_persist_through_death (§1705 + §366).
    The soul persists → the powers persist → the soul is active.

    This is the core answer to the motivating question: YES, a
    separated soul can think and will. -/
theorem separated_soul_can_think_and_will (p : HumanPerson)
    (h_dead : isDead p) :
    isExercisingPowers p :=
  spiritual_powers_persist_through_death p h_dead (soul_is_immortal p)

/-- The two cognition modes are distinct — embodied and separated
    cognition are not the same. This is not trivial: it means the
    soul's mode of knowing genuinely CHANGES at death, not just
    persists unchanged.

    Aquinas (ST I q.89 a.1): "the mode of understanding of a soul
    separated from the body is different from the mode it has while
    united to the body." -/
theorem cognition_modes_are_distinct :
    CognitionMode.embodied ≠ CognitionMode.separated := by
  intro h; cases h

/-- The embodied and separated modes are the two possible cognition
    states. Together with the axioms that assign modes to life-states,
    this means a living person uses embodied cognition and a dead
    person uses separated cognition — the mode changes at death.

    Uses BOTH cognition axioms (living_person_cognition_is_embodied
    and separated_soul_cognition_mode) to show the contrast. -/
theorem cognition_mode_changes_at_death (p : HumanPerson)
    (h_alive : ¬isDead p) (h_not_risen : ¬isRisen p)
    (q : HumanPerson) (h_dead : isDead q) :
    cognitionModeOf p = CognitionMode.embodied ∧
    cognitionModeOf q = CognitionMode.separated :=
  ⟨living_person_cognition_is_embodied p h_alive h_not_risen,
   separated_soul_cognition_mode q h_dead⟩

/-- The separated soul is incomplete but not inert.
    This connects two findings from different files:
    - Soul.lean: `separated_soul_is_incomplete` — the dead person
      lacks their corporeal aspect (body).
    - This file: `separated_soul_can_think_and_will` — the dead person
      still exercises spiritual powers.

    The conjunction IS the answer to the motivating question: incompleteness
    (from hylomorphism) does NOT entail inertness (from soul's subsistence).
    The CCC needs BOTH claims for its eschatology to work. -/
theorem incomplete_but_not_inert (p : HumanPerson)
    (h_dead : isDead p) :
    ¬isCompletePerson p ∧ isExercisingPowers p :=
  ⟨separated_soul_is_incomplete p h_dead,
   separated_soul_can_think_and_will p h_dead⟩

/-- A person in heaven is actively aware — the beatific vision
    requires intellect (to see God) and will (to love God).
    Derived from afterlife_states_imply_activity. -/
theorem heaven_requires_active_soul (p : HumanPerson)
    (h : personInHeaven p) :
    isExercisingPowers p :=
  (afterlife_states_imply_activity p).1 h

/-- A person in purgatory is actively undergoing purification —
    progressive change requires some form of spiritual activity.
    Derived from afterlife_states_imply_activity. -/
theorem purgatory_requires_active_soul (p : HumanPerson)
    (h : personInPurgatory p) :
    isExercisingPowers p :=
  (afterlife_states_imply_activity p).2.1 h

/-- A person in hell is aware of their separation from God —
    suffering requires awareness (intellect) and loss requires
    desire for the good (will).
    Derived from afterlife_states_imply_activity. -/
theorem hell_requires_active_soul (p : HumanPerson)
    (h : personInHell p) :
    isExercisingPowers p :=
  (afterlife_states_imply_activity p).2.2 h

/-!
## What this rules out: the inert soul hypothesis
-/

/-- The inert soul hypothesis: after death, the soul exists but
    cannot think, will, or act. It is like a seed waiting to be
    planted — present but dormant.

    Some forms of "soul sleep" (psychopannychia) hold this view:
    the soul exists after death but is unconscious until resurrection.
    Luther entertained this idea; it appears in some Adventist theology.

    The CCC rejects this because:
    1. Purgatory requires progressive purification (§1030-1031)
    2. Heaven requires the beatific vision (§1023)
    3. Hell requires awareness of separation (§1033-1037)

    All three afterlife states require an ACTIVE soul.
    If the soul were inert, none of them would be possible. -/
theorem rejects_soul_sleep (p : HumanPerson)
    (_h_dead : isDead p)
    (h_inert : ¬isExercisingPowers p) :
    -- If the soul were inert after death, then the person cannot be
    -- in any of the three afterlife states (all require activity)
    ¬personInHeaven p ∧ ¬personInPurgatory p ∧ ¬personInHell p :=
  ⟨fun h_heaven => h_inert (heaven_requires_active_soul p h_heaven),
   fun h_purg => h_inert (purgatory_requires_active_soul p h_purg),
   fun h_hell => h_inert (hell_requires_active_soul p h_hell)⟩

/-- Contrapositive: if the person IS in an afterlife state (which the
    CCC says every dead person is), then the soul is NOT inert.
    This makes the rejection of soul sleep concrete. -/
theorem afterlife_refutes_inertness (p : HumanPerson)
    (_h_dead : isDead p)
    (h_in_state : personInHeaven p ∨ personInPurgatory p ∨ personInHell p) :
    isExercisingPowers p := by
  cases h_in_state with
  | inl h => exact heaven_requires_active_soul p h
  | inr h => cases h with
    | inl h => exact purgatory_requires_active_soul p h
    | inr h => exact hell_requires_active_soul p h

/-!
## The deeper finding: hylomorphism requires a subsistent soul

The CCC's eschatology (purgatory, heaven, hell as conscious states)
is only compatible with hylomorphism IF the soul is SUBSISTENT —
capable of existing and operating on its own, albeit imperfectly.

Minimal hylomorphism (the soul is just the form of the body, like
the shape of a statue) would predict that the soul cannot operate
without the body. But the CCC requires exactly this.

Aquinas's solution: the human soul is a UNIQUE kind of form —
a "subsistent form" (forma subsistens, ST I q.75 a.2). Unlike the
form of a stone (which cannot exist without the stone), the human
soul can subsist on its own because it has an operation (intellection)
that does not intrinsically depend on matter, even though in life
it normally operates THROUGH matter.

This is a PHILOSOPHICAL INFRASTRUCTURE claim — the CCC assumes it
(by asserting both hylomorphism and conscious afterlife states) but
does not argue for it.
-/

/-- Under minimal hylomorphism (form = mere organizational principle),
    the form cannot subsist without matter. A separated soul would
    have NO powers at all — it would be like a shape without a surface.

    NOTA BENE: The CCC rejects this. This theorem shows what would
    follow from a premise the CCC denies. It is a counterfactual. -/
theorem minimal_hylomorphism_predicts_inertness
    (minimal_premise : ∀ (p : HumanPerson), isDead p → ¬isExercisingPowers p)
    (p : HumanPerson) (h_dead : isDead p) :
    ¬personInHeaven p ∧ ¬personInPurgatory p ∧ ¬personInHell p :=
  rejects_soul_sleep p h_dead (minimal_premise p h_dead)

/-- The CCC's actual position requires SUBSISTENT hylomorphism:
    the soul is the form of the body (§365) AND can subsist and
    operate without the body (§366, §1023, §1030-1037).

    This theorem shows the conjunction that the CCC needs:
    (1) The person IS the body-soul composite (hylomorphism)
    (2) The separated soul IS incomplete (follows from hylomorphism)
    (3) The separated soul IS active (follows from eschatology)

    All three must hold simultaneously. This rules out:
    - Dualism (denies 1 — body and soul are separate substances)
    - Minimal hylomorphism (denies 3 — form can't operate without matter)
    - Materialism (denies the soul's existence entirely) -/
theorem ccc_requires_subsistent_hylomorphism (p : HumanPerson)
    (h_dead : isDead p) :
    -- (1) The spiritual aspect persists (soul is immortal)
    hasSpiritualAspect p ∧
    -- (2) The person is incomplete (hylomorphism — person = composite)
    ¬isCompletePerson p ∧
    -- (3) The soul is active (eschatology requires cognition)
    isExercisingPowers p :=
  ⟨soul_is_immortal p,
   separated_soul_is_incomplete p h_dead,
   separated_soul_can_think_and_will p h_dead⟩

/-!
## Connection to existing infrastructure

### Soul.lean
- `soul_is_immortal` → the soul persists → its powers persist
  (this file's AXIOM 1 adds: persistence of powers, not just existence)
- `death_separates` → body lost → embodied mode lost → separated mode begins
- `separated_soul_is_incomplete` → incomplete but not inert (this file's key result)

### HumanNature.lean
- `SpiritualPower` (intellect/will) → these are the powers that persist
- `PersonAspect.soul` → the aspect that survives death
- `HumanNature.hasFreedom` → freedom persists because intellect and will persist

### DivineModes.lean
- All three afterlife states (heavenState, purgatoryState, hellState) →
  all imply awareness → all require active spiritual powers
- `personInHeaven`, `personInPurgatory`, `personInHell` → the person-level
  predicates that this file connects to spiritual activity

### The finding

The CCC's model of the human person requires MORE than standard
hylomorphism. It requires what Aquinas calls a "subsistent form" —
a soul that is simultaneously:
- The form of the body (hylomorphism, §365)
- Capable of subsisting without the body (immortality, §366)
- Capable of operating without the body (eschatology, §1023, §1030-1037)

This is a hidden assumption that the CCC borrows from Aquinas without
arguing for it. Our formalization makes it explicit: the conjunction of
hylomorphism + immortality + conscious eschatology logically REQUIRES
a subsistent soul with persistent powers. Drop any one of the three
and the CCC's anthropology collapses.

## Summary

Axioms (4 — 1 from CCC, 3 philosophical infrastructure):
1. spiritual_powers_persist_through_death (§1705 + §366)
2. living_person_cognition_is_embodied (Aquinas ST I q.84)
3. separated_soul_cognition_mode (Aquinas ST I q.89, implied by §1023/§1030-1037)
4. afterlife_states_imply_activity (§1023, §1030-1032, §1033-1037)

Theorems (9 — all derived from axioms + Soul.lean + DivineModes.lean):
1. separated_soul_can_think_and_will — THE CORE ANSWER: yes
2. cognition_mode_changes_at_death — mode changes, powers persist
3. incomplete_but_not_inert — the conjunction the CCC needs
4. heaven_requires_active_soul — beatific vision needs intellect
5. purgatory_requires_active_soul — purification needs activity
6. hell_requires_active_soul — awareness needs intellect
7. rejects_soul_sleep — inert soul incompatible with afterlife
8. afterlife_refutes_inertness — contrapositive of soul sleep
9. minimal_hylomorphism_predicts_inertness — counterfactual
10. ccc_requires_subsistent_hylomorphism — THE KEY FINDING

New types (1):
- CognitionMode (embodied | separated)

New opaques (2):
- isExercisingPowers — whether the soul is active
- cognitionModeOf — which cognition mode is active
-/

end Catlib.Creed
