import Catlib.Foundations
import Catlib.Creed.PapalInfallibility
import Catlib.Creed.RuleOfFaith

set_option autoImplicit false

/-!
# Why Can't Private Judgment Settle Doctrine? (CCC §85, §100, §889)

## The Catechism claim

CCC §85: "The task of giving an authentic interpretation of the Word of God,
whether in its written form or in the form of Tradition, has been entrusted
to the living teaching office of the Church alone."

CCC §100: "The task of interpretation has been entrusted to the bishops in
communion with the successor of Peter."

CCC §889: "In order to preserve the Church in the purity of the faith handed
on by the apostles, Christ who is the Truth willed to confer on her a share
in his own infallibility."

## The puzzle

Why can't each Christian read the Bible and figure out doctrine for themselves?
Why do you need a Magisterium?

## The CCC's answer

1. **Epistemic disagreement is real**: Sincere, competent readers of the same
   text arrive at different conclusions. This is not hypothetical — 30,000+
   Protestant denominations attest to it.

2. **No internal resolver**: Private judgment has no mechanism to settle
   disagreements between two equally sincere readers. Each appeals to "what
   Scripture plainly says" — but they disagree on what it plainly says.

3. **Christ established a teaching authority**: The Magisterium was established
   precisely to resolve this problem (§85).

4. **Therefore**: Private judgment is insufficient as the ULTIMATE rule of
   faith — it needs an external adjudicator.

## The key insight

This is an EPISTEMIC argument, not a moral one. It doesn't say private
judgment is BAD — it says private judgment is INSUFFICIENT. Even good-faith
readers disagree. The Magisterium is not there because people are stupid;
it's there because interpretation is genuinely underdetermined.

## Connection to NaturalLaw.lean

The `rational_convergence` theorem says two reasoners with the same premises
converge. But private judgment on Scripture DOESN'T converge — which means
either (a) the premises differ (different canons, different hermeneutics) or
(b) rational convergence requires more than sincerity (it requires a shared
interpretive framework). Either way, private judgment alone is insufficient.

## Denominational scope

- CATHOLIC + ORTHODOX: accept Magisterial authority as final interpreter
- PROTESTANT: private judgment guided by the Holy Spirit is sufficient.
  The "perspicuity of Scripture" — Scripture is clear enough on essential
  matters.

## Prediction

I expect:
1. The decisive problem is the ABSENCE OF A PRINCIPLED ADJUDICATOR, not
   epistemic disagreement alone. Disagreement is the symptom; the lack of
   a resolver is the structural defect.
2. The connection to NaturalLaw.lean's rational_convergence will be revealing:
   rational convergence FAILS for interpretation, which means interpretation
   requires more than reason applied to text.
3. The Protestant perspicuity defense will be internally consistent but will
   require a strong hidden assumption about the Holy Spirit's role in guiding
   individual readers to convergence on essentials.

## Findings

The formalization confirms prediction (1): the decisive structural problem is
that private judgment lacks an adjudication mechanism. Disagreement is the
EVIDENCE that something is missing, but the STRUCTURAL DEFECT is that when
two sincere readers disagree, private judgment provides no principled way to
determine who is right. Each reader appeals to private judgment — which is
the very faculty in dispute.

The connection to rational convergence is illuminating: NaturalLaw.lean's
`rational_convergence` says that rational agents examining the same premises
converge. Interpretive divergence on Scripture means either (a) the premises
are not the same (different canons, hermeneutics, presuppositions) or (b)
rational convergence requires a shared framework beyond individual reason.
Either diagnosis supports the Catholic conclusion: you need something BEYOND
private judgment to ground doctrinal unity.

The Protestant perspicuity defense is internally consistent: if the Holy Spirit
guides sincere readers to agree on essentials, then disagreement on non-essentials
is tolerable. But this requires (a) a principled essential/non-essential
distinction (itself requiring authority to draw), and (b) the empirical claim
that Spirit-guided readers DO converge on essentials — contested by the fact
that sincere Protestants disagree on baptism, predestination, the Eucharist,
and other matters most would consider essential.

## Design decisions

1. **Types from RuleOfFaith.lean**: We reuse `ApostolicTeaching` from
   RuleOfFaith.lean rather than defining a new "doctrine" type. This
   formalization is about HOW doctrine is interpreted, not what it contains.

2. **Interpreters, not just reasoners**: We introduce `Interpreter` as a
   specialization — a person applying reason to a text. This is distinct from
   NaturalLaw.lean's `TwoReasoners` because interpretation involves a TEXT
   (not just abstract premises).

3. **The adjudicator is the key**: The central type is `Adjudicator` — a
   mechanism for resolving interpretive disagreements. Private judgment
   LACKS one; the Magisterium IS one. This is what makes the argument
   structural rather than ad hominem.

4. **Protestant axioms as hypotheses**: As in RuleOfFaith.lean, Protestant
   positions (perspicuity, Spirit-guided convergence) are modeled as
   hypotheses, not declarations, because Catlib's axiom base is Catholic.
-/

namespace Catlib.Creed.PrivateJudgment

open Catlib
open Catlib.Creed.RuleOfFaith (ApostolicTeaching)

-- ============================================================================
-- TYPES FOR THE PRIVATE JUDGMENT PROBLEM
-- ============================================================================

/-!
## Core types

We need to model: interpreters, interpretations, disagreement, and
the mechanism (or lack thereof) for resolving disagreement.
-/

/-- An interpretation of a teaching — the conclusion a reader draws from
    studying a text. Two readers of the same text can produce different
    interpretations. This is the basic unit of the private judgment problem.
    STRUCTURAL OPACITY: The internal structure of an interpretation is not
    needed — we only need to know whether two interpretations agree or not.
    What matters is the RELATION between interpretations (agreement/disagreement),
    not their content. -/
opaque Interpretation : Type

/-- Whether two interpretations agree on a given teaching.
    CCC §85 implies that disagreement is expected without authoritative
    guidance: if interpretation were obvious, there would be no need to
    "entrust" it to a teaching office.
    HONEST OPACITY: What counts as "agreement" is itself underdetermined.
    Do two readers agree if they reach the same conclusion by different
    reasoning? If they agree on the proposition but not its implications?
    We treat agreement as opaque because the formalization does not model
    the granularity of doctrinal agreement. -/
opaque interpretationsAgree : Interpretation → Interpretation → Prop

/-- Whether a person is a sincere interpreter — someone who studies
    Scripture honestly and competently, not someone arguing in bad faith.
    The private judgment argument does NOT assume interpreters are stupid
    or dishonest. It assumes they are sincere and competent — and STILL
    disagree. This is what makes it an epistemic argument rather than a
    moral one.
    HONEST OPACITY: "Sincerity" is not precisely defined. We mean:
    genuine intellectual effort, honest engagement with the text, and
    no deliberate distortion. The argument works under ANY reasonable
    reading of sincerity. -/
opaque isSincereInterpreter : Person → Prop

/-- The interpretation a given person produces of a given teaching.
    This is a function: each interpreter, applied to a teaching, produces
    one interpretation. In reality people's interpretations shift over time,
    but for the structural argument we model interpretation as a snapshot.
    MODELING CHOICE: We model interpretation as deterministic (one person,
    one teaching → one interpretation). In reality, interpretation involves
    ongoing refinement. But the structural argument only needs the fact that
    AT SOME POINT two interpreters can disagree, not that they always do. -/
axiom interprets : Person → ApostolicTeaching → Interpretation

/-- An adjudicator — a mechanism for resolving interpretive disagreements.
    This is the KEY type in the formalization. The entire argument turns on
    whether private judgment has access to an adjudicator.
    Examples:
    - The Magisterium (CCC §85): an external teaching authority
    - An ecumenical council: bishops in communion settling doctrine
    - Scripture itself: if one claims Scripture adjudicates its own disputes
    - The Holy Spirit: if one claims the Spirit resolves disagreements
      in individual readers
    STRUCTURAL OPACITY: We do not model HOW an adjudicator resolves disputes,
    only WHETHER one exists and whether it is principled (can resolve any
    doctrinal dispute, not just easy ones). -/
opaque Adjudicator : Type

/-- Whether an adjudicator can resolve a disagreement about a specific
    teaching. An adjudicator that can resolve SOME disputes but not others
    is insufficient as a RULE OF FAITH — a rule of faith must be able to
    settle any doctrinal question, not just the easy ones.
    HONEST OPACITY: What counts as "resolving" a dispute is itself a deep
    question. Does the resolution need to be ACCEPTED by both parties?
    Or just objectively determinable? The Catholic view is the latter:
    the Magisterium's judgment is binding regardless of acceptance. -/
opaque canResolve : Adjudicator → ApostolicTeaching → Prop

/-- Whether private judgment (as a method) provides its own adjudicator.
    The Catholic claim: it does NOT. When two sincere readers disagree,
    private judgment offers no mechanism beyond "read more carefully" —
    which is precisely the faculty that produced the disagreement.
    HONEST OPACITY: Protestants would contest this framing. They argue
    the Holy Spirit IS the adjudicator internal to private judgment. The
    Catholic response: the Holy Spirit guides the Church corporately
    (through the Magisterium), not individuals atomistically. -/
opaque privateJudgmentHasAdjudicator : Prop

/-- Whether the Magisterium functions as an adjudicator for doctrinal
    disputes. CCC §85: the task of authentic interpretation has been
    "entrusted to the living teaching office of the Church alone."
    This connects to PapalInfallibility.lean — the Magisterium's
    adjudicating authority is grounded in the Petrine commission and
    apostolic succession. -/
opaque magisteriumIsAdjudicator : Prop

/-- Whether Scripture is perspicuous — clear enough on essential matters
    that a sincere reader can understand the saving message without
    magisterial help. This is the main Protestant defense against the
    Catholic argument.
    Westminster Confession 1.7: "All things in Scripture are not alike
    plain in themselves, nor alike clear unto all; yet those things which
    are necessary to be known, believed, and observed, for salvation, are
    so clearly propounded and opened in some place of Scripture or other,
    that not only the learned, but the unlearned, in a due use of the
    ordinary means, may attain unto a sufficient understanding of them."
    RESEARCH NEEDED: The perspicuity claim applies to "things necessary
    for salvation" — but the boundary of what's necessary for salvation
    is itself a doctrinal question. Is the real presence of Christ in the
    Eucharist "necessary for salvation"? Protestants disagree among
    themselves. -/
opaque scripturePerspicuous : Prop

-- ============================================================================
-- THE FOUR CATHOLIC AXIOMS
-- ============================================================================

/-!
## Axiom 1: Sincere Disagreement Exists (§85 implied; empirical)

CCC §85 implies that sincere disagreement is expected: if interpretation were
obvious, there would be no need to entrust it to a teaching office. The mere
existence of the Magisterium is evidence that the Church expects interpretive
disagreement.

This is also an empirical claim: the history of Christianity provides
overwhelming evidence that sincere, competent readers of Scripture disagree
on important doctrines (baptism, eucharist, predestination, ecclesiology,
soteriology, Mariology, etc.).
-/

/-- **AXIOM (SINCERE_DISAGREEMENT)**: There exists a teaching on which two
    sincere interpreters produce different interpretations.
    Source: CCC §85 (implied); empirical (denominational diversity).
    Denominational scope: BROADLY FACTUAL. Even Protestants acknowledge
    that sincere Christians disagree — they just think the disagreements
    are tolerable or resolvable without a Magisterium.

    HIDDEN ASSUMPTION: The disagreement is GENUINE, not merely verbal.
    Two readers might use different words for the same idea. This axiom
    claims that at least some doctrinal disagreements are about the THING
    ITSELF, not just about terminology. -/
axiom sincere_disagreement :
  ∃ (p1 p2 : Person) (t : ApostolicTeaching),
    isSincereInterpreter p1 ∧
    isSincereInterpreter p2 ∧
    ¬interpretationsAgree (interprets p1 t) (interprets p2 t)

def sincere_disagreement_provenance : Provenance :=
  Provenance.tradition "CCC §85 (implied); empirical observation"
def sincere_disagreement_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical]
    note := "Broadly factual; all traditions acknowledge some sincere disagreement" }

/-!
## Axiom 2: Private Judgment Lacks an Adjudicator (§85)

This is the STRUCTURAL claim at the heart of the argument. When two sincere
readers disagree, private judgment provides no principled mechanism to settle
the dispute. Each reader appeals to "what Scripture plainly says" — but
they disagree on what it plainly says. The appeal is circular: the method
being used to adjudicate IS the method that produced the disagreement.

CCC §85: "The task of giving an authentic interpretation... has been entrusted
to the living teaching office of the Church alone." The word "alone" implies
that no other mechanism is adequate.
-/

/-- **AXIOM (NO_PRIVATE_ADJUDICATOR)**: Private judgment, as a method, does
    not provide a principled adjudicator for doctrinal disputes.
    Source: CCC §85.
    Denominational scope: CATHOLIC + ORTHODOX. Protestants deny this —
    they claim the Holy Spirit guides individual readers, or that
    Scripture is perspicuous enough on essentials.

    HIDDEN ASSUMPTION: An adjudicator must be EXTERNAL to the disputed
    faculty. If private judgment is the faculty in dispute, private
    judgment cannot adjudicate its own disputes. This is an epistemological
    principle, not a theological one — it applies to any system that lacks
    an external checkpoint. -/
axiom no_private_adjudicator :
  ¬privateJudgmentHasAdjudicator

def no_private_adjudicator_provenance : Provenance :=
  Provenance.tradition "CCC §85"
def no_private_adjudicator_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Catholic + Orthodox; Protestants deny — claim Spirit-guidance or perspicuity" }

/-!
## Axiom 3: Christ Established a Teaching Authority (§85, §100, §889)

Christ did not leave interpretation to chance. He established a teaching
authority — the Magisterium — to resolve doctrinal disputes and preserve
the purity of the faith.

This connects to PapalInfallibility.lean's chain: the Petrine commission
(Mt 16:18-19), the faith prayer (Lk 22:31-32), and apostolic succession
ground the Magisterium's authority to adjudicate.

CCC §889: Christ "willed to confer on her a share in his own infallibility."
-/

/-- **AXIOM (MAGISTERIUM_ESTABLISHED)**: Christ established the Magisterium
    as an adjudicator for doctrinal disputes.
    Source: CCC §85, §100, §889; Mt 16:18-19; Mt 28:18-20.
    Denominational scope: CATHOLIC + ORTHODOX (with qualifications).
    Orthodox accept conciliar teaching authority but deny papal supremacy.

    CONNECTION TO PapalInfallibility.lean: The Magisterium's authority is
    grounded in the Petrine commission and apostolic succession. This axiom
    is a CONSEQUENCE of the PapalInfallibility axiom chain, but we state
    it independently here because the private judgment argument does not
    require the FULL infallibility machinery — it only requires that
    a teaching authority EXISTS and CAN adjudicate.

    HIDDEN ASSUMPTION: A divinely established authority can be reliably
    identified. Which institution IS the Magisterium? The Catholic answer
    is clear (the Pope and bishops in communion with him). But identifying
    the Magisterium requires SOME prior act of judgment — creating a
    worry about regress similar to the one leveled against private judgment. -/
axiom magisterium_established :
  magisteriumIsAdjudicator

def magisterium_established_provenance : Provenance :=
  Provenance.tradition "CCC §85, §100, §889; Mt 16:18-19"
def magisterium_established_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Catholic + Orthodox (with qualifications); Protestants reject" }

/-!
## Axiom 4: The Magisterium Can Resolve Doctrinal Disputes (§85, §100)

It is not enough that the Magisterium EXISTS — it must be able to RESOLVE
disputes. CCC §85 says interpretation has been "entrusted" to the
Magisterium, implying it has the competence (divine assistance) to settle
questions about faith and morals.

This is stronger than mere existence: it claims the Magisterium's
adjudicatory capacity is UNIVERSAL over matters of faith and morals, not
limited to a few clear-cut cases.
-/

/-- **AXIOM (MAGISTERIUM_CAN_ADJUDICATE)**: For any teaching on which sincere
    interpreters disagree, there exists an adjudicator that can resolve the
    dispute — namely, the Magisterium.
    Source: CCC §85, §100.
    Denominational scope: CATHOLIC.

    This is the strongest of the four axioms. It claims not just that the
    Magisterium exists, but that it has UNIVERSAL competence over doctrinal
    questions. In practice, the Magisterium has not resolved every possible
    question — many remain open (the fate of unbaptized infants, the exact
    nature of limbo, etc.). But the COMPETENCE to resolve, when exercised,
    is claimed to be definitive. -/
axiom magisterium_can_adjudicate :
  ∀ (t : ApostolicTeaching),
    (∃ (p1 p2 : Person),
      isSincereInterpreter p1 ∧
      isSincereInterpreter p2 ∧
      ¬interpretationsAgree (interprets p1 t) (interprets p2 t)) →
    ∃ (adj : Adjudicator), canResolve adj t

def magisterium_can_adjudicate_provenance : Provenance :=
  Provenance.tradition "CCC §85, §100"
def magisterium_can_adjudicate_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Catholic; Orthodox accept conciliar adjudication; Protestants reject" }

-- ============================================================================
-- THEOREMS — the logical consequences
-- ============================================================================

/-!
## Theorem 1: Private Judgment Is Insufficient (the main result)

From sincere_disagreement + no_private_adjudicator: private judgment
produces disagreements it cannot resolve. Therefore private judgment is
insufficient as the ULTIMATE rule of faith.

This does NOT say private judgment is useless or bad. It says private
judgment is INCOMPLETE — it needs a supplement (an external adjudicator)
to function as a rule of faith.
-/

/-- **THEOREM: private_judgment_insufficient** — Private judgment is
    insufficient as the ultimate rule of faith: it produces disagreements
    (sincere_disagreement) that it cannot resolve (no_private_adjudicator).

    The argument is EPISTEMIC, not moral. It does not accuse private
    interpreters of bad faith. It identifies a STRUCTURAL deficiency:
    a method that produces unresolvable disputes cannot be the final
    court of appeal.

    Axiom dependencies (kernel-verified):
    - sincere_disagreement (empirical + CCC §85 implied)
    - no_private_adjudicator (CCC §85)

    Source: CCC §85, §100.
    Denominational scope: CATHOLIC + ORTHODOX. -/
theorem private_judgment_insufficient :
    -- There exists a dispute that private judgment cannot resolve
    (∃ (p1 p2 : Person) (t : ApostolicTeaching),
      isSincereInterpreter p1 ∧
      isSincereInterpreter p2 ∧
      ¬interpretationsAgree (interprets p1 t) (interprets p2 t)) ∧
    ¬privateJudgmentHasAdjudicator := by
  exact ⟨sincere_disagreement, no_private_adjudicator⟩

/-!
## Theorem 2: The Magisterium Resolves What Private Judgment Cannot

From the four axioms together: there exists a dispute, private judgment
cannot resolve it, but the Magisterium CAN. This is the positive Catholic
conclusion — not just that private judgment fails, but that Christ
provided a remedy.
-/

/-- **THEOREM: magisterium_resolves_disputes** — The Magisterium can
    resolve doctrinal disputes that private judgment cannot.

    This chains all four axioms:
    1. sincere_disagreement: disputes exist
    2. no_private_adjudicator: private judgment can't resolve them
    3. magisterium_established: Christ established a teaching authority
    4. magisterium_can_adjudicate: that authority CAN resolve disputes

    The conclusion: for the disputed teaching from axiom 1, there exists
    an adjudicator (the Magisterium) that can resolve it.

    Axiom dependencies (kernel-verified):
    - sincere_disagreement
    - no_private_adjudicator
    - magisterium_established
    - magisterium_can_adjudicate

    Source: CCC §85, §100, §889.
    Denominational scope: CATHOLIC. -/
theorem magisterium_resolves_disputes :
    -- (1) Disputes exist and private judgment can't resolve them
    (¬privateJudgmentHasAdjudicator) ∧
    -- (2) The Magisterium is an adjudicator
    magisteriumIsAdjudicator ∧
    -- (3) For the disputed teaching, the Magisterium can resolve it
    (∃ (t : ApostolicTeaching) (adj : Adjudicator), canResolve adj t) := by
  constructor
  · exact no_private_adjudicator
  constructor
  · exact magisterium_established
  · -- Get the disputed teaching from sincere_disagreement
    obtain ⟨p1, p2, t, h_s1, h_s2, h_disagree⟩ := sincere_disagreement
    -- magisterium_can_adjudicate says there's an adjudicator for this teaching
    have h_disputed : ∃ p1 p2 : Person,
      isSincereInterpreter p1 ∧ isSincereInterpreter p2 ∧
      ¬interpretationsAgree (interprets p1 t) (interprets p2 t) :=
      ⟨p1, p2, h_s1, h_s2, h_disagree⟩
    obtain ⟨adj, h_resolve⟩ := magisterium_can_adjudicate t h_disputed
    exact ⟨t, adj, h_resolve⟩

/-!
## Theorem 3: Rational Convergence Fails for Interpretation

This connects to NaturalLaw.lean. The `rational_convergence` theorem says
that two reasoners examining the same precept can both access the truth
(through `rational_accessibility`). But for Scripture interpretation,
convergence FAILS — sincere interpreters do NOT agree.

This means either:
(a) The "premises" are not the same (different canons, hermeneutics,
    presuppositions) — i.e., the inputs to private judgment vary
(b) Interpretation requires more than rational sincerity — it requires
    a shared interpretive framework (which is what the Magisterium provides)

Either way, private judgment alone is insufficient.
-/

/-- **THEOREM: interpretive_convergence_fails** — Sincere interpreters
    of the same teaching do NOT always converge. This contrasts with
    NaturalLaw.lean's rational_convergence, which claims reasoners
    examining the same moral precept SHOULD converge.

    The implication: interpretation of revelation is HARDER than
    apprehension of natural law. Natural law (on the CCC's view) is
    inscribed on every heart (S3). But the correct interpretation of
    Scripture is NOT inscribed on every heart — it requires a guide.

    Axiom dependencies (kernel-verified):
    - sincere_disagreement

    Source: CCC §85; empirical observation.
    Denominational scope: BROADLY FACTUAL. -/
theorem interpretive_convergence_fails :
    ∃ (p1 p2 : Person) (t : ApostolicTeaching),
      isSincereInterpreter p1 ∧
      isSincereInterpreter p2 ∧
      ¬interpretationsAgree (interprets p1 t) (interprets p2 t) :=
  sincere_disagreement

/-!
## Theorem 4: The Perspicuity Defense Requires Hidden Premises

The main Protestant response: Scripture is "perspicuous" — clear enough
on essential matters. Under perspicuity + the assumption that the
Holy Spirit guides readers, private judgment IS sufficient (for essentials).

But this defense requires BOTH premises. Perspicuity alone (without
Spirit-guidance) doesn't solve the convergence problem: clear texts still
get different readings. Spirit-guidance alone (without perspicuity) makes
Scripture unnecessarily obscure.

More importantly: perspicuity requires drawing a principled line between
"essential" and "non-essential" doctrines. Who draws that line? That
question cannot be answered by private judgment without circularity.

NOTE: The Protestant axioms are modeled as HYPOTHESES, not declarations.
-/

/-- **THEOREM: perspicuity_requires_essential_boundary** — The perspicuity
    defense works IF we can distinguish essential from non-essential
    doctrines. But drawing that distinction is itself a doctrinal judgment —
    it requires the very authority perspicuity claims is unnecessary.

    Under perspicuity: essential teachings are clear, so disagreement on
    essentials shouldn't happen. But sincere disagreement EXISTS (axiom 1).
    Therefore either:
    (a) The disputed teaching is "non-essential" — but who decides?
    (b) Perspicuity fails on this teaching — but perspicuity was supposed
        to cover all essentials.

    This shows that perspicuity SHIFTS the problem rather than solving it:
    from "which interpretation is correct?" to "which teachings are essential?"

    Axiom dependencies (kernel-verified):
    - sincere_disagreement

    Source: Westminster Confession 1.7; CCC §85.
    Denominational scope: ANALYSIS OF PROTESTANT POSITION. -/
theorem perspicuity_requires_essential_boundary
    (h_perspicuity : scripturePerspicuous)
    -- Perspicuity: if a teaching is essential, sincere interpreters agree on it
    (h_perspicuity_implies_agreement :
      ∀ (t : ApostolicTeaching),
        scripturePerspicuous →
        -- "essential" is the predicate we need to define
        ∀ (isEssential : ApostolicTeaching → Prop),
        isEssential t →
        ∀ (p1 p2 : Person),
          isSincereInterpreter p1 →
          isSincereInterpreter p2 →
          interpretationsAgree (interprets p1 t) (interprets p2 t)) :
    -- Then: the disputed teaching from sincere_disagreement must be non-essential
    ∃ (t : ApostolicTeaching),
      (∃ (p1 p2 : Person),
        isSincereInterpreter p1 ∧
        isSincereInterpreter p2 ∧
        ¬interpretationsAgree (interprets p1 t) (interprets p2 t)) ∧
      -- For EVERY proposed essential/non-essential boundary, this teaching is
      -- classified as non-essential (otherwise perspicuity would have prevented
      -- the disagreement)
      ∀ (isEssential : ApostolicTeaching → Prop),
        ¬isEssential t := by
  obtain ⟨p1, p2, t, h_s1, h_s2, h_disagree⟩ := sincere_disagreement
  exact ⟨t,
    ⟨⟨p1, p2, h_s1, h_s2, h_disagree⟩,
     fun isEssential h_ess =>
       h_disagree (h_perspicuity_implies_agreement t h_perspicuity isEssential h_ess p1 p2 h_s1 h_s2)⟩⟩

/-!
## Theorem 5: The Combined Argument (Catholic conclusion)

Combining the private judgment argument with RuleOfFaith.lean's
results: the Catholic position is supported by TWO independent
arguments against sola scriptura:

1. **The content argument** (RuleOfFaith.lean): Scripture is materially
   incomplete — some revelation exists only in Tradition.

2. **The interpretation argument** (this file): Even the content that IS
   in Scripture cannot be authoritatively interpreted by private judgment
   alone — you need the Magisterium.

Together: sola scriptura fails on BOTH content and interpretation.
-/

/-- **THEOREM: combined_content_and_interpretation** — The Catholic position
    is supported by two convergent arguments: Scripture is materially
    incomplete (content argument from RuleOfFaith.lean) AND interpretation
    requires magisterial authority (interpretation argument from this file).

    Axiom dependencies (kernel-verified):
    - RuleOfFaith.not_everything_written (§76)
    - sincere_disagreement (§85)
    - no_private_adjudicator (§85)
    - magisterium_established (§85, §100, §889)
    - magisterium_can_adjudicate (§85, §100)

    Source: CCC §74-100.
    Denominational scope: CATHOLIC. -/
theorem combined_content_and_interpretation :
    -- (1) The content argument: Scripture is materially incomplete
    (∃ (t : ApostolicTeaching),
      RuleOfFaith.isRevealed t ∧ ¬RuleOfFaith.inScripture t) ∧
    -- (2) The interpretation argument: private judgment is insufficient
    ((∃ (p1 p2 : Person) (t : ApostolicTeaching),
      isSincereInterpreter p1 ∧
      isSincereInterpreter p2 ∧
      ¬interpretationsAgree (interprets p1 t) (interprets p2 t)) ∧
    ¬privateJudgmentHasAdjudicator) := by
  exact ⟨RuleOfFaith.scripture_materially_incomplete, private_judgment_insufficient⟩

-- ============================================================================
-- DENOMINATIONAL SUMMARY
-- ============================================================================

/-- Denominational scope of each axiom in the private judgment formalization. -/
def privateJudgmentDenominationalScope : List (String × DenominationalTag) :=
  [ ("sincere_disagreement",       sincere_disagreement_tag)
  , ("no_private_adjudicator",     no_private_adjudicator_tag)
  , ("magisterium_established",    magisterium_established_tag)
  , ("magisterium_can_adjudicate", magisterium_can_adjudicate_tag)
  ]

/-!
## Hidden assumptions — summary

1. **Disagreement is genuine, not merely verbal** (sincere_disagreement):
   The argument assumes that at least some doctrinal disagreements are about
   the THING ITSELF, not just about terminology. If all disagreements were
   merely verbal, private judgment would be sufficient once terms are clarified.

2. **An adjudicator must be external to the disputed faculty**
   (no_private_adjudicator): If private judgment is the method producing
   disagreement, private judgment cannot be the method resolving it. This
   is an epistemological principle analogous to "you can't be the judge in
   your own case." A Protestant might contest this by arguing the Holy Spirit
   is an INTERNAL but non-circular adjudicator.

3. **The Magisterium can be reliably identified** (magisterium_established):
   Knowing that a teaching authority exists requires identifying WHICH
   institution it is. This creates a potential regress: you need some
   judgment to identify the Magisterium, which is the very faculty the
   Magisterium is supposed to supplement. Catholics resolve this via
   the convergence of historical evidence (Peter in Rome, apostolic
   succession, conciliar continuity), but the regress worry is real.

4. **Doctrinal disputes are resolvable in principle** (magisterium_can_adjudicate):
   The strongest hidden assumption. Not every question HAS a definitive
   answer (the fate of unbaptized infants remains officially open). The
   axiom claims the Magisterium has the COMPETENCE to resolve, even on
   questions it has not yet addressed.

5. **Interpretation is underdetermined by the text alone** (implicit in the
   argument structure): The argument assumes that the text of Scripture does
   not uniquely determine its own interpretation. If it did, sincere readers
   would converge. The Protestant perspicuity doctrine contests exactly this
   assumption — at least for essential matters.

## Key finding

The decisive problem is the ABSENCE OF A PRINCIPLED ADJUDICATOR, not
epistemic disagreement per se. Disagreement is the evidence; the lack of
a resolver is the structural defect. Private judgment is insufficient not
because it produces wrong answers, but because when it produces CONFLICTING
answers, it provides no principled way to determine which is correct.

The connection to rational convergence is illuminating: NaturalLaw.lean
assumes reasoners converge on the same moral truths. Interpretive divergence
on Scripture shows that this convergence assumption FAILS for interpretation.
Either the premises differ (which means private judgment isn't even operating
on the same inputs) or rational convergence requires a shared framework
(which is what the Magisterium provides).

The Protestant perspicuity defense is internally consistent but SHIFTS the
problem rather than solving it: from "which interpretation is correct?" to
"which teachings are essential?" — and that boundary question cannot be
answered by private judgment without circularity.
-/

end Catlib.Creed.PrivateJudgment
