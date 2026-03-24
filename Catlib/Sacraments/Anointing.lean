import Catlib.Foundations
import Catlib.Sacraments.SacramentalCausation
import Catlib.Creed.DivineModes

/-!
# CCC §1499-1532: Anointing of the Sick — Grace at the Boundary of Death

## The source claims

The CCC teaches that Anointing of the Sick has four effects (§1520-1523):

1. **Spiritual strengthening**: "The first grace of this sacrament is one of
   strengthening, peace, and courage to overcome the difficulties that go with
   the condition of serious illness or the frailty of old age." (§1520)

2. **Forgiveness of sins** (if Penance unavailable): "The sick person may also
   receive the forgiveness of sins if he was unable to obtain it through the
   sacrament of Penance." (§1520)

3. **Union with Christ's Passion**: "By the grace of this sacrament the sick
   person receives the strength and the gift of uniting himself more closely
   to Christ's Passion." (§1521)

4. **Restoration of health IF conducive to salvation**: "a restoration of health,
   if it is conducive to the salvation of his soul" (§1520)

## The key question

Effect (4) makes Anointing UNIQUE among the sacraments. In every other sacrament,
the primary effects are UNCONDITIONAL (given proper disposition and valid form):
- Baptism ALWAYS removes original sin (§1263)
- Eucharist ALWAYS makes Christ present (§1376)
- Reconciliation ALWAYS restores communion (§1468)
- Holy Orders ALWAYS imprints character (§1582)

But Anointing's physical healing effect is CONDITIONAL on divine judgment about
what is best for the person's eternal salvation. God might withhold healing
BECAUSE death is better for the person's soul.

## Hidden assumptions

1. **Physical healing and spiritual salvation CAN BE IN TENSION**: The "if
   conducive" clause assumes there exist cases where healing would be BAD for
   the person's soul. This is not obvious — why would health ever harm salvation?
   The CCC's implicit answer: continued earthly life brings continued temptation,
   and some people are spiritually "ready" in a way they might not remain.

2. **God judges what is conducive**: The conditionality is not about the
   sacrament's power (it CAN heal) but about divine wisdom (God CHOOSES whether
   healing serves salvation). This presupposes a Providence model where God
   evaluates counterfactuals about individual souls.

3. **Death can be a good**: For the "if conducive" clause to have content,
   death must sometimes be BETTER for the person than continued life. This
   connects to DivineModes.lean: death is a transition to beatifying communion,
   not annihilation.

## Modeling choices

1. We model the conditionality as an opaque predicate `conduciveToSalvation`
   rather than trying to define what makes healing conducive. The CCC does not
   specify the criteria — it leaves this to divine judgment.

2. We distinguish CERTAIN effects (always conferred) from CONDITIONAL effects
   (conferred only under additional conditions). This distinction is our
   analytical framework; the CCC presents all four effects in a single paragraph.

3. We model the uniqueness claim comparatively: Anointing is the ONLY sacrament
   among the seven whose primary effects include a conditional one.

## Denominational scope

- The spiritual effects (strengthening, union with Christ's passion) are broadly
  Christian, though their sacramental causation depends on T3.
- The conditional healing clause is CATHOLIC DISTINCTIVE — it presupposes both
  T3 (the sacrament can genuinely cause healing) and a specific Providence model
  (God evaluates what serves salvation).
- Protestant traditions that practice anointing (Jas 5:14-15) typically treat it
  as a prayer ministry, not a sacrament with ex opere operato effects.

## Connections

- **SacramentalCausation.lean**: Anointing's profile is dispositional +
  relational (already axiomatized there). This file adds the CONDITIONAL
  dimension that SacramentalCausation doesn't capture.
- **DivineModes.lean**: Death as transition to beatifying communion explains
  WHY healing might not be conducive — the person may be ready for heaven.
- **Providence.lean**: The "if conducive" clause is an instance of providential
  governance — God directing events toward the person's ultimate good.

## Findings

- **The conditional effect reveals a deeper principle**: The "if conducive"
  clause is not an exception to sacramental efficacy but an EXPRESSION of it.
  The sacrament's purpose is the SALVATION of the soul (§1520), not bodily
  health. Physical healing serves that purpose only sometimes. The sacrament
  always achieves its TRUE end (spiritual strengthening); it achieves its
  SECONDARY end (healing) only when that serves the primary end.
- **Anointing is unique**: No other sacrament has a primary effect conditioned
  on divine judgment about the recipient's good. This makes Anointing the
  sacrament that most explicitly encodes the primacy of spiritual over
  temporal goods.
- **The tension between healing and salvation is the hidden load-bearing
  assumption**: Without it, the "if conducive" clause is vacuous (healing
  would always be conducive). The CCC quietly assumes that earthly life and
  eternal salvation can pull in different directions.
-/

set_option autoImplicit false

namespace Catlib.Sacraments.Anointing

open Catlib
open Catlib.Sacraments.SacramentalCausation
open Catlib.Creed

-- ============================================================================
-- § 1. Core Predicates
-- ============================================================================

/-- Whether a person is seriously ill or in danger of death.
    CCC §1514: "The Anointing of the Sick 'is not a sacrament for those only
    who are at the point of death. Hence, as soon as anyone of the faithful
    begins to be in danger of death from sickness or old age, the fitting
    time for him to receive this sacrament has certainly already arrived.'"

    HONEST OPACITY: The threshold for "serious illness" is pastoral, not
    metaphysical. The CCC gives guidelines (§1514-1515) but does not define
    a sharp boundary. -/
opaque seriouslyIll : Person → Prop

/-- Whether physical healing is conducive to the salvation of the person's soul.
    CCC §1520: "a restoration of health, if it is conducive to the salvation
    of his soul."

    HONEST OPACITY: This is the deepest opaque in the file. The CCC
    deliberately leaves the criterion to divine judgment — no human can know
    whether healing would serve or hinder a person's eternal salvation. This
    is not lazy opacity; it tracks genuine epistemic inaccessibility.
    The predicate is indexed by Person because what is conducive depends on
    the individual's spiritual state, remaining temptations, readiness for
    death, etc.

    HIDDEN ASSUMPTION: This predicate assumes God evaluates counterfactuals
    about individual souls — what WOULD happen to this person's salvation
    if they were healed vs. if they died now. This is a strong Providence
    claim. -/
opaque conduciveToSalvation : Person → Prop

/-- Whether the person was unable to receive the sacrament of Penance.
    CCC §1520: "if he was unable to obtain it through the sacrament of Penance."

    HONEST OPACITY: "Unable" could mean physically unable (unconscious),
    no priest available, or other circumstances. The CCC does not enumerate
    the conditions. -/
opaque unableToReceivePenance : Person → Prop

/-- Whether the person receives spiritual strengthening (peace, courage,
    trust in God) through the sacrament.
    Source: [CCC] §1520. -/
opaque receivesStrengthening : Person → Prop

/-- Whether the person receives forgiveness of sins through this sacrament.
    Source: [CCC] §1520. -/
opaque receivesForgiveness : Person → Prop

/-- Whether the person is united to Christ's Passion through this sacrament.
    Source: [CCC] §1521: "the sick person receives the strength and the gift
    of uniting himself more closely to Christ's Passion."
    HIDDEN ASSUMPTION: Union with Christ's Passion is a real spiritual event,
    not merely a psychological comfort. This depends on T3 (sacramental
    efficacy). -/
opaque unitedToChristsPassion : Person → Prop

/-- Whether the person receives physical healing through this sacrament.
    Source: [CCC] §1520. -/
opaque receivesHealing : Person → Prop

/-- Whether the sacrament prepares the person for the final journey (death).
    CCC §1523: "If the sacrament of Anointing of the Sick is given to all who
    suffer from serious illness and infirmity, even more rightly is it given to
    those at the point of departing this life; so it is also called sacramentum
    exeuntium (sacrament of those departing)."

    This is the VIATICUM dimension — anointing as preparation for death.
    HONEST OPACITY: What "preparation" means spiritually is not fully
    specified. -/
opaque preparedForFinalJourney : Person → Prop

-- ============================================================================
-- § 2. Denominational Tags
-- ============================================================================

/-- The certain effects are CATHOLIC — they depend on T3 (ex opere operato).
    Protestant anointing practices (Jas 5:14-15) are prayer ministries,
    not sacraments with guaranteed effects. -/
def certainEffectsTag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Depends on T3. Protestant anointing is prayer, not sacrament." }

/-- The conditional healing clause is CATHOLIC DISTINCTIVE — it presupposes
    both T3 and a specific model of Providence where God evaluates what
    serves individual salvation. -/
def conditionalHealingTag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Requires T3 + Providence model. §1520." }

-- ============================================================================
-- § 3. Axioms — The Three Certain Effects
-- ============================================================================

/-!
### Certain effects — always conferred on the seriously ill who receive the sacrament

These effects are UNCONDITIONAL (given valid reception). They are the
sacrament's guaranteed spiritual fruits.
-/

/-- AXIOM (§1520): Anointing always confers spiritual strengthening.
    "The first grace of this sacrament is one of strengthening, peace, and
    courage to overcome the difficulties that go with the condition of
    serious illness or the frailty of old age."

    Provenance: [Scripture] Jas 5:14-15 ("the prayer of faith will save the
    sick person"); [Definition] CCC §1520.
    Denominational scope: CATHOLIC (depends on T3). -/
axiom anointing_confers_strengthening :
  ∀ (p : Person), seriouslyIll p → receivesStrengthening p

/-- AXIOM (§1520): Anointing confers forgiveness of sins when Penance is
    unavailable. "The sick person may also receive the forgiveness of sins
    if he was unable to obtain it through the sacrament of Penance."

    NOTE: This is conditional on Penance being unavailable, but it is
    CERTAIN given that condition — not conditional on divine judgment about
    what's best. The condition is circumstantial (no access to Penance),
    not providential (divine evaluation of what serves salvation).

    Provenance: [Definition] CCC §1520.
    Denominational scope: CATHOLIC (depends on T3). -/
axiom anointing_confers_forgiveness_if_no_penance :
  ∀ (p : Person), seriouslyIll p → unableToReceivePenance p → receivesForgiveness p

/-- AXIOM (§1521): Anointing unites the sick person to Christ's Passion.
    "By the grace of this sacrament the sick person receives the strength
    and the gift of uniting himself more closely to Christ's Passion."

    Provenance: [Tradition] §1521; [Scripture] Col 1:24 ("I fill up in my
    flesh what is still lacking in regard to Christ's afflictions").
    Denominational scope: CATHOLIC (depends on T3). -/
axiom anointing_unites_to_passion :
  ∀ (p : Person), seriouslyIll p → unitedToChristsPassion p

-- ============================================================================
-- § 4. Axiom — The Conditional Effect
-- ============================================================================

/-!
### The conditional healing effect — UNIQUE among the sacraments

This is the distinctive feature of Anointing. Physical healing is a real
effect of the sacrament, but it is conditioned on divine judgment about
whether healing serves the person's eternal salvation.
-/

/-- AXIOM (§1520): Anointing restores health IF conducive to salvation.
    "a restoration of health, if it is conducive to the salvation of his soul."

    The "if conducive" clause makes this a CONDITIONAL sacramental effect.
    The sacrament genuinely CAN cause physical healing (it has the power),
    but God directs this power according to what serves the person's
    ultimate good.

    Provenance: [Definition] CCC §1520.
    Denominational scope: CATHOLIC (depends on T3 + Providence). -/
axiom anointing_heals_if_conducive :
  ∀ (p : Person), seriouslyIll p → conduciveToSalvation p → receivesHealing p

/-- AXIOM (§1523): Anointing prepares the person for the final journey.
    "a preparation for the final journey" — this is the viaticum dimension.
    When healing is NOT conducive (i.e., death is near and spiritually
    appropriate), the sacrament pivots from healing to preparation for death.

    Provenance: [Definition] CCC §1523.
    Denominational scope: CATHOLIC (depends on T3). -/
axiom anointing_prepares_for_death :
  ∀ (p : Person), seriouslyIll p → ¬conduciveToSalvation p → preparedForFinalJourney p

-- ============================================================================
-- § 5. Hidden Assumption — Healing and Salvation Can Be in Tension
-- ============================================================================

/-!
### The tension between physical healing and spiritual salvation

The "if conducive" clause is only meaningful if there exist cases where
healing would NOT be conducive to salvation. If healing were ALWAYS good
for salvation, the clause would be vacuous and Anointing would simply
always heal.

The hidden assumption: physical well-being and spiritual salvation can
pull in different directions. God might withhold healing BECAUSE death
is better for the person.

This connects to DivineModes.lean: death is not annihilation but
transition to beatifying communion (for those who die in grace). If death
leads to heaven, then healing delays heaven — and delay CAN be harmful
if continued earthly life brings risk of falling from grace.
-/

/-- AXIOM: Physical healing and spiritual salvation can be in tension.
    There exist persons for whom healing would NOT be conducive to salvation.

    This is the HIDDEN ASSUMPTION that gives the "if conducive" clause real
    content. Without it, `conduciveToSalvation` would be trivially true
    for everyone, and the conditional effect would collapse into an
    unconditional one.

    HIDDEN ASSUMPTION (in the CCC): The CCC never explicitly states that
    healing can harm salvation. It simply says "if conducive" — but the "if"
    only has force if the condition can fail. The implicit anthropology is:
    continued earthly life brings continued temptation, and a person who
    dies in grace is SAFE, while a person who recovers might later fall.

    Provenance: [CCC] §1520 (implicit in the conditional structure);
    [Tradition] Aquinas, ST Suppl. q.30, a.2 (God heals when expedient
    for salvation).
    Denominational scope: CATHOLIC. -/
axiom healing_salvation_tension :
  ∃ (p : Person), seriouslyIll p ∧ ¬conduciveToSalvation p

-- ============================================================================
-- § 6. Connection to DivineModes — Why Death Can Be Good
-- ============================================================================

/-!
### Death as transition, not annihilation

The "if conducive" clause presupposes that death is not the worst outcome.
Under DivineModes.lean, death for a person in grace is transition to
beatifying communion — the BEST possible state. This explains why God
might withhold healing: the person is ready for heaven.

The connection: SoulState from DivineModes tells us what death leads to.
If the person would enter heavenState (sustained + beatifying communion +
purified), then death is BETTER than continued earthly risk.
-/

/-- Whether death would lead to beatifying communion for this person.
    This connects `conduciveToSalvation` to DivineModes: healing is NOT
    conducive when death would lead to heaven (or at least purgatory
    leading to heaven).

    MODELING CHOICE: We connect the Anointing predicate to DivineModes
    rather than defining it independently. The CCC does not make this
    connection explicit, but the logic requires it: "conducive to salvation"
    must mean something about the person's eternal destiny, which is what
    DivineModes models.

    HONEST OPACITY: We do not define what makes death lead to beatifying
    communion — that depends on the person's state of grace, which is
    known to God alone (connecting to the `knownToGodAlone` principle
    from DivineAttributes). -/
opaque deathLeadsToBeatifyingCommunion : Person → Prop

/-- AXIOM: When death leads to beatifying communion, healing is not
    conducive to salvation. If the person is ready for heaven, continued
    earthly life is a risk (temptation, possible fall from grace) rather
    than a benefit.

    This axiom makes the DivineModes connection explicit: the afterlife
    model DETERMINES whether healing serves salvation.

    Provenance: [CCC] §1520 + §1023-1024 (beatific vision as ultimate
    good); [Tradition] Aquinas, ST Suppl. q.30, a.2.
    HIDDEN ASSUMPTION: The comparative judgment (heaven now > more life)
    is real and not just a pious sentiment. This presupposes that eternal
    beatitude is incommensurably more valuable than any temporal good
    (connecting to the priority of spiritual over temporal goods throughout
    the CCC). -/
axiom beatifying_communion_excludes_conducive :
  ∀ (p : Person), deathLeadsToBeatifyingCommunion p → ¬conduciveToSalvation p

-- ============================================================================
-- § 7. Uniqueness — No Other Sacrament Has a Conditional Primary Effect
-- ============================================================================

/-!
### Anointing's uniqueness among the seven sacraments

The key analytical finding: Anointing is the ONLY sacrament whose primary
effects include one conditioned on divine judgment about the recipient's
good.

We model this by defining what it means for a sacramental effect to be
conditional, then showing that the other six sacraments' effects (as
axiomatized in SacramentalCausation.lean) are all unconditional.
-/

/-- Whether a sacrament has a conditional primary effect — an effect whose
    conferral depends not just on valid reception but on divine judgment
    about what serves the recipient's salvation.

    MODELING CHOICE: This predicate is our analytical tool for comparing
    sacraments. The CCC does not use the term "conditional effect" — it
    simply states each sacrament's effects, and we observe that Anointing's
    healing effect has an "if" that no other sacrament's effects have. -/
opaque hasConditionalEffect : SacramentKind → Prop

/-- AXIOM: Anointing of the Sick has a conditional primary effect.
    The physical healing effect is conditioned on `conduciveToSalvation`.

    Provenance: [CCC] §1520 ("if it is conducive to the salvation of
    his soul").
    Denominational scope: CATHOLIC. -/
axiom anointing_has_conditional_effect :
  hasConditionalEffect .anointingOfTheSick

/-- AXIOM: Baptism has no conditional primary effect.
    Baptism ALWAYS removes original sin, confers new life, and imprints
    character (§1263-1272). No "if conducive" clause.

    Provenance: [CCC] §1263-1272.
    Denominational scope: CATHOLIC. -/
axiom baptism_no_conditional_effect :
  ¬hasConditionalEffect .baptism

/-- AXIOM: Confirmation has no conditional primary effect.
    Confirmation ALWAYS seals with the Spirit and empowers for mission
    (§1303-1304). No "if conducive" clause.

    Provenance: [CCC] §1303-1304.
    Denominational scope: CATHOLIC. -/
axiom confirmation_no_conditional_effect :
  ¬hasConditionalEffect .confirmation

/-- AXIOM: The Eucharist has no conditional primary effect.
    The Real Presence is ALWAYS effected by valid consecration (§1376).
    No "if conducive" clause.

    Provenance: [CCC] §1376.
    Denominational scope: CATHOLIC. -/
axiom eucharist_no_conditional_effect :
  ¬hasConditionalEffect .eucharist

/-- AXIOM: Reconciliation has no conditional primary effect.
    Reconciliation ALWAYS restores communion and removes guilt (§1468-1472).
    No "if conducive" clause.

    Provenance: [CCC] §1468-1472.
    Denominational scope: CATHOLIC. -/
axiom reconciliation_no_conditional_effect :
  ¬hasConditionalEffect .reconciliation

/-- AXIOM: Holy Orders has no conditional primary effect.
    Holy Orders ALWAYS imprints character and confers sacramental power
    (§1581-1582). No "if conducive" clause.

    Provenance: [CCC] §1581-1582.
    Denominational scope: CATHOLIC. -/
axiom holyOrders_no_conditional_effect :
  ¬hasConditionalEffect .holyOrders

/-- AXIOM: Marriage has no conditional primary effect.
    Marriage ALWAYS creates the bond when validly contracted (§1639).
    No "if conducive" clause.

    Provenance: [CCC] §1639.
    Denominational scope: CATHOLIC. -/
axiom marriage_no_conditional_effect :
  ¬hasConditionalEffect .marriage

-- ============================================================================
-- § 8. Theorems
-- ============================================================================

/-!
### Key results

1. Anointing always achieves spiritual good (strengthening + union with
   Christ's passion) regardless of whether healing occurs.
2. Anointing is the unique sacrament with a conditional primary effect.
3. When death leads to beatifying communion, the sacrament pivots from
   healing to preparation for death.
-/

/-- Anointing always achieves its spiritual effects regardless of whether
    healing occurs. The certain effects do not depend on `conduciveToSalvation`.

    This is the key structural finding: the sacrament's TRUE end (spiritual
    strengthening and union with Christ) is ALWAYS achieved. Physical healing
    is a secondary effect that serves the primary spiritual purpose only
    sometimes. -/
theorem anointing_always_achieves_spiritual_good :
    ∀ (p : Person), seriouslyIll p →
      receivesStrengthening p ∧ unitedToChristsPassion p :=
  fun p h => ⟨anointing_confers_strengthening p h, anointing_unites_to_passion p h⟩

/-- Anointing is the ONLY sacrament among the seven with a conditional
    primary effect.

    This is the uniqueness theorem: for every sacrament kind, it has a
    conditional effect if and only if it is Anointing of the Sick. -/
theorem anointing_uniquely_conditional :
    ∀ (s : SacramentKind), hasConditionalEffect s ↔ s = .anointingOfTheSick := by
  intro s
  constructor
  · -- Forward: if it has a conditional effect, it must be anointing
    intro h
    cases s with
    | baptism => exact absurd h baptism_no_conditional_effect
    | confirmation => exact absurd h confirmation_no_conditional_effect
    | eucharist => exact absurd h eucharist_no_conditional_effect
    | reconciliation => exact absurd h reconciliation_no_conditional_effect
    | anointingOfTheSick => rfl
    | holyOrders => exact absurd h holyOrders_no_conditional_effect
    | marriage => exact absurd h marriage_no_conditional_effect
  · -- Backward: anointing has a conditional effect
    intro h
    cases h
    exact anointing_has_conditional_effect

/-- When death leads to beatifying communion, anointing pivots from healing
    to preparation for death. The sacrament responds to the person's
    spiritual situation: if they are ready for heaven, it prepares them
    for the journey rather than delaying it through healing.

    This connects three axioms: beatifying_communion_excludes_conducive
    (DivineModes connection), anointing_heals_if_conducive (the conditional
    clause), and anointing_prepares_for_death (the viaticum dimension). -/
theorem anointing_pivots_at_deaths_door :
    ∀ (p : Person), seriouslyIll p → deathLeadsToBeatifyingCommunion p →
      preparedForFinalJourney p ∧ ¬conduciveToSalvation p :=
  fun p h_ill h_death =>
    let h_not_conducive := beatifying_communion_excludes_conducive p h_death
    ⟨anointing_prepares_for_death p h_ill h_not_conducive, h_not_conducive⟩

/-- The "if conducive" clause is non-vacuous: there genuinely exist cases
    where healing does not occur because it would not serve salvation.

    This follows from `healing_salvation_tension` (the hidden assumption
    that the tension is real). Without this theorem, the conditional
    effect might be an empty formality. -/
theorem conditional_effect_is_nonvacuous :
    ∃ (p : Person), seriouslyIll p ∧ ¬conduciveToSalvation p := healing_salvation_tension

/-- When Penance is unavailable, Anointing provides BOTH spiritual
    strengthening AND forgiveness — it fills the gap left by the
    inaccessible sacrament. This makes Anointing a spiritual safety net
    at the boundary of death.

    This theorem wires `anointing_confers_forgiveness_if_no_penance`
    together with the certain spiritual effects. -/
theorem anointing_fills_penance_gap :
    ∀ (p : Person), seriouslyIll p → unableToReceivePenance p →
      receivesStrengthening p ∧ receivesForgiveness p ∧ unitedToChristsPassion p :=
  fun p h_ill h_no_pen =>
    ⟨anointing_confers_strengthening p h_ill,
     anointing_confers_forgiveness_if_no_penance p h_ill h_no_pen,
     anointing_unites_to_passion p h_ill⟩

/-- When healing IS conducive, the sick person receives BOTH spiritual
    effects AND physical healing — the full complement of Anointing's
    effects.

    This shows the maximal case: when all conditions are met, Anointing
    confers strengthening, union with Christ's passion, AND physical
    healing. (Forgiveness is also conferred if Penance was unavailable,
    but that has its own separate condition.) -/
theorem anointing_full_effects_when_conducive :
    ∀ (p : Person), seriouslyIll p → conduciveToSalvation p →
      receivesStrengthening p ∧ unitedToChristsPassion p ∧ receivesHealing p :=
  fun p h_ill h_cond =>
    ⟨anointing_confers_strengthening p h_ill,
     anointing_unites_to_passion p h_ill,
     anointing_heals_if_conducive p h_ill h_cond⟩

/-- When healing is NOT conducive, the person still receives all spiritual
    effects plus preparation for death. The sacrament never fails to confer
    grace — it adapts its effects to what the person needs.

    This is the complement of `anointing_full_effects_when_conducive`:
    the sacrament achieves spiritual good in BOTH cases. -/
theorem anointing_spiritual_effects_when_not_conducive :
    ∀ (p : Person), seriouslyIll p → ¬conduciveToSalvation p →
      receivesStrengthening p ∧ unitedToChristsPassion p ∧ preparedForFinalJourney p :=
  fun p h_ill h_not =>
    ⟨anointing_confers_strengthening p h_ill,
     anointing_unites_to_passion p h_ill,
     anointing_prepares_for_death p h_ill h_not⟩

/-- Anointing covers both cases exhaustively: for any seriously ill person,
    EITHER healing occurs (when conducive) OR preparation for death occurs
    (when not conducive). The sacrament always acts — the question is only
    WHICH secondary effect it produces.

    This uses classical logic (excluded middle on `conduciveToSalvation p`),
    which is theologically appropriate: God's judgment is definite even if
    unknown to us. -/
theorem anointing_exhaustive_coverage :
    ∀ (p : Person), seriouslyIll p →
      (receivesHealing p ∨ preparedForFinalJourney p) := by
  intro p h_ill
  by_cases h : conduciveToSalvation p
  · exact Or.inl (anointing_heals_if_conducive p h_ill h)
  · exact Or.inr (anointing_prepares_for_death p h_ill h)

/-- Connection to SacramentalCausation: Anointing's dispositional change
    (from SacramentalCausation.lean) corresponds to the strengthening effect.
    This bridge links the causation taxonomy (dispositional change) with
    the specific content of that change (strengthening, peace, courage).

    Uses `anointing_causes_dispositional` from SacramentalCausation.lean. -/
theorem anointing_dispositional_is_strengthening :
    causesChangeOfType .anointingOfTheSick .dispositional := anointing_causes_dispositional

/-- Connection to SacramentalCausation: Anointing's relational change
    corresponds to union with Christ's Passion.

    Uses `anointing_causes_relational` from SacramentalCausation.lean. -/
theorem anointing_relational_is_union_with_passion :
    causesChangeOfType .anointingOfTheSick .relational := anointing_causes_relational

-- ============================================================================
-- § 9. Summary
-- ============================================================================

/-!
## Summary: What the formalization reveals

**Answer to the main question**: YES — the "if conducive" clause makes
Anointing's operation fundamentally different from baptism/Eucharist.

The difference is NOT that Anointing is weaker or less efficacious. The
difference is structural:

1. **Other sacraments have FIXED targets**: Baptism always targets original
   sin. Eucharist always effects Real Presence. Reconciliation always
   restores communion. The sacrament does the same thing every time.

2. **Anointing has an ADAPTIVE target**: It always confers spiritual
   strengthening and union with Christ's passion. But its secondary effect
   ADAPTS to divine judgment: healing when that serves salvation,
   preparation for death when death serves salvation better.

3. **The conditionality encodes a PRIORITY**: spiritual goods over temporal
   goods. Physical healing is good, but not if it comes at the cost of
   eternal salvation. This priority is implicit in all Catholic theology
   but EXPLICIT only in Anointing's effects.

**Key findings:**

- `anointing_uniquely_conditional`: Anointing is the only sacrament with
  a conditional primary effect (biconditional across all seven).
- `anointing_always_achieves_spiritual_good`: The spiritual effects are
  unconditional — the sacrament never fails to confer grace.
- `anointing_pivots_at_deaths_door`: When death leads to beatifying
  communion, the sacrament prepares for death rather than preventing it.
- `healing_salvation_tension`: The hidden assumption that makes the
  conditional clause non-vacuous — physical health and eternal salvation
  CAN be in tension.
- `anointing_exhaustive_coverage`: The sacrament covers both cases —
  healing or preparation for death, exhaustively.
-/

end Catlib.Sacraments.Anointing
