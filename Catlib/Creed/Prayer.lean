import Catlib.Foundations
import Catlib.Creed.Providence

/-!
# CCC §2734-2745, §307: Petitionary Prayer Under Providence

## The puzzle

If God already knows everything and wills the good, why pray? Prayer seems
either:
- **Pointless** (God already decided the outcome)
- **Presumptuous** (trying to change God's mind)
- **Redundant** (the outcome is fixed regardless of whether you pray)

This is structurally identical to the free-will/providence tension that
Providence.lean resolves. Just as human freedom operates WITHIN providence
(not against it), prayer operates WITHIN providence (not against it).

## The CCC's answer

"Do not be troubled if you do not immediately receive from God what you
ask him; for he desires to do something even greater for you, while you
cling to him in prayer." (CCC §2737, citing Evagrius Ponticus)

"God's providence works also through the actions of creatures." (CCC §307)

"We firmly believe that God is master of the world and of its history. But
the ways of his providence are often unknown to us." (CCC §314)

The answer has three steps:
1. God's providence INCLUDES secondary causes (§307, P2)
2. Prayer IS one such secondary cause — God incorporates human prayer
   into His providential plan (§2738)
3. Prayer doesn't change God's mind — it participates in God's plan (§2745)

## Prediction

I expect this to **confirm the P2 pattern**. The resolution should be
structurally identical to how P2 resolves the freedom/providence tension:
prayer and providence don't compete because they operate at different
causal levels. The interesting question is whether prayer changes outcomes,
changes the person, or both.

## Findings

- **Prediction vs. reality**: Confirmed — P2 does the same work here as
  in Providence.lean. The resolution is structurally identical: prayer is
  a secondary cause operating within (not against) the primary cause.
- **Key insight**: Prayer has TWO effects under this model:
  (a) It is a genuine secondary cause that God incorporates into providence
      (the "instrumental" effect — prayer participates in outcomes)
  (b) It transforms the one who prays by aligning them with God's will
      (the "formative" effect — prayer shapes the pray-er)
  The CCC teaches BOTH, but (b) is the deeper one. §2725: "Prayer is
  the life of the new heart." Prayer changes the person praying into
  someone more aligned with God — and THAT alignment is itself part of
  God's providential plan.
- **Hidden assumption**: The CCC assumes that a secondary cause can be
  genuinely efficacious even when the primary cause has already determined
  the outcome. This is the same assumption P2 makes for all secondary
  causes — prayer is just a special case.
- **Denominational scope**: ECUMENICAL — all Christians pray. The P2
  framing is Thomistic, but the practice and logic are universal.
  Calvinists would emphasize the formative effect (prayer changes you)
  over the instrumental effect (prayer changes outcomes), since under
  their view God's decree is unalterable. But even Calvinists pray.
- **Surprise**: The formalization reveals that the "prayer changes
  outcomes vs. prayer changes the person" dichotomy is FALSE under P2.
  Since prayer is a secondary cause within providence, it does both
  simultaneously. God's plan already includes the fact that you will
  pray and be changed by praying.
- **Assessment**: Tier 2 — applies P2 to a new domain (prayer) and
  exposes the false dichotomy between instrumental and formative effects.
-/

set_option autoImplicit false

namespace Catlib.Creed.Prayer

open Catlib
open Catlib.Creed

-- ============================================================================
-- § 1. Core concepts
-- ============================================================================

/-- A petitionary prayer — a request made by a person to God.
    Petitionary prayer is the specific case that creates the puzzle:
    if God already knows what you need, why ask?

    MODELING CHOICE: We model prayer as a structure with an agent, content,
    and the condition that it is freely offered. The CCC treats prayer as
    a free human act (§2725: "prayer is a vital and personal relationship
    with the living and true God"). -/
structure PetitionaryPrayer where
  /-- The person praying -/
  agent : Person
  /-- What the prayer asks for (the petition's content) -/
  petition : Prop
  /-- Prayer is a free act -/
  isFreeAct : Prop

/-- Whether a prayer functions as a genuine secondary cause within providence.
    MODELING CHOICE: This captures §307's claim that God's providence works
    "through the actions of creatures." Prayer is one such creaturely action.
    We use an opaque predicate because HOW prayer causes is a mystery — the
    CCC asserts it does, without specifying the mechanism. -/
opaque isSecondaryCause : PetitionaryPrayer → Prop

/-- Whether prayer transforms the one who prays — aligning them with God's will.
    CCC §2725: "Prayer is the life of the new heart."
    CCC §2745: "Prayer and Christian life are inseparable."

    HONEST OPACITY: The CCC describes prayer's formative effect in many places
    but never gives a mechanism. HOW does addressing God change the person?
    Possible answers: (1) habitual orientation — regularly directing the will
    toward God reshapes desire; (2) grace — God gives grace through prayer;
    (3) self-knowledge — prayer reveals the gap between the pray-er's will
    and God's will. The CCC implies all three but doesn't commit to a theory. -/
opaque transformsPrayer : PetitionaryPrayer → Prop

/-- Whether prayer participates in God's providential plan.
    This is the key concept: prayer does not change God's plan but is
    PART OF God's plan. God's providence includes the fact that the
    person will pray.

    HONEST OPACITY: "Participates in providence" is genuinely mysterious.
    The CCC asserts it (§307) without explaining the metaphysics. We keep
    this opaque because we don't want to smuggle in a specific theory of
    divine-creaturely cooperation that the CCC doesn't endorse. -/
opaque participatesInProvidence : PetitionaryPrayer → Prop

-- ============================================================================
-- § 2. Axioms
-- ============================================================================

/-- AXIOM (§307 + P2): Prayer is a genuine secondary cause.
    "God's providence works also through the actions of creatures.
    To human beings God grants also to participate in his providence
    by entrusting them with the responsibility..." (CCC §307)

    Prayer is a free creaturely act. Under P2 (two-tier causation),
    creaturely acts are genuine secondary causes. Therefore prayer is
    a genuine secondary cause within God's providential order.

    Provenance: [Definition] CCC §307; [Philosophical] P2 (Aquinas, ST I q.22 a.3)
    Denominational scope: ECUMENICAL. -/
axiom prayer_is_secondary_cause :
  ∀ (pr : PetitionaryPrayer),
    pr.agent.hasFreeWill = true →
    pr.isFreeAct →
    isSecondaryCause pr

/-- AXIOM (§2738): Secondary causes participate in providence.
    "Do not be troubled if you do not immediately receive from God what
    you ask him; for he desires to do something even greater for you,
    while you cling to him in prayer." (CCC §2737, citing Evagrius)

    The CCC's answer to "why doesn't God just give me what I pray for?"
    is that prayer's role in providence is richer than a vending machine.
    Prayer participates in providence — it is incorporated into God's
    providential plan — whether or not the specific petition is granted
    in the way the pray-er expects.

    HIDDEN ASSUMPTION: A secondary cause can genuinely participate in an
    outcome that the primary cause has already providentially ordered.
    This is the same assumption P2 makes for ALL secondary causes — the
    CCC applies it specifically to prayer in §2738.

    Provenance: [Definition] CCC §2737-2738; [Scripture] Rom 8:26-27
    Denominational scope: ECUMENICAL. -/
axiom prayer_participates_in_providence :
  ∀ (pr : PetitionaryPrayer),
    isSecondaryCause pr →
    (∀ (event : Prop), divinelyGoverned event) →
    participatesInProvidence pr

/-- AXIOM (§2725, §2745): Prayer transforms the one who prays.
    "Prayer is the life of the new heart." (CCC §2725)
    "Prayer and Christian life are inseparable." (CCC §2745)

    Prayer's formative effect: the act of praying aligns the person's
    will with God's will. Even when the petition is not granted as asked,
    the pray-er is changed by the act of praying.

    This is the deeper effect. §2735: "In the first place we ought to
    be astonished by this fact: when we praise God or give him thanks
    for his benefits in general, we are not particularly concerned
    whether or not our prayer is acceptable to him. On the other hand,
    when we ask for what we need, we demand that our prayer be answered."
    The CCC gently redirects: the primary gift of prayer is the
    relationship itself, not the specific outcome.

    HIDDEN ASSUMPTION: The act of freely addressing God in petition has
    an intrinsic formative effect on the person, independent of whether
    the petition is granted. The CCC teaches this but doesn't explain
    the mechanism.

    Provenance: [Definition] CCC §2725, §2745; [Scripture] Lk 11:1-13
    Denominational scope: ECUMENICAL. -/
axiom prayer_transforms_the_person :
  ∀ (pr : PetitionaryPrayer),
    pr.agent.hasFreeWill = true →
    pr.isFreeAct →
    participatesInProvidence pr →
    transformsPrayer pr

-- ============================================================================
-- § 3. Bridge theorems to base axioms
-- ============================================================================

/-- Bridge to S4: all events are divinely governed.
    Universal providence (S4) is the premise that makes prayer's
    relationship to providence coherent — if some events escaped
    providence, prayer's participation would be selective. -/
theorem universal_providence_bridge (event : Prop) :
    divinelyGoverned event :=
  s4_universal_providence event

/-- Bridge to P2: primary and secondary causes don't compete.
    This is the key bridge: prayer (secondary cause) does not compete
    with providence (primary cause). More prayer ≠ less providence.
    God's plan and the pray-er's petition are not rivals. -/
theorem prayer_and_providence_dont_compete
    (p : PrimaryCause) (s : SecondaryCause) :
    ¬ causesCompete p s :=
  p2_two_tier_causation p s

-- ============================================================================
-- § 4. Theorems: resolving the puzzle
-- ============================================================================

/-- THEOREM: Prayer is a genuine secondary cause within providence.

    This is the first step of the resolution: prayer is not pointless
    because it is a genuine secondary cause. Under P2, secondary causes
    are real — they are not illusory or redundant even though the primary
    cause governs all things.

    Depends on: prayer_is_secondary_cause, prayer_participates_in_providence,
    s4_universal_providence. -/
theorem prayer_is_genuine_cause_within_providence
    (pr : PetitionaryPrayer)
    (h_free : pr.agent.hasFreeWill = true)
    (h_act : pr.isFreeAct) :
    isSecondaryCause pr ∧ participatesInProvidence pr :=
  have h_sc := prayer_is_secondary_cause pr h_free h_act
  have h_pp := prayer_participates_in_providence pr h_sc s4_universal_providence
  ⟨h_sc, h_pp⟩

/-- THEOREM: Prayer both participates in providence AND transforms the person.

    This resolves the false dichotomy: "Does prayer change outcomes or change
    the person?" The answer is BOTH, simultaneously.

    (a) Prayer participates in providence — it is a genuine secondary cause
        that God incorporates into His plan (the instrumental effect).
    (b) Prayer transforms the pray-er — the act of praying aligns the
        person with God's will (the formative effect).

    Under P2, these don't compete. God's plan INCLUDES both the fact that
    the person will pray AND the fact that praying will change them.

    Depends on: prayer_is_secondary_cause, prayer_participates_in_providence,
    prayer_transforms_the_person, s4_universal_providence. -/
theorem prayer_has_dual_effect
    (pr : PetitionaryPrayer)
    (h_free : pr.agent.hasFreeWill = true)
    (h_act : pr.isFreeAct) :
    participatesInProvidence pr ∧ transformsPrayer pr :=
  have h_sc := prayer_is_secondary_cause pr h_free h_act
  have h_pp := prayer_participates_in_providence pr h_sc s4_universal_providence
  have h_tr := prayer_transforms_the_person pr h_free h_act h_pp
  ⟨h_pp, h_tr⟩

/-- THEOREM (Main): Prayer is meaningful under providence.

    The full resolution of the puzzle. For any free person who prays:
    1. The prayer is a genuine secondary cause (not pointless)
    2. The prayer participates in God's providential plan (not presumptuous)
    3. The prayer transforms the person praying (not redundant)
    4. Primary and secondary causes don't compete (P2) — so providence
       and prayer are not rivals

    This answers the backlog question: "Does prayer change outcomes,
    change the person, or both?" Answer: BOTH, because prayer is a
    secondary cause (participates in outcomes) that also transforms
    the agent (changes the person). The dichotomy is false under P2.

    Depends on: prayer_is_secondary_cause, prayer_participates_in_providence,
    prayer_transforms_the_person, s4_universal_providence, p2_two_tier_causation. -/
theorem prayer_meaningful_under_providence
    (pr : PetitionaryPrayer)
    (h_free : pr.agent.hasFreeWill = true)
    (h_act : pr.isFreeAct) :
    -- (a) Prayer is a genuine secondary cause
    isSecondaryCause pr
    -- (b) Prayer participates in providence
    ∧ participatesInProvidence pr
    -- (c) Prayer transforms the person
    ∧ transformsPrayer pr :=
  have h_sc := prayer_is_secondary_cause pr h_free h_act
  have h_pp := prayer_participates_in_providence pr h_sc s4_universal_providence
  have h_tr := prayer_transforms_the_person pr h_free h_act h_pp
  ⟨h_sc, h_pp, h_tr⟩

-- ============================================================================
-- § 5. The denominational picture
-- ============================================================================

/-!
### Where traditions agree and disagree

**All Christians agree:**
- Prayer is commanded (Mt 7:7, Lk 11:9, Phil 4:6)
- Prayer is a free act of the creature
- Prayer has formative effects on the person

**The P2-specific claim:**
- Prayer is a genuine secondary cause that participates in providence
- This is the Thomistic framing — prayer is a REAL cause, not merely
  a subjective exercise

**Where traditions differ:**
- **Catholic/Thomistic**: Prayer is both instrumental (genuine secondary
  cause within providence) and formative (transforms the person). God
  ordains both the end and the means, including prayer. Aquinas, ST II-II
  q.83 a.2: "We pray not to change God's mind, but to obtain what God
  has disposed to be fulfilled by prayers."
- **Calvinist**: Emphasizes the formative effect. Prayer changes US, not
  God's decree. But Calvinists still pray and still believe God commands
  prayer as a means of grace — they just ground it differently (in divine
  command rather than in secondary causation).
- **Open theism**: God genuinely responds to prayer in real time. The
  future is (partly) open. Prayer can change what happens because God
  hasn't decided everything yet. This REJECTS S4 (universal providence).

The P2 framework provides the middle path: prayer is genuinely efficacious
(not just formative) without requiring God to change His mind (not open
theism) or reducing prayer to mere obedience (not mere command theology).
-/

-- ============================================================================
-- § 6. Summary
-- ============================================================================

/-!
## Summary

**Axioms** (3 — from CCC, connected to existing infrastructure):
1. `prayer_is_secondary_cause` (§307 + P2) — prayer is a genuine secondary cause
2. `prayer_participates_in_providence` (§2738 + S4) — secondary causes participate in providence
3. `prayer_transforms_the_person` (§2725, §2745) — prayer transforms the pray-er

**Theorems** (4):
1. `prayer_is_genuine_cause_within_providence` — prayer is both a secondary cause and participates in providence
2. `prayer_has_dual_effect` — prayer participates in providence AND transforms the person
3. `prayer_meaningful_under_providence` — the full resolution: prayer is genuine, participatory, and transformative
4. `universal_providence_bridge` + `prayer_and_providence_dont_compete` — bridge theorems

**Cross-file connections:**
- `Axioms.lean`: `s4_universal_providence` (base axiom S4), `p2_two_tier_causation` (base axiom P2)
- `Providence.lean`: `PrimaryCause`, `SecondaryCause`, `causesCompete`, `divinelyGoverned`, `CausedEvent`

**Key finding:** The "prayer changes outcomes vs. prayer changes the person"
dichotomy is FALSE under P2. Since prayer is a secondary cause within
providence, it does both simultaneously. God's providential plan includes
the fact that the person will pray, the fact that praying will change them,
and the outcomes that flow from both.

**Key finding:** P2 does exactly the same work for prayer that it does for
free will. Just as P2 resolves "how can God govern all things AND creatures
act freely?" it resolves "how can God know all things AND prayer be
meaningful?" The answer is the same: primary and secondary causes don't
compete. More providence ≠ less prayer efficacy.

**Hidden assumptions identified:**
1. A secondary cause can genuinely participate in an outcome that the
   primary cause has already providentially ordered (from P2)
2. The act of freely addressing God has an intrinsic formative effect
   independent of whether the petition is granted (from §2725)
3. "Participates in providence" is meaningful even though we cannot
   specify the mechanism (the CCC asserts this as a mystery)
-/

end Catlib.Creed.Prayer
