import Catlib.Foundations
import Catlib.Creed.ScientificInquiry
import Catlib.Creed.Intelligibility
import Catlib.MoralTheology.NaturalLaw

/-!
# Faith and Reason — Complementarity, Not Competition

## The question

Is the CCC's epistemology internally consistent? The Catechism makes
several claims about faith and reason that appear to be in tension:

1. **Reason can know God exists** (§36, Vatican I, Dei Filius 2):
   "God, the first principle and last end of all things, can be known
   with certainty from the created world by the natural light of human
   reason."

2. **Faith accesses truths beyond reason** (§156): "What moves us to
   believe is not the fact that revealed truths appear as true and
   intelligible... but the authority of God himself."

3. **Faith is MORE certain than reason** (§157): "Faith is certain.
   It is more certain than all human knowledge."

4. **Faith seeks understanding** (§158): *fides quaerens intellectum*
   (Anselm) — faith does not replace reason but actively enlists it.

5. **Faith and reason never contradict** (§159, Vatican I, Dei Filius 4):
   "Though faith is above reason, there can never be any real discrepancy
   between faith and reason."

The apparent tension: How can faith be "above" reason (§157) yet never
contradict it (§159)? How can reason know God (§36) yet need faith to
access deeper truths (§156)?

## The CCC's resolution

The CCC resolves this through a COMPLEMENTARITY model. Faith and reason
are not rival sources competing for the same territory. They are ordered
to each other:

- **Reason** establishes the *praeambula fidei* — the preambles of faith
  (God's existence, the soul's immortality, etc.). These truths are
  accessible to reason alone (§36).

- **Faith** extends reason's reach to truths reason cannot access on its
  own: Trinity, Incarnation, Resurrection. These are not irrational —
  they are *supra-rational* (above reason, not against it).

- **Faith perfects reason** in three ways (Fides et Ratio §§43-44, §76):
  1. **Extension**: Faith accesses truths beyond reason's natural reach.
  2. **Correction**: Faith corrects errors that reason falls into
     due to the effects of sin on the intellect.
  3. **Transformation**: Faith changes how reason operates — the
     theologian reasons differently (not worse) than the philosopher.

## Hidden assumptions

1. **Reason is reliable within its domain.** The CCC assumes reason can
   reach genuine truth about God (§36). This is the position of Vatican I
   against fideism. A Barthian would deny this — reason is too corrupted
   by sin to do natural theology.

2. **There is a coherent notion of "above reason" that is not "against
   reason."** The supra-rational / irrational distinction is doing heavy
   work. The CCC assumes mysteries of faith (Trinity, Incarnation) are
   not contradictions but truths that exceed reason's grasp — like a
   2D being encountering a 3D object.

3. **Faith and reason share a common object (truth)** but access it
   differently. This is the *adaequatio* claim from Intelligibility.lean:
   both faith and reason are oriented toward truth, just through different
   pathways.

4. **Sin damages reason but does not destroy it.** The CCC's position
   (against Luther's stronger claim about total depravity of the
   intellect) is that sin WEAKENS reason but does not make natural
   theology impossible (§37).

## Modeling choices

1. **Faith and reason as epistemic faculties.** We model them as producing
   different kinds of knowledge — reason produces `reasonKnows` and faith
   produces `faithKnows`. This is a simplification; the CCC treats them as
   interrelated capacities, not cleanly separated faculties.

2. **The three perfections as separate predicates.** We model extension,
   correction, and transformation as distinct predicates rather than a
   single "perfects" relation. This lets us track which perfection is
   load-bearing in each theorem.

3. **The Barthian counter as a denied axiom.** We formalize Barth's
   position as the negation of reason's reliability in reaching God.
   This is a simplification of Barth's nuanced position (he doesn't
   deny reason entirely, but denies natural theology).

## Denominational scope

The core claims (§36, §156, §159) are ECUMENICAL in substance — most
Christian traditions accept that faith and reason are compatible. The
main dissenter is the Barthian tradition, which rejects natural theology
(§36). The Catholic distinctive is the STRENGTH of the claim for reason:
Vatican I defines it as de fide that reason CAN know God from creation.
-/

set_option autoImplicit false

namespace Catlib.Creed.FaithAndReason

open Catlib
open Catlib.Creed
open Catlib.Creed.ScientificInquiry
open Catlib.Creed.Intelligibility
open Catlib.MoralTheology

-- ============================================================================
-- § 1. Core Predicates
-- ============================================================================

/-- A truth — something that can be known by faith, reason, or both.

    MODELING CHOICE: We use a single opaque type for all truths. The CCC
    distinguishes natural truths (accessible to reason) from supernatural
    truths (accessible only through revelation), but both are genuine truths
    about reality. The distinction is in HOW they are known, not in their
    ontological status. -/
opaque Truth : Type

/-- Whether reason can know a given truth without revelation.
    §36: reason can know God's existence from creation.
    §37: but this knowledge is difficult, mixed with error, and often
    incomplete — hence the "moral necessity" of revelation even for
    truths reason could in principle reach. -/
opaque reasonKnows : Truth → Prop

/-- Whether faith (assent to divine revelation) knows a given truth.
    §156: faith is motivated by the authority of God who reveals,
    not by the intrinsic evidence of the truths revealed. -/
opaque faithKnows : Truth → Prop

/-- Whether a truth is supra-rational — above reason's natural capacity
    but not contrary to reason.

    Examples: the Trinity, the Incarnation, the Eucharist.
    These are not irrational (self-contradictory) but exceed what
    reason alone can derive.

    HIDDEN ASSUMPTION: There is a coherent category of truths that are
    "above" reason without being "against" it. This is the CCC's key
    epistemological distinction. A positivist would collapse this into
    "not knowable by reason = not meaningful." -/
opaque supraRational : Truth → Prop

/-- Whether two truths are contradictory — they cannot both be true.

    MODELING CHOICE: We model contradiction as a symmetric relation on truths.
    If `contradicts t1 t2`, then knowing `t1` rules out knowing `t2`.
    This lets us express the §159 claim that faith and reason cannot
    reach contradictory conclusions. -/
opaque contradicts : Truth → Truth → Prop

/-- Whether a truth is a *praeambulum fidei* — a preamble of faith,
    knowable by reason alone.

    §35: "Man's faculties make him capable of coming to a knowledge of
    the existence of a personal God."
    §36: God's existence can be known "with certainty from the created
    world by the natural light of human reason."

    Examples: God's existence, the soul's immortality, the natural law.
    These truths are ALSO confirmed by faith (revelation teaches them too)
    but do not REQUIRE faith for their knowledge. -/
opaque praeambulaFidei : Truth → Prop

/-- Whether sin has damaged a person's capacity for reasoning about God
    and moral truths.

    §37: "In the present condition of the human race" there are "many
    obstacles which prevent reason from the effective and fruitful use
    of this inborn faculty." These obstacles include "the influence of
    the senses," "the imagination," and "evil desires born of original sin."

    HIDDEN ASSUMPTION: Sin damages reason but does not destroy it. This is
    the CCC's position against both (a) Pelagianism (sin doesn't damage
    reason at all) and (b) radical Reformed theology (sin totally corrupts
    reason, making natural theology impossible). -/
opaque sinDamagesReason : Person → Prop

/-- Whether faith extends reason's reach to truths reason cannot
    access on its own.

    Fides et Ratio §43: faith "broadens the horizons of reason." -/
opaque faithExtends : Prop

/-- Whether faith corrects errors that reason falls into.

    §37: reason encounters "many obstacles" due to sin.
    Fides et Ratio §76: revelation provides a "purifying function"
    for reason, correcting errors arising from sin's effects on
    the intellect. -/
opaque faithCorrects : Prop

/-- Whether faith transforms how reason operates — not replacing
    reason but changing its mode of operation.

    Fides et Ratio §76: "faith frees reason from presumption."
    The theologian reasons differently from the philosopher — not
    by abandoning reason but by reasoning within a richer framework.

    MODELING CHOICE: This is our way of formalizing a subtle claim.
    The CCC doesn't give a precise definition of "transformation" of
    reason. We model it as a distinct predicate to track when this
    specific perfection matters. -/
opaque faithTransforms : Prop

/-- Whether faith perfects reason — the conjunction of extension,
    correction, and transformation.

    Fides et Ratio §43-44, §76: faith "purifies," "broadens," and
    "elevates" reason. The three modes of perfection are distinguished
    in the encyclical but the CCC treats them as a unified claim. -/
def faithPerfectsReason : Prop :=
  faithExtends ∧ faithCorrects ∧ faithTransforms

-- ============================================================================
-- § 2. Axioms
-- ============================================================================

/-- AXIOM (§36, Vatican I, Dei Filius 2): Reason can know God exists.

    "God, the first principle and last end of all things, can be known
    with certainty from the created world by the natural light of human
    reason." (CCC §36, citing Vatican I, Dei Filius 2, can. 2 § 1)

    This is the foundation of natural theology: God's existence is a
    *praeambulum fidei*, knowable without revelation. Vatican I defined
    this against fideism (faith alone, no reason) and traditionalism
    (knowledge only through tradition, not individual reason).

    Provenance: [Council] Vatican I, Dei Filius 2; [Definition] CCC §36.
    Denominational scope: ECUMENICAL (Barth dissents). -/
axiom reason_can_know_god (t : Truth) :
  praeambulaFidei t →
  reasonKnows t

/-- AXIOM (§156): Faith accesses truths beyond reason.

    "What moves us to believe is not the fact that revealed truths appear
    as true and intelligible in the light of our natural reason: we
    believe 'because of the authority of God himself who reveals them,
    who can neither deceive nor be deceived.'" (CCC §156, Vatican I,
    Dei Filius 3)

    Some truths (Trinity, Incarnation) are accessible ONLY through
    faith. Reason alone cannot derive them. They are supra-rational,
    not irrational.

    Provenance: [Council] Vatican I, Dei Filius 3; [Definition] CCC §156.
    Denominational scope: ECUMENICAL. -/
axiom faith_accesses_beyond_reason (t : Truth) :
  supraRational t →
  faithKnows t ∧ ¬ reasonKnows t

/-- AXIOM (§159, Vatican I, Dei Filius 4): Faith and reason never contradict.

    "Though faith is above reason, there can never be any real discrepancy
    between faith and reason. Since the same God who reveals mysteries and
    infuses faith has bestowed the light of reason on the human mind, God
    cannot deny himself, nor can truth ever contradict truth." (CCC §159,
    citing Vatican I, Dei Filius 4)

    If faith knows a truth, reason cannot know the negation of that truth.
    An apparent contradiction indicates either a failure of reasoning or a
    misunderstanding of the faith.

    Provenance: [Council] Vatican I, Dei Filius 4; [Definition] CCC §159.
    Denominational scope: ECUMENICAL. -/
axiom faith_reason_no_contradiction (t1 t2 : Truth) :
  faithKnows t1 → reasonKnows t2 → ¬ contradicts t1 t2

/-- AXIOM (Fides et Ratio §43): Faith extends reason's reach.

    Faith gives access to truths that reason alone could never reach:
    Trinity, Incarnation, Resurrection, the inner life of God.
    This is extension — the simplest and least controversial of
    the three perfections.

    Provenance: [Encyclical] Fides et Ratio §43; [Definition] CCC §156.
    Denominational scope: ECUMENICAL. -/
axiom faith_extends_reason :
  (∃ (t : Truth), supraRational t ∧ faithKnows t) →
  faithExtends

/-- AXIOM (Fides et Ratio §76, CCC §37): Faith corrects reason's errors.

    §37 says reason encounters "many obstacles" in knowing God — the
    influence of the senses, the imagination, and "evil desires born of
    original sin." Faith provides a corrective: revelation teaches truths
    (including natural truths like God's existence) that reason COULD reach
    but often fails to reach due to sin's effects.

    This is why revelation is "morally necessary" (§38) even for truths
    that are in principle accessible to reason: reason is reliable but
    damaged, and faith repairs the damage.

    Provenance: [Encyclical] Fides et Ratio §76; [Definition] CCC §37-38.
    Denominational scope: ECUMENICAL (in substance; the degree of damage
    from sin is debated). -/
axiom faith_corrects_reason :
  (∃ (p : Person), sinDamagesReason p) →
  faithCorrects

/-- AXIOM (Fides et Ratio §76, CCC §158): Faith transforms how reason
    operates.

    "Faith seeks understanding" (*fides quaerens intellectum*, Anselm).
    The believer does not abandon reason but uses it WITHIN the framework
    of faith. Theology IS faith using reason — not faith replacing reason.

    This is transformation: reason is not abandoned but elevated. The
    theologian's reasoning is qualitatively different from the philosopher's
    — not because it uses less logic, but because it starts from a richer
    set of premises (including revealed truths).

    Provenance: [Encyclical] Fides et Ratio §76; [Definition] CCC §158;
    [Tradition] Anselm, Proslogion.
    Denominational scope: ECUMENICAL. -/
axiom faith_transforms_reason :
  faithExtends → faithCorrects → faithTransforms

-- ============================================================================
-- § 3. Connecting Axiom: Preambles of Faith and ScientificInquiry
-- ============================================================================

/-- AXIOM (§36, §299): God's knowability by reason connects to
    reason's general reliability (ScientificInquiry.lean).

    If humans can understand the world (Proposition B from ScientificInquiry),
    and being is intelligible (from Intelligibility.lean), then the truths
    about God that are accessible to reason (*praeambula fidei*) are
    genuinely within reason's reach.

    This bridges ScientificInquiry's epistemology to faith-and-reason:
    the same rational capacity that makes science possible also makes
    natural theology possible.

    Provenance: [Definition] CCC §36 + §299; bridges ScientificInquiry.lean
    and Intelligibility.lean.
    Denominational scope: ECUMENICAL (Barth dissents on the application
    to God-knowledge). -/
axiom reason_reliability_grounds_praeambula :
  humansCanUnderstandIt →
  beingIsIntelligible →
  ∀ (t : Truth), praeambulaFidei t → reasonKnows t

-- ============================================================================
-- § 4. Theorems
-- ============================================================================

/-- THEOREM: The *praeambula fidei* are genuinely knowable by reason.

    Derivation:
    1. Humans can understand the world (ScientificInquiry's Proposition B)
    2. Being is intelligible (Intelligibility.lean)
    3. Therefore reason can reach truths classified as *praeambula fidei*

    This connects the deep epistemological infrastructure (ScientificInquiry,
    Intelligibility) to the faith-and-reason question. It's not circular:
    the GROUND for reason's reliability (imago dei + Logos) is different from
    the APPLICATION (knowing God from creation). -/
theorem praeambula_fidei_knowable (t : Truth) (h : praeambulaFidei t) :
    reasonKnows t := by
  have h_understand := humans_can_understand_the_world
  have h_intelligible := being_is_intelligible
  exact reason_reliability_grounds_praeambula h_understand h_intelligible t h

/-- THEOREM: Supra-rational truths are exclusively accessed by faith.

    From faith_accesses_beyond_reason: if a truth is supra-rational,
    faith knows it AND reason does not. This is the content of §156:
    the motive of faith is God's authority, not reason's evidence.

    Uses: faith_accesses_beyond_reason. -/
theorem suprarational_exclusive (t : Truth) (h : supraRational t) :
    faithKnows t ∧ ¬ reasonKnows t :=
  faith_accesses_beyond_reason t h

/-- THEOREM: Faith perfects reason in all three ways.

    Derivation:
    1. Supra-rational truths exist and faith knows them → faithExtends
    2. Sin damages reason → faithCorrects
    3. Extension + correction → faithTransforms
    4. All three together = faithPerfectsReason

    This requires two existential witnesses: a supra-rational truth and
    a person whose reason is damaged by sin. Both are CCC commitments:
    the Trinity is supra-rational (§237), and original sin damages all
    humans (§37, §405).

    Uses: faith_extends_reason, faith_corrects_reason, faith_transforms_reason. -/
theorem faith_perfects_reason_triple
    (t : Truth) (p : Person)
    (h_supra : supraRational t)
    (h_sin : sinDamagesReason p) :
    faithPerfectsReason := by
  -- Step 1: There exists a supra-rational truth known by faith → extension
  have h_faith := (faith_accesses_beyond_reason t h_supra).1
  have h_extends := faith_extends_reason ⟨t, h_supra, h_faith⟩
  -- Step 2: There exists a person with sin-damaged reason → correction
  have h_corrects := faith_corrects_reason ⟨p, h_sin⟩
  -- Step 3: Extension + correction → transformation
  have h_transforms := faith_transforms_reason h_extends h_corrects
  -- Step 4: All three = perfects
  exact ⟨h_extends, h_corrects, h_transforms⟩

/-- THEOREM: Supra-rational truths cannot contradict anything reason knows.

    If a truth is supra-rational, faith knows it (faith_accesses_beyond_reason),
    and for anything reason knows, it cannot contradict what faith knows
    (faith_reason_no_contradiction). Therefore nothing reason discovers can
    contradict supra-rational truths — not because reason is suppressed,
    but because faith and reason share a common source (§159).

    Uses: faith_accesses_beyond_reason, faith_reason_no_contradiction. -/
theorem suprarational_compatible_with_reason
    (t1 t2 : Truth) (h_supra : supraRational t1) (h_reason : reasonKnows t2) :
    ¬ contradicts t1 t2 := by
  have h_faith := (faith_accesses_beyond_reason t1 h_supra).1
  exact faith_reason_no_contradiction t1 t2 h_faith h_reason

/-- THEOREM: The epistemological package — reason is reliable (ScientificInquiry),
    being is intelligible (Intelligibility), and faith perfects reason.

    This shows the CCC's epistemology is LAYERED, not contradictory:
    - Layer 1: Reason is reliable (grounded in imago dei + Logos)
    - Layer 2: Being is intelligible (grounded in Logos + realism)
    - Layer 3: Faith extends reason into supra-rational territory
    - Layer 4: Faith corrects reason where sin damages it
    - Layer 5: Faith transforms reason's mode of operation

    Each layer BUILDS ON the previous ones. Faith doesn't replace
    reason — it presupposes and perfects it. -/
theorem epistemological_package
    (t : Truth) (p : Person)
    (h_supra : supraRational t)
    (h_sin : sinDamagesReason p) :
    humansCanUnderstandIt ∧ beingIsIntelligible ∧ faithPerfectsReason := by
  have h_understand := humans_can_understand_the_world
  have h_intelligible := being_is_intelligible
  have h_perfects := faith_perfects_reason_triple t p h_supra h_sin
  exact ⟨h_understand, h_intelligible, h_perfects⟩

-- ============================================================================
-- § 5. The Barthian Counter
-- ============================================================================

/-!
### The Barthian objection

Karl Barth (Church Dogmatics I/1, §§1-2) denies natural theology.
His position: reason is so corrupted by sin that it CANNOT reliably
know God from creation. All knowledge of God comes through God's
self-revelation in Christ alone.

Barth doesn't deny reason works for science or everyday life. He denies
it can reach GOD. The "natural light of human reason" (§36) is, for
Barth, a Catholic illusion inherited from Aristotelian philosophy.

This means Barth accepts our ScientificInquiry results (the world is
logical, humans can understand it) but REJECTS the application to
God-knowledge. He would say: reason can study chemistry; it cannot
study God.

In formal terms: Barth denies `reason_can_know_god` — the claim that
any truth about God is a *praeambulum fidei* knowable by reason alone.

The CCC's answer (§36, Vatican I) is that Barth's position undermines
faith itself: if reason is THAT damaged, how can it even RECEIVE
revelation? Faith requires a rational subject; a subject too broken
for natural theology may be too broken for supernatural theology.
-/

/-- The Barthian position: reason cannot know God from creation.
    All *praeambula fidei* are denied — even God's existence requires
    revelation.

    This is the negation of `reason_can_know_god`. Barth would accept
    `faithKnows t` for all truths about God but deny `reasonKnows t`
    for any of them.

    Source: Barth, Church Dogmatics I/1, §§1-2.
    This is NOT a CCC position — it is the major dissenting view.
    We formalize it to show what the CCC's axioms rule out. -/
opaque barthDeniesNaturalTheology : Prop

/-- AXIOM: The Barthian position contradicts the CCC.

    If Barth is right (reason cannot know God), then for any truth
    classified as a *praeambulum fidei*, reason does NOT know it.
    This directly contradicts `reason_can_know_god`.

    We formalize this as a conditional: IF barthDeniesNaturalTheology,
    THEN the praeambula are not known by reason.

    Provenance: [Dissent] Barth, Church Dogmatics I/1; formalizes the
    point of contradiction with [Council] Vatican I, Dei Filius 2.
    Denominational scope: BARTHIAN ONLY. -/
axiom barth_rejects_praeambula :
  barthDeniesNaturalTheology →
  ∀ (t : Truth), praeambulaFidei t → ¬ reasonKnows t

/-- THEOREM: The Barthian position is formally incompatible with
    the CCC's axiom set.

    If a *praeambulum fidei* exists, then:
    - The CCC says reason can know it (`reason_can_know_god`)
    - Barth says reason cannot (`barth_rejects_praeambula`)
    These are contradictory — both cannot hold.

    This is not a refutation of Barth (his premises differ from
    the CCC's). It is a proof that the CCC and Barth disagree on
    something real, not merely verbal. -/
theorem barth_incompatible_with_ccc
    (t : Truth)
    (h_prae : praeambulaFidei t)
    (h_barth : barthDeniesNaturalTheology) :
    False := by
  have h_yes := reason_can_know_god t h_prae
  have h_no := barth_rejects_praeambula h_barth t h_prae
  exact h_no h_yes

-- ============================================================================
-- § 6. Bridge Theorems to Existing Files
-- ============================================================================

/-- THEOREM: ScientificInquiry's "humans can understand the world"
    undergirds natural theology.

    The same rational capacity that makes science possible (Proposition B
    from ScientificInquiry) also makes natural theology possible. If
    human reason can grasp the world's order, it can grasp the Author
    of that order — you can read the signature because you can read the book.

    Uses: humans_can_understand_the_world (ScientificInquiry), being_is_intelligible
    (Intelligibility), reason_reliability_grounds_praeambula. -/
theorem scientific_inquiry_supports_natural_theology (t : Truth) (h : praeambulaFidei t) :
    humansCanUnderstandIt ∧ reasonKnows t := by
  have h_understand := humans_can_understand_the_world
  have h_knows := praeambula_fidei_knowable t h
  exact ⟨h_understand, h_knows⟩

/-- THEOREM: Intelligibility.lean's adequation principle underlies
    the faith-reason relationship.

    The *adaequatio rei et intellectus* (intellect is adequate to reality)
    is what makes BOTH natural theology and reception of revelation possible.
    Without adequation, neither reason nor faith-informed-reason could
    reach truth.

    Uses: realism_alone_gives_adequation (Intelligibility.lean). -/
theorem adequation_underlies_faith_and_reason :
    intellectAdequateToReality := by
  exact realism_alone_gives_adequation

/-- THEOREM: NaturalLaw's moral realism is an instance of faith-and-reason
    complementarity.

    Natural moral knowledge (§1954-1957) is one of the *praeambula fidei*:
    reason can reach moral truth without revelation (S6, moral realism).
    But revelation ALSO teaches the moral law (the Decalogue), and faith
    CORRECTS moral reasoning where sin distorts it (§37).

    This is faith and reason operating on the SAME DOMAIN (moral truth)
    through different channels — exactly the complementarity the CCC claims.

    Uses: s6_moral_realism (Axioms.lean), being_is_intelligible (Intelligibility). -/
theorem moral_knowledge_exhibits_complementarity
    (mp : MoralProposition) (h : moralTruthValue mp) :
    accessibleToReason mp ∧ beingIsIntelligible := by
  have h_moral := s6_moral_realism mp h
  have h_being := being_is_intelligible
  exact ⟨h_moral, h_being⟩

-- ============================================================================
-- § 7. What Breaks Without Each Axiom
-- ============================================================================

/-!
### Failure modes

| Drop this axiom | You get | Problem |
|-----------------|---------|---------|
| reason_can_know_god | Fideism | Faith is the ONLY path to God — reason is useless for theology. This is Barth's position and is condemned by Vatican I. |
| faith_accesses_beyond_reason | Rationalism | Reason can reach ALL truths, including Trinity, Incarnation. No mystery, no revelation needed. The Enlightenment position. |
| faith_reason_no_contradiction | Double truth | Faith and reason can reach contradictory conclusions and both be "true" in their own domain. The Latin Averroist position, condemned in 1277. |
| faith_extends_reason | Deism | God exists (reason knows this) but has revealed nothing beyond what reason can reach. No Trinity, no Incarnation, no supernatural order. |
| faith_corrects_reason | Pelagianism of the intellect | Reason is undamaged by sin and needs no help. §37's "obstacles" are ignored. |
| faith_transforms_reason | Extrinsicism | Faith and reason coexist but don't interact. Faith adds information but doesn't change how we think. The "two-story" model. |

### The key finding

The CCC's epistemology is INTERNALLY CONSISTENT because it's layered:

1. Reason is genuinely reliable (§36) — grounded in imago dei and Logos
   (ScientificInquiry, Intelligibility).
2. Reason is genuinely limited (§156) — some truths exceed its grasp.
3. Reason is genuinely damaged (§37) — sin introduces errors.
4. Faith addresses all three: confirms reason's reliability (§159),
   accesses truths beyond reason (§156), and corrects sin's damage (§37).

There is no contradiction because faith and reason are not COMPETING
for the same territory. They are LAYERED: reason provides the foundation
(praeambula fidei), faith builds on it (revealed truths), and faith also
repairs it where damaged (correction of errors).

The one genuine TENSION is §157: "Faith is more certain than all human
knowledge." If faith is grounded in God's authority (which cannot err)
and reason is grounded in human capacity (which can err), then faith's
certainty exceeds reason's. This doesn't mean faith contradicts reason —
it means faith is a MORE reliable source in its own domain. A telescope
is more reliable than the naked eye, but both see truly.
-/

-- ============================================================================
-- § 8. Denominational Scope
-- ============================================================================

/-- All axioms and theorems in this file are ECUMENICAL in substance.

    The faith-reason complementarity is accepted by Catholics, Orthodox,
    and most Protestants. The major dissenters:
    - Barthians: reject natural theology (§36)
    - Fideists: reject reason's capacity entirely
    - Rationalists: reject faith's necessity

    The Catholic DISTINCTIVE is the STRENGTH of the claim for reason:
    Vatican I defines it as *de fide* that reason CAN know God from
    creation. Most Protestant traditions accept this in practice but
    don't make it a dogmatic commitment. -/
def faith_and_reason_denominational_scope : DenominationalTag := ecumenical

/-!
## Summary

### Source claims formalized
- CCC §36 (Vatican I, Dei Filius 2): reason can know God from creation
- CCC §156 (Vatican I, Dei Filius 3): faith accesses truths beyond reason
- CCC §159 (Vatican I, Dei Filius 4): faith and reason never contradict
- CCC §35, §37-38: reason is reliable but damaged by sin
- Fides et Ratio §43-44, §76: faith perfects reason (extension, correction,
  transformation)
- Barth, Church Dogmatics I/1: the major counter-position

### Axioms (8)
1. `reason_can_know_god` (§36, Vatican I) — praeambula fidei are knowable
2. `faith_accesses_beyond_reason` (§156, Vatican I) — supra-rational truths
   are faith-exclusive
3. `faith_reason_no_contradiction` (§159, Vatican I) — faith and reason cannot
   reach contradictory conclusions
4. `faith_extends_reason` (Fides et Ratio §43) — faith broadens reason
5. `faith_corrects_reason` (Fides et Ratio §76, §37) — faith repairs sin-damage
6. `faith_transforms_reason` (Fides et Ratio §76, §158) — faith changes
   reason's mode
7. `reason_reliability_grounds_praeambula` (§36, §299) — bridges to
   ScientificInquiry and Intelligibility
8. `barth_rejects_praeambula` (Barth, CD I/1) — the Barthian counter

### Theorems (9)
1. `praeambula_fidei_knowable` — reason reaches praeambula (from ScientificInquiry + Intelligibility)
2. `suprarational_exclusive` — supra-rational truths are faith-only
3. `suprarational_compatible_with_reason` — supra-rational truths cannot contradict reason
4. `faith_perfects_reason_triple` — all three perfections derived
5. `epistemological_package` — the full layered epistemology
6. `barth_incompatible_with_ccc` — Barthian position contradicts the CCC
7. `scientific_inquiry_supports_natural_theology` — bridge to ScientificInquiry
8. `adequation_underlies_faith_and_reason` — bridge to Intelligibility
9. `moral_knowledge_exhibits_complementarity` — bridge to NaturalLaw/moral realism

### Key FINDING

**Answer to the main question: is the CCC's epistemology internally consistent?**

**Yes — because it's LAYERED, not competitive.**

The apparent tension between "reason can know God" (§36) and "faith is
above reason" (§157) dissolves once you see the layered structure:

1. Reason is reliable within its domain (praeambula fidei)
2. Faith extends beyond that domain (supra-rational truths)
3. Faith also repairs reason where sin damages it (correction)
4. Faith changes how reason operates (transformation)
5. They never contradict because they share a common source (God, the
   source of both natural reason and revelation — §159)

The GROUND for their compatibility is §159's principle: "the same God
who reveals mysteries and infuses faith has bestowed the light of reason
on the human mind." Faith and reason cannot contradict because they come
from the same source — exactly the unified-source argument from
Intelligibility.lean.

### Cross-file connections
- ScientificInquiry.lean: `humansCanUnderstandIt`, `humans_can_understand_the_world`
  (reason's reliability grounds natural theology)
- Intelligibility.lean: `beingIsIntelligible`, `intellectAdequateToReality`,
  `being_is_intelligible`, `realism_alone_gives_adequation`
  (the adequation principle underlies both faith and reason)
- NaturalLaw.lean: `moral_realism_from_s6` via S6 (moral knowledge as
  instance of faith-reason complementarity)
- Axioms.lean: `s6_moral_realism` (moral realism as a praeambulum fidei)

### Hidden assumptions
1. Reason is reliable within its domain (against radical skepticism) — grounded
   in ScientificInquiry and Intelligibility
2. There is a coherent "supra-rational" category distinct from "irrational" —
   the CCC's key epistemological innovation
3. Sin damages reason but does not destroy it — against both Pelagianism and
   radical Reformed anthropology
4. Faith and reason share a common object (truth) accessed differently —
   the adaequatio claim from Intelligibility.lean

### Modeling choices
1. Faith and reason as producing different kinds of knowledge (reasonKnows vs.
   faithKnows) — simplified from the CCC's more interrelated account
2. Three perfections as separate predicates — allows tracking which perfection
   is load-bearing in each theorem
3. Barthian counter as a denied axiom — simplified from Barth's nuanced position
-/

end Catlib.Creed.FaithAndReason
