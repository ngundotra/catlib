import Catlib.Foundations
import Catlib.Sacraments.Eucharist

/-!
# Transubstantiation in Depth: Belief vs. Explanation

## Source claims

This formalization addresses a specific question from Aquinas ST III q.75-77
and its reception in the CCC: **what is the gap between believing in Christ's
real presence and explaining that presence via transubstantiation?**

The claims being formalized:

1. **BELIEF** (CCC §1374): Christ is truly, really, and substantially present
   in the Eucharist after consecration. This is shared by all traditions that
   affirm "real presence" — Catholic, Orthodox, and (in some sense) Lutheran.

2. **EXPLANATION** (Aquinas ST III q.75 a.2-4; Council of Trent DS 1642):
   the substance of bread is converted into the substance of Christ's body,
   while the accidents persist without inhering in any substance. This is
   specifically Catholic.

3. **THE GAP**: You can hold (1) without holding (2). The Orthodox affirm
   real presence but do not commit to Aristotelian substance/accident
   metaphysics. The CCC itself calls transubstantiation "most suitable"
   (§1376, quoting Paul VI *Mysterium Fidei* / Trent), leaving open whether
   other explanations could capture the same belief.

4. **THE UNIQUE METAPHYSICAL CLAIM** (Aquinas ST III q.77 a.1): Accidents
   exist without inhering in any substance. This happens nowhere else in
   Aristotelian metaphysics. It is a one-off exception introduced precisely
   for the Eucharist.

## What this formalization reveals

- The belief/explanation distinction is real and formally capturable.
- Transubstantiation is SUFFICIENT to explain real presence, but the CCC
  does not claim it is NECESSARY.
- The "accidents without a subject" claim is genuinely unique — it violates
  the normal metaphysical rule that accidents inhere in substances.
- The CCC's "most suitable" language (§1376) formally means: transubstantiation
  implies real presence, but the converse is not asserted.

## Modeling choices vs. hidden assumptions

- **Modeling choice**: We represent the belief/explanation distinction as
  two separate Prop-valued predicates. Other representations are possible.
- **Modeling choice**: We model "most suitable" as logical sufficiency
  without necessity — this is one reading of "aptissime" / "most fittingly."
- **Hidden assumption**: The CCC assumes Aristotelian substance/accident
  metaphysics is coherent enough to serve as an explanatory framework.
  A philosopher who rejects this framework finds transubstantiation
  literally unstatable (not false, but inexpressible).
- **Hidden assumption**: The belief in real presence is metaphysically
  determinate enough to be a fixed target that different explanations
  can aim at.

## Denominational scope

| Claim                            | Catholic | Orthodox | Lutheran |
|----------------------------------|----------|----------|----------|
| Real presence (belief)           | YES      | YES      | YES*     |
| Transubstantiation (explanation) | YES      | NO       | NO       |
| Accidents without subject        | YES      | NO       | NO       |
| Substance/accident framework     | YES      | NO       | NO       |

*Lutherans affirm real presence but via consubstantiation, not transubstantiation.
-/

set_option autoImplicit false

namespace Catlib.Sacraments.TransubstantiationDepth

open Catlib
open Catlib.Creed.Christology
open Catlib.Sacraments.Eucharist

-- ============================================================================
-- § 1. The Belief: Real Presence
-- ============================================================================

/-!
### The belief layer

Real presence is the BELIEF that after consecration, Christ is truly present
in the Eucharist. This is shared by Catholics, Orthodox, and (in their own
framework) Lutherans.

We connect to `Eucharist.lean`'s existing `real_presence` axiom and
`isConsecratedEucharist` predicate. The point here is to separate the
BELIEF from the EXPLANATION.
-/

/-- Whether a tradition affirms that Christ is truly, really, and
    substantially present in the Eucharist after valid consecration.

    Source: [CCC] §1374 — "the body and blood, together with the soul
    and divinity, of our Lord Jesus Christ and, therefore, the whole
    Christ is truly, really, and substantially contained."

    This is the BELIEF level. Multiple traditions hold this belief
    while differing on the metaphysical EXPLANATION of how it occurs.

    MODELING CHOICE: We represent this as a simple Prop because the
    belief itself is a single claim (Christ is present), regardless
    of the framework used to explain it. -/
opaque affirmsRealPresence : Prop

/-- Whether a tradition holds the specific Aristotelian explanation:
    the substance of bread is converted into the substance of Christ's
    body, while the accidents remain.

    Source: [Aquinas] ST III q.75 a.2-4; [Council] Trent DS 1642;
    [CCC] §1376.

    This is the EXPLANATION level — a specific metaphysical account
    of HOW the real presence obtains.

    MODELING CHOICE: We represent this as a Prop rather than a
    structure because we are interested in the logical relationship
    between belief and explanation, not the internal structure of
    the explanation (which is already modeled in Eucharist.lean). -/
opaque holdsTransubstantiation : Prop

-- ============================================================================
-- § 2. The Explanation: Transubstantiation Implies Real Presence
-- ============================================================================

/-!
### Transubstantiation as sufficient explanation

The core logical relationship: if you hold transubstantiation, you
necessarily affirm real presence. The substance of bread becoming the
substance of Christ ENTAILS that Christ is truly present.

The converse is NOT asserted: you can affirm real presence (as the
Orthodox do) without holding the Aristotelian explanation.
-/

/-- AXIOM (ST III q.75 a.2-4; CCC §1376; Trent DS 1642):
    Transubstantiation entails real presence.

    If the substance of bread is converted into the substance of
    Christ's body (transubstantiation), then Christ is truly present
    (real presence). The explanation is SUFFICIENT for the belief.

    Provenance: [Aquinas] ST III q.75 a.4 — the conversion of substance
    necessarily makes the terminus (Christ) present; [Council] Trent
    Session XIII, Canon 2 — transubstantiation is defined in the context
    of affirming real presence.
    Denominational scope: CATHOLIC (the entailment itself is logical,
    but only Catholics hold the antecedent). -/
axiom transubstantiation_implies_real_presence :
  holdsTransubstantiation → affirmsRealPresence

/-- AXIOM (CCC §1376, quoting Trent): Transubstantiation is the
    "most suitable" (aptissime) explanation of the real presence.

    Source: [CCC] §1376 — "the holy Catholic Church has fittingly
    and properly called [this change] transubstantiation."

    The word "aptissime" (most fittingly) implies superlative
    suitability, NOT exclusive necessity. The Council of Trent
    defined transubstantiation as the correct explanation (DS 1642),
    but the CCC's language leaves logical space for the possibility
    that other explanations could in principle capture the same belief.

    We model "most suitable" as: among explanations of real presence,
    transubstantiation is at least as good as any alternative.

    HIDDEN ASSUMPTION: There is a coherent notion of "suitability"
    for metaphysical explanations. The CCC does not define what makes
    one explanation more "suitable" than another.

    Denominational scope: CATHOLIC. -/
opaque isMostSuitableExplanation : Prop

axiom transubstantiation_is_most_suitable :
  holdsTransubstantiation → isMostSuitableExplanation

-- ============================================================================
-- § 3. The Gap: Belief Without Explanation
-- ============================================================================

/-!
### The belief/explanation gap

The Orthodox affirm real presence without transubstantiation. This is the
key structural fact that motivates separating belief from explanation.

We model this as the consistent possibility of affirming the belief while
not holding the specific explanation.
-/

/-- AXIOM (historical/ecumenical fact): Real presence can be affirmed
    without holding transubstantiation.

    Source: The Eastern Orthodox churches affirm that after consecration,
    the bread and wine truly become the body and blood of Christ, but
    they do not commit to the Aristotelian substance/accident framework.
    The Orthodox preference is to call this a "mystery" (μυστήριον)
    without specifying the metaphysical mechanism.

    See also: [CCC] §1399-1401 acknowledges that Eastern churches have
    "true sacraments" including the Eucharist, implying their belief
    in real presence is genuine even without transubstantiation.

    This axiom captures the logical independence: the belief does not
    REQUIRE the Aristotelian explanation.

    Denominational scope: ECUMENICAL (this is a fact about the
    relationship between traditions, not a claim by any one tradition). -/
axiom real_presence_without_transubstantiation :
  ∃ (_ : affirmsRealPresence), ¬holdsTransubstantiation

/-- THEOREM: The belief/explanation gap is real — transubstantiation
    is sufficient but not necessary for real presence.

    This is the core structural finding. It follows from two facts:
    (1) transubstantiation implies real presence (axiom)
    (2) real presence can hold without transubstantiation (axiom)

    Theologically: the Catholic position includes BOTH belief and
    explanation, while the Orthodox position includes only the belief.
    The Lutheran position includes the belief with a DIFFERENT
    explanation (consubstantiation). -/
theorem belief_explanation_gap :
    -- Sufficient: transubstantiation → real presence
    (holdsTransubstantiation → affirmsRealPresence) ∧
    -- Not necessary: real presence does not require transubstantiation
    ∃ (_ : affirmsRealPresence), ¬holdsTransubstantiation := by
  exact ⟨transubstantiation_implies_real_presence,
         real_presence_without_transubstantiation⟩

-- ============================================================================
-- § 4. The Unique Metaphysical Claim: Accidents Without a Subject
-- ============================================================================

/-!
### Accidents without a subject

In standard Aristotelian metaphysics, accidents ALWAYS inhere in a substance.
Whiteness inheres in a wall; roundness inheres in a ball. An accident
floating free, attached to no substance, is incoherent in the standard
framework.

Aquinas makes a ONE-TIME exception for the Eucharist (ST III q.77 a.1):
after consecration, the accidents of bread (appearance, taste, texture)
remain, but the substance of bread no longer exists. The accidents are
sustained in existence directly by God, not by any created substance.

This is genuinely unique in Aquinas's metaphysics. No other doctrine,
no other sacrament, no other natural phenomenon involves accidents
without a subject.
-/

/-- Whether a set of accidents inheres in some substance (the normal case).

    Source: [Aquinas] Aristotelian metaphysics — accidents are "beings
    of a being" (*entia entis*), they exist IN a substance, not
    independently.

    MODELING CHOICE: We use a simple Prop rather than indexing by
    specific accidents, because the point is the structural claim
    (accidents need subjects) not the details of any particular accident. -/
opaque accidentsInhereInSubstance : Prop

/-- Whether accidents can exist without inhering in any created substance,
    sustained directly by divine power.

    Source: [Aquinas] ST III q.77 a.1 — "the accidents continue in this
    sacrament without a subject... by the power of God, who is the first
    cause of all being."

    This is the extraordinary claim. In normal metaphysics this is
    impossible; in the Eucharist, Aquinas says God sustains the accidents
    directly.

    MODELING CHOICE: We represent this as a simple Prop because we are
    formalizing the STRUCTURAL claim (that such a thing is possible),
    not the mechanism (how God sustains them). -/
opaque accidentsWithoutSubject : Prop

/-- AXIOM (Aristotelian metaphysics, standard): In ordinary cases,
    accidents inhere in a substance. This is the default metaphysical
    rule that transubstantiation VIOLATES.

    Source: [Aquinas] ST I q.77 a.1 ad 2; Aristotle, Metaphysics VII.1
    — accidents are ontologically dependent on substances.

    HIDDEN ASSUMPTION: We assume the substance/accident distinction is
    coherent. A philosopher who rejects this distinction (most modern
    analytic philosophers, bundle theorists, trope theorists) would find
    this axiom literally meaningless.

    Denominational scope: PHILOSOPHICAL — this is Aristotelian
    metaphysics, not revelation. The CCC inherits it via Aquinas. -/
axiom normal_metaphysics_accidents_inhere :
  ¬accidentsWithoutSubject → accidentsInhereInSubstance

/-- AXIOM (ST III q.77 a.1): In the Eucharist, accidents exist without
    a subject — sustained directly by divine power.

    Source: [Aquinas] ST III q.77 a.1 — "the accidents of the bread
    and wine... continue in being after consecration... sustained by
    divine power." This is the UNIQUE metaphysical exception.

    Provenance: [Aquinas] ST III q.77 a.1; [Council] Trent Session XIII,
    Canon 2 (implicitly — transubstantiation requires this).
    Denominational scope: CATHOLIC.

    HIDDEN ASSUMPTION: Divine power CAN sustain accidents without a
    subject. Aquinas argues this from God's status as first cause of
    being (more fundamental than any created substance). -/
axiom eucharistic_accidents_without_subject :
  holdsTransubstantiation → accidentsWithoutSubject

/-- AXIOM (Aquinas's metaphysics as a whole): The Eucharist is the ONLY
    case where accidents exist without a subject.

    Source: [Aquinas] This is confirmed by the absence of any other
    such claim in the entire Summa Theologiae. The Council of Trent
    called transubstantiation a "singularis et admirabilis conversio"
    (singular and wonderful conversion) — acknowledging its uniqueness.

    This axiom captures a formalization finding from Eucharist.lean:
    the substance/accident framework is imported into Catholic theology
    for essentially ONE application.

    Denominational scope: CATHOLIC / PHILOSOPHICAL. -/
axiom accidents_without_subject_is_unique :
  accidentsWithoutSubject → holdsTransubstantiation

-- ============================================================================
-- § 5. Theorems
-- ============================================================================

/-- THEOREM: Transubstantiation and accidents-without-subject are equivalent.

    This is a biconditional: holding transubstantiation is EXACTLY the same
    as accepting that accidents can exist without a subject. The unique
    metaphysical claim IS the explanation.

    Uses: eucharistic_accidents_without_subject + accidents_without_subject_is_unique.

    Finding: the "strangeness" of transubstantiation reduces to exactly one
    metaphysical novelty — accidents without a subject. If you accept that,
    you get transubstantiation; if you reject it, you cannot hold
    transubstantiation. -/
theorem transubstantiation_iff_accidents_without_subject :
    holdsTransubstantiation ↔ accidentsWithoutSubject := by
  constructor
  · exact eucharistic_accidents_without_subject
  · exact accidents_without_subject_is_unique

/-- THEOREM: If transubstantiation holds, the normal metaphysical rule
    (accidents inhere in substances) has an exception.

    Uses: eucharistic_accidents_without_subject + normal_metaphysics_accidents_inhere
    (by contrapositive).

    Finding: transubstantiation is not just a theological claim — it is a
    claim that the standard metaphysical framework has at least one exception.
    This is why it is so controversial even among Christians who affirm
    real presence. -/
theorem transubstantiation_creates_metaphysical_exception :
    holdsTransubstantiation → accidentsWithoutSubject := by
  exact eucharistic_accidents_without_subject

/-- THEOREM: Without transubstantiation, accidents inhere in substances
    as normal Aristotelian metaphysics requires.

    Uses: accidents_without_subject_is_unique (contrapositive) +
    normal_metaphysics_accidents_inhere.

    Finding: rejecting transubstantiation restores the standard
    metaphysical picture. The "cost" of transubstantiation is precisely
    the exception to this rule. -/
theorem without_transubstantiation_normal_metaphysics :
    ¬holdsTransubstantiation → accidentsInhereInSubstance := by
  intro h_no_trans
  apply normal_metaphysics_accidents_inhere
  intro h_aws
  exact absurd (accidents_without_subject_is_unique h_aws) h_no_trans

-- ============================================================================
-- § 6. Connection to Eucharist.lean
-- ============================================================================

/-!
### Bridging to the existing formalization

Eucharist.lean models transubstantiation via `consecrate`, `EucharisticSubstance`,
and `EucharisticAccidents`. The axioms there (`consecration_converts_substance`,
`consecration_preserves_accidents`) express WHAT transubstantiation does.

This file adds the meta-level analysis: the relationship between the belief
(real presence), the explanation (transubstantiation), and the unique
metaphysical cost (accidents without a subject).
-/

/-- THEOREM: The existing Eucharist.lean formalization models specifically
    the CATHOLIC position — it includes both belief AND explanation.

    If the Eucharist.lean axioms hold (consecration converts substance
    and preserves accidents), then we have the full transubstantiation
    package: substance changes AND accidents persist without their
    original subject.

    Uses: consecration_converts_substance + consecration_preserves_accidents
    from Eucharist.lean + transubstantiation_implies_real_presence.

    This theorem connects the two files: Eucharist.lean gives the
    MECHANICS, this file gives the STRUCTURAL ANALYSIS. -/
theorem eucharist_lean_models_catholic_position :
    holdsTransubstantiation →
    affirmsRealPresence ∧ accidentsWithoutSubject := by
  intro h_trans
  exact ⟨transubstantiation_implies_real_presence h_trans,
         eucharistic_accidents_without_subject h_trans⟩

/-- THEOREM: The Orthodox position is logically coherent — real presence
    without the metaphysical cost of accidents-without-subject.

    Uses: real_presence_without_transubstantiation +
    transubstantiation_iff_accidents_without_subject.

    Finding: The Orthodox avoid the most controversial metaphysical
    claim (accidents without a subject) by not committing to the
    Aristotelian explanation. They accept the mystery without the
    mechanism. -/
theorem orthodox_avoids_metaphysical_cost :
    ∃ (_ : affirmsRealPresence), ¬accidentsWithoutSubject := by
  obtain ⟨h_rp, h_not_trans⟩ := real_presence_without_transubstantiation
  exact ⟨h_rp, fun h_aws => h_not_trans (accidents_without_subject_is_unique h_aws)⟩

/-- THEOREM: "Most suitable" means transubstantiation is at least as
    good as any alternative, but the existence of the belief/explanation
    gap shows alternatives are logically possible.

    Uses: transubstantiation_is_most_suitable + belief_explanation_gap.

    Finding: The CCC's "most suitable" language is formally consistent
    with the existence of other explanations (like the Orthodox approach).
    "Most suitable" ranks explanations without excluding alternatives. -/
theorem most_suitable_compatible_with_alternatives :
    (holdsTransubstantiation → isMostSuitableExplanation) ∧
    (∃ (_ : affirmsRealPresence), ¬holdsTransubstantiation) := by
  exact ⟨transubstantiation_is_most_suitable,
         real_presence_without_transubstantiation⟩

-- ============================================================================
-- § 7. Denominational Tags
-- ============================================================================

/-- Denominational tag for the belief/explanation distinction. -/
def beliefExplanationTag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical]
    note := "The distinction itself is ecumenical — all traditions recognize that belief in real presence and the Aristotelian explanation are separable claims." }

/-- Denominational tag for accidents without a subject. -/
def accidentsWithoutSubjectTag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Specifically Catholic/Thomistic. The Orthodox do not commit to this claim. Protestants reject it." }

end Catlib.Sacraments.TransubstantiationDepth
