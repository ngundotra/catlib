import Catlib.Foundations
import Catlib.Creed.Christology
import Catlib.Creed.Atonement
import Catlib.Creed.OriginalSin

/-!
# CCC §456-460: Why Did God Become Man? (Cur Deus Homo)

## The CCC's central claims

The CCC gives FOUR reasons the Word became flesh (§456-460):

1. **To SAVE us** (§457): "The Word became flesh for us in order to save
   us by reconciling us with God." This connects directly to Atonement.lean's
   satisfaction theory — the Incarnation provides the divine-human mediator
   needed for adequate satisfaction.

2. **To REVEAL God's love** (§458): "The Word became flesh so that thus we
   might know God's love." The Incarnation is an act of divine self-disclosure —
   God makes His love VISIBLE in human form.

3. **To be our MODEL of holiness** (§459): "The Word became flesh to be our
   model of holiness." Christ's human life demonstrates what a rightly-ordered
   human life looks like. He is the exemplar.

4. **To make us PARTAKERS of the divine nature** (§460): "The Word became
   flesh to make us partakers of the divine nature" (2 Pet 1:4). This is
   theosis/divinization — the most startling claim: through the Incarnation,
   humans can participate in the divine life itself.

## The key theological question: Necessary or Fitting?

**Anselm** (Cur Deus Homo, c. 1098): The Incarnation is strictly NECESSARY.
Only a God-man can provide adequate satisfaction. There is no other mode of
salvation. God could not simply forgive by decree because the order of justice
requires repair, and only infinite dignity can provide proportional satisfaction.
This is already partially formalized in Atonement.lean (`bare_pardon_insufficient`,
`adequate_satisfaction_requires_divine`, `adequate_satisfaction_requires_human`).

**Aquinas** (ST III, q.1, a.1-2): The Incarnation is FITTING but not strictly
necessary. God COULD have saved us another way — by bare pardon, or by
appointing a mere creature empowered with grace. But the Incarnation was the
MOST FITTING way because it simultaneously accomplishes all four purposes
(salvation, revelation, exemplarity, divinization) in the most harmonious manner.

**CCC** (§461): Leans toward Aquinas — uses "fitting" language rather than
strict necessity. The CCC acknowledges the Incarnation's unique appropriateness
without claiming God was logically constrained to this exact method.

## Hidden assumptions

1. **The four purposes are genuinely distinct.** The CCC lists them as separate
   reasons (§457-460). We treat this as a doctrinal claim, not a modeling choice.
   However, one could argue they are different aspects of a single purpose.

2. **Theosis requires Incarnation.** The claim that humans can become "partakers
   of the divine nature" presupposes a bridge between divine and human — and the
   CCC claims the Incarnation IS that bridge. Without it, the gap between
   infinite God and finite creature remains unbridgeable.

3. **The fittingness concept is load-bearing.** Aquinas's distinction between
   "necessary" and "fitting" does real theological work. But what "fitting"
   means precisely is an open research question (see CONTRIBUTING.md backlog).

## Modeling choices

1. We model the four purposes as four predicates on the Incarnation event,
   following the CCC's enumeration.

2. We model the Anselm vs. Aquinas positions as two distinct axioms about
   whether alternatives exist, allowing comparison.

3. We leave `isMaximallyFitting` as an opaque predicate classified as
   "research needed" — the backlog item "Define what fittingness means"
   must be resolved before this can have real content.

4. We connect to Atonement.lean's existing `incarnation_necessary_for_atonement`
   to show WHY the mediator was needed at all.
-/

set_option autoImplicit false

namespace Catlib.Creed.CurDeusHomo

open Catlib
open Catlib.Creed.Christology
open Catlib.Creed.Atonement
open Catlib.Creed.OriginalSin

-- ============================================================================
-- § 1. Core Predicates
-- ============================================================================

/-- The Incarnation — the event of the Word becoming flesh.
    §461: "Taking up St. John's expression, 'The Word became flesh' (Jn 1:14),
    the Church calls 'Incarnation' the fact that the Son of God assumed a
    human nature in order to accomplish our salvation in it."

    STRUCTURAL OPACITY: The Incarnation is a unique, unrepeatable event.
    The CCC does not decompose it into sub-events — it treats it as a
    primitive. We model it as an opaque Prop because what matters for
    downstream reasoning is that it HAPPENED, not its internal mechanism. -/
opaque theIncarnation : Prop

/-- Whether the Incarnation accomplishes salvation — reconciliation
    with God through the divine-human mediator.
    §457: "The Word became flesh for us in order to save us by
    reconciling us with God." -/
opaque accomplishesSalvation : Prop → Prop

/-- Whether the Incarnation reveals God's love — makes divine love
    visible and knowable in human form.
    §458: "The Word became flesh so that thus we might know God's love." -/
opaque revealsGodsLove : Prop → Prop

/-- Whether the Incarnation provides a model of holiness — an
    exemplar of rightly-ordered human life.
    §459: "The Word became flesh to be our model of holiness." -/
opaque providesModelOfHoliness : Prop → Prop

/-- Whether the Incarnation enables participation in the divine nature
    (theosis/divinization).
    §460: "The Word became flesh to make us partakers of the divine
    nature" (citing 2 Pet 1:4).

    HONEST OPACITY: What "participation in the divine nature" means
    is genuinely mysterious. The CCC quotes 2 Pet 1:4 and the Church
    Fathers (Athanasius, Irenaeus) but does not give a philosophical
    definition. The Orthodox tradition calls this "theosis"; the
    Catholic tradition calls it "divinization." Both agree it is REAL
    participation, not merely metaphorical — but its mechanism is
    beyond human comprehension. -/
opaque enablesTheosis : Prop → Prop

/-- Whether a mode of salvation is an alternative to the Incarnation —
    i.e., a hypothetical way God COULD have accomplished salvation
    without the Word becoming flesh.
    This is where Anselm and Aquinas disagree: Anselm says no such
    alternative exists; Aquinas says alternatives exist but are less fitting. -/
opaque isAlternativeToIncarnation : Prop → Prop

/-- Whether an act or event is maximally fitting — the most harmonious,
    appropriate, and wise way to accomplish a purpose, even if not the
    ONLY possible way.

    RESEARCH NEEDED: This is the central open concept. "Fittingness"
    (*convenientia*) is a real category in Catholic theology used for
    the Incarnation (Aquinas ST III q.1), the Immaculate Conception
    (Scotus), and the Assumption. But we do not yet understand it well
    enough to formalize.

    See CONTRIBUTING.md backlog item: "Define what fittingness means."
    Three candidate definitions are under investigation:
    (1) Scotus: *potuit, decuit, fecit* — fittingness + omnipotence → actuality
    (2) Aquinas: *conveniens* — harmonious with God's wisdom, but not sufficient
        for actuality without a separate divine decree
    (3) Bonaventure: aesthetic/Platonic — beauty as participation in divine beauty

    Until resolved, this predicate stays opaque with no content. -/
opaque isMaximallyFitting : Prop → Prop

-- ============================================================================
-- § 2. Axioms: The Four Purposes of the Incarnation (§457-460)
-- ============================================================================

/-- **AXIOM 1 (CCC §457): THE INCARNATION SAVES.**
    "The Word became flesh for us in order to save us by reconciling
    us with God: 'it is he who will save his people from their sins'
    (Mt 1:21)."

    This connects to Atonement.lean: the Incarnation provides the
    divine-human mediator needed for satisfaction. The Cross (Atonement.lean)
    is the ACT of salvation; the Incarnation is the PRECONDITION — without
    a divine-human person, there is no one who can perform the act.

    Provenance: [Scripture] Mt 1:21, Jn 3:17; [Definition] CCC §457.
    Denominational scope: ECUMENICAL — all Christians affirm that the
    Incarnation is salvific. -/
axiom incarnation_saves : accomplishesSalvation theIncarnation

/-- Denominational tag: ecumenical. -/
def incarnation_saves_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "All Christians: the Incarnation is for our salvation; CCC §457, Nicene Creed" }

/-- **AXIOM 2 (CCC §458): THE INCARNATION REVEALS GOD'S LOVE.**
    "The Word became flesh so that thus we might know God's love:
    'In this the love of God was made manifest among us, that God sent
    his only Son into the world, so that we might live through him'
    (1 Jn 4:9)."

    The Incarnation is not just instrumentally salvific — it is an act
    of REVELATION. Through it, God's love becomes visible, tangible,
    knowable in human history. Without the Incarnation, God's love
    would remain inferred (from creation, providence) rather than
    directly witnessed.

    Provenance: [Scripture] 1 Jn 4:9, Jn 3:16; [Definition] CCC §458.
    Denominational scope: ECUMENICAL. -/
axiom incarnation_reveals_love : revealsGodsLove theIncarnation

/-- Denominational tag: ecumenical. -/
def incarnation_reveals_love_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "All Christians: the Incarnation reveals God's love; CCC §458, 1 Jn 4:9" }

/-- **AXIOM 3 (CCC §459): THE INCARNATION PROVIDES A MODEL.**
    "The Word became flesh to be our model of holiness: 'Take my yoke
    upon you, and learn from me' (Mt 11:29). 'I am the way, and the
    truth, and the life' (Jn 14:6)."

    Christ's human life is not accidental to salvation — it is the
    EXEMPLAR of what a healed, rightly-ordered human life looks like.
    The moral exemplar element of the atonement (Atonement.lean's
    `isMoralExemplar`) is grounded here: the Cross inspires because
    Christ's entire life, culminating in the Cross, is the model.

    Provenance: [Scripture] Mt 11:29, Jn 14:6; [Definition] CCC §459.
    Denominational scope: ECUMENICAL — all Christians hold Christ as
    the model of the moral and spiritual life. -/
axiom incarnation_models_holiness : providesModelOfHoliness theIncarnation

/-- Denominational tag: ecumenical. -/
def incarnation_models_holiness_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "All Christians: Christ is the model of holiness; CCC §459, Mt 11:29" }

/-- **AXIOM 4 (CCC §460): THE INCARNATION ENABLES THEOSIS.**
    "The Word became flesh to make us 'partakers of the divine nature'
    (2 Pet 1:4): 'For this is why the Word became man, and the Son of
    God became the Son of man: so that man, by entering into communion
    with the Word and thus receiving divine sonship, might become a son
    of God.' (St. Irenaeus)"

    This is the most radical of the four purposes. The Incarnation does
    not just repair a broken relationship — it elevates human nature to
    participation in the divine life itself. The patristic formula:
    "God became man so that man might become God" (Athanasius, De Inc. 54).

    This is distinct from salvation (purpose 1): salvation RESTORES what
    was lost; theosis ELEVATES beyond what was natural. The Incarnation
    accomplishes both.

    Provenance: [Scripture] 2 Pet 1:4; [Tradition] Irenaeus (Adv. Haer.
    III.19.1), Athanasius (De Inc. 54); [Definition] CCC §460.
    Denominational scope: ECUMENICAL in broad terms (all Christians
    affirm some form of union with God). The specific language of
    "divinization" or "theosis" is stronger in Catholic and Orthodox
    traditions. Protestant traditions typically prefer "union with Christ"
    or "sanctification" language. -/
axiom incarnation_enables_theosis : enablesTheosis theIncarnation

/-- Denominational tag: ecumenical with qualification. -/
def incarnation_enables_theosis_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "All: union with God through Incarnation. Catholic/Orthodox: theosis/divinization. Protestant: sanctification/union with Christ. CCC §460" }

-- ============================================================================
-- § 3. Axioms: The Necessity/Fittingness Question
-- ============================================================================

/-- **AXIOM 5 (Aquinas ST III q.1 a.2; CCC §461):
    THE INCARNATION IS MAXIMALLY FITTING.**
    The CCC, following Aquinas, presents the Incarnation as maximally
    fitting — the most appropriate, wise, and harmonious way to
    accomplish all four purposes — rather than as strictly logically
    necessary.

    §461 takes up Heb 10:5-7 ("a body you prepared for me") in the
    context of the Son's free acceptance of the Father's plan. The
    language is of WILL and WISDOM, not logical compulsion.

    Aquinas (ST III, q.1, a.2): "A thing is said to be necessary for
    a certain end in two ways: first, when the end cannot be without it
    (e.g., food for life); secondly, when the end is attained better
    and more conveniently through it. In the first way it was not
    necessary that God should become incarnate... But in the second way
    it was necessary for the restoration of human nature."

    MODELING CHOICE: We follow the CCC/Aquinas rather than Anselm here,
    since the CCC is our primary source. The Anselmian position is
    modeled as a separate axiom for comparison.

    Provenance: [Philosophy] Aquinas ST III q.1 a.2; [Definition]
    CCC §461, Heb 10:5-7.
    Denominational scope: CATHOLIC — the specific "fittingness" framework
    is Thomistic. Protestants typically assert necessity without
    distinguishing degrees. -/
axiom incarnation_maximally_fitting :
  isMaximallyFitting theIncarnation

/-- Denominational tag: Catholic for the fittingness framework. -/
def incarnation_maximally_fitting_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Catholic/Thomistic: the Incarnation is maximally fitting; Aquinas ST III q.1 a.2; CCC §461" }

/-- **AXIOM 6 (CCC §461 / Aquinas ST III q.1 a.2):
    ALTERNATIVES TO THE INCARNATION ARE CONCEIVABLE (Thomistic position).**
    Aquinas holds that God COULD have saved humanity another way —
    by bare pardon, by appointing an empowered creature, or by some
    means beyond our understanding. The Incarnation was not the ONLY
    possible mode of salvation but the MOST FITTING one.

    This directly contrasts with Anselm (Cur Deus Homo), who argues
    that no alternative exists — the Incarnation is strictly necessary.

    HIDDEN ASSUMPTION: This presupposes that divine omnipotence extends
    to alternative salvific modes. A theologian who holds that the order
    of justice ABSOLUTELY requires a divine-human mediator (following
    Anselm) would deny this axiom. The CCC does not settle the dispute
    explicitly but uses language that leans toward Aquinas.

    Provenance: [Philosophy] Aquinas ST III q.1 a.2 ad 2.
    Denominational scope: CATHOLIC (Thomistic). -/
axiom thomistic_alternatives_conceivable :
  ∃ (alt : Prop), isAlternativeToIncarnation alt

/-- Denominational tag: Catholic/Thomistic. -/
def thomistic_alternatives_conceivable_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Thomistic: God could have saved another way but chose the most fitting; ST III q.1 a.2" }

-- ============================================================================
-- § 4. The Anselmian Position (for comparison)
-- ============================================================================

/-!
### The Anselmian alternative

Anselm (Cur Deus Homo, c. 1098) argues the Incarnation is STRICTLY
necessary: there is NO alternative mode of salvation. His argument:

1. Sin offends God's infinite honor/justice
2. Only infinite satisfaction can repair the offense
3. Only a divine person has infinite dignity
4. But satisfaction must come FROM humanity (humanity must participate)
5. Therefore the satisfier must be both divine AND human
6. There is no other way to get a divine-human satisfier
7. ∴ The Incarnation is strictly necessary

This overlaps with Atonement.lean's axioms 4-5 (`adequate_satisfaction_requires_divine`,
`adequate_satisfaction_requires_human`). The difference is that Anselm
ALSO claims there is no alternative, while Aquinas allows alternatives.

We model the Anselmian position as a separate axiom for denominational
comparison. Under Catholic axioms (following the CCC/Aquinas), this
axiom is NOT asserted.
-/

/-- The Anselmian strict necessity claim: there is NO alternative to
    the Incarnation. If this axiom were added, it would contradict
    `thomistic_alternatives_conceivable`.

    This is NOT asserted as an axiom in Catlib because the CCC follows
    Aquinas. It is recorded as a denominational alternative.

    NOTE: Some Protestants (especially Reformed) lean toward Anselmian
    necessity — the Cross was not merely fitting but strictly required
    by divine justice. -/
def anselmian_strict_necessity_claim : Prop :=
  ¬ ∃ (alt : Prop), isAlternativeToIncarnation alt

/-- Denominational tag for the Anselmian position. -/
def anselmian_strict_necessity_tag : DenominationalTag :=
  { acceptedBy := [Denomination.reformed],
    note := "Anselmian/Reformed: no alternative to Incarnation; Cur Deus Homo; some Calvinists hold divine justice strictly required the Cross" }

-- ============================================================================
-- § 5. Axiom: The Four Purposes Require Two Natures
-- ============================================================================

/-- **AXIOM 7 (CCC §457-460 combined with Christology):
    ALL FOUR PURPOSES REQUIRE THE INCARNATION.**
    Each of the four purposes presupposes that the Word actually became
    flesh — i.e., that a divine person took on a human nature:

    - Salvation (§457): requires a divine-human mediator (Atonement.lean)
    - Revelation (§458): requires God to be VISIBLE in human form
    - Model (§459): requires a divine person to live a HUMAN life
    - Theosis (§460): requires divine and human natures to be UNITED
      so that humans can participate in divinity through that union

    This axiom connects the four purposes to the hypostatic union:
    none of the four purposes can be accomplished without two natures
    in one person.

    Provenance: [Definition] CCC §457-460 (the four purposes);
    [Tradition] Chalcedon (the hypostatic union is the means).
    Denominational scope: ECUMENICAL — all Christians hold that Christ's
    two natures are essential to what the Incarnation accomplishes. -/
axiom purposes_require_two_natures :
  (accomplishesSalvation theIncarnation →
    christ.hasNature Nature.divine ∧ christ.hasNature Nature.human) ∧
  (revealsGodsLove theIncarnation →
    christ.hasNature Nature.divine ∧ christ.hasNature Nature.human) ∧
  (providesModelOfHoliness theIncarnation →
    christ.hasNature Nature.divine ∧ christ.hasNature Nature.human) ∧
  (enablesTheosis theIncarnation →
    christ.hasNature Nature.divine ∧ christ.hasNature Nature.human)

/-- Denominational tag: ecumenical. -/
def purposes_require_two_natures_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "All Christians: the Incarnation's purposes require Christ's two natures; CCC §457-460" }

-- ============================================================================
-- § 6. Theorems
-- ============================================================================

/-- **THEOREM: The Incarnation accomplishes all four purposes.**
    Bundles all four purpose axioms into a single conjunction.

    Uses: incarnation_saves, incarnation_reveals_love,
    incarnation_models_holiness, incarnation_enables_theosis. -/
theorem incarnation_four_purposes :
    accomplishesSalvation theIncarnation
    ∧ revealsGodsLove theIncarnation
    ∧ providesModelOfHoliness theIncarnation
    ∧ enablesTheosis theIncarnation :=
  ⟨incarnation_saves, incarnation_reveals_love,
   incarnation_models_holiness, incarnation_enables_theosis⟩

/-- **THEOREM: Each purpose individually requires Christ's two natures.**
    Since the Incarnation accomplishes all four purposes (theorem above),
    and each purpose requires two natures (axiom 7), the hypostatic
    union is required by every purpose.

    Uses: incarnation_four_purposes, purposes_require_two_natures. -/
theorem salvation_requires_two_natures :
    christ.hasNature Nature.divine ∧ christ.hasNature Nature.human :=
  purposes_require_two_natures.1 incarnation_saves

theorem revelation_requires_two_natures :
    christ.hasNature Nature.divine ∧ christ.hasNature Nature.human :=
  purposes_require_two_natures.2.1 incarnation_reveals_love

theorem model_requires_two_natures :
    christ.hasNature Nature.divine ∧ christ.hasNature Nature.human :=
  purposes_require_two_natures.2.2.1 incarnation_models_holiness

theorem theosis_requires_two_natures :
    christ.hasNature Nature.divine ∧ christ.hasNature Nature.human :=
  purposes_require_two_natures.2.2.2 incarnation_enables_theosis

/-- **THEOREM: The Incarnation is fitting AND alternatives exist (Thomistic).**
    Under Catholic/Thomistic axioms, both claims hold simultaneously:
    the Incarnation is maximally fitting, and God could have chosen
    otherwise. These are not contradictory — they express Aquinas's view
    that wisdom (choosing the best) is distinct from necessity (having
    no choice).

    Uses: incarnation_maximally_fitting, thomistic_alternatives_conceivable. -/
theorem thomistic_position :
    isMaximallyFitting theIncarnation
    ∧ (∃ alt, isAlternativeToIncarnation alt) :=
  ⟨incarnation_maximally_fitting, thomistic_alternatives_conceivable⟩

/-- **THEOREM: The Anselmian position contradicts the Thomistic position.**
    If we assert both Anselmian strict necessity (no alternatives) and
    Thomistic alternatives (some alternative exists), we get a
    contradiction. This makes the two positions formally incompatible.

    Uses: pure logic (Anselmian position negates Thomistic). -/
theorem anselm_contradicts_aquinas :
    anselmian_strict_necessity_claim →
    (∃ alt, isAlternativeToIncarnation alt) →
    False := by
  intro h_anselm h_alt
  exact h_anselm h_alt

-- ============================================================================
-- § 7. Connection to Atonement.lean
-- ============================================================================

/-!
### How this file relates to Atonement.lean

Atonement.lean answers: "Why the Cross?" (given that the Incarnation happened).
This file answers: "Why the Incarnation?" (why did God become man AT ALL?).

The connection:
- Atonement.lean: `incarnation_necessary_for_atonement` — the mediator must
  have two natures to provide adequate satisfaction
- This file: the REASON a mediator is needed — the four purposes (§457-460)
- Atonement.lean provides the mechanism (satisfaction theory)
- This file provides the motivation (the four purposes) and asks whether
  the mechanism was the ONLY option (necessity vs. fittingness)
-/

/-- **THEOREM: Atonement requires the Incarnation's salvific purpose.**
    The salvific purpose (§457) is precisely what Atonement.lean formalizes:
    the Cross (as satisfaction) requires a divine-human mediator. This
    theorem composes the salvific purpose with Atonement.lean's result.

    Uses: incarnation_saves, purposes_require_two_natures,
    incarnation_necessary_for_atonement (from Atonement.lean). -/
theorem atonement_confirms_salvific_purpose :
    -- Atonement.lean independently derives the same conclusion:
    -- the mediator needs both natures
    christ.hasNature Nature.divine ∧ christ.hasNature Nature.human :=
  incarnation_necessary_for_atonement

/-- **THEOREM: The Incarnation goes BEYOND atonement.**
    Atonement.lean shows why a divine-human mediator is needed for
    SALVATION (purpose 1). But the Incarnation also reveals love (purpose 2),
    provides a model (purpose 3), and enables theosis (purpose 4).

    Even if one granted that salvation could be accomplished another way
    (Aquinas's concession), the other three purposes give ADDITIONAL
    reasons for the Incarnation. The Incarnation is not ONLY about
    repairing sin — it is about elevating humanity.

    Uses: incarnation_four_purposes. -/
theorem incarnation_exceeds_atonement :
    -- The Incarnation accomplishes purposes BEYOND salvation
    revealsGodsLove theIncarnation
    ∧ providesModelOfHoliness theIncarnation
    ∧ enablesTheosis theIncarnation :=
  ⟨incarnation_reveals_love, incarnation_models_holiness,
   incarnation_enables_theosis⟩

-- ============================================================================
-- § 8. Connection to OriginalSin.lean
-- ============================================================================

/-!
### Why the Incarnation was needed: the wound

OriginalSin.lean formalizes the WOUND that makes the Incarnation's
salvific purpose necessary. The chain:

1. OriginalSin: the Fall wounded human nature (the_fall)
2. OriginalSin: wounded nature cannot reach its supernatural end unaided
3. Atonement: bare pardon does not repair the rupture in the order of justice
4. Atonement: only a divine-human mediator can provide adequate satisfaction
5. This file: the Incarnation provides that mediator (purpose 1)
6. This file: and it does THREE additional things beyond atonement (purposes 2-4)
-/

/-- **THEOREM: The Fall grounds the need for the Incarnation.**
    Original sin creates the wound; the wound creates the need for healing;
    healing (adequate satisfaction) requires a divine-human mediator;
    the Incarnation provides that mediator.

    Uses: the_fall (from OriginalSin.lean),
    incarnation_saves, purposes_require_two_natures. -/
theorem fall_grounds_incarnation
    (p : Person)
    (h_intellect : p.hasIntellect = true) :
    -- The wound exists
    natureIsWounded p
    -- AND the Incarnation addresses it through the salvific purpose
    ∧ accomplishesSalvation theIncarnation := by
  exact ⟨(the_fall p h_intellect).1, incarnation_saves⟩

/-- **THEOREM: The Incarnation is the fitting response to the Fall.**
    Combines the Thomistic position (fitting, not strictly necessary)
    with the Fall as the occasion: the wound of original sin is the
    OCCASION for the Incarnation, and the Incarnation is the FITTING
    (though not strictly necessary) response.

    Uses: the_fall, incarnation_maximally_fitting,
    thomistic_alternatives_conceivable. -/
theorem incarnation_fitting_response_to_fall
    (p : Person)
    (h_intellect : p.hasIntellect = true) :
    -- The wound exists (the occasion)
    natureIsWounded p
    -- The Incarnation is maximally fitting (the response)
    ∧ isMaximallyFitting theIncarnation
    -- But alternatives were conceivable (it was not the only option)
    ∧ (∃ alt, isAlternativeToIncarnation alt) := by
  exact ⟨(the_fall p h_intellect).1,
         incarnation_maximally_fitting,
         thomistic_alternatives_conceivable⟩

-- ============================================================================
-- § 9. Summary Theorem
-- ============================================================================

/-- **THEOREM: CurDeusHomo summary — the full answer.**
    Why did God become man?
    1. To save us (reconciliation through the divine-human mediator)
    2. To reveal God's love (making divine love visible)
    3. To be our model (the exemplar of holiness)
    4. To make us partakers of divine nature (theosis)

    All four purposes require Christ's two natures (the hypostatic union).
    The Incarnation is maximally fitting (Aquinas/CCC) though alternatives
    were conceivable.

    Uses: incarnation_four_purposes, salvation_requires_two_natures,
    thomistic_position. -/
theorem cur_deus_homo :
    -- The four purposes
    (accomplishesSalvation theIncarnation
      ∧ revealsGodsLove theIncarnation
      ∧ providesModelOfHoliness theIncarnation
      ∧ enablesTheosis theIncarnation)
    -- Two natures required
    ∧ (christ.hasNature Nature.divine ∧ christ.hasNature Nature.human)
    -- Maximally fitting, not strictly necessary
    ∧ isMaximallyFitting theIncarnation := by
  exact ⟨incarnation_four_purposes,
         salvation_requires_two_natures,
         incarnation_maximally_fitting⟩

-- ============================================================================
-- § 10. Summary
-- ============================================================================

/-!
## Summary: What the formalization reveals

### The answer to the question

**Why did God become man rather than save some other way?**

The CCC gives FOUR reasons (§457-460), each requiring Christ's two natures:
1. To SAVE us — requires a divine-human mediator for adequate satisfaction
2. To REVEAL God's love — requires God to be visible in human form
3. To be our MODEL — requires a divine person to live a human life
4. To enable THEOSIS — requires divine and human natures to be united

The Incarnation is the FITTING (not strictly necessary) response to
humanity's wound. Alternatives were conceivable (Aquinas), but the
Incarnation is maximally fitting because it accomplishes ALL FOUR purposes
simultaneously. Anselm's strict necessity claim is formally incompatible
with the Thomistic/CCC position.

### Key finding: The Incarnation exceeds atonement

Atonement.lean shows why a divine-human mediator is needed for salvation
(purpose 1). But purposes 2-4 show the Incarnation does MORE than repair
sin. Even if salvation could be accomplished another way, the Incarnation
would still be fitting for revelation, exemplarity, and theosis. The
Incarnation is not merely therapeutic — it is elevating.

### The load-bearing opaque: fittingness

`isMaximallyFitting` is the key concept that distinguishes the CCC/Aquinas
position from Anselm's. Until we understand fittingness well enough to
give it content (see CONTRIBUTING.md backlog), this remains a genuine
open question in the formalization.

### Connection to other formalizations

- **Christology.lean**: the hypostatic union (two natures in one person)
  is the structural foundation that makes ALL four purposes possible
- **Atonement.lean**: `incarnation_necessary_for_atonement` formalizes
  purpose 1's mechanism (satisfaction theory); this file provides the
  WHY (the four motivations) and asks WHETHER (necessary vs. fitting)
- **OriginalSin.lean**: the Fall is the occasion for the Incarnation —
  the wound that makes the salvific purpose needed

### Axiom count for this file: 7

Local axioms: 7 (incarnation_saves, incarnation_reveals_love,
incarnation_models_holiness, incarnation_enables_theosis,
incarnation_maximally_fitting, thomistic_alternatives_conceivable,
purposes_require_two_natures)

Theorems: 12 (incarnation_four_purposes, salvation_requires_two_natures,
revelation_requires_two_natures, model_requires_two_natures,
theosis_requires_two_natures, thomistic_position,
anselm_contradicts_aquinas, atonement_confirms_salvific_purpose,
incarnation_exceeds_atonement, fall_grounds_incarnation,
incarnation_fitting_response_to_fall, cur_deus_homo)

Opaques: 7 (theIncarnation, accomplishesSalvation, revealsGodsLove,
providesModelOfHoliness, enablesTheosis, isAlternativeToIncarnation,
isMaximallyFitting)

Definitions: 2 (anselmian_strict_necessity_claim,
anselmian_strict_necessity_tag)
-/

end Catlib.Creed.CurDeusHomo
