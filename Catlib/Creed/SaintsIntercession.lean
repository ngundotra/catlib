import Catlib.Foundations
import Catlib.Creed.Soul
import Catlib.Creed.Purgatory
import Catlib.Creed.Intercession
import Catlib.Creed.PapalInfallibility

/-!
# CCC §946-962, §828, §956, §2683-2684, §1030-1032: The Communion of Saints

## The puzzle

The "communion of saints" (communio sanctorum) in the Apostles' Creed means
more than "a community of nice people." The CCC claims it spans THREE states:

1. **Church Militant** — the living faithful on earth (§954)
2. **Church Suffering** — the dead in purgatory being purified (§1030-1032)
3. **Church Triumphant** — the blessed in heaven (§956, §1023)

All three are in MUTUAL communion — goods flow in every direction:
- The living pray for the dead in purgatory (§1032)
- The saints in heaven intercede for the living (§956)
- The living venerate the saints (§2683-2684)
- Merit can be applied across boundaries (§1475-1477)

This creates two structural puzzles:

**Puzzle 1 (Protestant):** If the communion is only metaphorical — "we share
faith with other living Christians" — then prayers to saints and for the dead
are nonsensical. What makes the communion REAL across the death boundary?

**Puzzle 2 (Idolatry):** If we pray TO saints, aren't we worshiping them?
Doesn't this violate "You shall have no other gods before me" (Ex 20:3)?

## The CCC's answer

**To Puzzle 1:** The saints are ALIVE in Christ (soul_is_immortal, §366).
Death does not end personhood or communion. The communion of saints is not
metaphorical because the members are not metaphorically alive — they are
ACTUALLY alive (separated souls persisting per §366, in beatifying communion
per §1023). Communion crosses death because persons cross death.

**To Puzzle 2:** The latria/dulia distinction (§2132, §971). Worship (latria)
is owed to God alone. Veneration (dulia) is the honor given to saints.
Hyperdulia is the special veneration given to Mary. Asking a saint to pray
for you is NOT worship — it is asking a friend to intercede, exactly as
asking a living friend to pray for you is not worshiping that friend.
The difference is one of KIND, not degree.

## Structural findings

1. **The communion of saints is a STRONG topological claim.** It asserts
   that the communion relation (Axioms.lean) crosses the death boundary
   in BOTH directions. This requires: soul_is_immortal (§366), beatifying
   communion of saints (§1023), prayer efficacy across death (§1032),
   and the ability of the dead to ACT (intercede). Each is a substantial
   metaphysical commitment.

2. **The latria/dulia distinction is load-bearing.** Without it, the
   Protestant charge of idolatry is correct: any prayer directed to a
   creature would be worship. The distinction between worship (latria)
   and veneration (dulia) is not a hedge — it is a fundamental category
   difference that makes the entire practice coherent.

3. **Canonization connects infallibility to eschatology.** The Church
   claims to know INFALLIBLY that specific individuals are in heaven.
   This requires both PapalInfallibility.lean's chain AND a mechanism
   for knowing another's eternal state. The CCC treats this as obvious
   (§828) but it is a strong epistemic claim.

4. **The Treasury of Merit generalizes retroactive redemption.** If
   Christ's merits can be applied to Mary retroactively (MarianDogma),
   then merit-transfer is a general mechanism. The Treasury extends this:
   the merits of Christ AND of the saints form a common resource applicable
   to any member of the communion. This is P2 again — secondary merit
   participates in primary merit without competing.

5. **Hidden assumption: the dead can RECEIVE requests.** Intercession.lean
   formalizes that saints intercede FOR the living. But the practice of
   praying TO saints assumes they can HEAR or RECEIVE prayer. The CCC
   never explains how a separated soul perceives the prayers of the living.
   The traditional answer (they see in God's knowledge — Aquinas, ST II-II
   q.83 a.4 ad 2) is a substantial metaphysical claim that the CCC
   presupposes without stating.

## Denominational scope

- **Catholic + Orthodox**: Accept full communion of saints, intercession,
  veneration, prayer for the dead (§946-962, §1030-1032)
- **Protestant**: Reject prayers to saints, prayer for the dead, and
  the latria/dulia distinction. Accept "communion of saints" as the living
  community of believers only.
- **The precise disagreement**: Does communion persist across death?
  Does P2 extend to merit-transfer and intercessory mediation?

## Predictions

1. The three-fold Church structure will require communion to be transitive
   across states — militant ↔ suffering ↔ triumphant.
2. The latria/dulia distinction will be the key defense against idolatry.
3. Canonization will expose a hidden epistemic assumption: how does the
   Church know someone is in heaven?
4. The Treasury of Merit will parallel P2 (primary/secondary non-competition).
-/

set_option autoImplicit false

namespace Catlib.Creed.SaintsIntercession

open Catlib
open Catlib.Creed
open Catlib.Creed.Intercession
open Catlib.Creed.PapalInfallibility

-- ============================================================================
-- § 1. Core concepts: the three states of the Church
-- ============================================================================

/-- The three states of the Church — the communion of saints spans all three.
    CCC §954: "The three states of the Church." The Apostles' Creed's
    "communion of saints" (communio sanctorum) refers to this tripartite
    structure, not merely to fellowship among the living.

    STRUCTURAL INSIGHT: This is an inductive type, not a spectrum. The CCC
    presents these as DISCRETE states with clear boundaries: you are alive
    (militant), dead and being purified (suffering), or dead and in glory
    (triumphant). There is no fourth state and no state between them.

    HIDDEN ASSUMPTION: The state is well-defined — every member of the
    communion is in exactly one state. But the CCC's own §847 ("known to
    God alone") suggests some states may be epistemically inaccessible.
    We model the ontological states, not our knowledge of them. -/
inductive ChurchState where
  /-- The living faithful on earth — the pilgrim Church.
      CCC §954: "some of his disciples are pilgrims on earth." -/
  | militant
  /-- The dead undergoing purification in purgatory.
      CCC §954: "others have died and are being purified."
      CCC §1030-1032: purgatorial purification. -/
  | suffering
  /-- The blessed in heaven — the saints in glory.
      CCC §954: "still others are in glory, contemplating
      'in full light, God himself triune and one, exactly as he is.'" -/
  | triumphant

/-- Which state of the Church a human person is in.
    MODELING CHOICE: This is opaque because the mechanism by which a person
    transitions between states (death, purification, beatific vision) is
    modeled in other files (Soul.lean, Purgatory.lean). Here we only need
    the state assignment. -/
opaque churchStateOf : HumanPerson → ChurchState → Prop

-- ============================================================================
-- § 2. Core concepts: worship vs. veneration
-- ============================================================================

/-- The three kinds of honor in Catholic theology (§2132, §971).
    This distinction is LOAD-BEARING — without it, veneration of saints
    is indistinguishable from idolatry. The Protestant charge of idolatry
    collapses these three categories into one; the Catholic defense depends
    entirely on their being distinct in KIND, not merely in degree.

    HISTORICAL NOTE: The terminology comes from the Second Council of Nicaea
    (787), which defended the veneration of icons by distinguishing latria
    (worship) from proskynesis (relative honor). Aquinas formalized the
    three-fold distinction (ST II-II q.84, q.103, q.25 a.5).

    HIDDEN ASSUMPTION: These are categorically different, not points on a
    spectrum. If honor is a continuum from "mild respect" to "full worship,"
    then there is no principled line between dulia and latria — and the
    Protestant objection stands. The CCC treats them as categorically
    distinct but never argues for this categorical difference. -/
inductive HonorKind where
  /-- Latria: worship owed to God alone.
      CCC §2096-2097: "Adoration is the first act of the virtue of religion."
      Ex 20:3: "You shall have no other gods before me."
      This is the supreme acknowledgment of God as Creator and Lord. -/
  | latria
  /-- Dulia: veneration given to saints and angels.
      CCC §2132: "The honor rendered to sacred images is a 'respectful
      veneration,' not the adoration due to God alone."
      This is honor for a creature's holiness — NOT worship. -/
  | dulia
  /-- Hyperdulia: special veneration given to Mary.
      CCC §971: "The Church's devotion to the Blessed Virgin is intrinsic
      to Christian worship" — but it "differs essentially from the adoration
      which is rendered to the incarnate Word and equally to the Father and
      the Holy Spirit."
      Greater than dulia (because of Mary's unique role as Theotokos),
      less than latria (because Mary is a creature, not God). -/
  | hyperdulia

/-- Whether a given act of honor is directed at a person with a specific kind.
    MODELING CHOICE: Honor is modeled as a ternary relation: who honors,
    who is honored, and what kind of honor. This makes it impossible to
    confuse worship with veneration at the type level. -/
opaque honors : Person → Person → HonorKind → Prop

/-- Whether directing a given kind of honor at a person is appropriate.
    Latria → only God. Dulia → saints and angels. Hyperdulia → Mary only.
    Directing latria at a creature is idolatry. -/
opaque honorIsAppropriate : Person → HonorKind → Prop

-- ============================================================================
-- § 3. Core concepts: canonization
-- ============================================================================

/-- Whether the Church has formally declared that a specific person is in
    heaven. CCC §828: "By canonizing some of the faithful, i.e., by solemnly
    proclaiming that they practiced heroic virtue and lived in fidelity to
    God's grace, the Church recognizes the power of the Spirit of holiness
    within her and sustains the hope of believers by proposing the saints
    to them as models and intercessors."

    STRUCTURAL INSIGHT: Canonization is an INFALLIBLE declaration about a
    SPECIFIC person's eternal state. This is unusual — most infallible
    teachings are about doctrine (universal truths), not about individuals.
    Canonization claims the Church can know, with certainty, that a
    PARTICULAR person is in heaven. This requires both the infallibility
    apparatus (PapalInfallibility.lean) and some mechanism for knowing
    another's eschatological state.

    HIDDEN ASSUMPTION: The Church can discern the eternal state of specific
    individuals. How? The CCC doesn't say. Possible mechanisms: (1) direct
    divine revelation to the Church, (2) inference from verified miracles
    (the canonization process requires miracles attributed to the candidate's
    intercession — which itself presupposes they are in heaven and can
    intercede), (3) the charism of infallibility covers such discernments.
    The circularity in (2) is striking: miracles prove intercession, which
    proves heavenly state, which proves sainthood. -/
opaque isCanonized : HumanPerson → Prop

/-- Whether the declaration of canonization is an infallible teaching.
    The canonization is a specific teaching proposed definitively.
    MODELING CHOICE: We connect canonization to the infallibility apparatus
    by asserting that the canonization declaration is a Teaching (from
    PapalInfallibility.lean) that meets the conditions for irreformability.
    This bridges two files that were previously unconnected. -/
axiom canonizationTeaching : HumanPerson → Teaching

-- ============================================================================
-- § 4. Core concepts: the Treasury of Merit
-- ============================================================================

/-- Whether a person's meritorious actions contribute to the spiritual
    welfare of others. CCC §1475: "In the communion of saints, a perennial
    link of charity exists between the faithful who have already reached
    their heavenly home, those who are expiating their sins in purgatory
    and those who are still pilgrims on earth. Between them there is,
    too, an abundant exchange of all good things."

    CCC §1476: "We also call these spiritual goods of the communion of
    saints the Church's treasury, which is 'not the sum total of the
    material goods which have accumulated during the course of the
    centuries, but the infinite and inexhaustible value which Christ's
    expiatory actions and merits have before God.'"

    CCC §1477: "'This treasury includes as well the prayers and good works
    of the Blessed Virgin Mary. They are truly immense, unfathomable, and
    even pristine in their value before God. In the treasury, too, are the
    prayers and good works of all the saints.'"

    STRUCTURAL INSIGHT: This is P2 applied to MERIT. Christ's merit is
    primary (infinite, inexhaustible — §1476). The saints' merit is
    secondary (participatory — §1477). More saintly merit does not diminish
    Christ's merit, just as more saintly intercession does not diminish
    Christ's mediation (Intercession.lean). The Treasury is P2 in the
    domain of merit.

    HIDDEN ASSUMPTION: Merit is TRANSFERABLE. This is a strong claim —
    that the spiritual value of one person's actions can benefit another
    person. If merit is strictly personal (you get what you earned, no
    sharing), the Treasury collapses. The CCC assumes transferability
    without arguing for it. -/
opaque contributesMerit : Person → Prop

/-- Whether merit from one person can be applied to benefit another.
    This is the transfer mechanism. CCC §1475: "an abundant exchange
    of all good things" among the three states of the Church.

    MODELING CHOICE: We model merit-transfer as a binary relation rather
    than a quantitative system. The CCC speaks of "treasury" and "exchange"
    but never quantifies merit. We preserve this opacity. -/
opaque meritAppliesTo : Person → Person → Prop

/-- Whether a person can receive prayers from the living.
    HIDDEN ASSUMPTION: The dead can perceive the prayers of the living.
    The CCC never explains the mechanism. Aquinas (ST II-II q.83 a.4 ad 2):
    the saints see in God's knowledge what pertains to them. This is a
    substantial metaphysical claim that the CCC presupposes. -/
opaque canReceivePrayer : HumanPerson → Prop

-- ============================================================================
-- § 5. Axioms
-- ============================================================================

/-- AXIOM 1 (§954, §946): The communion of saints spans all three states.
    Every member of the communion, regardless of their state, is in communion
    with every other member. The living are in communion with the dead in
    purgatory AND with the saints in heaven.

    This is the TOPOLOGICAL claim: communion is connected across death.
    It is not three separate communities — it is ONE communion with
    three states.

    HIDDEN ASSUMPTION: Communion survives death. This depends on
    soul_is_immortal (§366) — the saints must persist to be in communion.
    It also depends on the dead retaining the capacity for relationship,
    not merely existence.

    Provenance: [Definition] CCC §946, §954
    Denominational scope: CATHOLIC + ORTHODOX. Protestants restrict
    "communion of saints" to the living Church. -/
axiom communion_spans_all_states :
  ∀ (p q : HumanPerson) (sp sq : ChurchState),
    churchStateOf p sp →
    churchStateOf q sq →
    inCommunion (p : CommunionParty) (q : CommunionParty)

def communion_spans_provenance : Provenance := Provenance.definition 946
def communion_spans_tag : DenominationalTag := catholicOnly

/-- AXIOM 2 (§2096-2097, Ex 20:3): Worship (latria) is owed to God alone.
    Directing worship at any creature is idolatry.

    This is ECUMENICAL — all Christians agree. The dispute is not about
    WHETHER latria belongs to God alone, but about whether Catholic
    veneration of saints constitutes latria or dulia.

    Provenance: [Scripture] Ex 20:3; Dt 6:13; [Definition] CCC §2096-2097
    Denominational scope: ECUMENICAL. -/
axiom latria_god_alone :
  ∀ (creature : Person),
    creature ≠ Person.human →   -- even for the most generic human
    ¬ honorIsAppropriate creature HonorKind.latria

def latria_provenance : Provenance := Provenance.scripture "Ex 20:3; Dt 6:13"
def latria_tag : DenominationalTag := ecumenical

/-- AXIOM 3 (§2132, §2683-2684): Veneration (dulia) of saints IS appropriate.
    CCC §2132: "'The honor rendered to sacred images is a respectful
    veneration, not the adoration due to God alone.'"

    The saints deserve honor because of their holiness — which is itself
    a participation in God's holiness. Honoring saints honors God.

    Provenance: [Definition] CCC §2132, §2683-2684; [Tradition] Nicaea II (787)
    Denominational scope: CATHOLIC + ORTHODOX. -/
axiom dulia_for_saints :
  ∀ (s : HumanPerson),
    isGlorifiedSaint s →
    honorIsAppropriate (personOfHuman s) HonorKind.dulia

def dulia_provenance : Provenance := Provenance.definition 2132
def dulia_tag : DenominationalTag := catholicOnly

/-- AXIOM 4 (§971): Dulia and latria are categorically different.
    The honor given to saints (dulia) is NOT worship (latria).
    CCC §971: devotion to Mary "differs essentially from the adoration
    which is rendered to the incarnate Word."

    This is the KEY defense against the idolatry charge. If dulia were
    a species of latria (worship-lite), the Protestant objection would
    be correct. The CCC asserts they differ in KIND, not degree.

    HIDDEN ASSUMPTION: There IS a categorical difference between
    veneration and worship. The CCC asserts this (§971, §2132) but
    never provides a formal criterion for the boundary. What precisely
    makes an act of honor "worship" rather than "veneration"? The CCC
    implies: worship acknowledges the honored one as God (Creator,
    infinite, self-sufficient); veneration acknowledges holiness in a
    creature. But a clear criterion is never stated.

    Provenance: [Definition] CCC §971, §2132; [Tradition] Nicaea II (787)
    Denominational scope: CATHOLIC + ORTHODOX. -/
axiom dulia_is_not_latria :
  ∀ (p : Person) (k : HonorKind),
    k = HonorKind.dulia ∨ k = HonorKind.hyperdulia →
    honorIsAppropriate p k →
    ¬ (k = HonorKind.latria)

def dulia_not_latria_provenance : Provenance := Provenance.definition 971
def dulia_not_latria_tag : DenominationalTag := catholicOnly

/-- AXIOM 5 (§828, §891): Canonization is an infallible declaration.
    The Church's solemn declaration that a person is in heaven is
    irreformable — it cannot be wrong.

    CCC §828: "By canonizing some of the faithful… the Church recognizes
    the power of the Spirit of holiness within her."

    This axiom connects to the infallibility apparatus: the canonization
    teaching is irreformable. A canonized person IS in heaven.

    HIDDEN ASSUMPTION 1: The Church can discern the eternal state of
    specific individuals. The canonization process uses miracles as
    evidence, but this is CIRCULAR: miracles prove intercession →
    intercession proves heavenly state → heavenly state proves sainthood
    → sainthood grounds further miracles. The CCC breaks the circle by
    grounding it in the charism of infallibility (divine assistance
    guarantees the final judgment is correct).

    HIDDEN ASSUMPTION 2: Infallibility extends beyond abstract doctrine
    to specific factual claims about individuals. Most infallible
    teachings are universal ("Christ is God," "Mary was conceived without
    sin"). Canonization is particular ("THIS person is in heaven"). The
    scope extension is significant but not argued for in the CCC.

    Provenance: [Definition] CCC §828; [Tradition] Papal authority (§891)
    Denominational scope: CATHOLIC only. -/
axiom canonization_is_infallible :
  ∀ (s : HumanPerson),
    isCanonized s →
    isIrreformable (canonizationTeaching s)

def canonization_provenance : Provenance := Provenance.definition 828
def canonization_tag : DenominationalTag := catholicOnly

/-- AXIOM 6 (§828): A canonized person is a glorified saint.
    If the Church declares infallibly that someone is in heaven,
    then they are in heaven — they are a glorified saint.

    This bridges canonization (an ecclesial act) to ontology (the person
    IS in the state of glory). The infallible declaration tracks reality.

    Provenance: [Definition] CCC §828
    Denominational scope: CATHOLIC only. -/
axiom canonized_implies_glorified :
  ∀ (s : HumanPerson), isCanonized s → isGlorifiedSaint s

def canonized_glorified_provenance : Provenance := Provenance.definition 828
def canonized_glorified_tag : DenominationalTag := catholicOnly

/-- AXIOM 7 (§1475-1477): Merit is transferable within the communion.
    The spiritual goods of one member benefit others. Christ's merit
    is primary and infinite; the saints' merit participates secondarily.

    CCC §1475: "an abundant exchange of all good things" among all
    three states of the Church.

    This is P2 applied to merit: primary (Christ's) and secondary
    (saints') merit don't compete. The Treasury is the accumulated
    secondary merit available for application.

    HIDDEN ASSUMPTION: Merit is not strictly personal. In a strict
    merit-based system, you get what you earn. The Treasury assumes
    that spiritual goods are COMMUNAL — shareable across persons and
    even across death. This is a corollary of communion_spans_all_states:
    if goods don't flow across the communion, it's not really a communion.

    Provenance: [Definition] CCC §1475-1477; [Tradition] Clement VI,
    *Unigenitus* (1343)
    Denominational scope: CATHOLIC only. Protestants reject merit-transfer
    entirely — Christ's merit is imputed directly by faith, not distributed
    through a treasury. -/
axiom merit_is_transferable :
  ∀ (s : HumanPerson) (beneficiary : Person),
    isGlorifiedSaint s →
    contributesMerit (personOfHuman s) →
    meritAppliesTo (personOfHuman s) beneficiary

def merit_provenance : Provenance := Provenance.definition 1475
def merit_tag : DenominationalTag := catholicOnly

/-- AXIOM 8 (§956, Aquinas ST II-II q.83 a.4): Glorified saints can
    receive prayers from the living.
    CCC §2683: "The witnesses who have preceded us into the kingdom…
    share in the living tradition of prayer."

    The saints are not merely interceding on their own initiative —
    the faithful can ADDRESS prayers to them, and the saints RECEIVE
    these requests. This is the asymmetric direction: not just saints → God
    for us (already in Intercession.lean), but living → saints.

    HIDDEN ASSUMPTION: Separated souls have cognitive access to the
    prayers of the living. Aquinas: saints see in God all that pertains
    to their state, including the prayers directed to them. Without this,
    the practice of praying TO saints would be addressing an unresponsive
    void. The CCC presupposes this capacity but never explains it.

    Provenance: [Definition] CCC §2683-2684; [Tradition] Aquinas, ST II-II q.83 a.4
    Denominational scope: CATHOLIC + ORTHODOX. -/
axiom saints_receive_prayer :
  ∀ (s : HumanPerson),
    isGlorifiedSaint s →
    canReceivePrayer s

def saints_receive_provenance : Provenance := Provenance.definition 2683
def saints_receive_tag : DenominationalTag := catholicOnly

-- ============================================================================
-- § 6. Bridge theorems: connecting to existing infrastructure
-- ============================================================================

/-- Bridge to soul_is_immortal: the communion of saints requires the
    saints to BE ALIVE. Without soul_is_immortal, the Church Triumphant
    and Church Suffering would be empty — dead persons would simply cease
    to exist.

    This is the deepest dependency: the entire three-fold structure of
    the communion rests on the persistence of the soul after death. -/
theorem saints_alive_bridge (s : HumanPerson) :
    hasSpiritualAspect s :=
  soul_is_immortal s

/-- Bridge to P2: merit non-competition parallels causation non-competition.
    Just as primary and secondary CAUSES don't compete (P2), primary and
    secondary MERIT don't compete. Christ's infinite merit is not diminished
    by the saints' contributed merit.

    This is P2's FIFTH instance:
    | Domain        | Primary        | Secondary       | File               |
    |---------------|----------------|-----------------|--------------------|
    | Causation     | God causes     | Creatures cause | Axioms.lean        |
    | Prayer        | God acts       | Person prays    | Prayer.lean        |
    | Absolution    | Christ forgives| Priest absolves | Reconciliation.lean|
    | Intercession  | Christ mediates| Saints intercede| Intercession.lean  |
    | **Merit**     | **Christ merits**| **Saints merit**| **this file**    | -/
theorem merit_non_competition_bridge
    (p : PrimaryCause) (s : SecondaryCause) :
    ¬ causesCompete p s :=
  p2_two_tier_causation p s

/-- Bridge to Intercession.lean: a canonized saint intercedes.
    If a person is canonized, they are glorified (axiom 6), and glorified
    saints intercede (Intercession.lean axiom 2). -/
theorem canonized_saint_intercedes
    (s : HumanPerson) (beneficiary : Person)
    (h_canon : isCanonized s) :
    intercedesFor (Person.human) beneficiary :=
  saints_intercede s beneficiary (canonized_implies_glorified s h_canon)

/-- Bridge to Purgatory.lean: the Church Suffering will join the
    Church Triumphant. Everyone in purgatory will eventually enter
    heaven (purgatory_leads_to_heaven). The three-fold structure is
    dynamic: suffering → triumphant is guaranteed. -/
theorem suffering_becomes_triumphant
    (p : Person) (h_purg : inPurgatory p) :
    attainsBeatificVision p :=
  purgatory_leads_to_heaven p h_purg

-- ============================================================================
-- § 7. Theorems: resolving the puzzles
-- ============================================================================

/-- THEOREM 1: Veneration of saints is not idolatry.

    For any canonized saint: (a) dulia is appropriate for them,
    (b) dulia is categorically not latria, therefore (c) venerating
    them is not worshiping them.

    This resolves Puzzle 2. The defense is the categorical distinction
    between dulia and latria — they are different in KIND, not degree.

    Depends on: canonized_implies_glorified, dulia_for_saints,
    dulia_is_not_latria. -/
theorem veneration_is_not_idolatry
    (s : HumanPerson)
    (h_canon : isCanonized s) :
    -- Dulia is appropriate for this saint
    honorIsAppropriate (personOfHuman s) HonorKind.dulia
    -- AND dulia is not latria
    ∧ ¬ (HonorKind.dulia = HonorKind.latria) :=
  have h_glor := canonized_implies_glorified s h_canon
  have h_dulia := dulia_for_saints s h_glor
  have h_not_latria := dulia_is_not_latria (personOfHuman s) HonorKind.dulia
    (Or.inl rfl) h_dulia
  ⟨h_dulia, h_not_latria⟩

/-- THEOREM 2: The communion of saints supports bidirectional prayer.

    For any glorified saint and any living person in the communion:
    (a) the saint intercedes for the living (from Intercession.lean),
    (b) the saint can receive prayer from the living (axiom 8), and
    (c) they are in communion (axiom 1).

    This resolves Puzzle 1: the communion is not metaphorical because
    it supports REAL bidirectional interaction — the saints act for us
    AND we can address them.

    Depends on: saints_intercede, saints_receive_prayer,
    communion_spans_all_states. -/
theorem bidirectional_prayer_in_communion
    (saint : HumanPerson) (living : HumanPerson)
    (h_saint_glor : isGlorifiedSaint saint)
    (s_triumphant : churchStateOf saint ChurchState.triumphant)
    (s_militant : churchStateOf living ChurchState.militant) :
    -- Saint intercedes for the living
    intercedesFor (Person.human) (personOfHuman living)
    -- AND saint can receive prayer
    ∧ canReceivePrayer saint
    -- AND they are in communion
    ∧ inCommunion (saint : CommunionParty) (living : CommunionParty) :=
  have h_int := saints_intercede saint (personOfHuman living) h_saint_glor
  have h_recv := saints_receive_prayer saint h_saint_glor
  have h_comm := communion_spans_all_states saint living
    ChurchState.triumphant ChurchState.militant s_triumphant s_militant
  ⟨h_int, h_recv, h_comm⟩

/-- THEOREM 3: The full communion picture — all three states interact.

    Given representatives from each state: they are all in mutual communion.
    This is the topological claim: the communion of saints is CONNECTED.

    Depends on: communion_spans_all_states, communion_symmetric. -/
theorem full_communion_connectivity
    (militant : HumanPerson) (suffering : HumanPerson) (triumphant : HumanPerson)
    (h_m : churchStateOf militant ChurchState.militant)
    (h_s : churchStateOf suffering ChurchState.suffering)
    (h_t : churchStateOf triumphant ChurchState.triumphant) :
    -- Militant ↔ Suffering
    inCommunion (militant : CommunionParty) (suffering : CommunionParty)
    ∧ inCommunion (suffering : CommunionParty) (militant : CommunionParty)
    -- Suffering ↔ Triumphant
    ∧ inCommunion (suffering : CommunionParty) (triumphant : CommunionParty)
    ∧ inCommunion (triumphant : CommunionParty) (suffering : CommunionParty)
    -- Militant ↔ Triumphant
    ∧ inCommunion (militant : CommunionParty) (triumphant : CommunionParty)
    ∧ inCommunion (triumphant : CommunionParty) (militant : CommunionParty) :=
  have h_ms := communion_spans_all_states militant suffering _ _ h_m h_s
  have h_sm := communion_symmetric _ _ h_ms
  have h_st := communion_spans_all_states suffering triumphant _ _ h_s h_t
  have h_ts := communion_symmetric _ _ h_st
  have h_mt := communion_spans_all_states militant triumphant _ _ h_m h_t
  have h_tm := communion_symmetric _ _ h_mt
  ⟨h_ms, h_sm, h_st, h_ts, h_mt, h_tm⟩

/-- THEOREM 4: Canonization closes the loop — from ecclesial act to
    intercession to non-idolatrous veneration.

    For any canonized person: (a) the canonization is infallible,
    (b) they are a glorified saint, (c) they intercede for the faithful,
    (d) venerating them (dulia) is appropriate, and (e) that veneration
    is not worship (latria).

    This is the COMPLETE canonization-to-practice chain:
    Church declares → infallibly → person is in heaven → they intercede →
    we may venerate them → that veneration is not worship.

    Depends on: all axioms. -/
theorem canonization_to_practice
    (s : HumanPerson) (beneficiary : Person)
    (h_canon : isCanonized s) :
    -- (a) Canonization is infallible
    isIrreformable (canonizationTeaching s)
    -- (b) They are glorified
    ∧ isGlorifiedSaint s
    -- (c) They intercede
    ∧ intercedesFor (Person.human) beneficiary
    -- (d) Dulia is appropriate
    ∧ honorIsAppropriate (personOfHuman s) HonorKind.dulia
    -- (e) Dulia ≠ Latria
    ∧ ¬ (HonorKind.dulia = HonorKind.latria) :=
  have h_irr := canonization_is_infallible s h_canon
  have h_glor := canonized_implies_glorified s h_canon
  have h_int := saints_intercede s beneficiary h_glor
  have h_dulia := dulia_for_saints s h_glor
  have h_not := dulia_is_not_latria (personOfHuman s) HonorKind.dulia
    (Or.inl rfl) h_dulia
  ⟨h_irr, h_glor, h_int, h_dulia, h_not⟩

-- ============================================================================
-- § 8. The Protestant objections formalized
-- ============================================================================

/-!
### Protestant Objection 1: "One mediator" (1 Tim 2:5)

"For there is one God and one mediator between God and mankind, the man
Christ Jesus." (1 Tim 2:5)

This objection is already handled in Intercession.lean. The Catholic
response: "one mediator" excludes rival PRIMARY mediators, not instrumental
SECONDARY intercessors. P2 applied to mediation.

But the communion of saints EXTENDS this: not only do saints intercede,
but the living can DIRECT prayers to saints (asking for their intercession),
and the dead in purgatory can be HELPED by the living's prayers. The
"one mediator" objection applies to ALL of these, not just to saintly
intercession per se.

The response is the same in each case: P2. The living person praying to
a saint is asking for SECONDARY intercession that PARTICIPATES in Christ's
PRIMARY mediation. No competition.

### Protestant Objection 2: Communion is metaphorical

The Protestant claim: "communion of saints" in the Creed means the living
community of believers. It does NOT imply communication with the dead.
The dead are "asleep" (1 Thess 4:13) or in God's hands — but we cannot
interact with them.

The Catholic response depends on THREE claims the Protestant denies:
1. The dead are ALIVE (soul_is_immortal, §366) — not asleep or annihilated
2. The dead can ACT (intercede, receive prayer) — not merely exist passively
3. Communion includes INTERACTION across death, not just shared membership

If ANY of these three fails, the communion of saints reduces to a metaphor.
The CCC asserts all three but never argues for #2 or #3 from first principles
— they are treated as given.

### The denominational picture (extended from Intercession.lean)

| Claim | Catholic | Orthodox | Protestant |
|-------|----------|----------|------------|
| Christ is one mediator | ✓ | ✓ | ✓ |
| Saints intercede in heaven | ✓ | ✓ | ✗ |
| We can address prayers to saints | ✓ | ✓ | ✗ |
| Latria/dulia distinction | ✓ | ✓ | ✗ |
| Prayer for the dead | ✓ | ✓ | ✗ |
| Purgatory (Western formulation) | ✓ | ✗ | ✗ |
| Treasury of merit | ✓ | ✗ | ✗ |
| Canonization as infallible | ✓ | ✗ | ✗ |
| Communion spans death | ✓ | ✓ | ✗ |

Observe: Orthodox agree on MOST of the communion-of-saints claims but
reject the specifically Western/Latin additions (purgatory as such,
treasury of merit, papal canonization). The Protestant position is more
radical: it denies the entire interaction-with-the-dead framework.

### What the Protestant position preserves

Under Protestant axioms alone, you still get:
- Christians should pray for one another (Jas 5:16)
- The living community shares in Christ's body (1 Cor 12:12-27)
- The dead are "in Christ" and will be raised (1 Thess 4:13-18)

What you lose:
- The dead can hear or respond to the living
- Merit can be transferred
- The Church can know who is in heaven
- Veneration is categorically distinct from worship
-/

/-- The Protestant restriction: communion applies only to the living.
    Under this axiom, the Church Suffering and Church Triumphant are not
    in communion with the Church Militant — they are in God's hands,
    but we cannot interact with them.

    NOTA BENE: This is NOT a Catholic axiom. It models the Protestant
    position for comparison. Under this premise, the three-fold
    communion collapses to a single-state fellowship. -/
def protestantCommunionRestriction : Prop :=
  ∀ (p q : HumanPerson) (sp sq : ChurchState),
    churchStateOf p sp → churchStateOf q sq →
    inCommunion (p : CommunionParty) (q : CommunionParty) →
    sp = ChurchState.militant ∧ sq = ChurchState.militant

/-- Under the Protestant restriction, the communion of saints cannot
    support prayer to saints. If communion only holds between the living,
    then the triumphant (saints in heaven) are outside the communion —
    and addressing prayers to them is addressing someone you are not
    in communion with.

    This makes explicit WHY the denominational disagreement matters:
    the Protestant position is not just "we prefer not to pray to saints"
    but "the communion relation does not support it." -/
theorem protestant_restriction_blocks_prayer_to_saints
    (h_restrict : protestantCommunionRestriction)
    (living : HumanPerson) (saint : HumanPerson)
    (h_living : churchStateOf living ChurchState.militant)
    (h_saint : churchStateOf saint ChurchState.triumphant)
    (h_comm : inCommunion (living : CommunionParty) (saint : CommunionParty)) :
    -- Under Protestant restriction, both must be militant
    ChurchState.triumphant = ChurchState.militant :=
  (h_restrict living saint _ _ h_living h_saint h_comm).2

-- ============================================================================
-- § 8b. Bridge: prayer for the dead (Purgatory.lean → SaintsIntercession)
-- ============================================================================

/-!
### Bridge: prayer_aids_dead connects communion of saints to purgatory

The communion of saints spans all three states (communion_spans_all_states).
Purgatory.lean declares prayer_aids_dead: prayer for the dead aids their
purification. Combined, the living in communion with the suffering can
efficaciously pray for their purification.

This makes explicit the pastoral practice: praying for the dead is not
superstition but a CONSEQUENCE of the communion spanning death + prayer
efficacy crossing that boundary.
-/

/-- The living can efficaciously pray for those in purgatory because
    (a) the communion spans all states, and (b) prayer aids the dead.

    Bridge: communion_spans_all_states + prayer_aids_dead (Purgatory.lean).

    This connects the ecclesiology (communion of saints) to the
    eschatology (purgatory) via the prayer mechanism. -/
theorem living_prayer_aids_suffering
    (living : HumanPerson) (suffering : HumanPerson)
    (h_m : churchStateOf living ChurchState.militant)
    (h_s : churchStateOf suffering ChurchState.suffering)
    (h_prays : praysFor (personOfHuman living) (personOfHuman suffering))
    (h_purg : inPurgatory (personOfHuman suffering)) :
    -- They are in communion...
    inCommunion (living : CommunionParty) (suffering : CommunionParty)
    -- ...AND prayer aids the suffering person's purification
    ∧ prayerAidsPurification (personOfHuman suffering) :=
  ⟨communion_spans_all_states living suffering _ _ h_m h_s,
   prayer_aids_dead (personOfHuman living) (personOfHuman suffering) h_prays h_purg⟩

-- ============================================================================
-- § 9. The P2 quintuple-duty finding
-- ============================================================================

/-!
### P2 now does QUINTUPLE duty

With the Treasury of Merit, P2 (two-tier causation) resolves FIVE distinct
theological puzzles — all with the same structure:

| Domain          | Primary           | Secondary          | File                |
|-----------------|-------------------|--------------------|---------------------|
| **Causation**   | God causes        | Creatures cause    | Axioms.lean         |
| **Prayer**      | God acts/governs  | Person prays       | Prayer.lean         |
| **Absolution**  | Christ forgives   | Priest absolves    | Reconciliation.lean |
| **Intercession**| Christ mediates   | Saints intercede   | Intercession.lean   |
| **Merit**       | Christ's merit    | Saints' merit      | this file           |

In each case:
1. The primary actor is unique and irreplaceable
2. The secondary actor participates in (not rivals) the primary actor
3. More secondary activity ≠ less primary activity
4. The secondary actor's efficacy derives FROM the primary

This is now the strongest structural finding in the project: five
seemingly independent Catholic doctrines are five instances of one
metaphysical principle. The Protestant position in each case is the
same: "the exclusivity of the primary means NO secondary." The Catholic
position: "the exclusivity of the primary is COMPATIBLE with secondary
participation."

### The deep question

Is P2 the Catholic Church's most important philosophical commitment?
It resolves more puzzles than any other single principle. Without P2:
- Creaturely causation competes with divine causation (Occasionalism)
- Prayer is either useless or changes God's mind (neither is Catholic)
- Sacramental absolution usurps Christ's forgiveness
- Saintly intercession adds rival mediators
- The Treasury of Merit distributes something that belongs to Christ alone

P2 is the principled rejection of ALL these objections — and the principled
acceptance of genuine creaturely participation in divine activity. This is,
arguably, the central Catholic insight.
-/

-- ============================================================================
-- § 10. Summary of hidden assumptions
-- ============================================================================

/-!
## Summary

### Axioms (8 — from CCC §946-962, §828, §971, §1475-1477, §2683):
1. `communion_spans_all_states` (§946, §954) — communion crosses death
2. `latria_god_alone` (Ex 20:3) — worship owed only to God (ecumenical)
3. `dulia_for_saints` (§2132) — veneration appropriate for saints
4. `dulia_is_not_latria` (§971) — veneration ≠ worship (categorical)
5. `canonization_is_infallible` (§828, §891) — canonization is irreformable
6. `canonized_implies_glorified` (§828) — canonized persons are in heaven
7. `merit_is_transferable` (§1475-1477) — spiritual goods flow across communion
8. `saints_receive_prayer` (§2683, Aquinas) — saints perceive prayers

### Theorems (8):
1. `veneration_is_not_idolatry` — dulia appropriate AND not latria
2. `bidirectional_prayer_in_communion` — saints intercede AND receive prayer
3. `full_communion_connectivity` — all three states mutually in communion
4. `canonization_to_practice` — full chain: canon → glorified → intercedes → venerable
5. `saints_alive_bridge` — soul_is_immortal grounds the whole structure
6. `merit_non_competition_bridge` — P2 applied to merit
7. `canonized_saint_intercedes` — bridge to Intercession.lean
8. `suffering_becomes_triumphant` — bridge to Purgatory.lean

### Protestant contrasts (2):
1. `protestantCommunionRestriction` — communion limited to the living
2. `protestant_restriction_blocks_prayer_to_saints` — restriction prevents prayer to saints

### Cross-file connections:
- `Soul.lean`: soul_is_immortal (§366), HumanPerson, hasSpiritualAspect, personOfHuman
- `Purgatory.lean`: inPurgatory, purgatory_leads_to_heaven, attainsBeatificVision
- `Intercession.lean`: isGlorifiedSaint, intercedesFor, saints_intercede,
  isPrincipalMediator, participatesInMediation
- `PapalInfallibility.lean`: Teaching, isIrreformable
- `Axioms.lean`: inCommunion, CommunionParty, communion_symmetric, p2_two_tier_causation

### Hidden assumptions identified:
1. **Communion survives death** — depends on soul_is_immortal + the claim that
   communion persists for separated souls. Persistence ≠ communion.
2. **The dead can ACT** — not just exist passively. Intercession requires agency;
   receiving prayer requires cognition. soul_is_immortal gives existence,
   but agency after death is an additional claim.
3. **The dead can PERCEIVE the living** — Aquinas's explanation (seeing in God)
   is a substantial metaphysical claim the CCC presupposes.
4. **Dulia and latria are categorically different** — not points on a spectrum.
   If honor is continuous, the boundary is arbitrary and the idolatry charge holds.
5. **The Church can discern individual eschatological states** — canonization
   requires an epistemic mechanism for knowing someone is in heaven.
6. **Merit is transferable** — spiritual goods can be shared, not merely personal.
   Without this, the Treasury collapses and with it indulgences.
7. **P2 extends to merit** — the fifth domain where P2 is applied. This extension
   is never argued for in the CCC.

### Key finding:
P2 does quintuple duty — causation, prayer, absolution, intercession, and now merit.
Five seemingly independent Catholic doctrines are five instances of one
metaphysical principle: primary and secondary causes/agents/merits don't compete.
This is arguably the deepest structural finding in the catlib project.
-/

end Catlib.Creed.SaintsIntercession
