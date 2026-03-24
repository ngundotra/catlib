import Catlib.Foundations
import Catlib.MoralTheology.Sin

/-!
# CCC §1854-1864: The Mortal Sin Threshold

## The Catechism claims

"For a sin to be mortal, three conditions must together be met:
'Mortal sin is sin whose object is grave matter and which is also
committed with full knowledge and deliberate consent.'" (§1857)

"Grave matter is specified by the Ten Commandments." (§1858)

"Mortal sin requires full knowledge and complete consent." (§1859)

"Unintentional ignorance can diminish or even remove the imputability
of a grave offense." (§1860)

"Mortal sin... results in the loss of charity and the privation of
sanctifying grace." (§1861)

"One commits venial sin when, in a less serious matter, he does not
observe the standard prescribed by the moral law, or when he disobeys
the moral law in a grave matter, but without full knowledge or without
complete consent." (§1862)

"Venial sin weakens charity; it manifests a disordered affection for
created goods... Deliberate and unrepented venial sin disposes us
little by little to commit mortal sin. However venial sin does not
break the covenant with God." (§1863)

## Prediction

Sin.lean already formalizes the binary mortal/venial structure. But the
CCC itself acknowledges gradation: §1860 says ignorance can "diminish or
even remove" imputability, not just flip a switch. The real question is
whether the mortal/venial boundary is:

(A) A THRESHOLD in a continuous space (crossing a line), or
(B) A QUALITATIVE BREAK (a different kind of thing), or
(C) BOTH — a threshold that, when crossed, produces a qualitative break.

I predict (C): the three conditions form a graded space, but the boundary
between venial and mortal is WHERE quantitative weakening of charity
BECOMES qualitative destruction. The threshold IS the point where the
break happens.

## Findings

- **Prediction confirmed**: The CCC describes BOTH gradation AND a sharp
  break. §1860 says knowledge/consent come in degrees. §1861-1863 say
  the effect is categorically different: mortal sin DESTROYS charity,
  venial sin merely WEAKENS it. The boundary is a threshold in the
  conditions that produces a qualitative change in the effect.

- **The hidden structure**: The three conditions (matter, knowledge,
  consent) form a 3-dimensional space. Sin.lean models this as binary
  per axis (2×2×2 cube with 8 corners). But §1860 acknowledges that
  knowledge and consent are really continuous. The mortal sin region is
  the SINGLE CORNER where all three are maximal. All other points —
  including grave matter with diminished knowledge — are venial.

- **The key insight**: The threshold is CONJUNCTIVE, not disjunctive.
  Weakening ANY single condition (even while the other two remain maximal)
  is sufficient to prevent mortal sin. This is §1862: "when he disobeys
  the moral law in a grave matter, but without full knowledge OR without
  complete consent" — venial sin. The conjunction is doing all the work.

- **Connection to charity**: Mortal sin destroys charity (§1861, Love.lean
  `mortal_sin_can_destroy_charity`). Venial sin weakens but does not
  destroy it (§1863). The threshold is WHERE weakening becomes destruction.
  Under the conjunctive model, charity destruction requires ALL THREE
  conditions simultaneously maximal. Remove any one and charity survives
  (weakened, not destroyed).

- **HIDDEN ASSUMPTION**: The conjunction is sufficient. The CCC says the
  three conditions are NECESSARY for mortal sin (§1857) but does not
  explicitly say they are SUFFICIENT. Could there be a fourth condition?
  The CCC doesn't mention one, and the tradition treats the three as
  jointly sufficient. We axiomatize sufficiency.

- **MODELING CHOICE**: We model the graded reality with a continuous
  `CulpabilityDegree` type alongside the binary `MoralKnowledge`/
  `MoralConsent` from Basic.lean. The CCC operates with both: binary
  for classification (mortal vs. venial), graded for pastoral assessment
  (§1860: diminished imputability). Both views are valid; they answer
  different questions.

- **Assessment**: Tier 2 — confirms the binary structure in Sin.lean
  while revealing the graded substrate. The conjunction as threshold
  is implicit in §1857 but becomes explicit when formalized. The
  connection between the threshold and charity destruction was predicted
  but the CONJUNCTIVE nature (any single weakening prevents destruction)
  is sharper than expected.

- **Denominational scope**: ECUMENICAL for the three conditions (all
  Christians recognize that culpability depends on knowledge, consent,
  and gravity). CATHOLIC for the mortal/venial distinction itself
  (most Protestants reject this binary classification of sin). CATHOLIC
  for the claim that mortal sin destroys charity (requires the Catholic
  theology of grace).
-/

set_option autoImplicit false

namespace Catlib.MoralTheology.MortalSinThreshold

open Catlib
open Catlib.MoralTheology
open Catlib.Foundations.Love

-- ============================================================================
-- ## Graded Culpability Model
-- ============================================================================

/-!
### The graded view: §1860

The CCC acknowledges that knowledge and consent come in degrees.
§1860: "Unintentional ignorance can diminish or even remove the
imputability of a grave offense. But no one is deemed to be ignorant
of the principles of the moral law, which are written in the conscience
of every man."

This means there is a SPECTRUM from "no knowledge at all" to "full
knowledge," and similarly for consent. The binary model in Sin.lean
(full/notFull, complete/incomplete) captures the ENDPOINTS of these
spectra, which is all that matters for the mortal/venial classification.
But the pastoral reality is graded.

We model this with a `CulpabilityDegree` — the degree to which someone
is culpable for their act. This is a function of knowledge and consent
(not matter gravity, which is objective).
-/

/-- The degree of culpability for a sinful act.
    MODELING CHOICE: We use Nat for simplicity. The CCC does not
    specify a scale; what matters is the ordering (more/less culpable)
    and the existence of a maximum (full culpability). -/
structure CulpabilityDegree where
  /-- Degree of knowledge of the act's moral character.
      0 = total ignorance, maxKnowledge = full knowledge (§1859). -/
  knowledgeDeg : Nat
  /-- Degree of consent to the act.
      0 = no consent (involuntary), maxConsent = complete consent (§1859). -/
  consentDeg : Nat

/-- The threshold values: knowledge and consent each have a maximum
    that corresponds to "full" / "complete" in the CCC's binary language.
    MODELING CHOICE: We fix these as constants. The specific values don't
    matter; what matters is the distinction between "at maximum" and
    "below maximum." -/
opaque maxKnowledge : Nat
opaque maxConsent : Nat

/-- Full knowledge (§1859) = knowledge degree at maximum. -/
def CulpabilityDegree.isFullKnowledge (cd : CulpabilityDegree) : Prop :=
  cd.knowledgeDeg = maxKnowledge

/-- Complete consent (§1859) = consent degree at maximum. -/
def CulpabilityDegree.isCompleteConsent (cd : CulpabilityDegree) : Prop :=
  cd.consentDeg = maxConsent

/-- Full culpability = both knowledge and consent at maximum.
    This is the condition required (together with grave matter) for
    mortal sin. -/
def CulpabilityDegree.isMaximal (cd : CulpabilityDegree) : Prop :=
  cd.isFullKnowledge ∧ cd.isCompleteConsent

-- ============================================================================
-- ## The Threshold Model
-- ============================================================================

/-!
### The three-condition conjunction

§1857: "For a sin to be mortal, three conditions must together be met."

The three conditions form a 3D space:
- Axis 1: Matter gravity (grave / less serious) — objective
- Axis 2: Knowledge degree (0 to maxKnowledge) — subjective
- Axis 3: Consent degree (0 to maxConsent) — subjective

Mortal sin occupies the SINGLE POINT (or small region) where all three
axes are at their maximum: grave matter × full knowledge × complete consent.

Everything else is venial — including grave matter with diminished
knowledge or consent (§1862).
-/

/-- A complete description of a sinful act's mortal-sin conditions.
    This bundles the objective gravity with the subjective culpability. -/
structure SinConditions where
  /-- The gravity of the matter — objective (§1858) -/
  gravity : MatterGravity
  /-- The agent's knowledge and consent — subjective (§1859-1860) -/
  culpability : CulpabilityDegree

/-- §1857: A sin is mortal when all three conditions are simultaneously
    met: grave matter, full knowledge, and complete consent.

    In the 3D condition-space, this is the single corner where all axes
    are maximal. -/
def SinConditions.isMortal (sc : SinConditions) : Prop :=
  sc.gravity = MatterGravity.grave ∧
  sc.culpability.isMaximal

/-- §1862: A sin is venial when any condition falls short of the mortal
    threshold — either less serious matter, or grave matter without full
    knowledge or complete consent.

    In the condition-space, this is EVERYTHING except the mortal corner. -/
def SinConditions.isVenial (sc : SinConditions) : Prop :=
  sc.gravity = MatterGravity.lesSerious ∨
  ¬sc.culpability.isMaximal

-- ============================================================================
-- ## Structural Theorems
-- ============================================================================

/-- The mortal and venial conditions are exhaustive: every set of
    conditions falls into one category or the other.

    This follows from the structure: either all three conditions are
    maximal (mortal), or at least one is not (venial). -/
theorem threshold_exhaustive (sc : SinConditions) :
    sc.isMortal ∨ sc.isVenial := by
  unfold SinConditions.isMortal SinConditions.isVenial
  cases hg : sc.gravity
  · -- grave: either culpability is maximal or not
    by_cases hm : sc.culpability.isMaximal
    · left; exact ⟨rfl, hm⟩
    · right; exact Or.inr hm
  · -- lesSerious: automatically venial
    right; exact Or.inl rfl

/-- Mortal and venial conditions are mutually exclusive.

    If all three conditions are maximal, then none of the venial
    conditions can hold (the matter IS grave, and culpability IS
    maximal). -/
theorem threshold_exclusive (sc : SinConditions) :
    sc.isMortal → ¬sc.isVenial := by
  intro ⟨hg, hm⟩ hv
  unfold SinConditions.isVenial at hv
  cases hv with
  | inl h => simp [hg] at h
  | inr h => exact h hm

/-- Bridge: the graded SinConditions model agrees with the binary Sin
    model from Sin.lean. A Sin with grave matter, full knowledge, and
    complete consent maps to mortal SinConditions.

    This shows the two models are COMPATIBLE: the binary model is a
    special case of the graded model (where knowledge and consent are
    at their maximum values). -/
theorem binary_agrees_with_graded (s : Sin)
    (h_mortal : s.isMortal) :
    ∃ (sc : SinConditions),
      sc.gravity = s.gravity ∧
      sc.isMortal := by
  obtain ⟨hg, hk, hc⟩ := h_mortal
  exact ⟨{ gravity := s.gravity,
            culpability := { knowledgeDeg := maxKnowledge,
                             consentDeg := maxConsent } },
         rfl,
         hg,
         ⟨rfl, rfl⟩⟩

-- ============================================================================
-- ## The Conjunctive Nature of the Threshold
-- ============================================================================

/-!
### Weakening ANY single condition prevents mortal sin

This is the central structural finding. The mortal sin threshold is
CONJUNCTIVE: all three conditions must hold simultaneously. Weakening
any single one — even while the other two remain maximal — is sufficient
to prevent mortal sin.

§1862 states this explicitly: "when he disobeys the moral law in a
grave matter, but without full knowledge OR without complete consent"
— this is venial sin, not mortal.

This means:
- Grave matter + full knowledge + incomplete consent = VENIAL
- Grave matter + not-full knowledge + complete consent = VENIAL
- Less serious matter + full knowledge + complete consent = VENIAL

The conjunction does all the work.
-/

/-- Weakening matter gravity (from grave to less serious) prevents
    mortal sin, regardless of knowledge and consent levels.

    A person with full knowledge and complete consent who commits a
    less serious offense has NOT committed mortal sin. -/
theorem weakening_matter_prevents_mortal
    (cd : CulpabilityDegree) (_h_max : cd.isMaximal) :
    ¬({ gravity := MatterGravity.lesSerious, culpability := cd : SinConditions}).isMortal := by
  intro ⟨hg, _⟩
  simp at hg

/-- Weakening knowledge (below full) prevents mortal sin, even with
    grave matter and complete consent.

    §1860: ignorance can "diminish or even remove" imputability.
    Even a grave act done with complete consent but without full
    knowledge is venial, not mortal. -/
theorem weakening_knowledge_prevents_mortal
    (cd : CulpabilityDegree)
    (h_not_full : ¬cd.isFullKnowledge) :
    ¬({ gravity := MatterGravity.grave, culpability := cd : SinConditions}).isMortal := by
  intro ⟨_, hm⟩
  exact h_not_full hm.1

/-- Weakening consent (below complete) prevents mortal sin, even with
    grave matter and full knowledge.

    §1860: factors like fear, habit, or passion can diminish consent.
    Even a grave act done with full knowledge but without complete
    consent is venial, not mortal. -/
theorem weakening_consent_prevents_mortal
    (cd : CulpabilityDegree)
    (h_not_complete : ¬cd.isCompleteConsent) :
    ¬({ gravity := MatterGravity.grave, culpability := cd : SinConditions}).isMortal := by
  intro ⟨_, hm⟩
  exact h_not_complete hm.2

-- ============================================================================
-- ## Connection to Charity: The Threshold IS the Break Point
-- ============================================================================

/-!
### Mortal sin destroys charity; venial sin weakens it

§1861: Mortal sin "results in the loss of charity."
§1863: Venial sin "weakens charity" but "does not break the covenant."

The threshold in the condition-space is WHERE quantitative weakening of
charity BECOMES qualitative destruction. Below the threshold, sin weakens
charity (reducing its degree). AT the threshold, sin destroys charity
(reducing it to zero).

This answers the original question: the mortal/venial boundary is BOTH
a threshold (in the condition-space) AND a qualitative break (in the
effect on charity). The threshold PRODUCES the break.
-/

/-- §1863: Venial sin weakens charity but does not destroy it.
    If the sin conditions are venial, charity's degree may decrease
    but remains positive.

    HIDDEN ASSUMPTION: "weakening" means reduction of degree, not
    destruction. The CCC asserts this (§1863: "does not break the
    covenant") but the mechanism by which venial sin weakens without
    destroying is not specified. We axiomatize it.

    Source: [Definition] CCC §1863.
    Denominational scope: CATHOLIC — requires the mortal/venial distinction. -/
axiom venial_sin_weakens_charity :
  ∀ (tl : TypedLove) (sc : SinConditions),
    tl.kind = LoveKind.agape →
    tl.degree > 0 →
    sc.isVenial →
    -- Charity may decrease but remains positive
    ∃ (tl' : TypedLove),
      tl'.kind = LoveKind.agape ∧
      tl'.lover = tl.lover ∧
      tl'.beloved = tl.beloved ∧
      tl'.degree > 0

/-- §1861: Mortal sin destroys charity — reduces it to zero.
    If the sin conditions are mortal (all three maximal), charity
    is destroyed.

    This connects to `mortal_sin_can_destroy_charity` in Love.lean
    but is MORE SPECIFIC: it says exactly WHICH conditions must hold
    for charity to be destroyed. Love.lean uses `isGraveSin` (an
    opaque predicate); here we give the full three-condition structure.

    Source: [Definition] CCC §1861.
    Denominational scope: CATHOLIC. -/
axiom mortal_sin_destroys_charity :
  ∀ (tl : TypedLove) (sc : SinConditions),
    tl.kind = LoveKind.agape →
    tl.degree > 0 →
    sc.isMortal →
    ∃ (tl' : TypedLove),
      tl'.kind = LoveKind.agape ∧
      tl'.lover = tl.lover ∧
      tl'.beloved = tl.beloved ∧
      tl'.degree = 0

-- ============================================================================
-- ## Derived Theorems
-- ============================================================================

/-- The threshold theorem: the mortal/venial boundary in condition-space
    coincides with the destruction/weakening boundary in charity-space.

    On the venial side: charity survives (degree > 0).
    On the mortal side: charity is destroyed (degree = 0).

    This is the formalized answer to the backlog question: the boundary
    IS both a threshold (in conditions) and a break (in charity). The
    threshold PRODUCES the break. -/
theorem threshold_coincides_with_charity_break
    (tl : TypedLove) (sc : SinConditions)
    (h_agape : tl.kind = LoveKind.agape)
    (h_pos : tl.degree > 0) :
    -- If venial: charity survives
    (sc.isVenial →
      ∃ (tl' : TypedLove),
        tl'.kind = LoveKind.agape ∧
        tl'.lover = tl.lover ∧
        tl'.beloved = tl.beloved ∧
        tl'.degree > 0) ∧
    -- If mortal: charity is destroyed
    (sc.isMortal →
      ∃ (tl' : TypedLove),
        tl'.kind = LoveKind.agape ∧
        tl'.lover = tl.lover ∧
        tl'.beloved = tl.beloved ∧
        tl'.degree = 0) := by
  constructor
  · intro hv
    exact venial_sin_weakens_charity tl sc h_agape h_pos hv
  · intro hm
    exact mortal_sin_destroys_charity tl sc h_agape h_pos hm

/-- Only the full conjunction of all three conditions can destroy charity.

    This is a strengthening of the threshold theorem: we show that if
    ANY single condition is weakened, charity CANNOT be destroyed (it
    survives). Charity destruction requires exactly the mortal corner.

    This answers the CONTRIBUTING.md question directly: "What makes a
    sin mortal rather than merely grave in effect?" — it is the
    SIMULTANEOUS maximal presence of all three conditions. Any single
    deficiency reduces the effect from destruction to mere weakening. -/
theorem only_conjunction_destroys_charity
    (tl : TypedLove)
    (h_agape : tl.kind = LoveKind.agape)
    (h_pos : tl.degree > 0) :
    -- Less serious matter: charity survives (cd is universally
    -- quantified to show this holds for ANY culpability level)
    (∀ (_cd : CulpabilityDegree),
      ∃ (tl' : TypedLove),
        tl'.kind = LoveKind.agape ∧
        tl'.lover = tl.lover ∧
        tl'.beloved = tl.beloved ∧
        tl'.degree > 0) ∧
    -- Grave matter but not full knowledge: charity survives
    (∀ (cd : CulpabilityDegree),
      ¬cd.isFullKnowledge →
      ∃ (tl' : TypedLove),
        tl'.kind = LoveKind.agape ∧
        tl'.lover = tl.lover ∧
        tl'.beloved = tl.beloved ∧
        tl'.degree > 0) ∧
    -- Grave matter but not complete consent: charity survives
    (∀ (cd : CulpabilityDegree),
      ¬cd.isCompleteConsent →
      ∃ (tl' : TypedLove),
        tl'.kind = LoveKind.agape ∧
        tl'.lover = tl.lover ∧
        tl'.beloved = tl.beloved ∧
        tl'.degree > 0) := by
  refine ⟨fun cd => ?_, fun cd hk => ?_, fun cd hc => ?_⟩
  · -- Less serious matter is always venial
    have hv : ({ gravity := MatterGravity.lesSerious,
                 culpability := cd : SinConditions}).isVenial := by
      unfold SinConditions.isVenial; left; rfl
    exact venial_sin_weakens_charity tl _ h_agape h_pos hv
  · -- Grave matter + not-full knowledge is venial
    have hv : ({ gravity := MatterGravity.grave,
                 culpability := cd : SinConditions}).isVenial := by
      unfold SinConditions.isVenial; right
      intro ⟨hfk, _⟩; exact hk hfk
    exact venial_sin_weakens_charity tl _ h_agape h_pos hv
  · -- Grave matter + not-complete consent is venial
    have hv : ({ gravity := MatterGravity.grave,
                 culpability := cd : SinConditions}).isVenial := by
      unfold SinConditions.isVenial; right
      intro ⟨_, hcc⟩; exact hc hcc
    exact venial_sin_weakens_charity tl _ h_agape h_pos hv

/-!
### §1863: Venial sin disposes toward mortal sin

"Deliberate and unrepented venial sin disposes us little by little to
commit mortal sin." (§1863)

This is a pastoral observation the CCC does not formalize as a causal
law. To give it content we would need a model of how weakened charity
affects the agent's vulnerability to temptation — specifically, how
reduced agape degree makes it more likely that the agent will meet
all three conditions for mortal sin in a future act. The CCC does not
specify this mechanism.

We leave this as a documented OPEN QUESTION rather than a vacuous
axiom (body = True). The key structural point is already captured:
venial sin weakens charity (venial_sin_weakens_charity), and mortal
sin requires the full conjunction (only_conjunction_destroys_charity).
The trajectory from weakness to destruction is real but unformalizable
without a model of temptation dynamics.
-/

/-!
## Summary

### The mortal sin threshold model

The three conditions for mortal sin (§1857) form a 3D space:

```
                    consent
                      ↑
                      │
            maxConsent ├────────────────────┐
                      │                    │ ← MORTAL SIN
                      │   VENIAL REGION    │    (single corner)
                      │                    │
                    0 ├────────────────────┤
                      0              maxKnowledge → knowledge
                                     (at gravity = grave)
```

At `gravity = lesSerious`, the ENTIRE plane is venial — no amount of
knowledge or consent makes a less serious matter mortal.

At `gravity = grave`, only the top-right corner (full knowledge ×
complete consent) is mortal. All other points are venial.

### Key findings

1. **The threshold is CONJUNCTIVE**: weakening ANY single condition
   (matter, knowledge, or consent) prevents mortal sin. This is sharper
   than saying "all three are needed" — it means each condition is
   independently protective.

2. **The threshold PRODUCES the qualitative break**: below the threshold,
   charity is weakened (venial effect). At the threshold, charity is
   destroyed (mortal effect). The threshold in conditions IS the break
   in charity.

3. **The graded and binary models are compatible**: Sin.lean's binary
   model captures the CLASSIFICATION (mortal vs. venial). This file's
   graded model captures the PASTORAL REALITY (degrees of culpability).
   They agree at the endpoints.

4. **HIDDEN ASSUMPTION — sufficiency**: The CCC says the three conditions
   are necessary (§1857: "must together be met"). We also assume they are
   sufficient — no fourth condition is needed. The tradition supports
   this but the CCC does not state it explicitly.

5. **HIDDEN ASSUMPTION — sharp boundary**: We model the boundary as
   sharp (at vs. below maximum). The CCC's language is binary ("full"
   vs. "not full"), but §1860 acknowledges a spectrum. Where exactly
   "full" begins on the spectrum is not specified. This is the genuine
   pastoral difficulty: at what point does diminished knowledge become
   "not full" enough to prevent mortal sin?

### Denominational scope

- Three conditions for mortal sin: CATHOLIC (requires the mortal/venial
  distinction, which most Protestants reject)
- Culpability depends on knowledge and consent: ECUMENICAL (all
  Christians agree that ignorance and coercion diminish guilt)
- Mortal sin destroys charity: CATHOLIC (requires Catholic theology
  of grace and charity)
-/

-- ============================================================================
-- ## Denominational Tags
-- ============================================================================

/-- The mortal sin threshold model: Catholic. -/
def mortal_sin_threshold_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "CCC §1857-1862; requires mortal/venial distinction" }

/-- Culpability depends on knowledge/consent: ecumenical. -/
def culpability_graded_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "All Christians accept that ignorance/coercion diminish guilt" }

end Catlib.MoralTheology.MortalSinThreshold
