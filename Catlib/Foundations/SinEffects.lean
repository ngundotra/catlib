import Catlib.Foundations.Basic

/-!
# The Three Layers of Sin's Effects (CCC §405, §1472)

The Catechism describes THREE distinct effects of sin, each removed
by a different mechanism. This is not our invention — it's what
§405 and §1472 explicitly say.

## The three layers

§405: Original sin = inherited wound (ignorance, concupiscence,
mortality). Removed by Baptism, but "consequences for nature...
persist."

§1472: "Grave sin deprives us of communion with God" = eternal
punishment (guilt). Removed by Reconciliation (absolution).

§1472: "Every sin, even venial, entails an unhealthy attachment
to creatures" = temporal punishment. Removed by purification
(penance in life, or purgatory after death).

§1472: "These two punishments must not be conceived of as a kind
of vengeance inflicted by God from without, but as following from
the very nature of sin."

## Important: Layer 1 ≠ Layer 3

Original sin (Layer 1) is the INHERITED inclination — not your fault.
Temporal punishment (Layer 3) is the residue of YOUR OWN sins —
the habits and attachments your choices created. These are different
things. The CCC treats them separately (§405 vs §1472).

## Ambiguity: the CCC does not determine all cases

§847: Those who "through no fault of their own, do not know the
Gospel" may be saved "in ways known to himself [God]."

§1260: Same — "in ways known to himself God can lead those who...
are ignorant of the Gospel."

Our model must NOT force a determinate answer where the CCC
explicitly says "we don't know." The `knownToGodAlone` outcome
preserves this ambiguity.
-/

namespace Catlib

/-!
## The three effects of sin
-/

/-- The three distinct effects sin has on a person (§405, §1472).
    Each is removed by a different mechanism. They are INDEPENDENT —
    you can have Layer 3 without Layer 2 (venial sin creates
    attachment without destroying communion). -/
inductive SinEffect where
  /-- Layer 1: Original sin — inherited wound.
      Source: §405. Not your fault. Removed by Baptism.
      Effects: ignorance, concupiscence, suffering, mortality.
      After Baptism: the sin is erased but "consequences for nature,
      weakened and inclined to evil, persist" (§405). -/
  | originalWound
  /-- Layer 2: Guilt of personal sin — "eternal punishment."
      Source: §1472. Your free choice. Removed by Reconciliation.
      Effect: "deprives us of communion with God" — loss of grace.
      This is what mortal sin does: it breaks the relationship. -/
  | guilt
  /-- Layer 3: Unhealthy attachment — "temporal punishment."
      Source: §1472. Residue of your own sins.
      Removed by purification (penance, charity, or purgatory).
      Effect: "unhealthy attachment to creatures" — disordered
      habits, lingering pull toward sin, even after forgiveness.
      NOT the same as original sin (Layer 1). Layer 1 is inherited
      inclination; Layer 3 is what YOUR sins added on top. -/
  | attachment

/-- The state of a particular sin-effect for a person.
    Each layer can be: present, removed, or unknown. -/
inductive EffectState where
  /-- This effect is present in the person -/
  | present
  /-- This effect has been removed (by baptism, reconciliation, or purification) -/
  | removed
  /-- The CCC does not determine this case.
      §847: "in ways known to himself [God]." -/
  | unknownToUs
  deriving DecidableEq, BEq

/-- The complete sin-effect profile of a person.
    Tracks which of the three layers are present, removed, or unknown. -/
structure SinProfile where
  /-- State of original sin (Layer 1) -/
  originalWound : EffectState
  /-- State of guilt / eternal punishment (Layer 2) -/
  guilt : EffectState
  /-- State of unhealthy attachments / temporal punishment (Layer 3) -/
  attachment : EffectState

/-!
## Standard profiles
-/

/-- A baptized person in good standing — original sin removed,
    no unrepented mortal sin, but attachments may linger. -/
def baptizedInGrace : SinProfile :=
  { originalWound := EffectState.removed
    guilt := EffectState.removed
    attachment := EffectState.present }  -- attachments often remain

/-- A baptized person who committed mortal sin — guilt returned,
    attachments accumulating. -/
def baptizedInMortalSin : SinProfile :=
  { originalWound := EffectState.removed  -- baptism was valid
    guilt := EffectState.present           -- mortal sin restored guilt
    attachment := EffectState.present }

/-- After Reconciliation — guilt removed, but temporal punishment
    (attachments) may remain. This is what §1472 says. -/
def afterReconciliation : SinProfile :=
  { originalWound := EffectState.removed
    guilt := EffectState.removed
    attachment := EffectState.present }  -- §1472: attachment persists

/-- Fully purified — all three layers removed. Ready for heaven. -/
def fullyPurified : SinProfile :=
  { originalWound := EffectState.removed
    guilt := EffectState.removed
    attachment := EffectState.removed }

/-- A person who never heard the Gospel — all layers unknown (§847).
    "In ways known to himself [God]." -/
def unevangelized : SinProfile :=
  { originalWound := EffectState.unknownToUs
    guilt := EffectState.unknownToUs
    attachment := EffectState.unknownToUs }

/-- A more precise model: someone born with original sin (they're
    human — §405) but who never heard the Gospel. We KNOW they have
    the inherited wound. We DON'T know their personal moral state.
    Result: still knownToGodAlone — one unknown poisons the whole
    determination. The CCC knows they have original sin but cannot
    judge their personal relationship with God (§847). -/
def nativeWithOriginalSin : SinProfile :=
  { originalWound := EffectState.present   -- we KNOW this (§405)
    guilt := EffectState.unknownToUs        -- can't judge their conscience
    attachment := EffectState.unknownToUs }  -- can't judge their attachments

/-!
## Afterlife determination

The afterlife outcome follows from the sin profile — BUT some
cases are genuinely undetermined by the CCC.
-/

/-- The possible afterlife outcomes.
    The CCC determines three cases and explicitly leaves one open. -/
inductive AfterlifeOutcome where
  /-- All layers removed → beatific vision -/
  | heaven
  /-- In grace but attachments remain → purification needed -/
  | purgatory
  /-- Died in unrepented mortal sin → permanent separation -/
  | hell
  /-- §847, §1260: "in ways known to himself [God]."
      The CCC explicitly does NOT determine this case.
      Our model MUST preserve this ambiguity — encoding a
      determinate answer here would go beyond the CCC. -/
  | knownToGodAlone

/-- Determine the afterlife outcome from a sin profile.
    Where the CCC is determinate, we give a determinate answer.
    Where the CCC says "we don't know," we say `knownToGodAlone`. -/
def afterlifeFromProfile (sp : SinProfile) : AfterlifeOutcome :=
  -- If ANY layer is unknown, the outcome is unknown
  if sp.originalWound = EffectState.unknownToUs
    ∨ sp.guilt = EffectState.unknownToUs
    ∨ sp.attachment = EffectState.unknownToUs
  then AfterlifeOutcome.knownToGodAlone
  -- All layers removed → heaven
  else if sp.originalWound = EffectState.removed
    ∧ sp.guilt = EffectState.removed
    ∧ sp.attachment = EffectState.removed
  then AfterlifeOutcome.heaven
  -- Guilt present → hell (died in mortal sin)
  else if sp.guilt = EffectState.present
  then AfterlifeOutcome.hell
  -- Guilt removed but attachments present → purgatory
  else AfterlifeOutcome.purgatory

/-!
## Theorems — what the CCC determines and what it doesn't
-/

/-- The fully purified go to heaven. (Determinate — CCC §1023.) -/
theorem purified_go_to_heaven :
    afterlifeFromProfile fullyPurified = AfterlifeOutcome.heaven := by
  simp [afterlifeFromProfile, fullyPurified]

/-- Those who die in mortal sin go to hell. (Determinate — CCC §1033.) -/
theorem mortal_sin_goes_to_hell :
    afterlifeFromProfile baptizedInMortalSin = AfterlifeOutcome.hell := by
  simp [afterlifeFromProfile, baptizedInMortalSin]

/-- Those in grace but with attachments go to purgatory. (Determinate — CCC §1030.) -/
theorem attachments_go_to_purgatory :
    afterlifeFromProfile afterReconciliation = AfterlifeOutcome.purgatory := by
  simp [afterlifeFromProfile, afterReconciliation]

/-- The unevangelized → "known to God alone." (CCC §847.)
    The model REFUSES to determine this case, matching the CCC. -/
theorem unevangelized_is_unknown :
    afterlifeFromProfile unevangelized = AfterlifeOutcome.knownToGodAlone := by
  simp [afterlifeFromProfile, unevangelized]

/-- Even knowing someone has original sin (they're human), if we
    can't determine their guilt or attachments, the outcome is still
    knownToGodAlone. The unknowns propagate — one unknown poisons
    the whole determination.
    This models the CCC's position on natives who never heard the
    Gospel: we KNOW they have original sin (§405), but we CANNOT
    judge their personal moral state (§847). -/
theorem native_with_original_sin_still_unknown :
    afterlifeFromProfile nativeWithOriginalSin = AfterlifeOutcome.knownToGodAlone := by
  simp [afterlifeFromProfile, nativeWithOriginalSin]

/-- §1472: Temporal punishment is NOT vengeance — it follows from
    the nature of sin. The attachment IS the punishment, not
    something added on top. Connects to P3 (evil is privation). -/
axiom temporal_punishment_is_intrinsic :
  ∀ (sp : SinProfile),
    sp.attachment = EffectState.present →
    -- The attachment follows from the sin itself, not from
    -- external divine punishment (§1472)
    True  -- NOTE: this is vacuous. The real content is in the
          -- docstring. Future work: give it real content by
          -- modeling attachment as a natural consequence of
          -- the act, not an imposed penalty.

/-!
## Summary

The three-layer model from the CCC (§405, §1472):

| Layer | What | Source | Removed by | CCC |
|-------|------|--------|-----------|-----|
| 1 | Original wound | Adam | Baptism | §405 |
| 2 | Guilt (eternal punishment) | Your mortal sin | Reconciliation | §1472 |
| 3 | Attachment (temporal punishment) | Your sins' residue | Purification | §1472 |

Layer 1 ≠ Layer 3. Original sin is inherited; attachments are self-inflicted.

The afterlife is DETERMINED by which layers remain — except for
cases the CCC explicitly leaves to God's knowledge (§847).

The `knownToGodAlone` outcome is not a cop-out. It's what the CCC
says. A model that forces an answer where the CCC says "we don't
know" would be going BEYOND the source material.
-/

end Catlib
