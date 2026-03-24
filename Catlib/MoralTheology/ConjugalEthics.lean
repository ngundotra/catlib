import Catlib.Foundations
import Catlib.MoralTheology.SourcesOfMorality
import Catlib.MoralTheology.LegitimateDefense
import Catlib.MoralTheology.NaturalLaw

/-!
# CCC §2366-2372: Conjugal Ethics

## The Catechism claims

"Each and every marital act must of necessity retain its intrinsic
relationship to the procreation of human life." (§2366, citing
Humanae Vitae §11)

"For just reasons, spouses may wish to space the births of their
children. It is their duty to make certain that their desire is not
motivated by selfishness." (§2368)

"Periodic continence, that is, the methods of birth regulation based on
self-observation and the use of infertile periods, is in conformity with
the objective criteria of morality... Every action which... proposes,
whether as an end or as a means, to render procreation impossible is
intrinsically evil." (§2370, citing Humanae Vitae §14, §16)

"The political authority... has no right to intervene... by encouraging
the use of methods of birth regulation contrary to the moral law."
(§2372, citing Populorum Progressio §37)

## Prediction

I expect this to **reveal hidden structure** in the inseparability
principle — the claim that the unitive and procreative meanings of
the conjugal act cannot be deliberately separated. This principle is
the lynchpin: it's what distinguishes the Catholic position on
contraception from the Protestant position (post-1930). Formalizing
it should expose:

1. The inseparability principle itself is asserted, not derived.
2. The NFP/contraception distinction depends on the object-independence
   axiom from SourcesOfMorality.lean.
3. "Just reasons" for spacing is left deliberately undefined.

## Findings

- **The inseparability principle is an axiom, not a theorem.** The
  Catechism cites Humanae Vitae, which cites natural law, but never
  provides a formal derivation. It is a foundational assertion about
  the nature of the conjugal act.
- **The NFP/contraception distinction is coherent but depends on
  the object-independence axiom.** Same outcome (no child), different
  moral object — this only works if you accept that the moral object
  can be evaluated independently of consequences.
- **"Just reasons" is a free parameter.** The Catechism provides
  examples but no decision procedure.
- **Denominational split**: Pre-1930, all Christians held the
  inseparability principle. The Anglican Lambeth Conference of 1930
  (Resolution 15) dropped it. Every other Protestant denomination
  followed within decades. The Catholic Church reaffirmed it in
  Casti Connubii (1930) and Humanae Vitae (1968).
- **Assessment**: Tier 3 — the inseparability principle is the key
  hidden axiom; the NFP/contraception distinction is its most
  practically consequential application.
-/

set_option autoImplicit false

namespace Catlib.MoralTheology.ConjugalEthics

open Catlib
open Catlib.MoralTheology

/-!
## The Two Meanings of the Conjugal Act

The Catechism (following Humanae Vitae §12) holds that every conjugal
act has two inherent meanings — unitive and procreative — and that
these are inseparable by the design of God.
-/

/-- The two inherent meanings of the conjugal act (HV §12).
    The unitive meaning: the act expresses and deepens spousal love.
    The procreative meaning: the act is ordered toward the generation
    of new life. -/
structure ConjugalAct where
  /-- The spouses performing the act -/
  spouse1 : Person
  spouse2 : Person
  /-- The act retains its unitive meaning (expresses spousal love) -/
  unitiveIntact : Prop
  /-- The act retains its procreative meaning (open to life) -/
  procreativeIntact : Prop

/-- Whether a conjugal act is ordered to both meanings. -/
def ConjugalAct.bothMeaningsIntact (act : ConjugalAct) : Prop :=
  act.unitiveIntact ∧ act.procreativeIntact

/-- Whether a conjugal act deliberately frustrates one of its meanings.
    This is the key distinction: NFP does NOT deliberately frustrate
    procreation (the couple simply abstains during fertile times).
    Contraception DOES deliberately frustrate it (the act is performed
    while procreation is actively rendered impossible).
    This predicate captures the "by human initiative" clause of HV §12. -/
opaque deliberatelyFrustratesProcreation : ConjugalAct → Prop

/-- The natural end (telos) of the conjugal act: procreation.
    The conjugal act is ordered toward generating new life. This is
    the teleological claim that grounds the inseparability principle.
    Source: Aquinas, ST II-II q.154; Humanae Vitae §12. -/
def conjugal_procreative_end (act : ConjugalAct) : NaturalEnd :=
  { subject := act.unitiveIntact  -- the conjugal act (as performed)
  , purpose := act.procreativeIntact  -- its natural end: openness to life
  }

/-!
## The Physical Act Principle

Before stating the inseparability principle, we must state its
deepest hidden assumption: the moral object of a conjugal act is
determined by what is PHYSICALLY done to the act, not by the
couple's reproductive intent.

This is the load-bearing claim that distinguishes Catholic moral
theology from consequentialism and from most Protestant ethics.
Two couples may have identical intentions (avoid pregnancy). But if
one uses contraception (modifying the act) and the other uses NFP
(choosing when to act), the MORAL OBJECTS are different — because
the physical structure of the act is different.

Why does Catholicism take the physical act so seriously? Because of
its anthropology: the person IS the body-soul composite (Soul.lean,
§365). The body is not packaging for intentions — it has its own
moral grammar. What you do with and to the body matters in itself,
not merely as an expression of the will. This is the "fleshy"
dimension of Catholic theology: the Incarnation (God became flesh),
the Eucharist (real presence in bread and wine), the sacraments
(physical matter as vehicle of grace), and sexual ethics (the
physical structure of the act is morally constitutive) all flow
from the same principle — the physical world is morally significant
in itself.

Protestantism, broadly, locates moral significance more in the
intention and the faith of the agent. This is why dropping the
physical-act principle collapses the NFP/contraception distinction:
if only intent matters, and the intent is the same, there is no
moral difference. The axiom swap is:

Catholic: moral object = physical structure of the act
Protestant (post-1930): moral object = the agent's intention + consequences

This is a PHILOSOPHICAL commitment, not a scriptural one. The
Catechism inherits it from Aristotle (via Aquinas) and from the
broader sacramental worldview. It is the same commitment that makes
transubstantiation possible (physical bread IS the body of Christ)
and that makes hylomorphism necessary (the soul IS the form of the
body, not a separate substance).
-/

/-- **AXIOM: THE PHYSICAL ACT PRINCIPLE.**
    The moral object of a conjugal act is determined by what is
    physically done to the act, not by the couple's reproductive intent.

    Two couples with identical intentions (avoid pregnancy) have DIFFERENT
    moral objects if one modifies the physical act (contraception) and the
    other does not (NFP). This is because the body is constitutive of
    personhood (Soul.lean, §365), and what is done to the body carries
    moral weight independently of what is intended.

    Source: Implicit in CCC §1750-1756 (the object of the act is one of
    the three sources of morality, evaluated independently); explicit in
    Humanae Vitae §13-14 and Veritatis Splendor §78.

    CONNECTION TO BASE AXIOM: This is the operational form of the
    object-independence axiom from SourcesOfMorality.lean, applied to
    sexual ethics. It also connects to Soul.lean's hylomorphism: the
    body is not morally neutral matter — it is constitutive of the person.

    Denominational scope: CATHOLIC. Consequentialists and most Protestants
    reject this — they evaluate the act by its intent and outcomes, not
    by its physical structure. Dropping this axiom collapses the
    NFP/contraception distinction entirely.

    HIDDEN ASSUMPTION: This is a PHILOSOPHICAL commitment inherited from
    Aristotelian-Thomistic ethics. It is not derivable from Scripture. -/
axiom physical_act_determines_object :
  ∀ (act : ConjugalAct),
    -- If the physical act is not modified (procreative structure intact),
    -- then the act does not deliberately frustrate procreation,
    -- REGARDLESS of the couple's intent to avoid pregnancy
    act.procreativeIntact → ¬deliberatelyFrustratesProcreation act

/-!
## The Inseparability Principle (Humanae Vitae §12)

This is THE key axiom. Paul VI declared:

"The Church... teaches that each and every marital act must of necessity
retain its intrinsic relationship to the procreation of human life.
This particular doctrine... is based on the inseparable connection,
established by God, which man on his own initiative may not break,
between the unitive significance and the procreative significance
which are both inherent to the marriage act."

HIDDEN ASSUMPTION: This principle is asserted, not derived. The
Catechism says it is "established by God" and grounded in natural law,
but provides no formal argument for WHY the two meanings are
inseparable. Aquinas didn't argue for it either — in his framework,
the procreative finality of sex was simply obvious from natural
teleology. The inseparability principle bundles a teleological claim
(sex has a natural end: procreation) with a moral claim (deliberately
frustrating that end is wrong). Whether teleological facts ground
moral obligations is itself a philosophical question (the is-ought
gap).
-/

/-- **AXIOM: Conjugal frustration IS teleological frustration.**
    Deliberately frustrating the procreative meaning of a conjugal act
    is an instance of the general concept of deliberately frustrating a
    natural end (NaturalLaw.lean).

    This is the bridge between the general teleology framework and the
    specific conjugal case. It says: when you use contraception, you are
    not just "separating meanings" — you are thwarting the natural end
    of the conjugal act, which is a specific instance of frustrating
    teleological purpose.

    Denominational scope: CATHOLIC (requires teleological_realism). -/
axiom conjugal_frustration_is_teleological :
  ∀ (act : ConjugalAct) (agent : Person),
    deliberatelyFrustratesProcreation act →
    deliberatelyFrustrates agent (conjugal_procreative_end act)

/-- **THEOREM (HV §12, CCC §2366): THE INSEPARABILITY PRINCIPLE.**
    Deliberately frustrating the procreative meaning of a conjugal act
    is intrinsically evil.

    THIS IS NOW A THEOREM, NOT AN AXIOM. It follows from:
    1. frustration_is_evil (NaturalLaw.lean): frustrating any natural end is evil
    2. conjugal_frustration_is_teleological: conjugal frustration IS teleological frustration
    3. conjugal_procreative_end: the conjugal act's natural end is procreation

    The entire Catholic position on contraception reduces to:
    - Do things have purposes? (teleological_realism)
    - Is thwarting purposes wrong? (frustration_is_evil)
    - Does the conjugal act have procreation as a purpose? (conjugal_procreative_end)
    - Does contraception thwart that purpose? (contraception_frustrates + conjugal_frustration_is_teleological)

    Drop any one of these → the conclusion falls.
    Denominational scope: Catholic (post-1930). Pre-1930: ecumenical. -/
theorem inseparability_principle
    (act : ConjugalAct)
    (agent : Person)
    (h_frustrates : deliberatelyFrustratesProcreation act) :
    IntrinsicallyEvil (conjugal_procreative_end act).purpose :=
  frustration_is_evil agent (conjugal_procreative_end act)
    (conjugal_frustration_is_teleological act agent h_frustrates)

/-- Denominational tag: Catholic (post-1930; pre-1930 ecumenical). -/
def inseparability_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Pre-1930: ecumenical. Post-1930: Catholic only (Lambeth 1930 dropped it)" }

/-!
## The Separability Principle (the Anglican axiom swap)

For completeness, we model what the 1930 Lambeth Conference actually
introduced. Resolution 15 effectively replaced the inseparability
principle with a separability principle: the two meanings CAN be
separated when there is "morally sound reason."

This is not part of Catholic teaching. We include it to show the
axiom swap that generated the Protestant position on contraception.
-/

/-- The separability principle — the axiom Lambeth 1930 introduced.
    The two meanings of the conjugal act CAN be deliberately separated
    when there is a morally sound reason.

    NOT accepted in Catholic teaching. Included for ecumenical
    comparison. -/
def A1_SEPARABILITY (act : ConjugalAct) (justReason : Prop) : Prop :=
  justReason → (act.unitiveIntact ∧ ¬act.procreativeIntact → True)

/-- Denominational tag: Protestant post-1930. -/
def separability_tag : DenominationalTag :=
  { acceptedBy := [Denomination.lutheran, Denomination.reformed],
    note := "Introduced at Lambeth 1930; adopted by all major Protestant bodies by ~1960" }

/-!
## NFP vs. Contraception: The Object Distinction

This is the most contested part of Catholic sexual ethics. The
Catechism distinguishes:
- NFP (Natural Family Planning): abstaining during fertile periods
- Contraception: having sex while rendering procreation impossible

Same OUTCOME (no child conceived), different MORAL OBJECT.

This distinction depends on the object-independence axiom from
SourcesOfMorality.lean: the moral object of an act can be evaluated
independently of its consequences.
-/

/-- The moral object of NFP: when a couple engages in the conjugal act
    during infertile periods, both meanings are intact — the act is
    unitive AND its procreative structure is unmodified.  Therefore
    the act does not deliberately frustrate procreation.

    Previously `True` (trivially provable). Now defined in terms of
    the existing moral-object framework so that proving it requires
    the `physical_act_determines_object` axiom. -/
def NFPObject (act : ConjugalAct) : Prop :=
  act.unitiveIntact ∧ act.procreativeIntact → ¬deliberatelyFrustratesProcreation act

/-- The moral object of contraception: having sex while deliberately
    rendering procreation impossible. Under the inseparability
    principle, this separates what cannot be separated — the unitive
    act is performed while the procreative meaning is deliberately
    frustrated. -/
def ContraceptionObject (act : ConjugalAct) : Prop :=
  act.unitiveIntact ∧ ¬act.procreativeIntact

/-- **AXIOM: Contraception deliberately frustrates procreation.**
    The moral object of contraception is to have conjugal relations
    while actively rendering procreation impossible. This is the
    definition of "deliberately frustrates" applied to contraception.
    Denominational scope: ECUMENICAL (definitional — even those who
    permit contraception agree this is what it does). -/
axiom contraception_frustrates :
  ∀ (act : ConjugalAct),
    ContraceptionObject act →
    deliberatelyFrustratesProcreation act

/-- **THEOREM: Contraception is intrinsically evil** (under inseparability).
    Derived from the full chain:
    - contraception_frustrates: contraception deliberately frustrates procreation
    - conjugal_frustration_is_teleological: this is teleological frustration
    - frustration_is_evil (NaturalLaw.lean): frustrating natural ends is evil

    This is the formal version of HV §14: "every action which proposes to
    render procreation impossible is intrinsically evil."

    The proof chain makes the axiom dependencies explicit:
    teleological_realism + frustration_is_evil + conjugal_frustration_is_teleological
    + contraception_frustrates → contraception is evil.

    Denominational scope: CATHOLIC (depends on the entire teleological framework). -/
theorem contraception_intrinsically_evil
    (act : ConjugalAct)
    (agent : Person)
    (h_contra : ContraceptionObject act) :
    IntrinsicallyEvil (conjugal_procreative_end act).purpose :=
  inseparability_principle act agent (contraception_frustrates act h_contra)

/-- Denominational tag: Catholic. -/
def contraception_evil_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Pre-1930: ecumenical. CCC §2370, HV §14" }

/-!
## NFP Permissibility

NFP is permitted because its moral object is different from
contraception. The couple abstains during fertile periods — they
do not perform a conjugal act while frustrating its procreative
meaning. When they do have conjugal relations (during infertile
periods), both meanings are intact: the act is unitive and is
not rendered artificially infertile.
-/

/-- The object of NFP is not evil. When a conjugal act preserves both
    meanings (unitive + procreative intact), it does not deliberately
    frustrate procreation. Derived from `physical_act_determines_object`.

    Previously provable by `trivial` (NFPObject was `True`). Now
    genuinely depends on the axiom that physical structure determines
    moral object. -/
theorem nfp_object_not_evil (act : ConjugalAct) : NFPObject act :=
  fun ⟨_, h_proc⟩ => physical_act_determines_object act h_proc

/-- **THEOREM: NFP does NOT deliberately frustrate procreation.**
    Derived from physical_act_determines_object: the physical act is
    not modified (procreativeIntact), therefore it does not deliberately
    frustrate procreation — regardless of the couple's intent to space births.

    This was previously an axiom. Now it's a theorem derived from the
    deeper principle that the physical structure of the act determines
    its moral object. -/
theorem nfp_does_not_frustrate
    (act : ConjugalAct)
    (h_unitive : act.unitiveIntact)
    (h_procreative : act.procreativeIntact) :
    ¬deliberatelyFrustratesProcreation act :=
  physical_act_determines_object act h_procreative

/-- **THEOREM: NFP does not trigger the inseparability principle.**
    An NFP act (both meanings intact) does not deliberately frustrate
    procreation, so the inseparability principle's antecedent is not
    satisfied. Contraception DOES trigger it (contraception_frustrates).
    This is the formal version of the Catholic claim that NFP and
    contraception are morally different despite the same outcome (no child).

    Derived from nfp_does_not_frustrate. -/
theorem nfp_does_not_trigger_inseparability
    (act : ConjugalAct)
    (h_unitive : act.unitiveIntact)
    (h_procreative : act.procreativeIntact) :
    ¬deliberatelyFrustratesProcreation act :=
  nfp_does_not_frustrate act h_unitive h_procreative

/-- NFP is permissible: the moral evaluation can be good.
    Given that NFP's object is not evil, and the intention is
    responsible parenthood (a good intention), and circumstances
    are appropriate (just reasons for spacing), the three sources
    of morality are satisfied. -/
theorem nfp_is_permissible
    (eval : MoralEvaluation)
    (h_obj : eval.objectIsGood)
    (h_int : eval.intentionIsGood)
    (h_circ : eval.circumstancesAppropriate) :
    eval.isGood := by
  exact ⟨h_obj, h_int, h_circ⟩

/-- Denominational tag: Catholic. -/
def nfp_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "CCC §2370; HV §16. Protestant view: NFP unnecessary since contraception is permitted" }

/-!
## Responsible Parenthood (CCC §2368)

"For just reasons, spouses may wish to space the births of their
children."

HIDDEN ASSUMPTION: "Just reasons" is a free parameter. The Catechism
gives examples (health, economic hardship, existing children's
welfare) but provides no formal decision procedure. Who decides
what counts as "just"? The answer is: the couple's informed
conscience (S9, conscience binds). But this creates a tension:
conscience is fallible, and what one couple considers "just" another
might not. The Catechism doesn't resolve this tension — it trusts
the conscience while insisting the conscience must be properly
formed.
-/

/-- Just reasons for spacing births.
    This is deliberately left as an opaque Prop because the
    Catechism itself does not define it precisely.
    Examples given: health of the mother, economic hardship,
    welfare of existing children.

    HIDDEN ASSUMPTION: "Just reasons" is undefined. This is a
    genuine gap in the formalization — and in the Catechism. -/
opaque JustReasons : Prop

/-- Responsible parenthood: spacing for just reasons using NFP
    is morally permissible. CCC §2368.
    Requires: (1) just reasons exist, (2) method used is NFP
    (not contraception), (3) motivation is not selfish. -/
structure ResponsibleParenthood where
  /-- Just reasons for spacing exist -/
  justReasons : JustReasons
  /-- The method respects the inseparability principle -/
  methodRespectsInseparability : Prop
  /-- The desire is not motivated by selfishness -/
  notSelfish : Prop

/-- Responsible parenthood is permissible when all conditions hold. -/
def ResponsibleParenthood.isPermissible (rp : ResponsibleParenthood) : Prop :=
  rp.methodRespectsInseparability ∧ rp.notSelfish

/-!
## Medical Double Effect (CCC §2370 note)

Medical treatment that has a contraceptive side effect is permitted
under the principle of double effect (formalized in
LegitimateDefense.lean). The classic case: hormonal treatment for
endometriosis that also suppresses ovulation.

This uses the same DoubleEffectConditions structure from
LegitimateDefense.lean.
-/

/-- A medical treatment with a contraceptive side effect. -/
structure MedicalTreatmentWithSideEffect where
  /-- The patient -/
  patient : Person
  /-- The medical condition being treated -/
  medicalCondition : Prop
  /-- The treatment addresses the condition (good effect) -/
  treatsCondition : Prop
  /-- The treatment has a contraceptive side effect (bad effect) -/
  contraceptiveSideEffect : Prop
  /-- The treatment's PURPOSE is medical, not contraceptive -/
  intendsMedical : Prop
  /-- The contraceptive effect is NOT intended -/
  doesNotIntendContraception : Prop

/-- Medical treatment with contraceptive side effect as a double
    effect act. Maps to the DoubleEffectAct structure. -/
def MedicalTreatmentWithSideEffect.toDoubleEffectAct
    (mt : MedicalTreatmentWithSideEffect) : DoubleEffectAct :=
  { agent := mt.patient
  , goodEffect := mt.treatsCondition
  , badEffect := mt.contraceptiveSideEffect
  , intendsGood := mt.intendsMedical
  , doesNotIntendBad := mt.doesNotIntendContraception
  }

/-- Medical treatment is permissible under double effect when all
    four conditions are met:
    1. The act (taking medicine) is not intrinsically evil
    2. The intention is medical treatment, not contraception
    3. The contraceptive effect is not the means to the medical benefit
    4. The medical benefit is proportionate to the side effect

    This is a direct application of the double effect framework
    from LegitimateDefense.lean. -/
theorem medical_treatment_permissible
    (dec : DoubleEffectConditions)
    (h_not_evil : dec.actNotIntrinsicallyEvil)
    (h_intended : dec.goodIntended)
    (h_not_means : dec.badNotMeansToGood)
    (h_proportionate : dec.proportionate) :
    dec.isPermissible := by
  exact ⟨h_not_evil, h_intended, h_not_means, h_proportionate⟩

/-!
## State Authority and Contraception (CCC §2372)

"Regulating the population... cannot justify courses of action which
are in themselves contrary to the moral law." The State has no
authority to impose contraception as population policy.
-/

/-!
### State Authority and Contraception (CCC §2372)

"The political authority has no right to intervene by encouraging
the use of methods of birth regulation contrary to the moral law."

This principle (state authority cannot command intrinsically evil
acts) is a consequence of the general natural law framework and
does not require a separate axiom.
-/

/-!
## Summary of Hidden Assumptions

Formalizing §2366-2372 required these assumptions the text doesn't
fully justify:

1. **The inseparability principle itself** — WHY can't you separate
   the unitive and procreative meanings? The Catechism says it's
   "established by God" and grounded in natural law, but provides
   no derivation. This is the foundational axiom. Pre-1930, all
   Christians accepted it. Post-1930, only Catholics (and some
   Orthodox) maintain it.

2. **The act/object distinction between NFP and contraception** —
   same outcome (no baby), different moral object (abstaining vs.
   rendering procreation impossible). This distinction is coherent
   but depends on the object-independence axiom: the moral object
   of an act can be evaluated independently of its consequences.
   Consequentialists reject this axiom, which is why they see no
   moral difference between NFP and contraception.

3. **"Just reasons" is undefined** — the Catechism says couples
   may space births for "just reasons" but never defines what
   counts. This is delegated to the couple's informed conscience
   (S9), which means the framework trusts human judgment on a
   question it considers very important.

4. **Natural vs. artificial infertility** — the distinction between
   "sex during a naturally infertile period" (morally fine) and
   "sex after artificially inducing infertility" (intrinsically evil)
   depends entirely on the inseparability principle. If you drop
   inseparability, this distinction evaporates — which is exactly
   what happened in Protestantism after 1930.

5. **The denominational fracture is an axiom swap** — dropping the
   inseparability principle and adopting A1_SEPARABILITY is the
   single axiom change that generates the entire Protestant position
   on contraception. Every other difference (permitting the pill,
   permitting condoms, etc.) follows from this one swap.
-/

end Catlib.MoralTheology.ConjugalEthics
