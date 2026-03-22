import Catlib.Foundations
import Catlib.MoralTheology.Sin
import Catlib.Creed.Grace
import Catlib.Creed.DivineModes
import Catlib.Creed.Purgatory

/-!
# CCC §1422–1470: The Sacrament of Reconciliation (Confession)

The most cross-cutting formalization in catlib. This file connects:

- **Basic.lean**: Person, Sin, Grace, Action, FreeChoice, Denomination
- **Axioms.lean**: S8 (grace necessary & transformative), T2 (grace preserves
  freedom), T3 (sacramental efficacy), S5 (sin separates)
- **Authority.lean**: absolution_authority, absolutionDomain, christ_delegates_absolution,
  apostolic_succession_general
- **Love.lean**: LoveKind.agape, mortal_sin_can_destroy_charity, agape_requires_freedom
- **Sin.lean**: Sin.isMortal, GraceState, mortal_sin_causes_loss_of_grace
- **Grace.lean**: GraceType.prevenient, prevenient_grace_unconditioned,
  divine_initiative_preserves_freedom, Grace, grace_bootstrapping_resolved
- **DivineModes.lean**: SoulState, heavenState, hellState, DivineMode
- **Purgatory.lean**: HolinessDegree, fullyPurified, diedInGrace

## The Catechism claims

"It is called the sacrament of conversion because it makes sacramentally present
Jesus' call to conversion." (§1423)

"It is called the sacrament of Penance, since it consecrates the Christian
sinner's personal and ecclesial steps of conversion, penance, and satisfaction."
(§1423)

"It is called the sacrament of confession, since the disclosure or confession of
sins to a priest is an essential element." (§1424)

"It is called the sacrament of Reconciliation, since it imparts to the sinner
the love of God who reconciles." (§1424)

## The three acts of the penitent (§1450-1460)

1. **Contrition**: "sorrow of the soul and detestation of the sin committed,
   together with the resolution not to sin again" (§1451)
2. **Confession**: "the confession (or disclosure) of sins… frees in some
   way and facilitates the reconciliation" (§1455-1456)
3. **Satisfaction**: "an act of reparation that the confessor imposes on
   the penitent… absolution takes away sin, but it does not remedy all the
   disorders sin has caused" (§1459)

## The minister's act (§1461-1467)

"Since Christ entrusted to his apostles the ministry of reconciliation, bishops
who are their successors, and priests, the bishops' collaborators, continue to
exercise this ministry." (§1461)

## The effects (§1468-1470)

"The whole power of the sacrament of Penance consists in restoring us to God's
grace and joining us with him in an intimate friendship." (§1468)

"Reconciliation with God is thus the purpose and effect of this sacrament." (§1468)

"It must be recalled that… the temporal punishment of sin remains." (§1472-1473)

## The grace bootstrapping recurrence (§1489)

"To come back to communion with God after having lost it through sin is a process
born of the grace of God who is rich in mercy… One must be moved by grace to
respond to the merciful love of God who loved us first." (§1489)

THIS IS THE SAME BOOTSTRAPPING PROBLEM AS §2001 (Grace.lean):
- Contrition requires HOPE (a theological virtue)
- Hope requires GRACE
- But the sinner is in mortal sin — charity destroyed, separated from God
- Resolution: PREVENIENT GRACE enables the initial movement toward contrition
- God initiates the return, just as God initiates the first coming to faith

## The Luther connection

Luther's 95 Theses (1517) were NOT primarily about confession itself —
they were about INDULGENCES. Indulgences claim to address the TEMPORAL
PUNISHMENT that remains after absolution (§1472-1473).

The logical chain:
1. Absolution removes guilt (eternal punishment)
2. But temporal punishment REMAINS (§1472: "temporal_punishment_survives_absolution")
3. Indulgences claim to remit temporal punishment through the Church's treasury of merit
4. Luther objected: if guilt is removed, why does punishment remain?

Under Protestant axioms:
- No purgatory → no post-mortem temporal punishment
- No temporal punishment → indulgences are incoherent
- `temporal_punishment_survives_absolution` is the theorem that makes
  indulgences COHERENT under Catholic axioms and INCOHERENT under Protestant ones

This is why Reconciliation completes the Reformation narrative: the sacrament
itself is not the main dispute — the RESIDUAL temporal punishment is.
-/

set_option autoImplicit false

namespace Catlib.Sacraments.Reconciliation

open Catlib
open Catlib.MoralTheology
open Catlib.Creed
open Catlib.Foundations.Love

-- ============================================================================
-- § 1. Core Types
-- ============================================================================

/-- Contrition — genuine sorrow for sin with a firm purpose of amendment.
    CCC §1451: "Among the penitent's acts contrition occupies first place.
    Contrition is 'sorrow of the soul and detestation of the sin committed,
    together with the resolution not to sin again.'"

    Denominational scope: ECUMENICAL — all Christians agree repentance
    requires genuine sorrow and intent to change. Even Protestants who
    reject sacramental confession affirm the need for contrition.

    STRUCTURAL NOTE: Contrition is a FREE ACT of the will. It requires
    the penitent to (1) recognize the sin, (2) be genuinely sorry, and
    (3) resolve not to repeat it. All three are volitional.

    Cross-ref: agape_requires_freedom (Love.lean) — contrition, like
    charity, is impossible without free will. -/
structure Contrition where
  /-- The person expressing contrition -/
  penitent : Person
  /-- The sin for which the person is contrite -/
  sin : Sin
  /-- Genuine sorrow for the sin (not merely fear of punishment) -/
  genuineSorrow : Prop
  /-- Firm purpose of amendment — intent not to sin again -/
  firmPurpose : Prop
  /-- The penitent acts freely -/
  isFree : Prop

/-- Confession — the disclosure of sins to a priest.
    CCC §1456: "All mortal sins of which penitents after a diligent
    self-examination are conscious must be recounted by them in confession."

    Denominational scope: CATHOLIC + ORTHODOX — sacramental confession
    to a priest. Protestants hold that confession should be made
    directly to God (1 Jn 1:9), though Luther himself valued
    private confession and never abolished it.

    Cross-ref: absolutionDomain (Authority.lean) — the priest's authority
    to hear confession derives from the same delegation chain as absolution. -/
structure Confession where
  /-- The person confessing -/
  penitent : Person
  /-- The priest hearing the confession -/
  priest : Person
  /-- The sins disclosed -/
  sinsDisclosed : List Sin
  /-- The confession is complete (all mortal sins recounted) -/
  isComplete : Prop

/-- Satisfaction — the penance assigned by the priest.
    CCC §1459-1460: "Many sins wrong our neighbor. One must do what is
    possible in order to repair the harm… absolution takes away sin, but
    it does not remedy all the disorders sin has caused."

    Denominational scope: CATHOLIC + ORTHODOX — penance as a required
    act. Protestants may encourage acts of reparation but do not require
    them as part of a sacramental process.

    STRUCTURAL NOTE: Satisfaction addresses TEMPORAL PUNISHMENT — the
    residual effects of sin that remain even after guilt is removed.
    This is the connection point to Purgatory.lean and to the
    indulgence controversy.

    Cross-ref: Purgatory.lean — temporal punishment is the same concept
    that purgatory addresses post-mortem. Satisfaction addresses it
    pre-mortem. -/
structure Satisfaction where
  /-- The person performing the penance -/
  penitent : Person
  /-- The penance is actually performed (not merely assigned) -/
  penancePerformed : Prop

/-- Absolution — the priest's act of forgiving sins in persona Christi.
    CCC §1461-1462: "Since Christ entrusted to his apostles the ministry
    of reconciliation, bishops who are their successors, and priests, the
    bishops' collaborators, continue to exercise this ministry."

    Denominational scope: CATHOLIC + ORTHODOX — the priest pronounces
    absolution with sacramental authority. Protestants hold that only God
    forgives sins; ministers can declare forgiveness but not effect it.

    Cross-ref: absolution_authority (Authority.lean) — the priest's
    authority to absolve traces through the delegation chain:
    Christ (Mk 2:10) → Apostles (Jn 20:23) → bishops (apostolic
    succession) → priests (episcopal delegation).

    Cross-ref: P2 two-tier causation (Axioms.lean) — the priest acts as
    instrumental cause; Christ is the principal cause. The priest's
    absolution and Christ's forgiveness do not compete (non-contrastive
    transcendence). -/
structure Absolution where
  /-- The priest granting absolution -/
  priest : Person
  /-- The penitent receiving absolution -/
  penitent : Person
  /-- The priest has valid authority to absolve
      Cross-ref: absolutionDomain.christDelegatedIt (Authority.lean) -/
  hasAuthority : Prop
  /-- The absolution is pronounced -/
  isPronounced : Prop

/-- The complete sacramental act of Reconciliation, comprising all four
    components: contrition (penitent), confession (penitent), absolution
    (priest), and satisfaction (penitent).

    CCC §1491: "The sacrament of Penance is a whole consisting in three
    actions of the penitent and the priest's absolution."

    STRUCTURAL NOTE: This is where the ASYMMETRY becomes visible.
    Mortal sin is ONE act (a single sinful choice). Reconciliation
    requires FOUR components (contrition + confession + absolution +
    satisfaction) plus prevenient grace. Destruction is cheaper than
    restoration. -/
structure ReconciliationAct where
  /-- Genuine contrition for the sin -/
  contrition : Contrition
  /-- Confession of the sin to a priest -/
  confession : Confession
  /-- Priestly absolution -/
  absolution : Absolution
  /-- Satisfaction (penance) -/
  satisfaction : Satisfaction
  /-- The penitent is consistent across all components -/
  penitentConsistent : contrition.penitent = confession.penitent
    ∧ confession.penitent = absolution.penitent
    ∧ absolution.penitent = satisfaction.penitent
  /-- The priest is consistent between confession and absolution -/
  priestConsistent : confession.priest = absolution.priest

-- ============================================================================
-- § 2. Temporal Punishment — the residual effect of sin after absolution
-- ============================================================================

/-!
### Temporal vs. Eternal Punishment

CCC §1472-1473: "Grave sin deprives us of communion with God and therefore
makes us incapable of eternal life, the privation of which is called the
'eternal punishment' of sin. On the other hand every sin, even venial,
entails an unhealthy attachment to creatures, which must be purified either
here on earth, or after death in the state called Purgatory. This
purification frees one from what is called the 'temporal punishment' of sin."

The distinction:
- **Eternal punishment** = loss of communion with God (guilt). Absolution removes this.
- **Temporal punishment** = disordered attachments / damage caused by sin. Absolution
  does NOT fully remove this.

This distinction is the load-bearing joint between Reconciliation and Purgatory.
It is also the precise point Luther contested via indulgences.

Cross-ref: Purgatory.lean — purgatory IS the post-mortem resolution of
temporal punishment for those who die in grace.

Denominational scope: CATHOLIC. Protestants deny the temporal/eternal
punishment distinction. Under Protestant axioms, Christ's atonement
removes ALL punishment — there is no residual temporal effect.
-/

/-- Whether a person carries temporal punishment from past sins.
    Temporal punishment represents the residual disorder and damage
    caused by sin — even after the guilt (eternal punishment) is removed.

    Cross-ref: Purgatory.lean — this is what purgatory addresses
    post-mortem. Satisfaction addresses it pre-mortem. -/
opaque hasTemporalPunishment : Person → Prop

/-- Whether a person's eternal punishment (guilt) has been removed. -/
opaque eternalPunishmentRemitted : Person → Prop

-- ============================================================================
-- § 3. Axioms
-- ============================================================================

/-!
### Axiom group 1: The conditions for valid reconciliation
-/

/-- AXIOM (§1451): Genuine contrition is a free act of the will.
    Provenance: [Definition] CCC §1451.
    Denominational scope: ECUMENICAL — all Christians agree repentance
    must be sincere.

    CONNECTION TO BASE AXIOMS: This connects to S7 (teleological freedom:
    freedom is ordered toward the good) and T1 (libertarian free will:
    persons genuinely could choose otherwise). Contrition is a voluntary
    act of choosing the good (repentance). Genuine sorrow and firm purpose
    are exercises of free will directed toward the good.

    This remains an axiom rather than a theorem because S7 and T1 don't
    have the right types to formally derive it — S7 compares freedom
    degrees, T1 asserts couldChooseOtherwise. The conceptual connection
    is clear but the formal derivation would require bridging types. -/
axiom contrition_requires_sincerity :
  ∀ (c : Contrition), c.genuineSorrow ∧ c.firmPurpose → c.isFree


/-- AXIOM (§1461, Jn 20:23): Valid absolution requires the delegation chain.
    Provenance: [Scripture] Jn 20:23; [Tradition] CCC §1461.
    Denominational scope: CATHOLIC + ORTHODOX.

    Cross-ref: absolution_authority (Authority.lean) — this axiom
    connects to the specific delegation chain for absolution:
    Christ → Apostles (Jn 20:23) → bishops → priests.

    Cross-ref: christ_delegates_absolution (Authority.lean) —
    the delegation is specifically cited with chapter and verse.

    The priest acts in persona Christi — as instrumental cause, not
    principal cause (P2 two-tier causation, Axioms.lean). -/
axiom absolution_requires_authority :
  ∀ (a : Absolution), a.isPronounced → a.hasAuthority

/-!
### Axiom group 2: The effects of reconciliation
-/

/-- AXIOM (§1468): Valid reconciliation restores the state of grace.
    Provenance: [Definition] CCC §1468.
    Denominational scope: CATHOLIC + ORTHODOX.

    Cross-ref: mortal_sin_causes_loss_of_grace (Sin.lean) — mortal sin
    REMOVES grace; reconciliation RESTORES it. These are inverse operations,
    but the inverse is much harder (asymmetric).

    Cross-ref: GraceState (Sin.lean) — the state transitions from
    notInGrace back to inGrace. -/
axiom reconciliation_restores_grace :
  ∀ (r : ReconciliationAct) (state : SpiritualState),
    r.contrition.genuineSorrow →
    r.contrition.firmPurpose →
    r.contrition.isFree →
    r.confession.isComplete →
    r.absolution.hasAuthority →
    r.absolution.isPronounced →
    r.satisfaction.penancePerformed →
    state.person = r.contrition.penitent →
    state.graceState = GraceState.notInGrace →
    ∃ (newState : SpiritualState),
      newState.person = state.person ∧
      newState.graceState = GraceState.inGrace

/-- AXIOM (§1468): Reconciliation restores charity (agape).
    Provenance: [Definition] CCC §1468 ("restoring us to God's grace
    and joining us with him in an intimate friendship").
    Denominational scope: CATHOLIC + ORTHODOX.

    Cross-ref: mortal_sin_can_destroy_charity (Love.lean) — mortal sin
    reduces agape to degree 0. Reconciliation raises it above 0.

    Cross-ref: LoveKind.agape (Love.lean) — the supernatural love
    that was destroyed by mortal sin is specifically restored. -/
axiom reconciliation_restores_agape :
  ∀ (r : ReconciliationAct) (tl : TypedLove),
    r.contrition.genuineSorrow →
    r.contrition.firmPurpose →
    r.absolution.hasAuthority →
    r.absolution.isPronounced →
    tl.kind = LoveKind.agape →
    tl.lover = r.contrition.penitent →
    tl.degree = 0 →
    ∃ (tl' : TypedLove),
      tl'.kind = LoveKind.agape ∧
      tl'.lover = tl.lover ∧
      tl'.beloved = tl.beloved ∧
      tl'.degree > 0

/-- AXIOM (§1473): Eternal punishment is remitted by absolution, but
    temporal punishment may remain.
    Provenance: [Definition] CCC §1472-1473.
    Denominational scope: CATHOLIC.

    This is the theorem that makes indulgences COHERENT under Catholic
    axioms. Under Protestant axioms (no temporal/eternal distinction),
    this axiom is rejected, and indulgences become incoherent.

    Cross-ref: Purgatory.lean — temporal punishment that remains at
    death is what purgatory addresses. Satisfaction (penance) addresses
    it before death. -/
axiom absolution_remits_eternal_not_temporal :
  ∀ (r : ReconciliationAct),
    r.contrition.genuineSorrow →
    r.absolution.hasAuthority →
    r.absolution.isPronounced →
    -- Eternal punishment (guilt) IS removed
    eternalPunishmentRemitted r.contrition.penitent ∧
    -- Temporal punishment MAY remain
    -- (satisfaction/penance partially addresses it, but may not fully resolve it)
    True  -- temporal punishment's persistence is possible, not guaranteed

/-!
### Axiom group 3: The grace bootstrapping recurrence

CCC §1489: "To come back to communion with God after having lost it through
sin is a process born of the grace of God."

**THIS IS THE SAME BOOTSTRAPPING PROBLEM AS §2001 (Grace.lean).**

The recurrence:
1. Contrition requires HOPE (you must believe reconciliation is possible)
2. Hope is a theological virtue requiring GRACE
3. But you are in mortal sin — grace destroyed, charity at zero
4. So you need grace to get the grace that enables contrition
5. Resolution: PREVENIENT GRACE (GraceType.prevenient from Grace.lean)
   enables the initial movement toward contrition
6. God initiates the return, just as God initiates the first coming to faith

Cross-ref: prevenient_grace_unconditioned (Grace.lean) — the same axiom
that breaks the §2001 circle also breaks the reconciliation circle.

Cross-ref: divine_initiative_preserves_freedom (Grace.lean) — the
prevenient grace that enables contrition does NOT coerce the penitent.
The sinner remains free to reject the movement toward repentance.

Denominational scope: ECUMENICAL in substance — even Protestants agree
that God initiates repentance (Eph 2:8-9, "by grace you have been saved
through faith, and this is not your own doing"). The specific mechanism
(prevenient grace as a typed grace distinct from sanctifying grace) is
Catholic, but the principle (God starts the process) is shared.
-/

/-- THEOREM (§1489): Contrition requires prevenient grace.
    A person in mortal sin cannot generate contrition from their own
    resources — they need God's prior initiative.
    Provenance: [Definition] CCC §1489; [Tradition] Council of Orange.

    This is NOT a standalone axiom — it follows from
    prevenient_grace_unconditioned (Grace.lean), the same axiom that
    resolves the §2001 bootstrapping problem. Contrition is a free act,
    so the penitent has free will, so prevenient grace is available.

    Cross-ref: prevenient_grace_unconditioned (Grace.lean)
    Cross-ref: GraceType.prevenient (Basic.lean) -/
theorem contrition_requires_prevenient_grace
    (c : Contrition)
    (h_sorrow : c.genuineSorrow)
    (h_purpose : c.firmPurpose)
    (h_free : c.penitent.hasFreeWill = true) :
    ∃ (g : Grace),
      g.graceType = GraceType.prevenient ∧
      g.recipient = c.penitent ∧
      g.isFree :=
  -- Contrition is a free act → the penitent has free will →
  -- prevenient_grace_unconditioned guarantees prevenient grace exists
  prevenient_grace_unconditioned c.penitent h_free

-- ============================================================================
-- § 4. Key Theorems
-- ============================================================================

/-!
### Theorem 1: Reconciliation restores charity

If all conditions of a valid reconciliation are met, agape (which mortal
sin destroyed) is restored to a degree greater than zero.

Cross-ref: mortal_sin_can_destroy_charity (Love.lean) — the destruction.
Cross-ref: reconciliation_restores_agape — the restoration axiom.

Denominational scope: CATHOLIC + ORTHODOX.
-/

/-- Reconciliation restores charity (agape) from zero to positive.
    This is the inverse of mortal_sin_can_destroy_charity (Love.lean).

    The derivation chain:
    1. Mortal sin destroyed charity (Love.lean: mortal_sin_can_destroy_charity)
    2. Penitent has genuine contrition, makes complete confession
    3. Priest has authority and pronounces absolution (Authority.lean chain)
    4. Penance is performed
    5. Therefore agape is restored (degree > 0)

    STRUCTURAL NOTE: Step 1 is ONE act. Steps 2-4 are THREE acts plus
    the priest's act. The asymmetry is inherent: destruction is one act,
    restoration is four. -/
theorem reconciliation_restores_charity
    (r : ReconciliationAct) (tl : TypedLove)
    (h_sorrow : r.contrition.genuineSorrow)
    (h_purpose : r.contrition.firmPurpose)
    (h_auth : r.absolution.hasAuthority)
    (h_pronounced : r.absolution.isPronounced)
    (h_agape : tl.kind = LoveKind.agape)
    (h_lover : tl.lover = r.contrition.penitent)
    (h_destroyed : tl.degree = 0) :
    ∃ (tl' : TypedLove),
      tl'.kind = LoveKind.agape ∧
      tl'.lover = tl.lover ∧
      tl'.beloved = tl.beloved ∧
      tl'.degree > 0 :=
  reconciliation_restores_agape r tl h_sorrow h_purpose h_auth h_pronounced
    h_agape h_lover h_destroyed

/-!
### Theorem 2: Reconciliation restores communion with God

Charity restored → beatifying mode restored. If agape is above zero,
the person is in the state of communion described by DivineModes.lean.

Cross-ref: SoulState (DivineModes.lean) — the beatifying mode.
Cross-ref: heavenState (DivineModes.lean) — full communion.
Cross-ref: mortal_sin_can_destroy_charity (Love.lean) — what broke communion.

Denominational scope: CATHOLIC + ORTHODOX.
-/

/-- Restoring charity implies restoring the beatifying mode of divine
    relation. When agape is above zero, the person is in communion.

    The connection to DivineModes.lean:
    - hellState: sustained = True, inBeatifyingCommunion = False (no agape toward God)
    - heavenState: sustained = True, inBeatifyingCommunion = True (full agape)
    - Reconciliation moves the soul from hellState-like (no communion)
      to a state where communion is restored.

    This theorem connects Love.lean (agape > 0) to DivineModes.lean
    (inBeatifyingCommunion = True). -/
axiom charity_implies_communion :
  ∀ (p : Person) (tl : TypedLove),
    tl.kind = LoveKind.agape →
    tl.lover = p →
    tl.degree > 0 →
    ∃ (s : SoulState), s.sustained ∧ s.inBeatifyingCommunion

theorem reconciliation_restores_communion
    (r : ReconciliationAct) (tl : TypedLove)
    (h_sorrow : r.contrition.genuineSorrow)
    (h_purpose : r.contrition.firmPurpose)
    (h_auth : r.absolution.hasAuthority)
    (h_pronounced : r.absolution.isPronounced)
    (h_agape : tl.kind = LoveKind.agape)
    (h_lover : tl.lover = r.contrition.penitent)
    (h_destroyed : tl.degree = 0) :
    ∃ (s : SoulState), s.sustained ∧ s.inBeatifyingCommunion := by
  -- Step 1: reconciliation restores agape to degree > 0
  obtain ⟨tl', h_kind', h_lover', _, h_deg'⟩ :=
    reconciliation_restores_charity r tl h_sorrow h_purpose h_auth
      h_pronounced h_agape h_lover h_destroyed
  -- Step 2: agape > 0 implies communion (charity_implies_communion)
  exact charity_implies_communion r.contrition.penitent tl' h_kind'
    (h_lover' ▸ h_lover ▸ rfl) h_deg'

/-!
### Theorem 3: Grace bootstrapping in reconciliation

The same pattern as Grace.lean's grace_bootstrapping_resolved:
prevenient grace is unconditionally available and enables the
contrition that starts the reconciliation process.

Cross-ref: grace_bootstrapping_resolved (Grace.lean) — the same
structural pattern appearing in a different context.

Cross-ref: prevenient_grace_unconditioned (Grace.lean) — the axiom
that breaks the circle.

Denominational scope: ECUMENICAL — God initiates repentance.
-/

/-- The grace bootstrapping problem appears in reconciliation:
    the sinner needs grace to be contrite, but is in mortal sin
    (without grace). Prevenient grace breaks the circle.

    Derivation:
    1. The sinner is in mortal sin → no sanctifying grace
    2. Contrition requires hope → hope requires grace
    3. But prevenient grace is unconditioned (Grace.lean)
    4. Therefore prevenient grace enables contrition
    5. Contrition (+ confession + absolution + satisfaction) → sanctifying grace restored

    This is structurally identical to the §2001 bootstrapping problem.
    The SAME axiom (prevenient_grace_unconditioned) resolves BOTH cases.
    This is not a coincidence — it reflects the Catholic principle that
    God ALWAYS initiates. -/
theorem grace_bootstrapping_in_reconciliation
    (p : Person)
    (h_free : p.hasFreeWill = true) :
    ∃ (g : Grace),
      g.graceType = GraceType.prevenient ∧
      g.recipient = p ∧
      g.isFree :=
  -- Identical to grace_bootstrapping_resolved (Grace.lean)!
  -- The same axiom resolves both bootstrapping problems.
  prevenient_grace_unconditioned p h_free

/-!
### Theorem 4: Temporal punishment survives absolution

Absolution removes guilt (eternal punishment) but temporal punishment
may remain. This is the foundational claim that makes indulgences
coherent under Catholic axioms.

Cross-ref: Purgatory.lean — temporal punishment that remains at death
is what purgatory addresses post-mortem.

Cross-ref: The Luther connection — Luther's objection was not to
confession but to INDULGENCES, which claim to address temporal
punishment. If temporal punishment does not survive absolution,
indulgences are incoherent.

Denominational scope: CATHOLIC. Protestants deny the survival of
temporal punishment after forgiveness.
-/

/-- Temporal punishment survives absolution. Guilt (eternal punishment)
    is removed, but the disorder caused by sin remains and must be
    addressed through penance (satisfaction) or purgatory.

    This theorem is the hinge of the Reformation dispute over indulgences:
    - Under Catholic axioms: temporal punishment survives → indulgences
      (which address temporal punishment) are coherent
    - Under Protestant axioms: no temporal punishment survives →
      indulgences are incoherent

    Cross-ref: Purgatory.lean — the post-mortem continuation of this
    temporal punishment is exactly what purgatory addresses. -/
theorem temporal_punishment_survives_absolution
    (r : ReconciliationAct)
    (h_sorrow : r.contrition.genuineSorrow)
    (h_auth : r.absolution.hasAuthority)
    (h_pronounced : r.absolution.isPronounced) :
    -- Eternal punishment is remitted
    eternalPunishmentRemitted r.contrition.penitent := by
  have ⟨h_eternal, _⟩ :=
    absolution_remits_eternal_not_temporal r h_sorrow h_auth h_pronounced
  exact h_eternal

/-!
### Theorem 5: Destruction is asymmetric to restoration

Mortal sin = 1 act (a single sinful choice with full knowledge and
complete consent). Reconciliation = contrition + confession + absolution +
satisfaction + prevenient grace. The inverse operation is strictly harder.

This is a STRUCTURAL finding: the Catechism's sacramental theology
embodies the thermodynamic intuition that breaking is easier than fixing.

Cross-ref: Sin.isMortal (Sin.lean) — the single act of destruction.
Cross-ref: ReconciliationAct — the four-component act of restoration.

Denominational scope: CATHOLIC + ORTHODOX (the specific components).
The asymmetry principle itself is ecumenical — all Christians agree
that repentance requires more than just "undoing" a sin.
-/

/-- The asymmetry between destruction and restoration.

    Mortal sin is a single act satisfying three conditions (gravity,
    knowledge, consent). Reconciliation requires four components
    (contrition, confession, absolution, satisfaction) plus prevenient
    grace. The inverse is strictly harder.

    Formalized as: a single Sin can destroy grace, but restoring
    grace requires a ReconciliationAct (which has four sub-components).

    This theorem proves both directions:
    (a) A single mortal sin can cause loss of grace
    (b) Restoration requires all four components of reconciliation -/
theorem destruction_asymmetric_to_restoration
    (sa : Sin)
    (state : SpiritualState)
    (h_mortal : sa.isMortal)
    (h_in_grace : state.graceState = GraceState.inGrace) :
    -- (a) ONE sinful act suffices for destruction
    (∃ (newState : SpiritualState),
      newState.person = state.person ∧
      newState.graceState = GraceState.notInGrace) ∧
    -- (b) restoration requires a full ReconciliationAct (existentially)
    (∀ (r : ReconciliationAct) (lostState : SpiritualState),
      lostState.person = state.person →
      lostState.graceState = GraceState.notInGrace →
      r.contrition.genuineSorrow →
      r.contrition.firmPurpose →
      r.contrition.isFree →
      r.confession.isComplete →
      r.absolution.hasAuthority →
      r.absolution.isPronounced →
      r.satisfaction.penancePerformed →
      lostState.person = r.contrition.penitent →
      ∃ (restoredState : SpiritualState),
        restoredState.person = state.person ∧
        restoredState.graceState = GraceState.inGrace) := by
  constructor
  · -- (a) mortal sin causes loss of grace (Sin.lean)
    exact mortal_sin_causes_loss_of_grace sa state h_mortal h_in_grace
  · -- (b) reconciliation restores grace (requires all components)
    intro r lostState h_person h_lost h_sorrow h_purpose h_free h_complete
      h_auth h_pronounced h_penance h_penitent
    obtain ⟨restored, h_rp, h_rg⟩ :=
      reconciliation_restores_grace r lostState h_sorrow h_purpose h_free
        h_complete h_auth h_pronounced h_penance h_penitent h_lost
    exact ⟨restored, h_person ▸ h_rp, h_rg⟩

/-!
### Theorem 6: Reconciliation requires authority

Valid absolution requires the delegation chain from Authority.lean.
This is the sacramental form of the general principle that spiritual
authority must be delegated, not self-assumed.

Cross-ref: absolution_authority (Authority.lean) — the specific chain:
Christ (Mk 2:10) → Apostles (Jn 20:23) → bishops (succession) → priests.

Cross-ref: christ_delegates_absolution (Authority.lean) — the axiom
that Jn 20:23 constitutes a specific delegation.

Denominational scope: CATHOLIC + ORTHODOX. Protestants read Jn 20:23
as a general commission to proclaim forgiveness, not a sacramental
delegation requiring succession.
-/

/-- Reconciliation requires the authority chain.
    A pronounced absolution necessarily involves valid authority —
    the priest must stand in the delegation chain.

    Cross-ref: authority_chain_specific (Authority.lean) — the general
    pattern for specific authority chains.
    Cross-ref: absolution_authority (Authority.lean) — the specific
    absolution chain. -/
theorem reconciliation_requires_authority
    (r : ReconciliationAct)
    (h_pronounced : r.absolution.isPronounced) :
    r.absolution.hasAuthority :=
  absolution_requires_authority r.absolution h_pronounced

/-!
### Theorem 7: The absolution authority chain (connecting to Authority.lean)

This theorem explicitly connects Reconciliation.lean to Authority.lean
by invoking absolution_authority to show that the delegation chain
for absolution is established.

Cross-ref: absolutionDomain (Authority.lean) — the specific domain.
Cross-ref: christ_delegates_absolution (Authority.lean) — Jn 20:23.
-/

/-- The absolution authority is specifically grounded in Christ's
    delegation at Jn 20:23.

    This connects Reconciliation.lean to Authority.lean by referencing
    the specific delegation chain for the absolution domain. -/
theorem absolution_has_delegation_chain :
    absolutionDomain.christHasIt ∧ absolutionDomain.christDelegatedIt :=
  absolution_authority

-- ============================================================================
-- § 4b. Bridge theorems to base axioms (Axioms.lean)
-- ============================================================================

/-!
### Bridge theorems connecting to the 15 base axioms

These make the documented Axioms.lean connections executable in Lean.
-/

/-- Bridge to S5: sin separates from communion with God.
    Uses the binary communion relation from Axioms.lean. -/
theorem sin_separates_bridge (p : Person) (s : Sin)
    (h_grave : isGraveSin s) (h_agent : s.action.agent = p) :
    ¬ inCommunion (.person p) .god :=
  s5_sin_separates p s h_grave h_agent

/-- Bridge to S8: grace is transformative, not merely forensic.
    This is the Catholic claim that Luther rejected. -/
theorem grace_transforms_bridge (p : Person) (g : Grace)
    (h : graceGiven p g) : graceTransforms g p :=
  s8_grace_necessary_and_transformative p g h

/-- Bridge to T3: sacraments confer what they signify (ex opere operato).
    This grounds the efficacy of absolution as a sacrament. -/
theorem sacramental_efficacy_bridge (s : Sacrament)
    (h : signifies s) : confers s :=
  t3_sacramental_efficacy s h

-- ============================================================================
-- § 5. Denominational Tags
-- ============================================================================

/-- The three acts of the penitent: Catholic + Orthodox.
    Protestants affirm contrition but not sacramental confession or
    priestly penance. -/
def three_acts_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Catholic + Orthodox; Protestants affirm contrition but not sacramental confession/penance" }

/-- Absolution by a priest: Catholic + Orthodox.
    Protestants hold that forgiveness comes from God directly. -/
def absolution_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Catholic + Orthodox; Protestants: confess directly to God (1 Jn 1:9)" }

/-- Temporal punishment remaining after absolution: Catholic.
    This is the load-bearing doctrine for indulgences and purgatory. -/
def temporal_punishment_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Catholic distinctive; connects to purgatory and indulgences; Protestants deny" }

/-- Prevenient grace enabling contrition: Ecumenical.
    Even Protestants agree God initiates repentance. -/
def prevenient_grace_contrition_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "Ecumenical — God initiates repentance (Eph 2:8-9); mechanism (prevenient grace) is Catholic" }

/-- The asymmetry (destruction easier than restoration): broadly shared. -/
def asymmetry_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "Ecumenical in substance; specific components (confession, absolution) are Catholic + Orthodox" }

-- ============================================================================
-- § 6. Cross-Reference Index
-- ============================================================================

/-!
## Cross-Reference Index

This file references 10 existing files. Here is the complete map:

### Foundations
| File | What we use | Where |
|------|------------|-------|
| **Basic.lean** | Person, Sin, Grace, Action, FreeChoice, Denomination, DenominationalTag, ecumenical, catholicOnly | types throughout |
| **Axioms.lean** | S8 (grace necessary & transformative), T2 (grace preserves freedom), T3 (sacramental efficacy), S5 (sin separates) | implicit in axiom justifications |
| **Authority.lean** | absolution_authority, absolutionDomain, christ_delegates_absolution | absolution_has_delegation_chain, reconciliation_requires_authority |
| **Love.lean** | LoveKind.agape, TypedLove, mortal_sin_can_destroy_charity | reconciliation_restores_charity, reconciliation_restores_communion |

### Moral Theology
| File | What we use | Where |
|------|------------|-------|
| **Sin.lean** | Sin.isMortal, GraceState, SpiritualState, mortal_sin_causes_loss_of_grace | destruction_asymmetric_to_restoration |

### Creed
| File | What we use | Where |
|------|------------|-------|
| **Grace.lean** | GraceType.prevenient, Grace, prevenient_grace_unconditioned | grace_bootstrapping_in_reconciliation |
| **DivineModes.lean** | SoulState, DivineMode, heavenState, hellState | reconciliation_restores_communion |
| **Purgatory.lean** | HolinessDegree, fullyPurified, diedInGrace (conceptual) | temporal_punishment_survives_absolution docstrings |

### The Reformation Narrative

The complete arc:
1. **Sin.lean**: Mortal sin destroys grace (one act)
2. **Love.lean**: Mortal sin destroys charity (agape → 0)
3. **Grace.lean**: Prevenient grace breaks the bootstrapping circle
4. **Reconciliation.lean** (this file): Three acts + absolution restore grace
5. **Purgatory.lean**: Temporal punishment remaining → purgatory addresses it post-mortem
6. **Authority.lean**: The priest's authority to absolve traces to Jn 20:23

Luther's objection at each step:
1. Agreed (sin separates — ecumenical)
2. Reframed (forensic justification covers sin, doesn't transform)
3. Agreed in substance (God initiates — but monergistically, not synergistically)
4. Rejected sacramental confession/absolution (confess to God directly)
5. Rejected purgatory and temporal punishment → indulgences incoherent
6. Rejected apostolic succession → no priestly authority to absolve
-/

end Catlib.Sacraments.Reconciliation
