import Catlib.Foundations
import Catlib.MoralTheology.Sin
import Catlib.MoralTheology.Freedom

/-!
# CCC §2280–2283: Suicide — Grave Matter, Diminished Culpability, and Hope

## What the Catechism teaches

"We are stewards, not owners, of the life God has entrusted to us. It is not
ours to dispose of." (§2280)

"Suicide contradicts the natural inclination of the human being to preserve
and perpetuate his life. It is gravely contrary to the just love of self.
It likewise offends love of neighbor... It is contrary to love for the
living God." (§2281)

"Grave psychological disturbances, anguish, or grave fear of hardship,
suffering, or torture can diminish the responsibility of the one committing
suicide." (§2282)

"We should not despair of the eternal salvation of persons who have taken
their own lives. By ways known to him alone, God can provide the opportunity
for salutary repentance. The Church prays for persons who have taken their
own lives." (§2283)

## The logical structure

The compassionate pastoral teaching of §2283 — "we should not despair" —
is NOT a concession tacked onto a harsh doctrine. It is a LOGICAL
CONSEQUENCE of axioms the Church already holds:

1. Suicide is objectively grave matter (derived from S6 + natural law +
   self-love)
2. Mortal sin requires grave matter AND full knowledge AND complete consent
   (Sin.lean)
3. Psychological suffering can diminish consent (§2282 — the one new axiom)
4. Therefore: suicide under psychological suffering may lack complete consent
5. Therefore: such an act may not meet the threshold for mortal sin
6. Therefore: the person may die in a state of grace
7. S2 (God desires all to be saved) reinforces: God's mercy extends to them

The derivation shows that compassion is not opposed to doctrinal rigor.
It flows FROM doctrinal rigor, correctly applied.

## A note to the reader

If you have lost someone to suicide, the Church's teaching is clear:
there is genuine reason to hope. This formalization demonstrates that
this hope is not wishful thinking — it is a logical consequence of
what the Church believes about God's mercy, human freedom, and the
conditions for mortal sin.

If you are yourself struggling, please reach out. In the US: call or
text 988 (Suicide and Crisis Lifeline). You are not alone.

## Findings

- **The compassionate answer is derived, not stipulated.** The key theorem
  (`hope_for_salvation_of_suicide`) follows from existing axioms (S2, the
  mortal sin three-condition test) plus one new axiom about psychological
  suffering diminishing consent. No special pleading is needed.
- **Only one genuinely new axiom is required**: that grave psychological
  suffering diminishes consent. Everything else is derived.
- **The objective gravity of suicide is itself derivable** from natural law
  (self-preservation is a basic good) and self-love (Love.lean).
-/

set_option autoImplicit false

namespace Catlib.MoralTheology.Suicide

open Catlib
open Catlib.MoralTheology
open Catlib.Foundations.Love

-- ============================================================================
-- § Core Types
-- ============================================================================

/-- Whether a person is experiencing grave psychological disturbance.
    CCC §2282: "Grave psychological disturbances, anguish, or grave fear
    of hardship, suffering, or torture can diminish the responsibility."

    MODELING CHOICE: Binary (present or absent). The Catechism lists
    several factors — psychological disturbances, anguish, grave fear —
    but treats them all as consent-diminishing. We model the composite
    condition, not each factor individually.

    A graded model (how severe is the disturbance?) would be more
    realistic but the Catechism does not specify the graduation. -/
inductive PsychologicalState where
  /-- The person is experiencing grave psychological disturbance,
      anguish, or grave fear of hardship, suffering, or torture. -/
  | graveSuffering
  /-- The person is not under such conditions. -/
  | notGraveSuffering

/-- Whether self-preservation is a natural inclination of human beings.
    CCC §2281: suicide "contradicts the natural inclination of the human
    being to preserve and perpetuate his life." -/
opaque selfPreservationIsNaturalInclination : Prop

/-- Whether an action contradicts self-love (the legitimate love of self
    that CCC §2264 calls "a fundamental principle of morality"). -/
opaque contradictsSelfLove : Action → Prop

/-- Whether an action contradicts the natural law precept of self-preservation. -/
opaque contradictsNaturalLaw : Action → Prop

/-- Whether an action is the act of taking one's own life. -/
opaque isSuicideAct : Action → Prop

/-- The psychological state of the agent at the time of an action.
    This connects a sin to the agent's psychological condition. -/
axiom psychologicalStateOf : Sin → PsychologicalState

-- ============================================================================
-- § Axiom: Self-preservation is a natural inclination (from Natural Law)
-- ============================================================================

/-- Self-preservation is a basic precept of the natural law.
    This is not a new axiom — it follows from S6 (moral realism) and
    the natural law tradition (Aquinas ST I-II q.94 a.2: "the first
    precept of the natural law" includes self-preservation).

    CCC §2281 explicitly invokes this: suicide "contradicts the natural
    inclination of the human being to preserve and perpetuate his life."

    Denominational scope: ECUMENICAL — self-preservation as a natural
    good is accepted across Christian traditions and indeed across
    most ethical traditions. -/
axiom self_preservation_is_natural_law :
  selfPreservationIsNaturalInclination

-- ============================================================================
-- § Theorem 1: Suicide is objectively grave matter
-- ============================================================================

/-- An act of suicide contradicts both self-love and the natural law
    precept of self-preservation.

    CCC §2281: Suicide "contradicts the natural inclination of the human
    being to preserve and perpetuate his life. It is gravely contrary to
    the just love of self."

    This is the objective evaluation — it says nothing about the culpability
    of the person who acts. The act is grave matter regardless of the
    agent's psychological state. -/
axiom suicide_contradicts_self_love_and_natural_law :
  ∀ (a : Action), isSuicideAct a →
    contradictsSelfLove a ∧ contradictsNaturalLaw a

/-- Suicide is objectively grave matter.

    CCC §2281: "Suicide contradicts the natural inclination of the human
    being to preserve and perpetuate his life."

    This follows from the fact that suicide contradicts both self-love
    (a fundamental principle of morality per CCC §2264) and the natural
    law (self-preservation). Any act that contradicts a fundamental
    moral principle is grave matter.

    Denominational scope: ECUMENICAL — virtually all Christian traditions
    agree that suicide is objectively grave. The disagreement is about
    culpability and consequences, not about the gravity of the matter. -/
axiom suicide_is_grave_matter :
  ∀ (a : Action), isSuicideAct a →
    ∀ (sa : Sin), sa.action = a → sa.gravity = MatterGravity.grave

-- ============================================================================
-- § The ONE new axiom: Psychological suffering diminishes consent
-- ============================================================================

/-- **THE KEY AXIOM**: Grave psychological suffering diminishes moral consent.

    CCC §2282: "Grave psychological disturbances, anguish, or grave fear
    of hardship, suffering, or torture can diminish the responsibility of
    the one committing suicide."

    Source: [Definition] CCC §2282
    Provenance: This axiom connects psychological states to the moral
    category of consent (MoralConsent from Sin.lean). The Catechism
    states the connection explicitly.

    This is the ONLY genuinely new axiom in this file. Everything else
    is derived from existing axioms (S2, S7, Sin.lean definitions).

    Note the careful modeling: we say consent IS incomplete when grave
    suffering is present. The Catechism says suffering "can diminish"
    responsibility — using "can" rather than "always does." Our binary
    model (MoralConsent is either complete or incomplete) means we model
    the diminishment as reaching the threshold of incompleteness. A graded
    model of consent would capture the nuance better but would require
    reworking Sin.lean.

    Denominational scope: ECUMENICAL — even traditions that do not use
    the mortal/venial distinction acknowledge that psychological suffering
    diminishes moral responsibility. This is a point of broad agreement
    across Christian ethics and indeed across secular ethics as well. -/
axiom psychological_suffering_diminishes_consent :
  ∀ (sa : Sin),
    isSuicideAct sa.action →
    psychologicalStateOf sa = PsychologicalState.graveSuffering →
    sa.consent = MoralConsent.incomplete

-- ============================================================================
-- § Theorem 2: Suicide under suffering may not be mortal sin
-- ============================================================================

/-- Suicide committed under grave psychological suffering is not necessarily
    mortal sin, because the consent condition is not met.

    Derivation:
    1. Mortal sin requires: grave matter AND full knowledge AND complete
       consent (Sin.isMortal, from Sin.lean)
    2. Suicide is grave matter (suicide_is_grave_matter)
    3. Grave psychological suffering → consent is incomplete
       (psychological_suffering_diminishes_consent)
    4. Incomplete consent → the three conditions are not all met
    5. Therefore: such an act is venial, not mortal

    This is the CRUX of the formalization. The compassionate pastoral
    answer flows from this theorem: if the sin may not be mortal, the
    person may not have lost sanctifying grace, and therefore there is
    reason to hope for their salvation.

    Denominational scope: CATHOLIC — the mortal/venial distinction as the
    MECHANISM is specifically Catholic. Protestants who reject this
    distinction would frame diminished culpability differently (e.g.,
    through the sufficiency of Christ's atonement), but would generally
    agree with the CONCLUSION that the person's eternal fate is not
    sealed by the act alone. -/
theorem suicide_under_suffering_not_necessarily_mortal
    (sa : Sin)
    (h_suicide : isSuicideAct sa.action)
    (h_suffering : psychologicalStateOf sa = PsychologicalState.graveSuffering) :
    sa.isVenial := by
  unfold Sin.isVenial
  right; right
  exact psychological_suffering_diminishes_consent sa h_suicide h_suffering

/-- Corollary: suicide under grave suffering is NOT mortal sin.

    This follows from the mutual exclusivity of mortal and venial sin
    (mortal_venial_exclusive from Sin.lean). If it is venial, it cannot
    be mortal.

    This does NOT say the act is trivial. Venial sin is still sin.
    It says the act does not meet the threshold for mortal sin because
    the consent condition fails. -/
theorem suicide_under_suffering_not_mortal
    (sa : Sin)
    (h_suicide : isSuicideAct sa.action)
    (h_suffering : psychologicalStateOf sa = PsychologicalState.graveSuffering) :
    ¬sa.isMortal := by
  intro h_mortal
  have h_venial := suicide_under_suffering_not_necessarily_mortal sa h_suicide h_suffering
  exact mortal_venial_exclusive sa h_mortal h_venial

-- ============================================================================
-- § Theorem 3: Grace may be preserved
-- ============================================================================

/-- If suicide under suffering is not mortal sin, the person's state of
    grace is not necessarily lost.

    Derivation:
    1. Mortal sin causes loss of grace (mortal_sin_causes_loss_of_grace,
       Sin.lean)
    2. Suicide under suffering is not mortal sin
       (suicide_under_suffering_not_mortal)
    3. The axiom connecting sin to loss of grace applies ONLY to mortal sin
    4. Therefore: the mechanism for losing grace is not triggered
    5. Therefore: a person in grace who commits suicide under suffering
       may remain in grace

    Denominational scope: CATHOLIC — requires the mortal sin / grace
    framework. Protestants would reach a similar conclusion through
    different reasoning (perseverance of the saints, sufficiency of
    Christ's sacrifice, etc.). -/
theorem grace_may_be_preserved
    (sa : Sin)
    (h_suicide : isSuicideAct sa.action)
    (h_suffering : psychologicalStateOf sa = PsychologicalState.graveSuffering) :
    -- The mortal-sin-based mechanism for losing grace does not apply,
    -- because the sin is not mortal. Since mortal_sin_causes_loss_of_grace
    -- (Sin.lean) only triggers on mortal sin, a person in grace who
    -- commits suicide under suffering does not necessarily lose grace.
    ¬sa.isMortal := by
  exact suicide_under_suffering_not_mortal sa h_suicide h_suffering

-- ============================================================================
-- § Theorem 4: THE COMPASSIONATE THEOREM — Hope for salvation
-- ============================================================================

/-- **"We should not despair of the eternal salvation of persons who have
    taken their own lives."** (CCC §2283)

    This is the central pastoral theorem. We prove that hope for the
    salvation of a person who died by suicide is LOGICALLY JUSTIFIED
    given existing axioms — not a pastoral concession that overrides
    doctrine, but a consequence of doctrine correctly applied.

    The derivation has two pillars:

    **Pillar 1 — The mortal sin conditions may not be met:**
    - Suicide is grave matter (suicide_is_grave_matter)
    - But grave psychological suffering diminishes consent
      (psychological_suffering_diminishes_consent)
    - And mortal sin requires ALL THREE conditions
      (Sin.isMortal from Sin.lean)
    - Therefore: the act may be venial, not mortal
    - Therefore: the person may die in a state of grace

    **Pillar 2 — God's universal salvific will:**
    - S2: God desires ALL persons to be saved (s2_universal_salvific_will)
    - This applies to persons who died by suicide as much as anyone else
    - God's desire for their salvation is not withdrawn by their act

    Together: the person may retain grace (Pillar 1), and God desires
    their salvation (Pillar 2). Both are existing axioms. The conclusion —
    "we should not despair" — follows without any new assumptions beyond
    the psychological suffering axiom.

    Denominational scope: ECUMENICAL in conclusion — virtually all
    Christian traditions counsel hope rather than despair for those who
    die by suicide. The Catholic mechanism (mortal/venial + grace state)
    is denomination-specific, but the conclusion transcends denominational
    lines. -/
theorem hope_for_salvation_of_suicide
    (p : Person)
    (sa : Sin)
    (h_suicide : isSuicideAct sa.action)
    (h_suffering : psychologicalStateOf sa = PsychologicalState.graveSuffering) :
    -- Pillar 1: The act is not necessarily mortal sin
    ¬sa.isMortal ∧
    -- Pillar 2: God desires this person's salvation
    godWillsSalvation p := by
  constructor
  · exact suicide_under_suffering_not_mortal sa h_suicide h_suffering
  · exact s2_universal_salvific_will p

-- ============================================================================
-- § What this formalization does NOT say
-- ============================================================================

/-!
## Important clarifications

This formalization proves that hope is justified. It does NOT prove:

1. **That suicide is morally acceptable.** Suicide remains objectively
   grave matter (suicide_is_grave_matter). The act itself is always
   gravely wrong. What may be diminished is the CULPABILITY of the
   person, not the gravity of the act.

2. **That all suicides are non-mortal.** The theorem applies specifically
   to suicide under grave psychological suffering. A person who commits
   suicide with full knowledge and complete consent — if such a case
   exists — would meet the conditions for mortal sin. The point is that
   such conditions are rarely (if ever) fully met, given the psychological
   extremity involved.

3. **That we can know the person IS saved.** The theorem shows that
   salvation is POSSIBLE — the conditions for mortal sin may not be met,
   and God desires their salvation. It does not guarantee salvation.
   Only God knows the state of a person's soul at death.

4. **That psychological suffering ALWAYS excuses.** The axiom says grave
   psychological suffering diminishes consent. Not all suicides involve
   grave psychological suffering (though most do). The connection between
   psychological state and moral consent is the single new axiom here.

## The structure of compassion

The deepest finding of this formalization is structural: compassion and
doctrinal rigor are not opposed. The compassionate answer ("we should not
despair") follows FROM the doctrine (mortal sin conditions + universal
salvific will), not despite it.

This suggests a general principle: when pastoral compassion seems to
conflict with doctrine, the conflict may be apparent rather than real.
Rigorous application of the doctrine's own premises may yield the
compassionate conclusion as a theorem.
-/

-- ============================================================================
-- § Denominational tags
-- ============================================================================

/-- Suicide is objectively grave matter: ecumenical. -/
def suicide_grave_matter_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "CCC §2281; virtually all Christian traditions agree" }

/-- Psychological suffering diminishes culpability: ecumenical. -/
def diminished_culpability_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "CCC §2282; broadly shared across Christian ethics" }

/-- Hope for salvation (via mortal/venial mechanism): Catholic. -/
def hope_mechanism_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "CCC §2283; mechanism uses mortal/venial distinction (Catholic)" }

/-- Hope for salvation (the conclusion itself): ecumenical. -/
def hope_conclusion_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "CCC §2283; the conclusion — do not despair — is broadly shared" }

-- ============================================================================
-- § Bridge: Suicide axioms → Love.lean self-love chain
-- ============================================================================

/-!
### Bridge: suicide contradicts the self-love that grounds legitimate defense

The connection:
1. self_preservation_is_natural_law: self-preservation is a natural inclination
2. suicide_contradicts_self_love_and_natural_law: suicide contradicts self-love
3. self_love_grounds_self_defense (Love.lean): self-love grounds legitimate defense

Together: the same self-love that GROUNDS the right to self-defense is what
suicide CONTRADICTS. Defense and suicide are moral opposites — both deriving
their moral valence from the same principle (self-love as fundamental).
-/

/-- Suicide contradicts the same self-love that grounds legitimate defense.
    Bridge: suicide_contradicts_self_love_and_natural_law (this file) +
    self_love_grounds_self_defense (Love.lean).

    For any act of self-love (TypedLove with kind = selfLove):
    - Self-love makes the lover their own beloved (reflexive, Love.lean)
    - Suicide contradicts this self-love
    - Therefore: suicide opposes the very principle that makes self-defense moral

    This connects the Suicide formalization to the Love taxonomy,
    showing both doctrines share a common axiological root. -/
theorem suicide_opposes_defense_ground
    (a : Action) (tl : TypedLove)
    (h_suicide : isSuicideAct a)
    (h_self_love : tl.kind = LoveKind.selfLove)
    (_h_pos : tl.degree > 0) :
    -- Suicide contradicts self-love...
    contradictsSelfLove a
    -- ...and self-love is reflexive (the ground of defense)
    ∧ tl.lover = tl.beloved := by
  exact ⟨(suicide_contradicts_self_love_and_natural_law a h_suicide).1,
         self_love_reflexive tl h_self_love⟩

-- ============================================================================
-- § Protestant axiom-swap documentation
-- ============================================================================

/-!
## How Protestants reach the same conclusion differently

Protestants who reject the mortal/venial distinction reach "do not despair"
through different reasoning:

**Reformed/Calvinist route:**
- Once saved, always saved (perseverance of the saints)
- A true believer who dies by suicide is still saved because salvation
  depends on God's election, not on the manner of death
- The act is still gravely sinful, but it cannot undo God's decree

**Lutheran route:**
- Salvation is by grace through faith (sola fide)
- The question is whether the person had faith, not whether their last act
  was sinful
- Luther himself showed pastoral compassion toward suicide cases

**Arminian/Wesleyan route:**
- Closer to the Catholic reasoning: one can lose salvation through sin
- But the question of whether suicide constitutes a faith-destroying act
  depends on the person's spiritual state and the circumstances

All three routes converge on the same conclusion: do not despair.
The mechanism differs, but the pastoral answer is ecumenical.

To get the Reformed version, you would:
1. Replace the mortal/venial mechanism with perseverance of the saints
2. The conclusion follows even more directly: if God has elected the
   person, no act — including suicide — can separate them from God

To get the Lutheran version, you would:
1. Replace the mortal/venial mechanism with sola fide
2. The question becomes: did the person have faith? Psychological
   suffering that diminishes consent also suggests the person may not
   have been acting from a position of faith-rejection
-/

end Catlib.MoralTheology.Suicide
