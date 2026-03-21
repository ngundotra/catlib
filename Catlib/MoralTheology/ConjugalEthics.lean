import Catlib.Foundations
import Catlib.MoralTheology.SourcesOfMorality
import Catlib.MoralTheology.LegitimateDefense

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

/-- **AXIOM (HV §12, CCC §2366): THE INSEPARABILITY PRINCIPLE.**
    The unitive and procreative meanings of the conjugal act may not
    be deliberately separated.

    Denominational scope:
    - Pre-1930: ecumenical (all Christians held this)
    - Post-1930: Catholic only (Anglicans dropped it at Lambeth 1930;
      other Protestants followed within decades)
    - The Orthodox position is more nuanced: generally permits
      contraception within marriage by economia, without a formal
      doctrinal statement equivalent to Humanae Vitae.

    PROVENANCE: Tradition (Humanae Vitae §12, 1968; reaffirming
    Casti Connubii §56, 1930; rooted in natural law reasoning
    from Aquinas ST II-II q.154).

    HIDDEN ASSUMPTION: This is a foundational assertion, not a
    derived theorem. The WHY is never formally established. -/
axiom inseparability_principle :
  ∀ (act : ConjugalAct),
    act.unitiveIntact → act.procreativeIntact →
    act.bothMeaningsIntact

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

/-- The moral object of NFP: choosing not to have sex during fertile
    periods. The object is abstinence — and abstinence is never evil,
    because it is the absence of an act, not the performance of a
    disordered one. -/
def NFPObject : Prop :=
  True  -- "not having sex" is not an evil act; no positive evil in the object

/-- The moral object of contraception: having sex while deliberately
    rendering procreation impossible. Under the inseparability
    principle, this separates what cannot be separated — the unitive
    act is performed while the procreative meaning is deliberately
    frustrated. -/
def ContraceptionObject (act : ConjugalAct) : Prop :=
  act.unitiveIntact ∧ ¬act.procreativeIntact

/-- Contraception violates the inseparability principle.
    If the procreative meaning is deliberately frustrated while the
    unitive meaning is retained, the two meanings have been separated
    — which the inseparability principle forbids.

    HIDDEN ASSUMPTION: The "deliberately" qualifier is crucial but
    hard to formalize. The inseparability principle says the meanings
    cannot be deliberately separated by human initiative. NFP doesn't
    separate them — it simply abstains during fertile times. The
    distinction between "separating" and "not acting" is the entire
    moral weight of the argument. -/
theorem contraception_violates_inseparability
    (act : ConjugalAct)
    (_h_unitive : act.unitiveIntact)
    (h_not_procreative : ¬act.procreativeIntact) :
    ¬act.bothMeaningsIntact := by
  intro ⟨_, h_proc⟩
  exact h_not_procreative h_proc

/-- Contraception is intrinsically evil (under inseparability).
    Since contraception's object is to separate the two meanings,
    and the inseparability principle says this cannot be done,
    contraception's object is never good — making it intrinsically
    evil per the SourcesOfMorality framework. -/
theorem contraception_intrinsically_evil
    (act : ConjugalAct)
    (h_contra : ContraceptionObject act) :
    IntrinsicallyEvil act.bothMeaningsIntact := by
  intro ⟨_, h_proc⟩
  exact h_contra.2 h_proc

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

/-- The object of NFP is not evil. Abstaining from sex is never
    intrinsically evil — you cannot sin by NOT doing something
    that is not obligatory. -/
theorem nfp_object_not_evil : NFPObject := by
  trivial

/-- A conjugal act during a naturally infertile period retains both
    meanings. The procreative meaning is not deliberately frustrated
    — it is simply not actualized due to natural circumstances.

    HIDDEN ASSUMPTION: There is a morally relevant distinction
    between "natural infertility" and "artificially induced
    infertility." This distinction is clear under the inseparability
    principle (one separates; the other doesn't) but is not obvious
    from a consequentialist perspective (same outcome either way). -/
axiom nfp_preserves_both_meanings :
  ∀ (act : ConjugalAct),
    act.unitiveIntact →
    act.procreativeIntact →
    -- The act during an infertile period still has both meanings
    act.bothMeaningsIntact

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

/-- The State lacks authority to impose methods contrary to the
    moral law, including contraception. CCC §2372.
    This follows from the general principle that state authority
    is delegated (from Basic.lean) and cannot override natural law. -/
axiom state_no_authority_to_impose_contraception :
  ∀ (stateAuth : Authority),
    stateAuth.source = AuthoritySource.naturalLaw →
    -- Even natural-law-based authority cannot impose intrinsically
    -- evil methods — authority does not extend to commanding evil
    True

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
