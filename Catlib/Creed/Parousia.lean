import Catlib.Foundations
import Catlib.Creed.Soul
import Catlib.Creed.Judgment
import Catlib.Creed.DevelopmentOfDoctrine
import Catlib.Creed.Soteriology

/-!
# CCC §668-682, §1042-1048: The Parousia and Eschatological Completion

## The source claims

§668: "Christ's Ascension... does not mean he is now absent from the earth."
He reigns now but "all things are not yet subject to him."

§671: "Though already present in his Church, Christ's reign is nevertheless
yet to be fulfilled."

§675: "Before Christ's second coming the Church must pass through a final
trial that will shake the faith of many believers."

§676: "The Church has rejected... millenarianism — especially the 'intrinsically
perverse' political form of a secular messianism."

§677: "The Church will enter the glory of the kingdom only through this final
Passover... The kingdom of God... will be fulfilled not by a historic triumph
of the Church... but only by God's victory over the final unleashing of evil."

§1042-1048: "At the end of time, the Kingdom of God will come in its fullness...
The visible universe, then, is itself destined to be transformed."

## The puzzle

The CCC asserts TWO claims that appear to be in tension:

1. **Anti-utopianism** (§677): The Kingdom will NOT be established by human
   effort alone. No "historic triumph of the Church" will bring about the
   final Kingdom. It comes "only by God's victory."

2. **Call to social justice** (§2401+, §1928-1942): Christians are obligated
   to work for justice, peace, and the common good in this world. The Church
   calls for active social improvement.

If the Kingdom comes only by God's victory, why work for justice at all?
If human effort cannot establish the Kingdom, is social action futile?

## The resolution: building vs. preparing

The CCC's hidden assumption is a DISTINCTION between:

- **Building the Kingdom** — only God can do this (§677). The eschatological
  completion is God's act, not humanity's achievement.
- **Preparing for the Kingdom** — humans can and must do this (§2401+).
  Social justice, peace-building, and the common good are genuine
  PREPARATIONS that participate in God's plan without replacing God's
  final act.

This maps exactly onto P2 (two-tier causation): God brings the Kingdom
as PRIMARY CAUSE; human justice work is SECONDARY CAUSE that participates
in (but does not substitute for) God's act. The anti-utopian claim is
that the secondary cause CANNOT replace the primary cause — not that
the secondary cause is useless.

## Hidden assumptions

1. **The building/preparing distinction** — the CCC never explicitly makes
   this distinction, but it is required to reconcile §677 with §2401+.
   Without it, either anti-utopianism renders social action pointless, or
   social action renders anti-utopianism hollow.

2. **Material continuity through transformation** — §1042-1048 say the
   universe will be "transformed," not annihilated. This implies that
   what humans build in this world is not simply discarded — it is
   TRANSFORMED into the new creation. This gives social justice
   eschatological significance: the "materials" are carried forward.

3. **The final trial is a real trial** — §675 says the Church will face
   a trial that "shakes the faith of many believers." This is not a
   metaphor for ordinary difficulty — it is a specific eschatological
   event. The CCC does not say what form it takes.

## Modeling choices

1. We model the Parousia (Christ's return) as an opaque event-type.
   The CCC does not describe the mechanism of Christ's return.

2. We model millenarianism as a specific rejected claim, not as a
   general category. The CCC rejects the "intrinsically perverse"
   political form (§676), which we model as the claim that human
   political effort alone can establish the Kingdom.

3. We model the building/preparing distinction using P2's primary/
   secondary causation framework. This is a Catlib modeling choice —
   the CCC does not use P2 language for eschatology. But the structure
   is the same: God's act and human action do not compete.

4. We model cosmic transformation as a predicate on the material
   universe, following §1042-1048. We do NOT model what the transformed
   universe looks like — the CCC says it is "mysterious" (§1048).

## Denominational scope

- Christ will return: ECUMENICAL (Nicene Creed: "He will come again
  in glory to judge the living and the dead")
- Anti-utopianism: ECUMENICAL (all traditions reject purely human
  salvation-through-politics)
- Millenarianism rejection: ECUMENICAL among Catholics and mainstream
  Protestants. Some evangelicals hold premillennial dispensationalism.
- Final trial: ECUMENICAL in principle, details vary by tradition
- Cosmic transformation (vs. annihilation): Catholic distinctive in
  its strength; some Protestants hold to annihilation and recreation
  rather than transformation
- The building/preparing distinction via P2: MODELING CHOICE (our
  framework; the CCC does not use this language)

## Findings

The formalization reveals that P2 (two-tier causation) does SEXTUPLE duty
across the project: causation (Providence), prayer (Prayer), absolution
(PriestlyAbsolution), intercession (Intercession), veneration (Veneration),
and now ESCHATOLOGY. The anti-utopian claim is structurally identical to
the other P2 applications: the secondary cause (human effort) participates
in but cannot replace the primary cause (God's act).

The deepest finding: the building/preparing distinction is NOT just a
rhetorical distinction — it is a STRUCTURAL one that maps onto P2. This
means anti-utopianism and social justice are not in tension at all: they
are two sides of the same P2 coin. Social justice IS preparation for the
Kingdom, precisely because it operates at the secondary-cause level. The
anti-utopian claim is just the P2 claim that secondary causes cannot
substitute for primary causes — applied to eschatology.
-/

set_option autoImplicit false

namespace Catlib.Creed.Parousia

open Catlib
open Catlib.Creed

-- ============================================================================
-- ## Opaque types and predicates
-- ============================================================================

/-- Whether Christ has returned in glory (the Parousia).
    Opaque because the CCC does not describe the mechanism of Christ's
    return — only that it will happen (§668, §1040, Nicene Creed).

    HONEST OPACITY: The Parousia is an eschatological event whose nature
    is beyond current human understanding. The CCC asserts it will occur
    but does not define what it looks like.

    Source: [CCC] §668; [Scripture] Acts 1:11 ("This same Jesus, who has
    been taken up from you into heaven, will come back in the same way
    you have seen him go into heaven."); Nicene Creed. -/
opaque parousiaHasOccurred : Prop

/-- Whether the Kingdom of God has come in its fullness.
    §671: "Though already present in his Church, Christ's reign is
    nevertheless yet to be fulfilled." The Kingdom is partially present
    now (in the Church) but awaits eschatological completion.

    HONEST OPACITY: The CCC says the Kingdom is "already but not yet"
    (§671) — a genuine ambiguity about what "fullness" means. The
    distinction between partial and full is real but the boundary is
    not defined.

    Source: [CCC] §671, §677. -/
opaque kingdomInFullness : Prop

/-- Whether the Kingdom of God is achievable by human effort alone,
    without God's decisive eschatological act.

    HIDDEN ASSUMPTION: The CCC (§677) assumes that the distinction
    between "achievable by human effort" and "achievable by God's
    victory" is meaningful and exhaustive. A process theologian might
    reject this dichotomy.

    Source: [CCC] §677. -/
opaque achievableByHumanEffortAlone : Prop

/-- Whether a given political program constitutes a secular messianism —
    the claim that a purely human political project can establish the
    final Kingdom on earth.

    HONEST OPACITY: What counts as "secular messianism" is not fully
    determined by the CCC. §676 gives the category but not a precise
    boundary. Marxism is the paradigm case, but the principle extends
    further.

    Source: [CCC] §676. -/
opaque isSecularMessianism : Prop → Prop

/-- Whether the Church is undergoing the final eschatological trial.
    §675: "Before Christ's second coming the Church must pass through
    a final trial that will shake the faith of many believers."

    HONEST OPACITY: The CCC does not specify the nature of the final
    trial beyond "shaking the faith of many." It is not identified with
    any particular historical event.

    Source: [CCC] §675. -/
opaque finalTrialOccurring : Prop

/-- Whether the material universe has been eschatologically transformed
    into the "new heavens and new earth" (§1042-1048).

    HONEST OPACITY: The CCC says the transformation is "mysterious"
    (§1048) — "We do not know the time... nor do we know the way in
    which the universe will be transformed." Opaque by the CCC's own
    admission.

    Source: [CCC] §1042-1048; [Scripture] Rev 21:1, Rom 8:19-21. -/
opaque universeTransformed : Prop

/-- Whether human action constitutes genuine preparation for the Kingdom.
    This is the KEY CONCEPT that reconciles anti-utopianism with social
    justice: humans cannot BUILD the Kingdom (that is God's act) but can
    PREPARE for it (through justice, love, peace).

    HIDDEN ASSUMPTION: The CCC requires this distinction but never states
    it explicitly. §677 says the Kingdom comes "only by God's victory,"
    and §2401+ commands justice work. The bridge is that justice work IS
    preparation, not construction.

    MODELING CHOICE: We model preparation as a predicate on Prop (any
    human action can be evaluated as preparation). Other formalizations
    might use a richer type.

    Source: [CCC] §677 (anti-utopianism) + §2401+ (social justice),
    reconciled via the building/preparing distinction. -/
opaque isPreparationForKingdom : Prop → Prop

/-- Whether Christ is already reigning (present kingship, before Parousia).
    §668: Christ's Ascension does not mean absence — he reigns NOW, but
    not all things are yet subject to him.

    Source: [CCC] §668. -/
opaque christReignsNow : Prop

-- ============================================================================
-- ## Axioms
-- ============================================================================

/-- AXIOM 1 (§668; Acts 1:11): The Parousia brings the Kingdom in fullness.
    The Nicene Creed: "He will come again in glory to judge the living
    and the dead, and his kingdom will have no end." Christ's return IS
    the event that establishes the Kingdom in fullness.

    Source: [CCC] §668-677; [Scripture] Acts 1:11; Nicene Creed.
    Denominational scope: ECUMENICAL (in the Nicene Creed). -/
axiom christ_will_return :
  parousiaHasOccurred → kingdomInFullness

/-- AXIOM 2 (§677): The Kingdom is NOT achievable by human effort alone.
    "The kingdom will be fulfilled... not by a historic triumph of the
    Church... but only by God's victory over the final unleashing of evil."

    This is the ANTI-UTOPIAN axiom. It says human political/social effort
    CANNOT by itself produce the eschatological Kingdom. This does NOT say
    human effort is useless — only that it is insufficient.

    Source: [CCC] §677.
    Denominational scope: ECUMENICAL (all traditions reject purely human
    eschatological achievement, though they differ on what human effort
    can accomplish). -/
axiom kingdom_not_by_human_effort_alone :
  ¬achievableByHumanEffortAlone

/-- AXIOM 3 (§676): Millenarianism is rejected.
    The Church rejects the claim that a secular political program can
    establish the final Kingdom on earth. §676 calls this the
    "intrinsically perverse" political form of millenarianism.

    This is STRONGER than axiom 2: it says that not only is human effort
    insufficient, but the specific claim that a POLITICAL program can
    do it is perverse (intrinsically disordered).

    Source: [CCC] §676.
    Denominational scope: ECUMENICAL among Catholics and mainstream
    Protestants. Some premillennial dispensationalists hold a form of
    millenarianism (literal 1000-year earthly reign), though not the
    "secular" form the CCC rejects. -/
axiom millenarianism_rejected :
  ∀ (program : Prop),
    isSecularMessianism program →
    ¬(program → kingdomInFullness)

/-- AXIOM 4 (§675): The Church must pass through a final trial before
    the Parousia. "Before Christ's second coming the Church must pass
    through a final trial that will shake the faith of many believers."

    We model this as: the Parousia REQUIRES the final trial to have
    occurred. The trial is a necessary precondition, not an optional
    historical event. The Church enters glory THROUGH the trial, not
    around it — "this final Passover" (§677).

    Source: [CCC] §675.
    Denominational scope: ECUMENICAL in principle (most traditions
    expect tribulation before Christ's return). The details (timing,
    nature, relation to Antichrist) vary significantly. -/
axiom final_trial_precedes_parousia :
  parousiaHasOccurred → finalTrialOccurring

/-- AXIOM 5 (§1042-1048): The material universe will be transformed.
    "The visible universe, then, is itself destined to be transformed."
    This is TRANSFORMATION, not annihilation — the material world is
    not discarded but renewed.

    Source: [CCC] §1042-1048; [Scripture] Rev 21:1, Rom 8:19-21.
    Denominational scope: Catholic distinctive in its strength.
    Some Protestants hold annihilation-and-recreation rather than
    transformation of the existing material universe. -/
axiom cosmic_transformation :
  parousiaHasOccurred → universeTransformed

/-- AXIOM 6: Human justice work is genuine preparation for the Kingdom.
    The CCC commands social justice (§2401+, §1928-1942) AND asserts
    anti-utopianism (§677). The RECONCILIATION is that human effort
    operates at the secondary-cause level (P2): it participates in
    God's plan without substituting for God's eschatological act.

    This is the BRIDGE AXIOM that connects anti-utopianism with
    social justice. Without it, either social action is pointless
    (if the Kingdom comes only by God) or anti-utopianism is hollow
    (if humans can effectively build the Kingdom).

    Source: [CCC] §677 + §2401+ + §306 (secondary causation);
    the reconciliation via P2 is a MODELING CHOICE.
    Denominational scope: ECUMENICAL in substance (all traditions
    affirm the value of Christian social action without equating it
    with eschatological completion). The P2 framework is our model. -/
axiom human_effort_prepares :
  ∀ (action : Prop),
    isPreparationForKingdom action →
    -- Preparation is real but does not by itself establish the Kingdom
    ¬(action → kingdomInFullness) ∧
    -- Yet preparation participates in God's plan (S4: all events are
    -- divinely governed, including human justice work)
    divinelyGoverned action

/-- AXIOM 7 (§668): Christ reigns now, before the Parousia.
    The Kingdom is "already but not yet" — partially present in the
    Church's sacraments and life, not yet fulfilled eschatologically.

    Source: [CCC] §668, §671.
    Denominational scope: ECUMENICAL. -/
axiom christ_already_reigns :
  christReignsNow

-- ============================================================================
-- ## Theorems
-- ============================================================================

/-- **THEOREM: Anti-utopianism does not negate social action.**
    The reconciliation of §677 (Kingdom comes only by God's victory)
    with §2401+ (work for justice): human preparation is REAL because
    it is divinely governed (S4/P2), but it is NOT the final cause of
    the Kingdom (anti-utopianism).

    This is the CENTRAL FINDING. The tension dissolves under P2:
    secondary causes (human justice) participate in but do not replace
    the primary cause (God's eschatological act).

    Derived from: human_effort_prepares, kingdom_not_by_human_effort_alone. -/
theorem anti_utopianism_compatible_with_social_justice
    (action : Prop)
    (h_prep : isPreparationForKingdom action) :
    -- Human effort cannot establish the Kingdom alone
    ¬achievableByHumanEffortAlone ∧
    -- Yet human preparation is genuinely part of God's plan
    divinelyGoverned action :=
  ⟨kingdom_not_by_human_effort_alone,
   (human_effort_prepares action h_prep).2⟩

/-- **THEOREM: Secular messianism contradicts the anti-utopian axiom.**
    Any program claiming to establish the Kingdom through purely human
    political effort is rejected on two grounds: (1) the Kingdom is not
    achievable by human effort alone, and (2) the specific form of
    secular messianism is intrinsically perverse (§676).

    Derived from: millenarianism_rejected. -/
theorem secular_messianism_fails
    (program : Prop) (h_secular : isSecularMessianism program) :
    ¬(program → kingdomInFullness) :=
  millenarianism_rejected program h_secular

/-- **THEOREM: The Kingdom is "already but not yet."**
    Christ reigns NOW (§668) but the Kingdom has not yet come in
    fullness (§671/§677). This is the eschatological tension that
    structures the entire Christian life.

    Derived from: christ_already_reigns, kingdom_not_by_human_effort_alone. -/
theorem already_but_not_yet :
    christReignsNow ∧ ¬achievableByHumanEffortAlone :=
  ⟨christ_already_reigns, kingdom_not_by_human_effort_alone⟩

/-- **THEOREM: The Parousia brings the Kingdom AND cosmic transformation.**
    Christ's return entails BOTH the Kingdom in fullness AND the
    transformation of the material universe. The universe is not
    annihilated but RENEWED — what was created is not discarded but
    perfected. And the Kingdom comes in its fullness.

    Derived from: christ_will_return, cosmic_transformation. -/
theorem parousia_brings_kingdom_and_transformation
    (h_parousia : parousiaHasOccurred) :
    kingdomInFullness ∧ universeTransformed :=
  ⟨christ_will_return h_parousia,
   cosmic_transformation h_parousia⟩

/-- **THEOREM: The final trial is part of the Parousia event.**
    If the Parousia has occurred, the final trial has occurred (it was
    the necessary passage). And through that trial, the Kingdom comes.

    Derived from: final_trial_precedes_parousia, christ_will_return. -/
theorem final_trial_leads_to_kingdom
    (h_parousia : parousiaHasOccurred) :
    finalTrialOccurring ∧ kingdomInFullness :=
  ⟨final_trial_precedes_parousia h_parousia,
   christ_will_return h_parousia⟩

-- ============================================================================
-- ## Bridge to Judgment.lean
-- ============================================================================

/-- **BRIDGE: The Parousia is the context of the Last Judgment.**
    Judgment.lean establishes that the Last Judgment makes justice
    publicly manifest, judges complete (risen) persons, and reveals
    cosmic meaning. The Parousia is the EVENT in which this occurs:
    Christ returns → Last Judgment → cosmic transformation.

    The risen person at the Last Judgment (Judgment.lean) exists in
    the context of cosmic transformation (this file).

    Derived from: cosmic_transformation, last_judgment_reveals_history
    (Judgment.lean). -/
theorem parousia_context_of_last_judgment
    (h_parousia : parousiaHasOccurred) :
    universeTransformed ∧ revealsCosmicMeaning :=
  ⟨cosmic_transformation h_parousia,
   last_judgment_reveals_history⟩

-- ============================================================================
-- ## Bridge to DevelopmentOfDoctrine.lean
-- ============================================================================

/-- **BRIDGE: Anti-utopianism sets the eschatological horizon for
    development of doctrine.**
    Development of doctrine (DevelopmentOfDoctrine.lean) unfolds what
    was implicit in the deposit. But this unfolding occurs WITHIN
    history, before the Parousia. The anti-utopian axiom means that
    even perfect doctrinal development cannot BY ITSELF bring about
    the Kingdom — the eschatological completion is God's act, not the
    Church's theological achievement.

    This connects two formalizations: development of doctrine proceeds
    within the "already but not yet" eschatological window.

    Derived from: christ_already_reigns, kingdom_not_by_human_effort_alone,
    understanding_grows (DevelopmentOfDoctrine.lean). -/
theorem development_within_eschatological_horizon :
    -- The Church already lives under Christ's reign
    christReignsNow ∧
    -- Understanding grows monotonically (doctrine develops)
    (∀ (e1 e2 : DevelopmentOfDoctrine.Epoch) (d : DevelopmentOfDoctrine.Doctrine),
      e1 ≤ e2 → DevelopmentOfDoctrine.explicitAtEpoch e1 d →
      DevelopmentOfDoctrine.explicitAtEpoch e2 d) ∧
    -- But doctrinal development alone cannot bring the Kingdom
    ¬achievableByHumanEffortAlone :=
  ⟨christ_already_reigns,
   fun e1 e2 d h_le h_exp => DevelopmentOfDoctrine.understanding_grows e1 e2 d h_le h_exp,
   kingdom_not_by_human_effort_alone⟩

-- ============================================================================
-- ## Bridge to Soteriology.lean
-- ============================================================================

/-- **BRIDGE: Soteriology operates within the eschatological "already
    but not yet."**
    The salvation chain (Soteriology.lean) describes how individuals
    are saved NOW — during the period when Christ reigns but the
    Kingdom has not yet come in fullness. The Parousia is the HORIZON
    toward which soteriology is oriented: individual salvation
    participates in but does not constitute the eschatological Kingdom.

    Derived from: christ_already_reigns, kingdom_not_by_human_effort_alone. -/
theorem soteriology_within_already_but_not_yet :
    christReignsNow ∧ ¬achievableByHumanEffortAlone :=
  already_but_not_yet

-- ============================================================================
-- ## The capstone: P2 applied to eschatology
-- ============================================================================

/-- **THE KEY THEOREM: P2 reconciles anti-utopianism and social justice.**
    This is the deepest finding: the anti-utopian claim (§677) and the
    call to social justice (§2401+) are not in tension — they are two
    sides of the P2 (two-tier causation) coin applied to eschatology.

    P2 says primary and secondary causes do not compete. Applied here:
    - PRIMARY CAUSE: God brings the Kingdom (§677)
    - SECONDARY CAUSE: Human justice prepares for the Kingdom (§2401+)

    These do not compete. Human preparation is genuine (divinely governed)
    but insufficient (the Kingdom comes only by God's victory). This is
    EXACTLY the P2 structure: more secondary-cause activity does not
    reduce the need for primary-cause activity, and vice versa.

    P2 now does SEXTUPLE duty in the project:
    1. Causation (Providence.lean)
    2. Prayer (Prayer.lean)
    3. Absolution (PriestlyAbsolution.lean)
    4. Intercession (Intercession.lean)
    5. Veneration (Veneration.lean)
    6. ESCHATOLOGY (this file)

    Derived from: p2_two_tier_causation, kingdom_not_by_human_effort_alone,
    human_effort_prepares, s4_universal_providence. -/
theorem p2_applied_to_eschatology
    (action : Prop)
    (h_prep : isPreparationForKingdom action) :
    -- P2: primary and secondary causes do not compete
    (∀ (p : PrimaryCause) (s : SecondaryCause), ¬causesCompete p s) ∧
    -- Applied: human preparation is real (secondary cause)
    divinelyGoverned action ∧
    -- Applied: human effort alone is insufficient (cannot replace primary cause)
    ¬achievableByHumanEffortAlone :=
  ⟨fun p s => p2_two_tier_causation p s,
   (human_effort_prepares action h_prep).2,
   kingdom_not_by_human_effort_alone⟩

/-!
## Summary

### The answer to the motivating question

**What reconciles anti-utopianism (§677) with the CCC's call for social
improvement (§2401+)?**

P2 (two-tier causation). The same principle that reconciles divine
sovereignty with human freedom (Providence.lean), divine prayer-hearing
with human petition (Prayer.lean), Christ's unique mediation with
saintly intercession (Intercession.lean), and latria with dulia
(Veneration.lean) — that SAME principle reconciles the anti-utopian
claim with social justice.

God brings the Kingdom as PRIMARY CAUSE (§677). Human justice work
participates as SECONDARY CAUSE (§2401+, §306). These do not compete
(P2). Human effort is genuinely valuable (preparation) but genuinely
insufficient (cannot replace God's act).

The building/preparing distinction is the eschatological instance of
P2: building is primary-cause work (God's act); preparing is
secondary-cause work (human participation).

### Axioms (7)

1. `christ_will_return` — Source: [CCC] §668-677; [Scripture] Acts 1:11
2. `kingdom_not_by_human_effort_alone` — Source: [CCC] §677
3. `millenarianism_rejected` — Source: [CCC] §676
4. `final_trial_precedes_parousia` — Source: [CCC] §675
5. `cosmic_transformation` — Source: [CCC] §1042-1048; [Scripture] Rev 21:1
6. `human_effort_prepares` — Source: [CCC] §677 + §2401+ + §306
7. `christ_already_reigns` — Source: [CCC] §668, §671

### Theorems (7)

1. `anti_utopianism_compatible_with_social_justice` — THE CENTRAL FINDING
2. `secular_messianism_fails` — millenarianism applied
3. `already_but_not_yet` — the eschatological tension
4. `parousia_transforms_universe` — cosmic renewal
5. `parousia_context_of_last_judgment` — bridge to Judgment.lean
6. `development_within_eschatological_horizon` — bridge to DevelopmentOfDoctrine
7. `soteriology_within_already_but_not_yet` — bridge to Soteriology
8. `p2_applied_to_eschatology` — the capstone: P2 does sextuple duty

### Opaques (8)

- `parousiaHasOccurred` — honest opacity; the CCC asserts the Parousia
  will occur but does not describe its mechanism
- `kingdomInFullness` — honest opacity; "already but not yet" is a genuine
  ambiguity the CCC embraces
- `achievableByHumanEffortAlone` — hidden assumption; the CCC presupposes
  the human-effort/divine-act dichotomy
- `isSecularMessianism` — honest opacity; the boundary of what counts as
  secular messianism is not precisely defined
- `finalTrialOccurring` — honest opacity; the nature of the final trial
  is unspecified
- `universeTransformed` — honest opacity; the CCC says the transformation
  is "mysterious" (§1048)
- `isPreparationForKingdom` — hidden assumption; the building/preparing
  distinction is our modeling choice reconciling §677 with §2401+
- `christReignsNow` — honest opacity; the mode of Christ's present reign
  is not fully described

### Cross-file connections

- **Axioms.lean**: P2 (two-tier causation), S4 (universal providence,
  via `divinelyGoverned`)
- **Judgment.lean**: `last_judgment_reveals_history`, `revealsCosmicMeaning`
  — the Parousia is the context of the Last Judgment
- **DevelopmentOfDoctrine.lean**: `understanding_grows`, `explicitAtEpoch`
  — doctrine develops within the eschatological "already but not yet"
- **Soteriology.lean**: individual salvation operates within the same
  eschatological horizon
- **Providence.lean**: P2 applied to eschatology is structurally identical
  to P2 applied to causation, prayer, intercession, and veneration
-/

end Catlib.Creed.Parousia
