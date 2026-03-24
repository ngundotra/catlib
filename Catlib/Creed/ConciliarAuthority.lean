import Catlib.Foundations
import Catlib.Creed.RuleOfFaith
import Catlib.Creed.DevelopmentOfDoctrine

set_option autoImplicit false

/-!
# Conciliar Authority and the Biblical Canon (CCC §120, §250, §465)

## The Catechism claim

CCC §250: "During the first centuries the Church sought to clarify her
Trinitarian faith, both to deepen her own understanding of the faith and
to defend it against the errors that were deforming it. This clarification
was the work of the early councils, aided by the theological work of the
Church Fathers and sustained by the Christian people's sense of the faith."

CCC §465: "The first ecumenical councils served to clarify [Christ's]
true identity." Nicaea (325 AD) defined homoousios — the Son is
consubstantial with the Father.

CCC §120: "It was by the apostolic Tradition that the Church discerned
which writings are to be included in the list of the sacred books."

## The argument structure

The historical-theological argument:
1. The Council of Nicaea (325 AD) defined the Trinity (homoousios) as
   binding doctrine on the whole Church.
2. The NT canon was not universally settled until the late 4th century:
   Athanasius's 39th Festal Letter (367 AD), Councils of Hippo (393) and
   Carthage (397).
3. Therefore: the Church exercised binding doctrinal authority BEFORE the
   canon was functionally closed.
4. This authority cannot derive FROM Scripture (whose boundaries weren't
   settled yet) — it must derive from apostolic succession/Tradition.
5. But sola scriptura claims Scripture is the SOLE final authority.
6. If the authority that SETTLED doctrine and SETTLED the canon is not
   itself scriptural, then sola scriptura depends on a non-scriptural
   authority it cannot account for.

## Connection to RuleOfFaith.lean

RuleOfFaith.lean established two arguments:
- The Tradition argument: Scripture is materially incomplete (some
  apostolic teaching was never written).
- The canon argument: Scripture's authority presupposes Church judgment
  (the canon was determined by the Church).

This file adds a TEMPORAL dimension: not just "the canon depends on the
Church" but "the Church exercised binding doctrinal authority BEFORE the
canon existed." The timeline makes the dependence concrete: Nicaea defined
the Trinity in 325 AD; the canon wasn't settled until after 367 AD.

## Connection to DevelopmentOfDoctrine.lean

DevelopmentOfDoctrine.lean models how the Church unfolds what is implicit
in the deposit of faith. Nicaea is a paradigm case: the homoousios was
implicit in the apostolic deposit and was made explicit by the Council.
The conciliar authority to do this is what we formalize here.

## Denominational scope

The HISTORICAL FACTS are undisputed:
- Nicaea met in 325 AD and defined homoousios — all Christians accept this.
- The NT canon was not universally settled until the late 4th century.
- The Church exercised doctrinal authority at councils before the canon closed.

The INTERPRETATION is contested:
- CATHOLIC: The Church exercised MAGISTERIAL authority (binding, from
  apostolic succession). Councils DETERMINE doctrine.
- ORTHODOX: Agree on conciliar authority, but locate it in the whole Church
  in council, not in papal primacy. Ecumenical councils are the highest
  authority.
- PROTESTANT: The Church RECOGNIZED (not determined) both doctrine and
  canon. Conciliar authority is MINISTERIAL (serving Scripture), not
  magisterial (over Scripture). The Spirit guided the Church to recognize
  what was already true, not to create new authority.

## Prediction

I expect:
1. The temporal argument is genuinely load-bearing — it adds something
   beyond the canon argument in RuleOfFaith.lean.
2. The COMBINATION of the temporal argument with the canon argument and
   the Tradition argument is stronger than any single argument.
3. The Protestant response (ministerial authority / recognition) will be
   internally consistent but will require a different account of HOW the
   Church could reliably recognize truth without binding authority.
4. The key hidden assumption: whether conciliar authority is constitutive
   (creates binding doctrine) or recognitive (discovers pre-existing truth).

## Findings

The formalization confirms the prediction. The temporal argument adds a
genuine new dimension:

1. **The temporal argument** (new): Nicaea exercised binding doctrinal
   authority in 325 AD. The canon wasn't settled until after 367 AD.
   Therefore the Church's doctrinal authority PRECEDED the closed canon.
   This authority cannot derive from Scripture (whose boundaries were
   still contested), so it must derive from something else — apostolic
   succession and Tradition.

2. **The combination theorem** (capstone): Three independent arguments
   converge against sola scriptura:
   (a) Scripture is materially incomplete (from RuleOfFaith.lean)
   (b) The canon presupposes non-scriptural authority (from RuleOfFaith.lean)
   (c) Binding doctrine was defined BEFORE the canon was closed (new)
   Each addresses a different dimension: content, formal authority, and
   temporal priority. Together they show sola scriptura faces challenges
   on all three fronts.

3. **The main question answered**: Is the decisive anti-sola-scriptura
   point the canon problem, the conciliar problem, or the combination?
   ANSWER: The combination. Each argument alone has a Protestant counter:
   - Canon problem → self-authentication
   - Conciliar problem → ministerial authority (recognition, not determination)
   - Temporal problem → proto-canonical Scripture was sufficient for Nicaea
   But the combination is harder to address because the counters pull in
   different directions: self-authentication requires Scripture to be
   identifiable WITHOUT Church authority, while the ministerial-authority
   response grants that the Church played a role but downgrades it.

4. **The deepest hidden assumption**: Whether conciliar authority is
   constitutive or recognitive. If constitutive, Nicaea MADE homoousios
   binding. If recognitive, Nicaea DISCOVERED that homoousios was already
   binding (from Scripture and apostolic teaching). Both are internally
   consistent. The Catholic claim is constitutive authority grounded in
   apostolic succession; the Protestant claim is recognitive authority
   guided by the Spirit.

## Design decisions

1. **Temporal modeling via Epoch.** We reuse `Epoch` from
   DevelopmentOfDoctrine.lean to represent the timeline. The key property
   is ordering (Nicaea < canon closure), not specific dates.

2. **Reuse of RuleOfFaith types.** We import `MagisterialJudgment` and
   `ApostolicTeaching` from RuleOfFaith.lean rather than re-declaring them.
   The conciliar authority argument extends (not replaces) the canon argument.

3. **Protestant counter as hypothesis.** The ministerial-authority response
   is modeled as a theorem hypothesis, not a declared axiom, consistent
   with Catlib's Catholic axiom base.

4. **Five axioms, all with real content.** No vacuous bodies. Each axiom
   is wired into at least one theorem.
-/

namespace Catlib.Creed.ConciliarAuthority

open Catlib
open Catlib.Creed.RuleOfFaith (ApostolicTeaching MagisterialJudgment
  derivableFromScriptureAlone isCanonical WrittenText)
open Catlib.Creed.DevelopmentOfDoctrine (Epoch DepositOfFaith Doctrine
  implicitIn explicitlyDefined explicitAtEpoch)

-- ============================================================================
-- CORE TYPES
-- ============================================================================

/-!
## Core types

We need to model: ecumenical councils, the timeline of doctrinal definition
vs. canon closure, and the nature of conciliar authority.
-/

/-- An ecumenical council — a gathering of bishops with authority to define
    doctrine for the whole Church.
    CCC §884: "The college or body of bishops has no authority unless united
    with the Roman Pontiff, Peter's successor, as its head."
    Historical examples: Nicaea (325), Constantinople (381), Ephesus (431),
    Chalcedon (451).
    STRUCTURAL OPACITY: The internal procedure of a council (voting, debates,
    canons) is not needed for this argument — we only need the council's
    authority to issue binding definitions. -/
opaque EcumenicalCouncil : Type

/-- A doctrinal definition issued by an ecumenical council — a binding
    statement on faith or morals that the council declares for the whole
    Church.
    Example: Nicaea's definition that the Son is homoousios (consubstantial)
    with the Father.
    STRUCTURAL OPACITY: The content of the definition is not modeled — we
    need only that it IS a binding definition, not WHAT it defines. -/
opaque ConciliarDefinition : Type

/-- Whether a conciliar definition is binding on the whole Church.
    CCC §891: The Church's teaching authority can define doctrine that is
    binding. A conciliar definition that is binding cannot be rejected
    without separating from the faith.
    HONEST OPACITY: What makes a definition "binding" is itself debated.
    Catholics say the council's authority under apostolic succession makes
    it binding. Protestants say only what accords with Scripture is binding.
    We leave this opaque because the nature of bindingness IS the debate. -/
opaque isBindingDefinition : ConciliarDefinition → Prop

/-- The epoch at which a council issued its definition.
    We use Epoch (= Nat) from DevelopmentOfDoctrine.lean. The ordering is
    what matters: Nicaea (325) < canon closure (c. 390s).
    MODELING CHOICE: We use abstract epochs rather than literal years because
    the argument depends only on the ORDERING, not on the specific dates. -/
opaque epochOfDefinition : ConciliarDefinition → Epoch

/-- The epoch at which the New Testament canon was functionally closed —
    meaning universally recognized by the Church.
    Historically: Athanasius's 39th Festal Letter (367 AD) is the first list
    matching the modern 27-book NT. The Councils of Hippo (393) and Carthage
    (397, 419) ratified the list.
    HONEST OPACITY: "Functionally closed" is not a sharp moment. There was a
    gradual process of convergence. We model it as a single epoch for
    simplicity. The key property is that this epoch is AFTER Nicaea. -/
opaque canonClosureEpoch : Epoch

/-- Whether a proposition was derivable from the canon at a given epoch.
    Before the canon was closed, the set of recognized scriptural texts
    varied by region. What was "derivable from Scripture" depended on
    WHICH texts were recognized as Scripture.
    HONEST OPACITY: This conflates two issues — which texts were available
    and what could be derived from them. We keep it opaque because the
    argument only needs: at the time of Nicaea, the scriptural basis was
    not yet universally settled. -/
opaque derivableFromCanonAtEpoch : Prop → Epoch → Prop

/-- Whether a conciliar definition derives its authority from apostolic
    succession and Tradition rather than from Scripture alone.
    CCC §77: "In order that the full and living Gospel might always be
    preserved in the Church the apostles left bishops as their successors.
    They gave them their own position of teaching authority."
    This is the Catholic claim: conciliar authority comes from apostolic
    succession, which is a TRADITION-based authority.
    HIDDEN ASSUMPTION: This is precisely what Protestants deny — they hold
    that conciliar authority is derivative of and subordinate to Scripture. -/
opaque authorityFromSuccession : EcumenicalCouncil → Prop

-- ============================================================================
-- THE 5 AXIOMS
-- ============================================================================

/-!
## Axiom 1: Nicaea Defined Binding Doctrine (Historical Fact)

The Council of Nicaea (325 AD) met under Emperor Constantine and defined
that the Son is homoousios (consubstantial) with the Father. This was a
BINDING definition — rejecting it (as the Arians did) meant separation
from the orthodox faith.

This is ECUMENICAL as a historical fact. All Christians who accept the
Nicene Creed (Catholics, Orthodox, and most Protestants) accept that
Nicaea's definition was authoritative.
-/

/-- **AXIOM (NICAEA_DEFINED_BINDING_DOCTRINE)**: There exists an ecumenical
    council (Nicaea) that issued a binding doctrinal definition.
    Source: CCC §465; Council of Nicaea (325 AD); Nicene Creed.
    Denominational scope: ECUMENICAL — all Nicene Christians accept that
    Nicaea's definition of homoousios was authoritative.
    HIDDEN ASSUMPTION: "Binding" means the definition is obligatory for all
    Christians, not merely advisory. Protestants accept this for Nicaea
    specifically but ground it differently (the definition accords with
    Scripture, not that the council had independent authority). -/
axiom nicaea_defined_binding_doctrine :
  ∃ (_ : EcumenicalCouncil) (def_ : ConciliarDefinition),
    isBindingDefinition def_

def nicaea_defined_binding_doctrine_provenance : Provenance :=
  Provenance.tradition "CCC §465; Council of Nicaea (325 AD)"
def nicaea_defined_binding_doctrine_tag : DenominationalTag := ecumenical

/-!
## Axiom 2: Nicaea Preceded Canon Closure (Historical Fact)

The Council of Nicaea met in 325 AD. The NT canon was not universally
settled until Athanasius's 39th Festal Letter (367 AD) at the earliest,
and was ratified at the Councils of Hippo (393) and Carthage (397).

This is a FACTUAL claim — the dates are not disputed. The dispute is
about the theological significance of the temporal ordering.
-/

/-- **AXIOM (NICAEA_PRECEDES_CANON)**: The binding doctrinal definition from
    Nicaea was issued at an epoch BEFORE the canon was functionally closed.
    Source: Historical chronology — Nicaea 325 AD; canon closure c. 367-397 AD.
    Denominational scope: FACTUAL — the chronology is undisputed.
    HIDDEN ASSUMPTION: The temporal ordering is theologically significant.
    A Protestant could accept the chronology but deny it matters: the
    proto-canonical core (the four Gospels, major Pauline epistles) was
    already widely recognized by 325 AD, so Nicaea could have relied on
    Scripture even without a closed canon. -/
axiom nicaea_precedes_canon :
  ∀ (def_ : ConciliarDefinition),
    isBindingDefinition def_ →
    epochOfDefinition def_ < canonClosureEpoch

def nicaea_precedes_canon_provenance : Provenance :=
  Provenance.tradition "Historical chronology: Nicaea 325 AD; canon closure c. 367-397 AD"
def nicaea_precedes_canon_tag : DenominationalTag := ecumenical

/-!
## Axiom 3: Pre-Canon Doctrine Not Derivable From Settled Canon

Before the canon was closed, there was no universally settled scriptural
corpus from which to derive doctrine "from Scripture alone." The disputed
books (Hebrews, James, 2 Peter, 2-3 John, Jude, Revelation) were not
universally accepted. Regional churches used different collections.

Therefore binding doctrinal definitions made BEFORE the canon was closed
cannot have been derived from a settled canon — because no settled canon
existed yet.

This is the key step that connects the temporal ordering to the authority
question. If Nicaea's authority cannot have come from a settled canon,
it must have come from somewhere else.
-/

/-- **AXIOM (PRE_CANON_NOT_FROM_SETTLED_SCRIPTURE)**: A binding definition
    issued before canon closure was not derivable from the settled canon
    at that epoch — because the canon was not yet settled.
    Source: Historical observation — the scriptural corpus varied by region
    before the late 4th century. Eusebius (c. 325 AD) classified NT books
    into accepted, disputed, and rejected categories (Church History III.25).
    Denominational scope: CATHOLIC + ORTHODOX.
    HIDDEN ASSUMPTION: "Derivable from the settled canon" requires a SETTLED
    canon. The Protestant counter: a proto-canonical core (four Gospels,
    major Pauline epistles) was sufficiently clear to ground Nicaea's
    definition, even without a formally closed canon. This is a genuine
    counter — the homoousios argument does rest heavily on John 1 and
    Colossians 1, which were undisputed. We acknowledge this in the
    Protestant response theorem below. -/
axiom pre_canon_not_from_settled_scripture :
  ∀ (def_ : ConciliarDefinition) (p : Prop),
    isBindingDefinition def_ →
    epochOfDefinition def_ < canonClosureEpoch →
    ¬derivableFromCanonAtEpoch p (epochOfDefinition def_)

def pre_canon_not_from_settled_scripture_provenance : Provenance :=
  Provenance.tradition "Eusebius, Church History III.25; regional canon variation before 367 AD"
def pre_canon_not_from_settled_scripture_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Catholic + Orthodox; Protestants argue proto-canonical core was sufficient" }

/-!
## Axiom 4: Conciliar Authority Derives From Succession

The Catholic claim: the authority by which Nicaea defined binding doctrine
was not derived from Scripture but from apostolic succession. The bishops
at Nicaea had authority BECAUSE they were successors of the apostles,
not because they had a better reading of the Bible.

CCC §77: "In order that the full and living Gospel might always be
preserved in the Church the apostles left bishops as their successors."

This connects to the existing Authority infrastructure — apostolic
succession as the ground of teaching authority.
-/

/-- **AXIOM (CONCILIAR_AUTHORITY_FROM_SUCCESSION)**: The ecumenical council
    that defined binding doctrine derived its authority from apostolic
    succession, not from Scripture alone.
    Source: CCC §77, §861, §862; Acts 15 (Council of Jerusalem as model).
    Denominational scope: CATHOLIC + ORTHODOX. Protestants deny that
    apostolic succession grounds conciliar authority — they hold that
    councils have authority only insofar as they faithfully teach Scripture.
    HIDDEN ASSUMPTION: Apostolic succession is a REAL chain of transmitted
    authority, not merely a historical lineage. The Catholic claim is that
    something is TRANSMITTED in ordination — teaching authority itself.
    Protestants deny this metaphysical claim. -/
axiom conciliar_authority_from_succession :
  ∀ (council : EcumenicalCouncil),
    authorityFromSuccession council

def conciliar_authority_from_succession_provenance : Provenance :=
  Provenance.tradition "CCC §77, §861, §862; Acts 15"
def conciliar_authority_from_succession_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Catholic + Orthodox; Protestants deny succession grounds authority" }

/-!
## Axiom 5: Succession-Based Authority Is Not Scriptural

The authority transmitted through apostolic succession is not itself
derivable from Scripture alone. The CLAIM that bishops have binding
teaching authority by succession is a Tradition-based claim, not a
claim that Scripture makes about itself.

This is the step that connects conciliar authority to the sola scriptura
debate. If conciliar authority derives from succession, and succession is
not a scriptural principle (in the sola scriptura sense), then the
authority that defined foundational Christian doctrine is non-scriptural.
-/

/-- **AXIOM (SUCCESSION_NOT_SOLA_SCRIPTURA)**: The authority from apostolic
    succession is not derivable from Scripture alone.
    Source: Observation — no Bible verse establishes the mechanism of
    apostolic succession as a self-evident teaching of Scripture.
    Denominational scope: FACTUAL (as observation).
    Protestants accept this: they explicitly DENY that apostolic succession
    (in the Catholic/Orthodox sense) is a scriptural doctrine. They ground
    authority differently (Scripture's own authority, the Spirit's guidance
    of individual believers and congregations).
    HIDDEN ASSUMPTION: "Derivable from Scripture alone" is strict enough to
    exclude succession. A Protestant might argue that Acts 1:15-26 (Matthias
    replaces Judas) and the Pastoral Epistles (Timothy/Titus appointed by
    Paul) are scriptural evidence for succession. The Catholic response:
    these passages describe succession but don't ESTABLISH it as the
    ground of binding teaching authority. -/
axiom succession_not_sola_scriptura :
  ∀ (council : EcumenicalCouncil),
    authorityFromSuccession council →
    ¬derivableFromScriptureAlone (authorityFromSuccession council)

def succession_not_sola_scriptura_provenance : Provenance :=
  Provenance.tradition "Observation; Protestant-Catholic agreement that succession is not sola scriptura"
def succession_not_sola_scriptura_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Broadly accepted — Protestants agree succession is not a sola scriptura doctrine" }

-- ============================================================================
-- THEOREMS
-- ============================================================================

/-!
## Theorem 1: Pre-Canon Binding Authority Exists

The direct consequence of axioms 1 and 2: there exists a binding doctrinal
definition that was issued before the canon was closed. This is the
historical FACT that the argument rests on.
-/

/-- **THEOREM: pre_canon_binding_authority** — There exists a binding
    doctrinal definition issued before the canon was functionally closed.
    This is the historical fact: Nicaea (325 AD) defined homoousios before
    the canon was settled (c. 367-397 AD).

    Axiom dependencies (kernel-verified):
    - nicaea_defined_binding_doctrine
    - nicaea_precedes_canon

    Source: Historical chronology.
    Denominational scope: ECUMENICAL (as historical fact). -/
theorem pre_canon_binding_authority :
    ∃ (_ : EcumenicalCouncil) (def_ : ConciliarDefinition),
      isBindingDefinition def_ ∧ epochOfDefinition def_ < canonClosureEpoch := by
  obtain ⟨council, def_, h_binding⟩ := nicaea_defined_binding_doctrine
  exact ⟨council, def_, h_binding, nicaea_precedes_canon def_ h_binding⟩

/-!
## Theorem 2: Pre-Canon Authority Cannot Derive From Settled Scripture

Combining the temporal fact (axiom 2) with the derivability constraint
(axiom 3): the binding authority exercised before canon closure was not
derivable from a settled scriptural canon.

This is the core of the TEMPORAL argument: you cannot derive your
authority from a canon that doesn't yet exist in settled form.
-/

/-- **THEOREM: pre_canon_authority_not_from_scripture** — The binding
    doctrinal authority exercised before canon closure was not derivable
    from the settled canon.

    Axiom dependencies (kernel-verified):
    - nicaea_defined_binding_doctrine
    - nicaea_precedes_canon
    - pre_canon_not_from_settled_scripture

    Source: CCC §465, §120; historical chronology.
    Denominational scope: CATHOLIC + ORTHODOX.
    KEY FINDING: This is the TEMPORAL dimension that RuleOfFaith.lean
    doesn't capture. RuleOfFaith shows the canon DEPENDS on the Church.
    This shows the Church PRECEDED the canon. -/
theorem pre_canon_authority_not_from_scripture :
    ∃ (_ : EcumenicalCouncil) (def_ : ConciliarDefinition),
      isBindingDefinition def_ ∧
      ¬derivableFromCanonAtEpoch (isBindingDefinition def_) (epochOfDefinition def_) := by
  obtain ⟨council, def_, h_binding⟩ := nicaea_defined_binding_doctrine
  have h_precedes := nicaea_precedes_canon def_ h_binding
  have h_not_from_canon := pre_canon_not_from_settled_scripture def_
    (isBindingDefinition def_) h_binding h_precedes
  exact ⟨council, def_, h_binding, h_not_from_canon⟩

/-!
## Theorem 3: Conciliar Authority Is Non-Scriptural

Combining the succession axioms (4 and 5): the authority exercised at
ecumenical councils derives from apostolic succession, and this succession
is not derivable from Scripture alone.

Therefore: there exists a source of binding doctrinal authority that is
not derivable from Scripture alone.
-/

/-- **THEOREM: conciliar_authority_non_scriptural** — The authority of
    ecumenical councils is not derivable from Scripture alone. It derives
    from apostolic succession, which is a Tradition-based authority.

    Axiom dependencies (kernel-verified):
    - nicaea_defined_binding_doctrine
    - conciliar_authority_from_succession
    - succession_not_sola_scriptura

    Source: CCC §77, §861.
    Denominational scope: CATHOLIC + ORTHODOX.
    This extends the canon argument (RuleOfFaith.lean) with a STRUCTURAL
    argument: not only does the canon depend on the Church, but the
    Church's authority structure itself is non-scriptural. -/
theorem conciliar_authority_non_scriptural :
    ∃ (council : EcumenicalCouncil),
      authorityFromSuccession council ∧
      ¬derivableFromScriptureAlone (authorityFromSuccession council) := by
  obtain ⟨council, _, _⟩ := nicaea_defined_binding_doctrine
  have h_succession := conciliar_authority_from_succession council
  have h_not_scriptural := succession_not_sola_scriptura council h_succession
  exact ⟨council, h_succession, h_not_scriptural⟩

/-!
## Theorem 4: The Temporal Argument Against Sola Scriptura

The capstone of the temporal argument. Under Catholic axioms:
1. Binding doctrine was defined before the canon was closed (temporal fact)
2. Pre-canon authority was not from settled Scripture (temporal consequence)
3. Conciliar authority derives from non-scriptural succession (structural fact)

Therefore: the authority that defined foundational Christian doctrine
(including the doctrine most Protestants accept — the Trinity) is not
derivable from Scripture alone. Sola scriptura cannot account for the
authority that produced the doctrines it accepts.
-/

/-- **THEOREM: temporal_argument_against_sola_scriptura** — There exists
    a binding doctrinal definition that:
    (a) was issued before the canon was closed,
    (b) was not derivable from the settled canon at that time, AND
    (c) was issued by an authority grounded in non-scriptural succession.

    This is the formal statement of the temporal argument. It shows that
    the authority structure behind foundational Christian doctrine is
    non-scriptural on THREE counts: temporal priority, epistemic
    independence from the settled canon, and structural grounding in
    Tradition-based succession.

    Axiom dependencies (kernel-verified):
    - nicaea_defined_binding_doctrine
    - nicaea_precedes_canon
    - pre_canon_not_from_settled_scripture
    - conciliar_authority_from_succession
    - succession_not_sola_scriptura

    Source: CCC §465, §77, §120; historical chronology.
    Denominational scope: CATHOLIC. -/
theorem temporal_argument_against_sola_scriptura :
    ∃ (council : EcumenicalCouncil) (def_ : ConciliarDefinition),
      -- (a) Binding and pre-canon
      isBindingDefinition def_ ∧
      epochOfDefinition def_ < canonClosureEpoch ∧
      -- (b) Not from settled Scripture
      ¬derivableFromCanonAtEpoch (isBindingDefinition def_) (epochOfDefinition def_) ∧
      -- (c) From non-scriptural succession
      authorityFromSuccession council ∧
      ¬derivableFromScriptureAlone (authorityFromSuccession council) := by
  obtain ⟨council, def_, h_binding⟩ := nicaea_defined_binding_doctrine
  have h_precedes := nicaea_precedes_canon def_ h_binding
  have h_not_canon := pre_canon_not_from_settled_scripture def_
    (isBindingDefinition def_) h_binding h_precedes
  have h_succession := conciliar_authority_from_succession council
  have h_not_scriptural := succession_not_sola_scriptura council h_succession
  exact ⟨council, def_, h_binding, h_precedes, h_not_canon, h_succession, h_not_scriptural⟩

/-!
## Theorem 5: The Combined Three-Argument Case

This brings together ALL THREE arguments against sola scriptura:
1. From RuleOfFaith.lean: Scripture is materially incomplete (Tradition argument)
2. From RuleOfFaith.lean: The canon presupposes non-scriptural authority
3. From THIS FILE: Binding doctrine preceded the closed canon

Each addresses a DIFFERENT dimension:
- (1) CONTENT: Not all revealed truth is in Scripture
- (2) FORMAL: Scripture's own authority depends on the Church
- (3) TEMPORAL: The Church's doctrinal authority preceded the settled canon

The combination is stronger than any single argument because each has a
different Protestant counter, and the counters are in tension with each
other.
-/

/-- **THEOREM: three_arguments_converge** — The three anti-sola-scriptura
    arguments hold simultaneously under Catholic axioms.

    (1) Scripture is materially incomplete — there exists revealed
        teaching not in Scripture.
    (2) Pre-canon binding authority exists — binding doctrine was defined
        before the canon was settled.
    (3) Conciliar authority is non-scriptural — the authority grounding
        these definitions is not derivable from Scripture alone.

    Each argument has a different Protestant counter:
    - Against (1): All necessary doctrine WAS written (reject material
      insufficiency)
    - Against (2): The proto-canonical core was sufficient (the disputed
      books weren't needed for Nicaea)
    - Against (3): Councils have authority because they teach Scripture
      faithfully, not from succession

    The COMBINATION is harder to address because:
    - If Scripture is sufficient (counter to 1), why did the Church need
      councils to settle disputes?
    - If councils have authority (accepting 2), where does that authority
      come from?
    - If authority comes from faithful teaching of Scripture (counter to 3),
      who judges whether the teaching is faithful?

    Axiom dependencies (kernel-verified):
    - From RuleOfFaith.lean: not_everything_written
    - From this file: nicaea_defined_binding_doctrine, nicaea_precedes_canon,
      conciliar_authority_from_succession, succession_not_sola_scriptura

    Source: CCC §76, §120, §465, §77.
    Denominational scope: CATHOLIC. -/
theorem three_arguments_converge :
    -- (1) Content: Scripture is materially incomplete
    (∃ (t : ApostolicTeaching), Catlib.Creed.RuleOfFaith.isRevealed t ∧
      ¬Catlib.Creed.RuleOfFaith.inScripture t) ∧
    -- (2) Temporal: Binding doctrine preceded the closed canon
    (∃ (_ : EcumenicalCouncil) (def_ : ConciliarDefinition),
      isBindingDefinition def_ ∧ epochOfDefinition def_ < canonClosureEpoch) ∧
    -- (3) Structural: Conciliar authority is non-scriptural
    (∃ (council : EcumenicalCouncil),
      authorityFromSuccession council ∧
      ¬derivableFromScriptureAlone (authorityFromSuccession council)) := by
  refine ⟨?_, pre_canon_binding_authority, conciliar_authority_non_scriptural⟩
  exact Catlib.Creed.RuleOfFaith.scripture_materially_incomplete

/-!
## Theorem 6: Protestant Ministerial Authority vs. Catholic Succession

Fairness requires showing that the Protestant position is internally
consistent. The Protestant response to the temporal argument:

1. Councils have MINISTERIAL authority — they serve Scripture, not rule
   over it.
2. Nicaea was authoritative because it correctly taught what Scripture
   teaches, not because the bishops had independent authority.
3. The proto-canonical core was sufficient: John 1:1-3, Colossians 1:15-20,
   Philippians 2:5-11 were undisputed and suffice for homoousios.
4. The Church RECOGNIZED the canon, not DETERMINED it — the canonical
   books are self-authenticating.

This is internally consistent under Protestant axioms. But it is
INCOMPATIBLE with the Catholic axiom set. The theorem below shows
the precise point of contradiction.
-/

/-- **THEOREM: protestant_ministerial_contradicts_succession_axiom** —
    The Protestant ministerial-authority claim is incompatible with the
    Catholic axiom that succession-based authority is NOT derivable from
    Scripture alone.

    This makes the denominational cut precise: the two positions directly
    contradict each other on whether conciliar authority is scriptural.
    The debate is about which axiom is true.

    Source: The incompatibility between Catholic and Protestant ecclesiology.
    Denominational scope: Meta-theological — shows the axiom sets clash. -/
theorem protestant_ministerial_contradicts_succession_axiom
    (h_ministerial : ∀ (council : EcumenicalCouncil),
      authorityFromSuccession council →
      derivableFromScriptureAlone (authorityFromSuccession council)) :
    False := by
  obtain ⟨council, _, _⟩ := nicaea_defined_binding_doctrine
  have h_succession := conciliar_authority_from_succession council
  have h_not_scriptural := succession_not_sola_scriptura council h_succession
  exact h_not_scriptural (h_ministerial council h_succession)

-- ============================================================================
-- DENOMINATIONAL SUMMARY
-- ============================================================================

/-- Denominational scope of each axiom in the conciliar authority formalization.
    The pattern: ecumenical historical facts → Catholic interpretation of
    what those facts mean for authority → denominational cuts. -/
def conciliarAuthorityDenominationalScope : List (String × DenominationalTag) :=
  [ ("nicaea_defined_binding_doctrine",          nicaea_defined_binding_doctrine_tag)
  , ("nicaea_precedes_canon",                    nicaea_precedes_canon_tag)
  , ("pre_canon_not_from_settled_scripture",     pre_canon_not_from_settled_scripture_tag)
  , ("conciliar_authority_from_succession",      conciliar_authority_from_succession_tag)
  , ("succession_not_sola_scriptura",            succession_not_sola_scriptura_tag)
  ]

/-!
## Hidden assumptions — summary

1. **Conciliar authority is constitutive, not merely recognitive**
   (conciliar_authority_from_succession): The Catholic claim is that
   councils MAKE doctrine binding (constitutive authority from succession).
   The Protestant claim is that councils DISCOVER what was already binding
   (recognitive authority serving Scripture). This is the deepest
   interpretive disagreement.

2. **The temporal ordering is theologically significant**
   (nicaea_precedes_canon → pre_canon_not_from_settled_scripture):
   The Catholic reads the chronology as evidence that the Church's
   authority is independent of the settled canon. The Protestant can
   accept the chronology but deny it matters: the proto-canonical core
   was sufficient, and God's providence ensured the Church recognized
   truth even before the canon was formally closed.

3. **Apostolic succession is a real transmission of authority**
   (conciliar_authority_from_succession): Not merely a historical lineage
   but a metaphysical transfer of teaching authority. Protestants reject
   this metaphysical claim while sometimes accepting the historical lineage.

4. **"Binding" means obligatory, not advisory** (isBindingDefinition):
   All sides agree Nicaea was authoritative. The Catholic claim is stronger:
   Nicaea's definition is binding BECAUSE of the council's succession-based
   authority, not merely because the definition happens to be true.

5. **The proto-canonical objection is real** (hidden in axiom 3):
   The strongest Protestant counter to the temporal argument. The four
   Gospels and major Pauline epistles WERE widely recognized by 325 AD.
   The homoousios argument rests primarily on John 1 and Colossians 1,
   which were undisputed. The Catholic response: even if the proto-canon
   was sufficient for THIS definition, the PRINCIPLE of conciliar
   authority doesn't derive from the proto-canon — it derives from
   succession. And who decided which books WERE proto-canonical?

## Key finding

The decisive anti-sola-scriptura point is the COMBINATION of all three
arguments (content, canon, temporal), not any single one. Each argument
alone has a plausible Protestant counter. But the combination creates a
mutually reinforcing case: the Church that settled the canon ALSO
exercised binding authority before the canon was settled, using an
authority grounded in Tradition-based succession rather than Scripture
alone. Sola scriptura must account for ALL THREE dimensions, and the
counters to each pull in different directions.

The Protestant position remains internally consistent — but only by
adopting a different set of axioms about the nature of authority
(ministerial vs. constitutive, recognitive vs. determinative). The
debate is ultimately about which axioms are true, not about logic.
-/

end Catlib.Creed.ConciliarAuthority
