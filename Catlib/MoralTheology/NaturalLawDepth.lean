import Catlib.MoralTheology.NaturalLaw
import Catlib.Creed.ScientificInquiry
import Catlib.Creed.Intelligibility
import Catlib.Creed.Providence

/-!
# Aquinas: Natural Law in Depth (ST I-II q.90-97)

## The question

The CCC §1954-1960 compresses Aquinas's rich four-fold law distinction into
a single treatment of "natural law." Aquinas distinguishes:

1. **Eternal law** — God's rational governance of all creation (ST I-II q.93)
2. **Natural law** — rational creatures' participation in eternal law (ST I-II q.91 a.2)
3. **Human law** — positive law derived from natural law by human legislators (ST I-II q.95)
4. **Divine law** — revealed law supplementing what natural law cannot reach (ST I-II q.91 a.4)

The CCC uses "natural law" to cover what Aquinas distributes across all four.
This file recovers Aquinas's richer structure and asks: can we formalize the
derivation from primary to secondary precepts?

## Prediction

I expect the derivation from primary to secondary precepts to be NON-DEDUCTIVE.
Aquinas explicitly says secondary precepts are derived by practical reason,
which involves prudential judgment (ST I-II q.94 a.4). This means natural law
is both OBJECTIVE (grounded in human nature) and PARTIALLY INDETERMINATE (its
concrete application requires virtue). The formalization should expose a gap
between the self-evident first principle and specific moral conclusions that
cannot be closed by logic alone.

I also expect the four-fold hierarchy to reveal that NaturalLaw.lean's
`divine_grounding` axiom is actually about ETERNAL law — the CCC compresses
what Aquinas keeps distinct.

## Findings

- **Prediction confirmed**: The derivation from primary to secondary precepts
  is genuinely non-deductive. The gap between "good is to be done" and specific
  moral conclusions requires `prudential_judgment` — an opaque that captures
  Aquinas's insight that practical reason is not mere deduction.
- **The four-fold hierarchy is genuinely load-bearing**: natural law is NOT
  autonomous — it depends on eternal law for its binding force and requires
  divine law for what reason cannot reach. The hierarchy is not mere taxonomy
  but a dependency chain.
- **Key finding**: the CCC's compression of Aquinas's four-fold distinction
  HIDES a crucial structural feature: natural law's authority comes FROM
  eternal law (participation), not from reason alone. This connects to
  NaturalLaw.lean's `divine_grounding` tension — the tension dissolves once
  you see that `divine_grounding` is really about ETERNAL law grounding
  natural law.
- **Connection to existing files**: natural law as participation in eternal
  law parallels ScientificInquiry.lean's thesis that human understanding
  participates in divine wisdom. Both are instances of P2's two-tier structure
  applied to knowledge rather than causation.
- **Surprise**: Aquinas's framework implies that DISAGREEMENT about secondary
  precepts is expected and not automatically a failure of reason (ST I-II q.94
  a.4) — softening NaturalLaw.lean's `rational_convergence` claim. Primary
  precepts are self-evident; secondary precepts admit legitimate disagreement
  because their derivation requires prudence, which varies with experience
  and virtue.

## Hidden assumptions

1. **Practical reason is a genuine cognitive faculty** — not just theoretical
   reason applied to action, but a distinct mode of knowing that grasps what
   is to be done. Aquinas assumes this (ST I-II q.94 a.1); the CCC does not
   argue for it.

2. **Human nature has stable, knowable inclinations** — the primary precepts
   track real features of human nature (self-preservation, procreation,
   knowledge of God, social life). This assumes human nature is fixed enough
   to ground universal precepts — an Aristotelian commitment.

3. **The eternal law is rational, not voluntarist** — God's governance follows
   wisdom, not arbitrary will. If divine law were pure will (Ockham), then
   natural law as "participation in eternal law" would be participation in
   arbitrariness, not rationality. Aquinas's position presupposes the primacy
   of intellect over will in God (ST I q.19 a.1).

## Modeling choices

1. **We model the four law-types as a hierarchy of Prop-valued predicates**
   rather than as a single type with constructors. This matches how Aquinas
   treats them — as distinct concepts with derivation relations, not as
   variants of one thing.

2. **We model the first principle as an opaque rather than a definition**
   because "good is to be done and evil avoided" is a primitive of practical
   reason that Aquinas says CANNOT be demonstrated (ST I-II q.94 a.2).

3. **We model prudential judgment as opaque** because its content is precisely
   what Aquinas says cannot be formalized — it requires experience, virtue,
   and attention to particulars.

## Denominational scope

CATHOLIC — the four-fold law hierarchy is specifically Thomistic. Protestants
generally reject the natural law tradition in favor of divine command theory
or biblical ethics. The first principle ("good is to be done") is ECUMENICAL
as a philosophical claim, but its grounding in eternal law is Catholic.
-/

namespace Catlib.MoralTheology.NaturalLawDepth

open Catlib
open Catlib.MoralTheology

/-!
## The Four-Fold Law Hierarchy

Aquinas distinguishes four kinds of law (ST I-II q.91). They form a hierarchy:
eternal law grounds natural law, natural law grounds human law, and divine law
supplements what natural law cannot reach.
-/

/-- Whether a precept belongs to the eternal law — God's rational governance
    of all creation.
    Source: [Aquinas] ST I-II q.93 a.1: "The eternal law is nothing other than
    the plan of divine wisdom, as directing all actions and movements."
    HIDDEN ASSUMPTION: God's governance is RATIONAL (follows wisdom), not
    voluntarist (follows arbitrary will). Without this, eternal law is not
    "law" in Aquinas's sense — it lacks the rational ordering that makes
    something a law (ST I-II q.90 a.1). -/
opaque isEternalLaw : Prop → Prop

/-- Whether a precept belongs to the natural law — rational creatures'
    participation in eternal law.
    Source: [Aquinas] ST I-II q.91 a.2: "The natural law is nothing other than
    the rational creature's participation in the eternal law."
    This is NOT the same as "moral truths discoverable by reason" — it is
    specifically a PARTICIPATION relation. Natural law has authority BECAUSE
    it participates in eternal law, not because reason is self-grounding. -/
opaque isNaturalLawPrecept : Prop → Prop

/-- Whether a law is human law — positive law enacted by human legislators,
    derived from natural law.
    Source: [Aquinas] ST I-II q.95 a.2: "Every human law has just so much
    of the nature of law as it is derived from the law of nature."
    Human law that contradicts natural law is "no longer a law but a
    corruption of law" (q.95 a.2). -/
opaque isHumanLaw : Prop → Prop

/-- Whether a precept belongs to divine law — revealed law given through
    Scripture and Tradition, supplementing natural law.
    Source: [Aquinas] ST I-II q.91 a.4: Divine law is necessary because
    (1) human judgment is uncertain about contingent matters,
    (2) human law cannot reach interior acts,
    (3) human law cannot prohibit all evil without destroying good,
    (4) the supernatural end exceeds natural capacity. -/
opaque isDivineLaw : Prop → Prop

/-!
## The Hierarchy Axioms

These axioms formalize the derivation relations between the four law-types.
-/

/-- AXIOM 1: Eternal law is God's rational governance of all creation.
    Source: [Aquinas] ST I-II q.93 a.1.
    CONNECTION TO BASE AXIOM: This connects to S4 (universal providence) via
    `divinelyGoverned`. Eternal law IS divine governance viewed under the
    aspect of rational ordering. S4 says everything is governed; this axiom
    says the governance is rational (has the character of law).
    Denominational scope: ECUMENICAL — all classical theists accept divine
    governance, though they may not call it "eternal law." -/
axiom eternal_law_is_rational_governance :
  ∀ (precept : Prop),
    isEternalLaw precept →
    divinelyGoverned precept

/-- AXIOM 2: Natural law is participation in eternal law.
    Source: [Aquinas] ST I-II q.91 a.2: "The natural law is nothing other than
    the rational creature's participation in the eternal law."
    This is the KEY Thomistic insight: natural law is NOT autonomous. It has
    authority because it participates in something higher — God's rational
    plan for creation. Without eternal law, natural law is just "what reason
    happens to discover," which lacks normative force.
    HIDDEN ASSUMPTION: "Participation" is a real metaphysical relation, not
    a metaphor. The rational creature genuinely shares in God's rational
    governance — not by knowing the whole plan, but by grasping the principles
    that govern human action.
    Denominational scope: CATHOLIC — specifically Thomistic. -/
axiom natural_law_participates_in_eternal :
  ∀ (precept : Prop),
    isNaturalLawPrecept precept →
    isEternalLaw precept

/-- AXIOM 3: Human law derives from natural law.
    Source: [Aquinas] ST I-II q.95 a.2: Human law is derived from natural law
    either by CONCLUSION (as from premises) or by DETERMINATION (specifying
    what natural law leaves open — e.g., natural law says "punish wrongdoers,"
    human law specifies the penalty).
    The derivation has two modes, not just one: deduction AND specification.
    Human law that contradicts natural law is invalid ("a corruption of law").
    Denominational scope: ECUMENICAL — most natural law theorists accept this. -/
axiom human_law_derives_from_natural :
  ∀ (law : Prop),
    isHumanLaw law →
    ∃ (precept : Prop), isNaturalLawPrecept precept ∧ (precept → law)

/-- AXIOM 4: Divine law supplements natural law.
    Source: [Aquinas] ST I-II q.91 a.4: Four reasons divine law is necessary:
    (1) human judgment is uncertain, (2) human law cannot judge interior acts,
    (3) human law cannot prohibit all evil, (4) the supernatural end exceeds
    natural capacity.
    This axiom says: there are truths that natural law cannot reach but divine
    law provides. Natural law is NOT sufficient for the full moral life.
    Denominational scope: ECUMENICAL — all Christians accept revealed moral law.
    The disagreement is about WHAT counts as revealed. -/
axiom divine_law_supplements_natural :
  ∃ (precept : Prop),
    isDivineLaw precept ∧
    ¬isNaturalLawPrecept precept

/-!
## The First Principle of Practical Reason

Aquinas identifies "good is to be done and pursued, and evil is to be avoided"
as the first principle of practical reason — analogous to the principle of
non-contradiction for theoretical reason (ST I-II q.94 a.2).
-/

/-- The first principle of practical reason: "good is to be done and pursued,
    and evil is to be avoided."
    Source: [Aquinas] ST I-II q.94 a.2.
    STRUCTURAL OPACITY: This is opaque because Aquinas says it is
    SELF-EVIDENT (per se nota) and cannot be demonstrated from anything more
    basic. It is the starting point of all practical reasoning, not a
    conclusion from prior premises. The CCC echoes this at §1954.
    MODELING CHOICE: We represent this as a Prop because it is a principle
    that either holds or does not. Aquinas treats it as necessarily true
    for any rational agent — it cannot be coherently denied by someone
    engaged in practical reasoning. -/
opaque firstPrincipleOfPracticalReason : Prop

/-- Whether a precept is self-evident (per se nota) — known immediately
    upon grasping its terms, without demonstration.
    Source: [Aquinas] ST I-II q.94 a.2: The first precepts of natural law
    are self-evident, "for their truth is known to all."
    HONEST OPACITY: What counts as "grasping the terms" is genuinely
    unclear. Aquinas says the first principle is self-evident to ALL, but
    the primary precepts (which follow immediately) may not be self-evident
    to those whose reason is "perverted by passion" (q.94 a.6). -/
opaque isSelfEvident : Prop → Prop

/-- Whether a precept is a primary precept — derived IMMEDIATELY from
    the first principle by attending to natural human inclinations.
    Source: [Aquinas] ST I-II q.94 a.2: The order of the precepts of
    natural law follows the order of natural inclinations:
    (1) self-preservation (shared with all substances),
    (2) procreation and education of offspring (shared with all animals),
    (3) knowledge of God and life in society (proper to rational creatures).
    HIDDEN ASSUMPTION: Human nature has stable, knowable INCLINATIONS that
    ground moral precepts. This is Aristotelian — it assumes natures are
    real and normatively significant. -/
opaque isPrimaryPrecept : Prop → Prop

/-- Whether a precept is a secondary precept — derived from primary precepts
    by practical reasoning that involves prudential judgment.
    Source: [Aquinas] ST I-II q.94 a.4-6.
    Secondary precepts are NOT merely deduced. They require attention to
    circumstances, experience, and virtue. This is why they can be
    "blotted out" from the heart by bad customs or corrupt habits (q.94 a.6)
    while primary precepts cannot. -/
opaque isSecondaryPrecept : Prop → Prop

/-- Whether prudential judgment connects two propositions. This captures
    the non-deductive element in practical reasoning — the move from
    universal principle to particular conclusion requires PRUDENCE (phronesis),
    not mere logic.
    Source: [Aquinas] ST I-II q.94 a.4; ST II-II q.47 (on prudence).
    HONEST OPACITY: The content of prudential judgment is precisely what
    CANNOT be formalized. Prudence requires experience, attention to
    particulars, and moral virtue. It is the anti-algorithm — the exercise
    of practical wisdom that no set of rules can replace.
    MODELING CHOICE: We model this as a binary relation between propositions
    (from a premise to a conclusion via prudential judgment) rather than as
    a property of agents, because our interest is in the logical structure
    of the derivation, not in the psychology of the reasoner. -/
opaque prudentialJudgment : Prop → Prop → Prop

/-!
## Axioms on the First Principle and Precepts
-/

/-- AXIOM 5: The first principle of practical reason is self-evident.
    Source: [Aquinas] ST I-II q.94 a.2: "The first principle in practical
    reason is one founded on the notion of good, viz., that good is to be
    done and pursued, and evil is to be avoided. All other precepts of the
    natural law are based upon this."
    The first principle CANNOT be demonstrated — it is the starting point
    of all practical reasoning, as the principle of non-contradiction is
    the starting point of all theoretical reasoning.
    Denominational scope: ECUMENICAL as a philosophical claim. -/
axiom first_principle_is_self_evident :
  isSelfEvident firstPrincipleOfPracticalReason

/-- AXIOM 6: The first principle is a precept of natural law.
    Source: [Aquinas] ST I-II q.94 a.2.
    The first principle belongs to the natural law because it is grasped
    by practical reason's participation in eternal law.
    Denominational scope: CATHOLIC — grounding in eternal law is Thomistic. -/
axiom first_principle_is_natural_law :
  isNaturalLawPrecept firstPrincipleOfPracticalReason

/-- AXIOM 7: Primary precepts are self-evident and belong to natural law.
    Source: [Aquinas] ST I-II q.94 a.2: The primary precepts follow immediately
    from the first principle by attending to natural inclinations. They are
    self-evident "to all" (though they can be obscured by passion or custom,
    q.94 a.6).
    Denominational scope: ECUMENICAL — most natural law theorists accept this. -/
axiom primary_precepts_are_self_evident :
  ∀ (p : Prop),
    isPrimaryPrecept p →
    isSelfEvident p ∧ isNaturalLawPrecept p

/-- AXIOM 8: Secondary precepts are derived from primary precepts by
    prudential judgment, NOT by deduction alone.
    Source: [Aquinas] ST I-II q.94 a.4: "As to the other, i.e., the secondary
    precepts, the natural law can be blotted out from the human heart, either
    by evil persuasions... or by vicious customs and corrupt habits."
    The fact that secondary precepts can be "blotted out" while primary precepts
    cannot shows the derivation is not purely logical — if it were deductive,
    denying a secondary precept while affirming the primary would be a logical
    contradiction, which Aquinas says it is not.
    HIDDEN ASSUMPTION: Practical reasoning is a genuine mode of rational
    derivation that is weaker than deduction but stronger than mere opinion.
    Denominational scope: CATHOLIC — the non-deductive character is specifically
    Thomistic and distinguishes natural law from rationalist ethics. -/
axiom secondary_from_primary_via_prudence :
  ∀ (s : Prop),
    isSecondaryPrecept s →
    ∃ (p : Prop), isPrimaryPrecept p ∧ prudentialJudgment p s

/-- AXIOM 9: Secondary precepts belong to natural law but are NOT self-evident.
    Source: [Aquinas] ST I-II q.94 a.4-6.
    They belong to natural law (they are derived from it) but they require
    derivation — they are not immediately grasped.
    Denominational scope: CATHOLIC. -/
axiom secondary_precepts_are_natural_law :
  ∀ (s : Prop),
    isSecondaryPrecept s →
    isNaturalLawPrecept s ∧ ¬isSelfEvident s

/-!
## Theorems

These derive consequences from the axiom set, showing the logical structure
of the four-fold hierarchy and the derivation of precepts.
-/

/-- THEOREM: The first principle has a unique epistemic status — it is both
    self-evident (known immediately by any practical reasoner) AND grounded
    in eternal law (its authority comes from God's rational governance).
    Chain: first_principle_is_self_evident + first_principle_is_natural_law +
    natural_law_participates_in_eternal.
    This is the formal expression of the divine_grounding tension from
    NaturalLaw.lean: the first principle is DISCOVERED by reason (self-evident)
    but GROUNDED in something beyond reason (eternal law). -/
theorem first_principle_self_evident_and_eternal :
    isSelfEvident firstPrincipleOfPracticalReason ∧
    isEternalLaw firstPrincipleOfPracticalReason :=
  ⟨first_principle_is_self_evident,
   natural_law_participates_in_eternal
     firstPrincipleOfPracticalReason
     first_principle_is_natural_law⟩

/-- THEOREM: The first principle participates in eternal law.
    Chain: first_principle_is_natural_law → natural_law_participates_in_eternal.
    The self-evident first principle of practical reason is ultimately grounded
    in God's rational governance — not in reason's own authority. -/
theorem first_principle_participates_in_eternal :
    isEternalLaw firstPrincipleOfPracticalReason :=
  (first_principle_self_evident_and_eternal).2

/-- THEOREM: The first principle is divinely governed.
    Chain: first_principle_participates_in_eternal → eternal_law_is_rational_governance.
    The most basic moral principle is part of God's providential ordering. -/
theorem first_principle_is_governed :
    divinelyGoverned firstPrincipleOfPracticalReason :=
  eternal_law_is_rational_governance
    firstPrincipleOfPracticalReason
    first_principle_participates_in_eternal

/-- THEOREM: Primary precepts participate in eternal law.
    Chain: primary_precepts_are_self_evident → natural_law_participates_in_eternal.
    The primary moral precepts (self-preservation, procreation, knowledge
    of God, social life) are not mere human discoveries — they participate
    in God's eternal rational ordering. -/
theorem primary_precepts_participate_in_eternal (p : Prop)
    (h : isPrimaryPrecept p) :
    isEternalLaw p :=
  natural_law_participates_in_eternal p (primary_precepts_are_self_evident p h).2

/-- THEOREM: Secondary precepts participate in eternal law.
    Chain: secondary_precepts_are_natural_law → natural_law_participates_in_eternal.
    Even derived precepts participate in eternal law, because the natural law
    from which they are derived is itself a participation. -/
theorem secondary_precepts_participate_in_eternal (s : Prop)
    (h : isSecondaryPrecept s) :
    isEternalLaw s :=
  natural_law_participates_in_eternal s (secondary_precepts_are_natural_law s h).1

/-- THEOREM: The derivation gap — secondary precepts are NOT self-evident.
    This is the formal expression of Aquinas's key insight: the move from
    primary to secondary precepts is NOT purely deductive. If it were,
    secondary precepts would be self-evident to anyone who grasps the primary
    ones. But Aquinas explicitly says they are not (q.94 a.4-6).
    This means natural law is PARTIALLY INDETERMINATE at the level of
    concrete application — its application requires prudential judgment
    (virtue), not just logical inference. -/
theorem derivation_gap (s : Prop)
    (h : isSecondaryPrecept s) :
    (∃ p, isPrimaryPrecept p ∧ prudentialJudgment p s) ∧ ¬isSelfEvident s :=
  ⟨secondary_from_primary_via_prudence s h,
   (secondary_precepts_are_natural_law s h).2⟩

/-- THEOREM: The full dependency chain from secondary precept to eternal law.
    A secondary precept depends on: prudential judgment applied to a primary
    precept, which belongs to natural law, which participates in eternal law,
    which is divinely governed.
    This is the complete four-level chain that the CCC compresses into
    "natural law." -/
theorem full_dependency_chain (s : Prop)
    (h : isSecondaryPrecept s) :
    -- Secondary precept is governed by eternal law AND derived via prudence
    isEternalLaw s ∧
    (∃ p, isPrimaryPrecept p ∧ prudentialJudgment p s) :=
  ⟨secondary_precepts_participate_in_eternal s h,
   secondary_from_primary_via_prudence s h⟩

/-- THEOREM: Human law ultimately depends on eternal law.
    Chain: human_law_derives_from_natural → natural_law_participates_in_eternal.
    Any just human law traces back through natural law to eternal law.
    An unjust law — one that contradicts natural law — is "no longer a law
    but a corruption of law" (ST I-II q.95 a.2). -/
theorem human_law_depends_on_eternal (law : Prop)
    (h : isHumanLaw law) :
    ∃ (precept : Prop), isEternalLaw precept ∧ (precept → law) := by
  obtain ⟨precept, h_nl, h_derives⟩ := human_law_derives_from_natural law h
  exact ⟨precept, natural_law_participates_in_eternal precept h_nl, h_derives⟩

/-- THEOREM: Natural law is not self-sufficient — divine law is necessary.
    Aquinas gives four reasons (ST I-II q.91 a.4) why divine law is needed
    beyond natural law. This theorem shows the formal consequence: there
    exist moral truths that natural law cannot reach.
    Key finding: this means the CCC's reliance on BOTH natural law and
    revelation is not redundancy but NECESSITY. -/
theorem natural_law_insufficient :
    ∃ (precept : Prop), isDivineLaw precept ∧ ¬isNaturalLawPrecept precept :=
  divine_law_supplements_natural

/-!
## Bridge Theorems to Existing Formalizations
-/

/-- Bridge to NaturalLaw.lean: `divine_grounding` IS participation in eternal law.
    NaturalLaw.lean axiom 5 says natural law has binding force because it
    comes from "a higher reason." THIS is what Aquinas means by participation
    in eternal law. The `divine_grounding` tension (accessible to reason but
    grounded in God) DISSOLVES in Aquinas's framework: natural law is
    discovered by reason but GROUNDED in eternal law. -/
theorem divine_grounding_is_participation (p : MoralPrecept)
    (h : isNaturalLawPrecept p.content) :
    isEternalLaw p.content :=
  natural_law_participates_in_eternal p.content h

/-- Bridge to ScientificInquiry.lean: natural law participation parallels
    the participation of human understanding in divine wisdom.
    ScientificInquiry.lean shows that human understanding of the world is
    grounded in creation through wisdom (`godCreatesThruWisdom`).
    Natural law is the MORAL instance of the same structure: just as the
    physical world is intelligible because it participates in divine wisdom,
    the moral world is knowable because natural law participates in eternal law.
    Both are instances of rational creatures sharing in God's rationality. -/
theorem moral_parallels_physical (precept : Prop)
    (h_nl : isNaturalLawPrecept precept) :
    -- Natural law precepts are divinely governed (like all events under S4)
    divinelyGoverned precept :=
  eternal_law_is_rational_governance precept
    (natural_law_participates_in_eternal precept h_nl)

/-- Bridge to NaturalLaw.lean: rational convergence is QUALIFIED by the
    primary/secondary distinction.
    NaturalLaw.lean's `rational_convergence` claims all reasoners should
    reach the same moral conclusions. Aquinas's framework QUALIFIES this:
    - For PRIMARY precepts: convergence holds (they are self-evident to all)
    - For SECONDARY precepts: convergence may fail because derivation
      requires prudential judgment, which varies with experience and virtue
    This is a SOFTENING of the CCC's compression — the CCC implies universal
    convergence, but Aquinas allows for legitimate disagreement at the
    secondary level. -/
theorem primary_convergence_secondary_divergence :
    -- Primary: self-evident to all who grasp the terms
    (∀ (p : Prop), isPrimaryPrecept p → isSelfEvident p) ∧
    -- Secondary: NOT self-evident, derivation requires prudence
    (∀ (s : Prop), isSecondaryPrecept s → ¬isSelfEvident s) :=
  ⟨fun p h => (primary_precepts_are_self_evident p h).1,
   fun s h => (secondary_precepts_are_natural_law s h).2⟩

/-!
## Summary

### What the four-fold hierarchy reveals

1. **Natural law is not autonomous.** It derives its authority from eternal law
   (participation), not from reason's own self-grounding. This dissolves the
   `divine_grounding` tension in NaturalLaw.lean: reason DISCOVERS the law,
   but the law's AUTHORITY comes from its participation in God's rational
   governance.

2. **The derivation from primary to secondary precepts is genuinely non-deductive.**
   The gap between self-evident principles and concrete moral conclusions requires
   prudential judgment — practical wisdom that cannot be reduced to an algorithm.
   This means natural law is both OBJECTIVE (grounded in human nature and eternal
   law) and PARTIALLY INDETERMINATE (its application requires virtue).

3. **The CCC's compression hides a dependency chain.** The CCC treats "natural law"
   as a single concept. Aquinas shows it is actually a four-level hierarchy:
   eternal → natural → human → divine. Each level depends on the one above
   (except divine law, which supplements from outside). Compressing the hierarchy
   makes it look like natural law is self-standing; the full picture shows it
   is grounded in eternal law and supplemented by divine law.

4. **Natural law parallels the intelligibility of creation.** Just as the physical
   world is intelligible because it participates in divine wisdom
   (ScientificInquiry.lean), the moral world is knowable because natural law
   participates in eternal law. Both are instances of P2's two-tier structure:
   the created order (secondary) participates in the divine order (primary)
   without competing with it.

5. **Disagreement about secondary precepts is expected.** Unlike the CCC's
   strong convergence claim (NaturalLaw.lean), Aquinas's framework allows for
   legitimate disagreement at the secondary level. Primary precepts are self-evident;
   secondary precepts require prudence, which varies. This is a feature, not a bug —
   it explains moral diversity without abandoning moral objectivity.

### Key sources used
- [Aquinas] ST I-II q.90 a.1: Law is an ordinance of reason
- [Aquinas] ST I-II q.91 a.2: Natural law = participation in eternal law
- [Aquinas] ST I-II q.93 a.1: Eternal law = divine wisdom directing all things
- [Aquinas] ST I-II q.94 a.2: First principle: "good is to be done, evil avoided"
- [Aquinas] ST I-II q.94 a.4-6: Secondary precepts, prudence, "blotting out"
- [Aquinas] ST I-II q.95 a.2: Human law derived from natural law
- [CCC] §1954-1960: Natural law (compressed version)
- [CCC] §302-303: Divine governance and secondary causes (S4, P2)

### Cross-file connections
- `NaturalLaw.lean`: `moral_realism`, `rational_convergence`, `divine_grounding`
- `ScientificInquiry.lean`: `godCreatesThruWisdom`, `worldIsLogical` (parallel participation)
- `Intelligibility.lean`: `intellectAdequateToReality` (the *adaequatio* is the
  epistemological instance of the same participation structure)
- `Axioms.lean`: S3 (law on hearts), S4 (universal providence), S6 (moral realism)
- `Providence.lean`: `divinelyGoverned` (eternal law IS rational governance)
-/

end Catlib.MoralTheology.NaturalLawDepth
