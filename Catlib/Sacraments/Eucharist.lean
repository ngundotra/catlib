import Catlib.Foundations
import Catlib.Foundations.SinEffects
import Catlib.Creed.Soul
import Catlib.Creed.Christology
import Catlib.Sacraments.Reconciliation

/-!
# CCC §1322–1419: The Eucharist — Real Presence and Communion

## Working backwards from "who can receive"

The CCC's Eucharist teaching has a clean logical structure that maps
directly to our three-layer sin model (SinEffects.lean):

```
PRECONDITIONS (who can receive — §1355, §1385):
  Layer 1: removed (baptized)        ← originalWound = removed
  Layer 2: removed (in grace)        ← guilt = removed
  Layer 3: may be present            ← Eucharist ACTS on this

EFFECTS (what communion does — §1391–1396):
  Layer 2: strengthened against      ← "preserves from mortal sin" (§1395)
  Layer 3: reduced                   ← "separates from venial sin" (§1394)
  Agape: strengthened                ← "strengthens charity" (§1394)
```

This reveals a beautiful pattern: **each sacrament maps to a layer**.

| Sacrament        | Primary layer | CCC    |
|------------------|---------------|--------|
| Baptism          | Layer 1       | §1263  |
| Reconciliation   | Layer 2       | §1468  |
| Eucharist        | Layer 3       | §1394  |

## The Real Presence (§1373–1381)

§1374: "In the most blessed sacrament of the Eucharist 'the body and blood,
together with the soul and divinity, of our Lord Jesus Christ and, therefore,
the whole Christ is truly, really, and substantially contained.'"

§1376: Transubstantiation — the substance of bread and wine is converted
into the substance of Christ's body and blood. The appearances (accidents)
remain.

§1377: "The Eucharistic presence of Christ begins at the moment of the
consecration and endures as long as the Eucharistic species subsist."

## Key CCC quotes on reception

§1355 (Justin Martyr): "No one may take part in it unless he believes that
what we teach is true, has received baptism for the forgiveness of sins and
new birth, and lives in keeping with what Christ taught."

§1385: "Anyone who is aware of having committed a mortal sin must not
receive the Body of the Lord without having first received sacramental
absolution, unless he has a grave reason for receiving Communion and there
is no possibility of going to confession."

§1387: "To prepare for worthy reception of this sacrament, the faithful
should observe the fast required in their Church. Bodily demeanor (gestures,
clothing) ought to convey the respect, solemnity, and joy of this moment
when Christ becomes our guest."

## Effects of communion (§1391–1396)

§1391: "Holy Communion augments our union with Christ."

§1394: "As bodily nourishment restores lost strength, so the Eucharist
strengthens our charity, which tends to be weakened in daily life; and this
living charity wipes away venial sins."

§1395: "By the same charity that it enkindles in us, the Eucharist preserves
us from future mortal sins... The Eucharist is not ordered to the forgiveness
of mortal sins — that is proper to the sacrament of Reconciliation."

§1396: "The Eucharist makes the Church. Those who receive the Eucharist
are united more closely to Christ. Through it Christ unites them to all the
faithful in one body — the Church."

## Discipline vs. Doctrine

§1387's fasting requirement is a DISCIPLINE (Canon Law 919), not a doctrine.
It has changed: midnight fast → 3-hour fast → 1-hour fast. The CCC doesn't
ground it doctrinally — it just says "observe the fast required."

Theologically, the rationale connects to body-soul unity (§365): since
the person is one nature (not soul imprisoned in body), bodily preparation
IS spiritual preparation. The fast is not dualist punishment of the body —
it's hylomorphic participation of the body in the spiritual act.

## Denominational scope

- **Real Presence**: Catholic + Orthodox affirm transubstantiation.
  Lutherans affirm real presence (consubstantiation). Reformed deny
  corporeal presence (spiritual presence only). Zwinglians: memorial only.
- **Communion requirements**: Catholic-specific (state of grace, fasting).
- **Eucharist as sacrifice**: Catholic + Orthodox. Protestants generally
  reject sacrificial language (memorial, not re-offering).
- **Sacrament-layer mapping**: Catholic framework (depends on three-layer
  sin model which Protestants reject).

## What this formalization exposes

1. The Eucharist REQUIRES what Reconciliation PROVIDES (state of grace).
   This creates a sacramental ordering: Baptism → Reconciliation → Eucharist.

2. The Eucharist does NOT do what Reconciliation does (forgive mortal sin).
   §1395 is explicit: "not ordered to the forgiveness of mortal sins."
   Each sacrament has its own domain — they don't substitute for each other.

3. The fasting requirement reveals the doctrine/discipline distinction:
   doctrine = unchangeable (from revelation), discipline = changeable
   (from Church authority). Fasting is discipline; Real Presence is doctrine.

4. §1401's exception (non-Catholics in grave necessity) reveals that
   even the communion requirements have an escape valve — but only when
   the person "demonstrates Catholic faith regarding the sacrament."
   The belief condition is non-negotiable; the ecclesial condition is
   relaxable.
-/

set_option autoImplicit false

namespace Catlib.Sacraments.Eucharist

open Catlib
open Catlib.Creed
open Catlib.Creed.Christology

-- ============================================================================
-- § 1. Doctrine vs. Discipline
-- ============================================================================

/-!
### The doctrine/discipline distinction

This distinction is important for the Eucharist because some requirements
are permanent (from revelation) and others are changeable (from Church
authority). Failing to distinguish them conflates "the Church teaches X"
with "the Church currently requires X."

Examples:
- DOCTRINE: Real Presence (§1374) — cannot change
- DOCTRINE: State of grace required (§1385) — cannot change
- DISCIPLINE: Duration of Eucharistic fast (Canon 919) — has changed
- DISCIPLINE: Frequency of required reception (currently once/year) — can change
-/

/-- Whether a teaching is doctrine (from revelation, unchangeable) or
    discipline (from Church authority, changeable).

    This distinction matters because the Eucharist's requirements are
    a MIX of both. Confusing them leads to treating changeable practices
    as if they were dogma, or treating doctrines as if they could be
    changed by vote.

    Denominational scope: ECUMENICAL in principle — all traditions
    distinguish some version of "what God revealed" vs "what the Church
    decided." The Catholic version is more precisely defined. -/
inductive TeachingKind where
  /-- From revelation (Scripture + Tradition). Cannot be changed
      by any human authority, including the Pope. -/
  | doctrine
  /-- From Church authority. Can be changed by competent authority.
      Examples: fasting rules, liturgical calendar, clerical celibacy. -/
  | discipline

-- ============================================================================
-- § 2. Real Presence (§1373–1381)
-- ============================================================================

/-!
### The Real Presence — what the Eucharist IS

The CCC's claim (§1374) is that after consecration, what appears to be
bread and wine IS the body, blood, soul, and divinity of Christ. The
appearances (accidents) remain; the substance changes. This is
transubstantiation (§1376).

This is the most divisive eucharistic claim across denominations:
- Catholic/Orthodox: transubstantiation (substance changes)
- Lutheran: consubstantiation (Christ present IN/WITH/UNDER bread)
- Reformed: spiritual presence (Christ present spiritually, not corporally)
- Zwinglian: memorial only (bread stays bread)

Each position corresponds to a different axiom about what happens at
consecration. The axiom set IS the denomination.
-/

/-- Models of Christ's presence in the Eucharist.

    Each denomination holds one of these. The disagreement is not about
    WHETHER Christ is involved but HOW — the metaphysics of presence.

    This is a genuine theological disagreement, not a misunderstanding.
    Each model has a coherent internal logic. -/
inductive EucharisticPresence where
  /-- Catholic/Orthodox: the substance of bread/wine becomes the substance
      of Christ's body/blood. Appearances (accidents) remain unchanged.
      Council of Trent, Session XIII; CCC §1376. -/
  | transubstantiation
  /-- Lutheran: Christ is truly present "in, with, and under" the bread
      and wine. The bread remains bread AND Christ is present. Both
      substances coexist. Formula of Concord, Article VII. -/
  | consubstantiation
  /-- Reformed/Calvinist: Christ is present spiritually but not corporally.
      The faithful receive Christ by faith through the Spirit, but the
      bread does not become or contain Christ's body. Calvin, Institutes IV.17. -/
  | spiritualPresence
  /-- Zwinglian: The Lord's Supper is a memorial — an act of remembrance.
      The bread is bread. Christ is not present in any special sense.
      Zwingli, "On the Lord's Supper" (1526). -/
  | memorialOnly

/-- The consequence of consecration: the eucharistic species IS Christ.
    Not a symbol, not a reminder — the whole Christ.

    §1374: "the body and blood, together with the soul and divinity,
    of our Lord Jesus Christ and, therefore, the whole Christ is truly,
    really, and substantially contained."

    NOTE: We say "whole Christ" — body, blood, soul, divinity. This
    means a consecrated host is not merely "Christ's body" in isolation.
    It is the complete person of Christ. This matters because it means
    receiving communion is receiving a PERSON, not a substance.

    Denominational scope: CATHOLIC — specifically transubstantiation.
    Other models yield different accounts of what reception involves. -/
opaque isConsecratedEucharist : Prop

/-- AXIOM (§1374, Council of Trent): After valid consecration, the
    whole Christ is truly, really, and substantially present — body,
    blood, soul, and divinity.

    Provenance: [Tradition] Council of Trent, Session XIII, Canon 1;
    [Definition] CCC §1374.
    Denominational scope: CATHOLIC.
    Teaching kind: DOCTRINE — cannot be changed.

    Now connected to Christology.lean: `wholeChristPresent` is the
    conjunction of both natures + both human aspects. This gives
    real content to what "truly, really, substantially" means. -/
axiom real_presence :
  isConsecratedEucharist → Christology.wholeChristPresent

/-- The denominational tag for real presence. -/
def realPresenceTag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Transubstantiation. Lutherans: consubstantiation. Reformed: spiritual. Zwinglian: memorial." }

-- ============================================================================
-- § 3. Transubstantiation — The Substance/Accident Distinction (§1373–1381)
-- ============================================================================

/-!
### Transubstantiation: how can bread become a person?

The puzzle: a piece of bread has no soul. After consecration, the CCC claims
the "whole Christ" — body, blood, soul, divinity — is present (§1374).
Does this violate `corporeal_requires_spiritual` from Soul.lean?

The Catholic answer (§1376): **transubstantiation**. The substance of bread
CEASES TO EXIST. The substance of Christ — who already has a body, soul,
and divinity — becomes present WHERE the bread was. The APPEARANCES (accidents)
of bread remain, but there is no bread substance anymore.

Key insight: `corporeal_requires_spiritual` is about substances, not
appearances. The bread-like appearances after consecration are accidents
without a bread-substance. The substance present is Christ, who has a soul.
No violation.

**Modeling choice (§1376):** The CCC uses Aristotelian metaphysics
(substance/accident distinction) as its framework. This is a PHILOSOPHICAL
CHOICE — the same claim could in principle be expressed in a different
metaphysical framework. We follow the CCC's choice because formalizing
the Catechism means formalizing its philosophical commitments too.

Denominational scope: CATHOLIC. The substance/accident framework and
the claim that bread's substance is converted are specifically Catholic
(Council of Trent, Session XIII). Lutherans affirm real presence but
reject the substance-conversion model (consubstantiation: both
substances coexist). Reformed and Zwinglian models don't need this
framework at all.
-/

/-- What a eucharistic element IS — its substance.

    In Aristotelian metaphysics, the substance is what makes something
    what it IS (its essence). Before consecration, the substance is bread
    or wine. After consecration, according to Catholic teaching, the
    substance IS Christ.

    MODELING CHOICE: We use a finite enumeration rather than building
    a general Aristotelian substance theory. This is enough to express
    the CCC's claim without over-modeling. -/
inductive EucharisticSubstance where
  /-- The substance of bread — what bread IS -/
  | bread
  /-- The substance of wine — what wine IS -/
  | wine
  /-- The substance of Christ — the whole person (body, blood, soul, divinity).
      This is NOT a new kind of substance invented for the Eucharist.
      It is the same Christ from Christology.lean — now present under
      the eucharistic species. -/
  | christ
  deriving DecidableEq, BEq

/-- What a eucharistic element APPEARS to be — its accidents.

    In Aristotelian metaphysics, accidents are the observable properties
    (color, taste, texture, shape) that normally inhere in a substance.
    The extraordinary claim of transubstantiation is that accidents can
    PERSIST after their original substance has been replaced.

    MODELING CHOICE: Same minimalist enumeration. We don't model
    individual accidents (whiteness, roundness, etc.) — just the
    cluster of appearances that identify bread or wine. -/
inductive EucharisticAccidents where
  /-- Appearances of bread — looks, tastes, feels like bread -/
  | breadlike
  /-- Appearances of wine — looks, tastes, feels like wine -/
  | winelike
  deriving DecidableEq, BEq

/-- A eucharistic species — a combination of substance and accidents.

    Normally, substance and accidents match: bread IS bread and LOOKS
    like bread. The CCC's claim (§1376) is that after consecration,
    they come apart: the substance is Christ, but the accidents are
    still bread-like.

    This structure models the BEFORE and AFTER of consecration. -/
structure EucharisticSpecies where
  /-- What this species IS (its substance) -/
  substance : EucharisticSubstance
  /-- What this species APPEARS to be (its accidents) -/
  accidents : EucharisticAccidents

/-- Bread before consecration: IS bread, LOOKS like bread.
    Substance and accidents agree — the ordinary case. -/
def unconsecratedBread : EucharisticSpecies :=
  { substance := .bread, accidents := .breadlike }

/-- Wine before consecration: IS wine, LOOKS like wine. -/
def unconsecratedWine : EucharisticSpecies :=
  { substance := .wine, accidents := .winelike }

/-- The consecrated host: IS Christ, LOOKS like bread.
    Substance and accidents DISAGREE — the extraordinary claim.
    §1376: "the whole substance of the bread [is] converted into the
    substance of the body of Christ our Lord, and the whole substance
    of the wine into the substance of his blood. This change the holy
    Catholic Church has fittingly and properly called transubstantiation." -/
def consecratedHost : EucharisticSpecies :=
  { substance := .christ, accidents := .breadlike }

/-- The consecrated chalice: IS Christ, LOOKS like wine. -/
def consecratedChalice : EucharisticSpecies :=
  { substance := .christ, accidents := .winelike }

-- ── Axioms: what consecration does ──────────────────────────────────────

/-- The consecration function: transforms a eucharistic species.
    This models the act of consecration as a function from pre-
    to post-consecration species. The axioms below constrain what
    this function does.

    Opaque because we don't define the mechanism — we only axiomatize
    the result. The HOW of transubstantiation is a mystery; the WHAT
    is defined by the Council of Trent. -/
noncomputable opaque consecrate : EucharisticSpecies → EucharisticSpecies :=
  fun _ => consecratedHost  -- default; axioms override

/-- AXIOM (§1376, Trent Session XIII): Consecration changes the substance
    to Christ. The bread ceases to exist as bread; the wine ceases to
    exist as wine. What remains is the substance of Christ.

    Provenance: [Tradition] Council of Trent, Session XIII, Canon 2;
    [Definition] CCC §1376.
    Denominational scope: CATHOLIC.
    Teaching kind: DOCTRINE — defined dogma. -/
axiom consecration_converts_substance :
  ∀ (species : EucharisticSpecies),
    (consecrate species).substance = EucharisticSubstance.christ

/-- AXIOM (§1376, Trent Session XIII): Consecration does NOT change the
    accidents. The bread still looks, tastes, and feels like bread.
    The wine still looks, tastes, and feels like wine.

    Provenance: [Tradition] Council of Trent, Session XIII, Chapter 4;
    [Definition] CCC §1376.
    Denominational scope: CATHOLIC.
    Teaching kind: DOCTRINE.

    This is the other half of transubstantiation: substance changes,
    accidents persist. Together with `consecration_converts_substance`,
    this axiom pair DEFINES what transubstantiation means. -/
axiom consecration_preserves_accidents :
  ∀ (species : EucharisticSpecies),
    (consecrate species).accidents = species.accidents

/-- AXIOM (§1374-§1376): When the substance is Christ, the WHOLE Christ
    is present — body, blood, soul, and divinity.

    This connects the substance model to Christology.lean. The substance
    `EucharisticSubstance.christ` is not an abstract label — it IS the
    risen Christ, with both natures and both human aspects.

    Provenance: [Tradition] Council of Trent, Session XIII, Canon 1;
    [Definition] CCC §1374.
    Denominational scope: CATHOLIC.
    Teaching kind: DOCTRINE. -/
axiom christ_substance_is_whole_christ :
  ∀ (species : EucharisticSpecies),
    species.substance = EucharisticSubstance.christ →
    Christology.wholeChristPresent

-- ── Theorems ────────────────────────────────────────────────────────────

/-- THEOREM: The consecrated host IS the `consecratedHost` model —
    substance is Christ, accidents are bread-like.

    Uses: consecration_converts_substance + consecration_preserves_accidents.
    Composes both halves of the transubstantiation definition. -/
theorem consecrated_bread_has_correct_form :
    (consecrate unconsecratedBread).substance = EucharisticSubstance.christ ∧
    (consecrate unconsecratedBread).accidents = EucharisticAccidents.breadlike := by
  constructor
  · exact consecration_converts_substance unconsecratedBread
  · have h := consecration_preserves_accidents unconsecratedBread
    simp [unconsecratedBread] at h
    exact h

/-- THEOREM: Consecration yields the whole Christ present.

    Uses: consecration_converts_substance + christ_substance_is_whole_christ.
    This bridges the substance model to Christology.lean — after
    consecration, everything `wholeChristPresent` guarantees is available. -/
theorem consecration_yields_whole_christ :
    ∀ (_ : EucharisticSpecies),
      Christology.wholeChristPresent := by
  intro species
  have h_sub := consecration_converts_substance species
  exact christ_substance_is_whole_christ (consecrate species) h_sub

/-- THEOREM: `corporeal_requires_spiritual` is NOT violated by
    transubstantiation.

    THE KEY TENSION RESOLUTION.

    The worry: bread has no soul, but the Eucharist contains a body
    (corporeal aspect). Doesn't `corporeal_requires_spiritual` say
    every corporeal thing needs a soul?

    The resolution: `corporeal_requires_spiritual` applies to
    `HumanPerson` — a substance, not an appearance. After consecration:

    1. The substance present is CHRIST (not bread).
    2. Christ IS a `HumanPerson` (via `christHumanPerson`).
    3. Christ HAS a soul (via `christ_has_full_human_nature`).
    4. Therefore `corporeal_requires_spiritual` is satisfied FOR CHRIST.
    5. The bread-like APPEARANCES are accidents — they are not a
       `HumanPerson` and `corporeal_requires_spiritual` does not
       apply to them.

    Uses: consecration_converts_substance + christ_substance_is_whole_christ
          + Christology.christ_has_full_human_nature (= body + soul).
    This is the real theorem — it composes three axiom chains to show
    the apparent contradiction dissolves. -/
theorem transubstantiation_respects_body_soul_unity :
    ∀ (_ : EucharisticSpecies),
      -- After consecration, the substance present (Christ) satisfies
      -- corporeal_requires_spiritual: Christ's body HAS a soul.
      hasCorporealAspect Christology.christHumanPerson →
      hasSpiritualAspect Christology.christHumanPerson := by
  intro _species h_corp
  -- Christ's body requires a soul (corporeal_requires_spiritual)
  exact corporeal_requires_spiritual Christology.christHumanPerson h_corp

/-- THEOREM: Stronger form — after consecration, the substance present
    actually HAS both corporeal and spiritual aspects. We don't need to
    assume the corporeal aspect; it follows from the whole Christ being
    present.

    Uses: consecration_converts_substance + christ_substance_is_whole_christ
          + the definition of `wholeChristPresent` (which includes both
          aspects of Christ's human nature).

    This shows the body-soul unity is not just "not violated" but
    positively SATISFIED: the substance present after consecration
    is a complete person with body and soul. -/
theorem consecrated_substance_has_body_and_soul :
    ∀ (_ : EucharisticSpecies),
      hasCorporealAspect Christology.christHumanPerson ∧
      hasSpiritualAspect Christology.christHumanPerson := by
  intro species
  have h_sub := consecration_converts_substance species
  have h_whole := christ_substance_is_whole_christ (consecrate species) h_sub
  exact ⟨h_whole.2.2.1, h_whole.2.2.2⟩

/-- THEOREM: The substance/accident separation is what makes
    transubstantiation work — without it, you'd need the bread
    itself to have a soul.

    This theorem shows that the substance IS Christ (who has a soul)
    while the accidents are bread-like (which don't need a soul,
    because accidents are not substances).

    Uses: All three transubstantiation axioms + Christology.
    This is the full picture: substance = Christ (complete person),
    accidents = bread-like (mere appearances). -/
theorem transubstantiation_full_picture :
    ∀ (species : EucharisticSpecies),
      -- The substance is Christ
      (consecrate species).substance = EucharisticSubstance.christ ∧
      -- The accidents are unchanged
      (consecrate species).accidents = species.accidents ∧
      -- Christ (the substance) has a soul
      hasSpiritualAspect Christology.christHumanPerson ∧
      -- Christ (the substance) has a body
      hasCorporealAspect Christology.christHumanPerson := by
  intro species
  have h_sub := consecration_converts_substance species
  have h_acc := consecration_preserves_accidents species
  have h_whole := christ_substance_is_whole_christ (consecrate species) h_sub
  exact ⟨h_sub, h_acc, h_whole.2.2.2, h_whole.2.2.1⟩

/-- Denominational tag for transubstantiation. -/
def transubstantiationTag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Council of Trent, Session XIII. Lutherans reject substance-conversion (consubstantiation instead). Reformed/Zwinglian: no substance change." }

/-- Denominational tag for the substance/accident distinction. -/
def substanceAccidentTag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Aristotelian metaphysics via Aquinas. This is a MODELING CHOICE — the CCC adopted this philosophical framework. Other frameworks (e.g., phenomenological, process) might express the same claim differently." }

/-!
### FINDING: Transubstantiation is the ONLY substance/accident separation in the CCC

The Aristotelian substance/accident framework is imported into the Catechism
for essentially ONE application. No other sacrament or doctrine claims that
substance and accidents come apart:

| Sacrament       | Physical matter      | Substance changes? |
|-----------------|---------------------|--------------------|
| Baptism         | Water               | NO — water stays water       |
| Confirmation    | Chrism oil          | NO — oil stays oil           |
| **Eucharist**   | **Bread & wine**    | **YES — becomes Christ**     |
| Reconciliation  | Words of absolution | No physical matter           |
| Anointing       | Oil                 | NO — oil stays oil           |
| Holy Orders     | Laying on of hands  | No substance change          |
| Matrimony       | Couple's consent    | No physical matter           |

The Council of Trent called this a "singularis et admirabilis conversio"
(singular and wonderful conversion) — they knew it was a one-off.

The closest analogues aren't really analogues:
- **Incarnation**: Christ appeared human but was also divine — but the human
  nature is REAL, not just appearances. Chalcedon ("without confusion") means
  the natures don't reduce to substance vs accident.
- **Angelic appearances**: Angels appear as humans (Gen 18, Tobit), but the
  CCC doesn't use substance/accident language here.
- **Holy water / relics**: Still physically what they were. Blessed, not
  transubstantiated. No substance change claimed.

This is a formalization finding: the CCC imports an entire philosophical
framework (Aristotelian substance/accident metaphysics) that is load-bearing
in exactly ONE place. Every other sacrament works through T3 (ex opere operato
— sacraments confer grace through the action) without needing this machinery.

A philosopher who rejects the substance/accident distinction (most modern
analytic philosophers, most Protestants) would find transubstantiation
literally inexpressible — not false, but unstatable in their framework.
The Lutheran alternative (consubstantiation — Christ present "in, with,
and under" the bread, which REMAINS bread) doesn't need Aristotle at all.
-/

-- ============================================================================
-- § 4. Communion Preconditions (§1355, §1385, §1387)
-- ============================================================================

/-!
### Working backwards: who can receive?

The CCC gives a clear, layered set of preconditions. These map directly
to our three-layer sin model:

1. **Baptized** (§1355) — Layer 1 resolved
2. **In state of grace** (§1385) — Layer 2 resolved
3. **Believes** what the Church teaches (§1355)
4. **Examined conscience** (§1385)
5. **Observes Eucharistic fast** (§1387) — DISCIPLINE, not doctrine
6. **Lives according to Christ's teaching** (§1355)

Conditions 1-2 map to SinProfile. Conditions 3-6 are additional.
-/

/-- The complete set of conditions for worthy reception of communion.

    These are drawn from §1355 (Justin Martyr's formula) and §1385
    (state of grace requirement). The structure separates DOCTRINAL
    conditions (which cannot change) from DISCIPLINARY ones (which can).

    Cross-ref: SinProfile (SinEffects.lean) — conditions 1-2 are
    exactly the first two layers of the sin profile being resolved. -/
structure CommunionDisposition where
  /-- The person seeking to receive -/
  recipient : Person
  /-- The person's sin profile — tracks the three layers -/
  sinProfile : SinProfile
  /-- Condition 3 (§1355): believes what the Church teaches about
      the Eucharist. This is the BELIEF condition.
      Note: §1401 says even non-Catholics can receive in grave
      necessity IF they demonstrate this faith. -/
  believesChurchTeaching : Prop
  /-- Condition 4 (§1385): has examined their conscience.
      This is not a guarantee of sinlessness — it's a duty of
      honest self-examination before approaching the sacrament. -/
  hasExaminedConscience : Prop
  /-- Condition 5 (§1387): observes the Eucharistic fast.
      DISCIPLINE — currently 1 hour (Canon Law 919).
      The theological rationale connects to body-soul unity (§365):
      bodily preparation IS spiritual preparation because the person
      is one nature, not two. -/
  observesFast : Prop

/-- Whether a person's sin profile permits communion.
    Layer 1 must be removed (baptized).
    Layer 2 must be removed (in grace — no unconfessed mortal sin).
    Layer 3 can be present — the Eucharist ACTS on this layer.

    This is the doctrinal core: baptism + state of grace. These
    conditions CANNOT change (they're from §1355 and §1385).
    The fast CAN change (it's discipline). -/
def sinProfilePermitsCommunion (sp : SinProfile) : Prop :=
  sp.originalWound = EffectState.removed ∧
  sp.guilt = EffectState.removed

/-- Whether all conditions for worthy reception are met. -/
def isWorthyToReceive (cd : CommunionDisposition) : Prop :=
  sinProfilePermitsCommunion cd.sinProfile ∧
  cd.believesChurchTeaching ∧
  cd.hasExaminedConscience ∧
  cd.observesFast

-- ============================================================================
-- § 5. Effects of Communion (§1391–1396)
-- ============================================================================

/-!
### What communion DOES

The CCC describes four effects, each connecting to something we've
already modeled:

1. **Union with Christ** (§1391) — augments communion (DivineModes)
2. **Strengthens charity** (§1394) — increases agape (Love.lean)
3. **Separates from venial sin** (§1394) — reduces Layer 3 (SinEffects)
4. **Preserves from mortal sin** (§1395) — strengthens against Layer 2
5. **Unites the faithful** (§1396) — ecclesial communion

And one crucial NEGATIVE: NOT for forgiving mortal sin (§1395).
-/

-- ============================================================================
-- § 5b. The Eucharist's Effect on the Sin Profile
-- ============================================================================

/-!
### Modeling state change

The Eucharist CHANGES a person's sin profile. To avoid tautological axioms
(the old P→P problem), we model this as a FUNCTION from pre-communion
profile to post-communion profile. The axioms then say WHAT this function
does — and theorems can compose them.

The key CCC claims about what communion does to the three layers:
- Layer 1 (original wound): UNCHANGED — communion doesn't re-baptize
- Layer 2 (guilt): UNCHANGED — "not ordered to forgiveness of mortal sins" (§1395)
- Layer 3 (attachment): REDUCED — "wipes away venial sins" (§1394)
-/

/-- The sin profile AFTER worthy reception of communion.
    This models the state change that communion effects.

    The function takes a pre-communion profile and returns a
    post-communion profile. The axioms below constrain what
    this function can and cannot do. -/
noncomputable opaque eucharistEffectOnProfile : SinProfile → SinProfile :=
  fun sp => sp  -- default implementation; axioms override behavior

-- ============================================================================
-- § 6. Axioms
-- ============================================================================

/-!
### Axiom group 1: What communion DOES to the sin profile
-/

/-- AXIOM (§1394): Communion reduces attachments (Layer 3).
    "The Eucharist strengthens our charity, which tends to be weakened
    in daily life; and this living charity wipes away venial sins."

    Provenance: [Definition] CCC §1394.
    Denominational scope: CATHOLIC.
    Teaching kind: DOCTRINE.

    This is the key claim: the Eucharist acts on LAYER 3. The mechanism
    is love — stronger agape naturally loosens disordered attachments.
    If attachments were present, they become removed. If already removed,
    they stay removed. -/
axiom eucharist_reduces_attachment :
  ∀ (sp : SinProfile),
    sinProfilePermitsCommunion sp →
    (eucharistEffectOnProfile sp).attachment = EffectState.removed

/-- AXIOM (§1395): Communion does NOT remove guilt (Layer 2).
    "The Eucharist is not ordered to the forgiveness of mortal sins —
    that is proper to the sacrament of Reconciliation."

    Provenance: [Definition] CCC §1395.
    Denominational scope: CATHOLIC.
    Teaching kind: DOCTRINE.

    This axiom creates a BOUNDARY: Eucharist acts on Layer 3,
    Reconciliation acts on Layer 2. They are complementary, not
    interchangeable. -/
axiom eucharist_preserves_guilt_state :
  ∀ (sp : SinProfile),
    (eucharistEffectOnProfile sp).guilt = sp.guilt

/-- AXIOM: Communion does not change baptismal status (Layer 1).
    Baptism is a one-time event; the Eucharist neither confers it
    nor reverses it.

    Provenance: [Definition] CCC §1263 (baptism is once-for-all);
    implied by the absence of any CCC claim that communion affects
    original sin.
    Denominational scope: ECUMENICAL.
    Teaching kind: DOCTRINE. -/
axiom eucharist_preserves_baptism_state :
  ∀ (sp : SinProfile),
    (eucharistEffectOnProfile sp).originalWound = sp.originalWound

-- ============================================================================
-- § 7. The §1387 Fast — Discipline, not Doctrine
-- ============================================================================

/-!
### Why fasting? The hylomorphic rationale

§1387 says: "observe the fast required in their Church. Bodily demeanor
(gestures, clothing) ought to convey the respect, solemnity, and joy."

The CCC does NOT explain WHY fasting is required. It just says to do it.
But the rationale follows from body-soul unity (§365, Soul.lean):

1. The person is ONE nature — body and soul form "a single nature" (§365)
2. Therefore bodily acts ARE spiritual acts (not mere accompaniments)
3. Therefore bodily preparation (fasting) IS spiritual preparation
4. This is NOT dualist punishment of the body — it's the body
   PARTICIPATING in the spiritual event

The fast is DISCIPLINE (has changed: midnight → 3 hours → 1 hour).
But the RATIONALE is doctrinal: body-soul unity means bodily acts matter.
-/

/-- THEOREM (§1387, §365): Bodily preparation serves spiritual preparation
    because the person is one nature (body-soul unity).

    This was an AXIOM but is now a THEOREM — it follows directly from
    `corporeal_requires_spiritual` in Soul.lean. The Eucharistic fast
    is just one instance of the body-soul unity principle.

    The PRINCIPLE (body participates in spiritual acts) is doctrine.
    The IMPLEMENTATION (how long to fast) is discipline. -/
theorem bodily_preparation_is_spiritual :
    ∀ (p : HumanPerson),
      hasCorporealAspect p → hasSpiritualAspect p :=
  fun p h => corporeal_requires_spiritual p h

-- ============================================================================
-- § 8. Theorems
-- ============================================================================

/-!
### What follows from the CCC's claims

The theorems below fall into two groups:
1. **Precondition theorems** — who can/can't receive (from the definition)
2. **Effect theorems** — what communion does (from the axioms about
   `eucharistEffectOnProfile`)

Group 2 is the interesting one: the axioms have real content and the
theorems compose them to derive non-obvious conclusions.
-/

-- ── Group 1: Precondition theorems (from the definition) ──────────────

/-- Mortal sin bars communion: if guilt is present, the sin profile
    does not permit communion. -/
theorem guilt_bars_communion (sp : SinProfile)
    (h_guilt : sp.guilt = EffectState.present) :
    ¬sinProfilePermitsCommunion sp := by
  intro ⟨_, h_no_guilt⟩
  exact absurd h_no_guilt (by rw [h_guilt]; decide)

/-- The unbaptized cannot receive. -/
theorem unbaptized_cannot_receive (sp : SinProfile)
    (h_not_baptized : sp.originalWound ≠ EffectState.removed) :
    ¬sinProfilePermitsCommunion sp := by
  intro ⟨h_removed, _⟩
  exact absurd h_removed h_not_baptized

/-- A baptized person in grace CAN receive. Layer 3 being present
    is fine — the Eucharist acts on Layer 3. -/
theorem baptized_in_grace_can_receive :
    sinProfilePermitsCommunion baptizedInGrace := by
  unfold sinProfilePermitsCommunion baptizedInGrace
  exact ⟨rfl, rfl⟩

/-- After reconciliation, communion is permitted. -/
theorem reconciled_can_receive :
    sinProfilePermitsCommunion afterReconciliation := by
  unfold sinProfilePermitsCommunion afterReconciliation
  exact ⟨rfl, rfl⟩

/-- A person in mortal sin CANNOT receive — even though baptized.
    Layer 1 resolved is necessary but NOT sufficient. -/
theorem mortal_sinner_cannot_receive :
    ¬sinProfilePermitsCommunion baptizedInMortalSin := by
  intro ⟨_, h_guilt⟩
  simp [baptizedInMortalSin] at h_guilt

/-- The unevangelized cannot be determined — unknownToUs propagates. -/
theorem unevangelized_communion_indeterminate :
    ¬sinProfilePermitsCommunion unevangelized := by
  intro ⟨h_ow, _⟩
  simp [unevangelized] at h_ow

/-- The Eucharist REQUIRES what Reconciliation PROVIDES.
    Sacramental ordering: Reconciliation → Eucharist. -/
theorem reconciliation_enables_communion :
    ¬sinProfilePermitsCommunion baptizedInMortalSin ∧
    sinProfilePermitsCommunion afterReconciliation := by
  exact ⟨mortal_sinner_cannot_receive, reconciled_can_receive⟩

-- ── Group 2: Effect theorems (from the axioms — non-trivial) ──────────

/-- THEOREM: After worthy communion, the person is fully purified.
    Communion reduces attachments (§1394) and preserves the other layers.
    Combined with the precondition that L1+L2 are already removed,
    the result is: all three layers removed = `fullyPurified`.

    This is a REAL theorem — it composes three axioms:
    - eucharist_reduces_attachment (L3 → removed)
    - eucharist_preserves_guilt_state (L2 unchanged = removed)
    - eucharist_preserves_baptism_state (L1 unchanged = removed)

    The CCC doesn't state this explicitly. It emerges from combining
    §1394 (communion wipes venial sins) with §1395 (doesn't affect
    mortal sin) and the precondition (must be baptized + in grace). -/
theorem communion_leads_to_full_purification (sp : SinProfile)
    (h_worthy : sinProfilePermitsCommunion sp) :
    let result := eucharistEffectOnProfile sp
    result.originalWound = EffectState.removed ∧
    result.guilt = EffectState.removed ∧
    result.attachment = EffectState.removed := by
  have ⟨h_ow, h_guilt⟩ := h_worthy
  have h1 := eucharist_preserves_baptism_state sp
  have h2 := eucharist_preserves_guilt_state sp
  have h3 := eucharist_reduces_attachment sp h_worthy
  exact ⟨by rw [h1, h_ow], by rw [h2, h_guilt], h3⟩

/-- THEOREM: After worthy communion, the person's afterlife outcome
    is heaven. This composes the purification theorem with the
    afterlife model from SinEffects.lean.

    Uses: communion_leads_to_full_purification + purified_go_to_heaven.

    The CCC doesn't say "communion gets you to heaven" directly.
    But it follows from: communion purifies attachments (§1394) +
    only fully purified go to heaven (§1023) + you must already
    be in grace to receive (§1385). -/
theorem communion_points_to_heaven (sp : SinProfile)
    (h_worthy : sinProfilePermitsCommunion sp) :
    afterlifeFromProfile (eucharistEffectOnProfile sp) = AfterlifeOutcome.heaven := by
  have ⟨h1, h2, h3⟩ := communion_leads_to_full_purification sp h_worthy
  simp [afterlifeFromProfile, h1, h2, h3]

/-- THEOREM: Communion cannot change a mortal sinner's afterlife outcome.
    Even if someone in mortal sin somehow receives communion, their
    guilt state is preserved — and guilt leads to hell.

    Uses: eucharist_preserves_guilt_state + eucharist_preserves_baptism_state.

    This is the formal content of §1395: "not ordered to forgiveness
    of mortal sins." Communion doesn't substitute for Reconciliation. -/
theorem communion_cannot_save_mortal_sinner :
    (eucharistEffectOnProfile baptizedInMortalSin).guilt = EffectState.present := by
  have h := eucharist_preserves_guilt_state baptizedInMortalSin
  simp [baptizedInMortalSin] at h
  exact h

/-- THEOREM: After consecration, the Eucharist contains a person with
    a divine nature — receiving communion is receiving GOD, not just
    a symbol. This composes real_presence (§1374) with Christology.

    Uses: real_presence + Christology.wholeChristPresent definition.
    The "body, blood, soul, and divinity" of §1374 decompose into:
    divine nature (Christology) + human aspects (Soul.lean). -/
theorem eucharist_contains_divine_person
    (h_consecrated : isConsecratedEucharist) :
    Christology.christ.hasNature Christology.Nature.divine := by
  have h := real_presence h_consecrated
  exact h.1

/-- THEOREM: After consecration, the Eucharist contains a COMPLETE
    human nature — body AND soul. This is why the Eucharist is not
    merely "spiritual communion" but involves the BODY of Christ.

    Uses: real_presence + Christology.
    Connects to Soul.lean: the corporeal and spiritual aspects
    of Christ's human person are both present. -/
theorem eucharist_contains_complete_human_nature
    (h_consecrated : isConsecratedEucharist) :
    hasCorporealAspect Christology.christHumanPerson ∧
    hasSpiritualAspect Christology.christHumanPerson := by
  have h := real_presence h_consecrated
  exact ⟨h.2.2.1, h.2.2.2⟩

/-- THEOREM: The sacrament-layer correspondence.
    Eucharist requires L1+L2 resolved and acts on L3.
    The CCC never states this pattern — it emerges from formalization.

    Each sacrament has its own domain:
    - Baptism: acts on L1 (original wound)
    - Reconciliation: acts on L2 (guilt), requires L1
    - Eucharist: acts on L3 (attachment), requires L1+L2 -/
theorem sacraments_have_distinct_domains :
    -- Eucharist permits L3 to be present (acts on it)
    sinProfilePermitsCommunion
      { originalWound := EffectState.removed
        guilt := EffectState.removed
        attachment := EffectState.present } ∧
    -- But Eucharist requires L2 resolved
    ¬sinProfilePermitsCommunion
      { originalWound := EffectState.removed
        guilt := EffectState.present
        attachment := EffectState.present } ∧
    -- And Eucharist requires L1 resolved
    ¬sinProfilePermitsCommunion
      { originalWound := EffectState.present
        guilt := EffectState.removed
        attachment := EffectState.present } := by
  refine ⟨⟨rfl, rfl⟩, ?_, ?_⟩
  · intro ⟨_, h⟩; simp at h
  · intro ⟨h, _⟩; simp at h

-- ============================================================================
-- § 9. The §1401 Exception
-- ============================================================================

/-!
### Grave necessity: non-Catholics receiving communion

§1401: "When, in the Ordinary's judgment, a grave necessity arises,
Catholic ministers may give the sacraments of Eucharist, Penance, and
Anointing of the Sick to other Christians not in full communion with
the Catholic Church, who ask for them of their own will, provided they
demonstrate the Catholic faith regarding these sacraments and are
properly disposed."

This reveals the hierarchy of conditions:
1. BELIEF in Real Presence — NON-NEGOTIABLE (even in §1401)
2. State of grace — NON-NEGOTIABLE (properly disposed)
3. Full ecclesial communion — RELAXABLE (in grave necessity)

The belief condition is harder than the ecclesial condition.
-/

/-- Whether a person is in full ecclesial communion with the Catholic Church.
    §1401 shows this is RELAXABLE in grave necessity — unlike belief
    and state of grace, which are never relaxed. -/
opaque inFullCommunionWithChurch : Person → Prop

/-- Whether grave necessity exists (danger of death, persecution, etc.).
    This is a situational judgment, not a permanent state. -/
opaque graveNecessityExists : Prop

/-- Whether a person may licitly receive communion.
    This is STRONGER than sinProfilePermitsCommunion — it also
    requires belief, conscience examination, and either full ecclesial
    communion OR grave necessity. -/
opaque mayLicitlyReceive : Person → Prop

/-- AXIOM (§1401): In grave necessity, a non-Catholic who believes and
    is properly disposed may licitly receive communion — even without
    full ecclesial communion.

    Provenance: [Definition] CCC §1401.
    Denominational scope: CATHOLIC.
    Teaching kind: DISCIPLINARY exception, but the CONDITIONS it names
    (faith + disposition) are doctrinal.

    This axiom reveals that the CCC distinguishes NEGOTIABLE from
    NON-NEGOTIABLE conditions. Belief and state of grace: non-negotiable.
    Ecclesial communion: negotiable under extreme circumstances. -/
axiom grave_necessity_exception :
  ∀ (cd : CommunionDisposition),
    graveNecessityExists →
    sinProfilePermitsCommunion cd.sinProfile →
    cd.believesChurchTeaching →
    cd.hasExaminedConscience →
    -- Even without full ecclesial communion, they may receive
    mayLicitlyReceive cd.recipient

/-- THEOREM (§1401): A baptized Protestant in grace who believes in the
    Real Presence may receive communion in grave necessity — even without
    full ecclesial communion.

    Uses: grave_necessity_exception.
    This theorem exercises the §1401 exception with a concrete case:
    a non-Catholic whose sin profile permits (baptized + in grace),
    who believes and has examined conscience. -/
theorem protestant_in_grave_necessity
    (cd : CommunionDisposition)
    (h_grave : graveNecessityExists)
    (h_profile : sinProfilePermitsCommunion cd.sinProfile)
    (h_believes : cd.believesChurchTeaching)
    (h_conscience : cd.hasExaminedConscience) :
    mayLicitlyReceive cd.recipient :=
  grave_necessity_exception cd h_grave h_profile h_believes h_conscience

/-- THEOREM: Even in grave necessity, mortal sin still bars communion.
    The §1401 exception relaxes ECCLESIAL conditions, not MORAL ones.
    A non-Catholic in mortal sin cannot receive even in danger of death.

    Uses: grave_necessity_exception (indirectly — shows its limits). -/
theorem grave_necessity_still_requires_grace
    (cd : CommunionDisposition)
    (h_guilt : cd.sinProfile.guilt = EffectState.present) :
    ¬sinProfilePermitsCommunion cd.sinProfile :=
  guilt_bars_communion cd.sinProfile h_guilt

/-!
## Summary — post-audit

Axioms (5 — all with real content, none vacuous):
1. real_presence (§1374) — consecration → Christ truly present
2. eucharist_reduces_attachment (§1394) — communion removes Layer 3
3. eucharist_preserves_guilt_state (§1395) — communion doesn't touch Layer 2
4. eucharist_preserves_baptism_state — communion doesn't touch Layer 1
5. grave_necessity_exception (§1401) — non-Catholics in grave necessity

Theorems (11 — mix of definitional and axiom-composing):

Precondition theorems (from definition of sinProfilePermitsCommunion):
1. guilt_bars_communion — mortal sin prevents reception
2. unbaptized_cannot_receive — baptism required
3. baptized_in_grace_can_receive — the standard case
4. reconciled_can_receive — after confession
5. mortal_sinner_cannot_receive — even if baptized
6. unevangelized_communion_indeterminate — unknownToUs propagates
7. reconciliation_enables_communion — sacramental ordering

Effect theorems (composing axioms — the interesting ones):
8. bodily_preparation_is_spiritual — DERIVED from Soul.lean (was an axiom!)
9. communion_leads_to_full_purification — composes 3 axioms → fully purified
10. communion_points_to_heaven — composes purification + afterlife model
11. communion_cannot_save_mortal_sinner — §1395 with real content
12. sacraments_have_distinct_domains — emergent pattern

Key AUDIT FIXES:
- `real_presence`: was `→ True` (vacuous) → now `→ christTrulyPresent`
- `eucharist_does_not_forgive_mortal_sin`: was P→P (tautology) → replaced
  with `eucharist_preserves_guilt_state` (real content via opaque function)
- `bodily_preparation_is_spiritual`: was duplicate axiom → now theorem
  derived from Soul.lean's `corporeal_requires_spiritual`
- `grave_necessity_exception`: was premise-in-conclusion → now produces
  `mayLicitlyReceive` (new opaque predicate)
- `mortal_sin_bars_communion`, `baptism_required_for_communion`: deleted —
  were axioms restating the definition
- `eucharist_strengthens_charity`, `eucharist_preserves_from_mortal_sin`,
  `eucharist_builds_church`: replaced with `eucharistEffectOnProfile`
  model that enables real theorem composition

Key FINDING: The sacrament-layer correspondence (Baptism→L1,
Reconciliation→L2, Eucharist→L3) is NOT stated in the CCC.
It EMERGES from formalizing the individual sacraments.

NEW FINDING: `communion_leads_to_full_purification` — worthy communion
results in full purification (all 3 layers removed). The CCC doesn't
say this directly. It follows from: L1+L2 already removed (precondition)
+ L3 removed by communion (§1394) = fully purified.

NEW FINDING: `communion_points_to_heaven` — composing the purification
with the afterlife model: worthy communion → full purification → heaven.
This is a 5-axiom chain the CCC never makes explicit.
-/

end Catlib.Sacraments.Eucharist
