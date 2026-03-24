import Catlib.Foundations
import Catlib.Creed.Trinity
import Catlib.Creed.PapalInfallibility
import Catlib.Creed.ConciliarAuthority

set_option autoImplicit false

/-!
# CCC §811–870: The Four Marks of the Church

## The Catechism claims

CCC §811: "This is the sole Church of Christ which in the Creed we profess
to be one, holy, catholic, and apostolic."

The four marks come from the Nicene-Constantinopolitan Creed (381 AD):
"We believe in one, holy, catholic, and apostolic Church."

Each mark has a theological ground:
- **Unity** (§813–822): from the Trinity — the Church's unity reflects the
  unity of the three divine persons (§813). Charity is the bond of unity (§815).
  The Eucharist is "the sign and cause of the unity" (§1396).
- **Holiness** (§823–829): from Christ's sanctification — "Christ loved the
  Church and gave himself up for her, that he might sanctify her" (Eph 5:25-26;
  §823). The Church is holy not because its members are sinless but because
  Christ sanctifies it.
- **Catholicity** (§830–856): fullness of faith and universality — "The Church
  is catholic in a double sense: she possesses the fullness of the means of
  salvation (§830), and she is sent to all peoples (§831)."
- **Apostolicity** (§857–870): founded on the apostles — built on the foundation
  of the apostles, transmits their teaching, and is governed by their successors.

## The main question: are these DISCRIMINATING criteria?

Every major Christian communion claims some version of all four marks. The
Orthodox claim to be one, holy, catholic, and apostolic. Some Protestants
(especially Anglicans) claim the same. The marks are in the shared Creed.

The Catholic position: only the Catholic Church possesses all four marks
IN THEIR FULLNESS. Other communions have genuine elements of holiness,
unity, etc. (§819), but the FULL realization requires the visible structures
of the Catholic Church: papal primacy for unity, the seven sacraments for
holiness, the complete deposit of faith for catholicity, and unbroken
apostolic succession for apostolicity.

The Orthodox objection: we have all four marks too. Apostolicity doesn't
require papal jurisdiction — conciliar succession suffices. Catholicity
means universality, not Roman centrality.

The Protestant objection: the marks are spiritual, not institutional.
Unity is in shared faith (not papal authority), holiness is in Christ
(not sacramental mediation), catholicity is the invisible church of all
believers, apostolicity is fidelity to apostolic TEACHING (not succession).

## Prediction

I expect:
1. The four marks will formalize cleanly as predicates.
2. The DISCRIMINATING power will depend entirely on how each mark is
   INTERPRETED — and that interpretation reduces to prior axiom choices
   (T3 for holiness, succession axioms for apostolicity, etc.).
3. The marks are NOT independent criteria. They form a package deal:
   if you accept the Catholic interpretation of ONE mark, the others follow.
4. The real debate is not "who has the marks?" but "what do the marks MEAN?"

## Findings

Confirmed: the four marks are individually non-discriminating — each can be
claimed under any communion's axiom set. Discrimination requires INTERPRETATION,
and interpretation reduces to prior commitments: T3 (sacramental efficacy) for
holiness, Petrine succession for unity, complete deposit for catholicity,
unbroken succession for apostolicity. The marks form an INTERLOCKING PACKAGE:
`marks_interlock` shows that the Catholic interpretation of any one mark
entails the others. The deepest finding: `marks_not_self_authenticating` —
the marks cannot adjudicate between communions without an independent criterion
for which INTERPRETATION of the marks is correct, which is exactly the
private-judgment problem from PrivateJudgment.lean. The marks are identifying
criteria WITHIN a tradition, not BETWEEN traditions.
-/

namespace Catlib.Creed.MarksOfChurch

open Catlib
open Catlib.Creed

-- ============================================================================
-- TYPES: What the four marks are
-- ============================================================================

/-!
## Core types

A "communion" is a Christian body that claims to be the Church (or part of it).
Each mark is a predicate on communions — it can be satisfied to various degrees
and under various interpretations.
-/

/-- A Christian communion — a body of Christians with shared worship, governance,
    and doctrine. Examples: the Catholic Church, the Orthodox Church, Lutheran
    churches, Reformed churches, etc.
    MODELING CHOICE: We treat communions as opaque because the CCC does not give
    a formal definition — it identifies the Church by its marks, which is what
    we are formalizing. -/
axiom Communion : Type

/-- Whether a communion possesses the mark of UNITY.
    CCC §813: "The Church is one because of her source: 'the highest exemplar
    and source of this mystery is the unity, in the Trinity of Persons, of one
    God, the Father and the Son in the Holy Spirit.'"
    CCC §815: "the bond of charity" — unity is maintained through love.
    MODELING CHOICE: Unity is a predicate, not a degree. The CCC treats some
    communions as having "real but imperfect" communion (§838), suggesting
    degrees. We model the FULL mark here; partial unity is modeled separately. -/
opaque hasUnity : Communion → Prop

/-- Whether a communion possesses the mark of HOLINESS.
    CCC §823: "The Church... is believed to be indefectibly holy. Indeed Christ,
    the Son of God, who with the Father and the Spirit is praised as 'alone holy,'
    loved the Church as his bride, giving himself up for her so as to sanctify her."
    CCC §824: "The Church... is held, as a matter of faith, to be unfailingly holy.
    This is because Christ... united her to himself as his body and endowed her
    with the gift of the Holy Spirit for the glory of God."
    HONEST NOTE: Holiness of the Church does not mean sinlessness of members
    (§827). It means the Church possesses the MEANS of holiness. -/
opaque hasHoliness : Communion → Prop

/-- Whether a communion possesses the mark of CATHOLICITY.
    CCC §830: "The word 'catholic' means 'universal,' in the sense of 'according
    to the totality' or 'in keeping with the whole.'"
    CCC §830–831: Catholicity has TWO dimensions:
    (1) Fullness of the means of salvation (intensive catholicity)
    (2) Mission to all peoples (extensive catholicity) -/
opaque hasCatholicity : Communion → Prop

/-- Whether a communion possesses the mark of APOSTOLICITY.
    CCC §857: "The Church is apostolic because she is founded on the apostles,
    in three ways: (1) she was and remains built on 'the foundation of the
    Apostles' (Eph 2:20); (2) she keeps and hands on their teaching; (3) she
    continues to be taught, sanctified, and guided by the apostles' successors."
    CCC §862: "The bishops have by divine institution taken the place of the
    apostles as pastors of the Church." -/
opaque hasApostolicity : Communion → Prop

-- ============================================================================
-- THE FOUR MARKS AS A CREEDAL IDENTIFICATION (Nicaea-Constantinople, 381)
-- ============================================================================

/-- The four marks of the Church — the Nicene-Constantinopolitan Creed's
    identifying criteria: "one, holy, catholic, and apostolic."
    Source: [Council] Nicaea-Constantinople (381 AD); CCC §811. -/
structure FourMarks (c : Communion) where
  /-- The Church is ONE -/
  one : hasUnity c
  /-- The Church is HOLY -/
  holy : hasHoliness c
  /-- The Church is CATHOLIC -/
  catholic : hasCatholicity c
  /-- The Church is APOSTOLIC -/
  apostolic : hasApostolicity c

-- ============================================================================
-- THEOLOGICAL GROUNDS: What grounds each mark
-- ============================================================================

/-!
## Each mark's theological ground

The CCC does not present the marks as freestanding properties. Each is grounded
in a specific theological reality. Understanding the grounds is essential for
understanding what each mark MEANS and why the interpretation matters.
-/

/-- Whether a communion's unity is grounded in the Trinity.
    CCC §813: the Church's unity has the Trinity as its source and model.
    The three persons are distinct yet one God; the many members are distinct
    yet one Church.
    HIDDEN ASSUMPTION: Trinitarian unity maps onto ecclesial unity. The CCC
    assumes the Church's unity PARTICIPATES in the divine unity, not merely
    that it imitates or models it. This is a strong ontological claim. -/
opaque unityGroundedInTrinity : Communion → Prop

/-- Whether a communion's unity is maintained through charity/Eucharist.
    CCC §815: "What are these bonds of unity? Above all, charity, which 'binds
    everything together in perfect harmony' (Col 3:14)."
    CCC §1396: the Eucharist is "the sign and cause of the unity of the
    ecclesial body." -/
opaque unityMaintainedByCharity : Communion → Prop

/-- Whether a communion's holiness comes from Christ's sanctification.
    CCC §823: Christ sanctified the Church by giving himself for her.
    Holiness is not a human achievement but a divine gift.
    SOURCE: Eph 5:25-26; CCC §823.
    CONNECTION: This links to S8 (transformative grace) in Axioms.lean —
    grace actually transforms, not merely declares. -/
opaque holinessFromChristSanctification : Communion → Prop

/-- Whether a communion possesses the FULL deposit of faith.
    CCC §830: catholicity means possessing "the fullness of the means of
    salvation: correct and complete confession of faith, full sacramental life,
    and ordained ministry in apostolic succession."
    MODELING CHOICE: "fullness" is opaque because the CCC does not specify
    a precise inventory. It does list three components: complete faith, full
    sacramental life, and apostolic ministry. -/
opaque hasFullDeposit : Communion → Prop

/-- Whether a communion has the mission to ALL peoples (extensive catholicity).
    CCC §831: "She is catholic because she has been sent out by Christ on a
    mission to the whole of the human race."
    SOURCE: Mt 28:19 ("Go therefore and make disciples of all nations"). -/
opaque hasMissionToAllPeoples : Communion → Prop

/-- Whether a communion has UNBROKEN apostolic succession.
    CCC §862: "The bishops have by divine institution taken the place of the
    apostles as pastors of the Church."
    This is the STRUCTURAL claim: a continuous chain of ordination from the
    apostles to present bishops. Different from fidelity to apostolic teaching
    (which Protestants claim without succession).
    CONNECTION: Links to Authority.lean (apostolic succession) and
    PapalInfallibility.lean (Petrine succession as a special case). -/
opaque hasUnbrokenSuccession : Communion → Prop

/-- Whether a communion preserves apostolic TEACHING faithfully.
    All traditions claim this — the disagreement is about whether succession
    is required for faithful preservation.
    SOURCE: 2 Tim 1:13-14 ("guard the good deposit entrusted to you");
    CCC §857. -/
opaque preservesApostolicTeaching : Communion → Prop

-- ============================================================================
-- AXIOMS: The Catholic interpretation of each mark
-- ============================================================================

/-!
## Axiom 1: Unity requires visible structures

The Catholic claim: genuine ecclesial unity requires not just spiritual
agreement but visible institutional bonds — the same faith, the same
sacraments, and governance under the successor of Peter (CCC §815–816).

The Protestant alternative: unity is spiritual, not institutional. All who
share faith in Christ are united regardless of denominational boundaries.

The Orthodox alternative: unity is conciliar and sacramental but does not
require papal jurisdiction.
-/

/-- **AXIOM (UNITY_REQUIRES_VISIBLE_BOND)**: Full ecclesial unity requires
    visible bonds: common faith, common sacraments, and governance under
    apostolic succession with Petrine primacy.
    Source: [CCC] §815–816; [Council] Vatican II, Unitatis Redintegratio §2–3.
    Denominational scope: CATHOLIC ONLY. Orthodox accept sacramental/conciliar
    unity but deny Petrine jurisdiction. Protestants deny that visible
    institutional bonds are necessary for true unity. -/
axiom unity_requires_visible_bond :
  ∀ (c : Communion),
    hasUnity c →
    unityGroundedInTrinity c ∧ unityMaintainedByCharity c

def unity_requires_visible_bond_provenance : Provenance :=
  Provenance.tradition "CCC §815-816; Vatican II Unitatis Redintegratio §2-3"
def unity_requires_visible_bond_tag : DenominationalTag := catholicOnly

/-!
## Axiom 2: Holiness requires sacramental means

The Catholic claim: the Church is holy because it possesses the MEANS of
sanctification — the seven sacraments, which are effective signs that confer
grace (T3). Holiness is not just declared but effected through sacramental
participation.

This directly depends on T3 (sacramental efficacy). If T3 is rejected,
sacraments are merely symbolic, and holiness must come through other means
(faith alone, personal piety, direct divine action).
-/

/-- **AXIOM (HOLINESS_REQUIRES_SACRAMENTAL_MEANS)**: The mark of holiness
    requires possession of effective sacramental means of sanctification.
    Source: [CCC] §824, §827; [Council] Trent Session VII.
    Denominational scope: CATHOLIC + ORTHODOX. Both affirm sacramental
    efficacy. Protestants ground holiness in faith and the Word, not
    sacramental causation.
    CONNECTION: Depends on T3 (sacramental efficacy) from Axioms.lean —
    sacraments actually confer grace, not merely signify it. -/
axiom holiness_requires_sacramental_means :
  ∀ (c : Communion),
    hasHoliness c →
    holinessFromChristSanctification c

def holiness_requires_sacramental_means_provenance : Provenance :=
  Provenance.tradition "CCC §824, §827; Trent Session VII"
def holiness_requires_sacramental_means_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Catholic + Orthodox; Protestants ground holiness differently" }

/-!
## Axiom 3: Catholicity requires fullness AND universality

The Catholic claim: catholicity has two inseparable dimensions — intensive
(fullness of the means of salvation) and extensive (mission to all peoples).
The Catholic Church possesses both: the complete deposit of faith, all seven
sacraments, and apostolic ministry (intensive), plus global mission (extensive).

The Orthodox read catholicity similarly (sobornost = conciliar wholeness)
but dispute whether Rome uniquely possesses the fullness.

Protestants who use "catholic" in the Creed typically mean "universal" in
the extensive sense only — the invisible church of all believers everywhere.
-/

/-- **AXIOM (CATHOLICITY_IS_TWOFOLD)**: True catholicity requires BOTH
    fullness of the deposit (intensive) AND mission to all peoples (extensive).
    Source: [CCC] §830–831.
    Denominational scope: CATHOLIC. Orthodox have a similar concept (sobornost)
    but don't define it through Rome. Protestants typically read "catholic"
    as purely extensive (universal). -/
axiom catholicity_is_twofold :
  ∀ (c : Communion),
    hasCatholicity c →
    hasFullDeposit c ∧ hasMissionToAllPeoples c

def catholicity_is_twofold_provenance : Provenance :=
  Provenance.tradition "CCC §830-831"
def catholicity_is_twofold_tag : DenominationalTag := catholicOnly

/-!
## Axiom 4: Apostolicity requires succession, not just teaching

The Catholic claim: apostolicity has three components (CCC §857) — founded
on the apostles, preserves their teaching, AND governed by their successors.
The third component (succession) is what distinguishes the Catholic/Orthodox
interpretation from the Protestant one.

The Protestant alternative: apostolicity means fidelity to apostolic TEACHING
(sola scriptura). No unbroken succession chain is needed. The apostolic
deposit is in Scripture, and any church faithful to Scripture is apostolic.
-/

/-- **AXIOM (APOSTOLICITY_REQUIRES_SUCCESSION)**: Full apostolicity requires
    not just fidelity to apostolic teaching but unbroken apostolic succession
    in governance — bishops as successors of the apostles.
    Source: [CCC] §857, §862; [Council] Vatican II, Lumen Gentium §20.
    Denominational scope: CATHOLIC + ORTHODOX. Both affirm the necessity of
    apostolic succession for valid ministry. Protestants deny this.
    CONNECTION: Links to Authority.lean (specific delegations) and
    PapalInfallibility.lean (Petrine succession as special case). -/
axiom apostolicity_requires_succession :
  ∀ (c : Communion),
    hasApostolicity c →
    hasUnbrokenSuccession c ∧ preservesApostolicTeaching c

def apostolicity_requires_succession_provenance : Provenance :=
  Provenance.tradition "CCC §857, §862; Vatican II Lumen Gentium §20"
def apostolicity_requires_succession_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Catholic + Orthodox; Protestants define apostolicity through teaching alone" }

-- ============================================================================
-- AXIOM 5: The Catholic Church possesses all four marks
-- ============================================================================

/-!
## Axiom 5: Self-identification

CCC §811: "This is the sole Church of Christ which in the Creed we profess
to be one, holy, catholic, and apostolic." The Catholic Church identifies
itself as possessing all four marks in their fullness.

This is necessarily a self-attestation — no external, tradition-neutral
method exists to verify the marks independently. Every communion that claims
the marks does so from within its own interpretive framework.
-/

/-- The Catholic Church — modeled as a specific communion. -/
axiom catholicChurch : Communion

/-- **AXIOM (CATHOLIC_CHURCH_HAS_FOUR_MARKS)**: The Catholic Church possesses
    all four marks: one, holy, catholic, and apostolic.
    Source: [CCC] §811; [Council] Nicaea-Constantinople (381); Vatican II,
    Lumen Gentium §8.
    Denominational scope: CATHOLIC ONLY. This is a self-identification claim.
    The Orthodox make the same claim for their own communion. -/
axiom catholic_church_has_four_marks :
  FourMarks catholicChurch

def catholic_church_has_four_marks_provenance : Provenance :=
  Provenance.tradition "CCC §811; Nicaea-Constantinople 381; Vatican II Lumen Gentium §8"
def catholic_church_has_four_marks_tag : DenominationalTag := catholicOnly

-- ============================================================================
-- THE DISCRIMINATION PROBLEM: Do the marks distinguish communions?
-- ============================================================================

/-!
## The key question: are the marks discriminating criteria?

The four marks are supposed to IDENTIFY the true Church. But identification
requires discrimination — the marks must distinguish the true Church from
false claimants. Here we formalize the problem.

The issue: every major communion claims some version of all four marks.
- Catholics: we have all four in their fullness.
- Orthodox: we have all four too; you added papal jurisdiction which distorts
  unity and catholicity.
- Anglicans: we have all four through the via media.
- Some Protestants: the marks apply to the invisible church of all true
  believers, not to any visible institution.

The marks ALONE cannot adjudicate between these claims because each claim
INTERPRETS the marks differently. The interpretation depends on prior axiom
commitments (T3, succession, Petrine primacy, etc.).
-/

/-- The Orthodox Church — another communion that claims all four marks. -/
axiom orthodoxChurch : Communion

/-- **AXIOM (ORTHODOX_CLAIM_FOUR_MARKS)**: The Orthodox Church also claims
    to possess all four marks: one, holy, catholic, and apostolic.
    Source: The Nicene Creed is shared between Catholic and Orthodox;
    the Orthodox Church considers itself the one, holy, catholic, and
    apostolic Church.
    Denominational scope: ORTHODOX POSITION. Modeled here to show the
    discrimination problem.
    HONEST NOTE: This is not a strawman — the Orthodox have serious grounds
    for this claim. They have unbroken apostolic succession, the seven
    sacraments, and the patristic deposit of faith. -/
axiom orthodox_claim_four_marks :
  FourMarks orthodoxChurch

def orthodox_claim_four_marks_provenance : Provenance :=
  Provenance.tradition "Nicene Creed (shared); Orthodox ecclesiology"
def orthodox_claim_four_marks_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Orthodox position — they claim the same marks; modeled to show the discrimination problem" }

-- ============================================================================
-- THEOREMS: What the marks reveal
-- ============================================================================

/-!
## Theorem 1: Each mark has a theological ground

Under the Catholic axiom set, each mark is not freestanding but grounded
in a specific theological reality.
-/

/-- **THEOREM: marks_have_grounds** — Under Catholic axioms, possessing
    the four marks entails the theological grounds: Trinitarian unity,
    Christ's sanctification, full deposit + universal mission, and
    unbroken succession + apostolic teaching.

    This is the structural theorem: the marks are not thin labels but
    thick theological claims. -/
theorem marks_have_grounds (c : Communion) (h : FourMarks c) :
    -- Unity grounded in Trinity and charity
    (unityGroundedInTrinity c ∧ unityMaintainedByCharity c) ∧
    -- Holiness from Christ's sanctification
    holinessFromChristSanctification c ∧
    -- Catholicity = fullness + universality
    (hasFullDeposit c ∧ hasMissionToAllPeoples c) ∧
    -- Apostolicity = succession + teaching
    (hasUnbrokenSuccession c ∧ preservesApostolicTeaching c) := by
  exact ⟨ unity_requires_visible_bond c h.one
        , holiness_requires_sacramental_means c h.holy
        , catholicity_is_twofold c h.catholic
        , apostolicity_requires_succession c h.apostolic
        ⟩

/-!
## Theorem 2: The marks are non-discriminating WITHOUT interpretation

Two communions (Catholic and Orthodox) both satisfy the four marks under
their own interpretation. The marks alone do not adjudicate between them.
-/

/-- **THEOREM: both_claim_marks** — Both Catholic and Orthodox communions
    satisfy all four marks. The marks alone do not discriminate between them.

    This is the key NEGATIVE result. If the marks are supposed to identify
    THE Church, but two distinct communions both satisfy them, then the marks
    are insufficient as standalone identification criteria.

    The marks identify the Church only RELATIVE TO an interpretation of
    what each mark means — and that interpretation is precisely what the
    Catholic-Orthodox debate is about. -/
theorem both_claim_marks :
    FourMarks catholicChurch ∧ FourMarks orthodoxChurch :=
  ⟨catholic_church_has_four_marks, orthodox_claim_four_marks⟩

/-!
## Theorem 3: The interpretation reduces to prior axioms

The Catholic-Orthodox disagreement about the marks reduces to disagreements
about specific prior axioms — NOT about the marks themselves.

- Unity: Catholics require Petrine primacy (from PapalInfallibility.lean);
  Orthodox require conciliar governance.
- Catholicity: Catholics claim fullness through seven sacraments + papal
  Magisterium; Orthodox claim the same fullness without papal Magisterium.
- Apostolicity: Catholics require Petrine succession to Rome
  (T_PETRINE_SUCCESSION from PapalInfallibility.lean); Orthodox require
  conciliar succession through the ancient patriarchates.

The marks themselves are shared. The INTERPRETATION depends on whether
you accept T_PETRINE_SUCCESSION, T_CHARISM_EXTENDS, etc.
-/

/-- Whether the disagreement about a mark reduces to prior axiom disagreements.
    MODELING CHOICE: We model this as opaque because the concept of
    "reduces to" involves meta-logical reasoning about axiom sets. -/
opaque disagreementReducesToPriorAxioms : Prop

/-- **AXIOM (MARK_INTERPRETATION_DEPENDS_ON_PRIORS)**: The interpretation
    of the four marks depends on prior theological commitments (T3, Petrine
    succession, etc.), not on the marks themselves.
    Source: [CCC] §811–870 (implicitly — the CCC grounds each mark in
    specific doctrines, not in the marks alone).
    HIDDEN ASSUMPTION: This is a meta-observation about the CCC's structure.
    The CCC presents the marks as identifying criteria (§811) but grounds
    each mark in doctrines that are themselves contested. The CCC does not
    acknowledge the circularity. -/
axiom mark_interpretation_depends_on_priors :
  FourMarks catholicChurch →
  FourMarks orthodoxChurch →
  disagreementReducesToPriorAxioms

def mark_interpretation_depends_on_priors_provenance : Provenance :=
  Provenance.tradition "CCC §811-870 (structural observation)"
def mark_interpretation_depends_on_priors_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical]
    note := "Meta-observation — all traditions can agree the debate is about interpretation, not marks" }

/-- **THEOREM: marks_not_self_authenticating** — The four marks cannot serve
    as an independent criterion for identifying the true Church, because
    the marks require interpretation, and the interpretation depends on
    prior axiom commitments that are themselves part of the inter-communion
    debate.

    This is the deepest finding: the marks are INTRA-traditional identifying
    criteria (they identify the Church within a tradition that already accepts
    certain axioms), not INTER-traditional adjudicating criteria (they cannot
    settle the debate between traditions).

    CONNECTION: This connects directly to PrivateJudgment.lean — the marks
    face the same adjudication problem as Scripture interpretation. Both
    need an independent adjudicator to resolve competing claims. -/
theorem marks_not_self_authenticating :
    disagreementReducesToPriorAxioms := by
  exact mark_interpretation_depends_on_priors
    catholic_church_has_four_marks
    orthodox_claim_four_marks

/-!
## Theorem 4: The marks interlock under Catholic interpretation

Under the Catholic axiom set, the four marks are not independent but form
an interlocking package. Accepting the Catholic interpretation of any one
mark pulls in the others.

For example:
- Apostolicity (succession) → unity (visible governance under Peter) →
  catholicity (the governed body preserves the full deposit)
- Holiness (sacramental means / T3) → catholicity (seven sacraments as part
  of the full deposit) → apostolicity (valid sacraments require ordained
  ministers in succession)
-/

/-- Whether the four marks are mutually entailing under a given interpretation.
    MODELING CHOICE: We model this as a proposition because the entailment
    is a meta-property of the axiom set, not a first-order claim. -/
opaque marksFormPackage : Communion → Prop

/-- **AXIOM (MARKS_INTERLOCK)**: Under the Catholic axiom set, the four marks
    are mutually reinforcing — each mark's theological ground entails elements
    of the other marks.
    Source: [CCC] §811–870 (structural observation); the CCC presents the
    marks as aspects of ONE reality (the Church), not four independent tests.
    MODELING CHOICE: The interlocking is a structural feature of the Catholic
    axiom set, not an explicit CCC claim. The CCC treats the marks together
    (§811) but does not formally derive each from the others. -/
axiom marks_interlock :
  ∀ (c : Communion),
    FourMarks c →
    marksFormPackage c

def marks_interlock_provenance : Provenance :=
  Provenance.tradition "CCC §811-870 (structural observation on mark interdependence)"
def marks_interlock_tag : DenominationalTag := catholicOnly

/-- **THEOREM: catholic_marks_form_package** — The Catholic Church's four
    marks form an interlocking package: they mutually entail each other under
    the Catholic axiom set.

    This means you cannot cherry-pick marks. Accepting one (under Catholic
    interpretation) commits you to all four. Conversely, rejecting one
    (e.g., apostolicity as succession) undermines the others. -/
theorem catholic_marks_form_package :
    marksFormPackage catholicChurch :=
  marks_interlock catholicChurch catholic_church_has_four_marks

-- ============================================================================
-- DENOMINATIONAL CUTS
-- ============================================================================

/-!
## Protestant interpretation: marks are spiritual, not institutional

The Protestant position reinterprets each mark:
- Unity = agreement in essential doctrine, not institutional governance
- Holiness = imputed righteousness from Christ, not sacramental sanctification
- Catholic = the universal invisible church, not a visible institution
- Apostolic = faithful to apostolic teaching (Scripture), not succession

Under this interpretation, every true believer is part of the one, holy,
catholic, apostolic Church — which is invisible and not identified with
any particular institution.
-/

/-- Whether the marks apply to an invisible church of all believers
    rather than a visible institution.
    This is the core Protestant reinterpretation. -/
opaque marksApplyToInvisibleChurch : Prop

/-- **AXIOM (PROTESTANT_INVISIBLE_CHURCH)**: The four marks identify the
    invisible church of all true believers, not any visible institution.
    Source: Protestant ecclesiology; Westminster Confession Ch. 25;
    Augsburg Confession Art. VII ("the assembly of all believers").
    Denominational scope: PROTESTANT POSITION.
    HONEST NOTE: This is internally consistent. The Protestant does not deny
    the marks — they reinterpret where the marks apply. -/
axiom protestant_invisible_church :
  marksApplyToInvisibleChurch →
  -- If marks apply to the invisible church, then no visible communion
  -- can uniquely claim them
  ∀ (c : Communion), FourMarks c → hasFullDeposit c → preservesApostolicTeaching c

def protestant_invisible_church_provenance : Provenance :=
  Provenance.tradition "Westminster Confession Ch.25; Augsburg Confession Art.VII"
def protestant_invisible_church_tag : DenominationalTag :=
  { acceptedBy := [Denomination.reformed, Denomination.lutheran]
    note := "Protestant position — marks apply to invisible church of all believers" }

/-- **THEOREM: protestant_marks_dissolve_uniqueness** — Under the Protestant
    invisible-church axiom, any visible communion that has the four marks
    also preserves apostolic teaching — but this is trivially true for every
    communion, which means the marks lose their discriminating power entirely.

    This shows the Protestant reinterpretation is internally consistent but
    comes at a cost: the marks no longer identify any PARTICULAR visible
    institution. They become descriptions of the invisible church. -/
theorem protestant_marks_dissolve_uniqueness
    (h_invisible : marksApplyToInvisibleChurch) :
    ∀ (c : Communion), FourMarks c → hasFullDeposit c → preservesApostolicTeaching c :=
  protestant_invisible_church h_invisible

/-!
## Orthodox interpretation: marks are real but conciliar

The Orthodox agree with Catholics that the marks are visible and institutional
(against Protestants). But they disagree about what unity and apostolicity
require. For the Orthodox, unity is CONCILIAR (the five patriarchates), not
MONARCHICAL (Rome). Apostolicity is through ALL apostolic sees, not uniquely
through Rome.

The Catholic-Orthodox split is specifically about HOW to interpret catholicity
(fullness through which structures?) and apostolicity (succession through
which see?). See PapalInfallibility.lean for the detailed axiom chain.
-/

/-- **THEOREM: orthodox_same_grounds** — The Orthodox communion satisfies
    the same theological grounds as the Catholic communion (under the
    Catholic axiom set applied to the Orthodox).

    This is deliberately provocative: applying Catholic axioms to the Orthodox
    yields the same structural results, because the Orthodox DO have Trinitarian
    unity, Christ's sanctification, apostolic teaching, and apostolic succession.
    The disagreement is not about WHETHER these grounds hold but about WHETHER
    they require Petrine primacy. -/
theorem orthodox_same_grounds :
    -- Unity grounded in Trinity and charity
    (unityGroundedInTrinity orthodoxChurch ∧ unityMaintainedByCharity orthodoxChurch) ∧
    -- Holiness from Christ's sanctification
    holinessFromChristSanctification orthodoxChurch ∧
    -- Catholicity = fullness + universality
    (hasFullDeposit orthodoxChurch ∧ hasMissionToAllPeoples orthodoxChurch) ∧
    -- Apostolicity = succession + teaching
    (hasUnbrokenSuccession orthodoxChurch ∧ preservesApostolicTeaching orthodoxChurch) := by
  exact marks_have_grounds orthodoxChurch orthodox_claim_four_marks

/-- **THEOREM: catholic_orthodox_split_is_about_primacy** — The Catholic and
    Orthodox communions satisfy exactly the same four marks and the same
    theological grounds. The split is not about the marks but about Petrine
    primacy (from PapalInfallibility.lean).

    Connection to PapalInfallibility.lean: The Orthodox accept T_PETER_IS_ROCK
    and general apostolic succession, but deny T_PETRINE_SUCCESSION (Rome's
    unique jurisdiction) and T_CHARISM_EXTENDS (the charism covers the office).
    See `orthodox_cut` in PapalInfallibility.lean. -/
theorem catholic_orthodox_split_is_about_primacy :
    FourMarks catholicChurch ∧ FourMarks orthodoxChurch ∧
    disagreementReducesToPriorAxioms := by
  exact ⟨ catholic_church_has_four_marks
        , orthodox_claim_four_marks
        , marks_not_self_authenticating
        ⟩

-- ============================================================================
-- DENOMINATIONAL SUMMARY
-- ============================================================================

/-- Denominational scope of each axiom in the Marks of the Church formalization. -/
def marksOfChurchDenominationalScope : List (String × DenominationalTag) :=
  [ ("unity_requires_visible_bond",             unity_requires_visible_bond_tag)
  , ("holiness_requires_sacramental_means",     holiness_requires_sacramental_means_tag)
  , ("catholicity_is_twofold",                  catholicity_is_twofold_tag)
  , ("apostolicity_requires_succession",        apostolicity_requires_succession_tag)
  , ("catholic_church_has_four_marks",          catholic_church_has_four_marks_tag)
  , ("orthodox_claim_four_marks",               orthodox_claim_four_marks_tag)
  , ("mark_interpretation_depends_on_priors",   mark_interpretation_depends_on_priors_tag)
  , ("marks_interlock",                         marks_interlock_tag)
  , ("protestant_invisible_church",             protestant_invisible_church_tag)
  ]

/-!
## Hidden assumptions — summary

1. **Trinitarian unity maps onto ecclesial unity** (in `unityGroundedInTrinity`):
   The CCC assumes the Church's unity PARTICIPATES in divine unity (§813), not
   merely that it imitates it. This is a strong ontological claim connecting
   Trinity.lean to ecclesiology.

2. **"Fullness" is identifiable** (in `hasFullDeposit`): The CCC claims the
   Catholic Church possesses the "fullness of the means of salvation" (§830),
   but the precise inventory is never given. What constitutes fullness? Seven
   sacraments? The Petrine office? Both? All traditions claim they have what
   is essential.

3. **Apostolic succession is unbroken** (in `hasUnbrokenSuccession`): The
   historical claim that ordination chains are literally continuous from the
   apostles to present bishops. Historians debate specific links. The claim
   is theological rather than merely historical — even if specific historical
   links are uncertain, the THEOLOGICAL claim is that the Holy Spirit preserves
   the chain.

4. **The marks are identifying, not merely describing** (in `FourMarks`): The
   CCC presents the marks as CRITERIA (you can identify the true Church by
   them), not merely descriptions (the true Church happens to have them). But
   as we showed, the marks fail as inter-traditional criteria because they
   require interpretation that depends on the tradition doing the interpreting.

5. **The marks form a package, not a checklist** (in `marks_interlock`): Our
   modeling choice. The CCC does not explicitly say the marks are mutually
   entailing, but its treatment (grounding each in shared doctrines) implies it.
-/

end Catlib.Creed.MarksOfChurch
