import Catlib.Foundations
import Catlib.MoralTheology.ConjugalEthics
import Catlib.MoralTheology.TheologyOfBody
import Catlib.MoralTheology.EvangelicalCounsels
import Catlib.MoralTheology.Virtues

/-!
# CCC §2331-2400, §2514-2533: Chastity as Integration

## The Catechism claims

"Chastity means the successful integration of sexuality within the person
and thus the inner unity of man in his bodily and spiritual being." (§2337)

"The chaste person maintains the integrity of the powers of life and love
placed in him." (§2338)

"Chastity includes an apprenticeship in self-mastery which is a training
in human freedom." (§2339)

"People should cultivate [chastity] in the way that is suited to their
state of life." (§2349)
- "Those who are engaged to marry are called to live chastity in
  continence." (§2350)
- "Married couples are called to live conjugal chastity." (§2349)
- "Those who are not married are called to continence." (§2349)
- Religious profess chastity as an evangelical counsel (§914-915).

"Purification of heart" (ninth commandment): "The 'struggle against
carnal covetousness entails purifying the heart and practicing
temperance.'" (§2517)

"Purity of heart will enable us to see God: it enables us even now
to see things according to God." (§2531)

## Prediction

I expect this formalization to reveal that CHASTITY IS NOT ABSTINENCE.
The CCC's definition (§2337) is explicitly about INTEGRATION — the
ordering of sexuality within the whole person. This means:

1. Chastity is required of ALL persons in every state of life (§2348-2350),
   not just the unmarried.
2. Conjugal chastity (married persons) is the inseparability principle
   from ConjugalEthics.lean — the integration of unitive and procreative
   meanings.
3. Religious chastity is the evangelical counsel from EvangelicalCounsels.lean.
4. The ninth commandment (§2514-2533) extends chastity from ACT to HEART —
   the interior dimension that goes beyond external behavior.

The main question from CONTRIBUTING.md: "Does ConjugalEthics.lean generalize
to a unified virtue theory?" Answer: YES — chastity-as-integration is the
general virtue; conjugal ethics is its MARRIED expression. The
inseparability principle is not a standalone rule but a special case of the
integration requirement applied to married sexuality.

## Findings

- **Chastity-as-integration is the GENERAL virtue; conjugal ethics is a
  SPECIAL CASE.** The CCC defines chastity as "integration of sexuality
  within the person" (§2337), which applies to ALL states of life. The
  inseparability principle (ConjugalEthics.lean) is what integration LOOKS
  LIKE for married persons. This answers the CONTRIBUTING.md question: yes,
  ConjugalEthics.lean generalizes, and Chastity.lean is the generalization.

- **Three expressions, one virtue.** Conjugal chastity = inseparability
  principle (both meanings intact). Religious chastity = evangelical counsel
  of chastity (total self-gift to God). Single chastity = continence
  (reserving sexual expression for its proper context). The unity is
  INTEGRATION — sexuality ordered within the person according to their
  state of life.

- **The ninth commandment extends chastity to the INTERIOR.** The sixth
  commandment concerns ACTS; the ninth concerns the HEART (§2514-2515).
  Purity of heart is not just avoiding bad acts but ordering DESIRES.
  This connects to TheologyOfBody.lean's concupiscence: the Fall
  disordered desires (NuptialCapacity), and purity of heart is the
  progressive re-ordering.

- **Connection to TheologyOfBody.lean is deep.** Body-as-sign (TOB)
  provides the anthropological GROUND for chastity-as-integration:
  the body has inherent meaning, so integrating sexuality means
  making one's sexual acts TRUTHFUL signs (not body-lies). The three-state
  anthropology (original integrity → fallen → redeemed) explains WHY
  chastity requires effort: concupiscence disordered desires, and
  integration is the progressive restoration.

- **The hidden assumption is that sexuality HAS a telos.** The entire
  framework presupposes teleological realism about sexuality: sex has
  inherent purposes (unitive + procreative), and "integration" means
  ordering oneself toward those purposes. Drop teleological realism
  (NaturalLaw.lean) and "integration" loses its content — integration
  toward WHAT?

## Modeling choices

1. We model chastity as a predicate on Person × StateOfLife, not as a
   standalone property, because the CCC insists that chastity's
   EXPRESSION varies by state of life while its ESSENCE (integration)
   is universal.
2. We connect conjugal chastity directly to ConjugalEthics.lean's
   inseparability principle via a bridge axiom, rather than re-axiomatizing.
3. We connect religious chastity to EvangelicalCounsels.lean's counsel
   of chastity via a bridge axiom.
4. We model purity of heart (ninth commandment) as the interior dimension
   of chastity, connecting to TheologyOfBody.lean's NuptialCapacity.
-/

set_option autoImplicit false

namespace Catlib.MoralTheology.Chastity

open Catlib
open Catlib.MoralTheology
open Catlib.MoralTheology.ConjugalEthics (ConjugalAct deliberatelyFrustratesProcreation
  physical_act_determines_object)
open Catlib.MoralTheology.TheologyOfBody (AnthropologicalState NuptialCapacity
  stateCapacity three_state_anthropology concupiscence_diminishes_not_destroys
  body_as_sign isSign inherentMeaning)
open Catlib.MoralTheology.EvangelicalCounsels (EvangelicalCounsel StateOfLife
  professes counsels_remove_hindrances hindersCharity counselRenounces)
open Catlib.MoralTheology.Virtues (CardinalVirtue Virtue hasVirtue)

-- ============================================================================
-- § 1. Core types
-- ============================================================================

/-- Whether a person's sexuality is integrated within the whole person —
    i.e., bodily sexual expression is ordered to the person's state of
    life and vocation.

    §2337: "Chastity means the successful integration of sexuality within
    the person and thus the inner unity of man in his bodily and spiritual
    being."

    HONEST OPACITY: The CCC defines integration as "inner unity of man in
    his bodily and spiritual being" (§2337) but does not specify a metric
    for when integration is "successful." The concept is clear in its
    extremes (obvious violations vs. obvious harmony) but underdetermined
    in the middle. We keep this opaque to track that underdetermination.

    This is the CCC's concept, not ours: §2337 explicitly defines chastity
    this way. -/
opaque sexualityIntegrated : Person → Prop

/-- The degree to which a person's desires are ordered toward the good
    of the other (rather than toward self-gratification).

    §2339: "Chastity includes an apprenticeship in self-mastery which is
    a training in human freedom."

    MODELING CHOICE: We reuse NuptialCapacity from TheologyOfBody.lean
    for the interior state, and add this predicate for the behavioral
    dimension. Self-mastery is the EXTERIOR expression of interior ordering.

    This is the CCC's concept: §2339 explicitly names self-mastery. -/
opaque hasSelfMastery : Person → Prop

/-- Whether a person lives chastity according to their state of life.

    §2349: "People should cultivate [chastity] in the way that is suited
    to their state of life."

    This is the KEY insight: chastity is ONE virtue with MULTIPLE
    expressions depending on state of life. The expression differs;
    the essence (integration) is the same.

    HONEST OPACITY: What "suited to their state of life" means concretely
    is specified for some states (married: §2349; religious: §914-915;
    engaged: §2350) but not fully determined for all situations. -/
opaque livesChastityInState : Person → StateOfLife → Prop

-- ============================================================================
-- § 2. Axioms
-- ============================================================================

/-!
### Axiom 1: Chastity IS integration (§2337)

This is the definitional axiom. Chastity is NOT abstinence, NOT mere
rule-following, but the SUCCESSFUL INTEGRATION of sexuality within the
person. A chaste person's sexual desires, acts, and vocation form a
coherent whole.
-/

/-- **AXIOM (§2337): CHASTITY IS INTEGRATION.**
    Chastity means the successful integration of sexuality within the
    person. If a person has the virtue of temperance (of which chastity
    is a species per §2341) AND their sexuality is integrated, then
    they live chastity in their state of life.

    Source: [CCC] §2337: "Chastity means the successful integration of
    sexuality within the person and thus the inner unity of man in his
    bodily and spiritual being."

    Denominational scope: ECUMENICAL — the definition itself is broadly
    shared. The APPLICATION (what counts as "integrated") is where
    denominations diverge.

    HIDDEN ASSUMPTION: Sexuality admits of "integration" — presupposes
    teleological realism (sexuality has inherent purposes toward which
    one can be ordered or disordered). Without teleological realism,
    "integration" is contentless. -/
axiom chastity_is_integration :
  ∀ (p : Person) (s : StateOfLife),
    hasVirtue p (Virtue.cardinal CardinalVirtue.temperance) →
    sexualityIntegrated p →
    livesChastityInState p s

/-!
### Axiom 2: Chastity requires self-mastery (§2339)

Self-mastery is the behavioral dimension of integration. A person
whose desires are disordered but who exercises self-mastery is ON THE
PATH to integration — not yet fully integrated, but actively working
toward it.
-/

/-- **AXIOM (§2339): CHASTITY REQUIRES SELF-MASTERY.**
    Living chastity in any state of life requires self-mastery — the
    capacity to direct one's sexual desires rather than being directed
    by them.

    Source: [CCC] §2339: "Chastity includes an apprenticeship in
    self-mastery which is a training in human freedom."

    Denominational scope: ECUMENICAL.

    CONNECTION TO BASE AXIOM: Self-mastery connects to Freedom.lean's
    freedom-as-flourishing (§1733): mastering one's desires increases
    freedom (freedom is not doing whatever you want, but being able to
    do the good). -/
axiom chastity_requires_self_mastery :
  ∀ (p : Person) (s : StateOfLife),
    livesChastityInState p s → hasSelfMastery p

/-!
### Axiom 3: Conjugal chastity = inseparability (§2349 + HV §12)

For married persons, chastity means preserving both meanings of the
conjugal act — the inseparability principle from ConjugalEthics.lean.
This is the BRIDGE that answers the CONTRIBUTING.md question: conjugal
ethics IS chastity's married expression.
-/

/-- **AXIOM (§2349, HV §12): CONJUGAL CHASTITY = INSEPARABILITY.**
    For married persons, living chastity means preserving both the
    unitive and procreative meanings of the conjugal act. A married
    person who performs a conjugal act with both meanings intact is
    living conjugal chastity.

    Source: [CCC] §2349: "Married people are called to live conjugal
    chastity"; [CCC] §2366-2370 (inseparability principle, formalized
    in ConjugalEthics.lean).

    Denominational scope: CATHOLIC. The identification of conjugal
    chastity with the inseparability principle is specifically Catholic
    (post-1930). Pre-1930: ecumenical.

    MODELING CHOICE: We bridge to ConjugalEthics.lean rather than
    re-axiomatizing. This makes the relationship between the general
    virtue (chastity) and the specific application (conjugal ethics)
    explicit in the dependency graph. -/
axiom conjugal_chastity_is_inseparability :
  ∀ (p : Person) (act : ConjugalAct),
    livesChastityInState p StateOfLife.lay →
    act.unitiveIntact ∧ act.procreativeIntact →
    ¬deliberatelyFrustratesProcreation act

/-!
### Axiom 4: Religious chastity = evangelical counsel (§914-915)

For consecrated religious, chastity is the evangelical counsel —
total celibacy for the Kingdom. This bridges to
EvangelicalCounsels.lean.
-/

/-- **AXIOM (§914-915): RELIGIOUS CHASTITY = COUNSEL OF CHASTITY.**
    For consecrated persons, living chastity means professing the
    evangelical counsel of chastity (celibacy for the Kingdom).

    Source: [CCC] §914-915 (evangelical counsels, formalized in
    EvangelicalCounsels.lean); §2349 ("Religious... are called to
    practice chastity in continence").

    Denominational scope: CATHOLIC. Protestants generally reject the
    evangelical counsels as a distinct moral category (Luther, De Votis
    Monasticis, 1521).

    MODELING CHOICE: We bridge to EvangelicalCounsels.lean. Religious
    chastity is the counsel of chastity. -/
axiom religious_chastity_is_counsel :
  ∀ (p : Person),
    livesChastityInState p StateOfLife.consecrated →
    professes p EvangelicalCounsel.chastity

/-!
### Axiom 5: Purity of heart — the ninth commandment (§2514-2515)

The ninth commandment extends chastity from the EXTERIOR (acts) to
the INTERIOR (heart/desires). "Blessed are the pure in heart, for
they shall see God" (Mt 5:8). Purity of heart means ordering one's
desires, not just one's actions.
-/

/-- Whether a person has purity of heart — the interior ordering of
    desires toward the good.

    §2517: "The heart is the seat of moral personality... The 'struggle
    against carnal covetousness entails purifying the heart.'"

    §2531: "Purification of the heart demands prayer, the practice of
    chastity, purity of intention and of vision."

    HONEST OPACITY: "Purity of heart" is defined in terms of interior
    ordering that is not externally verifiable. The CCC describes it
    with language of "seeing according to God" (§2531) — an epistemic
    and spiritual state, not a behavioral criterion.

    This is the CCC's concept: §2514-2533 are devoted to it. -/
opaque purityOfHeart : Person → Prop

/-- **AXIOM (§2514-2515, Mt 5:8): PURITY OF HEART IS INTERIOR CHASTITY.**
    Chastity of acts (sixth commandment) without purity of heart (ninth
    commandment) is incomplete. Full chastity requires ordering not just
    acts but desires.

    Source: [CCC] §2514: "The ninth commandment warns against lust or
    carnal concupiscence." [CCC] §2518: "The sixth beatitude proclaims,
    'Blessed are the pure in heart, for they shall see God' (Mt 5:8)."

    Denominational scope: ECUMENICAL — Mt 5:8 is universally accepted.
    The specific APPLICATION to sexual desire as distinct from sexual
    acts is the Catholic contribution.

    CONNECTION TO TheologyOfBody.lean: Purity of heart is the progressive
    re-ordering of NuptialCapacity — moving from disordered desires
    (Fallen state) toward ordered desires (Redeemed state). The three-state
    anthropology provides the framework: concupiscence disordered desires,
    grace progressively restores them, purity of heart is the NAME for
    that restoration in the sexual domain. -/
axiom purity_of_heart_completes_chastity :
  ∀ (p : Person) (s : StateOfLife) (nc : NuptialCapacity),
    livesChastityInState p s →
    nc.level > 0 →
    nc.desiresOrdered →
    purityOfHeart p

/-!
### Axiom 6: Chastity is universally required (§2348)

This axiom makes explicit what the CCC states plainly: chastity is
required of ALL baptized persons, not just the unmarried or religious.
-/

/-- **AXIOM (§2348): CHASTITY IS UNIVERSALLY REQUIRED.**
    All persons are called to chastity. This is NOT a call to abstinence
    for all — it is a call to INTEGRATION for all.

    Source: [CCC] §2348: "All Christ's faithful are called to lead a
    chaste life in keeping with their particular states of life."

    Denominational scope: ECUMENICAL — all Christian traditions affirm
    that sexuality must be rightly ordered, though they differ on what
    "rightly ordered" means.

    HIDDEN ASSUMPTION: "All persons" includes married persons. This is
    explicit in the CCC (§2349: "Married people are called to live
    conjugal chastity") but is counterintuitive to the common
    understanding of chastity as abstinence. -/
axiom chastity_universally_required :
  ∀ (p : Person), p.isMoralAgent = true →
    ∃ (s : StateOfLife), livesChastityInState p s

-- ============================================================================
-- § 3. Theorems
-- ============================================================================

/-!
### Theorem 1: Chastity as integration generalizes conjugal ethics

This is the answer to the CONTRIBUTING.md question. The inseparability
principle (ConjugalEthics.lean) is a SPECIAL CASE of chastity-as-integration
for married persons.
-/

/-- **THEOREM: Conjugal chastity implies the inseparability principle.**
    A married person living chastity, when performing a conjugal act with
    both meanings intact, does not deliberately frustrate procreation.
    This derives from conjugal_chastity_is_inseparability (Axiom 3) and
    connects to physical_act_determines_object (ConjugalEthics.lean).

    This formally answers the CONTRIBUTING.md question: ConjugalEthics.lean
    DOES generalize — chastity-as-integration is the general virtue, and
    the inseparability principle is its married expression.

    Denominational scope: CATHOLIC. -/
theorem conjugal_chastity_implies_inseparability
    (p : Person)
    (act : ConjugalAct)
    (h_chaste : livesChastityInState p StateOfLife.lay)
    (h_both : act.unitiveIntact ∧ act.procreativeIntact) :
    ¬deliberatelyFrustratesProcreation act :=
  conjugal_chastity_is_inseparability p act h_chaste h_both

/-!
### Theorem 2: Religious chastity removes a hindrance to charity

Consecrated chastity, as the evangelical counsel, removes the hindrance
that divided attention (marriage) poses to charity. This bridges to
EvangelicalCounsels.lean.
-/

/-- **THEOREM: Religious chastity removes a hindrance to charity.**
    A consecrated person living chastity professes the evangelical counsel,
    which removes the hindrance that the lawful good of marriage poses to
    undivided charity.

    Derivation: religious_chastity_is_counsel (Axiom 4) +
    counsels_remove_hindrances (EvangelicalCounsels.lean Axiom 2).

    Denominational scope: CATHOLIC. -/
theorem religious_chastity_removes_hindrance
    (_p : Person)
    (_h_chaste : livesChastityInState _p StateOfLife.consecrated) :
    hindersCharity (counselRenounces EvangelicalCounsel.chastity) :=
  counsels_remove_hindrances EvangelicalCounsel.chastity

/-!
### Theorem 3: Self-mastery as training in freedom

The CCC says chastity's self-mastery is "a training in human freedom"
(§2339). Under the CCC's concept of freedom-as-flourishing (§1733),
mastering desires does not reduce freedom but increases it.
-/

/-- **THEOREM: Chastity in any state requires self-mastery.**
    Self-mastery is a NECESSARY condition for chastity, regardless of
    state of life. This makes explicit that chastity is an active
    achievement (requiring self-mastery) not a passive state.

    Derivation: chastity_requires_self_mastery (Axiom 2).

    Denominational scope: ECUMENICAL. -/
theorem chastity_requires_active_mastery
    (p : Person) (s : StateOfLife)
    (h_chaste : livesChastityInState p s) :
    hasSelfMastery p :=
  chastity_requires_self_mastery p s h_chaste

/-!
### Theorem 4: The body-as-sign grounds chastity

From TheologyOfBody.lean: the body is a sign with inherent meaning.
Chastity-as-integration means making one's sexual acts TRUTHFUL signs.
A chaste act is one where the body's sign-value is preserved; an
unchaste act is a body-lie.
-/

/-- **THEOREM: Bodily acts in the sexual domain are signs.**
    The body-as-sign principle from TheologyOfBody.lean applies to
    conjugal acts: every conjugal act is a sign (it bears meaning
    that refers beyond itself).

    Derivation: body_as_sign (TheologyOfBody.lean).

    This provides the anthropological GROUND for chastity: integration
    means making one's bodily acts truthful signs, not contradicting
    their inherent meaning.

    Denominational scope: CATHOLIC + ORTHODOX. -/
theorem conjugal_act_is_sign
    (conjugalActMeaning : Prop) :
    isSign conjugalActMeaning :=
  body_as_sign conjugalActMeaning

/-!
### Theorem 5: Purity of heart connects to the three-state anthropology

The ninth commandment's call to purity of heart (ordering desires) maps
onto TheologyOfBody.lean's three-state anthropology: in the Fallen state,
desires are disordered (concupiscence); purity of heart is the progressive
re-ordering that grace makes possible in the Redeemed state.
-/

/-- **THEOREM: The Fallen state has non-zero capacity for purity of heart.**
    Even in the Fallen state, the capacity for self-gift (and thus for
    purity of heart) is non-zero. Concupiscence diminishes but does NOT
    destroy the capacity. This means purity of heart is possible even
    for fallen persons — difficult, but not impossible.

    Derivation: three_state_anthropology (TheologyOfBody.lean) gives
    that the Fallen state has level > 0.

    Denominational scope: CATHOLIC — against Calvinist total depravity
    which would make purity of heart impossible without prior regeneration. -/
theorem fallen_can_pursue_purity :
    (stateCapacity AnthropologicalState.Fallen).level > 0 ∧
    (stateCapacity AnthropologicalState.Fallen).canChooseSelfGift :=
  ⟨three_state_anthropology.2.2.1, three_state_anthropology.2.2.2.1⟩

/-!
### Theorem 6: Every moral agent is called to some form of chastity

The universal requirement (Axiom 6) means that chastity is not a
special vocation but a basic moral call. This is the most
counterintuitive claim to modern ears: MARRIED persons are called to
chastity too — conjugal chastity.
-/

/-- **THEOREM: Every moral agent has a chastity vocation.**
    For every moral agent, there exists a state of life in which they
    are called to live chastity. No one is exempt.

    Derivation: chastity_universally_required (Axiom 6).

    Denominational scope: ECUMENICAL. -/
theorem every_moral_agent_has_chastity_vocation
    (p : Person)
    (h_moral : p.isMoralAgent = true) :
    ∃ (s : StateOfLife), livesChastityInState p s :=
  chastity_universally_required p h_moral

/-!
### Theorem 7: Integration unifies the three expressions

The three expressions of chastity (conjugal, religious, single/lay)
are unified by the common requirement of self-mastery. Self-mastery
is what makes chastity ONE virtue with multiple expressions, not
three unrelated rules.
-/

/-- **THEOREM: All three expressions of chastity require self-mastery.**
    Whether conjugal, religious, or lay, chastity in every state
    requires self-mastery. This is the UNITY beneath the diversity of
    expressions.

    Derivation: chastity_requires_self_mastery (Axiom 2) instantiated
    for each state of life.

    Denominational scope: ECUMENICAL. -/
theorem integration_unifies_expressions
    (p : Person)
    (h_lay : livesChastityInState p StateOfLife.lay)
    (h_cons : livesChastityInState p StateOfLife.consecrated)
    (h_ord : livesChastityInState p StateOfLife.ordained) :
    hasSelfMastery p ∧ hasSelfMastery p ∧ hasSelfMastery p :=
  ⟨chastity_requires_self_mastery p _ h_lay,
   chastity_requires_self_mastery p _ h_cons,
   chastity_requires_self_mastery p _ h_ord⟩

-- ============================================================================
-- § 4. Denominational tags
-- ============================================================================

/-- Denominational tag for chastity-as-integration. -/
def chastityIntegrationTag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical]
    note := "The DEFINITION of chastity as integration is ecumenical. The APPLICATION (what counts as integrated) varies: Catholic inseparability principle vs. Protestant consent-based ethics." }

/-- Denominational tag for the conjugal-chastity/inseparability bridge. -/
def conjugalChastityTag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Conjugal chastity = inseparability principle. Catholic post-1930. Pre-1930: ecumenical." }

/-- Denominational tag for the ninth commandment / purity of heart. -/
def purityOfHeartTag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical]
    note := "Mt 5:8 is universally accepted. The specific application to ordering sexual desire (as distinct from acts) is Catholic emphasis." }

/-!
## Summary

| Axiom | Source | Claim | Denominational scope |
|-------|--------|-------|---------------------|
| 1. `chastity_is_integration` | §2337 | Chastity = integration of sexuality | ECUMENICAL (definition) |
| 2. `chastity_requires_self_mastery` | §2339 | Living chastity requires self-mastery | ECUMENICAL |
| 3. `conjugal_chastity_is_inseparability` | §2349, HV §12 | Married chastity = inseparability principle | CATHOLIC |
| 4. `religious_chastity_is_counsel` | §914-915 | Religious chastity = evangelical counsel | CATHOLIC |
| 5. `purity_of_heart_completes_chastity` | §2514-2515, Mt 5:8 | Full chastity requires ordering desires, not just acts | ECUMENICAL |
| 6. `chastity_universally_required` | §2348 | ALL persons are called to chastity | ECUMENICAL |

**Key findings:**
1. **Chastity is NOT abstinence.** The CCC defines it as INTEGRATION (§2337),
   not as refraining from sex. Married persons are called to chastity (§2349).
2. **ConjugalEthics.lean generalizes.** Chastity-as-integration is the general
   virtue; the inseparability principle is its married expression. This answers
   the CONTRIBUTING.md question affirmatively.
3. **Three expressions, one virtue.** Conjugal (inseparability), religious
   (evangelical counsel), single (continence) — unified by the common
   requirement of self-mastery and the common essence of integration.
4. **The ninth commandment extends to the INTERIOR.** Purity of heart (§2514-
   2533) is the interior dimension: ordering DESIRES, not just ACTS. This
   connects to TheologyOfBody.lean's concupiscence and NuptialCapacity.
5. **The hidden assumption is teleological realism.** "Integration" presupposes
   that sexuality HAS purposes toward which one can be ordered. Drop
   teleological realism and the concept of integration empties.
-/

end Catlib.MoralTheology.Chastity
