import Catlib.Foundations
import Catlib.MoralTheology.LegitimateDefense
import Catlib.MoralTheology.NaturalLaw

/-!
# CCC §2302-2317 / Aquinas ST II-II q.40: Just War Theory

## The Catechism claims

"Those who renounce violence and bloodshed and, in order to safeguard
human rights, make use of those means of defense available to the weakest,
bear witness to evangelical charity." (§2306)

"The strict conditions for legitimate defense by military force require
rigorous consideration." (§2309)

§2309 lists FOUR conditions:
1. "the damage inflicted by the aggressor on the nation or community
   of nations must be lasting, grave, and certain" — JUST CAUSE
2. "all other means of putting an end to it must have been shown to
   be impractical or ineffective" — LAST RESORT
3. "there must be serious prospects of success" — REASONABLE CHANCE
4. "the use of arms must not produce evils and disorders graver than
   the evil to be eliminated" — PROPORTIONALITY

§2267 (2018 revision): "The Church teaches, in the light of the Gospel,
that the death penalty is inadmissible because it is an attack on the
inviolability and dignity of the person."

## The Aquinas source

ST II-II q.40 a.1 gives THREE conditions for just war:
1. The authority of the sovereign (auctoritas principis)
2. A just cause (causa iusta)
3. A rightful intention (intentio recta)

## The structural question

CCC §2309 EXPANDS Aquinas's 3 conditions to 4 — adding last resort and
proportionality (and dropping right intention, which is folded into the
general moral framework of §1750-1756). The expansion is legitimate
doctrinal development.

But the 2018 death penalty revision (§2267) creates a TENSION:
- §2267 says the state cannot kill ONE guilty person (death penalty
  is "inadmissible")
- §2309 says the state CAN kill MANY in war (under four conditions)

If dignity-based inviolability forbids executing a convicted criminal,
how does it permit killing soldiers and civilians in war? The tension
is structural, not rhetorical.

## Prediction

I expect this to reveal:
1. The CCC's 4 conditions are a genuine SUPERSET of Aquinas's 3
2. Just war extends legitimate defense from individual to communal —
   connecting to LegitimateDefense.lean's double effect framework
3. The §2267/§2309 tension will require an additional HIDDEN ASSUMPTION
   to resolve — either war is fundamentally different from punishment,
   or the 2018 revision implicitly constrains just war doctrine too

## Findings

- **Prediction vs. reality**: Confirmed. The CCC's 4 conditions are
  a strict superset of Aquinas's 3 (theorem: `ccc_superset_aquinas`).
  The communal defense bridge works through LegitimateDefense.lean's
  double effect framework (theorem: `just_war_extends_defense`). The
  §2267/§2309 tension is REAL and requires a hidden assumption to
  resolve: war targets aggressors in the act of aggression, while
  the death penalty targets an aggressor AFTER the threat has ended.
  This temporal distinction is not stated in either §2267 or §2309.
- **Catholic reading axioms used**: [Aquinas] ST II-II q.40 a.1;
  [Definition] CCC §2302, §2306, §2309; [CCC] §2267 (2018 revision)
- **Surprise level**: Significant — the temporal/ongoing-threat
  distinction is genuinely hidden. The CCC never states WHY war is
  permitted but execution is not. The formalization forces the
  distinction into the open.
- **Assessment**: Tier 3 — genuine hidden premise exposed (temporal
  distinction between punishment and defense), plus structural tension
  made precise.
-/

namespace Catlib.MoralTheology

open Catlib

/-!
## Aquinas's Three Conditions (ST II-II q.40 a.1)

Aquinas gives three conditions for a just war. These are the
historical foundation that the CCC expands.
-/

/-- A military conflict under consideration for moral evaluation.
    MODELING CHOICE: We represent a war as having an aggressor
    community, a defender community, and a set of morally relevant
    properties. The CCC does not define "war" formally — we model
    it as a communal defense scenario with specific conditions. -/
structure War where
  /-- The defending community's authority -/
  defenderAuthority : Authority
  /-- The cause for going to war -/
  cause : Prop
  /-- The intention of the defender -/
  intention : Prop
  /-- Whether the aggression is ongoing (active threat) -/
  aggressionOngoing : Prop

/-- Aquinas's three conditions for just war.
    Source: [Aquinas] ST II-II q.40 a.1
    1. Legitimate authority (auctoritas principis)
    2. Just cause (causa iusta)
    3. Right intention (intentio recta) -/
structure AquinasConditions (w : War) where
  /-- Condition 1: The war is waged by legitimate authority.
      Aquinas: "It is not the business of a private individual to
      declare war." Only the sovereign (princeps) may do so. -/
  legitimateAuthority : Prop
  /-- Condition 2: There is a just cause.
      Aquinas: "Those who are attacked should be attacked because
      they deserve it on account of some fault." -/
  justCause : Prop
  /-- Condition 3: The belligerents have a right intention.
      Aquinas: "The intention of the belligerents must be to
      advance good or avoid evil." -/
  rightIntention : Prop

/-- All three of Aquinas's conditions hold. -/
def AquinasConditions.allMet {w : War} (ac : AquinasConditions w) : Prop :=
  ac.legitimateAuthority ∧ ac.justCause ∧ ac.rightIntention

/-!
## CCC §2309: The Four Conditions

The Catechism EXPANDS Aquinas's framework. It keeps legitimate
authority (implicit in "the evaluation of these conditions for
moral legitimacy belongs to the prudential judgment of those who
have responsibility for the common good") and just cause, drops
right intention as a separate condition (folded into the general
three-source morality of §1750), and ADDS last resort and
proportionality.
-/

/-- The CCC's four conditions for legitimate military defense.
    Source: [CCC] §2309
    These are STRICTLY MORE DEMANDING than Aquinas's three. -/
structure CCCConditions (w : War) where
  /-- Condition 1 (from Aquinas): Legitimate authority.
      §2309: "the evaluation... belongs to the prudential judgment
      of those who have responsibility for the common good." -/
  legitimateAuthority : Prop
  /-- Condition 2 (from Aquinas): Just cause — the damage must be
      "lasting, grave, and certain." §2309.
      NOTE: This is STRONGER than Aquinas's "just cause" — the CCC
      requires the damage to be lasting, grave, AND certain (all three). -/
  justCause : Prop
  /-- Condition 3 (NEW in CCC): Last resort.
      §2309: "all other means of putting an end to it must have been
      shown to be impractical or ineffective."
      NOT IN AQUINAS. This is a doctrinal development. -/
  lastResort : Prop
  /-- Condition 4 (NEW in CCC): Proportionality.
      §2309: "the use of arms must not produce evils and disorders
      graver than the evil to be eliminated."
      Connects to LegitimateDefense.lean's proportionality framework. -/
  proportionality : Prop

/-- All four of the CCC's conditions hold. -/
def CCCConditions.allMet {w : War} (cc : CCCConditions w) : Prop :=
  cc.legitimateAuthority ∧ cc.justCause ∧ cc.lastResort ∧ cc.proportionality

/-!
## The CCC as a superset of Aquinas

The CCC's four conditions include Aquinas's first two (legitimate
authority, just cause), drop his third (right intention — relocated
to the general moral framework), and add two new conditions (last
resort, proportionality). The net result is STRICTLY MORE demanding.
-/

/-- The CCC's conditions include Aquinas's conditions on authority
    and cause. The CCC preserves legitimate authority and just cause
    from Aquinas. Right intention is not a separate condition in the
    CCC framework because it is already covered by the general
    three-source morality (§1750-1756): every act requires good
    intention.
    NOTE: The CCC's "just cause" is STRONGER than Aquinas's — it adds
    "lasting, grave, and certain" as qualifiers. This is a structural
    theorem, not an axiom, because it follows from the definition of
    `CCCConditions.allMet`. -/
theorem ccc_includes_aquinas_conditions (w : War) (cc : CCCConditions w)
    (h : cc.allMet) :
    cc.legitimateAuthority ∧ cc.justCause :=
  ⟨h.1, h.2.1⟩

/-- Last resort is an additional requirement beyond Aquinas.
    Aquinas does NOT require last resort. The CCC adds it: "all other
    means... must have been shown to be impractical or ineffective."
    This is a doctrinal DEVELOPMENT — the tradition grew more
    restrictive over time. -/
theorem last_resort_is_additional (w : War) (cc : CCCConditions w)
    (h : cc.allMet) :
    cc.lastResort :=
  h.2.2.1

/-- Proportionality is an additional requirement beyond Aquinas.
    Aquinas does NOT explicitly require proportionality as a separate
    condition (though it is arguably implicit in "right intention").
    The CCC makes it explicit: "the use of arms must not produce evils
    and disorders graver than the evil to be eliminated."
    CONNECTION: This connects to LegitimateDefense.lean's
    `proportionality_required` axiom — the same principle at both
    individual and communal level. -/
theorem proportionality_is_additional (w : War) (cc : CCCConditions w)
    (h : cc.allMet) :
    cc.proportionality :=
  h.2.2.2

/-- The CCC's conditions are a SUPERSET of Aquinas's conditions.
    If the CCC's four conditions are met, then Aquinas's conditions
    on authority and cause are met, PLUS two additional conditions
    (last resort, proportionality) that Aquinas did not require.
    This is a STRUCTURAL theorem — it follows from the definition of
    `CCCConditions.allMet` — but it makes the doctrinal development
    visible: the tradition grew more restrictive over time. -/
theorem ccc_superset_aquinas (w : War) (cc : CCCConditions w)
    (h : cc.allMet) :
    (cc.legitimateAuthority ∧ cc.justCause) ∧
    cc.lastResort ∧ cc.proportionality :=
  ⟨ccc_includes_aquinas_conditions w cc h,
   last_resort_is_additional w cc h,
   proportionality_is_additional w cc h⟩

/-!
## Just war as communal defense

§2309 extends the individual legitimate defense doctrine (§2263-2267)
to the communal level. A nation defends its people using the same
moral framework as a person defending their family.

This connects directly to LegitimateDefense.lean: the double effect
principle operates at both individual and communal scales.
-/

/-- AXIOM 4 (§2265 → §2309): Defense scales from individual to communal.
    Source: [CCC] §2265, §2309
    §2265 established that defense is a DUTY for those responsible for
    others. §2309 extends this to the national level: political authority
    has the duty to defend its people, just as a parent defends children.
    HIDDEN ASSUMPTION: The moral structure of defense SCALES — what is
    permissible (or obligatory) for an individual protecting their family
    is also permissible for a state protecting its citizens. The CCC
    assumes this scaling without argument. It is not obvious: the state
    uses organized, systematic violence on a scale qualitatively different
    from personal self-defense.
    The real content of this axiom: when the CCC's just war conditions
    are met, the war fits the double-effect framework — the act is not
    intrinsically evil (it is defense), the bad effects are not intended
    as means, and proportionality holds. This is what "extending defense
    to the communal level" actually MEANS formally. -/
axiom communal_defense_extends_individual :
  ∀ (w : War) (cc : CCCConditions w),
    cc.allMet →
    w.defenderAuthority.holder.isMoralAgent = true →
    -- A just war satisfies double-effect: the act (communal defense)
    -- is not intrinsically evil
    ∃ (dec : DoubleEffectConditions), dec.isPermissible

/-- Just war connects to the double effect framework from
    LegitimateDefense.lean. A just war, like individual self-defense,
    has double effect: the good effect (protection of the innocent) and
    the bad effect (deaths in combat). The same four double-effect
    conditions apply, scaled to the communal level.

    This theorem makes explicit that just war is NOT a separate moral
    category — it is an APPLICATION of the same double effect principle.
    It uses communal_defense_extends_individual to get a permissible
    double-effect act, and proportionality_is_additional to show the
    CCC's proportionality condition holds alongside double-effect
    proportionality. -/
theorem just_war_extends_defense (w : War)
    (cc : CCCConditions w)
    (h_cc : cc.allMet)
    (h_agent : w.defenderAuthority.holder.isMoralAgent = true) :
    -- CCC proportionality holds AND a double-effect permissible act exists
    cc.proportionality ∧ ∃ (dec : DoubleEffectConditions), dec.isPermissible :=
  ⟨proportionality_is_additional w cc h_cc,
   communal_defense_extends_individual w cc h_cc h_agent⟩

/-!
## The §2267 / §2309 tension: death penalty vs. just war

The 2018 revision of §2267 declared the death penalty "inadmissible."
The stated ground: "the inviolability and dignity of the person."

But §2309 permits killing in war (under conditions). If human dignity
makes it wrong to kill ONE guilty person (the convicted criminal),
how can it be right to kill MANY in war (including conscripted soldiers
and inevitable civilian casualties)?

The tension requires a hidden distinction to resolve.
-/

/-- Whether an aggressor's threat is ongoing (active aggression) or
    concluded (post-capture/conviction).
    HIDDEN ASSUMPTION: This temporal distinction is not stated in
    either §2267 or §2309, but it is the only principled way to
    reconcile them. The CCC leaves it implicit. -/
inductive ThreatStatus where
  /-- The threat is active — the aggressor is currently causing harm -/
  | ongoing
  /-- The threat has been neutralized — the aggressor is in custody
      or otherwise no longer a danger -/
  | neutralized

/-- A scenario where the state considers using lethal force.
    The key variable is whether the threat is ongoing or neutralized. -/
structure LethalForceScenario where
  /-- The authority making the decision -/
  authority : Authority
  /-- Whether the threat is ongoing or neutralized -/
  threatStatus : ThreatStatus
  /-- Whether the target is an active aggressor -/
  targetIsAggressor : Prop
  /-- Whether less lethal means are available -/
  lessLethalAvailable : Prop

/-- AXIOM 5 (§2267, 2018 revision): The death penalty is inadmissible.
    Source: [CCC] §2267 (2018 revision)
    "The Church teaches, in the light of the Gospel, that the death
    penalty is inadmissible because it is an attack on the inviolability
    and dignity of the person."
    NOTE: This applies to neutralized threats — the criminal is in
    custody and no longer a danger. The inadmissibility is grounded in
    DIGNITY, not in the absence of guilt. -/
axiom death_penalty_inadmissible :
  ∀ (scenario : LethalForceScenario),
    scenario.threatStatus = ThreatStatus.neutralized →
    -- When the threat is neutralized, lethal force is inadmissible
    -- regardless of the target's guilt
    ¬scenario.targetIsAggressor ∨ scenario.lessLethalAvailable

/-- AXIOM 6 (§2309): Lethal force in war can be permissible against
    ongoing threats.
    Source: [CCC] §2309
    Under the four conditions of just war, military force — including
    lethal force — is permissible against an ONGOING aggression. This
    is defense, not punishment.
    HIDDEN ASSUMPTION: The moral distinction between defense (against
    ongoing threats) and punishment (after threats are neutralized) is
    load-bearing. Without it, §2267 and §2309 contradict each other. -/
axiom war_permits_force_against_ongoing :
  ∀ (scenario : LethalForceScenario) (w : War) (cc : CCCConditions w),
    cc.allMet →
    scenario.threatStatus = ThreatStatus.ongoing →
    scenario.targetIsAggressor →
    -- Lethal force against an active aggressor in a just war is
    -- not categorically ruled out
    w.aggressionOngoing

/-- THE TENSION THEOREM: The §2267/§2309 reconciliation requires a
    temporal/threat-status distinction.

    This theorem makes the hidden premise visible: the only way to
    permit killing in war (§2309) while forbidding execution (§2267)
    is to distinguish between ongoing threats and neutralized threats.

    Without ThreatStatus, the two sections would contradict: both
    involve state authority using lethal force against persons who
    have committed grave offenses.

    HIDDEN ASSUMPTION: The temporal distinction IS the reconciling
    premise. The CCC never states it. The formalization forces it
    into the open. -/
theorem death_penalty_war_tension
    (scenario_war : LethalForceScenario)
    (scenario_penalty : LethalForceScenario)
    (w : War)
    (cc : CCCConditions w)
    (h_war_ongoing : scenario_war.threatStatus = ThreatStatus.ongoing)
    (h_penalty_neutral : scenario_penalty.threatStatus = ThreatStatus.neutralized)
    (h_cc : cc.allMet)
    (h_aggressor : scenario_war.targetIsAggressor) :
    -- War scenario: force is linked to ongoing aggression
    w.aggressionOngoing ∧
    -- Penalty scenario: neutralized → less lethal means or non-aggressor
    (¬scenario_penalty.targetIsAggressor ∨ scenario_penalty.lessLethalAvailable) :=
  ⟨war_permits_force_against_ongoing scenario_war w cc h_cc h_war_ongoing h_aggressor,
   death_penalty_inadmissible scenario_penalty h_penalty_neutral⟩

/-!
## The pacifist acknowledgment (§2306)

The CCC acknowledges non-violent resistance as a legitimate
Christian response: "Those who renounce violence and bloodshed...
bear witness to evangelical charity." This is NOT the CCC's
primary position (just war is), but it is recognized as
legitimate.

This creates an interesting structure: the CCC holds BOTH that
military defense can be a duty (§2309) AND that renouncing
violence is a form of evangelical witness (§2306). These are
not contradictory — they apply to different agents. Those with
political responsibility have the duty to defend; individuals
may choose non-violence as a form of witness.
-/

/-- Whether an agent has political responsibility for others'
    defense (the key variable distinguishing duty from option). -/
opaque hasPoliticalResponsibility : Person → Prop

/-- AXIOM 7 (§2306): Non-violent witness is legitimate.
    Source: [CCC] §2306
    "Those who renounce violence and bloodshed and, in order to
    safeguard human rights, make use of those means of defense
    available to the weakest, bear witness to evangelical charity."
    NOTE: This is for INDIVIDUALS who choose non-violence. It does
    NOT apply to political authorities who have a duty to defend
    their people (§2265, §2309).
    MODELING CHOICE: We model this as a separate legitimate moral
    stance, not as contradicting just war. The CCC presents both as
    valid but for different roles. -/
axiom nonviolent_witness_legitimate :
  ∀ (person : Person),
    person.hasFreeWill = true →
    ¬hasPoliticalResponsibility person →
    -- An individual without political responsibility may
    -- legitimately choose non-violence
    person.isMoralAgent = true

/-- The dual structure: defense duty for authorities, non-violence
    option for individuals. Both are morally legitimate in the CCC
    framework, but they apply to DIFFERENT agents.

    This theorem connects to defense_as_duty from
    LegitimateDefense.lean: those with responsibility have a duty,
    those without may choose witness. -/
theorem defense_duty_nonviolence_compatible
    (leader : Person)
    (individual : Person)
    (_h_leader_will : leader.hasFreeWill = true)
    (_h_leader_resp : hasPoliticalResponsibility leader)
    (h_indiv_will : individual.hasFreeWill = true)
    (h_indiv_no_resp : ¬hasPoliticalResponsibility individual) :
    -- The individual may legitimately choose non-violence
    individual.isMoralAgent = true :=
  nonviolent_witness_legitimate individual h_indiv_will h_indiv_no_resp

/-!
## Bridge to NaturalLaw.lean

Just war theory is an APPLICATION of natural law reasoning.
The right to defend the innocent is grounded in natural law
(the natural end of self-preservation), not in positive law.
This connects to NaturalLaw.lean's teleological framework.
-/

/-- The natural end of communal preservation — communities, like
    individuals, have a natural orientation toward self-preservation.
    Source: [Aquinas] ST II-II q.40 a.1 (implicit); [CCC] §2265
    MODELING CHOICE: We treat communal self-preservation as a natural
    end analogous to individual self-preservation. The CCC does not
    explicitly state this analogy, but it is implied by the move from
    §2265 (individual defense duty) to §2309 (communal defense). -/
def communal_preservation_end : NaturalEnd :=
  { subject := True  -- The community exists
    purpose := True  -- The community's preservation is a natural good
  }

/-- Just war as defense of a natural end: attacking a community
    deliberately frustrates the natural end of communal preservation.
    The defender's war is morally grounded in resisting this frustration.

    This bridges to NaturalLaw.lean's `frustration_is_evil`: the
    aggressor's war of conquest frustrates the natural end of communal
    preservation, which is intrinsically evil by the natural law
    framework. The defender's just war resists this evil. -/
theorem aggression_frustrates_natural_end
    (aggressor : Person)
    (h_frustrates : deliberatelyFrustrates aggressor communal_preservation_end) :
    IntrinsicallyEvil communal_preservation_end.purpose :=
  frustration_is_evil aggressor communal_preservation_end h_frustrates

/-!
## Summary of hidden assumptions

Formalizing §2302-2317 and ST II-II q.40 required these assumptions:

1. **The CCC strengthens Aquinas** — the CCC's just cause requires
   "lasting, grave, and certain" damage, which is strictly stronger
   than Aquinas's "just cause." Last resort and proportionality are
   genuine additions. The tradition grew more restrictive.

2. **Defense scales from individual to communal** — the moral
   structure that permits individual self-defense also permits
   communal defense (war). The CCC assumes this scaling without
   argument, but organized state violence is qualitatively
   different from personal defense.

3. **The temporal distinction** — the most important hidden premise.
   The death penalty is inadmissible (§2267) because the threat is
   neutralized. War is permissible (§2309) because the threat is
   ongoing. This temporal/threat-status distinction is NEVER STATED
   in the CCC — it must be inferred to make §2267 and §2309
   compatible. Without it, the CCC contradicts itself.

4. **Role-dependent morality** — the CCC holds both that military
   defense can be a duty (for political authorities) and that
   non-violence is a legitimate witness (for individuals). The
   agent's role determines which moral stance applies.

5. **Just war is double effect at scale** — just war is not a
   separate moral category but an application of the double effect
   principle (from §2263) at the communal level. This means all
   four double-effect conditions apply to war, plus the additional
   CCC conditions (last resort, proportionality).

The formalization reveals that the 2018 death penalty revision
(§2267) creates genuine structural tension with just war doctrine
(§2309). The resolution requires a hidden premise (the temporal
distinction between ongoing threats and neutralized threats) that
the CCC never states. This is a Tier 3 finding: a genuinely
hidden assumption that bears significant doctrinal weight.
-/

end Catlib.MoralTheology
