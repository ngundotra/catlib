import Catlib.Foundations
import Catlib.Sacraments.Reconciliation
import Catlib.Creed.Prayer
import Catlib.Creed.Intercession

/-!
# CCC §1441-1467: Why Confession to a Priest Makes Sense

## The puzzle

§1441: "Only God forgives sins."
§1444: Christ gives the apostles "the power to reconcile sinners with
the Church" (Jn 20:23).

Apparent contradiction: if ONLY God forgives sins, how can a priest
forgive sins? Either God alone forgives (and the priest is superfluous)
or the priest genuinely forgives (and "only God" is false).

## The CCC's answer

P2 (two-tier causation) again! God forgives as PRINCIPAL cause; the
priest acts as INSTRUMENTAL cause. The priest's absolution and God's
forgiveness don't compete — they operate at different levels.

This is the FIFTH instance of P2 in the project:
1. Causation (Axioms.lean) — God + creatures
2. Prayer (Prayer.lean) — God + prayer
3. Intercession (Intercession.lean) — Christ + saints
4. Evil permission (Providence.lean) — God permits + creature causes
5. Absolution (THIS file) — God + priest

## The three candidate load-bearing steps

§1441-1467 offers three distinct reasons why priestly absolution works:

1. **Delegated authority** (Jn 20:23): Christ explicitly delegated
   forgiveness power to the apostles and their successors. This tells
   us WHO can absolve.

2. **Sacramental instrumentality** (T3): The sacrament is an effective
   sign that confers the grace it signifies (ex opere operato). This
   tells us HOW absolution works.

3. **Ecclesial visibility** (§1443-1445): Sin wounds the Church as a
   body; reconciliation with God requires visible reconciliation with
   the Church. This tells us WHY visible absolution matters.

## Prediction

Delegated authority is necessary but not sufficient: it explains WHO
can absolve but not HOW or WHY. T3 (sacramental instrumentality) is
the mechanism — it explains HOW priestly words effect grace. Ecclesial
visibility explains WHY a visible, external act is needed (not just
private repentance). All three are load-bearing, but for DIFFERENT
things. Drop any one, and the picture is incomplete.

## Findings

- **Prediction confirmed**: All three steps are genuinely load-bearing,
  but each carries a DIFFERENT aspect of the argument.
  - Authority: necessary condition (WHO). Without Jn 20:23, no one has
    standing to absolve.
  - T3: the mechanism (HOW). Without sacramental efficacy, the priest's
    words are merely declarative, not effective — this is the Protestant
    position.
  - Ecclesial visibility: the purpose (WHY). Without the ecclesial
    dimension, private contrition would suffice — no need for confession.

- **Key finding**: The Protestant position is not a single rejection
  but THREE distinct rejections at different levels:
  (a) Reject sacramental delegation (Jn 20:23 is a general commission,
      not a sacramental power) → no authority
  (b) Reject T3 (sacraments are signs, not causes) → no mechanism
  (c) Reject ecclesial mediation (reconciliation is between the
      individual and God alone) → no purpose for visible absolution

- **P2 is the deepest principle**: Authority and ecclesial visibility
  both DEPEND on P2. Authority works because Christ (principal) can
  delegate to priests (instrumental) without losing anything. Ecclesial
  visibility works because reconciliation with God (principal) and
  reconciliation with the Church (secondary) are not rivals.
  Without P2, delegation looks like division of power, and ecclesial
  reconciliation looks like adding a requirement God didn't impose.

- **Hidden assumptions identified**:
  1. Instrumental causes can genuinely effect what only the principal
     cause has the power to do (Aquinas, ST III q.64 a.1). The priest
     does not forgive by his own power — but the forgiveness IS real.
  2. The Church is a visible body whose communion is a real dimension
     of the God-person relationship (§1443: "Jesus... also gives the
     power of reconciling sinners WITH THE CHURCH"). Sin is not purely
     private; it wounds the body.
  3. The scope of P2 extends to sacramental causation, not just
     physical or providential causation. This is the same extension
     the Protestant contests in the intercession case.

- **Assessment**: Tier 2 — applies P2 to a new domain (sacramental
  absolution), decomposes a single question into three sub-questions
  with different load-bearing axioms, and identifies the three-level
  Protestant objection.
-/

set_option autoImplicit false

namespace Catlib.Sacraments.PriestlyAbsolution

open Catlib
open Catlib.Sacraments.Reconciliation
open Catlib.Creed

-- ============================================================================
-- § 1. Core concepts
-- ============================================================================

/-- Whether a person acts as PRINCIPAL cause of forgiveness — forgiving
    by his own authority and power.
    §1441: "Only God forgives sins." God alone is the principal cause
    of forgiveness — forgiveness originates from God's mercy.

    STRUCTURAL OPACITY: The CCC affirms God alone forgives principally
    but never defines the metaphysics of "principal forgiveness" beyond
    the assertion. The content is: the source and power of forgiveness
    is divine, not creaturely. -/
opaque forgivesAsPrincipalCause : Person → Prop

/-- Whether a person acts as INSTRUMENTAL cause of forgiveness —
    effecting forgiveness not by his own power but as an instrument
    of the principal cause.
    §1461-1462: The priest exercises "the ministry of reconciliation"
    entrusted by Christ. He forgives in persona Christi, not in his
    own name.

    HONEST OPACITY: HOW a human being can instrumentally effect divine
    forgiveness is genuinely mysterious. The CCC asserts it (§1461)
    without explaining the metaphysical mechanism. Aquinas (ST III q.64
    a.1) says an instrument participates in the power of the principal
    agent for the duration of its use — like a brush participates in
    the painter's art. But this analogy is inexact (a brush has no will;
    a priest does). We keep this opaque because the mechanism is a
    genuine mystery. -/
opaque forgivesAsInstrumentalCause : Person → Prop

/-- Whether a person is reconciled with the Church as a visible body.
    §1443-1445: Sin wounds not only the sinner's relationship with God
    but also the communion of the Church. Sacramental reconciliation
    addresses BOTH dimensions.

    HIDDEN ASSUMPTION: The Church is a visible communion whose integrity
    is damaged by sin and restored by reconciliation. Sin is not purely
    private — it has an ecclesial dimension. This is the CCC's assumption
    (§1443: "Jesus... also gives the power of reconciling sinners WITH
    THE CHURCH"), but it is a substantive claim that a Protestant would
    not grant. -/
opaque reconciledWithChurch : Person → Prop

/-- Whether the principal and instrumental causes of forgiveness
    compete — whether more of one means less of the other.
    This is the absolution-specific analogue of `causesCompete`
    from Axioms.lean and `mediationsCompete` from Intercession.lean.

    MODELING CHOICE: We introduce a separate predicate rather than
    reusing `causesCompete` directly, because forgiveness is not
    identical to physical causation or mediation. The PRINCIPLE is P2,
    but the domain is distinct. The Protestant objection to priestly
    absolution is precisely that P2 does not extend to forgiveness. -/
opaque forgivenessLevelsCompete : Person → Person → Prop

/-- Whether reconciliation with God and reconciliation with the Church
    are rival requirements — whether the ecclesial dimension adds a
    condition God did not impose.

    HIDDEN ASSUMPTION: The CCC treats these as naturally unified (§1445:
    "Reconciliation with the Church is inseparable from reconciliation
    with God"). The Protestant view is that adding an ecclesial requirement
    to divine forgiveness goes beyond what Christ taught. -/
opaque reconciliationDimensionsCompete : Prop

-- ============================================================================
-- § 2. Axioms
-- ============================================================================

/-- AXIOM 1 (§1441): Only God forgives sins as principal cause.
    "Only God forgives sins." Since only God is offended by every sin
    (sin is ultimately against God — Ps 51:4), only God can forgive as
    the one whose mercy originates the pardon.

    This is ECUMENICAL — all Christians affirm that God alone ultimately
    forgives. The question is whether He uses instruments to do so.

    Provenance: [Scripture] Mk 2:7 ("Who can forgive sins but God alone?");
    Ps 51:4 ("Against you, you alone, have I sinned")
    Denominational scope: ECUMENICAL. -/
axiom god_alone_forgives_principally :
  ∀ (p q : Person),
    forgivesAsPrincipalCause p →
    forgivesAsPrincipalCause q →
    p = q

/-- AXIOM 2 (§1461-1462, Jn 20:23): Christ delegates the ministry of
    reconciliation to the apostles and their successors.
    "Since Christ entrusted to his apostles the ministry of reconciliation,
    bishops who are their successors, and priests, the bishops' collaborators,
    continue to exercise this ministry." (§1462)

    This axiom says: a priest with valid authority (from the delegation
    chain in Authority.lean) acts as instrumental cause of forgiveness.
    He does NOT forgive by his own power — he is an instrument of Christ
    who is an instrument of God.

    Cross-ref: christ_delegates_absolution (Authority.lean) — the specific
    delegation at Jn 20:23.
    Cross-ref: absolution_requires_authority (Reconciliation.lean) — valid
    absolution requires the authority chain.

    HIDDEN ASSUMPTION: An instrumental cause can genuinely effect what
    only the principal cause has the power to do. The brush doesn't paint
    by its own art, yet the painting IS genuinely made through the brush.
    Aquinas, ST III q.64 a.1.

    Provenance: [Scripture] Jn 20:21-23; [Tradition] CCC §1461-1462
    Denominational scope: CATHOLIC + ORTHODOX. -/
axiom priest_is_instrumental_cause :
  ∀ (a : Absolution),
    a.hasAuthority →
    a.isPronounced →
    forgivesAsInstrumentalCause a.priest

/-- AXIOM 3 (P2 applied to forgiveness): Principal and instrumental
    forgiveness do not compete.
    God forgives as principal cause; the priest forgives as instrumental
    cause. More priestly absolution does NOT mean less divine forgiveness.
    They operate at different causal levels — the priest's words are
    the instrument THROUGH which God's mercy reaches the penitent.

    This is P2 (two-tier causation) in the forgiveness domain:
    - Causation (Axioms.lean): God causes + creatures cause → don't compete
    - Prayer (Prayer.lean): God acts + person prays → don't compete
    - Intercession (Intercession.lean): Christ mediates + saints intercede → don't compete
    - Absolution (here): God forgives + priest absolves → don't compete

    Provenance: [Philosophical] P2 (Aquinas, ST I q.105 a.5; III q.84 a.1)
    Denominational scope: CATHOLIC + ORTHODOX. Protestants REJECT this for
    sacramental forgiveness — they accept P2 for causation but deny that
    a human can instrumentally cause forgiveness. -/
axiom forgiveness_non_competition :
  ∀ (god priest : Person),
    forgivesAsPrincipalCause god →
    forgivesAsInstrumentalCause priest →
    ¬ forgivenessLevelsCompete god priest

/-- AXIOM 4 (T3 applied to absolution): Sacramental absolution SIGNIFIES
    forgiveness — and by T3, what a sacrament signifies it confers.
    The words of absolution ("I absolve you...") are not merely a
    declaration that God has forgiven. They are an EFFECTIVE SIGN —
    a sacramental act that actually confers forgiveness (ex opere operato).

    This is T3 (sacramental efficacy) applied to the specific sacrament
    of reconciliation. T3 is the mechanism: it explains HOW the priest's
    words effect grace.

    Cross-ref: t3_sacramental_efficacy (Axioms.lean) — the base axiom.
    Cross-ref: sacramental_efficacy_bridge (Reconciliation.lean) — the
    bridge to T3.

    Without T3, the priest's words are merely declarative (the Protestant
    position: the minister ANNOUNCES forgiveness; he does not CAUSE it).
    With T3, the priest's words are effective (the Catholic position:
    the sacrament CONFERS the grace it signifies).

    NOTE: This axiom connects absolution (a specific sacramental act) to
    the general sacramental framework (Sacrament type from Axioms.lean).
    The bridge: absolution is a sacrament; it signifies forgiveness;
    therefore by T3 it confers forgiveness. This is distinct from
    priest_is_instrumental_cause (which is about WHO, from Jn 20:23).
    This axiom is about HOW (the sacramental mechanism of T3).

    Provenance: [Tradition] CCC §1449, §1461; Trent Session 14, Canon 3
    Denominational scope: CATHOLIC + ORTHODOX. -/
axiom absolution_signifies_forgiveness :
  ∀ (a : Absolution) (s : Sacrament),
    a.hasAuthority →
    a.isPronounced →
    -- The sacramental act of absolution signifies forgiveness
    signifies s

/-- AXIOM 5 (§1443-1445): Sin wounds the Church; reconciliation with
    God requires visible reconciliation with the Church.
    "It is before the community of the Church that confession takes place...
    reconciliation with the Church is inseparable from reconciliation
    with God." (§1445)

    Sin is not purely private. It damages the communion of the Body of
    Christ. Therefore, restoration requires not just private contrition
    before God but visible reconciliation within the ecclesial community.

    This is the PURPOSE axiom: it explains WHY visible confession to a
    priest matters (not just private repentance). The priest represents
    both Christ (as instrumental cause) and the Church (as its minister).

    HIDDEN ASSUMPTION: The Church is a real visible body whose communion
    is genuinely damaged by sin. Sin has an ecclesial dimension, not just
    a vertical (God-person) dimension. The Protestant counter: sin is
    primarily between the individual and God (Ps 51:4); the ecclesial
    dimension is secondary and does not require sacramental confession.

    Provenance: [Definition] CCC §1443-1445; [Tradition] Lateran IV (1215),
    confession to a priest is obligatory for mortal sin
    Denominational scope: CATHOLIC + ORTHODOX. -/
axiom sin_has_ecclesial_dimension :
  ∀ (r : ReconciliationAct),
    r.absolution.hasAuthority →
    r.absolution.isPronounced →
    r.contrition.genuineSorrow →
    reconciledWithChurch r.contrition.penitent

/-- AXIOM 6 (§1445): The two dimensions of reconciliation do not compete.
    Reconciliation with God and reconciliation with the Church are not
    rival requirements — they are two aspects of one reality. Being
    reconciled with the Church IS part of being reconciled with God,
    because the Church is Christ's body.

    This is a second application of P2: just as God's forgiveness and
    the priest's absolution don't compete (axiom 3), so reconciliation
    with God and reconciliation with the Church don't compete. The
    ecclesial dimension does not ADD an extra burden — it IS the visible
    form of the divine reconciliation.

    Provenance: [Definition] CCC §1445 ("inseparable from reconciliation with God")
    Denominational scope: CATHOLIC + ORTHODOX. -/
axiom reconciliation_dimensions_unified :
  ¬ reconciliationDimensionsCompete

-- ============================================================================
-- § 3. Bridge theorems to base axioms
-- ============================================================================

/-- Bridge to P2: primary and secondary causes don't compete.
    This makes explicit the structural parallel: the absolution argument
    uses the same non-competition principle as all other P2 instances. -/
theorem causation_non_competition_bridge
    (p : PrimaryCause) (s : SecondaryCause) :
    ¬ causesCompete p s :=
  p2_two_tier_causation p s

/-- Bridge to T3: sacraments confer what they signify.
    Absolution is a sacrament. T3 says sacraments are effective signs.
    Therefore absolution is an effective sign. -/
theorem t3_bridge (s : Sacrament)
    (h : signifies s) : confers s :=
  t3_sacramental_efficacy s h

/-- Bridge to Authority.lean: the absolution delegation chain is established.
    Christ delegated absolution authority at Jn 20:23. -/
theorem delegation_chain_bridge :
    absolutionDomain.christHasIt ∧ absolutionDomain.christDelegatedIt :=
  absolution_authority

-- ============================================================================
-- § 4. Theorems: resolving the puzzle
-- ============================================================================

/-- THEOREM: Priestly absolution is instrumental, not rival.

    For any absolution with valid authority: the priest acts as
    instrumental cause, and this does not compete with God's principal
    forgiveness. The priest is not a second forgiver — he is the
    instrument through which the one forgiver acts.

    Depends on: priest_is_instrumental_cause, forgiveness_non_competition,
    god_alone_forgives_principally. -/
theorem absolution_is_instrumental_not_rival
    (a : Absolution) (god : Person)
    (h_auth : a.hasAuthority)
    (h_pronounced : a.isPronounced)
    (h_god : forgivesAsPrincipalCause god) :
    forgivesAsInstrumentalCause a.priest ∧
    ¬ forgivenessLevelsCompete god a.priest :=
  have h_inst := priest_is_instrumental_cause a h_auth h_pronounced
  have h_nc := forgiveness_non_competition god a.priest h_god h_inst
  ⟨h_inst, h_nc⟩

/-- THEOREM: The three load-bearing steps are all present in valid
    reconciliation.

    For any valid reconciliation act and any sacrament representing it:
    1. The priest has AUTHORITY (Jn 20:23 delegation chain — WHO)
    2. The sacrament CONFERS what it signifies (T3 + axiom 4 — HOW)
    3. The penitent is reconciled with the CHURCH (ecclesial dimension — WHY)

    Each step answers a different question:
    - Authority: WHO has standing to absolve? (The priest, via delegation)
    - T3 mechanism: HOW does absolution work? (Sacrament signifies → confers)
    - Ecclesial visibility: WHY is visible confession needed? (Sin wounds the body)

    Depends on: absolution_requires_authority, absolution_signifies_forgiveness,
    t3_sacramental_efficacy, sin_has_ecclesial_dimension. -/
theorem three_load_bearing_steps
    (r : ReconciliationAct) (s : Sacrament)
    (h_pronounced : r.absolution.isPronounced)
    (h_sorrow : r.contrition.genuineSorrow) :
    -- (a) WHO: the priest has authority
    r.absolution.hasAuthority
    -- (b) HOW: the sacrament confers forgiveness (signifies → confers via T3)
    ∧ confers s
    -- (c) WHY: the penitent is reconciled with the Church
    ∧ reconciledWithChurch r.contrition.penitent :=
  have h_auth := absolution_requires_authority r.absolution h_pronounced
  have h_sig := absolution_signifies_forgiveness r.absolution s h_auth h_pronounced
  have h_confers := t3_sacramental_efficacy s h_sig
  have h_eccl := sin_has_ecclesial_dimension r h_auth h_pronounced h_sorrow
  ⟨h_auth, h_confers, h_eccl⟩

/-- THEOREM (Main): Priestly absolution is coherent with "only God forgives."

    The full resolution of the §1441/§1444 puzzle. For any valid
    reconciliation act and any principal forgiver (God):

    1. God alone forgives as principal cause (§1441 — no rivals at
       the primary level)
    2. The priest absolves as instrumental cause (§1461 — secondary level)
    3. They don't compete (P2 applied to forgiveness)
    4. The absolution is effective, not merely declarative (T3)
    5. The penitent is reconciled with the Church (ecclesial dimension)
    6. The two dimensions (God + Church) don't compete either

    The contradiction dissolves: "only God forgives" means only God
    forgives AS PRINCIPAL CAUSE. The priest forgives as INSTRUMENTAL
    cause — through, with, and in Christ. These are different causal
    levels, and P2 says they don't compete.

    Depends on: god_alone_forgives_principally, priest_is_instrumental_cause,
    forgiveness_non_competition, absolution_signifies_forgiveness,
    t3_sacramental_efficacy, sin_has_ecclesial_dimension,
    reconciliation_dimensions_unified, absolution_requires_authority. -/
theorem priestly_absolution_coherent
    (r : ReconciliationAct) (s : Sacrament) (god : Person)
    (h_pronounced : r.absolution.isPronounced)
    (h_sorrow : r.contrition.genuineSorrow)
    (h_god : forgivesAsPrincipalCause god) :
    -- (a) God is unique at the principal level
    (∀ (q : Person), forgivesAsPrincipalCause q → q = god)
    -- (b) The priest acts instrumentally (WHO — delegation)
    ∧ forgivesAsInstrumentalCause r.absolution.priest
    -- (c) Principal and instrumental don't compete (P2)
    ∧ ¬ forgivenessLevelsCompete god r.absolution.priest
    -- (d) The sacrament confers forgiveness (HOW — T3)
    ∧ confers s
    -- (e) The penitent is reconciled with the Church (WHY — ecclesial)
    ∧ reconciledWithChurch r.contrition.penitent
    -- (f) God-reconciliation and Church-reconciliation don't compete
    ∧ ¬ reconciliationDimensionsCompete :=
  have h_auth := absolution_requires_authority r.absolution h_pronounced
  have h_unique : ∀ (q : Person), forgivesAsPrincipalCause q → q = god :=
    fun q hq => by
      have := god_alone_forgives_principally q god hq h_god
      exact this
  have h_inst := priest_is_instrumental_cause r.absolution h_auth h_pronounced
  have h_nc := forgiveness_non_competition god r.absolution.priest h_god h_inst
  have h_sig := absolution_signifies_forgiveness r.absolution s h_auth h_pronounced
  have h_confers := t3_sacramental_efficacy s h_sig
  have h_eccl := sin_has_ecclesial_dimension r h_auth h_pronounced h_sorrow
  have h_unified := reconciliation_dimensions_unified
  ⟨h_unique, h_inst, h_nc, h_confers, h_eccl, h_unified⟩

-- ============================================================================
-- § 5. The P2 quintuple-duty finding
-- ============================================================================

/-!
### P2 does quintuple duty

The same non-competition principle (P2: primary and secondary causes don't
compete) now resolves FIVE distinct theological puzzles:

| Domain | Primary Level | Secondary Level | File |
|--------|---------------|-----------------|------|
| **Causation** | God causes | Creatures cause | Axioms.lean |
| **Prayer** | God acts/governs | Person prays | Prayer.lean |
| **Intercession** | Christ mediates | Saints intercede | Intercession.lean |
| **Evil permission** | God permits | Creature causes evil | Providence.lean |
| **Absolution** | God forgives | Priest absolves | this file |

In each case:
1. The primary actor is unique and irreplaceable
2. The secondary actor participates in (not rivals) the primary actor
3. More secondary activity ≠ less primary activity
4. The secondary actor's efficacy derives FROM the primary, not independently

### What distinguishes this instance

Absolution adds something the other four don't: the ecclesial dimension.
Prayer, intercession, and providence are "vertical" (God-creature). But
absolution has a "horizontal" component too — reconciliation with the
Church. P2 does double duty here: it unifies both the vertical
(God forgives + priest absolves) and the horizontal (reconciliation with
God + reconciliation with the Church).

### The three-level Protestant objection

The Protestant rejects priestly absolution at THREE distinct levels:

1. **Authority** (Jn 20:23 scope): "Receive the Holy Spirit" was a
   general commission to proclaim forgiveness, not a sacramental
   delegation. There IS no special priestly authority to absolve.

2. **Mechanism** (T3): Sacraments are signs, not causes. The priest's
   words DECLARE what God has already done; they don't CAUSE forgiveness.
   Without T3, absolution is declarative, not effective.

3. **Purpose** (ecclesial dimension): Reconciliation is between the
   individual and God. The Church is a fellowship, not a mediating body
   whose communion must be visibly restored. Adding an ecclesial
   requirement goes beyond Scripture.

These three rejections are INDEPENDENT — a Protestant who accepts one
can still reject the others. This decomposition is itself a finding:
the Catholic and Protestant positions differ not at one point but at
three, and each point has its own logic.
-/

-- ============================================================================
-- § 6. Denominational picture
-- ============================================================================

/-!
### Where traditions agree and disagree

**All Christians agree:**
- Only God forgives sins (§1441, Mk 2:7) — ECUMENICAL
- Repentance and contrition are necessary — ECUMENICAL
- Christ commissioned the apostles (Jn 20:21-23) — ECUMENICAL
  (disputed: the scope and nature of the commission)

**Catholic + Orthodox:**
- The commission at Jn 20:23 is a specific sacramental delegation
- Priests act as instrumental causes of forgiveness (P2)
- Sacramental absolution is effective, not merely declarative (T3)
- Sin has an ecclesial dimension requiring visible reconciliation
- The seal of confession is inviolable (§1467)

**Protestant:**
- Jn 20:23 is a general commission to proclaim forgiveness
- Ministers can DECLARE forgiveness; they cannot CAUSE it
- Forgiveness is between the individual and God
- Private confession to God suffices (1 Jn 1:9)
- Luther valued private confession but did not require it; he removed
  it from the list of sacraments (though he wavered on this)

**Orthodox distinctive:**
- Same sacramental model as Catholic
- Different penitential practice (emphasis on spiritual direction)
- No indulgences (which depend on temporal punishment surviving absolution)
-/

-- ============================================================================
-- § 7. Summary
-- ============================================================================

/-!
## Summary

**Axioms** (6 — from CCC §1441-1467, connected to existing infrastructure):
1. `god_alone_forgives_principally` (§1441) — God is unique principal forgiver
2. `priest_is_instrumental_cause` (§1461-1462) — priest absolves instrumentally
3. `forgiveness_non_competition` (P2) — principal and instrumental don't compete
4. `absolution_signifies_forgiveness` (T3/§1449) — absolution signifies forgiveness
   (and by T3, what it signifies it confers)
5. `sin_has_ecclesial_dimension` (§1443-1445) — sin wounds the Church
6. `reconciliation_dimensions_unified` (§1445) — God-reconciliation and
   Church-reconciliation are not rival requirements

**Theorems** (4):
1. `absolution_is_instrumental_not_rival` — priest's absolution is instrumental, not competing
2. `three_load_bearing_steps` — authority (WHO) + instrumentality (HOW) + ecclesial (WHY)
3. `priestly_absolution_coherent` — full resolution: §1441 and §1444 are compatible
4. Bridge theorems to P2, T3, and Authority.lean

**Cross-file connections:**
- `Axioms.lean`: `p2_two_tier_causation` (P2), `t3_sacramental_efficacy` (T3),
  `PrimaryCause`, `SecondaryCause`, `causesCompete`
- `Authority.lean`: `absolution_authority`, `absolutionDomain`,
  `christ_delegates_absolution`
- `Reconciliation.lean`: `Absolution`, `ReconciliationAct`,
  `absolution_requires_authority`
- `Prayer.lean`: structural parallel (P2 in prayer domain)
- `Intercession.lean`: structural parallel (P2 in mediation domain)

**Key finding:** The §1441/§1444 puzzle decomposes into three sub-questions
(WHO, HOW, WHY), each with its own load-bearing axiom:
- Authority (Jn 20:23): necessary but not sufficient — tells WHO
- T3 (sacramental efficacy): the mechanism — tells HOW
- Ecclesial visibility (§1443-1445): the purpose — tells WHY

**Key finding:** P2 does quintuple duty across the project. The same
non-competition principle resolves causation, prayer, intercession, evil
permission, and absolution. This is the deepest structural unity in the
formalization.

**Key finding:** The Protestant position is a THREE-LEVEL rejection:
authority (scope of Jn 20:23), mechanism (T3), and purpose (ecclesial
dimension). These are independent — each can be accepted or rejected
separately. The Catholic position requires all three.

**Hidden assumptions identified:**
1. Instrumental causes can genuinely effect what only the principal cause
   has the power to do (Aquinas, ST III q.64 a.1)
2. The Church is a visible body whose communion is a real dimension of the
   God-person relationship (§1443)
3. P2's scope extends to sacramental forgiveness (same extension the
   Protestant contests for intercession)
-/

end Catlib.Sacraments.PriestlyAbsolution
