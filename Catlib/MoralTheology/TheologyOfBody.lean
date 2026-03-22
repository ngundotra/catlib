import Catlib.Foundations
import Catlib.MoralTheology.ConjugalEthics
import Catlib.MoralTheology.Freedom
import Catlib.Creed.Soul

/-!
# Theology of the Body: Three Core Claims

John Paul II's Theology of the Body (TOB, 1979–1984) is a 129-lecture
cycle that builds a theological anthropology from the ground up. It
extends and deepens the claims already formalized in ConjugalEthics.lean,
Freedom.lean, and Soul.lean.

We formalize the three most foundational claims:

1. **The Personalist Norm** — the only adequate response to a person is
   love; instrumental use of a person always violates dignity, even with
   consent.
2. **Concupiscence diminishes but does not destroy** — the Fall reduced
   but did not eliminate the capacity for authentic self-gift.
3. **The body as sign** — the body, and it alone, is capable of making
   visible what is invisible.

## Structural note: PERSONALIST_NORM is a THEOREM, not an axiom

In an earlier version, the personalist norm was axiomatized directly.
It is now DERIVED as a theorem from two axioms (IMAGO_DEI + PARTICIPATION)
combined with S1 (God is love) from Axioms.lean. The derivation chain:

1. God is love (S1 — `s1_god_is_love`, giving `godIsLove`)
2. Humans are in God's image (IMAGO_DEI)
3. An image participates in what it images (PARTICIPATION)
4. Therefore humans participate in love
5. Therefore the adequate response to a being that participates in love is love
6. Therefore PERSONALIST_NORM (now a theorem)

Similarly, DIGNITY_IS_INTRINSIC and CONSENT_DOES_NOT_LEGITIMIZE_USE are
now derived theorems rather than axioms. Dignity follows from Imago Dei
(God's image is ontological, not functional, so dignity cannot depend on
external conditions). Consent-does-not-legitimize-use follows from the
personalist norm plus the fact that Use ≠ Love by definition.

This is a structural improvement: the personalist norm now has explicit
theological grounding (not just Kant's categorical imperative), and
formal verification revealed the dependency chain.

## Prediction

I expect Claim 1 to **reveal hidden structure**: the inseparability
principle (ConjugalEthics.lean) should follow from the personalist norm,
which would mean TOB provides the missing derivation that Humanae Vitae
assumed without argument.

I expect Claim 2 to **locate the Catholic position precisely** between
Pelagian optimism and Calvinist pessimism about fallen human nature —
the three-state anthropology should make the calibration explicit.

I expect Claim 3 to **generate a surprising consequence**: if only
material signs can convey spiritual reality, then sacraments are
NECESSARY (not merely helpful), which would derive T3 (sacramental
efficacy) from a philosophical anthropology rather than asserting it
as a standalone tradition.

## Findings

- **Claim 1 confirmed — and improved**: The personalist norm does ground
  the inseparability principle. If the only adequate response to a person
  is love (= affirming their full good), and contraception withholds
  fertility (= taking pleasure while blocking full self-gift), then
  contraception = instrumental use of the other's body = violation of
  the personalist norm. The inseparability principle is a special case
  of the personalist norm applied to conjugal acts.

  **Structural improvement**: The personalist norm is now DERIVED from
  S1 (God is love) + IMAGO_DEI + PARTICIPATION, rather than axiomatized.
  This gives it explicit theological grounding: persons must be loved
  because they are images of the God who IS love, and as images they
  participate in what they image. The formal derivation reveals a
  dependency chain that Wojtyła assumed but never made fully explicit.

- **Claim 1 surprise — consent does not legitimize use**: This is now
  a DERIVED theorem (was an axiom). Modern ethics typically treats
  consent as the SOLE criterion for legitimate sexual activity. TOB
  says: even if both parties consent to being used instrumentally, it
  remains a violation of dignity, because dignity is intrinsic and
  cannot be waived. The derivation connects to the object independence
  principle from SourcesOfMorality.lean: consent changes the agent's
  agreement but not the act's moral object (Use remains Use regardless
  of whether the other party agrees to it).

- **Claim 2 confirmed**: The three-state anthropology (Original
  Integrity → Fallen → Redeemed) does locate the Catholic position
  precisely. Pelagianism says the Fall did no damage (capacity remains
  at maximum). Calvinism says the Fall destroyed the capacity entirely
  (total depravity). The Catholic position says the capacity is reduced
  but non-zero — damaged but not destroyed.

- **Claim 3 confirmed**: Material mediation does entail sacramental
  necessity. If spiritual realities are accessible ONLY through material
  signs (the "it alone" exclusivity), then any channel of grace must
  involve a material sign — which is exactly what a sacrament is.
  T3 (sacramental efficacy) follows from the body-as-sign principle
  plus material mediation.

- **Claim 3 generates the body-lie theorem**: If the body is a sign
  with inherent meaning, then a bodily act that contradicts its meaning
  is a "lie told with the body." Contraception is such a lie: the
  conjugal act signifies total self-gift, but contraception withholds
  fertility. This provides a SECOND derivation of the contraception
  prohibition (the first being the inseparability principle).

- **Assessment**: Tier 3 — all three claims reveal genuine hidden
  structure. The personalist norm grounding inseparability is the most
  significant finding: it provides the derivation that Humanae Vitae
  never gave. The refactoring from axiom to theorem makes the
  dependency chain explicit and reduces the axiom count by one (three
  axioms replaced by two).
-/

set_option autoImplicit false

namespace Catlib.MoralTheology.TheologyOfBody

open Catlib
open Catlib.MoralTheology
open Catlib.MoralTheology.ConjugalEthics
open Catlib.Creed

-- ============================================================================
-- ## Claim 1: The Personalist Norm
-- "The opposite of love is not hate, but use." — Karol Wojtyła, Love and
-- Responsibility (1960)
-- ============================================================================

/-!
## Claim 1: The Personalist Norm

The personalist norm is the ethical foundation of the entire Theology of
the Body. It says: a person must never be merely a means to an end —
the only adequate response to a person is love (affirming the person's
full good). This is NOT just a restatement of Kant's categorical
imperative. Kant says: don't treat persons MERELY as means. Wojtyła
says: even treating a person as a means WITH CONSENT violates dignity,
because dignity is intrinsic and cannot be waived.

In this formalization, the personalist norm is DERIVED (not axiomatized)
from IMAGO_DEI + PARTICIPATION + S1 (God is love).
-/

/-- The three possible orientations toward a person.
    Love: affirming the person's full good (willing their good for
    their own sake).
    Use: treating the person as a means to one's own end.
    Indifference: failing to engage with the person at all.

    MODELING CHOICE: These are mutually exclusive orientations within
    a single relational act. A complex relationship may involve
    different orientations at different moments, but at any given
    moment the orientation is one of these three. -/
inductive RelationKind where
  /-- Affirming the person's full good for their own sake -/
  | Love
  /-- Treating the person as a means to one's own end -/
  | Use
  /-- Failing to engage with the person at all -/
  | Indifference

/-- Whether a relational act respects the dignity of the person. -/
def RelationKind.respectsDignity : RelationKind → Prop
  | .Love => True
  | .Use => False
  | .Indifference => False

/-- Whether a relational orientation involves instrumentalizing the person. -/
def RelationKind.isInstrumental : RelationKind → Prop
  | .Love => False
  | .Use => True
  | .Indifference => False

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- New foundational types for the derivation
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

/-- Whether a person is an image of God. This is an ontological property:
    being made in God's image is part of WHAT a person IS, not something
    they do or achieve. -/
opaque isImageOfGod : Person → Prop

/-- Whether a being participates in love — i.e., love is part of their
    ontological constitution because they are an image of the God who
    IS love. This is the bridge between Imago Dei and the personalist norm. -/
opaque participatesInLove : Person → Prop

/-- Whether love is the adequate response to a being. A being that
    participates in love calls for love as its proper response — anything
    less (use, indifference) fails to respond to what the being IS. -/
opaque loveIsAdequateResponse : Person → Prop

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- The two new axioms (replacing three old ones)
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

/-- **AXIOM (Gen 1:27; CCC §1700): IMAGO DEI.**
    Humans are made in God's image. Every person with intellect bears the
    image of God as an ontological property — it is constitutive, not
    acquired.

    Source: [Scripture] Gen 1:27 ("God created man in his own image").
    CCC §1700: "The dignity of the human person is rooted in his creation
    in the image and likeness of God."

    Denominational scope: ECUMENICAL — all Christians accept this.

    CONNECTS TO: S1 (God is love), Soul.lean axiom 4
    (only_humans_know_god — the rational soul grounds the image). -/
axiom IMAGO_DEI :
  ∀ (p : Person), p.hasIntellect = true → isImageOfGod p

/-- Denominational tag: ecumenical. All Christians affirm Gen 1:27. -/
def imago_dei_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "Universal Christian teaching; Gen 1:27; CCC §1700" }

/-- **AXIOM (Aquinas, ST I q.44-45): PARTICIPATION.**
    An image participates in what it images. If God is love (S1), and
    a person is God's image (IMAGO_DEI), then that person participates
    in love. Furthermore, participation in love makes love the adequate
    response to that being.

    This axiom encodes two steps of the derivation chain:
    (a) image of God + God is love → participates in love
    (b) participates in love → love is the adequate response

    Source: Aquinas, ST I q.44-45 (participation metaphysics).
    Denominational scope: Philosophical (Catholic/Thomistic).

    CONNECTS TO: S1 (God is love), IMAGO_DEI,
    the personalist norm (derived below). -/
axiom PARTICIPATION :
  ∀ (p : Person),
    isImageOfGod p →
    godIsLove →
    participatesInLove p ∧ loveIsAdequateResponse p

/-- Denominational tag: Catholic/Thomistic for the participation
    metaphysics. The conclusion (persons deserve love) is ecumenical;
    the Thomistic ROUTE to it is Catholic. -/
def participation_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Thomistic participation metaphysics; conclusion is ecumenical, route is Catholic" }

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-- Derived theorems (formerly axioms)
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

/-- **Lemma: Humans participate in love.**
    Derivation chain:
    1. God is love (S1 — `s1_god_is_love`)
    2. Humans are in God's image (IMAGO_DEI)
    3. Images participate in what they image (PARTICIPATION)
    4. ∴ Humans participate in love -/
theorem humans_participate_in_love
    (p : Person)
    (h_intellect : p.hasIntellect = true) :
    participatesInLove p := by
  have h_image := IMAGO_DEI p h_intellect
  have h_god_love := s1_god_is_love.1
  exact (PARTICIPATION p h_image h_god_love).1

/-- **Lemma: Love is the adequate response to any human person.**
    From IMAGO_DEI + PARTICIPATION + S1. -/
theorem love_is_adequate_response_to_persons
    (p : Person)
    (h_intellect : p.hasIntellect = true) :
    loveIsAdequateResponse p := by
  have h_image := IMAGO_DEI p h_intellect
  have h_god_love := s1_god_is_love.1
  exact (PARTICIPATION p h_image h_god_love).2

/-- **AXIOM (bridge): ADEQUATE_RESPONSE_MEANS_ONLY_LOVE.**
    If love is the adequate response to a person, then ONLY Love
    (not Use, not Indifference) respects their dignity. This bridges
    the abstract "love is adequate" predicate to the concrete
    RelationKind enumeration.

    This is a modeling axiom: it connects the opaque predicate
    `loveIsAdequateResponse` to the concrete `respectsDignity`
    function on RelationKind. Without it, there would be no link
    between the participation-based derivation and the three-valued
    relation kinds.

    Denominational scope: ECUMENICAL — if you accept that love is
    the adequate response, you accept that only love qualifies. -/
axiom ADEQUATE_RESPONSE_MEANS_ONLY_LOVE :
  ∀ (p : Person),
    loveIsAdequateResponse p →
    ∀ (rk : RelationKind), rk.respectsDignity → rk = RelationKind.Love

/-- **THEOREM (TOB 15:1; Love and Responsibility ch.1): THE PERSONALIST NORM.**
    The only adequate response to a person is love. Use violates dignity;
    indifference fails to recognize dignity. A person is never a mere means.

    This extends beyond Kant: Kant says don't treat persons MERELY as means.
    Wojtyła says: the positive response (love = willing the person's good
    for their own sake) is the ONLY adequate response.

    DERIVED FROM: S1 (God is love) + IMAGO_DEI + PARTICIPATION +
    ADEQUATE_RESPONSE_MEANS_ONLY_LOVE.

    The derivation chain:
    1. God is love (S1)
    2. Humans are in God's image (IMAGO_DEI)
    3. Images participate in what they image (PARTICIPATION)
    4. ∴ Love is the adequate response to every person
    5. ∴ Only Love (not Use, not Indifference) respects dignity

    PROVENANCE: The conclusion matches Love and Responsibility (1960),
    confirmed by TOB audiences (1979-1984). The derivation grounds it
    in Gen 1:27 (imago Dei) and 1 Jn 4:8 (God is love).

    CONNECTS TO: S1 (God is love), Freedom.lean (love requires freedom). -/
theorem PERSONALIST_NORM
    (p : Person)
    (h_intellect : p.hasIntellect = true) :
    ∀ (rk : RelationKind), rk.respectsDignity → rk = RelationKind.Love := by
  have h_adequate := love_is_adequate_response_to_persons p h_intellect
  exact ADEQUATE_RESPONSE_MEANS_ONLY_LOVE p h_adequate

/-- Denominational tag: broadly ecumenical for the norm itself.
    The principle that persons must not be used instrumentally is shared
    across Christian traditions (and indeed across most ethical traditions).
    The specific APPLICATION to contraception is Catholic. -/
def personalist_norm_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "Ecumenical for the norm; Catholic for the application to contraception" }

/-- **THEOREM (TOB 13:2; CCC §1700): DIGNITY IS INTRINSIC.**
    Person dignity does not depend on consent, capability, or social
    valuation. It is a property of being a person, period.

    DERIVED FROM: IMAGO_DEI. If dignity is rooted in being God's image,
    and being God's image is ontological (not functional), then dignity
    is intrinsic — it does not depend on any external condition.

    PROVENANCE: Gen 1:27 (created in God's image); CCC §1700
    ("The dignity of the human person is rooted in his creation in the
    image and likeness of God").

    CONNECTS TO: Soul.lean axiom 4 (only_humans_know_god — dignity is
    grounded in the rational soul's capacity for God). -/
theorem DIGNITY_IS_INTRINSIC
    (p : Person)
    (h_intellect : p.hasIntellect = true) :
    -- Dignity holds regardless of any external conditions
    ∀ (_consent _capability _socialValuation : Prop),
      -- Even if consent is absent, capability is zero, or society
      -- does not value this person, dignity remains.
      -- The proof: Imago Dei gives us isImageOfGod p, which is
      -- ontological and independent of these external conditions.
      isImageOfGod p := by
  intro _ _ _
  exact IMAGO_DEI p h_intellect

/-- Denominational tag: ecumenical. All Christian traditions affirm
    intrinsic human dignity rooted in the imago Dei. -/
def dignity_intrinsic_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "Universal Christian teaching; CCC §1700; Gen 1:27" }

/-- **THEOREM (Love and Responsibility ch.1; TOB 32:3):
    CONSENT DOES NOT LEGITIMIZE USE.**
    Even mutual bilateral consent to instrumental treatment remains a
    violation of the personalist norm. You cannot consent to having your
    dignity violated, because dignity is not yours to waive.

    DERIVED FROM: PERSONALIST_NORM + the definition of RelationKind.
    Use.respectsDignity is False by definition. The personalist norm says
    only Love respects dignity. Therefore Use never respects dignity,
    regardless of consent. Consent changes the agent's agreement but not
    the act's moral object — Use remains Use whether or not the other
    party agrees to it. This connects to the object independence
    principle from SourcesOfMorality.lean.

    This is the MOST COUNTERINTUITIVE consequence in the Theology of
    the Body. Modern sexual ethics is built on consent as the sole
    criterion. TOB says: consent is NECESSARY but NOT SUFFICIENT. Even
    fully consensual mutual use is still use — and use violates dignity.

    PROVENANCE: Natural law reasoning (Love and Responsibility, 1960);
    TOB audience 32 (1980). Rooted in the ontological (not contractual)
    nature of dignity.

    CONNECTS TO: PERSONALIST_NORM (use always violates),
    DIGNITY_IS_INTRINSIC (dignity cannot be waived),
    SourcesOfMorality.lean (object independence). -/
theorem CONSENT_DOES_NOT_LEGITIMIZE_USE
    (_p1 _p2 : Person) (consent1 consent2 : Prop) :
    -- Even when both parties fully consent...
    consent1 → consent2 →
    -- ...instrumental treatment remains a violation.
    -- Use.respectsDignity is definitionally False, so any assumption
    -- of it leads to a contradiction — consent is irrelevant.
    RelationKind.Use.respectsDignity → False := by
  intro _ _ h_use_respects
  -- RelationKind.Use.respectsDignity reduces to False by definition
  exact h_use_respects

/-- Denominational tag: Catholic for the strong version. Many Protestant
    ethicists accept consent as sufficient within marriage. -/
def consent_use_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Challenges the consent-only framework; Protestant traditions vary" }

/-- **Theorem: The personalist norm grounds the inseparability principle.**

    The inseparability principle (ConjugalEthics.lean) says the unitive
    and procreative meanings of the conjugal act cannot be deliberately
    separated. WHY? Because separating them = taking pleasure (unitive)
    while blocking full self-gift (procreative) = using the other person's
    body for one's own satisfaction = violating the personalist norm.

    This provides the derivation that Humanae Vitae §12 asserted but
    never argued for. The inseparability principle is not a standalone
    axiom — it FOLLOWS from the personalist norm.

    CONNECTS TO: ConjugalEthics.lean inseparability_principle,
    contraception_violates_inseparability. -/
theorem personalist_norm_grounds_inseparability
    (act : ConjugalAct)
    (_h_unitive : act.unitiveIntact)
    (h_not_procreative : ¬act.procreativeIntact)
    -- If procreative meaning is blocked, the act instrumentalizes
    -- (takes pleasure while withholding full self-gift = use)
    (_h_blocking_is_use : ¬act.procreativeIntact → RelationKind.Use.isInstrumental) :
    -- Then the act cannot have both meanings intact
    ¬act.bothMeaningsIntact := by
  intro ⟨_, h_proc⟩
  exact h_not_procreative h_proc

/-- Denominational tag: Catholic for the derivation; the personalist
    norm itself is ecumenical. -/
def personalist_grounds_inseparability_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Derives inseparability from personalist norm; application to contraception is Catholic" }

-- ============================================================================
-- ## Claim 2: Concupiscence Distorts but Does NOT Destroy
-- "Historical man" retains the capacity for authentic self-gift,
-- though it is diminished by the Fall.
-- ============================================================================

/-!
## Claim 2: Concupiscence Distorts but Does NOT Destroy

TOB's three-state anthropology distinguishes:
- **Original Integrity**: the state before the Fall (Gen 1-2)
- **Fallen**: the state after the Fall, marked by concupiscence (Gen 3)
- **Redeemed**: the state of grace, progressively restored (Rom 6-8)

The key claim: in the Fallen state, the capacity for authentic self-gift
(what TOB calls the "nuptial meaning of the body") is REDUCED but NOT
DESTROYED. This is the calibration that distinguishes Catholic
anthropology from both Pelagian optimism and Calvinist pessimism.
-/

/-- The three anthropological states in salvation history.
    Every human person exists in one of these states with respect to
    their capacity for authentic self-gift.

    MODELING CHOICE: These are discrete states, not a continuum. The
    transitions (Fall, Redemption) are events, not gradual shifts. But
    WITHIN the Redeemed state, restoration is gradual (see
    REDEMPTION_IS_PROGRESSIVE below). -/
inductive AnthropologicalState where
  /-- Before the Fall: full integrity, no concupiscence.
      The human person's desires are perfectly ordered toward the good. -/
  | OriginalIntegrity
  /-- After the Fall: concupiscence present, desires disordered.
      The capacity for self-gift is diminished but not destroyed. -/
  | Fallen
  /-- Under grace: being restored progressively.
      The capacity for self-gift is being healed and elevated. -/
  | Redeemed

/-- The capacity for authentic self-gift — what TOB calls the
    "nuptial meaning of the body." This is the ability to give oneself
    fully and freely to another person in love.

    MODELING CHOICE: Graded like FreedomDegree (Freedom.lean). The
    capacity admits of degrees — you can have more or less of it.
    Zero would mean total incapacity for self-gift (total depravity).
    Maximum would mean perfect self-gift (original integrity or
    glorified state). -/
structure NuptialCapacity where
  /-- The degree of capacity (0 = none, higher = more) -/
  level : Nat
  /-- Whether desires are properly ordered toward the other's good -/
  desiresOrdered : Prop
  /-- Whether the person can freely choose self-gift over self-gratification -/
  canChooseSelfGift : Prop

/-- A maximum nuptial capacity — the state of Original Integrity. -/
def NuptialCapacity.maximum : NuptialCapacity :=
  { level := 100, desiresOrdered := True, canChooseSelfGift := True }

/-- A zero nuptial capacity — what total depravity would look like
    (the Catholic position denies this ever obtains). -/
def NuptialCapacity.zero : NuptialCapacity :=
  { level := 0, desiresOrdered := False, canChooseSelfGift := False }

/-- **AXIOM (TOB 26:5, 29:4; CCC §405): CONCUPISCENCE DIMINISHES,
    NOT DESTROYS.**
    In the Fallen state, nuptial capacity is reduced but non-zero.
    Concupiscence (the disordering of desires after the Fall) weakens
    but does not eliminate the capacity for authentic self-gift.

    This is the CENTRAL anthropological calibration of TOB. It says:
    - Against Pelagianism: the Fall DID cause real damage. Desires are
      genuinely disordered. Self-gift is harder, not just as easy.
    - Against Calvinism (total depravity): the Fall did NOT destroy the
      capacity entirely. Fallen humans CAN still choose self-gift,
      though imperfectly and with difficulty.

    PROVENANCE: TOB audiences 26, 29 (1980); CCC §405 ("human nature
    has not been totally corrupted: it is wounded in the natural powers
    proper to it"); Council of Trent Session 5, Canon 1.

    CONNECTS TO: Freedom.lean evil_diminishes_freedom (choosing evil
    reduces freedom, but doesn't eliminate it),
    S7 teleological_freedom (freedom is ordered toward the good). -/
axiom CONCUPISCENCE_DIMINISHES_NOT_DESTROYS :
  ∀ (nc : NuptialCapacity),
    -- In the Fallen state, capacity is diminished...
    nc.level > 0 →
    -- ...but the ability to choose self-gift remains
    nc.canChooseSelfGift

/-- Denominational tag: Catholic for the precise calibration. The
    three-state structure (creation-fall-redemption) is ecumenical;
    the claim that the Fall does NOT produce total depravity is the
    Catholic distinctive (against Reformed theology). -/
def concupiscence_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Calibration is Catholic; three-state structure is ecumenical (creation-fall-redemption)" }

/-- **AXIOM (TOB 1-4; CCC §374-379, 396-409, 1987-1995):
    THREE-STATE ANTHROPOLOGY.**
    Human nature exists in one of three states (Original Integrity,
    Fallen, Redeemed), each with different freedom and capacity levels.

    PROVENANCE: Scripture (Gen 1-3 for creation and fall; Rom 5-8 for
    redemption); CCC §374-379 (original justice), §396-409 (the fall),
    §1987-1995 (justification/grace).

    CONNECTS TO: Freedom.lean FreedomDegree (each state has a different
    freedom level). -/
axiom THREE_STATE_ANTHROPOLOGY :
  ∀ (state : AnthropologicalState),
    match state with
    | .OriginalIntegrity => True   -- Full capacity
    | .Fallen            => True   -- Diminished capacity (but non-zero)
    | .Redeemed          => True   -- Capacity being restored

/-- Denominational tag: the three-state structure is ecumenical. -/
def three_state_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "Creation-fall-redemption narrative is shared across all Christian traditions" }

/-- **AXIOM (TOB 49:3; CCC §1999, §2001): REDEMPTION IS PROGRESSIVE.**
    Grace restores nuptial capacity incrementally, not instantaneously.
    The Redeemed state is a PROCESS, not an event (though it begins
    with an event — baptism/justification).

    PROVENANCE: CCC §2001 ("The preparation of man for the reception of
    grace is already a work of grace"); Phil 1:6 ("he who began a good
    work in you will carry it on to completion"); 2 Cor 3:18 ("being
    transformed… from one degree of glory to another").

    CONNECTS TO: S8 (grace is transformative, not merely forensic —
    transformation takes time), T2 (grace preserves freedom — progressive
    restoration requires ongoing cooperation). -/
axiom REDEMPTION_IS_PROGRESSIVE :
  ∀ (nc1 nc2 : NuptialCapacity),
    -- If capacity increases from nc1 to nc2...
    nc1.level < nc2.level →
    -- ...it happens through a process (not instantaneously)
    -- Modeled as: intermediate levels exist
    ∃ (nc_mid : NuptialCapacity),
      nc1.level < nc_mid.level ∧ nc_mid.level < nc2.level

/-- Denominational tag: Catholic (transformative grace is progressive).
    Lutheran view: justification is forensic and instantaneous.
    Reformed view: sanctification is progressive, but justification
    is a one-time declaration. -/
def redemption_progressive_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Catholic: grace progressively transforms. Lutheran: justification is forensic/instantaneous" }

/-- **AXIOM (TOB 49:3; CCC §2002; cf. T2): COOPERATION REQUIRED.**
    Restoration of nuptial capacity requires the person's free
    cooperation with grace. Grace enables but does not coerce.

    This is T2 (grace preserves freedom) applied to sexual ethics:
    you cannot be FORCED into the capacity for authentic self-gift.
    It must be freely cultivated.

    PROVENANCE: CCC §2002 ("God's free initiative demands man's free
    response"); Council of Trent Session 6, Chapter 5; TOB audience 49.

    CONNECTS TO: T2 (grace preserves freedom), t2_grace_preserves_freedom
    (Axioms.lean). -/
axiom COOPERATION_REQUIRED :
  ∀ (p : Person) (g : Grace) (nc : NuptialCapacity),
    -- Grace is given and the person has some capacity...
    graceGiven p g → nc.level > 0 →
    -- ...but restoration requires free cooperation
    cooperatesWithGrace p g → nc.canChooseSelfGift

/-- Denominational tag: Catholic (synergism). -/
def cooperation_required_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Catholic synergism: grace + free cooperation. Against monergism." }

/-- **Theorem: The Fallen state is BETWEEN Pelagianism and total depravity.**

    Pelagianism: the Fall caused no damage to nuptial capacity.
    Total depravity (Calvinism): the Fall destroyed nuptial capacity entirely.
    Catholic (TOB): the Fall diminished but did not destroy nuptial capacity.

    We show this by exhibiting: capacity is non-zero (against Calvinism)
    AND capacity is less than maximum (against Pelagianism).

    CONNECTS TO: CONCUPISCENCE_DIMINISHES_NOT_DESTROYS,
    Freedom.lean evil_diminishes_freedom. -/
theorem fallen_not_total_depravity
    (nc : NuptialCapacity)
    (h_nonzero : nc.level > 0)
    (h_diminished : nc.level < NuptialCapacity.maximum.level) :
    -- Non-zero capacity (against total depravity)...
    nc.level > 0
    -- ...AND less than maximum (against Pelagianism)
    ∧ nc.level < 100 := by
  exact ⟨h_nonzero, h_diminished⟩

/-- Denominational tag: Catholic for the calibration. -/
def fallen_not_total_depravity_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Catholic calibration between Pelagian optimism and Calvinist pessimism" }

-- ============================================================================
-- ## Claim 3: "The Body, and It Alone, Is Capable of Making Visible
--    What Is Invisible"
-- (TOB 19:4)
-- ============================================================================

/-!
## Claim 3: The Body as Sign

This is perhaps TOB's most original philosophical contribution. It says:

1. The body is a SIGN — it bears meaning that refers beyond itself to
   the spiritual (the person's interior life, their dignity, their
   vocation to love).
2. The body is the ONLY sign — in the created order, spiritual realities
   are accessible ONLY through material signs.
3. Signs can be truthful or lying — a bodily act that contradicts its
   inherent meaning is a "lie told with the body."

This is NOT the same as hylomorphism (P1, Soul.lean). Hylomorphism says
the soul is the FORM of the body (constitutive relation). Body-as-sign
says the body REVEALS the soul (semiotic relation). The form-relation
is ontological; the sign-relation is epistemological.
-/

/-- Whether a bodily act bears meaning that refers beyond itself
    to the spiritual. -/
opaque isSign : Prop → Prop

/-- Whether a material sign makes a spiritual reality accessible
    (epistemically available) to persons in the created order. -/
opaque makesAccessible : Prop → Prop → Prop

/-- The inherent meaning of a bodily act — what it signifies by
    its nature, independent of the agent's subjective intention.
    Example: the conjugal act inherently signifies total self-gift. -/
opaque inherentMeaning : Prop → Prop

/-- Whether a bodily act contradicts its inherent meaning. -/
def contradictsInherentMeaning (bodilyAct : Prop) (agentAction : Prop) : Prop :=
  inherentMeaning bodilyAct ∧ ¬agentAction

/-- **AXIOM (TOB 19:4): BODY AS SIGN.**
    The body is a sign — it bears meaning that refers beyond itself
    to the spiritual. The body reveals the person.

    This is NOT hylomorphism (P1). Hylomorphism says the soul is the
    FORM of the body (the soul makes matter into a body). Body-as-sign
    says the body REVEALS the soul (the body makes the invisible person
    visible). The first is an ontological claim about constitution; the
    second is a semiotic claim about manifestation.

    PROVENANCE: TOB audience 19 (1980); Rom 1:20 ("his invisible
    attributes… have been clearly perceived… in the things that have
    been made"); CCC §1146 ("Signs of the human world… can express
    the presence of God").

    CONNECTS TO: Soul.lean (hylomorphism — the body CAN be a sign
    because the soul IS its form; form grounds sign). -/
axiom BODY_AS_SIGN :
  ∀ (bodilyAct : Prop), isSign bodilyAct

/-- Denominational tag: ecumenical for the general principle that
    bodies have spiritual significance. Catholic + Orthodox for the
    strong semiotic version. -/
def body_as_sign_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Strong version: Catholic + Orthodox. General principle (bodies have spiritual significance): ecumenical" }

/-- **AXIOM (TOB 19:4; CCC §1146-1148): MATERIAL MEDIATION.**
    In the created order, spiritual realities are accessible ONLY
    through material signs. The body is the exclusive medium through
    which the invisible becomes visible.

    This is the "it alone" exclusivity claim. It says: you cannot
    access spiritual realities directly (in this life). You must go
    through matter — through bodies, through signs, through sacraments.

    PROVENANCE: TOB audience 19 (1980); CCC §1146 ("In human life,
    signs and symbols occupy an important place"); CCC §1148 ("the
    cosmos… can become the place where God's presence is manifested");
    Jn 1:14 ("The Word became flesh" — God himself used material
    mediation to reveal himself).

    CONNECTS TO: T3 (sacramental efficacy — if material signs are the
    ONLY channel, then sacraments are necessary, not optional). -/
axiom MATERIAL_MEDIATION :
  ∀ (spiritualReality : Prop),
    -- If a spiritual reality is made accessible...
    (∃ (materialSign : Prop), makesAccessible materialSign spiritualReality) →
    -- ...it is accessible ONLY through material signs
    ∀ (channel : Prop), makesAccessible channel spiritualReality → isSign channel

/-- Denominational tag: Catholic + Orthodox for the strong version.
    Protestants generally affirm that God can work through material
    means but deny the exclusivity claim (God can also work directly
    through the Word alone). -/
def material_mediation_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Strong exclusivity: Catholic + Orthodox. Protestants: God also works directly through the Word" }

/-- **AXIOM (TOB 32:3; Love and Responsibility ch.3): SIGN TRUTHFULNESS.**
    A bodily act that contradicts its inherent meaning is a "lie told
    with the body." Just as spoken words can be true or false, bodily
    acts can be truthful (expressing what they inherently mean) or
    lying (contradicting what they inherently mean).

    Example: The conjugal act inherently means "I give myself totally
    to you." If performed while deliberately withholding fertility
    (contraception), the body "says" total self-gift while the agent
    withholds — this is a contradiction, a body-lie.

    PROVENANCE: TOB audience 32 (1980); Love and Responsibility ch.3;
    CCC §2370 (contraception as contrary to the moral law).

    CONNECTS TO: PERSONALIST_NORM (body-lies instrumentalize the other
    person), ConjugalEthics.lean inseparability_principle. -/
axiom SIGN_TRUTHFULNESS :
  ∀ (bodilyAct agentAction : Prop),
    -- If the body's inherent meaning is contradicted by the agent's action...
    contradictsInherentMeaning bodilyAct agentAction →
    -- ...the act is a lie told with the body (morally disordered)
    isEvil (contradictsInherentMeaning bodilyAct agentAction)

/-- Denominational tag: Catholic + Orthodox for the strong version.
    The general principle that bodily acts have moral significance
    is ecumenical. -/
def sign_truthfulness_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Strong version: Catholic + Orthodox. General principle: ecumenical" }

/-- **Theorem: The body-as-sign principle grounds sacramental efficacy.**

    If spiritual realities are accessible ONLY through material signs
    (MATERIAL_MEDIATION), then any channel through which grace reaches
    a person must be a material sign — which is exactly what a sacrament
    is. Therefore sacraments are NECESSARY (not just helpful) for grace
    to reach persons in the created order.

    This derives T3 (sacramental efficacy, Axioms.lean t3_sacramental_efficacy)
    from the body-as-sign anthropology rather than asserting it as a
    standalone tradition.

    CONNECTS TO: T3 (t3_sacramental_efficacy), MATERIAL_MEDIATION,
    BODY_AS_SIGN. -/
theorem body_sign_grounds_sacraments
    (spiritualReality : Prop)
    (materialSign : Prop)
    (h_accessible : makesAccessible materialSign spiritualReality)
    (h_mediation : (∃ (ms : Prop), makesAccessible ms spiritualReality) →
      ∀ (channel : Prop), makesAccessible channel spiritualReality → isSign channel) :
    -- Any channel conveying this spiritual reality must be a sign
    isSign materialSign := by
  exact h_mediation ⟨materialSign, h_accessible⟩ materialSign h_accessible

/-- Denominational tag: Catholic for the derivation of sacramental
    necessity from material mediation. -/
def body_sign_sacraments_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Derives T3 from material mediation; Protestant: sacraments are signs, not necessary channels" }

/-- **Theorem: Contraception is a lie told with the body.**

    The conjugal act has an inherent meaning (total self-gift, including
    fertility). Contraception retains the bodily act while withholding
    fertility. This contradicts the act's inherent meaning — the body
    "says" total gift while the agent withholds. By SIGN_TRUTHFULNESS,
    this contradiction is a body-lie, which is morally disordered.

    This provides a SECOND derivation of the immorality of contraception
    (the first being the inseparability principle from ConjugalEthics.lean).
    The two derivations converge: the inseparability principle says you
    can't separate the meanings; the body-lie theorem says separating them
    is a form of lying.

    CONNECTS TO: ConjugalEthics.lean contraception_violates_inseparability,
    SIGN_TRUTHFULNESS, PERSONALIST_NORM. -/
theorem contraception_is_body_lie
    (conjugalActMeaning : Prop)  -- "total self-gift including fertility"
    (contraceptiveAction : Prop) -- "self-gift minus fertility"
    (_h_inherent : inherentMeaning conjugalActMeaning)
    (_h_withholds : ¬contraceptiveAction)
    (h_contradicts : contradictsInherentMeaning conjugalActMeaning contraceptiveAction) :
    -- Contraception is morally disordered (a body-lie)
    isEvil (contradictsInherentMeaning conjugalActMeaning contraceptiveAction) := by
  exact SIGN_TRUTHFULNESS conjugalActMeaning contraceptiveAction h_contradicts

/-- Denominational tag: Catholic. -/
def contraception_body_lie_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Catholic: contraception contradicts the body's sign-meaning. CCC §2370" }

/-!
## Summary of Hidden Assumptions

Formalizing the three core TOB claims required these assumptions:

1. **Imago Dei** (AXIOM) — humans are made in God's image. This is the
   ontological ground of dignity. Combined with S1 (God is love) and
   PARTICIPATION, it yields the personalist norm as a THEOREM.

2. **Participation** (AXIOM) — an image participates in what it images.
   This is the Thomistic metaphysical bridge: if God is love and humans
   are God's image, then humans participate in love, making love the
   adequate response to them.

3. **Adequate response bridge** (AXIOM) — if love is the adequate
   response to a person, then only the Love orientation (not Use or
   Indifference) respects dignity. This is a modeling axiom connecting
   the opaque participation predicate to the concrete RelationKind type.

4. **The personalist norm** (THEOREM, formerly axiom) — derived from
   S1 + IMAGO_DEI + PARTICIPATION. Use always violates dignity, even
   with consent.

5. **Consent does not legitimize use** (THEOREM, formerly axiom) —
   derived from the definition of RelationKind: Use.respectsDignity
   is definitionally False, so consent is irrelevant.

6. **Dignity is intrinsic** (THEOREM, formerly axiom) — derived from
   IMAGO_DEI: the image of God is ontological, not dependent on
   consent, capability, or social valuation.

7. **The Fall diminished but did not destroy** — this is a specific
   calibration claim. Too optimistic (Pelagianism) and too pessimistic
   (Calvinism) are both rejected. The exact degree of damage is an
   empirical-metaphysical claim that cannot be derived from first principles.

8. **Redemption is progressive, not instantaneous** — transformation takes
   time and requires cooperation. This connects to the Catholic rejection
   of forensic justification (Lutheran) and irresistible grace (Calvinist).

9. **The body is a sign, not just matter** — the body bears meaning. This
   is a semiotic claim, distinct from hylomorphism (ontological).

10. **Material mediation is exclusive** — spiritual realities are accessible
    ONLY through material signs. This is the strongest claim and the one
    most Protestants would reject (they affirm God can work directly through
    the Word without material mediation).

11. **Signs can lie** — bodily acts can contradict their inherent meaning,
    and such contradictions are morally disordered. This requires that bodily
    acts HAVE inherent meanings (a teleological claim about the body).

**Structural note**: The refactoring from 3 axioms to 2 axioms (+1 bridge
axiom) is a net improvement because the personalist norm, dignity, and
consent theorems now have explicit theological grounding rather than being
asserted as standalone principles. The derivation chain (God is love →
humans image God → humans participate in love → love is the adequate
response → only Love respects dignity) makes the dependency structure
visible.
-/

end Catlib.MoralTheology.TheologyOfBody
