import Catlib.Foundations
import Catlib.Creed.DivineAttributes
import Catlib.Creed.Intelligibility

/-!
# CCC §40-43, Aquinas ST I q.13: The Analogy of Being

## The Catechism's claims

§40: "Since our knowledge of God is limited, our language about God is
equally so. We can name God only by taking creatures as our starting point."

§41: "All creatures bear a certain resemblance to God... 'For from the
greatness and beauty of created things comes a corresponding perception
of their Creator.'" (Wis 13:5)

§42: "Our human words always fall short of the mystery of God."

§43: "In speaking about God like this, our language is using human modes
of expression; nevertheless it really does attain to God himself, though
unable to express him in his infinite simplicity."

## The question

When we say "God is good" and "this person is good," does "good" mean:
1. EXACTLY the same thing (UNIVOCAL) — identity of meaning
2. COMPLETELY different things (EQUIVOCAL) — no shared meaning
3. A RELATED but different meaning (ANALOGICAL) — genuine but
   limited truth content

Aquinas argues for (3): analogy (ST I q.13 a.5-6).

## What we formalize

### 1. Three modes of predication (ST I q.13 a.5)
Univocal, equivocal, and analogical predication as an exhaustive
classification. Every term applied to both God and creatures falls
into one of these three modes.

### 2. God-talk is analogical (CCC §40-43; ST I q.13 a.5)
Neither univocal (§42: "Our human words always fall short") nor
equivocal (§43: "it really does attain to God himself"). The CCC
explicitly occupies the middle position.

### 3. The methodological challenge
Every axiom in catlib that predicates something of God (`godIsLove`,
`godCanBringAbout`, `knownToGod`, etc.) uses predicates analogically.
This means our formal axioms have genuine but LIMITED truth content.
Formal identity (Lean's `=`) does not capture analogical identity.

### 4. Systematic uncertainty
If analogy is the mode of all God-talk, then every axiom about God
carries an implicit qualifier: "in an analogical sense." Our formalization
cannot capture this qualifier — Lean predicates are either true or false,
not "true analogically." This is a methodological limit of formal theology.

### 5. The Barthian challenge
Karl Barth rejected the analogia entis as "the invention of the
Antichrist" (*KD* I/1, p. viii). For Barth, any analogy from creatures
to God implies human reason can reach God — but God is known ONLY
through God's self-revelation. If Barth is right, catlib's methodology
(applying predicates from creaturely experience to God) is fundamentally
misconceived.

## Prediction

This formalization should reveal that the ENTIRE catlib project implicitly
assumes analogy works — that formal predicates applied to God have
genuine (if limited) truth content. This is the deepest methodological
assumption in the project, deeper even than any individual axiom.

## Findings

- **Prediction confirmed**: Analogy is the foundational methodological
  assumption. Every axiom about God (`godIsLove`, `omnipotence`,
  `omniscience`, etc.) implicitly assumes analogical predication carries
  genuine truth content. If analogy fails (equivocity), every axiom
  about God is potentially meaningless. If analogy is unnecessary
  (univocity), divine simplicity is violated.

- **Connection to divine simplicity**: DivineAttributes.lean showed
  that simplicity forces us to decompose God into separate predicates
  while the doctrine says they are one. Analogy explains WHY this
  decomposition is permitted: because analogical predication gives
  genuine (if limited) access to the divine reality. Without analogy,
  simplicity would make God entirely unknowable (equivocity). With
  univocity, simplicity would be incoherent (how can "good" mean
  exactly the same thing for creatures and for a simple God?).

- **Connection to intelligibility**: Intelligibility.lean showed that
  being is knowable because it comes from rational Logos. Analogy is
  the MECHANISM by which this knowability extends to God: creatures
  resemble their Creator (§41), and this resemblance grounds our
  ability to speak truly (if partially) about God.

- **The Barthian challenge is real**: Barth's rejection of analogia
  entis is not a misunderstanding — it is a denial that creaturely
  reason has any reliable path to God. If Barth is right, catlib's
  entire methodology (formal axioms about God using creaturely
  predicates) collapses. The CCC explicitly disagrees with Barth
  (§36: God "can be known with certainty from the created world"),
  but the disagreement is an axiom, not a proof.

- **THE KEY FINDING**: Analogy introduces SYSTEMATIC UNCERTAINTY into
  the entire formalization. Every axiom about God is true-analogically,
  not true-univocally. Lean cannot represent this distinction. Therefore,
  catlib's formal system is stronger than what the CCC claims to know:
  our `axiom godIsLove` says "God is love" univocally (a Lean Prop is
  true or false), but the CCC says "God is love" analogically (§42:
  "always fall short"). The gap between formal and analogical truth
  is a permanent methodological limit.

## Hidden assumptions

1. **Analogy carries genuine truth content.** The CCC asserts this
   (§43: "it really does attain to God himself") but never argues for
   it. The argument is Aquinas's (ST I q.13 a.5-6): creatures are
   effects of God, and effects resemble their cause, so creaturely
   perfections say something true about the cause.

2. **The three modes are exhaustive.** If there were a fourth mode
   of predication, the analogical argument might not apply to all
   God-talk. Aquinas treats the three as exhaustive (q.13 a.5).

3. **Creatures genuinely resemble God.** §41 cites Wisdom 13:5.
   Without this resemblance, analogy has no ground. This is the
   *vestigia Dei* tradition.

4. **Catlib implicitly assumes analogy works.** Every axiom about
   God uses predicates analogically. This is never stated as an
   axiom but is presupposed by the entire project.

## Modeling choices

1. **We model predication modes as an inductive type.** This is a
   classification, not a substantive claim.

2. **We model "genuine truth content" as an opaque predicate.** The
   CCC says analogy "really does attain to God himself" (§43) but
   doesn't define what "attain" means formally.

3. **We model the Barthian challenge as a rejection of the analogy
   axiom.** This is a simplification — Barth's position is more
   nuanced (he later allowed an *analogia fidei*, analogy of faith,
   as opposed to analogia entis, analogy of being).

4. **We axiomatize analogy as a PROJECT-LEVEL assumption** rather
   than a local claim. This reflects the finding: analogy is not
   one axiom among many, it is the precondition for all axioms
   about God.

## Denominational scope

- **Analogy of being**: CATHOLIC distinctive (developed by Aquinas,
  affirmed by the Fourth Lateran Council §806: "between Creator and
  creature no similitude can be expressed without implying an even
  greater dissimilitude"). Orthodox accept a version. Many Protestants
  accept implicitly. Barth explicitly rejects.

- **God-talk as analogical** (§40-43): BROADLY ECUMENICAL in practice —
  virtually all traditions agree our language about God is limited.
  The specific Thomistic framework is Catholic.
-/

set_option autoImplicit false

namespace Catlib.Creed.AnalogyOfBeing

open Catlib
open Catlib.Creed
open Catlib.Creed.DivineAttributes
open Catlib.Creed.Intelligibility

-- ============================================================================
-- § 1. Core Predicates and Types
-- ============================================================================

/-- The three modes of predication: how a term relates when applied
    to two different subjects.

    Source: [Aquinas] ST I q.13 a.5. Aquinas argues that these three
    exhaust the possibilities for how a term can be shared between
    God and creatures.

    MODELING CHOICE: We model this as an inductive type because it is
    a classification (exhaustive by Aquinas's argument). -/
inductive PredicationMode where
  /-- UNIVOCAL: the term means exactly the same thing in both uses.
      Example: "animal" applied to ox and cow.
      Source: [Aquinas] ST I q.13 a.5. -/
  | univocal
  /-- EQUIVOCAL: the term means completely different things in both uses.
      Example: "bank" (riverbank vs. financial institution).
      Source: [Aquinas] ST I q.13 a.5. -/
  | equivocal
  /-- ANALOGICAL: the term means a related but non-identical thing.
      Example: "healthy" applied to medicine and to a body — medicine
      is healthy in a different but related sense (it CAUSES health).
      Source: [Aquinas] ST I q.13 a.5-6. -/
  | analogical

/-- A theological predicate — a term applied to God.

    Every axiom about God in catlib uses theological predicates:
    `godIsLove`, `godCanBringAbout`, `knownToGod`, `godCreatesThruWisdom`,
    `identicalWithEssence`, etc. Each of these predicates is used
    ANALOGICALLY: when we say "God is love," "love" does not mean
    exactly what it means for creatures (univocal) nor something
    totally different (equivocal), but something genuinely related
    (analogical).

    STRUCTURAL OPACITY: We leave this opaque because the specific
    content of each theological predicate is given by the axioms
    themselves (in other files). What this file tracks is the MODE
    of predication, not the content. -/
opaque TheologicalPredicate : Type

/-- The mode of predication for a given theological predicate when
    applied to God vs. creatures.

    Source: [Aquinas] ST I q.13 a.5. Every predicate shared between
    God and creatures has a mode of predication.

    MODELING CHOICE: We model this as a function from predicates to
    modes because each predicate has exactly one mode. -/
instance : Inhabited PredicationMode := ⟨PredicationMode.analogical⟩

opaque predicationMode : TheologicalPredicate → PredicationMode

/-- Whether a predicate, applied to God, carries genuine truth content
    — i.e., it says something TRUE about God, not merely something
    about our mental categories.

    Source: [CCC] §43: "our language... really does attain to God
    himself, though unable to express him in his infinite simplicity."

    HONEST OPACITY: "Genuine truth content" is exactly what the CCC
    claims but cannot define further. §43 says our language "really
    does attain to God himself" — the "really" is the CCC's own
    marker that this is a substantive (not trivial) claim. What
    "attain" means beyond "it's not equivocal" is left open. -/
opaque hasGenuineTruthContent : TheologicalPredicate → Prop

/-- Whether a predicate applied to God captures the divine reality
    COMPLETELY — without remainder, without qualification.

    This is what UNIVOCAL predication would give: complete, unqualified
    truth. The CCC denies this for all human predicates applied to God
    (§42: "Our human words always fall short").

    MODELING CHOICE: We separate "genuine truth content" (partial but
    real) from "complete truth content" (total and unqualified) to
    formalize the CCC's middle position. -/
opaque capturesCompletely : TheologicalPredicate → Prop

/-- Whether creatures bear a genuine resemblance to God —
    the ground of all analogical predication.

    Source: [CCC] §41: "All creatures bear a certain resemblance
    to God." Cites Wisdom 13:5: "For from the greatness and beauty
    of created things comes a corresponding perception of their Creator."

    HIDDEN ASSUMPTION: This resemblance is REAL, not merely projected
    by the mind. A Kantian could say we IMPOSE the resemblance rather
    than discovering it. The CCC assumes the resemblance is in the
    things themselves, not just in our perception. This connects to
    Intelligibility.lean's `beingIsIntelligible`. -/
opaque creaturesResembleGod : Prop

-- ============================================================================
-- § 2. Axioms
-- ============================================================================

/-- AXIOM (CCC §40-43; ST I q.13 a.5): God-talk is ANALOGICAL —
    neither univocal nor equivocal.

    §42: "Our human words always fall short of the mystery of God"
    — therefore NOT univocal (complete capture).
    §43: "it really does attain to God himself"
    — therefore NOT equivocal (no truth content).

    This is the CCC's explicit position on theological language.
    It occupies the Thomistic middle: genuine but limited truth.

    Provenance: [Definition] CCC §40-43; [Philosophical] Aquinas,
    ST I q.13 a.5-6.
    Denominational scope: BROADLY ECUMENICAL in practice, though the
    specific Thomistic framework is Catholic. -/
axiom god_talk_is_analogical :
  ∀ (pred : TheologicalPredicate),
    predicationMode pred = PredicationMode.analogical

/-- AXIOM (CCC §43): Analogical predication carries genuine truth content.

    §43: "In speaking about God like this, our language is using human
    modes of expression; nevertheless it really does attain to God
    himself."

    The word "really" is load-bearing: the CCC insists this is not
    merely useful fiction or pious language. Analogical predicates
    say something TRUE about God.

    Provenance: [Definition] CCC §43; [Philosophical] Aquinas,
    ST I q.13 a.6.
    Denominational scope: ECUMENICAL. -/
axiom analogy_carries_truth :
  ∀ (pred : TheologicalPredicate),
    predicationMode pred = PredicationMode.analogical →
    hasGenuineTruthContent pred

/-- AXIOM (CCC §42): No human predicate captures God completely.

    §42: "Our human words always fall short of the mystery of God."

    This is the NEGATIVE side of analogy: genuine truth, but always
    partial. Divine simplicity (DivineAttributes.lean) explains WHY:
    God's attributes are identical with God's essence, but our predicates
    decompose them into separate propositions.

    HIDDEN ASSUMPTION: "Always fall short" means IN PRINCIPLE, not
    merely in practice. Even in the beatific vision, human language
    does not univocally capture God (though knowledge does surpass
    ordinary cognition — cf. §1028). The CCC implies this but the
    argument is Aquinas's (ST I q.12 a.4, a.7).

    Provenance: [Definition] CCC §42; [Philosophical] Aquinas,
    ST I q.13 a.5, q.12 a.4.
    Denominational scope: ECUMENICAL. -/
axiom human_language_falls_short :
  ∀ (pred : TheologicalPredicate),
    ¬ capturesCompletely pred

/-- AXIOM (CCC §41; Wis 13:5): Creatures genuinely resemble God.

    §41: "All creatures bear a certain resemblance to God... 'For from
    the greatness and beauty of created things comes a corresponding
    perception of their Creator.'"

    This resemblance is the GROUND of analogy: we can speak about God
    because creatures, as God's effects, bear traces of their cause.
    Without this resemblance, analogical predication would have no basis.

    CONNECTION TO INTELLIGIBILITY: This is a specific instance of
    Intelligibility.lean's `beingIsIntelligible` — the intelligibility
    of creatures extends (analogically) to knowledge of their Creator.

    Provenance: [Scripture] Wis 13:5; [Definition] CCC §41.
    Denominational scope: ECUMENICAL. -/
axiom creatures_resemble_god :
  creaturesResembleGod

/-- AXIOM (CCC §41, §43): Creaturely resemblance grounds analogical
    truth content.

    If creatures resemble God (§41) and a predicate is used analogically
    (§43), then the predicate's truth content is GROUNDED — not floating
    or arbitrary, but based on the real resemblance between creature and
    Creator.

    This is Aquinas's argument (ST I q.13 a.5): "Names are applied to
    God and creatures in an analogous sense... For since we know God
    from other things, the meaning of the names applied to Him depends
    on creatures."

    HIDDEN ASSUMPTION: Causal resemblance is sufficient for analogical
    truth. Aquinas assumes that effects genuinely resemble their cause
    (ST I q.4 a.3). A Humean could deny this: effects need not resemble
    causes. The CCC assumes the Thomistic position.

    Provenance: [Philosophical] Aquinas, ST I q.13 a.5, q.4 a.3;
    [Definition] CCC §41, §43.
    Denominational scope: CATHOLIC (the specific causal-resemblance
    argument is Thomistic). -/
axiom resemblance_grounds_analogy :
  creaturesResembleGod →
  ∀ (pred : TheologicalPredicate),
    predicationMode pred = PredicationMode.analogical →
    hasGenuineTruthContent pred

-- ============================================================================
-- § 3. The Methodological Challenge: Analogy and Catlib
-- ============================================================================

/-!
### What analogy means for catlib

Every axiom about God in this project uses predicates analogically:

- `godIsLove` (Axioms.lean, S1) — "love" is analogical
- `godCanBringAbout` (DivineAttributes.lean) — "bring about" is analogical
- `knownToGod` (DivineAttributes.lean) — "known" is analogical
- `godCreatesThruWisdom` (ScientificInquiry.lean) — "wisdom" is analogical
- `divinelyGoverned` (Axioms.lean, S4) — "governed" is analogical
- `identicalWithEssence` (DivineAttributes.lean) — "identical" is analogical

Lean treats each of these as a Prop — either true or false. But under
analogy, each is true IN AN ANALOGICAL SENSE, which is weaker than
univocal truth but stronger than equivocal truth.

Catlib CANNOT represent this distinction. A Lean `Prop` does not have
a "mode of truth." This is the deepest methodological limit of formal
theology: the gap between formal truth (univocal, binary) and analogical
truth (genuine but partial, non-binary).

### Why this matters

If we took analogy seriously IN the formalization, every axiom about God
would need a qualifier: "in an analogical sense, God is love." But Lean
has no type for "analogically true." So we state `godIsLove` as if it
were univocally true, knowing that the CCC says it is analogically true.

This means catlib's formal system is STRONGER than what the CCC claims:
- Catlib says: `godIsLove` is true (full stop)
- The CCC says: "God is love" in an analogical sense that "really does
  attain to God himself" but "always falls short of the mystery"

The gap is real and permanent. It is not a failure of our formalization
but a structural feature of applying formal methods to theology.
-/

/-- Whether the entire catlib project's methodology is sound —
    i.e., whether formal predicates applied to God have genuine
    (if limited) truth content.

    This is the DEEPEST methodological assumption in the project.
    It is not one axiom among many — it is the precondition for
    all axioms about God.

    MODELING CHOICE: We model this as a single Prop because it is
    a yes/no question: either analogy works (and catlib's axioms have
    genuine truth content) or it doesn't (and they might be meaningless).
    The CCC says yes (§40-43). Barth says no (KD I/1). -/
opaque catlibMethodologySound : Prop

/-- Whether Barth's rejection of the analogia entis is correct —
    that any analogy from creatures to God is illegitimate because
    God is known ONLY through self-revelation.

    Source: Barth, KD I/1 p. viii: the analogia entis is "the
    invention of the Antichrist" and "the reason why one cannot
    become Catholic."

    MODELING CHOICE: We model Barth's position as a simple rejection
    because the formal consequence is simple: if Barth is right,
    catlib's methodology is unsound.

    Note: Barth later allowed an *analogia fidei* (analogy of faith) —
    that God can be known through God's self-revelation in Christ.
    This is more nuanced than simple rejection, but the formal
    consequence for catlib is the same: if analogy of BEING fails,
    our predicates based on creaturely experience fail too. -/
opaque barthRejectionCorrect : Prop

/-- AXIOM (CCC §40-43, §36): The catlib methodology is sound BECAUSE
    analogy carries genuine truth content AND creaturely resemblance
    grounds it.

    If analogy carries genuine truth (§43) and creatures resemble God
    (§41), then formal predicates applied to God have genuine (if
    limited) truth content — and catlib's axioms are meaningful.

    This is the PROJECT-LEVEL ASSUMPTION that underlies everything else.
    It is stated here rather than in Axioms.lean because it is not a
    theological claim but a METHODOLOGICAL one: the claim that formal
    theology is possible.

    Provenance: [Definition] CCC §40-43, §36 (Vatican I, Dei Filius 2);
    [Philosophical] Aquinas, ST I q.13.
    Denominational scope: CATHOLIC — Barth explicitly denies this. -/
axiom analogy_grounds_methodology :
  (∀ (pred : TheologicalPredicate), hasGenuineTruthContent pred) →
  creaturesResembleGod →
  catlibMethodologySound

/-- AXIOM: If Barth's rejection is correct, the catlib methodology is
    NOT sound — formal predicates based on creaturely experience cannot
    reliably say anything about God.

    Source: Barth, KD I/1 p. viii.

    This is an honest axiom: catlib documents the strongest objection
    to its own methodology. If `barthRejectionCorrect` is true, then
    `catlibMethodologySound` is false.

    Provenance: [Philosophical] Karl Barth, KD I/1 (1932).
    Denominational scope: REFORMED (Barthian). -/
axiom barth_challenge :
  barthRejectionCorrect → ¬ catlibMethodologySound

-- ============================================================================
-- § 4. Theorems
-- ============================================================================

/-- THEOREM: God-talk carries genuine but incomplete truth content.
    This is the CCC's position stated formally: every predicate applied
    to God says something TRUE (§43: "really does attain") but not
    EVERYTHING (§42: "always falls short").

    This is the formal analogue of the "middle way" between univocity
    (full truth) and equivocity (no truth).

    Depends on: god_talk_is_analogical, analogy_carries_truth,
    human_language_falls_short. -/
theorem analogical_truth_is_genuine_but_partial
    (pred : TheologicalPredicate) :
    hasGenuineTruthContent pred ∧ ¬ capturesCompletely pred :=
  have h_mode := god_talk_is_analogical pred
  ⟨analogy_carries_truth pred h_mode, human_language_falls_short pred⟩

/-- THEOREM: Creaturely resemblance grounds all theological predication.
    The chain: creatures resemble God (§41) → analogy carries truth (§43)
    → every predicate about God has genuine truth content.

    This shows that §41 (resemblance) is the FOUNDATION of §43 (truth
    content). Without resemblance, there is no ground for analogy.

    Depends on: creatures_resemble_god, resemblance_grounds_analogy,
    god_talk_is_analogical. -/
theorem resemblance_grounds_all_god_talk
    (pred : TheologicalPredicate) :
    hasGenuineTruthContent pred :=
  have h_resemble := creatures_resemble_god
  have h_mode := god_talk_is_analogical pred
  resemblance_grounds_analogy h_resemble pred h_mode

/-- THEOREM: The catlib methodology is sound.
    The argument chain:
    1. Creatures resemble God (§41)
    2. Every predicate about God is analogical (§40-43)
    3. Analogical predication grounded in resemblance carries truth
    4. Therefore all predicates have genuine truth content
    5. Therefore catlib's formal axioms are meaningful

    Depends on: creatures_resemble_god, resemblance_grounds_all_god_talk,
    analogy_grounds_methodology. -/
theorem catlib_methodology_is_sound : catlibMethodologySound :=
  have h_resemble := creatures_resemble_god
  have h_truth : ∀ pred, hasGenuineTruthContent pred :=
    fun pred => resemblance_grounds_all_god_talk pred
  analogy_grounds_methodology h_truth h_resemble

/-- THEOREM: Analogy and divine simplicity are COMPLEMENTARY, not conflicting.

    DivineAttributes.lean showed that divine simplicity forces us to
    decompose God into separate predicates while the doctrine says they
    are one. Analogy EXPLAINS why this decomposition is permitted:

    - Simplicity says God's attributes are identical with God's essence
    - Analogy says our predicates give genuine but partial access
    - Therefore: we can legitimately reason with separate predicates
      (analogy permits it) even though God is simple (simplicity is
      not violated because our predicates are not univocal)

    The decomposition that DivineAttributes.lean flagged as a
    "methodological tension" is actually the EXPECTED CONSEQUENCE
    of analogical predication: multiple predicates for one simple
    reality, each capturing a genuine aspect.

    Depends on: god_talk_is_analogical, analogy_carries_truth,
    human_language_falls_short, simplicity_love (DivineAttributes). -/
theorem analogy_and_simplicity_complementary
    (pred : TheologicalPredicate) (e : DivineEssence) :
    -- Analogy gives genuine but partial access
    (hasGenuineTruthContent pred ∧ ¬ capturesCompletely pred) ∧
    -- Simplicity asserts identity with essence (for love, as example)
    identicalWithEssence godIsLove e :=
  ⟨analogical_truth_is_genuine_but_partial pred, simplicity_love e⟩

/-- THEOREM: Analogy connects to intelligibility — both rest on the
    knowability of being.

    Intelligibility.lean showed: being is intelligible because it comes
    from rational Logos. Analogy of being says: creaturely being
    RESEMBLES divine being, so creaturely intelligibility gives
    (analogical) access to God.

    The connection: `beingIsIntelligible` (Intelligibility) +
    `creaturesResembleGod` (this file) together ground the claim
    that being's intelligibility extends to knowledge of God.

    Depends on: being_is_intelligible (Intelligibility),
    creatures_resemble_god. -/
theorem intelligibility_grounds_analogy :
    beingIsIntelligible ∧ creaturesResembleGod :=
  ⟨being_is_intelligible, creatures_resemble_god⟩

/-- THEOREM: The Barthian challenge — if Barth is right, catlib fails.

    This theorem makes explicit what is at stake: catlib's methodology
    AND Barth's rejection cannot BOTH be true. The CCC (§36, §40-43)
    takes one side; Barth takes the other.

    This is NOT a proof that Barth is wrong. It is a proof that catlib
    has picked a side — and that the other side would invalidate the
    entire project.

    Depends on: catlib_methodology_is_sound, barth_challenge. -/
theorem barth_and_catlib_incompatible :
    ¬ barthRejectionCorrect :=
  fun h_barth =>
    have h_sound := catlib_methodology_is_sound
    have h_not_sound := barth_challenge h_barth
    h_not_sound h_sound

-- ============================================================================
-- § 5. Denominational Scope
-- ============================================================================

/-- Denominational scope: the analogy of being is a Catholic distinctive
    in its full Thomistic form. The broader claim that God-talk is
    limited-but-genuine is ecumenical.

    - CATHOLIC: Full analogia entis (Aquinas, Fourth Lateran Council)
    - ORTHODOX: Accept analogical predication in practice (e.g., the
      apophatic/cataphatic tradition) without the Thomistic framework
    - REFORMED (non-Barthian): Generally accept that language about God
      is accommodated/analogical (Calvin, Institutes I.13.1)
    - REFORMED (Barthian): REJECT analogia entis; accept only analogia
      fidei (analogy from God's self-revelation in Christ)
    - LUTHERAN: Generally accept the limitations of theological language
      without engaging the Thomistic framework specifically -/
def analogy_denominational_scope : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Full Thomistic analogia entis is Catholic; the broader claim " ++
            "that God-talk is limited-but-genuine is broadly ecumenical. " ++
            "Barth (Reformed) explicitly rejects analogia entis." }

/-!
## Summary

### Source claims formalized
- CCC §40: "our language about God is equally [limited]" → analogical predication
- CCC §41: "All creatures bear a certain resemblance to God" → creaturesResembleGod
- CCC §42: "Our human words always fall short" → human_language_falls_short
- CCC §43: "it really does attain to God himself" → analogy_carries_truth
- Aquinas ST I q.13 a.5: three modes of predication → PredicationMode
- Aquinas ST I q.13 a.5-6: God-talk is analogical → god_talk_is_analogical
- Barth KD I/1: rejection of analogia entis → barth_challenge

### Axioms (6)
1. `god_talk_is_analogical` (CCC §40-43; ST I q.13 a.5) — every predicate
   applied to God is analogical
2. `analogy_carries_truth` (CCC §43; ST I q.13 a.6) — analogical predicates
   have genuine truth content
3. `human_language_falls_short` (CCC §42; ST I q.13 a.5) — no predicate
   captures God completely
4. `creatures_resemble_god` (CCC §41; Wis 13:5) — creaturely resemblance
   to God is real
5. `resemblance_grounds_analogy` (CCC §41, §43; ST I q.13 a.5, q.4 a.3) —
   resemblance is the ground of analogical truth
6. `analogy_grounds_methodology` (CCC §40-43, §36) — analogy makes formal
   theology possible
7. `barth_challenge` (Barth, KD I/1) — Barth's rejection invalidates the
   methodology

### Theorems (5)
1. `analogical_truth_is_genuine_but_partial` — the CCC's middle position
2. `resemblance_grounds_all_god_talk` — §41 grounds §43
3. `catlib_methodology_is_sound` — the project's foundational assumption holds
4. `analogy_and_simplicity_complementary` — analogy explains why simplicity
   doesn't make God unknowable
5. `intelligibility_grounds_analogy` — being's knowability extends to God
6. `barth_and_catlib_incompatible` — catlib and Barth cannot both be right

### Key FINDING: Systematic uncertainty

**Analogy is the deepest methodological assumption in catlib.**

Every axiom about God (`godIsLove`, `omnipotence`, `omniscience`, etc.)
implicitly assumes that formal predicates applied to God have genuine
truth content. This assumption is:

- **Stated by the CCC** (§40-43): God-talk is analogical, genuine but limited
- **Grounded by Aquinas** (ST I q.13): in the causal resemblance of creatures
  to their Creator
- **Denied by Barth** (KD I/1): who rejects all analogy from being to God
- **Unprovable within catlib**: because it is the precondition for the axioms,
  not a consequence of them

The formal system cannot represent the analogical qualifier. When catlib says
`godIsLove`, it means this univocally (a Lean Prop is true or false). When
the CCC says "God is love," it means this analogically (genuinely but
partially). This gap between formal and analogical truth is a permanent
methodological limit of formal theology.

**Comparison with DivineAttributes.lean:**
- DivineAttributes found: simplicity makes God resist decomposition, but our
  methodology requires decomposition
- This file finds: analogy EXPLAINS why the decomposition is permitted — it
  gives genuine partial access, not univocal capture
- Together: simplicity says WHY our predicates fall short (God is one);
  analogy says WHY our predicates still have value (creatures resemble God)

### Cross-file connections
- DivineAttributes.lean: `DivineEssence`, `identicalWithEssence`,
  `simplicity_love` — analogy explains why simplicity doesn't block knowledge
- Intelligibility.lean: `beingIsIntelligible`, `being_is_intelligible` —
  analogy is the mechanism by which intelligibility extends to God
- Axioms.lean: `godIsLove` — the paradigm case of analogical predication
- ScientificInquiry.lean: `godCreatesThruWisdom` — another analogical predicate
  (wisdom applied to God)

### Hidden assumptions
1. Analogy carries genuine truth content (§43, never argued for — assumed)
2. The three modes are exhaustive (Aquinas, q.13 a.5)
3. Creatures genuinely resemble God (§41, Wis 13:5 — the vestigia Dei tradition)
4. Causal resemblance is sufficient for analogical truth (Aquinas, q.4 a.3)
5. Catlib implicitly assumes analogy works (the deepest hidden assumption)

### Modeling choices
1. Predication modes as an inductive type (classification, not claim)
2. "Genuine truth content" as opaque (the CCC doesn't define "attain")
3. Barth's position as simple rejection (simplification of a nuanced view)
4. Analogy as project-level assumption rather than local axiom
-/

end Catlib.Creed.AnalogyOfBeing
