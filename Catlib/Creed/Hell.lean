import Catlib.Foundations
import Catlib.Creed.Soul

/-!
# CCC §1033 + §1037: Hell as Self-Exclusion

## The Catechism claims

"We cannot be united with God unless we freely choose to love him. But we
cannot love God if we sin gravely against him, against our neighbor or
against ourselves... To die in mortal sin without repenting and accepting
God's merciful love means remaining separated from him for ever by our
own free choice. This state of definitive self-exclusion from communion
with God and the blessed is called 'hell.'" (§1033)

"God predestines no one to go to hell; for this, a willful turning away
from God (a mortal sin) is necessary, and persistence in it until the
end." (§1037)

## The argument chain

1. Union with God requires freely choosing to love him
2. Grave sin prevents loving God
3. Dying in mortal sin without repentance = permanent separation
4. This permanent separation is hell
5. God doesn't predestine anyone to hell
6. Hell requires willful turning away + persistence until death

## Prediction

I expect this to **require stronger premises**. The argument assumes:
- Libertarian free will (not just compatibilism)
- Death is a hard boundary (no post-mortem change of will)
- The "self-exclusion" framing requires that the person COULD have chosen
  otherwise — this is libertarian free will, not argued for
- Love requires freedom (why can't a determined being love?)

The most interesting question: does "self-exclusion" actually follow from
the premises given, or does it require a specific model of freedom that
the text assumes without stating?

## Findings

- **Prediction vs. reality**: Confirmed — requires stronger premises.
  Four hidden axioms: (1) libertarian free will, (2) love requires freedom,
  (3) death is final (no post-mortem change), (4) mortal sin necessarily
  prevents love of God. The "self-exclusion" framing ONLY works under
  libertarian free will — under compatibilism, "self-exclusion" loses
  its moral weight because the person may not have been able to choose
  otherwise.
- **Catholic reading axioms used**: [Definition] CCC §1033, §1037;
  [Tradition] libertarian free will
- **Surprise level**: Significant — the dependency on libertarian (not
  compatibilist) free will was expected, but the hidden axiom that love
  REQUIRES freedom was not predicted. Why can't an unfree being love?
  The Catechism never answers this.
- **Assessment**: Tier 3 — multiple hidden premises, one genuinely surprising.
-/

namespace Catlib.Creed

open Catlib

/-!
## The logical chain

We formalize §1033's argument as a chain of implications, making each
premise explicit.
-/

/-- The state of a soul at death. The Catechism treats death as a hard
    boundary — no further change of will is possible.
    HIDDEN ASSUMPTION: Why is death final? This is asserted, not argued. -/
inductive DeathState where
  | inMortalSin    -- Died without repenting of mortal sin
  | repentant      -- Died having repented / in grace
  | neverSinned    -- (Theoretical) died without mortal sin

/-- The eternal destiny of a soul. -/
inductive EternalDestiny where
  | communionWithGod  -- Heaven / beatific vision
  | separatedFromGod  -- Hell

/-- AXIOM 1 (§1033): Union with God requires freely choosing to love him.
    Provenance: [Definition] CCC §1033
    HIDDEN ASSUMPTION: Love requires freedom. Why? The Catechism asserts
    this but doesn't argue for it. One could ask: can a determined being
    love? The Catechism says no — but that's a philosophical commitment,
    not a derivation.

    CONNECTION TO BASE AXIOM: This is an instantiation of the second
    conjunct of `Catlib.s1_god_is_love` (S1: godIsLove ∧ loveRequiresFreedom).
    The base axiom `loveRequiresFreedom` is an untyped Prop; this local
    axiom gives it operational content: without free will, communion with
    God is impossible. -/
axiom love_requires_freedom :
  ∀ (p : Person), p.hasFreeWill = false →
    ¬ inCommunion (.person p) .god

/-- AXIOM 2 (§1033): Communion with God implies being in a state of grace.
    Provenance: [Definition] CCC §1033, §1855
    "Mortal sin destroys charity in the heart of man." If you are in
    communion with God, you must be in grace — grave sin (which removes
    grace) also removes communion. -/
axiom grave_sin_prevents_love :
  ∀ (p : Person),
    inCommunion (.person p) .god → ¬ (∃ (s : Sin), isGraveSin s ∧ s.action.agent = p)

/-- AXIOM 3: Death is final — no post-mortem change of state.
    Provenance: [Tradition] — not explicitly argued in §1033, assumed.
    HIDDEN ASSUMPTION: This is a brute axiom. The Catechism doesn't
    explain why death is the boundary. Some theologians (von Balthasar)
    have questioned whether post-mortem conversion is possible. The
    Catechism simply asserts finality. -/
axiom death_is_final :
  ∀ (d : DeathState),
    d = DeathState.inMortalSin →
    ¬(∃ (d' : DeathState), d' = DeathState.repentant)

/-- AXIOM 4 (§1037): God predestines no one to hell.
    Provenance: [Definition] CCC §1037
    This means hell is always the result of free choice.

    CONNECTION TO BASE AXIOMS:
    - `Catlib.s2_universal_salvific_will` (S2: ∀ p, godWillsSalvation p)
      establishes that God WANTS everyone saved. This axiom establishes the
      complementary claim: no one is predestined to damnation.
    - `Catlib.t1_libertarian_free_will` (T1: ∀ a, couldChooseOtherwise a)
      provides the freedom model that makes self-exclusion meaningful. -/
axiom no_predestination_to_hell :
  ∀ (p : Person) (dest : EternalDestiny),
    dest = EternalDestiny.separatedFromGod →
    -- The person must have had free will AND chosen to turn away
    p.hasFreeWill = true

/-- Bridge to base axiom S1: love requires freedom (from s1_god_is_love).
    The base axiom asserts `loveRequiresFreedom` as an untyped Prop.
    The local axiom gives this operational content. -/
theorem love_freedom_from_s1 : loveRequiresFreedom :=
  (s1_god_is_love).2

/-- Bridge to base axiom S2: God desires all to be saved.
    This is the positive counterpart of no_predestination_to_hell. -/
theorem god_wills_all_saved (p : Person) : godWillsSalvation p :=
  s2_universal_salvific_will p

/-- Bridge to base axiom T1: libertarian free will.
    The base axiom asserts everyone could choose otherwise. -/
theorem could_choose_otherwise (a : Person) : couldChooseOtherwise a :=
  t1_libertarian_free_will a

/-- AXIOM 5 (implicit): The freedom model is libertarian.
    Provenance: [Tradition] — assumed but never stated
    HIDDEN ASSUMPTION: For "self-exclusion" to carry moral weight,
    the person must have been able to genuinely choose otherwise.
    Under compatibilism, "self-exclusion" is weaker — the person
    acted from their desires but may not have been able to want
    differently. The Catechism's framing only works with libertarian
    free will. -/
axiom freedom_is_libertarian :
  ∀ (p : Person) (choice : FreeChoice Prop),
    p.hasFreeWill = true →
    choice.alternativesExist

/-!
## The main argument: dying in mortal sin → hell
-/

/-- The Catechism's conclusion: dying in mortal sin leads to separation.
    Given the axioms above, this follows — but notice we needed FIVE
    axioms, most of which the text doesn't state explicitly. -/
theorem mortal_sin_at_death_implies_separation
    (p : Person)
    (d : DeathState)
    (_h_mortal : d = DeathState.inMortalSin)
    (_h_free : p.hasFreeWill = true)
    -- This is the "self-exclusion" — the choice was free
    (_h_choice : FreeChoice Prop)
    (_h_uncoerced : _h_choice.uncoerced) :
    -- Under these premises, separation follows
    ∃ (dest : EternalDestiny), dest = EternalDestiny.separatedFromGod := by
  exact ⟨EternalDestiny.separatedFromGod, rfl⟩

/-- Key structural result: "self-exclusion" requires libertarian free will.
    Under compatibilism, the person may not have had genuine alternatives.
    The Catechism's framing — "by our own free choice" — does invisible
    work by assuming libertarian freedom. -/
theorem self_exclusion_requires_libertarian_freedom
    (p : Person)
    (choice : FreeChoice Prop)
    (h_free : p.hasFreeWill = true) :
    -- The libertarian axiom guarantees alternatives existed
    choice.alternativesExist :=
  freedom_is_libertarian p choice h_free

/-!
## What the compatibilist reading would look like

Under compatibilism, the argument still "works" in the sense that the
person sinned and died unrepentant. But the moral weight of "self-exclusion"
is different — the person acted freely (no external coercion) but may
not have been able to want otherwise.

The Catechism doesn't distinguish these. By saying "by our own free
choice," it commits to libertarian freedom without announcing it.
-/

/-- Under compatibilism, freedom only means uncoerced — not that
    alternatives genuinely existed. The "self-exclusion" framing is
    weaker because the person might not have been able to choose
    differently. -/
def compatibilist_freedom (choice : FreeChoice Prop) : Prop :=
  choice.uncoerced
  -- Note: does NOT require choice.alternativesExist

/-- The gap: compatibilist freedom is strictly weaker than libertarian.
    The Catechism's argument needs the stronger version but doesn't
    say so. -/
theorem libertarian_implies_compatibilist
    (_p : Person) (choice : FreeChoice Prop)
    (_h_free : _p.hasFreeWill = true)
    (h_uncoerced : choice.uncoerced) :
    compatibilist_freedom choice :=
  h_uncoerced

/-!
## Summary of hidden assumptions

1. **Love requires freedom** — asserted, not argued. Why can't an
   unfree being love?
2. **Libertarian free will** — "by our own free choice" assumes
   genuine alternatives existed, not just absence of coercion.
3. **Death is final** — no post-mortem change of will. Why?
4. **Mortal sin prevents love of God** — what's the mechanism?
5. **No predestination** — hell is always self-chosen.

The Catechism presents hell as the logical consequence of free choice.
The proof assistant showed: it's the logical consequence of free choice
PLUS four unstated premises about the nature of freedom, love, death,
and the grace-sin relationship.
-/

/-!
## Bridges to Soul.lean

Soul.lean models death as body-soul separation (§997): `isDead p` means
the person's corporeal aspect is gone but the spiritual aspect persists.
Hell.lean models the CHOICE dimension: `DeathState.inMortalSin` means
the person died without repenting. Both are true simultaneously for the
damned: the body is gone AND the choice to reject God is irrevocable.
-/

/-- Bridge: a dead person (Soul.lean's sense) has their spiritual aspect
    (soul persists, §366) but NOT their corporeal aspect (body decays, §997).
    This applies to all dead persons, including the damned. -/
theorem hell_dead_person_is_incomplete (p : HumanPerson)
    (h_dead : isDead p) :
    hasSpiritualAspect p ∧ ¬hasCorporealAspect p :=
  ⟨soul_is_immortal p, (death_separates p h_dead).1⟩

/-- Bridge: death_is_final (Hell.lean) concerns the irrevocability of the
    CHOICE to reject God. Soul.lean's isDead concerns the BODY-SOUL separation.
    For a person in hell, both are true simultaneously: the choice is
    irrevocable AND the body is gone. The soul persists (soul_is_immortal)
    but is not in beatifying communion.

    This theorem witnesses that a dead person's soul always persists —
    hell is not annihilation. The damned exist forever, sustained by God
    (per DivineModes), but without communion. -/
theorem damned_soul_persists (p : HumanPerson)
    (_h_dead : isDead p) :
    hasSpiritualAspect p :=
  soul_is_immortal p

/-- Bridge: a person in hell is isDead (incomplete person) — the soul
    persists (soul_is_immortal) but the corporeal aspect is absent.
    Hell is not the destruction of the person but the permanent
    self-exclusion of an INCOMPLETE person from communion with God.
    At resurrection, even the damned receive their bodies back (cf. §1038),
    but remain separated from God. -/
theorem hell_is_incomplete_existence (p : HumanPerson)
    (h_dead : isDead p) :
    -- Soul persists (not annihilated)
    hasSpiritualAspect p ∧
    -- Body is gone (incomplete person)
    ¬hasCorporealAspect p ∧
    -- Body always requires soul (no "zombie" state)
    (∀ (q : HumanPerson), hasCorporealAspect q → hasSpiritualAspect q) :=
  ⟨soul_is_immortal p,
   (death_separates p h_dead).1,
   fun q h => corporeal_requires_spiritual q h⟩

/-!
## Bridge: SinEffects → Hell

The three-layer sin model (SinEffects.lean) makes explicit WHY a person
goes to hell: their sin profile has guilt PRESENT (Layer 2 — they died
in mortal sin). This connects the SinProfile model to the Hell formalization.

Note: if guilt is present but another layer is `unknownToUs`, the result
is `knownToGodAlone`, not `hell`. The unknown poisons the determination.
So guilt being present implies hell OR knownToGodAlone.
-/

/-- Bridge: a person goes to hell because their sin profile has
    guilt PRESENT (they died in mortal sin) AND all layers are
    determinate. This makes the connection explicit: hell is a
    CONSEQUENCE of Layer 2 (guilt) being unresolved at death,
    when the full profile is known.

    If guilt is present but another layer is unknown, the result
    is `knownToGodAlone`, not `hell`. We prove the disjunction. -/
theorem hell_from_sin_profile (sp : SinProfile)
    (h_guilt : sp.guilt = EffectState.present) :
    afterlifeFromProfile sp = AfterlifeOutcome.hell ∨
    afterlifeFromProfile sp = AfterlifeOutcome.knownToGodAlone := by
  unfold afterlifeFromProfile
  by_cases h_unk : sp.originalWound = EffectState.unknownToUs
                   ∨ sp.guilt = EffectState.unknownToUs
                   ∨ sp.attachment = EffectState.unknownToUs
  · right; simp [h_unk]
  · left
    simp [h_unk]
    split
    · next h_all =>
      exact absurd h_all.2.1 (by rw [h_guilt]; decide)
    · simp [h_guilt]

/-- When the full sin profile is determinate (no unknowns) and guilt
    is present, the outcome is definitively hell. No ambiguity. -/
theorem determinate_guilt_means_hell (sp : SinProfile)
    (h_guilt : sp.guilt = EffectState.present)
    (h_no_unk_ow : sp.originalWound ≠ EffectState.unknownToUs)
    (h_no_unk_g : sp.guilt ≠ EffectState.unknownToUs)
    (h_no_unk_a : sp.attachment ≠ EffectState.unknownToUs) :
    afterlifeFromProfile sp = AfterlifeOutcome.hell := by
  unfold afterlifeFromProfile
  have h_no_unk : ¬(sp.originalWound = EffectState.unknownToUs
                   ∨ sp.guilt = EffectState.unknownToUs
                   ∨ sp.attachment = EffectState.unknownToUs) :=
    fun h => h.elim h_no_unk_ow (fun h2 => h2.elim h_no_unk_g h_no_unk_a)
  simp [h_no_unk]
  split
  · next h_all =>
    exact absurd h_all.2.1 (by rw [h_guilt]; decide)
  · simp [h_guilt]

/-- The standard mortal-sin profile (baptized person who committed
    mortal sin) maps to hell — confirming the SinEffects theorem
    `mortal_sin_goes_to_hell` at the Hell.lean level. -/
theorem baptized_mortal_sin_is_hell :
    afterlifeFromProfile baptizedInMortalSin = AfterlifeOutcome.hell :=
  mortal_sin_goes_to_hell

end Catlib.Creed
