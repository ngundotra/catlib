import Catlib.Foundations

/-!
# CCC §1849–1864: Sin

## The Catechism claims

"Sin is an offense against reason, truth, and right conscience; it is a
failure in genuine love for God and neighbor caused by a perverse attachment
to certain goods." (§1849)

"Sin is an offense against God." (§1850)

"Mortal sin requires full knowledge and complete consent." (§1859)

"Mortal sin... results in the loss of charity and the privation of sanctifying
grace, that is, of the state of grace. If it is not redeemed by repentance and
God's forgiveness, it causes exclusion from Christ's kingdom and the eternal
death of hell." (§1861)

"One commits venial sin when, in a less serious matter, he does not observe
the standard prescribed by the moral law, or when he disobeys the moral law
in a grave matter, but without full knowledge or without complete consent."
(§1862)

## Prediction

I expect this to **require stronger premises**. The distinction between mortal
and venial sin rests on a precise threshold: "full knowledge AND complete
consent." This binary framing (full vs. not-full) hides a modeling choice:
is knowledge a binary or a spectrum? Is consent all-or-nothing or graded?
The Catechism seems to assume both are binary, but that's doing invisible work.

Also: the claim that mortal sin "causes" loss of grace assumes a specific
causal model connecting free human acts to divine states. That's a major
hidden assumption.

## Findings

- **Prediction vs. reality**: Confirmed — requires stronger premises. The
  mortal/venial distinction requires: (1) knowledge and consent are binary,
  not graded, (2) "grave matter" is objectively determinable (same independence
  assumption as §1756), and (3) a causal axiom connecting human acts to states
  of grace. None of these are stated in §1859-1862.
- **Catholic reading axioms used**: [Definition] CCC §1849, §1859, §1862
- **Surprise level**: Significant — the binary knowledge/consent assumption
  was expected, but the hidden causal model connecting sin to grace was not
  predicted. The Catechism treats this causation as obvious, but formalizing
  it requires a specific metaphysics of grace.
- **Assessment**: Tier 3 — multiple hidden premises exposed.
-/

-- Define isMortal and isVenial in the Catlib namespace so they become
-- Catlib.Sin.isMortal and Catlib.Sin.isVenial (dot notation on Sin).
namespace Catlib

-- MoralKnowledge, MoralConsent, MatterGravity, and Sin are defined in
-- Basic.lean. The unified Sin type captures both the essential nature of
-- sin (freedom, contrariety to reason/truth) and the severity conditions
-- (knowledge, consent, gravity).

/-- §1857: "Mortal sin is sin whose object is grave matter and which is
    also committed with full knowledge and deliberate consent."
    All three conditions must be met simultaneously. -/
def Sin.isMortal (s : Sin) : Prop :=
  s.gravity = MatterGravity.grave ∧
  s.knowledge = MoralKnowledge.full ∧
  s.consent = MoralConsent.complete

/-- §1862: Venial sin occurs when ANY of the three conditions for mortal
    sin is not met. -/
def Sin.isVenial (s : Sin) : Prop :=
  -- Less serious matter with any knowledge/consent, OR
  -- Grave matter but without full knowledge or complete consent
  s.gravity = MatterGravity.lesSerious ∨
  s.knowledge = MoralKnowledge.notFull ∨
  s.consent = MoralConsent.incomplete

end Catlib

namespace Catlib.MoralTheology

open Catlib

/-- Mortal and venial are exhaustive: every sin is one or the other.
    HIDDEN ASSUMPTION: There are exactly two categories. No sin is
    "neither mortal nor venial." The Catechism asserts this but doesn't
    prove it — it follows from the binary modeling of all three properties. -/
theorem mortal_or_venial (s : Sin) :
    s.isMortal ∨ s.isVenial := by
  unfold Sin.isMortal Sin.isVenial
  cases hg : s.gravity <;> cases hk : s.knowledge <;> cases hc : s.consent
  all_goals simp_all

/-- Mortal and venial are mutually exclusive. -/
theorem mortal_venial_exclusive (s : Sin) :
    s.isMortal → ¬s.isVenial := by
  intro ⟨hg, hk, hc⟩ hv
  unfold Sin.isVenial at hv
  cases hv with
  | inl h => simp [hg] at h
  | inr h => cases h with
    | inl h => simp [hk] at h
    | inr h => simp [hc] at h

/-!
## The hidden causal model: Sin → Loss of Grace

§1861 claims mortal sin "results in the loss of charity and the privation
of sanctifying grace." This is a CAUSAL claim connecting a human act to
a divine state. To formalize this, we need an axiom about how human acts
affect the state of grace. The Catechism doesn't explain the mechanism —
it presents the causation as a brute fact.
-/

/-- The state of a person with respect to grace.
    MODELING CHOICE: Binary — you're either in a state of grace or not.
    Catholic theology actually has more nuance (degrees of grace, etc.)
    but the mortal sin discussion treats it as binary. -/
inductive GraceState where
  | inGrace    -- In a state of sanctifying grace
  | notInGrace -- Deprived of sanctifying grace

/-- A person's spiritual state. -/
structure SpiritualState where
  person : Person
  graceState : GraceState

/-- §1861 as an AXIOM: Mortal sin causes loss of grace.
    This is presented as a fact, not derived from anything.
    We must axiomatize it because the Catechism doesn't give a
    mechanism — it's a revealed truth, not a reasoned conclusion.

    HIDDEN ASSUMPTION: There exists a causal connection between
    free human acts and divine states (grace). This is a specific
    metaphysics that the Catechism assumes but doesn't argue for. -/
axiom mortal_sin_causes_loss_of_grace :
  ∀ (s : Sin) (state : SpiritualState),
    s.isMortal →
    state.graceState = GraceState.inGrace →
    ∃ (newState : SpiritualState),
      newState.person = state.person ∧
      newState.graceState = GraceState.notInGrace

/-- Consequence: a person who commits mortal sin while in grace
    necessarily transitions out of grace. This follows directly from
    the axiom — the "proof" is trivial. The FINDING is that we needed
    the axiom at all. -/
theorem mortal_sin_removes_grace
    (s : Sin) (state : SpiritualState)
    (h_mortal : s.isMortal)
    (h_in_grace : state.graceState = GraceState.inGrace) :
    ∃ (newState : SpiritualState),
      newState.person = state.person ∧
      newState.graceState = GraceState.notInGrace :=
  mortal_sin_causes_loss_of_grace s state h_mortal h_in_grace

/-!
## Summary of hidden assumptions

Formalizing §1849-1864 required these assumptions the text didn't state:

1. **Knowledge is binary** (full or not-full). No spectrum.
2. **Consent is binary** (complete or not-complete). No spectrum.
3. **Matter gravity is binary** (grave or less serious). No spectrum.
4. **Grace state is binary** (in grace or not). No spectrum.
5. **Mortal sin causally removes grace** — a brute axiom connecting
   human acts to divine states, with no stated mechanism.

The Catechism's moral theology rests on a deeply binary ontology.
Everything is either/or. This is a philosophical commitment that
the proof assistant forced into the open.
-/

end Catlib.MoralTheology
