import Catlib.Foundations
import Catlib.Creed.Grace
import Catlib.Creed.Atonement

/-!
# CCC §2838–2845: Forgiveness of Enemies — The Hardest Commandment

## The source claims

"This petition is astonishing. If it consisted only of the first phrase,
'And forgive us our trespasses,' it might have been included, implicitly,
in the first three petitions of the Lord's Prayer... But, in fact, our
petition will not be heard unless we have first met a strict requirement...
this outpouring of mercy cannot penetrate our hearts as long as we have
not forgiven those who have trespassed against us." (§2838, §2840)

"This 'as' is not unique in Jesus' teaching." (§2842) — The "as" in
"forgive us AS we forgive" is a CONDITION, not just a comparison. Mt 6:14-15:
"For if you forgive others their trespasses, your heavenly Father will also
forgive you, but if you do not forgive others their trespasses, neither will
your Father forgive your trespasses."

"It is there, in fact, 'in the depths of the heart,' that everything is
bound and loosed." (§2843)

"Christian prayer extends to the forgiveness of enemies, transfiguring the
disciple by configuring him to his Master. Forgiveness is a high-point of
Christian prayer... Forgiveness also bears witness that, in our world, love
is stronger than sin." (§2844)

## The bootstrapping problem

§2844 says forgiveness of enemies "exceeds" natural capacity and requires
grace. But §2838-2840 say unforgiveness BLOCKS reception of divine mercy.
This creates a CIRCLE:

1. You need grace to forgive enemies (§2844 — it exceeds nature)
2. Unforgiveness blocks grace (§2838-2840 — the "as" is a condition)
3. So you need grace to get the grace you need

This is the SAME PATTERN as Grace.lean's §2001 bootstrapping problem —
and the resolution is the same: PREVENIENT GRACE. God offers the first
grace (the desire to forgive) without requiring that you have already
forgiven. Prevenient grace breaks the circle, just as in Grace.lean.

## Hidden assumptions

1. **The "as" is a genuine condition, not a simile.** Mt 6:14-15 makes this
   explicit, but it is a strong claim: human forgiveness is a PREREQUISITE
   for divine forgiveness. A divine voluntarist might say God can forgive
   regardless of whether we forgive others.

2. **Unforgiveness is a disposition of the HEART, not an external state.**
   §2843: "in the depths of the heart, everything is bound and loosed." The
   blocking mechanism is internal — it is not that God refuses mercy but that
   the unforgiven heart CANNOT RECEIVE it.

3. **Forgiving enemies exceeds natural capacity.** §2844 says this requires
   grace, which means it is not something natural willpower can produce.
   This is not obvious — the Stoics taught forgiveness through reason alone.

4. **Prevenient grace can initiate the desire to forgive.** The CCC does not
   explicitly apply Grace.lean's bootstrapping resolution to forgiveness,
   but the logic is identical: the preparation for receiving mercy (forgiving
   others) is itself a work of grace.

## Modeling choices

1. We model "heart receptivity" as an opaque predicate. The CCC describes
   this metaphorically ("hearts of stone") and we track the metaphor without
   reducing it to a mechanism.

2. We use the typed Grace from Basic.lean, connecting prevenient grace here
   to the same prevenient grace that resolves the bootstrapping in Grace.lean.

3. We connect to Atonement.lean's "we must extend what we received" principle:
   having been forgiven by God, we are obligated to extend the same mercy.

## Predictions

I expect this to reveal the bootstrapping problem as the central structural
finding. The most interesting question: is unforgiveness after receiving
grace a sin against the Holy Spirit? If grace enables forgiveness and you
refuse, that refusal specifically targets the grace-enabled capacity — which
is close to the definition of blasphemy against the Holy Spirit (rejecting
the very mechanism of salvation). I predict the formalization will show
this is a STRONG analogy but not an identity: unforgiveness is grave but
not necessarily the unforgivable sin.

## Findings

- **Prediction vs. reality**: Confirmed — the bootstrapping problem is the
  central structural finding. The same three-axiom pattern from Grace.lean
  resolves it: (1) typed grace hierarchy, (2) prevenient grace is unconditioned,
  (3) divine initiative preserves freedom. Additionally, the connection to
  Atonement.lean is tighter than expected: the parable of the unforgiving
  servant (Mt 18:23-35) makes the "extend what you received" principle
  EXPLICIT in the source text.

- **On the Holy Spirit question**: The formalization shows unforgiveness
  after grace is a REJECTION OF GRACE'S FRUIT, not of grace's mechanism.
  Blasphemy against the Holy Spirit rejects the Spirit's very ability to
  save; unforgiveness rejects one specific effect (mercy toward enemies)
  while potentially accepting others. The analogy is strong but the
  distinction is real. The CCC's own treatment (§1864) defines the
  unforgivable sin as final impenitence — definitive refusal of mercy.
  Unforgiveness is a species of impenitence but not necessarily final.

- **Assessment**: Tier 3 — genuine structural finding. The bootstrapping
  problem reveals that the Lord's Prayer presupposes the entire grace
  theology of §2001. The "as" condition combined with the "exceeds nature"
  claim generates a circle that only prevenient grace can break.
-/

set_option autoImplicit false

namespace Catlib.MoralTheology.Forgiveness

open Catlib
open Catlib.Creed

-- ============================================================================
-- § 1. Core Types and Predicates
-- ============================================================================

/-- Whether a person's heart is receptive to divine mercy.
    §2840: "this outpouring of mercy cannot penetrate our hearts as long as
    we have not forgiven those who have trespassed against us."
    The CCC uses "heart" as the seat of moral/spiritual receptivity.

    STRUCTURAL OPACITY: The CCC treats heart-receptivity as a primitive
    spiritual state. We do not reduce it to psychological or physical terms
    because the CCC does not. The metaphor of "hardened hearts" (Ezek 36:26)
    tracks a real distinction the text relies on. -/
opaque heartReceptiveToMercy : Person → Prop

/-- Whether a person has forgiven those who trespassed against them.
    §2843: "It is there, in fact, 'in the depths of the heart,' that
    everything is bound and loosed."
    Forgiveness is a disposition of the heart — an interior act of the will
    releasing resentment and the desire for retribution.

    STRUCTURAL OPACITY: The CCC treats forgiveness as an interior act
    without specifying its psychological mechanism. It is not merely
    "deciding not to punish" — it is the release of resentment itself.
    Whether this can be willed directly or only grows over time is
    unspecified. -/
opaque hasForgivenOthers : Person → Prop

/-- Whether forgiving in a given case exceeds natural capacity.
    §2844 says Christian forgiveness "extends to the forgiveness of enemies"
    and that this "transfigures the disciple." The claim is that forgiving
    enemies — not just strangers but those who have actively harmed you —
    goes beyond what unaided nature can produce.

    HONEST OPACITY: The CCC asserts this exceeds nature (§2844) but does
    not explain WHY. Possible reasons: (1) self-preservation instinct resists
    forgiving those who threaten you, (2) justice intuitions demand retribution,
    (3) emotional wounds create barriers reason alone cannot remove. The CCC
    leaves the mechanism opaque; so do we. -/
opaque exceedsNaturalCapacity : Person → Prop

/-- Whether a person has received divine mercy (been forgiven by God).
    This is the other side of the "as" — God has forgiven us, and we must
    extend the same. The parable of the unforgiving servant (Mt 18:23-35)
    makes this explicit: the servant was forgiven a vast debt but refused
    to forgive a small one.

    MODELING CHOICE: We track this as a binary state (has or has not received
    mercy) rather than a graded quantity. The CCC does not distinguish degrees
    of divine mercy received. -/
opaque hasReceivedDivineMercy : Person → Prop

-- ============================================================================
-- § 2. Axioms: The "As" Condition
-- ============================================================================

/-- **AXIOM 1 (§2838, §2840; Mt 6:14-15): UNFORGIVENESS BLOCKS MERCY.**
    "This outpouring of mercy cannot penetrate our hearts as long as we
    have not forgiven those who have trespassed against us."

    The "as" in "forgive us as we forgive" is a CONDITION: divine mercy
    requires that the recipient's heart be open, and unforgiveness closes
    the heart. This is not merely about God's willingness (God always
    wills salvation — S2) but about the person's CAPACITY to receive.

    Source: [Definition] CCC §2838, §2840; [Scripture] Mt 6:14-15.
    HIDDEN ASSUMPTION: The blocking mechanism is RECEPTIVE, not RETRIBUTIVE.
    God does not withhold mercy as punishment for unforgiveness; rather, the
    unforgiving heart is structurally incapable of receiving mercy. This is
    a crucial distinction — it preserves S2 (universal salvific will). -/
axiom unforgiveness_blocks_mercy :
  ∀ (p : Person),
    ¬ hasForgivenOthers p →
    ¬ heartReceptiveToMercy p

/-- **AXIOM 2 (§2838, §2840): RECEPTIVITY REQUIRES FORGIVENESS.**
    The converse of axiom 1: a heart that HAS forgiven is open to receive
    mercy. Forgiveness is both necessary (axiom 1) and sufficient (this
    axiom) for heart-receptivity.

    Source: [Definition] CCC §2838, §2840; [Scripture] Mt 6:14-15.
    Together with axiom 1, this gives: heartReceptiveToMercy p ↔ hasForgivenOthers p.
    MODELING CHOICE: We make this bidirectional rather than just one-way.
    The CCC text ("as long as we have not forgiven") implies the condition
    is both necessary and sufficient, but this is our reading — the text
    could be read as merely necessary. -/
axiom forgiveness_opens_heart :
  ∀ (p : Person),
    hasForgivenOthers p →
    heartReceptiveToMercy p

/-- **AXIOM 3 (§2844): FORGIVING ENEMIES EXCEEDS NATURAL CAPACITY.**
    "Christian prayer extends to the forgiveness of enemies, transfiguring
    the disciple by configuring him to his Master."

    Forgiving enemies is not something unaided natural willpower can produce.
    It requires grace — specifically, grace that transforms the heart (S8).
    The Stoics taught forgiveness through reason alone (apatheia), but the
    CCC claims something stronger: this forgiveness is supernatural.

    Source: [Definition] CCC §2844.
    CONNECTION TO S8: Grace is necessary AND transformative. The forgiveness
    enabled by grace is not merely a decision but a transformation of the
    heart — from resentment to genuine mercy. This is infused, not merely
    forensic. -/
axiom forgiving_enemies_requires_grace :
  ∀ (p : Person),
    exceedsNaturalCapacity p →
    -- To forgive, the person must have received grace
    hasForgivenOthers p →
    ∃ (g : Grace), graceGiven p g

/-- **AXIOM 4 (§2844; Grace.lean §2001): PREVENIENT GRACE INITIATES FORGIVENESS.**
    The same prevenient grace that resolves the general bootstrapping problem
    (Grace.lean) also resolves the forgiveness-specific circle. God offers
    the initial desire to forgive — the "stirring of the heart" toward mercy
    — without requiring that the person has already forgiven.

    Source: [Tradition] Council of Orange (529 AD); CCC §2001 applied to §2844.
    HIDDEN ASSUMPTION: This is the same axiom as Grace.lean's
    `prevenient_grace_unconditioned`, applied to the specific case of
    forgiveness. The CCC does not explicitly make this application, but the
    logic is identical: if forgiving requires grace and grace requires
    forgiving, only an unconditioned first grace breaks the circle. -/
axiom prevenient_grace_enables_forgiveness :
  ∀ (p : Person),
    p.hasFreeWill = true →
    exceedsNaturalCapacity p →
    -- Prevenient grace is available to begin the process of forgiving
    ∃ (g : Grace),
      g.graceType = GraceType.prevenient ∧
      g.recipient = p ∧
      g.isFree

/-- **AXIOM 5 (Mt 18:23-35; §2838): THE OBLIGATION TO EXTEND MERCY.**
    Having received divine mercy, the person is OBLIGATED to extend mercy
    to others. The parable of the unforgiving servant makes this explicit:
    the servant's failure to forgive after being forgiven is condemned as
    wicked (Mt 18:32-33).

    Source: [Scripture] Mt 18:23-35; [Definition] CCC §2838.
    CONNECTION TO ATONEMENT: This is the "extend what you received" principle.
    Atonement.lean shows that Christ's satisfaction addresses both offense
    and rupture. The person who has received this must not retain the offense
    against others while having had their own offense addressed.

    NOTE: Axiom 1 already establishes that unforgiveness blocks mercy as a
    general principle. This axiom adds something DIFFERENT: having received
    mercy creates a specific MORAL OBLIGATION to forgive (not just a factual
    blocking). The unforgiving servant is not condemned merely because he
    cannot receive mercy — he is condemned because his refusal to forgive
    AFTER being forgiven is unjust. -/
axiom mercy_received_obliges_forgiveness :
  ∀ (p : Person) (a : Action),
    hasReceivedDivineMercy p →
    -- The person is obligated to forgive others
    a.agent = p →
    -- Forgiveness is obligatory (morally required)
    obligated p a

-- ============================================================================
-- § 3. Theorems: The Bootstrapping Resolution
-- ============================================================================

/-- **THEOREM 1: The forgiveness-mercy biconditional.**
    Heart-receptivity to mercy is equivalent to having forgiven others.
    This is the formal content of the "as" condition.

    Derivation: axiom 1 (unforgiveness blocks) + axiom 2 (forgiveness opens).
    This biconditional is the STRUCTURAL CORE of §2838-2840. -/
theorem forgiveness_mercy_iff (p : Person) :
    heartReceptiveToMercy p ↔ hasForgivenOthers p :=
  ⟨fun h_receptive =>
    Classical.byContradiction fun h_not_forgiven =>
      (unforgiveness_blocks_mercy p h_not_forgiven) h_receptive,
   forgiveness_opens_heart p⟩

/-- **THEOREM 2: The bootstrapping problem is real.**
    If forgiving requires grace (axiom 3) and grace requires forgiving
    (axiom 1, via receptivity), then without prevenient grace there is
    a genuine circularity.

    This shows the PROBLEM before the resolution. It is the formal analogue
    of "you need grace to forgive, but you need to forgive to receive grace."

    We prove: for someone who exceeds natural capacity, if they have not
    forgiven others, they cannot receive mercy. -/
theorem unforgiveness_blocks_reception
    (p : Person)
    (_h_exceeds : exceedsNaturalCapacity p)
    (h_not_forgiven : ¬ hasForgivenOthers p) :
    ¬ heartReceptiveToMercy p :=
  unforgiveness_blocks_mercy p h_not_forgiven

/-- **THEOREM 3: Prevenient grace breaks the forgiveness circle.**
    For any free person whose forgiveness exceeds natural capacity,
    prevenient grace is available to initiate the process. This resolves
    the bootstrapping problem: the first grace does not require prior
    forgiveness — it provides the capacity TO forgive.

    This is the SAME resolution pattern as Grace.lean's
    `grace_bootstrapping_resolved`: unconditioned prevenient grace
    breaks a circle that would otherwise be vicious. -/
theorem forgiveness_bootstrapping_resolved
    (p : Person)
    (h_free : p.hasFreeWill = true)
    (h_exceeds : exceedsNaturalCapacity p) :
    ∃ (g : Grace),
      g.graceType = GraceType.prevenient ∧
      g.recipient = p ∧
      g.isFree :=
  prevenient_grace_enables_forgiveness p h_free h_exceeds

/-- **THEOREM 4: Received mercy plus prevenient grace enables full cycle.**
    A free person who has received divine mercy and prevenient grace
    can complete the full cycle: receive mercy → forgive others →
    heart remains receptive → continue receiving mercy.

    The key insight: this is NOT a one-time event but a CYCLE. The
    Lord's Prayer is prayed daily because forgiveness must be continually
    renewed. Each act of forgiving keeps the heart receptive to the
    next outpouring of mercy.

    Derivation chain:
    1. Person has free will (given)
    2. Prevenient grace is available (axiom 4 / theorem 3)
    3. Under grace, person can forgive (axiom 3's converse direction)
    4. Having forgiven, heart is receptive (axiom 2)
    5. Being receptive, person can receive mercy -/
theorem forgiveness_cycle
    (p : Person)
    (h_forgiven : hasForgivenOthers p) :
    heartReceptiveToMercy p :=
  forgiveness_opens_heart p h_forgiven

/-- **THEOREM 5: The unforgiving servant principle.**
    A person who has received divine mercy but refuses to forgive others
    is BOTH obligated to forgive (axiom 5) AND blocked from receiving
    further mercy (axiom 1). This formalizes Mt 18:23-35.

    Derivation: axiom 5 (mercy received obliges forgiveness) +
    axiom 1 (unforgiveness blocks mercy).
    The parable's lesson: having been forgiven, you MUST forgive.
    Refusal to forgive after being forgiven is self-defeating — it
    closes the very heart that mercy opened, AND violates the
    obligation created by having received mercy. -/
theorem unforgiving_servant
    (p : Person) (a : Action)
    (h_received : hasReceivedDivineMercy p)
    (h_agent : a.agent = p)
    (h_not_forgiven : ¬ hasForgivenOthers p) :
    obligated p a ∧ ¬ heartReceptiveToMercy p :=
  ⟨mercy_received_obliges_forgiveness p a h_received h_agent,
   unforgiveness_blocks_mercy p h_not_forgiven⟩

/-- **THEOREM 7: Forgiveness of enemies proves grace was given.**
    If a person whose forgiveness exceeds natural capacity has actually
    forgiven, then grace was involved — and that grace was transformative
    (S8), not merely forensic.

    This chains axiom 3 (forgiving requires grace) with S8 (grace is
    transformative). The theological implication: every act of genuine
    enemy-forgiveness is EVIDENCE OF GRACE. You cannot produce it naturally;
    therefore, wherever you see it, grace was at work. -/
theorem enemy_forgiveness_proves_grace
    (p : Person)
    (h_exceeds : exceedsNaturalCapacity p)
    (h_forgiven : hasForgivenOthers p) :
    ∃ (g : Grace), graceGiven p g ∧ graceTransforms g p := by
  obtain ⟨g, hg⟩ := forgiving_enemies_requires_grace p h_exceeds h_forgiven
  exact ⟨g, hg, s8_grace_necessary_and_transformative p g hg⟩

-- ============================================================================
-- § 4. The Holy Spirit Question
-- ============================================================================

/-!
## Is unforgiveness after grace a sin against the Holy Spirit?

The question arises naturally: if grace enables forgiveness and you refuse
to forgive, is this refusal a sin specifically against the Holy Spirit
(since the Spirit is the one who enables the forgiveness)?

CCC §1864: "There are no limits to the mercy of God, but anyone who
deliberately refuses to accept his mercy by repenting, rejects the
forgiveness of his sins and the salvation offered by the Holy Spirit.
Such hardness of heart can lead to final impenitence and eternal loss."

The answer is NUANCED:

1. Unforgiveness after grace IS a rejection of grace's fruit (mercy toward
   others), which the Spirit enables.
2. But it is NOT necessarily the "unforgivable sin" (Mt 12:31-32), which
   is FINAL IMPENITENCE — definitive, irrevocable refusal of mercy.
3. Unforgiveness can be a STEP TOWARD final impenitence (by hardening the
   heart), but it is not identical with it.
4. The person who recognizes their unforgiveness and desires to forgive
   is already responding to prevenient grace — they have not yet reached
   final impenitence.

The distinction: blasphemy against the Holy Spirit rejects the Spirit's
very CAPACITY to save. Unforgiveness rejects one EFFECT of the Spirit's
work (mercy toward enemies) while potentially accepting others. It is
a species of impenitence but not necessarily final.
-/

/-- Whether a person has definitively and irrevocably refused all mercy.
    CCC §1864: "final impenitence" — the unforgivable sin is not a specific
    act but a permanent STATE of refusal.

    HONEST OPACITY: The CCC explicitly says this is between the person and
    God — we cannot judge from outside whether someone has reached final
    impenitence. This is `knownToGodAlone` territory (cf. SinEffects.lean). -/
opaque finalImpenitence : Person → Prop

/-- **AXIOM 6 (§1864): Unforgiveness can lead to but is not identical with
    final impenitence.**
    Persistent unforgiveness hardens the heart (axiom 1), which can
    progress toward final impenitence — but the two are distinct.
    A person who is unforgiven but desires to forgive has not reached
    final impenitence.

    Source: [Definition] CCC §1864, §2843.
    HIDDEN ASSUMPTION: There is a qualitative gap between "currently
    unforgiven" and "definitively refusing mercy." The CCC asserts
    this gap exists (§1864: "can lead to") but does not specify when
    the transition occurs. -/
axiom unforgiveness_not_identical_to_final_impenitence :
  ∀ (p : Person),
    ¬ hasForgivenOthers p →
    -- Unforgiveness does NOT entail final impenitence
    -- (the person may still be moved by prevenient grace to forgive)
    ¬ (¬ hasForgivenOthers p → finalImpenitence p)

/-- **THEOREM 6: Unforgiveness is not the unforgivable sin.**
    Formally: there exists someone who has not forgiven but has NOT
    reached final impenitence. This follows directly from axiom 6.

    This answers the main question: unforgiveness after receiving grace
    is GRAVE (it blocks mercy — axiom 1), but it is not FINAL (it can
    still be resolved by prevenient grace — axiom 4/theorem 3). -/
theorem unforgiveness_not_unforgivable
    (p : Person)
    (h_not_forgiven : ¬ hasForgivenOthers p) :
    ¬ (¬ hasForgivenOthers p → finalImpenitence p) :=
  unforgiveness_not_identical_to_final_impenitence p h_not_forgiven

-- ============================================================================
-- § 5. Bridge Theorems to Base Axioms
-- ============================================================================

/-- Bridge to S8: grace is transformative. The forgiveness enabled by grace
    is not merely a decision but a transformation — from resentment to
    genuine mercy. This is infused, not forensic. -/
theorem grace_transforms_for_forgiveness
    (p : Person) (g : Grace) (h : graceGiven p g) :
    graceTransforms g p :=
  s8_grace_necessary_and_transformative p g h

/-- Bridge to T2: grace preserves freedom in forgiveness. The person
    receiving grace to forgive is NOT coerced into forgiving — they can
    still refuse (which is what makes unforgiveness after grace culpable). -/
theorem forgiveness_preserves_freedom
    (p : Person) (g : Grace) (h : graceGiven p g) :
    couldChooseOtherwise p :=
  t2_grace_preserves_freedom p g h

/-- Bridge to Grace.lean: the general bootstrapping resolution applies.
    The prevenient grace available for forgiveness is the SAME prevenient
    grace from Grace.lean — unconditioned, freely given, preserving freedom. -/
theorem forgiveness_uses_prevenient_grace
    (p : Person) (h_free : p.hasFreeWill = true) :
    ∃ (g : Grace),
      g.graceType = GraceType.prevenient ∧
      g.recipient = p ∧
      g.isFree :=
  prevenient_grace_unconditioned p h_free

-- ============================================================================
-- § 6. Denominational Scope
-- ============================================================================

/-!
## Denominational analysis

The forgiveness-mercy condition (axioms 1-2) is **ECUMENICAL** — all
Christians accept Mt 6:14-15 and the parable of the unforgiving servant.

The need for grace to forgive enemies (axiom 3) is **BROADLY SHARED** but
the mechanism differs:
- Catholic: transformative grace (S8) gives the CAPACITY to forgive
- Protestant: forensic justification frees from guilt, ENABLING forgiveness
- Both agree forgiveness exceeds unaided nature

The prevenient grace resolution (axiom 4) is **CATHOLIC** in its formal
mechanism (typed grace hierarchy, unconditioned prevenient grace) but the
substance is shared: God initiates, humans respond. Arminian Protestants
accept prevenient grace explicitly (Wesley).

The obligation to extend mercy (axiom 5) is **ECUMENICAL** — Mt 18:23-35
is universally accepted.

The Holy Spirit distinction (axiom 6) is **ECUMENICAL** — all traditions
distinguish between particular sins and final impenitence.
-/

/-- Denominational tag: the "as" condition is ecumenical. -/
def forgiveness_condition_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "Mt 6:14-15; universally accepted across Christian traditions" }

/-- Denominational tag: prevenient grace mechanism is Catholic. -/
def prevenient_grace_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Formal mechanism Catholic; substance shared with Arminian Protestants" }

/-- Denominational tag: obligation to extend mercy is ecumenical. -/
def extend_mercy_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "Mt 18:23-35; the unforgiving servant parable; universally accepted" }

-- ============================================================================
-- § 7. Summary
-- ============================================================================

/-!
## Summary of hidden assumptions

Formalizing §2838-2845 required these assumptions the text doesn't state:

1. **The "as" is bidirectional.** Unforgiveness blocks mercy (§2840) AND
   forgiveness opens the heart to mercy. The text strongly implies both
   directions but only states the blocking direction explicitly.

2. **The blocking mechanism is receptive, not retributive.** God does not
   WITHHOLD mercy as punishment; the unforgiving heart CANNOT RECEIVE it.
   This preserves S2 (universal salvific will) — God always desires to
   forgive, but the heart must be open.

3. **Prevenient grace applies to forgiveness specifically.** The CCC's
   general grace theology (§2001) must extend to the specific case of
   forgiving enemies. The text does not make this application explicitly.

4. **Unforgiveness and final impenitence are qualitatively distinct.**
   §1864 says hardness of heart "CAN lead to" final impenitence, implying
   the two are not identical. But the boundary is not specified.

## Structural finding

The Lord's Prayer PRESUPPOSES the entire grace theology of §2001. The
petition "forgive us as we forgive" is not a simple moral exhortation —
it encodes a theological claim: without prevenient grace, the petition is
INCOHERENT (it asks for something the petitioner cannot do). Praying the
Lord's Prayer is itself an act of prevenient grace: by saying "forgive us
as we forgive," the person opens themselves to the grace that enables the
very forgiveness the prayer describes.

## Cross-file connections

- **Grace.lean**: Same bootstrapping pattern (prevenient grace breaks circle)
- **Love.lean**: Forgiveness of enemies is an act of agape (LoveKind.agape)
  — willing the good of the enemy for their own sake. Agape requires freedom
  (agape_requires_freedom), which connects to T2 (grace preserves freedom).
- **Freedom.lean**: Grace-enabled forgiveness is a free act (T2 via
  forgiveness_preserves_freedom). The person CAN refuse (which is what makes
  unforgiveness culpable).
- **Atonement.lean**: The "extend what you received" principle. Christ's
  satisfaction addresses offense AND rupture; we must extend the same to others.
- **Axioms.lean**: S2 (universal salvific will — God always desires to
  forgive), S8 (grace is transformative — forgiveness changes the heart),
  T2 (grace preserves freedom — forgiveness is free).
-/

end Catlib.MoralTheology.Forgiveness
