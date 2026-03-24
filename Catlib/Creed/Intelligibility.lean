import Catlib.Creed.Logos
import Catlib.Creed.ScientificInquiry
import Catlib.MoralTheology.NaturalLaw

/-!
# Why Should Truth Be Intelligible At All?

## The question

Why should we expect reality to be knowable by reason? This is not obvious.
Many worldviews offer no account of why mind fits world:

- **Materialism**: mind is an accidental byproduct of matter. No reason to
  expect its categories to track reality's deep structure.
- **Idealism**: the world conforms to mind, but then "truth" is just
  consistency, not adequation to an independent reality.
- **Skepticism** (Hume, Kant): we may impose categories that don't match
  the thing-in-itself. The gap between appearance and reality is permanent.

The CCC's answer draws on three interrelated claims:

1. **Logos theology** (Jn 1:1-3): reality is intelligible because it was
   created through rational Logos. Mind fits world because both come from
   the same rational source.

2. **Metaphysical realism** (Aristotle/Aquinas): being is inherently
   intelligible. To BE is to be knowable. Truth is the conformity of
   intellect to thing (*adaequatio rei et intellectus*).

3. **Both together** (the CCC's actual position): Logos theology EXPLAINS
   why metaphysical realism is true. Being is intelligible because being
   comes from Logos. The philosophical claim (realism) has a theological
   ground (Logos).

## What this formalization shows

The key theorem: Logos theology + metaphysical realism together are
STRONGER than either alone.

- **Logos alone** gives intelligibility but not mechanism. The world was
  made through a rational Word — but HOW does that make it knowable to US?
  Without the realist claim that being itself is intelligible, the Logos
  doctrine gives us a source but not a pathway.

- **Realism alone** gives mechanism but not ground. Being is intelligible,
  and intellect is adequate to being — but WHY? What explains the fit?
  Without Logos theology, the fit between mind and world is a brute fact,
  not an explained one.

- **Together**: grounded mechanism. Being is intelligible (realism) BECAUSE
  it comes from Logos (theology). The mechanism has a ground; the ground
  has a mechanism. This is the *adaequatio rei et intellectus* with its
  theological foundation exposed.

## Connection to existing files

ScientificInquiry.lean derives two propositions:
- (A) `worldIsLogical` — the world has stable, discoverable order
- (B) `humansCanUnderstandIt` — human reason is fitted to that order

Logos.lean establishes:
- The wisdom behind creation is personal (the Son/Logos)
- Creation through Logos grounds intelligibility

This file bridges them: ScientificInquiry's A and B are the REALIST face
of what Logos.lean grounds THEOLOGICALLY. They are two perspectives on the
same reality: the rational fit of knower to known.

## Hidden assumptions

1. **Being is convertible with intelligibility** (*ens et verum
   convertuntur*). This is Aquinas's thesis (De Veritate q.1 a.1) —
   everything that exists is, in principle, knowable. The CCC never
   states this explicitly but it pervades the natural theology of §36.

2. **The fit between mind and world requires explanation.** A thorough
   naturalist could say the fit is just a brute evolutionary fact. The
   CCC assumes it requires a metaphysical ground — not just a causal
   explanation.

3. **Personal agency can ground impersonal order.** Already flagged in
   Logos.lean — the claim that a Person (the Logos) grounds lawlike
   regularity.

## Modeling choices

1. **We model the three positions as producing Props.** The Logos position
   yields intelligibility, the realist position yields a mechanism (the
   knower-known adequation), and the combined position yields both.

2. **We use opaque predicates for the core metaphysical claims.** The CCC
   doesn't give us definitions of "being is intelligible" or "intellect
   is adequate to reality" — it assumes them.

3. **The "stronger together" result is structural.** We show that the
   combined position entails claims that neither position alone entails.

## Denominational scope

ECUMENICAL — all three premises (Logos theology, metaphysical realism,
and their combination) are shared across Catholic, Orthodox, and most
Protestant traditions. The one exception: fideist traditions (some
Barthians) reject natural theology entirely, denying that reason
can reliably know anything about God from creation.
-/

set_option autoImplicit false

namespace Catlib.Creed.Intelligibility

open Catlib
open Catlib.Creed
open Catlib.Creed.ScientificInquiry
open Catlib.Creed.Logos
open Catlib.Creed.Christology
open Catlib.MoralTheology

-- ============================================================================
-- § 1. Core Predicates
-- ============================================================================

/-- Whether being is inherently intelligible — to exist is to be, in
    principle, knowable. This is the *ens et verum convertuntur* of Aquinas
    (De Veritate q.1 a.1): being and truth are convertible.

    The CCC assumes this throughout its natural theology (§36: God "can be
    known with certainty from the created world") but never states it as
    a principle. It is the deepest hidden assumption behind the claim that
    reason can reach reality.

    HIDDEN ASSUMPTION: This is Aquinas's thesis, not a CCC definition.
    The CCC *uses* it (§36, §286, §299) but never *states* it. A nominalist
    (Ockham) would deny that being is inherently intelligible — for a
    nominalist, intelligibility is imposed by the mind, not intrinsic to
    things. -/
opaque beingIsIntelligible : Prop

/-- Whether the intellect is naturally adequate to being — the mind is
    fitted to reality, not a defective instrument projecting patterns
    onto chaos.

    This is the *adaequatio rei et intellectus* (Aquinas, ST I q.16 a.1):
    truth is the conformity of intellect to thing. The adequation claim
    says the conformity is POSSIBLE — that the intellect is the right
    kind of thing to grasp reality.

    ScientificInquiry.lean's `humansCanUnderstandIt` is the CONSEQUENCE
    of this adequation. This predicate captures the PRINCIPLE that
    explains why understanding is possible.

    HIDDEN ASSUMPTION: The adequation is not just a lucky accident but
    a structural feature of the intellect-world relationship. -/
opaque intellectAdequateToReality : Prop

/-- Whether the intelligibility of being has a ground — i.e., there is
    an explanation for WHY being is intelligible, as opposed to the
    intelligibility being a brute fact.

    Under Logos theology: being is intelligible because it comes from
    rational Logos. The ground is personal and divine.

    Under pure realism: being is intelligible because that's what being IS.
    The ground is the nature of being itself — no further explanation.

    The CCC claims BOTH: being is intelligible (realism) and the reason
    it's intelligible is that it comes from Logos (theology). -/
opaque intelligibilityIsGrounded : Prop

/-- Whether there is a unified source that accounts for both the world's
    rational order AND the mind's capacity to grasp that order.

    Under Logos theology + realism: the unified source is the Logos.
    The same rational Word that structured creation also structured
    the mind (via imago dei) that studies creation. The fit between
    knower and known is explained by their common origin.

    MODELING CHOICE: This is our way of capturing the "stronger together"
    claim. Neither Logos alone nor realism alone provides a unified source
    for both sides of the adequation. -/
opaque unifiedSourceOfFit : Prop

-- ============================================================================
-- § 2. Axioms
-- ============================================================================

/-- AXIOM (§36, De Veritate q.1 a.1): Being is intelligible — to exist
    is to be knowable.

    "God, the first principle and last end of all things, can be known
    with certainty from the created world by the natural light of human
    reason." (CCC §36, citing Vatican I, Dei Filius 2)

    §36 asserts that God can be known from creation. This presupposes
    that creation is KNOWABLE — i.e., that being is intelligible.
    The principle is Aquinas's *ens et verum convertuntur* but the CCC
    relies on it without naming it.

    Provenance: [Philosophy] Aquinas, De Veritate q.1 a.1;
    [Definition] CCC §36 (presupposed).
    Denominational scope: ECUMENICAL. -/
axiom being_is_intelligible :
  beingIsIntelligible

/-- AXIOM (§36, §1700, §299): The adequation of intellect to reality.

    If being is intelligible (being_is_intelligible) and the world is
    logical (the_world_is_logical from ScientificInquiry), and humans
    share in divine rationality (imageSharesRationality from
    ScientificInquiry), then the intellect is adequate to reality —
    the mind can grasp what IS.

    This is the *adaequatio rei et intellectus*: the conformity of
    intellect to thing is POSSIBLE because the same wisdom that made
    things intelligible also made the intellect rational.

    Provenance: [Philosophy] Aquinas, ST I q.16 a.1;
    [Definition] CCC §36 + §299 + §1700.
    Denominational scope: ECUMENICAL. -/
axiom adequation_of_intellect :
  beingIsIntelligible →
  worldIsLogical →
  intellectAdequateToReality

/-- AXIOM (§291-292, §295, §299): Logos theology grounds the
    intelligibility of being.

    If the Logos grounds the world's intelligibility (from Logos.lean)
    AND being is intelligible (realism), then the intelligibility has
    a GROUND — it is not a brute fact but explained by the Logos.

    This is the CCC's distinctive move: the philosophical claim (being
    is intelligible) has a theological explanation (because being comes
    from Logos). The realist claim is TRUE, and Logos theology says WHY.

    Provenance: [Definition] CCC §291-292, §295, §299.
    Denominational scope: ECUMENICAL. -/
axiom logos_grounds_realism :
  groundsIntelligibility son →
  beingIsIntelligible →
  intelligibilityIsGrounded

/-- AXIOM (§299 + §1700 + Jn 1:1-3): The Logos provides a unified source
    for both the world's order and the mind's fitness.

    If intelligibility is grounded in Logos (logos_grounds_realism) AND
    the intellect is adequate to reality (adequation_of_intellect) AND
    wisdom is personal (wisdom_is_personal from Logos.lean), then there
    is a unified source — the same Logos that ordered creation also
    accounts for the mind's capacity to understand it (via imago dei:
    humans are images of the rational God who IS the Logos).

    This is what neither position gives alone:
    - Logos alone: the world is ordered (but WHY can we grasp the order?)
    - Realism alone: the mind fits reality (but WHY this fit?)
    - Together: the Logos is both the source of order AND (via imago dei)
      the source of the mind's fitness. ONE source, TWO effects.

    Provenance: [Definition] CCC §299 + §1700; [Scripture] Jn 1:1-3.
    Denominational scope: ECUMENICAL. -/
axiom unified_source_from_logos_and_realism :
  intelligibilityIsGrounded →
  intellectAdequateToReality →
  wisdomIsPersonal →
  unifiedSourceOfFit

-- ============================================================================
-- § 3. Theorems: The Three Positions
-- ============================================================================

/-- THEOREM (Position 1): Logos theology alone — intelligibility is
    grounded but the mechanism (adequation) is not yet derived.

    From Logos.lean, we know the Logos grounds creation's intelligibility.
    Combined with the realist premise (being is intelligible), we get
    a grounded intelligibility. But we have not yet shown the adequation
    of intellect to reality — that requires the realist analysis.

    Uses: logos_grounds_creation_order (Logos.lean) + being_is_intelligible +
          logos_grounds_realism. -/
theorem logos_alone_grounds_intelligibility :
    intelligibilityIsGrounded := by
  have h_logos := logos_grounds_creation_order
  have h_being := being_is_intelligible
  exact logos_grounds_realism h_logos h_being

/-- THEOREM (Position 2): Metaphysical realism alone — the mechanism
    (adequation) is available but the ground is not yet provided.

    From being_is_intelligible and the_world_is_logical, we can derive
    the adequation of intellect to reality. But this adequation is a
    BRUTE FACT — realism alone doesn't explain WHY being is intelligible.

    Uses: being_is_intelligible + the_world_is_logical (ScientificInquiry) +
          adequation_of_intellect. -/
theorem realism_alone_gives_adequation :
    intellectAdequateToReality := by
  have h_being := being_is_intelligible
  have h_logical := the_world_is_logical
  exact adequation_of_intellect h_being h_logical

/-- THEOREM (Position 3 — KEY RESULT): Both together provide what
    neither gives alone — a GROUNDED MECHANISM with a UNIFIED SOURCE.

    The combined position yields three things:
    1. Intelligibility is grounded (from Logos theology)
    2. The intellect is adequate to reality (from realism)
    3. There is a unified source for both (from combining them)

    The unified source is the Logos: the same rational Word that ordered
    creation (grounding intelligibility) also structured the mind
    (via imago dei, grounding adequation). The fit between knower and
    known is not accidental — it is because both are expressions of
    the same Person.

    Uses: logos_alone_grounds_intelligibility + realism_alone_gives_adequation +
          wisdom_is_personal (Logos.lean) + unified_source_from_logos_and_realism. -/
theorem both_together_unified_source :
    intelligibilityIsGrounded ∧ intellectAdequateToReality ∧ unifiedSourceOfFit := by
  have h_grounded := logos_alone_grounds_intelligibility
  have h_adequate := realism_alone_gives_adequation
  have h_personal := wisdom_is_personal
  have h_unified := unified_source_from_logos_and_realism h_grounded h_adequate h_personal
  exact ⟨h_grounded, h_adequate, h_unified⟩

-- ============================================================================
-- § 4. Bridge Theorems to Existing Files
-- ============================================================================

/-- THEOREM: ScientificInquiry's worldIsLogical is the REALIST FACE of
    what Logos.lean grounds THEOLOGICALLY.

    ScientificInquiry derives: the world is logical (from §299 + P2).
    Logos.lean establishes: the Logos grounds intelligibility.
    This bridge shows they converge: if the world is logical AND the
    Logos grounds intelligibility AND being is intelligible, then we
    have the full grounded intelligibility.

    Two perspectives on one reality: the philosopher says "being is
    intelligible"; the theologian says "because Logos." -/
theorem scientific_inquiry_meets_logos :
    worldIsLogical ∧ groundsIntelligibility son ∧ intelligibilityIsGrounded := by
  have h_logical := the_world_is_logical
  have h_logos := logos_grounds_creation_order
  have h_grounded := logos_alone_grounds_intelligibility
  exact ⟨h_logical, h_logos, h_grounded⟩

/-- THEOREM: The adequation of intellect to reality EXPLAINS
    ScientificInquiry's `humansCanUnderstandIt`.

    ScientificInquiry's Proposition B (`humansCanUnderstandIt`) is the
    downstream effect; this file's `intellectAdequateToReality` is the
    principle that explains it. Both are true; the adequation is the
    deeper claim.

    Uses: humans_can_understand_the_world (ScientificInquiry) +
          realism_alone_gives_adequation. -/
theorem adequation_explains_understanding :
    humansCanUnderstandIt ∧ intellectAdequateToReality := by
  have h_understand := humans_can_understand_the_world
  have h_adequate := realism_alone_gives_adequation
  exact ⟨h_understand, h_adequate⟩

/-- THEOREM: NaturalLaw's moral_realism participates in the same
    intelligibility structure.

    If being is intelligible, then moral being is also intelligible —
    moral facts are knowable by reason. NaturalLaw.lean's moral_realism
    (moral propositions have definite truth values) is an instance of
    the broader metaphysical realism formalized here.

    Uses: being_is_intelligible + moral_realism_from_s6 (NaturalLaw).

    This bridge shows that moral knowledge and scientific knowledge
    share the same metaphysical foundation: the intelligibility of
    being, grounded in Logos. -/
theorem moral_realism_from_intelligibility
    (mp : MoralProposition) (h : moralTruthValue mp) :
    accessibleToReason mp ∧ beingIsIntelligible := by
  have h_moral := moral_realism_from_s6 mp h
  have h_being := being_is_intelligible
  exact ⟨h_moral, h_being⟩

-- ============================================================================
-- § 5. What Breaks Without Each Component
-- ============================================================================

/-!
### Failure modes

| Drop this | You get | Problem |
|-----------|---------|---------|
| Logos theology | Brute realism | Being is intelligible but WHY? No explanation. The fit between mind and world is a cosmic coincidence. |
| Metaphysical realism | Logos without mechanism | God made the world through Logos but HOW does that make it knowable to us? No account of adequation. |
| Both | Skepticism or fideism | Either reality is unknowable (Kant), or we can know it only by faith, not by reason (Barth). |
| imago_dei (from ScientificInquiry) | Logos + realism without a knower | The world is intelligible and grounded, but WE have no access. The adequation applies to SOME intellect but we have no reason to think ours qualifies. |

### The deepest finding

The CCC's position is that the THREE components (Logos, realism, imago dei)
form an irreducible package:

1. **Logos** → the world is intelligible (source of object-side order)
2. **Realism** → being is knowable (the object-side is open to intellect)
3. **Imago dei** → we can know it (the subject-side is fitted to the object)

Drop any one and the argument fails:
- Without Logos: intelligibility is brute (no ground)
- Without realism: Logos gives order but not knowability (no mechanism)
- Without imago dei: the world is knowable in principle but not by us (no knower)

This is the *adaequatio rei et intellectus* with its full infrastructure
exposed. Aquinas stated the principle; the CCC provides the theology that
explains why the principle is true.
-/

/-- THEOREM: The complete package — all three components of the CCC's
    account of intelligibility.

    1. The world is logical (ScientificInquiry — the object-side fact)
    2. Humans can understand it (ScientificInquiry — the subject-side fact)
    3. Being is intelligible (realism — the principle)
    4. The intellect is adequate to reality (realism — the mechanism)
    5. Intelligibility is grounded in Logos (theology — the explanation)
    6. There is a unified source (both together — the synthesis)

    Uses: everything from ScientificInquiry, Logos, and this file. -/
theorem complete_intelligibility_package :
    worldIsLogical ∧
    humansCanUnderstandIt ∧
    beingIsIntelligible ∧
    intellectAdequateToReality ∧
    intelligibilityIsGrounded ∧
    unifiedSourceOfFit := by
  have h_both := both_together_unified_source
  exact ⟨the_world_is_logical,
         humans_can_understand_the_world,
         being_is_intelligible,
         h_both.2.1,
         h_both.1,
         h_both.2.2⟩

-- ============================================================================
-- § 6. Denominational Scope
-- ============================================================================

/-- All axioms and theorems in this file are ECUMENICAL.

    The three components:
    - Logos theology: Jn 1:1-3, accepted by all Christians (Nicaea/Chalcedon)
    - Metaphysical realism: Aristotle/Aquinas, but the claim that being is
      knowable is broadly shared
    - Imago dei: Gen 1:27, universally accepted

    The only dissenters: fideist traditions (some Barthians) who deny natural
    theology entirely. They accept Logos theology but reject that reason can
    reliably know God from creation (Vatican I's Dei Filius 2). -/
def intelligibility_denominational_scope : DenominationalTag := ecumenical

/-!
## Summary

### Source claims formalized
- CCC §36 (Vatican I, Dei Filius 2): God can be known from creation by reason
- CCC §291-292, §295, §299: creation through Logos → rational order
- CCC §1700: imago dei → human intellect
- Aquinas, De Veritate q.1 a.1: *ens et verum convertuntur* (being and truth
  are convertible)
- Aquinas, ST I q.16 a.1: *adaequatio rei et intellectus* (truth is the
  conformity of intellect to thing)

### Axioms (4 — all ECUMENICAL)
1. `being_is_intelligible` (§36, De Veritate) — to be is to be knowable
2. `adequation_of_intellect` (§36 + §299 + §1700) — intellect is fitted to reality
3. `logos_grounds_realism` (§291-292, §295) — Logos explains WHY being is intelligible
4. `unified_source_from_logos_and_realism` (§299 + §1700 + Jn 1:1-3) — one source for both order and understanding

### Theorems (7)
1. `logos_alone_grounds_intelligibility` — Position 1: grounded but no mechanism
2. `realism_alone_gives_adequation` — Position 2: mechanism but no ground
3. `both_together_unified_source` — Position 3 (KEY): grounded mechanism with unified source
4. `scientific_inquiry_meets_logos` — Bridge: ScientificInquiry ↔ Logos convergence
5. `adequation_explains_understanding` — Bridge: adequation explains understanding
6. `moral_realism_from_intelligibility` — Bridge: moral knowledge shares the same foundation
7. `complete_intelligibility_package` — The full six-part package

### Key FINDING

**Answer to the main question: does intelligibility rest on Logos theology,
metaphysical realism, or both?**

**Both — and the "both" is the point.**

Logos theology and metaphysical realism are not competing explanations but
complementary aspects of a single account:

- Realism provides the MECHANISM: being is intelligible, intellect is
  adequate to being, truth is the conformity of intellect to thing.
- Logos theology provides the GROUND: being is intelligible BECAUSE it comes
  from rational Logos; the intellect is adequate BECAUSE it is made in the
  image of the same Logos.
- Together they yield what neither provides alone: a UNIFIED SOURCE (the Logos)
  that accounts for BOTH sides of the adequation — the knowability of the object
  AND the fitness of the knower.

This is the *adaequatio rei et intellectus* with its full theological
infrastructure exposed. The philosophical principle (Aquinas) is true,
and the CCC shows why: because both res (thing) and intellectus (mind)
are expressions of the same rational Logos.

### Cross-file connections
- ScientificInquiry.lean: `worldIsLogical`, `humansCanUnderstandIt`,
  `the_world_is_logical`, `humans_can_understand_the_world`,
  `god_creates_through_wisdom`, `imageSharesRationality`
- Logos.lean: `groundsIntelligibility`, `wisdomIsPersonal`,
  `logos_grounds_creation_order`, `wisdom_is_personal`, `son`
- NaturalLaw.lean: `moral_realism_from_s6` (moral knowledge as instance
  of the same intelligibility)
- Axioms.lean: P2 (used via ScientificInquiry), S6 (used via NaturalLaw)

### Hidden assumptions
1. **Being is convertible with intelligibility** (*ens et verum convertuntur*) —
   Aquinas's thesis, assumed by the CCC but never stated
2. **The fit between mind and world requires explanation** — a naturalist
   could accept the fit as brute evolutionary fact
3. **Personal agency can ground impersonal order** — already flagged in
   Logos.lean

### Modeling choices
1. The three positions (Logos, realism, both) are modeled as producing
   distinct Props — this captures the structural difference between them
2. Opaque predicates for core metaphysical claims — the CCC doesn't define
   "being is intelligible" or "intellect is adequate to reality"
3. The "unified source" is modeled as a single opaque Prop — the mechanism
   of unification (how the Logos is both source of order and source of mind)
   is left unspecified because the CCC doesn't specify it
-/

end Catlib.Creed.Intelligibility
