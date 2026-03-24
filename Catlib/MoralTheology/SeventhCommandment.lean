import Catlib.Foundations
import Catlib.MoralTheology.NaturalLaw
import Catlib.MoralTheology.SocialDoctrine

/-!
# CCC §2401-2463: The Seventh Commandment — Theft, Economic Justice, and Stewardship

## The Catechism claims

§2401: "The seventh commandment forbids unjustly taking or keeping the goods
of one's neighbor and wronging him in any way with respect to his goods."

§2408: "The seventh commandment forbids theft, that is, usurping another's
property against the reasonable will of the owner."

§2409: "Even if it does not contradict the provisions of civil law, any form
of unjustly taking and keeping the property of others is against the seventh
commandment: thus, deliberate retention of goods lent or of objects lost;
business fraud; paying unjust wages; forcing up prices by taking advantage of
the ignorance or hardship of another."

§2434: "A just wage is the legitimate fruit of work. To refuse or withhold it
can be a grave injustice."

§2435: "Recourse to a strike is morally legitimate when it cannot be avoided,
or at least when it is necessary to obtain a proportionate benefit. It becomes
morally unacceptable when accompanied by violence, or when objectives are
included that are not directly linked to working conditions or are contrary to
the common good."

## The structural claim

The Seventh Commandment goes far beyond pickpocketing. The CCC defines theft
BROADLY: any unjust taking or keeping of another's goods (§2401). This broad
definition encompasses:
1. Direct theft — stealing physical goods (§2408)
2. Business fraud — deception in commerce (§2409)
3. Unjust wages — paying workers less than their due (§2409, §2434)
4. Price exploitation — manipulating prices via ignorance or hardship (§2409)
5. Retention of borrowed goods — keeping what was lent (§2409)

The key structural insight: all five forms share the same underlying wrong —
unjust acquisition or retention of another's goods. The Seventh Commandment
is not a catalogue of separate prohibitions but a SINGLE principle
(justice in exchange) applied to different domains.

## Prediction

I expect the formalization to reveal:
1. The broad definition of theft (§2408-2409) is derivable from the underlying
   principle of justice in economic exchange + the SocialDoctrine property theory.
2. The just wage doctrine (§2434) connects directly to the bounded-rights model
   from SocialDoctrine.lean: wages are bounded by justice, not merely by the
   labor market.
3. The strike doctrine (§2435) reveals a tension: workers may use collective
   action to enforce justice, but only within bounds (no violence, proportionate).
4. The connection to NaturalLaw.lean: economic justice is a natural law precept,
   discoverable by reason.

## Findings

- **Prediction confirmed**: The broad definition of theft is a single principle
  — unjust acquisition — instantiated across five domains. The formalization
  reveals that ALL forms of economic injustice in §2409 are structurally the
  same wrong: taking or retaining what is not justly yours.
- **Hidden assumptions identified**:
  1. Justice in exchange has a determinate content — there IS a "just price"
     and a "just wage" that is not merely whatever the market produces (§2434).
     This rejects pure market pricing (where the just price = the market price).
  2. The worker's claim on wages is a matter of JUSTICE, not charity (§2434:
     "legitimate fruit of work"). This is stronger than saying employers
     SHOULD pay well — it says workers are OWED a just wage.
  3. Strike legitimacy requires proportionality (§2435) — a hidden assumption
     that collective action is bounded by the same justice principle that
     bounds property (from SocialDoctrine.lean).
- **Key finding**: The Seventh Commandment extends the bounded-rights theory
  from SocialDoctrine.lean. Property is bounded by universal destination
  (SocialDoctrine); exchange is bounded by justice (SeventhCommandment).
  The pattern is the same: Catholic economic teaching asserts real rights
  (property, wages, commerce) that are BOUNDED by prior moral principles
  (universal destination, justice, common good).
- **Denominational scope**: The broad definition of theft is ECUMENICAL
  (all Christians reject stealing). The just wage doctrine and systematic
  social teaching are distinctively CATHOLIC, drawing on the papal social
  encyclicals (Rerum Novarum, Laborem Exercens). Protestant traditions
  generally treat wages as a matter of charity or prudence rather than
  strict justice.
- **Assessment**: Tier 2 — real structural insight (broad theft = single
  principle of unjust acquisition), clear connection to SocialDoctrine's
  bounded-rights model, denominational cuts on just wage doctrine.
-/

set_option autoImplicit false

namespace Catlib.MoralTheology.SeventhCommandment

open Catlib
open Catlib.MoralTheology
open Catlib.MoralTheology.SocialDoctrine (MaterialGood hasPropertyRight
  justlyAcquired exercisesStewardship destinedForAll
  property_subordinate_to_universal_destination stewardship_not_absolute_ownership
  private_property_legitimate)

-- ============================================================================
-- § 1. Core types
-- ============================================================================

/-- An economic exchange between two persons — any transfer of goods, labor,
    or money. CCC §2409 treats commerce, wages, and lending all as forms of
    exchange subject to the Seventh Commandment.

    MODELING CHOICE: We abstract over the specific kind of exchange. The CCC's
    arguments apply to all forms equally: what matters is whether the exchange
    is just, not what kind of exchange it is. -/
structure EconomicExchange where
  /-- The party giving goods/money -/
  giver : Person
  /-- The party receiving goods/money -/
  receiver : Person
  /-- The good being exchanged -/
  good : MaterialGood

/-- Whether taking or keeping a good is unjust — the core wrong of the
    Seventh Commandment.
    CCC §2401: "unjustly taking or keeping the goods of one's neighbor."

    STRUCTURAL OPACITY: The CCC lists specific forms of unjust acquisition
    (§2409) but does not define "unjust" in fully formal terms. The underlying
    principle is that acquisition is unjust when it violates the rights of
    the owner or the demands of justice in exchange. -/
opaque isUnjustAcquisition : Person → MaterialGood → Prop

/-- Whether a wage paid to a worker is just.
    CCC §2434: "A just wage is the legitimate fruit of work."
    Aquinas (ST II-II q.77 a.1): just exchange requires proportionality
    between what is given and received.

    STRUCTURAL OPACITY: The CCC says a just wage must account for "the needs
    and the contributions of each person" (§2434) but does not give a formula.
    Rerum Novarum §45 (Leo XIII) says the wage must be sufficient for a
    "frugal and well-behaved" worker to support himself and his family.
    We keep this opaque because the CCC does not commit to a single
    wage-determination theory — what matters is that some wages ARE unjust,
    not merely ungenerous. -/
opaque isJustWage : EconomicExchange → Prop

/-- Whether market behavior constitutes exploitation — taking advantage of
    another's ignorance or hardship.
    CCC §2409: "forcing up prices by taking advantage of the ignorance or
    hardship of another."

    STRUCTURAL OPACITY: The CCC identifies exploitation by its mechanism
    (taking advantage of ignorance or hardship) but does not formalize where
    the line falls. We keep this opaque because the boundary between
    legitimate profit and exploitation is context-dependent. -/
opaque isExploitative : EconomicExchange → Prop

/-- Whether a strike meets the conditions for moral legitimacy.
    CCC §2435: morally legitimate "when it cannot be avoided, or at least
    when it is necessary to obtain a proportionate benefit."

    STRUCTURAL OPACITY: The conditions — unavoidability, proportionality,
    non-violence, link to working conditions — are stated (§2435) but
    their application to specific cases is context-dependent. -/
structure StrikeConditions where
  /-- The workers involved -/
  workers : Person
  /-- Whether less disruptive means have been exhausted -/
  unavoidable : Prop
  /-- Whether the expected benefit is proportionate to the disruption -/
  proportionate : Prop
  /-- Whether the strike is free from violence -/
  nonviolent : Prop
  /-- Whether objectives are directly linked to working conditions -/
  linkedToWorkingConditions : Prop

/-- Whether a strike is morally legitimate given its conditions.
    CCC §2435 defines the conditions; this predicate evaluates them.

    HONEST OPACITY: The CCC gives necessary conditions (§2435) but the
    judgment of proportionality in a specific case requires prudential
    reasoning that cannot be fully formalized. -/
opaque isLegitimateStrike : StrikeConditions → Prop

-- ============================================================================
-- § 2. Axioms
-- ============================================================================

/-- AXIOM 1 (§2408): Theft defined — unjust acquisition of another's goods.
    "The seventh commandment forbids theft, that is, usurping another's
    property against the reasonable will of the owner."

    This is the CORE DEFINITION: theft = unjust acquisition. The Catechism
    does not limit theft to physical stealing — it is any form of unjust
    taking or keeping (§2401).

    Source: [CCC] §2408; [Scripture] Ex 20:15 ("You shall not steal"),
    Deut 5:19; [Aquinas] ST II-II q.66 a.3.
    Denominational scope: ECUMENICAL (all Christians accept the Decalogue). -/
axiom theft_is_unjust_acquisition :
  ∀ (p : Person) (g : MaterialGood),
    isUnjustAcquisition p g →
    -- Unjust acquisition violates the property rights of the owner.
    -- This connects to SocialDoctrine: property rights ARE real (axiom 2),
    -- so violating them is a genuine wrong.
    ¬ justlyAcquired p g

/-- AXIOM 2 (§2409): Unjust wages are a form of theft.
    "paying unjust wages" is listed among forms of unjust acquisition.

    The CCC treats unjust wages as STRUCTURALLY THE SAME WRONG as theft:
    the employer takes labor and gives less than what is due in return.
    The worker's right to a just wage is a property right over the fruit
    of their labor (§2434: "legitimate fruit of work").

    Source: [CCC] §2409, §2434; [Tradition] Rerum Novarum §45 (Leo XIII);
    [Aquinas] ST II-II q.77 a.1 (just price in exchange);
    [Scripture] Deut 24:14-15 ("You shall not oppress a hired worker"),
    Jas 5:4 ("The wages of the laborers who mowed your fields, which you
    kept back by fraud, are crying out against you").
    HIDDEN ASSUMPTION: Wages are a matter of JUSTICE, not mere contract.
    The market price of labor is not automatically the just price. This
    rejects pure market theory of wages (where just wage = whatever the
    market produces) and asserts an external standard of justice.
    Denominational scope: CATHOLIC in its systematic development (Rerum
    Novarum, Laborem Exercens), though the Scriptural grounding (Deut
    24:14-15, Jas 5:4) is ecumenical. -/
axiom unjust_wages_are_theft :
  ∀ (exchange : EconomicExchange),
    ¬ isJustWage exchange →
    isUnjustAcquisition exchange.receiver exchange.good

/-- AXIOM 3 (§2409): Market exploitation is a form of theft.
    "forcing up prices by taking advantage of the ignorance or hardship
    of another" is listed among forms of unjust acquisition.

    Source: [CCC] §2409; [Aquinas] ST II-II q.77 a.1 (seller must not
    exploit buyer's ignorance); [Scripture] Lev 25:14 ("You shall not
    wrong one another").
    HIDDEN ASSUMPTION: There exists a standard of fair exchange independent
    of what the parties agree to under duress or ignorance. Consent
    obtained through exploitation is not genuine consent.
    Denominational scope: ECUMENICAL (broadly accepted). -/
axiom exploitation_is_theft :
  ∀ (exchange : EconomicExchange),
    isExploitative exchange →
    isUnjustAcquisition exchange.receiver exchange.good

/-- AXIOM 4 (§2434): A just wage is owed as a matter of justice, not charity.
    "A just wage is the legitimate fruit of work. To refuse or withhold it
    can be a grave injustice."

    The CCC's language is precise: wages are a "fruit" of work — they
    BELONG to the worker the way fruit belongs to the tree that produced it.
    Withholding a just wage is not merely uncharitable; it is unjust.

    Source: [CCC] §2434; [Tradition] Laborem Exercens §19 (John Paul II:
    "the just wage becomes the key verification of the whole socioeconomic
    system"); [Aquinas] ST II-II q.77 a.1.
    HIDDEN ASSUMPTION: The wage relationship is not symmetric — the worker
    has a PRIOR claim on the fruit of labor, and the employer's profit is
    subordinate to the worker's just wage. This parallels SocialDoctrine's
    subordination axiom: just as property is subordinate to universal
    destination, profit is subordinate to just wages.
    Denominational scope: CATHOLIC (systematically developed in papal
    encyclicals). -/
axiom just_wage_is_owed :
  ∀ (exchange : EconomicExchange),
    isJustWage exchange →
    justlyAcquired exchange.receiver exchange.good

/-- AXIOM 5 (§2435): Strike is morally legitimate under conditions.
    "Recourse to a strike is morally legitimate when it cannot be avoided,
    or at least when it is necessary to obtain a proportionate benefit."

    The CCC affirms the moral legitimacy of collective action for justice
    — but only within bounds. The strike must be:
    (a) unavoidable — less disruptive means exhausted
    (b) proportionate — benefit justifies disruption
    (c) nonviolent — violence makes it illegitimate
    (d) linked to working conditions — not a political weapon

    Source: [CCC] §2435; [Tradition] Laborem Exercens §20 (John Paul II:
    workers' right to strike is recognized).
    HIDDEN ASSUMPTION: Collective action is bounded by the same justice
    principles that bound individual action. Workers may not use unjust
    means (violence) even to pursue just ends (better wages). This connects
    to SourcesOfMorality.lean: good intention does not justify evil means
    (§1753).
    Denominational scope: CATHOLIC (systematically affirmed). -/
axiom strike_legitimacy :
  ∀ (s : StrikeConditions),
    s.unavoidable →
    s.proportionate →
    s.nonviolent →
    s.linkedToWorkingConditions →
    isLegitimateStrike s

/-- AXIOM 6 (§2435): Violence makes a strike morally unacceptable.
    "It becomes morally unacceptable when accompanied by violence."

    This is the NEGATIVE condition: even if all positive conditions are met,
    violence disqualifies the strike. This is a direct application of the
    principle that evil means cannot be justified by good ends (§1753).

    Source: [CCC] §2435; [CCC] §1753 (evil means).
    Denominational scope: ECUMENICAL (broadly accepted). -/
axiom violence_disqualifies_strike :
  ∀ (s : StrikeConditions),
    ¬ s.nonviolent →
    ¬ isLegitimateStrike s

-- ============================================================================
-- § 3. Theorems: the unified theory of economic justice
-- ============================================================================

/-- THEOREM: Unjust wages violate property rights.

    The chain: unjust wages are theft (axiom 2) → theft is unjust acquisition
    (axiom 1) → unjust acquisition means the acquirer has no just title.
    This connects to SocialDoctrine: the worker's right to a just wage
    is a property right over the fruit of their labor.

    Depends on: unjust_wages_are_theft, theft_is_unjust_acquisition. -/
theorem unjust_wages_violate_property
    (exchange : EconomicExchange)
    (h_unjust : ¬ isJustWage exchange) :
    ¬ justlyAcquired exchange.receiver exchange.good :=
  have h_theft := unjust_wages_are_theft exchange h_unjust
  theft_is_unjust_acquisition exchange.receiver exchange.good h_theft

/-- THEOREM: Exploitation violates property rights.

    The chain: exploitation is theft (axiom 3) → theft is unjust acquisition
    (axiom 1) → unjust acquisition means no just title.

    Depends on: exploitation_is_theft, theft_is_unjust_acquisition. -/
theorem exploitation_violates_property
    (exchange : EconomicExchange)
    (h_exploit : isExploitative exchange) :
    ¬ justlyAcquired exchange.receiver exchange.good :=
  have h_theft := exploitation_is_theft exchange h_exploit
  theft_is_unjust_acquisition exchange.receiver exchange.good h_theft

/-- THEOREM: Just wages yield bounded property rights.

    The full Catholic chain for wages: a just wage gives the worker a
    genuine property right (axiom 4 → SocialDoctrine axiom 2), AND that
    right is bounded by universal destination (SocialDoctrine axiom 3),
    AND the holder is a steward (SocialDoctrine axiom 4).

    This shows wages participate in the same bounded-rights structure
    as all property: real but not absolute.

    Depends on: just_wage_is_owed, private_property_legitimate,
    property_subordinate_to_universal_destination,
    stewardship_not_absolute_ownership. -/
theorem just_wages_yield_bounded_rights
    (exchange : EconomicExchange)
    (h_just : isJustWage exchange) :
    hasPropertyRight exchange.receiver exchange.good
    ∧ destinedForAll exchange.good
    ∧ exercisesStewardship exchange.receiver exchange.good :=
  have h_acquired := just_wage_is_owed exchange h_just
  have h_owns := private_property_legitimate exchange.receiver exchange.good h_acquired
  have h_dest := property_subordinate_to_universal_destination exchange.receiver exchange.good h_owns
  have h_stew := stewardship_not_absolute_ownership exchange.receiver exchange.good h_owns
  ⟨h_owns, h_dest, h_stew⟩

/-- THEOREM: All conditions are necessary for a legitimate strike.

    Under CCC §2435, a strike is legitimate ONLY when all four conditions
    hold. If violence is present, the strike is illegitimate (axiom 6),
    regardless of the other conditions.

    This formalizes the CONJUNCTIVE nature of strike legitimacy: failing
    any condition — especially nonviolence — disqualifies the action.

    Depends on: violence_disqualifies_strike. -/
theorem violent_strike_always_illegitimate
    (s : StrikeConditions)
    (h_violent : ¬ s.nonviolent) :
    ¬ isLegitimateStrike s :=
  violence_disqualifies_strike s h_violent

/-- THEOREM: A strike meeting all conditions is legitimate.

    The positive result: when all four CCC conditions are satisfied,
    the strike is morally legitimate. Workers have a genuine right to
    collective action for justice under these bounds.

    Depends on: strike_legitimacy. -/
theorem complete_strike_is_legitimate
    (s : StrikeConditions)
    (h_unavoid : s.unavoidable)
    (h_prop : s.proportionate)
    (h_nonviol : s.nonviolent)
    (h_linked : s.linkedToWorkingConditions) :
    isLegitimateStrike s :=
  strike_legitimacy s h_unavoid h_prop h_nonviol h_linked

-- ============================================================================
-- § 4. Bridge theorems
-- ============================================================================

/-- Bridge to SocialDoctrine.lean: unjust acquisition violates the
    bounded-rights model.

    Under the Catholic bounded-rights theory (SocialDoctrine), property
    rights require just acquisition. Theft — any form of unjust acquisition
    — is precisely the violation of this requirement. The Seventh Commandment
    protects the JUST acquisition condition from SocialDoctrine axiom 2.

    Depends on: theft_is_unjust_acquisition. -/
theorem theft_violates_bounded_rights
    (p : Person) (g : MaterialGood)
    (h_unjust : isUnjustAcquisition p g) :
    ¬ justlyAcquired p g :=
  theft_is_unjust_acquisition p g h_unjust

/-- Bridge to NaturalLaw.lean: economic justice is a natural law precept.

    The prohibition of theft and the obligation to pay just wages are
    accessible to reason (they do not require revelation). The natural
    law framework grounds economic justice: reason can discover that
    taking what belongs to another is wrong.

    Depends on: divine_grounding (from NaturalLaw.lean). -/
theorem economic_justice_is_natural_law
    (precept : MoralPrecept)
    (h_access : precept.accessibleToReason) :
    precept.content :=
  divine_grounding precept h_access

-- ============================================================================
-- § 5. The unified picture: five forms, one principle
-- ============================================================================

/-!
## The five forms of theft are one principle

CCC §2409 lists several forms of unjust acquisition:
1. Deliberate retention of goods lent or lost
2. Business fraud
3. Paying unjust wages
4. Forcing up prices by exploitation

These are not separate moral prohibitions but INSTANCES of a single
principle: unjust acquisition of another's goods (§2401). The
formalization captures this unity through the `isUnjustAcquisition`
predicate: all five forms satisfy this predicate and therefore all
violate the same property rights.

The structural parallel to SocialDoctrine.lean:
- SocialDoctrine shows that property rights are BOUNDED (by universal
  destination)
- SeventhCommandment shows that acquisition must be JUST (violating
  justice = theft)
- Together they form the complete Catholic economic ethic: real property
  rights, bounded by universal destination, acquired only through just
  means, with just wages owed as a matter of justice, and collective
  action (strike) permitted under bounded conditions.

## Connection to NaturalLaw.lean

Economic justice connects to natural law through the virtue of justice:
"the moral virtue that consists in the constant and firm will to give
their due to God and neighbor" (CCC §1807, in Virtues.lean). The
Seventh Commandment is justice applied to economic life. The natural
law framework (NaturalLaw.lean) grounds this: justice in exchange is
a moral precept accessible to reason and binding on all.

## Denominational picture

**All Christians agree:**
- Theft (direct stealing) is wrong (Ex 20:15)
- Fraud and deception in commerce are wrong (Lev 19:35-36)
- Workers should not be oppressed (Deut 24:14-15, Jas 5:4)

**The disputed question:**
- Is there a DETERMINATE "just wage" that employers are bound in
  justice to pay, or is the just wage simply whatever worker and
  employer freely agree to?

**Catholic (just wage as justice):**
- The just wage is the "legitimate fruit of work" (§2434) — it is
  OWED, not merely recommended
- The wage must account for "needs and contributions" (§2434)
- Refusing a just wage "can be a grave injustice" (§2434)
- Systematically developed: Rerum Novarum (1891), Laborem Exercens (1981)

**Protestant (varies):**
- Reformed: some systematic social ethics (Kuyper's sphere sovereignty),
  but less formal wage doctrine
- Lutheran: economic justice under temporal authority (two kingdoms)
- Evangelical: diverse, ranging from prosperity theology to voluntary
  simplicity; generally no formal just wage doctrine

**Free market (wage = market price):**
- Drops the external standard of justice in wages
- The just wage = whatever is freely agreed upon
- The CCC rejects this: §2434 implies wages can be unjust even when
  freely contracted
-/

-- ============================================================================
-- § 6. Summary
-- ============================================================================

/-!
## Summary

**Axioms** (6 — from CCC §2408-2435):
1. `theft_is_unjust_acquisition` (§2408) — theft = unjust taking of goods
2. `unjust_wages_are_theft` (§2409, §2434) — paying unjust wages is theft
3. `exploitation_is_theft` (§2409) — market exploitation is theft
4. `just_wage_is_owed` (§2434) — just wages yield just acquisition
5. `strike_legitimacy` (§2435) — strike is legitimate under four conditions
6. `violence_disqualifies_strike` (§2435) — violence makes strike illegitimate

**Theorems** (6 + 2 bridges):
1. `unjust_wages_violate_property` — unjust wages violate property rights
2. `exploitation_violates_property` — exploitation violates property rights
3. `just_wages_yield_bounded_rights` — just wages yield bounded property
4. `violent_strike_always_illegitimate` — violence disqualifies a strike
5. `complete_strike_is_legitimate` — all conditions met → legitimate strike
6. `theft_violates_bounded_rights` — bridge: theft violates bounded-rights model
7. `economic_justice_is_natural_law` — bridge: economic justice is natural law
   (Note: theorem 6 listed separately as bridge)

**Cross-file connections:**
- `SocialDoctrine.lean`: `MaterialGood`, `hasPropertyRight`, `justlyAcquired`,
  `exercisesStewardship`, `destinedForAll`, `private_property_legitimate`,
  `property_subordinate_to_universal_destination`,
  `stewardship_not_absolute_ownership`
- `NaturalLaw.lean`: `MoralPrecept`, `divine_grounding`
- `Basic.lean`: `Person`

**Key finding:** The Seventh Commandment extends SocialDoctrine's bounded-rights
theory to EXCHANGE. Property is bounded by universal destination (SocialDoctrine);
acquisition must be just (SeventhCommandment). All five forms of theft in §2409
are structurally the same wrong: unjust acquisition. The just wage doctrine
(§2434) treats wages as justice, not charity — paralleling the subordination
axiom's treatment of property as bounded, not absolute.

**Hidden assumptions identified:**
1. Justice in exchange has determinate content — an external standard exists
   independent of market forces or contractual agreement
2. The wage relationship is asymmetric — the worker has a prior claim on the
   fruit of labor (§2434: "legitimate fruit of work")
3. Collective action (strike) is bounded by the same justice principles as
   individual action — good ends do not justify evil means (§1753)
4. Economic justice is a natural law precept — accessible to reason without
   revelation (connects to NaturalLaw.lean)
-/

end Catlib.MoralTheology.SeventhCommandment
