import Catlib.Foundations
import Catlib.Creed.Soul

/-!
# CCC §1030-1032: Purgatory as Post-Mortem Purification

## The Catechism claims

"All who die in God's grace and friendship, but still imperfectly purified,
are indeed assured of their eternal salvation; but after death they undergo
purification, so as to achieve the holiness necessary to enter the joy of
heaven." (§1030)

"The Church gives the name Purgatory to this final purification." (§1031)

"From the beginning the Church has honored the memory of the dead and offered
prayers in suffrage for them, above all the Eucharistic sacrifice, so that,
thus purified, they may attain the beatific vision of God." (§1032)

## The argument chain

1. Holiness is required for heaven (nothing impure can enter — Rev 21:27)
2. Some die in God's grace but imperfectly purified
3. These persons undergo a purification AFTER death
4. This purification is temporary (not eternal like hell)
5. The purified WILL reach heaven (assured salvation)
6. The living can help the dead through prayer (intercession crosses death)

## Prediction

I expect this to **expose a deep tension** with Hell.lean. Hell says death
is final (axiom 3: `death_is_final` — no post-mortem change of state).
Purgatory says post-mortem purification happens. These look contradictory.

The Catholic resolution: death is final for the CHOICE (you cannot switch
from rejecting God to accepting Him), but not final for PURIFICATION
(you can be cleaned up after choosing God). This distinction is not made
explicit in the Catechism — it is a hidden structural assumption.

## Findings

- **Prediction vs. reality**: Confirmed — tension with Hell.lean is real and
  requires explicit resolution. The `death_is_final` axiom from Hell.lean
  must be reinterpreted as finality of CHOICE, not finality of all change.
- **Hidden assumptions**:
  1. Post-mortem change is possible (tension with death-is-final!)
  2. Temporal process after death (how does time work for disembodied souls?)
  3. Prayer efficacy crosses the life/death boundary
  4. Holiness is a SPECTRUM, not binary saved/damned
  5. The strongest Scripture (2 Macc 12:46) requires the 73-book canon
- **Denominational scope**: Catholic only. Protestants reject purgatory.
  Orthodox have a related but distinct concept (toll houses / aerial realm).
- **Assessment**: Tier 3 — multiple hidden premises, genuine tension with
  another formalized doctrine (Hell), and critical dependency on L4 (canon).
-/

namespace Catlib.Creed

open Catlib

/-!
## Core types for purgatory
-/

/-- The degree of holiness a person possesses.
    HIDDEN ASSUMPTION: Holiness is a spectrum, not binary.
    The Catechism never argues for this — it assumes it. If holiness
    were binary (holy / not-holy), purgatory would be unnecessary:
    you either have it or you don't. Purgatory requires DEGREES. -/
opaque HolinessDegree : Type

/-- Ordering on holiness degrees — some are higher than others. -/
opaque holinessLt : HolinessDegree → HolinessDegree → Prop

/-- The threshold of holiness required for heaven. -/
axiom heavenThreshold : HolinessDegree

/-- The holiness degree of a given person. -/
axiom personHoliness : Person → HolinessDegree

/-- Whether a person died in God's grace (chose God, even if imperfectly purified). -/
opaque diedInGrace : Person → Prop

/-- Whether a person died in mortal sin (chose against God). -/
opaque diedInMortalSin : Person → Prop

/-- Whether a person is fully purified (holiness meets the threshold). -/
opaque fullyPurified : Person → Prop

/-- Whether a person is in the state of purgatorial purification. -/
opaque inPurgatory : Person → Prop

/-- Whether a living person prays for a dead person. -/
opaque praysFor : Person → Person → Prop

/-- Whether prayer aids the purification of a person. -/
opaque prayerAidsPurification : Person → Prop

/-- Whether a person has attained the beatific vision (heaven). -/
opaque attainsBeatificVision : Person → Prop

/-!
## Axioms: CCC §1030-1032

Each axiom is tagged with its Catechism source and any hidden assumptions.
-/

/-- AXIOM 1 (§1030 + Rev 21:27): Nothing impure can enter heaven.
    Holiness at or above the threshold is required for the beatific vision.
    Provenance: [Scripture] Rev 21:27 — "Nothing unclean will enter it."
    Also: Heb 12:14 — "without holiness no one will see the Lord."
    DENOMINATIONAL: Ecumenical — Protestants agree holiness is required
    for heaven. They disagree about how it is achieved. -/
axiom holiness_required_for_heaven :
  ∀ (p : Person), attainsBeatificVision p → fullyPurified p

/-- Provenance tag for axiom 1. -/
def purg_ax1_provenance : Provenance := Provenance.scripture "Rev 21:27; Heb 12:14"
def purg_ax1_tag : DenominationalTag := ecumenical

/-- AXIOM 2 (§1030): A middle state exists. Some die in grace but
    imperfectly purified — they chose God, but still carry impurity.
    Provenance: [Definition] CCC §1030
    HIDDEN ASSUMPTION: "Imperfectly purified" presupposes that holiness
    is a spectrum, not binary. If holiness were binary, you'd either
    be purified or not — no middle ground.
    DENOMINATIONAL: Catholic only. Protestants hold that Christ's
    righteousness covers the believer completely at justification
    (simul justus et peccator), so no further purification is needed. -/
axiom imperfect_purification_exists :
  ∃ (p : Person), diedInGrace p ∧ ¬fullyPurified p

/-- Provenance tag for axiom 2. -/
def purg_ax2_provenance : Provenance := Provenance.definition 1030
def purg_ax2_tag : DenominationalTag := catholicOnly

/-- AXIOM 3 (§1030): Post-mortem purification occurs.
    Those who die in grace but imperfectly purified undergo purification
    after death to achieve the holiness necessary for heaven.
    Provenance: [Definition] CCC §1030
    HIDDEN ASSUMPTION 1: Post-mortem change is possible. This is in
    TENSION with Hell.lean's `death_is_final` axiom!
    HIDDEN ASSUMPTION 2: There is a temporal process after death.
    How does time work for a disembodied soul? The Catechism never
    addresses this. -/
axiom post_mortem_purification :
  ∀ (p : Person), diedInGrace p → ¬fullyPurified p → inPurgatory p

/-- Provenance tag for axiom 3. -/
def purg_ax3_provenance : Provenance := Provenance.definition 1030
def purg_ax3_tag : DenominationalTag := catholicOnly

/-- AXIOM 4 (§1030): Purgatory is temporary — the purified WILL reach heaven.
    Unlike hell, which is permanent self-exclusion, purgatory has an end.
    "They are indeed assured of their eternal salvation."
    Provenance: [Definition] CCC §1030
    DENOMINATIONAL: Catholic only. This is what distinguishes purgatory
    from hell — it is a state of ASSURED salvation, not uncertainty. -/
axiom purgatory_leads_to_heaven :
  ∀ (p : Person), inPurgatory p → attainsBeatificVision p

/-- Provenance tag for axiom 4. -/
def purg_ax4_provenance : Provenance := Provenance.definition 1030
def purg_ax4_tag : DenominationalTag := catholicOnly

/-- AXIOM 5 (§1032): Prayer for the dead is efficacious.
    The living can aid the purification of the dead through prayer,
    especially the Eucharistic sacrifice.
    Provenance: [Scripture] 2 Macc 12:46 — "It is a holy and wholesome
    thought to pray for the dead, that they may be loosed from sins."
    HIDDEN ASSUMPTION: Prayer efficacy crosses the life/death boundary.
    The Catechism assumes this without argument.
    CRITICAL DEPENDENCY: 2 Macc 12:46 is in a Deuterocanonical book.
    Under Luther's L4 (66-book canon), this verse is not Scripture.
    The scriptural case for prayer for the dead collapses under L4. -/
axiom prayer_aids_dead :
  ∀ (living dead : Person), praysFor living dead → inPurgatory dead →
    prayerAidsPurification dead

/-- Provenance tag for axiom 5. -/
def purg_ax5_provenance : Provenance := Provenance.scripture "2 Macc 12:46"
def purg_ax5_tag : DenominationalTag := catholicOnly

/-- AXIOM 6: Those who die in mortal sin do NOT enter purgatory.
    Purgatory is only for those who die in God's grace.
    Provenance: [Definition] CCC §1033 (from Hell.lean's scope)
    This axiom distinguishes purgatory from hell: the person in
    purgatory CHOSE God. The person in hell REJECTED God. -/
axiom mortal_sin_excludes_purgatory :
  ∀ (p : Person), diedInMortalSin p → ¬inPurgatory p

/-- Provenance tag for axiom 6. -/
def purg_ax6_provenance : Provenance := Provenance.definition 1033
def purg_ax6_tag : DenominationalTag := catholicOnly

/-!
## Key theorems
-/

/-- AXIOM 7: Those who die in grace AND are already fully purified go
    directly to heaven (no purgatory needed).
    Provenance: [Definition] CCC §1023
    STRUCTURAL NOTE: This axiom is REQUIRED to prove that dying in grace
    guarantees heaven. Without it, we can only show the imperfectly-purified
    reach heaven (via purgatory). The already-purified case needs its own
    axiom — the Catechism assumes this without stating it as a separate claim. -/
axiom purified_in_grace_sees_god :
  ∀ (p : Person), diedInGrace p → fullyPurified p → attainsBeatificVision p

/-- Provenance tag for axiom 7. -/
def purg_ax7_provenance : Provenance := Provenance.definition 1023
def purg_ax7_tag : DenominationalTag := ecumenical

/-- THEOREM 1: Everyone in purgatory will see God.
    This follows directly from axiom 4: purgatory leads to heaven.
    The important structural point: purgatory is a state of HOPE, not fear.
    The outcome is certain. -/
theorem purgatory_guarantees_vision :
    ∀ (p : Person), inPurgatory p → attainsBeatificVision p :=
  fun (p : Person) (h : inPurgatory p) => purgatory_leads_to_heaven p h

/-- THEOREM 2: Purgatory results in full purification.
    If someone is in purgatory, they will attain the beatific vision.
    And the beatific vision requires full purification (axiom 1).
    So purgatory results in full purification. -/
theorem purgatory_achieves_holiness :
    ∀ (p : Person), inPurgatory p → fullyPurified p :=
  fun (p : Person) (h : inPurgatory p) =>
    holiness_required_for_heaven p (purgatory_leads_to_heaven p h)

/-- THEOREM 3: Dying in grace guarantees eventual heaven.
    Either you are already fully purified (go directly to heaven via axiom 7),
    or you are not (go to purgatory via axiom 3, then to heaven via axiom 4).
    Either way, if you die in grace, you will see God.
    This is the core ASSURANCE claim of purgatory doctrine. -/
theorem grace_at_death_guarantees_heaven :
    ∀ (p : Person), diedInGrace p → attainsBeatificVision p :=
  fun (p : Person) (hg : diedInGrace p) =>
    Classical.byCases
      (fun (hp : fullyPurified p) =>
        purified_in_grace_sees_god p hg hp)
      (fun (hnp : ¬fullyPurified p) =>
        purgatory_leads_to_heaven p (post_mortem_purification p hg hnp))

/-!
## The tension with Hell.lean: death_is_final

Hell.lean declares:

```
axiom death_is_final :
  ∀ (d : DeathState),
    d = DeathState.inMortalSin →
    ¬(∃ (d' : DeathState), d' = DeathState.repentant)
```

At first glance, this contradicts purgatory. If death is final and no
post-mortem change is possible, how can post-mortem purification occur?

The Catholic resolution requires a DISTINCTION that neither §1033 nor
§1030 makes explicit:

- **Death is final for CHOICE**: You cannot switch from rejecting God
  to accepting Him (hell → purgatory is impossible), nor from accepting
  God to rejecting Him (purgatory → hell is impossible).

- **Death is NOT final for PURIFICATION**: You can be cleaned up after
  choosing God. Purification is not a change of will — it is the
  completion of a will already oriented toward God.

This distinction is theologically sophisticated but is a HIDDEN
ASSUMPTION. The Catechism never states it this way. It simply asserts
both "death is final" (§1033) and "post-mortem purification occurs"
(§1030) without acknowledging the apparent tension.

We formalize the resolution below.
-/

/-- The resolution: death is final for CHOICE, not for all change.
    A person who died in grace cannot later be in mortal sin.
    A person who died in mortal sin cannot later be in grace.
    But a person who died in grace CAN be further purified.
    Provenance: [Tradition] — theological inference, not stated in CCC.
    HIDDEN ASSUMPTION: This distinction is never made explicit in the
    Catechism. It is the structural requirement for both Hell and
    Purgatory to coexist without contradiction. -/
axiom death_finalizes_choice_not_state :
  ∀ (p : Person), diedInGrace p → ¬diedInMortalSin p

/-- Provenance tag for the resolution axiom. -/
def resolution_provenance : Provenance := Provenance.tradition "theological inference"
def resolution_tag : DenominationalTag := catholicOnly

/-- THEOREM 4: The hell-purgatory boundary is absolute.
    No one in hell can reach purgatory. No one in purgatory can fall to hell.
    The choice made before death is permanent; only purification continues. -/
theorem hell_purgatory_boundary :
    ∀ (p : Person), diedInMortalSin p → ¬inPurgatory p :=
  fun (p : Person) (h : diedInMortalSin p) =>
    mortal_sin_excludes_purgatory p h

/-- THEOREM 5: Grace at death and mortal sin at death are mutually exclusive.
    This is the structural foundation: the choice is binary and final,
    even though holiness is a spectrum. -/
theorem grace_and_mortal_sin_exclusive :
    ∀ (p : Person), diedInGrace p → ¬diedInMortalSin p :=
  fun (p : Person) (h : diedInGrace p) =>
    death_finalizes_choice_not_state p h

/-!
## The canon dependency: purgatory under different Bibles

The strongest scriptural support for purgatory is 2 Maccabees 12:46:
"It is a holy and wholesome thought to pray for the dead, that they
may be loosed from sins."

This verse is in a Deuterocanonical book — one of the seven books
Luther removed from the Old Testament. Under Luther's L4 axiom
(the canon is determinable without Church authority → 66 books),
2 Maccabees is not Scripture.

Under the 66-book canon, the scriptural case for purgatory relies on:
- 1 Cor 3:13-15: "each one's work will become manifest... the fire
  will test what sort of work each one has done... he himself will
  be saved, but only as through fire." Catholics read this as
  purgatorial fire; Protestants read it as a metaphor for judgment.
- Mt 12:32: "whoever speaks against the Holy Spirit will not be
  forgiven, either in this age or in the age to come." Catholics
  argue the phrase "or in the age to come" implies SOME sins ARE
  forgiven in the age to come — which requires purgatory. Protestants
  read this as emphasis (not even in the next age), not implication.

The exegetical case is significantly weaker without 2 Maccabees.
The doctrine of purgatory thus has a CRITICAL DEPENDENCY on L4
(which Bible you use). This is one of the clearest examples of
how the canon question (L4) cascades into specific doctrines.
-/

/-- The scriptural evidence under the 73-book (Catholic) canon. -/
def purgatory_scripture_73 : List String :=
  [ "2 Macc 12:46 — 'holy and wholesome thought to pray for the dead'"
  , "1 Cor 3:13-15 — 'saved, but only as through fire'"
  , "Mt 12:32 — 'not forgiven in this age or the age to come'"
  , "Rev 21:27 — 'nothing unclean will enter'"
  ]

/-- The scriptural evidence under the 66-book (Protestant) canon.
    Note: 2 Maccabees is gone. The remaining passages are subject
    to alternative exegesis. -/
def purgatory_scripture_66 : List String :=
  [ "1 Cor 3:13-15 — 'saved, but only as through fire' (contested reading)"
  , "Mt 12:32 — 'not forgiven in this age or the age to come' (contested reading)"
  , "Rev 21:27 — 'nothing unclean will enter' (shared, but doesn't entail purgatory)"
  ]

/-!
## Denominational summary

| Tradition  | Accepts purgatory? | Notes |
|------------|-------------------|-------|
| Catholic   | Yes               | Defined doctrine (CCC §1030-1032, Council of Florence, Council of Trent) |
| Lutheran   | No                | Rejected as unscriptural (under 66-book canon) |
| Reformed   | No                | Rejected; Christ's atonement is complete |
| Orthodox   | Partially          | Similar concept (aerial toll houses, prayers for the dead) but reject the Latin formulation |

## Summary of hidden assumptions

1. **Holiness is a spectrum** — not binary saved/damned. Without degrees
   of holiness, purgatory is unnecessary.
2. **Post-mortem change is possible** — in tension with `death_is_final`
   from Hell.lean. Resolved by distinguishing choice-finality from
   state-finality, but this distinction is never made explicit.
3. **Temporal process after death** — purification takes "time" in some
   sense. How does time work for a disembodied soul? Unanswered.
4. **Prayer crosses the death boundary** — the living can help the dead.
   This is a strong metaphysical claim, assumed without argument.
5. **The 73-book canon** — the strongest scriptural support requires
   2 Maccabees. Under the 66-book canon, the case is significantly weaker.

The most important finding: purgatory and hell BOTH exist in the Catholic
system, but they require a distinction (choice-finality vs. state-finality)
that the Catechism never makes explicit. The proof assistant forced this
distinction to the surface.
-/

/-!
## Bridges to Soul.lean

Soul.lean models the person as an opaque indivisible entity with two
observable aspects: corporeal and spiritual. Death separates them (§997).
Purgatory happens to the SOUL (spiritual aspect) while the corporeal
aspect awaits resurrection.

The key compatibility: Soul.lean's `isDead` says the body is gone.
Purgatory says the soul can still be PURIFIED after death. These are
compatible because death separates body from soul, but the soul (which
persists per `soul_is_immortal`) can still change STATE (purification).
The CHOICE (to accept God) is final; the STATE (purity level) is not.
-/

/-- Bridge: a person in purgatory is isDead — their soul persists but
    body is gone. Purification happens to the SOUL (spiritual aspect)
    while the corporeal aspect awaits resurrection.
    This connects Soul.lean's death model to Purgatory's purification:
    death removes the body, but the soul that remains can still be purified. -/
theorem purgatory_person_is_dead_and_spiritual (p : HumanPerson)
    (_h_dead : isDead p) :
    hasSpiritualAspect p :=
  soul_is_immortal p

/-- Bridge: Soul.lean says isDead → ¬hasCorporealAspect (body gone).
    Purgatory says the soul can still be PURIFIED after death.
    This theorem witnesses both facts simultaneously: the body is gone
    AND the soul persists for purification.

    death_finalizes_choice_not_state (Purgatory axiom) says the choice
    to accept God is irrevocable. Soul.lean's death_separates says the
    body decays. Together: the person in purgatory has an irrevocable
    orientation toward God (choice is final) AND lacks a body (death
    separated it), but the soul can still be purified (state is not final). -/
theorem purgatory_death_compatible_with_purification (p : HumanPerson)
    (h_dead : isDead p) :
    -- Soul persists (can be purified)
    hasSpiritualAspect p ∧
    -- Body is gone (death separated it)
    ¬hasCorporealAspect p :=
  ⟨soul_is_immortal p, (death_separates p h_dead).1⟩

/-- Bridge: after purification, the soul awaits resurrection (§997).
    Purgatory → heaven (soul in communion) → resurrection (body restored).
    The person becomes complete again only at resurrection.

    A person who has completed purgatory and attained the beatific vision
    is still isDead (incomplete) until resurrection. The risen person is
    the real endpoint: body + soul reunited in full communion. This is
    why the Creed says "I look for the resurrection of the dead" — even
    saints in heaven are incomplete without their bodies. -/
theorem purified_soul_awaits_resurrection (p : HumanPerson)
    (h_risen : isRisen p) :
    hasCorporealAspect p ∧ hasSpiritualAspect p :=
  resurrection_reunites p h_risen

/-- Bridge: the incompleteness of a person in purgatory. They have their
    spiritual aspect (soul persists, is being purified) but lack their
    corporeal aspect. Even after purification completes and they enter
    heaven, they remain incomplete until the resurrection. -/
theorem purgatory_person_is_incomplete (p : HumanPerson)
    (h_dead : isDead p) :
    ¬hasCorporealAspect p :=
  (death_separates p h_dead).1

/-!
## Bridge: SinEffects → Purgatory

The three-layer sin model (SinEffects.lean) makes explicit WHY a person
goes to purgatory: their sin profile has guilt REMOVED (Layer 2 cleared
by Reconciliation) but attachment PRESENT (Layer 3 remains). This is
the CCC's §1030 made formal: "imperfectly purified" = Layer 3 unresolved.

The connection: afterReconciliation (SinEffects) maps to purgatory,
confirming `attachments_go_to_purgatory` from SinEffects.lean.
-/

/-- Bridge: a person goes to purgatory because their sin profile
    has guilt REMOVED but attachment PRESENT. Layer 2 cleared,
    Layer 3 remains. This is the CCC's §1030 made formal.

    Directly reuses `attachments_go_to_purgatory` from SinEffects. -/
theorem purgatory_from_sin_profile :
    afterlifeFromProfile afterReconciliation = AfterlifeOutcome.purgatory :=
  attachments_go_to_purgatory

/-- The fully purified go to heaven, not purgatory. If all three
    layers are removed, no purification is needed.
    Bridges SinEffects' `purified_go_to_heaven` into the purgatory context. -/
theorem fully_purified_skips_purgatory :
    afterlifeFromProfile Catlib.fullyPurified = AfterlifeOutcome.heaven :=
  purified_go_to_heaven

/-- When the sin profile is determinate, has no guilt, but has
    attachment, the outcome is purgatory. This is the general form
    of the purgatory condition. -/
theorem attachment_without_guilt_means_purgatory (sp : SinProfile)
    (h_ow : sp.originalWound ≠ EffectState.unknownToUs)
    (h_g : sp.guilt ≠ EffectState.unknownToUs)
    (h_a : sp.attachment ≠ EffectState.unknownToUs)
    (h_no_guilt : sp.guilt = EffectState.removed)
    (h_attach : sp.attachment = EffectState.present) :
    afterlifeFromProfile sp = AfterlifeOutcome.purgatory := by
  unfold afterlifeFromProfile
  have h_no_unk : ¬(sp.originalWound = EffectState.unknownToUs
                   ∨ sp.guilt = EffectState.unknownToUs
                   ∨ sp.attachment = EffectState.unknownToUs) :=
    fun h => h.elim h_ow (fun h2 => h2.elim h_g h_a)
  simp [h_no_unk]
  split
  · next h_all =>
    exact absurd h_all.2.2 (by rw [h_attach]; decide)
  · split
    · next h_guilt_present =>
      exact absurd h_guilt_present (by rw [h_no_guilt]; decide)
    · rfl

end Catlib.Creed
