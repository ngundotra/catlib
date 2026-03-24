import Catlib.Foundations
import Catlib.Creed.RuleOfFaith
import Catlib.Creed.PapalInfallibility

set_option autoImplicit false

/-!
# Development of Doctrine (CCC §66, §84, §94)

## The puzzle

The Immaculate Conception was defined in 1854. The Assumption in 1950. These
were not in the Apostles' Creed. How can the Church "add" doctrines if revelation
closed with the apostles (§66)?

## The CCC's answer

Development is UNFOLDING, not ADDING. What was implicit in the deposit of faith
becomes explicit over time. The oak tree was already in the acorn.

CCC §66: "The Christian economy, therefore, since it is the new and definitive
Covenant, will never pass away; and no new public revelation is to be expected."

CCC §84: "The apostles entrusted the 'Sacred deposit' of the faith... to the
whole of the Church."

CCC §94: "Thanks to the assistance of the Holy Spirit, the understanding of both
the realities and the words of the heritage of faith is able to grow in the life
of the Church."

§94 gives THREE ways understanding grows:
1. Contemplation and study by believers
2. Intimate understanding from spiritual experience
3. Preaching of those with episcopal succession

## The key distinctions

1. `DepositOfFaith` — the complete revelation entrusted to the apostles (§84).
   CLOSED — nothing new added after the apostolic era.
2. `ExplicitUnderstanding` — what the Church has formally defined. GROWS over time.
3. `implicitIn` — a doctrine is "implicit in" the deposit if it can be derived
   from what was deposited. THIS is the load-bearing opaque.
4. Legitimate development: making explicit what was implicit. NOT adding new content.
5. Corruption: claiming something is implicit when it ISN'T.

## The key theorem

A legitimate development does not ADD to the deposit — it UNFOLDS it. The deposit
stays the same; understanding grows.

## The hard question

What does "implicit in" mean formally? Is the Immaculate Conception "implicit in"
Scripture? The CCC says yes (via Tradition + theological reasoning). Protestants
say no (it's an addition). This is where `implicitIn` becomes the load-bearing
opaque — and it's the most contested concept in the whole formalization.

## Denominational scope

- CATHOLIC: Development of doctrine is principled. Newman's criteria plus the
  Magisterium guide development. The Holy Spirit assists the Church in
  unfolding what was always implicitly present.
- ORTHODOX: Accept development but are more cautious — "the faith once delivered"
  (Jude 1:3). Development is allowed but the bar is higher and the mechanism
  is conciliar (the whole Church in council) rather than papal.
- PROTESTANT: Generally suspicious — development looks like addition. Sola
  scriptura limits what can "develop" since the only recognized source is
  Scripture itself.

## Newman's seven criteria (1845)

Newman's *Essay on the Development of Christian Doctrine* proposed seven notes
distinguishing legitimate development from corruption:
1. Preservation of type — the development retains the essential character
2. Continuity of principles — the same underlying principles operate
3. Power of assimilation — the development absorbs new material without losing identity
4. Logical sequence — the development follows from prior teaching by valid reasoning
5. Anticipation of its future — earlier teaching foreshadows the development
6. Conservative action on its past — the development preserves and explains prior teaching
7. Chronic vigour — the development has lasting vitality, not a temporary trend

We model these as a structure rather than individual axioms because they
function as a PACKAGE — a single doctrine must satisfy all seven to count as
legitimate development. Newman's criteria are the Catholic answer to "how do
you tell development from corruption?"

## Prediction

I expect:
1. `implicitIn` will be the most contested concept — the place where the
   real Catholic/Protestant disagreement lives.
2. The deposit-is-closed axiom will be ecumenical — everyone agrees revelation
   ended with the apostles. The dispute is about what "implicit" means.
3. The connection to RuleOfFaith.lean will be natural: dual transmission (§76)
   means the deposit includes BOTH written and oral content, so "implicit in
   the deposit" includes implications of Tradition, not just Scripture.
4. The connection to PapalInfallibility.lean will be needed: the Magisterium is
   what DECLARES a development legitimate. Without it, there's no authoritative
   mechanism to distinguish development from corruption.

## Findings

The formalization reveals that the real question is NOT "can doctrine develop?"
(everyone agrees understanding grows) but "WHO decides what was implicit?"

Under Catholic axioms, the Magisterium guided by the Holy Spirit makes this
judgment — and the ex cathedra mechanism (PapalInfallibility.lean) is the
ultimate form of such a judgment.

Under Protestant axioms, only what is derivable from Scripture alone counts,
so "implicit" is limited to logical consequences of the biblical text.

Under Orthodox axioms, the whole Church in council judges, but individual
bishops (including the Bishop of Rome) cannot unilaterally declare developments.

The deepest hidden assumption is `spirit_assists_church` — that the Holy Spirit
actively guides the Church's unfolding of implicit content. Without this, there
is no principled reason to trust that what the Church declares "implicit" actually
was implicit rather than being a later invention. This is the Catholic answer to
"how do you distinguish development from rationalization?" — the Holy Spirit
guarantees it. Protestants call this circular; Catholics call it faith in
Christ's promise to the Church (Mt 16:18, Jn 16:13).
-/

namespace Catlib.Creed.DevelopmentOfDoctrine

open Catlib
open Catlib.Creed.RuleOfFaith (ApostolicTeaching isRevealed inScripture inTradition
  MagisterialJudgment derivableFromScriptureAlone)
open Catlib.Creed.PapalInfallibility (Teaching isIrreformable)

-- ============================================================================
-- CORE TYPES
-- ============================================================================

/-!
## Core types

The central concepts: the deposit of faith, what it means for something to be
implicit in the deposit, and what counts as legitimate development.
-/

/-- The deposit of faith — the complete body of divine revelation entrusted to
    the apostles. CCC §84: "The apostles entrusted the 'Sacred deposit' of the
    faith (the depositum fidei), contained in Sacred Scripture and Tradition,
    to the whole of the Church."
    MODELING CHOICE: We model this as an opaque type rather than identifying it
    with `ApostolicTeaching` from RuleOfFaith.lean because the deposit is the
    WHOLE — the totality of revelation — not individual teachings. Individual
    doctrines are `implicitIn` or `explicitIn` the deposit. -/
opaque DepositOfFaith : Type

/-- A doctrinal proposition — a specific claim about faith or morals that the
    Church may define. These are what "develop" — they go from implicit to
    explicit as the Church's understanding unfolds. -/
opaque Doctrine : Type

/-- Whether a doctrine is implicit in the deposit of faith — present in the
    deposit but not yet formally recognized or defined.

    THIS IS THE LOAD-BEARING OPAQUE.

    HONEST OPACITY: The CCC does not give a formal definition of "implicit in."
    The concept is genuinely ambiguous between:
    (a) Logically deducible from explicit propositions in the deposit
    (b) Materially contained but requiring theological reasoning to extract
    (c) Connected by a chain of fittingness arguments to explicit content
    (d) Recognized as always having been believed by the sensus fidei

    Each of these gives a different extension to "implicit" — (a) is narrowest,
    (d) is broadest. The IC (1854) arguably requires at least (b) or (c);
    it is not a straightforward deduction from any single Scripture verse.

    The Protestant objection is precisely that "implicit" is too elastic —
    it can be stretched to include anything the Magisterium wishes to define,
    making the constraint vacuous.

    The Catholic response: the Holy Spirit guides the Church's discernment,
    so the elasticity is bounded by divine assistance, not arbitrary.

    We leave this opaque because the CCC itself does not resolve this ambiguity.
    The choice of definition for `implicitIn` IS the theological debate. -/
opaque implicitIn : Doctrine → DepositOfFaith → Prop

/-- Whether a doctrine has been explicitly defined — formally declared by the
    Church's teaching authority. A doctrine goes from implicit to explicit when
    the Magisterium defines it.
    CCC §88: "The Church's Magisterium exercises the authority it holds from
    Christ to the fullest extent when it defines dogmas." -/
opaque explicitlyDefined : Doctrine → Prop

/-- A moment in the Church's history — we need temporal ordering to express
    that understanding grows OVER TIME.
    MODELING CHOICE: We use natural numbers for simplicity. The important
    property is the ordering, not the specific encoding. -/
abbrev Epoch := Nat

/-- What the Church explicitly understands at a given epoch. This is the set
    of doctrines formally defined by that point in time. It GROWS — what
    was defined at epoch n is still defined at epoch n+1, and potentially more.
    CCC §94: "the understanding... is able to grow." -/
opaque explicitAtEpoch : Epoch → Doctrine → Prop

/-- Whether the Holy Spirit assists the Church in a specific act of doctrinal
    discernment. CCC §94: "Thanks to the assistance of the Holy Spirit."
    HIDDEN ASSUMPTION: This assistance is REAL and EFFECTIVE — it actually
    prevents the Church from defining as implicit what is genuinely not
    in the deposit. Without this, there is no principled constraint on
    what can be "developed." -/
opaque spiritAssists : MagisterialJudgment → Prop

-- ============================================================================
-- NEWMAN'S SEVEN NOTES OF GENUINE DEVELOPMENT
-- ============================================================================

/-!
## Newman's criteria

Newman's *Essay on the Development of Christian Doctrine* (1845) proposed seven
notes for distinguishing legitimate development from corruption. These are the
Catholic answer to "how do you tell?"

MODELING CHOICE: We model these as a structure rather than seven independent
axioms because they function as a PACKAGE. Newman's claim is that a genuine
development exhibits ALL seven characteristics, while a corruption fails on
at least one.

HIDDEN ASSUMPTION: These criteria are SUFFICIENT (not just necessary) to
distinguish development from corruption. A skeptic could argue that a
clever corruption might satisfy all seven criteria. Newman's implicit claim
is that the criteria are jointly discriminating.
-/

/-- Whether a doctrine satisfies Newman's seven notes of genuine development.
    The seven notes are:
    1. Preservation of type — retains the essential character
    2. Continuity of principles — the same underlying principles operate
    3. Power of assimilation — absorbs new material without losing identity
    4. Logical sequence — follows from prior teaching by valid reasoning
    5. Anticipation of its future — earlier teaching foreshadows the development
    6. Conservative action on its past — preserves and explains prior teaching
    7. Chronic vigour — has lasting vitality, not a temporary trend

    Source: Newman, *Essay on the Development of Christian Doctrine* (1845).

    HONEST OPACITY: We model this as a single opaque Prop rather than seven
    individual predicates. The CCC does not formally adopt Newman's criteria,
    and the meaning of each note (e.g., what counts as "preservation of type")
    is itself debatable. Making each note a separate axiom would give a false
    impression of precision. The single predicate tracks the CONCEPT of
    Newman-style diagnostic criteria without pretending we can formalize the
    content of each note.

    MODELING CHOICE: The seven notes function as a PACKAGE — a genuine
    development exhibits ALL seven, while a corruption fails on at least one.
    We capture this holistic character by using one predicate rather than seven. -/
opaque satisfiesNewmanNotes : Doctrine → DepositOfFaith → Prop

-- ============================================================================
-- THE 5 AXIOMS
-- ============================================================================

/-!
## Axiom 1: Revelation Is Closed (§66)

CCC §66: "The Christian economy, therefore, since it is the new and definitive
Covenant, will never pass away; and no new public revelation is to be expected
before the glorious manifestation of our Lord Jesus Christ."

This is ECUMENICAL — all Christians agree that public revelation ended with
the apostolic era. The deposit of faith is FIXED.
-/

/-- **AXIOM (REVELATION_CLOSED)**: No new doctrine can be added to the deposit
    of faith after the apostolic era. The deposit is complete and closed.
    Source: CCC §66; Jude 1:3 ("the faith once for all delivered to the saints");
    Gal 1:8 ("even if we or an angel from heaven should preach a gospel other
    than the one we preached to you, let them be under God's curse").
    Denominational scope: ECUMENICAL — all Christians accept this.
    This is the foundation that makes the development question arise: if
    revelation is closed, how can new definitions appear? -/
axiom revelation_closed :
  ∀ (d : Doctrine) (deposit : DepositOfFaith),
    explicitlyDefined d → implicitIn d deposit

def revelation_closed_provenance : Provenance :=
  Provenance.scripture "CCC §66; Jude 1:3; Gal 1:8"
def revelation_closed_tag : DenominationalTag := ecumenical

/-!
## Axiom 2: Understanding Grows (§94)

CCC §94: "Thanks to the assistance of the Holy Spirit, the understanding of
both the realities and the words of the heritage of faith is able to grow in
the life of the Church."

This is broadly ecumenical in principle — even Protestants accept that the
Church's understanding of Scripture deepens. The dispute is about the SCOPE
and MECHANISM of growth.
-/

/-- **AXIOM (UNDERSTANDING_GROWS)**: What is explicitly understood at an earlier
    epoch is still explicitly understood at a later epoch, and the set of
    explicit doctrines can only grow (never shrink).
    Source: CCC §94.
    Denominational scope: Broadly ecumenical in principle. The Catholic
    distinctive is that growth includes Tradition-based development, not just
    better exegesis of Scripture.
    MODELING CHOICE: Monotonicity of explicit understanding. The Church cannot
    "un-define" a dogma. This is itself a strong Catholic claim — the Orthodox
    would agree for conciliar definitions, but Protestants deny that any human
    definition is irreversible. -/
axiom understanding_grows :
  ∀ (e1 e2 : Epoch) (d : Doctrine),
    e1 ≤ e2 → explicitAtEpoch e1 d → explicitAtEpoch e2 d

def understanding_grows_provenance : Provenance :=
  Provenance.tradition "CCC §94"
def understanding_grows_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Catholic + Orthodox (for conciliar definitions); growth principle broadly shared" }

/-!
## Axiom 3: The Holy Spirit Assists the Church (§94)

CCC §94: "Thanks to the assistance of the Holy Spirit."
Jn 16:13: "When the Spirit of truth comes, he will guide you into all the truth."

This is the axiom that makes Catholic development PRINCIPLED rather than
arbitrary. The Holy Spirit assists the Magisterium in judging what was
implicit in the deposit.

WITHOUT THIS AXIOM, there is no principled way to distinguish development
from corruption. The Church could define anything and claim it was "implicit."
The Spirit's assistance is what bounds the process.

This is the deepest hidden assumption in the formalization.
-/

/-- **AXIOM (SPIRIT_ASSISTS_CHURCH)**: When the Magisterium defines a doctrine
    as implicit in the deposit, the Holy Spirit assists this judgment — ensuring
    that what is declared implicit actually IS implicit.
    Source: CCC §94; Jn 16:13; Mt 16:18 ("the gates of hell shall not prevail").
    Denominational scope: CATHOLIC. Orthodox locate this assistance in
    ecumenical councils. Protestants deny that any post-apostolic body has
    guaranteed assistance in defining doctrine.
    HIDDEN ASSUMPTION: This is the single deepest hidden assumption. It is
    the Catholic answer to the Protestant objection ("how do you know it was
    implicit and not invented?"). The answer is: the Holy Spirit guarantees it.
    Protestants call this circular. Catholics call it trust in Christ's promise.
    CONNECTION: This connects to PapalInfallibility.lean's T_CHARISM_EXTENDS —
    both claim that divine assistance attaches to an ecclesial OFFICE. -/
axiom spirit_assists_church :
  ∀ (j : MagisterialJudgment) (d : Doctrine) (deposit : DepositOfFaith),
    spiritAssists j →
    explicitlyDefined d →
    implicitIn d deposit

def spirit_assists_church_provenance : Provenance :=
  Provenance.scripture "CCC §94; Jn 16:13; Mt 16:18"
def spirit_assists_church_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Catholic; Orthodox locate in councils; Protestants deny post-apostolic guaranteed assistance" }

/-!
## The Deposit Is Fixed — a design note (§84)

CCC §84: "The apostles entrusted the 'Sacred deposit' of the faith... to the
whole of the Church."

The deposit itself does not change. It is the same deposit at every epoch.
What changes is the Church's UNDERSTANDING of it — what has been made explicit.

This is captured BY CONSTRUCTION: `implicitIn` has no `Epoch` parameter, so
it is time-independent by design. We do not need a separate axiom for this —
the type system already enforces it. An earlier version had a `deposit_is_fixed`
axiom (`P → P`), which was correctly identified as tautological and removed.
-/

/-!
## Axiom 4: Legitimate Development Satisfies Newman's Criteria

Newman's criteria are the Catholic STANDARD for distinguishing development
from corruption. If a doctrine satisfies all seven notes AND the Magisterium
defines it with the Spirit's assistance, it is a legitimate development.

This axiom connects Newman's philosophical criteria to the theological
process of development. The criteria are NECESSARY but not SUFFICIENT on
their own — they need the Spirit's assistance (axiom 3) to be trustworthy.
-/

/-- **AXIOM (NEWMAN_CRITERIA_NECESSARY)**: A legitimately developed doctrine
    satisfies Newman's seven notes. If the Church defines a doctrine, and the
    Spirit assists the judgment, then the doctrine satisfies the criteria.
    Source: Newman, *Essay on the Development of Christian Doctrine* (1845);
    CCC §94 (implicitly — the three ways of growth map onto Newman's criteria).
    Denominational scope: CATHOLIC. Newman's criteria are influential in
    Catholic theology but not formally defined by the Magisterium.
    MODELING CHOICE: We make Newman's criteria a CONSEQUENCE of Spirit-assisted
    definition, not a precondition. The idea is that if the Spirit truly assists,
    then the result will exhibit the hallmarks of genuine development. This
    avoids making Newman's criteria into additional axioms — they are DIAGNOSTIC,
    not constitutive. -/
axiom newman_criteria_necessary :
  ∀ (j : MagisterialJudgment) (d : Doctrine) (deposit : DepositOfFaith),
    spiritAssists j →
    explicitlyDefined d →
    implicitIn d deposit →
    satisfiesNewmanNotes d deposit

def newman_criteria_necessary_provenance : Provenance :=
  Provenance.tradition "Newman, Essay on Development (1845); CCC §94"
def newman_criteria_necessary_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Catholic; Newman's criteria influential but not formally magisterial" }

/-!
## Axiom 5: Corruption Contradicts the Deposit

A corruption is a claim that something is implicit in the deposit when it
actually is NOT. The negation of `implicitIn` is what makes something a
corruption rather than a development.

This axiom gives the corruption concept TEETH: if a doctrine contradicts
the deposit (is not merely absent from it, but inconsistent with it), then
it cannot be implicit. This is stronger than just "not implicit" — it says
certain propositions are EXCLUDED by the deposit's content.
-/

/-- Whether a doctrine contradicts the content of the deposit — not merely
    absent from it, but inconsistent with what the deposit contains.
    Example: Arianism (Christ is a creature) contradicts the deposit's
    affirmation of Christ's divinity. It is not merely "not implicit" but
    positively excluded.
    HONEST OPACITY: The boundary between "not implicit" and "contradicts"
    is itself debatable. We keep this opaque because the CCC does not
    give a formal criterion for contradiction vs. mere absence. -/
opaque contradictsDeposit : Doctrine → DepositOfFaith → Prop

/-- **AXIOM (CONTRADICTION_EXCLUDES_IMPLICITNESS)**: If a doctrine contradicts
    the deposit, it is not implicit in the deposit. What contradicts the
    deposit cannot have been part of it.
    Source: CCC §66 (no new revelation); Gal 1:8 (anathema on a different gospel).
    Denominational scope: ECUMENICAL — all Christians agree that what contradicts
    divine revelation is not part of divine revelation.
    HIDDEN ASSUMPTION: `implicitIn` and `contradictsDeposit` are mutually
    exclusive. This assumes the deposit is consistent — it does not contain
    contradictory implications. This is itself a strong assumption (the
    deposit is divinely given, hence consistent). -/
axiom contradiction_excludes_implicitness :
  ∀ (d : Doctrine) (deposit : DepositOfFaith),
    contradictsDeposit d deposit →
    ¬implicitIn d deposit

def contradiction_excludes_implicitness_provenance : Provenance :=
  Provenance.scripture "CCC §66; Gal 1:8"
def contradiction_excludes_implicitness_tag : DenominationalTag := ecumenical

-- ============================================================================
-- THEOREMS
-- ============================================================================

/-!
## Theorem 1: Development Does Not Add to the Deposit

The KEY THEOREM. A legitimate development (one where the doctrine is implicit
in the deposit) does not ADD to the deposit — it UNFOLDS it. The deposit
remains the same; only understanding grows.

This is the answer to the puzzle: the IC (1854) and the Assumption (1950)
were not ADDED to the deposit. They were UNFOLDED from what was always
implicit in it. The deposit at the time of the apostles already contained
(implicitly) the IC and the Assumption — it just took centuries of
reflection for the Church to make them explicit.
-/

/-- **THEOREM: development_does_not_add** — A legitimately defined doctrine
    was always implicit in the deposit. The definition makes it EXPLICIT
    but does not change the deposit itself.

    This is the formal statement of the CCC's answer to "how can the Church
    define new dogmas if revelation is closed?" The answer: it cannot define
    NEW dogmas (genuinely new content). It can only make EXPLICIT what was
    always IMPLICIT.

    Source: CCC §66, §84, §94.
    Denominational scope: CATHOLIC (requires spirit_assists_church). -/
theorem development_does_not_add
    (j : MagisterialJudgment) (d : Doctrine) (deposit : DepositOfFaith)
    (h_assists : spiritAssists j)
    (h_defined : explicitlyDefined d) :
    implicitIn d deposit :=
  spirit_assists_church j d deposit h_assists h_defined

/-- **THEOREM: development_preserves_newman** — A Spirit-assisted development
    satisfies all of Newman's criteria for genuine development.

    This connects the theological mechanism (Spirit's assistance) to the
    philosophical criteria (Newman's notes). If the Spirit truly guides the
    process, the result exhibits the hallmarks of legitimate development. -/
theorem development_preserves_newman
    (j : MagisterialJudgment) (d : Doctrine) (deposit : DepositOfFaith)
    (h_assists : spiritAssists j)
    (h_defined : explicitlyDefined d) :
    satisfiesNewmanNotes d deposit :=
  newman_criteria_necessary j d deposit h_assists h_defined
    (development_does_not_add j d deposit h_assists h_defined)

/-!
## Theorem 2: A Contradictory Doctrine Cannot Be Defined

If a doctrine contradicts the deposit, then defining it would violate the
closure of revelation. This theorem chains two axioms:
- `contradiction_excludes_implicitness`: contradiction → not implicit
- `revelation_closed`: defined → implicit

The contrapositive of `revelation_closed` is: not implicit → not defined.
Combined: contradiction → not implicit → not definable.

This is the formal answer to "can a heresy be a legitimate development?"
No — because a heresy contradicts the deposit, and what contradicts the
deposit cannot have been implicit, and what was not implicit cannot be
legitimately defined.
-/

/-- **THEOREM: contradiction_blocks_definition** — A doctrine that contradicts
    the deposit cannot be legitimately defined. If it is defined anyway, we
    reach a contradiction — showing the definition itself was illegitimate.

    This chains `contradiction_excludes_implicitness` with the contrapositive
    of `revelation_closed`. It is the formal version of: "heresy cannot be
    development, because heresy contradicts what was deposited."

    Source: CCC §66 (revelation closed); Gal 1:8 (anathema on different gospel).
    Denominational scope: ECUMENICAL — all Christians agree heresies cannot
    be legitimate developments. -/
theorem contradiction_blocks_definition
    (d : Doctrine) (deposit : DepositOfFaith)
    (h_contradicts : contradictsDeposit d deposit)
    (h_defined : explicitlyDefined d) :
    False := by
  have h_not_implicit := contradiction_excludes_implicitness d deposit h_contradicts
  have h_implicit := revelation_closed d deposit h_defined
  exact h_not_implicit h_implicit

/-!
## Theorem 3: The Protestant Limit on Development

Under sola scriptura, "implicit in the deposit" reduces to "derivable from
Scripture alone." This is a MUCH narrower notion of implicitness than the
Catholic one (which includes Tradition-based reasoning).

The Protestant position: if a doctrine cannot be derived from Scripture alone,
it is an addition, not a development. This is why Protestants reject the IC
and the Assumption — they cannot find these doctrines in Scripture.

We model the Protestant position honestly: it is internally consistent.
The disagreement is about the scope of `implicitIn`, not about logic.
-/

/-- Whether a doctrine is derivable from Scripture alone — the Protestant
    standard for what counts as "implicit in" revelation.
    MODELING CHOICE: This is a restriction of `implicitIn` — if something is
    derivable from Scripture alone, it is a fortiori implicit in the full
    deposit (which includes Scripture). But the converse does not hold:
    something can be implicit in the deposit (via Tradition) without being
    derivable from Scripture alone.
    This asymmetry is the formal structure of the Catholic-Protestant
    disagreement about development. -/
opaque doctrineDerivableFromScriptureAlone : Doctrine → Prop

/-- **THEOREM: protestant_development_limit** — Under the Protestant axiom set,
    only doctrines derivable from Scripture alone can count as legitimate
    developments. Any doctrine NOT derivable from Scripture alone is, from
    the Protestant perspective, an illegitimate addition.

    This makes the denominational cut precise. The Catholic has a WIDER notion
    of "implicit" (includes Tradition-based reasoning). The Protestant has a
    NARROWER notion (Scripture alone). The IC is implicit under the wide
    notion but not under the narrow one — hence the disagreement.

    Source: Sola scriptura principle; 2 Tim 3:16-17.
    Denominational scope: PROTESTANT. -/
theorem protestant_development_limit
    (d : Doctrine)
    (h_not_scriptural : ¬doctrineDerivableFromScriptureAlone d)
    (h_sola_standard : ¬doctrineDerivableFromScriptureAlone d →
      ∀ (deposit : DepositOfFaith), ¬implicitIn d deposit) :
    ∀ (deposit : DepositOfFaith), ¬implicitIn d deposit :=
  h_sola_standard h_not_scriptural

/-!
## Theorem 4: The Orthodox Middle Position

The Orthodox accept development but locate the discernment authority in
ecumenical councils rather than the papal Magisterium. They accept that
understanding grows (§94) but deny that the Bishop of Rome can unilaterally
declare a development legitimate.

This is the intermediate position: broader than the Protestant (accepts
Tradition-based development) but narrower than the Catholic (requires
conciliar rather than papal authority).
-/

/-- Whether a development has been ratified by an ecumenical council.
    The Orthodox standard: only conciliar definitions are binding on the
    whole Church. Papal definitions (like the IC 1854 and Assumption 1950)
    lack conciliar ratification. -/
opaque ratifiedByConcil : Doctrine → Prop

/-- **THEOREM: orthodox_development_standard** — Under the Orthodox axiom set,
    a development requires conciliar ratification. A papal definition without
    conciliar support is not binding.

    The IC (1854) and Assumption (1950) were defined ex cathedra by the Pope
    WITHOUT an ecumenical council. This is precisely where the Catholic-Orthodox
    split on development lies: not on WHETHER development is possible, but on
    WHO has the authority to declare it.

    Source: Orthodox ecclesiology; the seven ecumenical councils.
    Denominational scope: ORTHODOX. -/
theorem orthodox_development_standard
    (d : Doctrine)
    (h_not_conciliar : ¬ratifiedByConcil d)
    (h_orthodox_standard : ¬ratifiedByConcil d → ¬explicitlyDefined d) :
    ¬explicitlyDefined d :=
  h_orthodox_standard h_not_conciliar

/-!
## Theorem 5: The Three-Way Denominational Split

The formalization makes the three-way split precise:

- CATHOLIC: Wide implicitness (Scripture + Tradition) + papal authority
  → IC and Assumption are legitimate developments
- ORTHODOX: Wide implicitness (Scripture + Tradition) + conciliar authority only
  → IC and Assumption are not yet ratified (no council)
- PROTESTANT: Narrow implicitness (Scripture alone) + no development authority
  → IC and Assumption are additions, not developments

The KEY FINDING: The dispute is NOT about whether development is possible.
It is about TWO THINGS:
1. What counts as "implicit" (wide vs. narrow)
2. Who has the authority to declare something explicit (pope vs. council vs. nobody)
-/

/-- **THEOREM: development_requires_both** — A legitimate (Catholic) development
    requires BOTH that the doctrine is implicit in the deposit AND that the
    Spirit assists the defining judgment. Neither alone is sufficient.

    Without implicitness, you have corruption (adding new content).
    Without Spirit's assistance, you have no guarantee the judgment is correct.

    This is the formal answer to "what criteria distinguish legitimate
    development from retrospective rationalization?" The answer:
    implicitness (the doctrine was always there) + divine assistance
    (the Church correctly identified it). -/
theorem development_requires_both
    (j : MagisterialJudgment) (d : Doctrine) (deposit : DepositOfFaith)
    (h_assists : spiritAssists j)
    (h_defined : explicitlyDefined d) :
    implicitIn d deposit ∧ satisfiesNewmanNotes d deposit :=
  ⟨development_does_not_add j d deposit h_assists h_defined,
   development_preserves_newman j d deposit h_assists h_defined⟩

/-!
## Theorem 6: Understanding Is Monotonically Non-Decreasing

The Church's explicit understanding can only grow — what was defined at an
earlier time remains defined at a later time. This is a consequence of
`understanding_grows` and makes the irreversibility of dogma precise.

This connects to PapalInfallibility.lean's `isIrreformable`: once defined
ex cathedra, a teaching cannot be reversed. Development is a ratchet.
-/

/-- **THEOREM: explicit_understanding_monotone** — If a doctrine is explicit
    at epoch e1, it remains explicit at all later epochs.

    Immediate consequence of `understanding_grows`. The Church cannot
    "un-define" a dogma. This is the formal expression of irreformability
    at the level of explicit understanding.

    Source: CCC §94 (understanding grows); CCC §891 (irreformability).
    Denominational scope: CATHOLIC + ORTHODOX (for conciliar definitions).
    Protestants deny that any human definition is irreversible in principle. -/
theorem explicit_understanding_monotone
    (e1 e2 : Epoch) (d : Doctrine)
    (h_order : e1 ≤ e2) (h_earlier : explicitAtEpoch e1 d) :
    explicitAtEpoch e2 d :=
  understanding_grows e1 e2 d h_order h_earlier

-- ============================================================================
-- DENOMINATIONAL SUMMARY
-- ============================================================================

/-- Denominational scope of each axiom in the development of doctrine
    formalization. The pattern: ecumenical foundations (revelation closed,
    deposit fixed) → Catholic mechanisms (Spirit assists, Newman criteria)
    → denominational cuts on authority and scope. -/
def developmentDenominationalScope : List (String × DenominationalTag) :=
  [ ("revelation_closed",                    revelation_closed_tag)
  , ("understanding_grows",                  understanding_grows_tag)
  , ("spirit_assists_church",                spirit_assists_church_tag)
  , ("newman_criteria_necessary",            newman_criteria_necessary_tag)
  , ("contradiction_excludes_implicitness",  contradiction_excludes_implicitness_tag)
  ]

/-!
## Hidden assumptions — summary

1. **The Holy Spirit assists the Church's doctrinal judgments**
   (spirit_assists_church): The DEEPEST hidden assumption. Without this,
   there is no principled distinction between development and corruption.
   The Church could define anything and claim it was "implicit."

2. **`implicitIn` is a fact of the matter** (contradiction_excludes_implicitness):
   A doctrine either IS or IS NOT implicit in the deposit, regardless of
   what anyone claims. This assumes bivalence about implicitness —
   that there is a definite answer even if we cannot determine it.
   An anti-realist about theological content would reject this.

3. **Understanding is irreversible** (understanding_grows): Once defined,
   a dogma cannot be un-defined. This is a strong claim about the nature
   of ecclesial authority. Protestants deny this (the Church CAN err,
   including in formal definitions).

4. **Newman's criteria are diagnostic** (newman_criteria_necessary):
   We model the seven notes as CONSEQUENCES of Spirit-assisted development,
   not as independent tests. This means we cannot USE them to CHECK whether
   a development is legitimate — we can only observe that legitimate
   developments exhibit them. A stronger model would make them a test.

5. **The deposit includes Tradition** (implicit in the connection to
   RuleOfFaith.lean): Under Catholic axioms, "implicit in the deposit"
   includes implications of Sacred Tradition, not just Scripture. This is
   what WIDENS the scope of development beyond what sola scriptura allows.
   The IC is "implicit" because it follows from Mary's unique grace (Lk 1:28)
   AS READ THROUGH the Tradition of the Fathers and the sensus fidei.

## Key finding

The formalization reveals that the real question is not "can doctrine develop?"
but "WHO decides what was implicit?" The answer to this question — papal
Magisterium (Catholic), ecumenical council (Orthodox), or nobody/Scripture alone
(Protestant) — determines which specific developments are accepted. The LOGIC
of development is shared; the AUTHORITY to apply it is the denominational cut.
-/

end Catlib.Creed.DevelopmentOfDoctrine
