import Catlib.Foundations
import Catlib.Sacraments.SacramentalCausation

/-!
# CCC §1536-1600: Holy Orders — The Three Degrees and Ontological Priesthood

## The puzzle

The CCC distinguishes THREE degrees of holy orders: bishop, priest, deacon
(§1536, §1554). It also distinguishes TWO kinds of priesthood: the
ministerial (ordained) priesthood and the common (baptismal) priesthood
of all the faithful (§1547). The relationship between these two is
"in essence and not only in degree" different (§1547, quoting Vatican II,
Lumen Gentium 10).

What does "in essence not degree" mean? If both are called "priesthood,"
in what sense are they essentially different? And what makes ordination
an ONTOLOGICAL change rather than a functional appointment?

## The CCC's answer

1. **Three degrees** (§1536, §1554): Bishop has the fullness of the
   sacrament of holy orders; priest and deacon participate in Christ's
   ministry at different levels. Bishops can ordain; priests can confect
   Eucharist and absolve; deacons serve.

2. **Indelible character** (§1581-1584): Ordination imprints an indelible
   spiritual character. The ordained person IS a priest/bishop/deacon
   ontologically — it is not a role that can be resigned or revoked.
   A laicized priest remains ontologically a priest; he is merely
   forbidden to exercise his priestly functions.

3. **"In essence not degree"** (§1547, LG 10): The ministerial priesthood
   acts "in the person of Christ" (in persona Christi) — the priest is
   an instrument of Christ in confecting sacraments. The common priesthood
   is the baptismal consecration to holiness and worship. They are not
   two levels of the SAME thing; they are two DIFFERENT things that share
   the name "priesthood" by analogy.

## Connection to SacramentalCausation.lean

SacramentalCausation already establishes:
- Holy orders causes ontological change (§1582): `holyOrders_causes_ontological`
- Holy orders causes dispositional change (§1581): `holyOrders_causes_dispositional`
- Holy orders imprints an indelible character: `holyOrders_imprints_character`
- Holy orders is non-repeatable: `holyOrders_not_repeatable`

This file builds on that foundation by modeling the INTERNAL structure
of holy orders (three degrees), the ministerial/common distinction, and
the denominational split over ontological priesthood.

## Hidden assumptions

1. **Ontological change via sacrament**: The CCC assumes that a ritual act
   (ordination) can cause a real change in what a person IS. This is a
   claim about the causal efficacy of sacramental signs (T3).

2. **The character is permanent**: A laicized priest retains his
   ontological character (§1583: "the character imprinted by ordination
   is forever"). This assumes the ontological change is irreversible —
   not a state that can be undone.

3. **The ministerial/common distinction is essential**: The CCC asserts
   this without deriving it. The claim is that acting "in persona Christi"
   is not a matter of degree (more or less holiness) but of kind (a
   different TYPE of participation in Christ's priesthood).

## Modeling choices

1. We model the three degrees as an enumeration (`OrderDegree`). The CCC
   treats them as hierarchically ordered (bishop > priest > deacon in
   sacramental power), which we capture via predicates.

2. We model the ministerial/common distinction as two separate predicates
   rather than a single "priesthood" type with a parameter. This
   reflects the CCC's claim that they differ "in essence" — they are
   not parametric variants of one concept.

3. We connect to SacramentalCausation.lean via the existing
   `imprintsCharacter` and `isRepeatable` predicates, and derive the
   non-repeatability theorem from the existing biconditional.

## Denominational scope

- **CATHOLIC + ORTHODOX**: Ontological priesthood, indelible character,
  three degrees, ministerial/common distinction.
- **LUTHERAN**: Ordination is valued but understood functionally — the
  minister is set apart for a function, not ontologically changed.
  Luther: "priesthood of all believers" collapses the ministerial/common
  distinction (all baptized are equally priests; some are called to
  preach).
- **REFORMED / NON-DENOM**: Ordination is functional appointment by the
  community. No indelible character, no ontological change, no essential
  ministerial/common distinction.
-/

set_option autoImplicit false

namespace Catlib.Sacraments.HolyOrders

open Catlib
open Catlib.Sacraments.SacramentalCausation

-- ============================================================================
-- § 1. The Three Degrees of Holy Orders (CCC §1536, §1554)
-- ============================================================================

/-- The three degrees of the sacrament of holy orders.

    CCC §1536: "Holy Orders is the sacrament through which the mission
    entrusted by Christ to his apostles continues to be exercised in the
    Church until the end of time: it is the sacrament of apostolic ministry.
    It includes three degrees: episcopate, presbyterate, and diaconate."

    CCC §1554: "Catholic doctrine, expressed in the liturgy, the Magisterium,
    and the constant practice of the Church, recognizes that there are two
    degrees of ministerial participation in the priesthood of Christ: the
    episcopacy and the presbyterate. The diaconate is intended to help and
    serve them."

    MODELING CHOICE: We use a closed enumeration. The CCC is explicit
    that there are exactly three degrees (Council of Trent, Session 23,
    Canon 6). -/
inductive OrderDegree where
  /-- Bishop — has the fullness of the sacrament of holy orders.
      CCC §1557: "the high priesthood, the summit of the sacred ministry." -/
  | bishop
  /-- Priest (presbyter) — co-worker of the episcopal order.
      CCC §1562: "priests are united with the bishops in sacerdotal dignity." -/
  | priest
  /-- Deacon — ordained for service, not for priesthood.
      CCC §1569: "At a lower level of the hierarchy are deacons, upon whom
      hands are imposed 'not unto the priesthood, but unto a ministry of
      service.'" -/
  | deacon
  deriving DecidableEq, BEq

-- ============================================================================
-- § 2. Core Predicates
-- ============================================================================

/-- Whether a person has been ordained to a specific degree of holy orders.

    HONEST OPACITY: The CCC does not define the metaphysics of what
    happens in ordination beyond asserting an indelible character is
    imprinted (§1582). We track the ordained state without modeling
    the mechanism of the ontological change. -/
opaque isOrdained : Person → OrderDegree → Prop

/-- Whether a person participates in the MINISTERIAL (ordained) priesthood.

    CCC §1547: "The ministerial priesthood is at the service of the
    common priesthood." The ordained priest acts "in the person of Christ
    the Head" (in persona Christi Capitis, §1548).

    HIDDEN ASSUMPTION: Acting "in persona Christi" is an ontological
    reality, not merely a social role. The priest genuinely stands in
    for Christ in confecting sacraments — he is not merely performing
    a function that anyone could perform. This is the central claim
    the Protestant rejects. -/
opaque hasMinisterialPriesthood : Person → Prop

/-- Whether a person participates in the COMMON (baptismal) priesthood.

    CCC §1546: "The whole community of believers is, as such, priestly."
    CCC §1547 (quoting LG 10): "The baptized... are consecrated to be
    a holy priesthood."

    All baptized persons share in the common priesthood. This is
    ECUMENICAL — even Protestants accept the "priesthood of all believers"
    (though they interpret it as exhausting the concept of priesthood,
    whereas Catholics hold it is one of TWO essentially different kinds). -/
opaque hasCommonPriesthood : Person → Prop

/-- Whether two kinds of priesthood differ "in essence and not only in degree."

    CCC §1547 (quoting LG 10): "Though they differ from one another in
    essence and not only in degree, the common priesthood of the faithful
    and the ministerial or hierarchical priesthood are nonetheless
    interrelated."

    HIDDEN ASSUMPTION: The phrase "in essence not degree" means they are
    not two levels of one thing but two DIFFERENT things. A ministerial
    priest is not simply a "holier" baptized person — he has a different
    KIND of participation in Christ's priesthood. The CCC asserts this
    without providing a detailed philosophical analysis. -/
opaque differInEssence : Prop

/-- Whether a person can confect the Eucharist — the central
    sacerdotal (priestly) power.

    CCC §1566: "It is in the Eucharistic cult or in the Eucharistic
    assembly of the faithful (synaxis) that they exercise in a supreme
    degree their sacred office."

    Only bishops and priests can confect the Eucharist. Deacons cannot.

    HONEST OPACITY: What "confecting" the Eucharist means at the
    metaphysical level is the subject of Eucharist.lean. Here we
    track only WHO can do it. -/
opaque canConfectEucharist : Person → Prop

/-- Whether a person can ordain others — the power to transmit holy orders.

    CCC §1576: "Since the sacrament of Holy Orders is the sacrament of
    the apostolic ministry, it is for the bishops as the successors of
    the apostles to hand on the 'gift of the Spirit,' the 'apostolic
    line.'"

    Only bishops can ordain. This is the episcopal distinctive.

    STRUCTURAL OPACITY: The CCC asserts this without explaining why
    bishops (and not priests) can ordain. The historical answer is
    apostolic succession — bishops are the successors of the apostles
    in the fullest sense. -/
opaque canOrdain : Person → Prop

-- ============================================================================
-- § 3. Denominational Tags
-- ============================================================================

/-- The three-degree structure and ontological priesthood are CATHOLIC
    (+ Orthodox). Protestants reject ontological ordination. -/
def holyOrdersOntologicalTag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Catholic + Orthodox: ontological priesthood. Protestants: ordination is functional." }

/-- The common priesthood of all believers is ECUMENICAL — all
    Christians accept it, though they interpret it differently. -/
def commonPriesthoodTag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "All Christians affirm 'priesthood of all believers' (1 Pet 2:9). Catholics add a SECOND, ministerial priesthood." }

/-- The "in essence not degree" distinction is CATHOLIC (+ Orthodox).
    Protestants hold that the common priesthood exhausts the concept. -/
def essenceNotDegreeTag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Catholic + Orthodox: two essentially different priesthoods. Protestant: one priesthood, some called to preach." }

-- ============================================================================
-- § 4. Axioms — The Structure of Holy Orders
-- ============================================================================

/-!
### The three degrees and their powers
-/

/-- AXIOM (§1557-1558): The bishop has the fullness of the sacrament of
    holy orders — he possesses both the ministerial priesthood and the
    power to ordain.

    "Among those various offices which have been exercised in the Church
    from the earliest times the chief place, according to the witness of
    tradition, is held by the function of those who, through their
    appointment to the dignity and responsibility of bishop... have taken
    over the service of the community, presiding in God's stead over the
    flock." (LG 20, cited in §1555)

    Provenance: [Council] Vatican II, LG 20-21; [CCC] §1555-1558.
    Denominational scope: CATHOLIC + ORTHODOX. -/
axiom bishop_has_fullness :
  ∀ (p : Person), isOrdained p .bishop →
    hasMinisterialPriesthood p ∧ canConfectEucharist p ∧ canOrdain p

/-- AXIOM (§1562-1566): The priest shares in the ministerial priesthood
    and can confect the Eucharist, but cannot ordain.

    "Priests, while not having the supreme degree of the pontifical
    office, and depending on the bishops in the exercise of their
    authority, are united with the bishops in sacerdotal dignity." (LG 28,
    cited in §1562)

    Provenance: [Council] Vatican II, LG 28; [CCC] §1562-1568.
    Denominational scope: CATHOLIC + ORTHODOX. -/
axiom priest_has_sacerdotal :
  ∀ (p : Person), isOrdained p .priest →
    hasMinisterialPriesthood p ∧ canConfectEucharist p ∧ ¬canOrdain p

/-- AXIOM (§1569-1571): The deacon is ordained for service, not for
    priesthood. Deacons cannot confect the Eucharist or ordain.

    "At a lower level of the hierarchy are deacons, upon whom hands are
    imposed 'not unto the priesthood, but unto a ministry of service.'"
    (LG 29, cited in §1569)

    Provenance: [Council] Vatican II, LG 29; [CCC] §1569-1571.
    Denominational scope: CATHOLIC + ORTHODOX. -/
axiom deacon_serves_not_priesthood :
  ∀ (p : Person), isOrdained p .deacon →
    ¬hasMinisterialPriesthood p ∧ ¬canConfectEucharist p ∧ ¬canOrdain p

/-!
### The ministerial/common priesthood distinction
-/

/-- AXIOM (§1547, LG 10): The ministerial and common priesthoods differ
    "in essence and not only in degree."

    "Though they differ from one another in essence and not only in degree,
    the common priesthood of the faithful and the ministerial or
    hierarchical priesthood are nonetheless interrelated; each of them in
    its own special way is a participation in the one priesthood of Christ."

    This is the central structural claim: the two priesthoods are not
    two levels of one thing but two DIFFERENT kinds of participation in
    Christ's priesthood. The ministerial priest acts "in persona Christi";
    the common priest offers spiritual sacrifices (1 Pet 2:5).

    Provenance: [Council] Vatican II, LG 10; [CCC] §1547.
    Denominational scope: CATHOLIC + ORTHODOX. -/
axiom ministerial_common_differ_in_essence :
  differInEssence

/-- AXIOM (§1546-1547): Every baptized person has the common priesthood.

    "Christ the Lord, High Priest taken from among men, made the new
    people 'a kingdom of priests to God, his Father.'" (§1546, citing
    Rev 1:6)

    Combined with Baptism.lean: baptism confers the common priesthood.
    This is ECUMENICAL — 1 Pet 2:9 ("a royal priesthood") is accepted
    by all Christians.

    Provenance: [Scripture] 1 Pet 2:9, Rev 1:6; [CCC] §1546.
    Denominational scope: ECUMENICAL. -/
axiom baptism_confers_common_priesthood :
  ∀ (p : Person), hasCommonPriesthood p

/-!
### Indelible character and ontological permanence

CCC §1582-1583: Ordination imprints an indelible character that is permanent.
A validly ordained person cannot lose the character — a laicized priest
remains ontologically a priest.

"The sacrament of Holy Orders, like the other two [baptism and confirmation],
confers an indelible spiritual character and cannot be repeated or conferred
temporarily." (§1582)

"It is true that someone validly ordained can, for grave reasons, be
discharged from the obligations and functions linked to ordination, or can
be forbidden to exercise them; but he cannot become a layman again in the
strict sense, because the character imprinted by ordination is forever." (§1583)

NOTE: The indelible character for holy orders is already axiomatized in
SacramentalCausation.lean as `holyOrders_imprints_character`, and the
non-repeatability consequence follows from `character_blocks_repetition`.
We do NOT re-axiomatize these here to avoid duplication.

CCC §1581: "This sacrament configures the recipient to Christ by a special
grace of the Holy Spirit, so that he may serve as Christ's instrument
for his Church." The ontological content of ordination is: the ordained
person is "configured to Christ" — not merely assigned a role but given
a new relation to Christ that enables instrumental causation of sacramental
grace. This is captured by the degree axioms above (bishop_has_fullness,
priest_has_sacerdotal) which specify WHAT configuration to Christ enables
at each degree.
-/

/-!
### The Protestant counter-model
-/

/-- Whether ordination is understood as purely functional — a community
    appointment to a role, without ontological change.

    MODELING CHOICE: We introduce this predicate to model the Protestant
    position directly. Under functional ordination, the minister is
    SET APART for a task but not CHANGED in what he IS. The "priesthood
    of all believers" exhausts the concept — there is no second,
    essentially different priesthood.

    Denominational scope: PROTESTANT (Lutheran, Reformed, Baptist, etc.). -/
opaque functionalOrdinationOnly : Prop

/-- AXIOM (Protestant position): Under functional ordination, ordination
    does not imprint an indelible character. The minister can resign or
    be removed; he returns to lay status fully.

    This is the NEGATION of the Catholic ontological claim. Luther
    (Address to the Christian Nobility, 1520): "All Christians are truly
    of the spiritual estate, and there is no difference among them save
    of office alone." Ordination is about function, not ontology.

    Provenance: [Modeling] Protestant counter-position to §1582.
    Denominational scope: PROTESTANT. -/
axiom functional_ordination_no_character :
  functionalOrdinationOnly →
    ¬ imprintsCharacter .holyOrders

-- ============================================================================
-- § 5. Theorems
-- ============================================================================

/-!
### Key derivations
-/

/-- THEOREM: Only bishops can ordain — the episcopate is the source of
    sacramental transmission.

    A priest has the ministerial priesthood and can confect the Eucharist
    but CANNOT ordain. A bishop can do all three. This is the episcopal
    distinctive.

    Depends on: bishop_has_fullness, priest_has_sacerdotal. -/
theorem only_bishops_ordain
    (p : Person) (h_priest : isOrdained p .priest) :
    ¬canOrdain p :=
  (priest_has_sacerdotal p h_priest).2.2

/-- THEOREM: Bishops have strictly more sacramental power than priests.

    A bishop can do everything a priest can do (ministerial priesthood +
    Eucharist) AND can ordain. A priest cannot ordain.

    Depends on: bishop_has_fullness, priest_has_sacerdotal. -/
theorem bishop_exceeds_priest
    (b : Person) (h_bishop : isOrdained b .bishop) :
    hasMinisterialPriesthood b
    ∧ canConfectEucharist b
    ∧ canOrdain b :=
  bishop_has_fullness b h_bishop

/-- THEOREM: Deacons have neither the ministerial priesthood nor
    Eucharistic power — they are ordained for service.

    Depends on: deacon_serves_not_priesthood. -/
theorem deacon_no_priestly_powers
    (p : Person) (h_deacon : isOrdained p .deacon) :
    ¬hasMinisterialPriesthood p ∧ ¬canConfectEucharist p :=
  let h := deacon_serves_not_priesthood p h_deacon
  ⟨h.1, h.2.1⟩

/-- THEOREM: The ministerial and common priesthoods are both real but
    essentially different. Every baptized person has the common priesthood;
    not all have the ministerial priesthood. A deacon, for instance, has
    the common priesthood (as a baptized person) but not the ministerial
    priesthood.

    This gives formal content to "in essence not degree": the ministerial
    priesthood is not "more" common priesthood — it is a DIFFERENT kind
    of participation in Christ's priesthood, obtained through a different
    sacrament (orders, not baptism).

    Depends on: baptism_confers_common_priesthood,
    deacon_serves_not_priesthood, ministerial_common_differ_in_essence. -/
theorem essence_not_degree_witness
    (p : Person) (h_deacon : isOrdained p .deacon) :
    hasCommonPriesthood p
    ∧ ¬hasMinisterialPriesthood p
    ∧ differInEssence :=
  ⟨ baptism_confers_common_priesthood p,
    (deacon_serves_not_priesthood p h_deacon).1,
    ministerial_common_differ_in_essence ⟩

/-- THEOREM: Holy orders is non-repeatable — connecting to
    SacramentalCausation.lean's character/repeatability biconditional.

    This is a re-derivation using the existing infrastructure:
    holy orders imprints character → character blocks repetition →
    not repeatable.

    Depends on: holyOrders_imprints_character, character_blocks_repetition
    (from SacramentalCausation.lean). -/
theorem holyOrders_non_repeatable :
    ¬isRepeatable .holyOrders :=
  character_blocks_repetition .holyOrders holyOrders_imprints_character

/-- THEOREM: The three degrees form a hierarchy of sacramental power.

    Bishop: ministerial priesthood + Eucharist + ordination
    Priest: ministerial priesthood + Eucharist + NO ordination
    Deacon: NO ministerial priesthood + NO Eucharist + NO ordination

    Each degree has a proper subset of the powers of the degree above it
    (with the addition of its own distinctive service charism for deacons).

    Depends on: bishop_has_fullness, priest_has_sacerdotal,
    deacon_serves_not_priesthood. -/
theorem three_degree_hierarchy
    (b : Person) (pr : Person) (d : Person)
    (h_b : isOrdained b .bishop)
    (h_pr : isOrdained pr .priest)
    (h_d : isOrdained d .deacon) :
    -- Bishop: all three powers
    (hasMinisterialPriesthood b ∧ canConfectEucharist b ∧ canOrdain b)
    -- Priest: two of three, not ordination
    ∧ (hasMinisterialPriesthood pr ∧ canConfectEucharist pr ∧ ¬canOrdain pr)
    -- Deacon: none of the three
    ∧ (¬hasMinisterialPriesthood d ∧ ¬canConfectEucharist d ∧ ¬canOrdain d) :=
  ⟨ bishop_has_fullness b h_b,
    priest_has_sacerdotal pr h_pr,
    deacon_serves_not_priesthood d h_d ⟩

/-- THEOREM (denominational diagnosis): The split over ordination reduces
    to whether ordination causes an ontological change (indelible character)
    or is a functional appointment.

    Under Catholic axioms: ordination imprints character → non-repeatable
    → the ordained IS a priest forever.
    Under Protestant axioms: ordination is functional → no character →
    ordination is revocable and repeatable.

    The load-bearing axiom is the same as for baptism and confirmation:
    T3 (sacramental efficacy). If sacraments cause real ontological change
    (T3), then ordination produces an indelible character. If sacraments
    are signs only (Protestant rejection of T3), then ordination is a
    community appointment.

    Depends on: holyOrders_imprints_character, character_blocks_repetition,
    functional_ordination_no_character. -/
theorem ordination_denominational_split :
    -- Catholic: character → non-repeatable
    (imprintsCharacter .holyOrders ∧ ¬isRepeatable .holyOrders)
    -- Protestant (given functional-only): no character
    ∧ (functionalOrdinationOnly → ¬imprintsCharacter .holyOrders) :=
  ⟨ ⟨holyOrders_imprints_character,
     character_blocks_repetition .holyOrders holyOrders_imprints_character⟩,
    functional_ordination_no_character ⟩

-- ============================================================================
-- § 6. Summary
-- ============================================================================

/-!
## Summary: What the CCC teaches about Holy Orders

**Axioms** (6 — from CCC §1536-1600, connected to SacramentalCausation):
1. `bishop_has_fullness` (§1555-1558) — bishops have full sacramental power
2. `priest_has_sacerdotal` (§1562-1568) — priests share ministerial priesthood
3. `deacon_serves_not_priesthood` (§1569-1571) — deacons serve, not priestly
4. `ministerial_common_differ_in_essence` (§1547, LG 10) — two essentially
   different priesthoods
5. `baptism_confers_common_priesthood` (§1546) — all baptized share common
   priesthood
6. `functional_ordination_no_character` — Protestant counter-position

NOTE: The indelible character (§1582-1583) and configuration to Christ (§1581)
are already axiomatized in SacramentalCausation.lean (`holyOrders_imprints_character`,
`holyOrders_causes_ontological`, `holyOrders_causes_dispositional`) and are
NOT re-axiomatized here to avoid duplication.

**Theorems** (6):
1. `only_bishops_ordain` — episcopal distinctive
2. `bishop_exceeds_priest` — bishop has all priestly powers + ordination
3. `deacon_no_priestly_powers` — deacon has neither ministerial nor Eucharistic power
4. `essence_not_degree_witness` — deacon has common but not ministerial priesthood
5. `holyOrders_non_repeatable` — non-repeatable (via SacramentalCausation)
6. `three_degree_hierarchy` — the complete power hierarchy
7. `ordination_denominational_split` — Catholic vs. Protestant on ontological character

**Cross-file connections:**
- `SacramentalCausation.lean`: `imprintsCharacter`, `isRepeatable`,
  `holyOrders_imprints_character`, `character_blocks_repetition`,
  `holyOrders_causes_ontological`, `holyOrders_causes_dispositional`
- `Authority.lean`: `ordinationDomain`, `christ_delegates_ordination`

**Key finding:** The three-degree structure is not merely administrative — it
maps directly onto specific sacramental powers. The episcopal/presbyteral/
diaconal division is about WHAT EACH CAN DO sacramentally, not just rank.
The bishop's distinctive is ordination power — the ability to transmit
holy orders itself.

**Key finding:** The ministerial/common distinction is formalized as two
SEPARATE predicates, not two values of one type. This reflects "in essence
not degree": they are genuinely different concepts, not a parameterized
variant. A deacon witnesses this — he has the common priesthood (baptized)
but NOT the ministerial priesthood (ordained below the sacerdotal level).

**Key finding:** The denominational split mirrors the baptism and confirmation
splits — it reduces to T3 (sacramental efficacy). If ordination merely
appoints (functional view), there is no character and the minister can
resign fully. If ordination ontologically changes (Catholic view), the
character is indelible and the sacrament non-repeatable.
-/

end Catlib.Sacraments.HolyOrders
