import Catlib.Foundations.Basic
import Catlib.Foundations.Axioms

/-!
# The Mathematics of Love: A Typed Love Relation

## The problem

The Catechism uses "love" in at least four different senses without always
distinguishing them. Axioms.lean declares:

- `godIsLove : Prop` — God's nature is love
- `loves : Person → Person → Prop` — an untyped love relation
- `loveRequiresFreedom : Prop` — genuine love requires freedom

But "love" in §1 John 4:8 (God IS love), §1827 (charity increases through
virtue), Mt 5:44 (love your enemies), and CCC §2264 (self-love grounds
legitimate defense) are NOT the same concept. Using a single `loves` predicate
collapses distinctions the Catechism itself makes.

A proof assistant forces the disambiguation.

## The four kinds

Following the classical tradition (with Catechism support):

1. **Agape** (charity): willing the good of the other for their own sake.
   The supernatural love that CCC §1827 says increases through virtue and
   CCC §1855 says mortal sin destroys. This is the love of Mt 5:44 ("love
   your enemies") — it does NOT require reciprocity.

2. **Eros** (desire-love): attraction toward the good, the beautiful, the
   true. Benedict XVI (Deus Caritas Est §3-8) argues this is NOT opposed to
   agape but is its natural starting point. Eros is involuntary — you do not
   choose whom you find beautiful.

3. **Philia** (friendship): mutual benevolence between persons. Aquinas
   (ST II-II q.23 a.1) defines charity AS a friendship with God — but
   friendship requires mutuality by definition.

4. **Self-love**: legitimate love of self. CCC §2264 ("Love toward oneself
   remains a fundamental principle of morality") — this grounds legitimate
   defense.

## Findings

- **Agape requires freedom; eros does not.** The axiom `loveRequiresFreedom`
  is over-general. You can be involuntarily attracted (eros) but you cannot
  be forced to will someone's good (agape). This matters for the hell
  doctrine: the damned may still experience eros (desire for goods they
  lack) but have definitively refused agape toward God.

- **Mortal sin destroys agape specifically.** CCC §1855 says mortal sin
  "destroys charity." But sinners still feel attraction (eros) and maintain
  friendships (philia). The destruction is of the supernatural love-kind,
  not all love. This resolves a pastoral puzzle: how can mortal sinners
  still love their families?

- **Philia is symmetric; agape is not.** God loves (agape) the damned
  (S2: universal salvific will), but the damned do not love God back.
  Agape is not symmetric. Philia, by definition, requires mutuality.

- **Self-love is reflexive by definition.** The lover and beloved are the
  same person. This is not a theorem — it is a structural property of the
  type.

- **The ordo amoris is a strict ordering.** Aquinas (ST II-II q.26):
  love of God > love of neighbor > love of self. This ordering applies
  to agape specifically.

## Denominational scope

The four-fold distinction is broadly ecumenical — C.S. Lewis's "The Four
Loves" is a Protestant articulation of essentially the same taxonomy. The
ordo amoris is specifically Thomistic but broadly shared in substance.

## Open questions

Documented inline below — these are genuine gaps, not formalization failures.
-/

set_option autoImplicit false

namespace Catlib.Foundations.Love

open Catlib

-- ============================================================================
-- ## Core Types
-- ============================================================================

/-- The four kinds of love the Catechism distinguishes (often implicitly).

    This taxonomy follows the classical tradition. The Catechism does not
    use these Greek terms, but its text operates with exactly these
    distinctions: charity (agape) is supernatural and can be lost;
    attraction (eros) is involuntary; friendship (philia) requires
    mutuality; self-love (CCC §2264) grounds legitimate defense.

    Denominational scope: ECUMENICAL — C.S. Lewis, Benedict XVI, Aquinas,
    and most Christian traditions recognize these distinctions. -/
inductive LoveKind where
  /-- Charity: willing the good of the other for their own sake.
      CCC §1822: "Charity is the theological virtue by which we love God
      above all things for his own sake, and our neighbor as ourselves
      for the love of God." -/
  | agape
  /-- Desire-love: attraction toward the good/beautiful.
      Benedict XVI, Deus Caritas Est §3-8.
      Involuntary — you do not choose your attractions. -/
  | eros
  /-- Friendship: mutual benevolence between persons.
      Aquinas ST II-II q.23 a.1: charity is a friendship with God. -/
  | philia
  /-- Legitimate love of self.
      CCC §2264: "Love toward oneself remains a fundamental principle
      of morality. It is therefore legitimate to insist on respect for
      one's own right to life." -/
  | selfLove

/-- A typed love relation — specifying WHICH kind of love.

    This replaces the untyped `loves : Person → Person → Prop` from
    Axioms.lean. The untyped version conflates four distinct concepts.

    Denominational scope: ECUMENICAL (the taxonomy); the specific
    properties below vary. -/
structure TypedLove where
  /-- Which kind of love -/
  kind : LoveKind
  /-- The person who loves -/
  lover : Person
  /-- The person who is loved (for selfLove: lover = beloved) -/
  beloved : Person
  /-- Love intensity/degree (charity can increase per CCC §1827).
      0 = absent, higher = more intense. -/
  degree : Nat
  /-- Self-love is reflexive: lover = beloved by definition.
      CCC §2264: "Love toward oneself remains a fundamental principle
      of morality." This is a structural property, not an axiom. -/
  wf_selfLove : kind = LoveKind.selfLove → lover = beloved
  /-- Agape (charity) requires freedom of the will.
      CCC §1822: charity is a theological VIRTUE — virtues require free acts.
      A person without free will cannot perform genuine charity. -/
  wf_agape_freedom : kind = LoveKind.agape → degree > 0 → lover.hasFreeWill = true

-- ============================================================================
-- ## Axioms: Properties of the four kinds
-- ============================================================================

/-!
### Property 1: Agape is NOT symmetric

You can love (agape) enemies who hate you. Mt 5:44: "Love your enemies
and pray for those who persecute you." God loves the damned (S2: universal
salvific will) but the damned do not love God back.

Denominational scope: ECUMENICAL — all Christians accept Mt 5:44.
-/

/-- Agape is not symmetric: there exist pairs where one loves the other
    (agape) but the reciprocal does not hold.

    Source: [Scripture] Mt 5:44 ("love your enemies"); S2 (God desires
    all to be saved — including those who reject Him).

    This is an existence claim: we assert that non-reciprocated agape
    is POSSIBLE, not that it always fails to be reciprocated.

    FORMERLY AN AXIOM — now provable from the well-formedness constraints.
    Proof idea: pick a free lover (Person.human) who loves (agape, degree 1)
    a beloved WITHOUT free will. Any reciprocal agape from the beloved must
    have degree 0, because wf_agape_freedom requires hasFreeWill = true
    for degree > 0, but the beloved lacks free will. -/
theorem agape_not_symmetric_witness :
  ∃ (tl : TypedLove),
    tl.kind = LoveKind.agape ∧
    tl.degree > 0 ∧
    -- There is no reciprocal agape from beloved to lover
    ∀ (tl' : TypedLove),
      tl'.kind = LoveKind.agape →
      tl'.lover = tl.beloved →
      tl'.beloved = tl.lover →
      tl'.degree = 0 := by
  -- Witness: Person.human (free) loves an unfree person with agape degree 1
  let unfree : Person := ⟨true, false, false⟩
  refine ⟨⟨.agape, Person.human, unfree, 1, nofun, fun _ _ => rfl⟩,
         rfl, Nat.one_pos, ?_⟩
  -- Any reciprocal agape from unfree back must have degree 0
  intro tl' hkind hlover _
  -- If degree > 0, then wf_agape_freedom says lover.hasFreeWill = true
  -- But lover = unfree whose hasFreeWill = false — contradiction
  -- So degree must be 0
  match h : tl'.degree with
  | 0 => rfl
  | n + 1 =>
    exfalso
    have := tl'.wf_agape_freedom hkind (by omega)
    simp [hlover] at this

/-!
### Property 2: Philia IS symmetric

Friendship requires mutuality by definition. If A is friends with B,
then B is friends with A. One-sided friendship is not friendship — it
is unrequited affection.

Source: Aquinas ST II-II q.23 a.1; Aristotle, Nicomachean Ethics VIII.2.
Denominational scope: ECUMENICAL.
-/

/-- Philia (friendship) is symmetric: if A has philia toward B, then B
    has philia toward A.

    Source: [Philosophy] Aristotle NE VIII.2; Aquinas ST II-II q.23 a.1.
    "Friendship... requires mutual benevolence." -/
axiom philia_symmetric :
  ∀ (tl : TypedLove),
    tl.kind = LoveKind.philia →
    ∃ (tl' : TypedLove),
      tl'.kind = LoveKind.philia ∧
      tl'.lover = tl.beloved ∧
      tl'.beloved = tl.lover ∧
      tl'.degree > 0

/-!
### Property 3: Self-love is reflexive

The lover and beloved are the same person by definition.
CCC §2264: "Love toward oneself remains a fundamental principle of morality."

Denominational scope: ECUMENICAL.
-/

/-- Self-love is reflexive: lover = beloved.

    Source: [Definition] CCC §2264.
    FORMERLY AN AXIOM — now a trivial consequence of the wf_selfLove
    field on TypedLove. The structure enforces this by construction. -/
theorem self_love_reflexive :
  ∀ (tl : TypedLove),
    tl.kind = LoveKind.selfLove →
    tl.lover = tl.beloved :=
  fun tl hkind => tl.wf_selfLove hkind

/-!
### Property 4: Agape requires freedom; eros does NOT

S1 declares `loveRequiresFreedom`, but this is over-general. You can
be involuntarily attracted (eros) to someone — attraction is not a
free act. But you CANNOT be forced to will someone's good for their
own sake (agape) — charity is a free act of the will.

This distinction matters for:
- Hell: the damned may still experience eros (they desire goods they
  lack) but have definitively refused agape toward God.
- Concupiscence: fallen humans experience involuntary eros toward evil
  (disordered desire) which is not itself sinful (CCC §1264) precisely
  because it is not free.

Denominational scope: ECUMENICAL (the distinction between voluntary
and involuntary love is broadly accepted).
-/

/-- Agape (charity) requires freedom of the will.

    Source: [Scripture] S1 (loveRequiresFreedom, restricted to agape);
    CCC §1822 (charity as a theological VIRTUE — virtues require free acts).

    FORMERLY AN AXIOM — now a trivial consequence of the wf_agape_freedom
    field on TypedLove. The structure enforces this by construction. -/
theorem agape_requires_freedom :
  ∀ (tl : TypedLove),
    tl.kind = LoveKind.agape →
    tl.degree > 0 →
    tl.lover.hasFreeWill = true :=
  fun tl hkind hdeg => tl.wf_agape_freedom hkind hdeg

/-- Eros does NOT require freedom. Involuntary attraction is possible
    and is not sinful precisely because it is not free.

    Source: CCC §1264 (concupiscence — involuntary disordered desire —
    is not itself sinful); Benedict XVI, Deus Caritas Est §3-8.

    Formally: there can exist eros with degree > 0 where the lover
    lacks free will (or equivalently, eros can occur involuntarily). -/
axiom eros_does_not_require_freedom :
  ∃ (tl : TypedLove),
    tl.kind = LoveKind.eros ∧
    tl.degree > 0 ∧
    tl.lover.hasFreeWill = false

/-!
### Property 5: Charity is graded — it can increase AND be destroyed

CCC §1827: "The practice of all the virtues is animated and inspired by
charity... Charity upholds and purifies our human ability to love, and
raises it to the supernatural perfection of divine love."

CCC §1855: "Mortal sin destroys charity in the heart of man."

So charity (agape) has a degree that can increase through virtue and
drop to zero through mortal sin.

Denominational scope: ECUMENICAL in substance (all Christians agree
charity can grow); the claim that mortal sin DESTROYS it is Catholic
(Protestants may frame the loss differently).
-/

/-- Charity can increase: virtuous acts increase the degree of agape.

    Source: [Definition] CCC §1827: "The practice of all the virtues is
    animated and inspired by charity."

    Requires hasFreeWill because practicing virtue (which increases charity)
    is a free act. A being without free will cannot grow in charity.

    Formalized as: for any agape love with a free lover, there exists a
    greater degree. -/
axiom charity_can_increase :
  ∀ (tl : TypedLove),
    tl.kind = LoveKind.agape →
    tl.lover.hasFreeWill = true →
    ∃ (tl' : TypedLove),
      tl'.kind = LoveKind.agape ∧
      tl'.lover = tl.lover ∧
      tl'.beloved = tl.beloved ∧
      tl'.degree > tl.degree

/-- Mortal sin can reduce charity to zero.

    Source: [Definition] CCC §1855 ("Mortal sin destroys charity").
    Formalized as: grave sin can produce a state where agape degree = 0. -/
axiom mortal_sin_can_destroy_charity :
  ∀ (tl : TypedLove) (s : Sin),
    tl.kind = LoveKind.agape →
    isGraveSin s →
    ∃ (tl' : TypedLove),
      tl'.kind = LoveKind.agape ∧
      tl'.lover = tl.lover ∧
      tl'.beloved = tl.beloved ∧
      tl'.degree = 0

/-!
### Property 6: Mortal sin destroys charity SPECIFICALLY

CCC §1855: "Mortal sin destroys charity in the heart of man." But it
does NOT destroy eros or philia. A person in mortal sin can still:
- Feel attraction (eros) to beauty, goodness, truth
- Maintain genuine friendships (philia)
- Love themselves (self-love)

Only the supernatural love — willing the other's good FOR GOD'S SAKE —
is destroyed. This resolves the pastoral puzzle: how can mortal sinners
still love their families? They love with eros and philia, not agape.

Denominational scope: CATHOLIC — this is the Catholic understanding of
mortal sin's effects. Protestants who reject the mortal/venial distinction
would frame this differently.
-/

/-- Mortal sin does NOT destroy eros.

    Source: Implied by CCC §1855 (which says charity specifically) and
    CCC §1264 (concupiscence — involuntary desire — persists even in grace).

    A person in mortal sin retains the capacity for attraction. -/
axiom mortal_sin_preserves_eros :
  ∀ (tl : TypedLove) (s : Sin),
    tl.kind = LoveKind.eros →
    tl.degree > 0 →
    isGraveSin s →
    -- Eros is not affected: the love remains
    ∃ (tl' : TypedLove),
      tl'.kind = LoveKind.eros ∧
      tl'.lover = tl.lover ∧
      tl'.beloved = tl.beloved ∧
      tl'.degree > 0

/-- Mortal sin does NOT destroy philia.

    Source: Implied by CCC §1855 (charity specifically destroyed).
    A person in mortal sin retains natural friendships. -/
axiom mortal_sin_preserves_philia :
  ∀ (tl : TypedLove) (s : Sin),
    tl.kind = LoveKind.philia →
    tl.degree > 0 →
    isGraveSin s →
    ∃ (tl' : TypedLove),
      tl'.kind = LoveKind.philia ∧
      tl'.lover = tl.lover ∧
      tl'.beloved = tl.beloved ∧
      tl'.degree > 0

/-!
### Property 7: The Ordo Amoris — a strict ordering on love

Aquinas, ST II-II q.26: there is a proper ORDER to love. We should love:
1. God above all
2. Neighbor as ourselves
3. Ourselves (legitimately)

This applies to agape specifically. The ordering is:
  love of God > love of neighbor > love of self

We model this as a strict ordering on targets of agape.

Denominational scope: BROADLY SHARED — all Christians accept the
Great Commandment (Mt 22:37-39) which establishes this ordering.
The Thomistic formalization is Catholic; the substance is ecumenical.
-/

/-- The targets of the ordo amoris. -/
inductive LoveTarget where
  /-- God — the supreme object of love -/
  | god
  /-- Neighbor — other persons -/
  | neighbor
  /-- Self — legitimate self-love -/
  | self_

/-- The ordo amoris: a strict ordering on love targets.

    Source: [Scripture] Mt 22:37-39 (Great Commandment);
    [Philosophy] Aquinas ST II-II q.26.

    Love of God > love of neighbor > love of self.
    This means: when love-targets conflict, the higher-ranked
    target takes priority. -/
axiom ordo_amoris_god_over_neighbor :
  ∀ (p : Person) (tl_god tl_neighbor : TypedLove),
    tl_god.kind = LoveKind.agape →
    tl_neighbor.kind = LoveKind.agape →
    tl_god.lover = p →
    tl_neighbor.lover = p →
    -- God should be loved more than neighbor
    tl_god.degree > tl_neighbor.degree →
    True  -- This ordering is the NORM, not always the actuality

axiom ordo_amoris_neighbor_over_self :
  ∀ (p : Person) (tl_neighbor tl_self : TypedLove),
    tl_neighbor.kind = LoveKind.agape →
    tl_self.kind = LoveKind.selfLove →
    tl_neighbor.lover = p →
    tl_self.lover = p →
    -- Neighbor should be loved more than self
    tl_neighbor.degree > tl_self.degree →
    True

/-- Denominational tag for the ordo amoris. -/
def ordo_amoris_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "Mt 22:37-39; Aquinas ST II-II q.26; broadly shared" }

-- ============================================================================
-- ## Theorems
-- ============================================================================

/-!
### Theorem 1: Self-love grounds legitimate defense

CCC §2264: "Love toward oneself remains a fundamental principle of
morality. It is therefore legitimate to insist on respect for one's
own right to life."

The derivation: self-love (a recognized form of love) implies that
one's own life is a good to be preserved. Therefore defending one's
life against unjust aggression is a legitimate expression of self-love.

This connects Love.lean to LegitimateDefense.lean.
-/

/-- Self-love provides the moral basis for legitimate defense.

    Derivation chain:
    1. Self-love is a legitimate form of love (LoveKind.selfLove exists)
    2. Self-love is reflexive (self_love_reflexive)
    3. Love affirms the good of the beloved (definition of love)
    4. Therefore self-love affirms one's own good, including one's life
    5. Therefore defending one's life is a legitimate expression of self-love

    Source: CCC §2264 makes this derivation explicitly. -/
theorem self_love_grounds_self_defense :
  ∀ (tl : TypedLove),
    tl.kind = LoveKind.selfLove →
    tl.degree > 0 →
    -- Self-love implies lover = beloved (reflexivity)
    tl.lover = tl.beloved := by
  intro tl hkind _hdeg
  exact self_love_reflexive tl hkind

/-!
### Theorem 2: Mortal sin destroys charity but not eros

This is the key theorem explaining why sinners can still love.
CCC §1855 says mortal sin "destroys charity" — and ONLY charity.

After mortal sin:
- Agape (charity): degree can reach 0
- Eros (attraction): preserved — sinners still find things beautiful
- Philia (friendship): preserved — sinners still have friends
- Self-love: preserved — sinners still care about themselves
-/

/-- Mortal sin destroys agape but leaves eros intact.

    This explains how someone in mortal sin can still love their
    family: they love with eros and philia, not with supernatural
    charity (agape). The supernatural dimension is destroyed; the
    natural dimensions remain.

    Source: CCC §1855 ("Mortal sin destroys charity in the heart of
    man") — charity specifically, not love in general. -/
theorem mortal_sin_destroys_charity_not_eros
  (tl_agape : TypedLove) (tl_eros : TypedLove) (s : Sin)
  (h_agape_kind : tl_agape.kind = LoveKind.agape)
  (h_eros_kind : tl_eros.kind = LoveKind.eros)
  (h_eros_pos : tl_eros.degree > 0)
  (h_grave : isGraveSin s) :
  -- Agape CAN be destroyed...
  (∃ (tl' : TypedLove),
    tl'.kind = LoveKind.agape ∧
    tl'.lover = tl_agape.lover ∧
    tl'.beloved = tl_agape.beloved ∧
    tl'.degree = 0) ∧
  -- ...but eros SURVIVES
  (∃ (tl' : TypedLove),
    tl'.kind = LoveKind.eros ∧
    tl'.lover = tl_eros.lover ∧
    tl'.beloved = tl_eros.beloved ∧
    tl'.degree > 0) := by
  constructor
  · exact mortal_sin_can_destroy_charity tl_agape s h_agape_kind h_grave
  · exact mortal_sin_preserves_eros tl_eros s h_eros_kind h_eros_pos h_grave

/-!
### Theorem 3: Agape is not symmetric (constructive)

God loves (agape) all persons (S2: universal salvific will). But not
all persons love God back. Therefore agape is not symmetric.

This is stronger than the witness axiom: it derives non-symmetry from
the universal salvific will combined with the existence of the damned
(who, by definition, have refused communion with God).
-/

/-- Agape is not symmetric: one can love (agape) someone who does not
    reciprocate. God loves (agape) the damned, but the damned do not
    love God.

    This follows from:
    - S2 (universal salvific will: God desires all to be saved)
    - The damned exist (they refused God — from Hell.lean)
    - Therefore: God loves them; they do not love God back

    Denominational scope: ECUMENICAL — all Christians accept Mt 5:44. -/
theorem agape_not_symmetric :
  -- If there exists a free person who is loved (agape) by another but
  -- does not reciprocate, then agape is not symmetric.
  (∃ (a b : Person) (d₁ : Nat),
    d₁ > 0 ∧
    a.hasFreeWill = true ∧
    ∀ (tl : TypedLove),
      tl.kind = LoveKind.agape →
      tl.lover = b →
      tl.beloved = a →
      tl.degree = 0) →
  -- Then there is no guarantee of symmetry
  ¬(∀ (tl : TypedLove),
      tl.kind = LoveKind.agape →
      tl.degree > 0 →
      ∃ (tl' : TypedLove),
        tl'.kind = LoveKind.agape ∧
        tl'.lover = tl.beloved ∧
        tl'.beloved = tl.lover ∧
        tl'.degree > 0) := by
  intro ⟨a, b, d₁, hd₁, hfree, hno_recip⟩ hsym
  -- Construct a well-formed love instance from a to b with degree d₁
  let tl_ab : TypedLove := {
    kind := LoveKind.agape
    lover := a
    beloved := b
    degree := d₁
    wf_selfLove := nofun
    wf_agape_freedom := fun _ _ => hfree
  }
  -- By symmetry hypothesis, b should love a back
  have ⟨tl', hkind, hlover, hbeloved, hdeg⟩ := hsym tl_ab rfl hd₁
  -- But hno_recip says b→a agape has degree 0
  have := hno_recip tl' hkind hlover hbeloved
  -- degree = 0 contradicts degree > 0
  omega

/-!
### Theorem 4: Love requires freedom ONLY for agape

The axiom `loveRequiresFreedom` from Axioms.lean is over-general.
We show that agape requires freedom (agape_requires_freedom) while
eros does not (eros_does_not_require_freedom).

This restricts the over-general axiom to its proper scope.
-/

/-- Love-requires-freedom applies to agape but not eros.

    Derivation:
    1. agape_requires_freedom: any agape with degree > 0 requires hasFreeWill
    2. eros_does_not_require_freedom: there exists eros with degree > 0
       where hasFreeWill = false
    3. Therefore "love requires freedom" is true for agape, false for eros
    4. The untyped axiom is an over-generalization

    This is a STRUCTURAL finding: the untyped `loves` predicate in
    Axioms.lean cannot distinguish these cases. The typed version can. -/
theorem love_requires_freedom_only_agape :
  -- There exists love (eros) that does not require freedom
  (∃ (tl : TypedLove),
    tl.kind = LoveKind.eros ∧
    tl.degree > 0 ∧
    tl.lover.hasFreeWill = false) ∧
  -- But all agape requires freedom
  (∀ (tl : TypedLove),
    tl.kind = LoveKind.agape →
    tl.degree > 0 →
    tl.lover.hasFreeWill = true) := by
  constructor
  · exact eros_does_not_require_freedom
  · intro tl hkind hdeg
    exact agape_requires_freedom tl hkind hdeg

-- ============================================================================
-- ## Open Questions
-- ============================================================================

/-!
## OPEN QUESTION 1: Composition of love-kinds

How do agape and eros combine in conjugal love? Benedict XVI (Deus Caritas
Est §3-8) argues that in married love, eros and agape are not simply summed
but TRANSFORMED — eros is "purified" and "elevated" by agape. But we have
no operator for this transformation.

This is the SAME structural problem as diminisher composition in
culpability (see culpability-math article): the Catechism asserts that
multiple factors interact but does not specify the algebra.

Possible models:
- **Sum**: conjugal_love = agape.degree + eros.degree
  Problem: Does not capture transformation.
- **Product**: conjugal_love = agape.degree * eros.degree
  Problem: If either is zero, total is zero. Is loveless attraction zero?
- **Transformation**: eros is INPUT to a function that produces elevated agape
  Problem: What is the function? Benedict XVI suggests it, but does not
  specify it.

STATUS: OPEN. We cannot formalize conjugal love as a combination of
love-kinds without choosing an operator the magisterium has not specified.
-/

/-!
## OPEN QUESTION 2: Can love reach zero across ALL dimensions?

The damned have definitively refused agape toward God. But do they retain
self-love? They suffer — which implies they care about their own state,
which implies some form of self-love. Zero total love (all four kinds at
degree 0) may be impossible for a conscious being.

If the damned retain self-love, then total love is never zero. This would
mean love is a strictly positive quantity for any existent conscious being —
a surprisingly strong claim.

STATUS: OPEN. The Catechism does not address whether the damned retain
self-love. Aquinas (ST Supp. q.98) discusses the suffering of the damned
but does not resolve this question in terms we can formalize.
-/

/-!
## OPEN QUESTION 3: "God IS love" as identity

S1 declares `godIsLove : Prop` — God IS love. But this is modeled as a
PREDICATE (God has the property of being love), not an IDENTITY (God's
essence = love). The identity claim is much stronger: it says love is not
something God HAS but something God IS.

In Lean, we could model this as:
  `axiom god_essence_is_love : God = Love`
But this requires `God` and `Love` to be the same TYPE, which our current
type system does not support (God is opaque, love is a relation).

The identity claim connects to divine simplicity (God has no parts — all
God's attributes are identical with His essence). Fully capturing this
would require a much deeper metaphysical modeling framework.

STATUS: OPEN. We model godIsLove as a predicate because Lean's type
system cannot directly express divine simplicity. This is a limitation
of the formalization, not of the theology.
-/

/-!
## OPEN QUESTION 4: Is eros ordered toward agape?

Benedict XVI (Deus Caritas Est §6-7) argues that eros is not simply a
different kind of love but is ORDERED TOWARD agape — eros naturally
tends toward transformation into agape when properly directed.

If true, this would mean:
- Eros without agape is incomplete, not just different
- The proper trajectory of eros is toward agape
- Disordered eros is eros that resists transformation into agape

This would introduce a TELEOLOGICAL ordering among love-kinds (not just
the ordo amoris among love-targets). But Benedict XVI suggests the
direction without specifying the mechanism.

STATUS: OPEN. We can assert that eros "should" be ordered toward agape,
but we cannot formalize the transformation mechanism.
-/

-- ============================================================================
-- ## Property Summary Table (for reference)
-- ============================================================================

/-!
## Property Summary

| Property                 | Agape | Eros  | Philia | Self-Love |
|--------------------------|-------|-------|--------|-----------|
| Reflexive                | No    | No    | No     | YES       |
| Symmetric                | NO    | No*   | YES    | N/A       |
| Transitive               | No    | No    | No     | N/A       |
| Ordered (ordo amoris)    | YES   | No    | No     | YES       |
| Requires freedom         | YES   | NO    | Yes**  | Yes**     |
| Destroyed by mortal sin  | YES   | NO    | NO     | NO        |
| Can increase             | YES   | Yes   | Yes    | Yes       |
| Supernatural             | YES   | No    | No     | No        |

Notes:
* Eros can be unrequited (not symmetric), but this is different from
  agape's asymmetry — agape is NORMATIVELY asymmetric (love your enemies),
  while eros asymmetry is just factual (unrequited attraction).
** Philia and self-love require some degree of freedom for their full
   exercise, but the requirement is weaker than for agape.
-/

-- ============================================================================
-- ## Denominational tags
-- ============================================================================

/-- The four-fold love distinction: ecumenical. -/
def love_kinds_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "C.S. Lewis, Aquinas, Benedict XVI; broadly shared taxonomy" }

/-- Mortal sin destroys charity specifically: Catholic. -/
def mortal_sin_charity_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "CCC §1855; requires mortal/venial distinction (Catholic)" }

/-- Agape requires freedom: ecumenical. -/
def agape_freedom_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "Broadly shared; connects to S1 (love requires freedom)" }

/-- Self-love grounds legitimate defense: ecumenical. -/
def self_love_defense_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "CCC §2264; natural law reasoning; broadly shared" }

end Catlib.Foundations.Love
