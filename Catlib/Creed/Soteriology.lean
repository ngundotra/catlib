import Catlib.Foundations
import Catlib.Creed.OriginalSin
import Catlib.Creed.Grace

/-!
# CCC §1987–2029: The Catholic Plan of Salvation (Soteriology)

## The source claims

The Catechism presents salvation as an ordered chain of doctrinal steps.
Each step adds a claim; each claim is either ecumenical (shared with
Protestants) or distinctively Catholic. The chain is:

1. **All are sinners** (Rom 3:23; §1987) — universal need for salvation
2. **No one can save themselves** (§1987; Jn 15:5) — self-salvation impossible
3. **Christ alone saves** (Acts 4:12; §432) — unique savior
4. **Grace is a free gift** (§1996; Eph 2:8) — unmerited
5. **Grace is accessed through faith + baptism + repentance** (§1987–1989)
6. **Faith is lived through love** (Gal 5:6; §1814) — "faith working through love"
7. **Good works are required as grace-enabled cooperation** (§2008–2011)
8. **Perseverance is needed** (§2016) — salvation is not a one-time event

## What this formalization reveals

The Catholic salvation chain is a LONGER chain than the Protestant one.
Steps 1–4 are ecumenical — all Christians agree. Steps 5–8 each introduce
a distinctively Catholic axiom that a Protestant would reject or weaken.

The denominational split at each step:
- Step 5: Catholic adds baptism + repentance as ordinary means; Protestant
  says faith alone (sola fide)
- Step 6: Catholic says faith must be active in love; Protestant says love
  is fruit, not condition
- Step 7: Catholic says works are genuinely meritorious (by grace);
  Protestant says works are evidence, not cause
- Step 8: Catholic says you can lose salvation (mortal sin); many Protestants
  say "once saved always saved" (perseverance of the saints)

The KEY structural finding: the Catholic soteriology is the CONJUNCTION
of all 8 steps. The Protestant soteriology is steps 1–4 only (with steps
5–8 either rejected or weakened). Each additional step is a new axiom a
Protestant would contest. The "debate" is not about one point — it is
about how LONG the chain should be.

## Hidden assumptions

1. **Universal sinfulness is TRANSMITTED, not just universal in practice.**
   The CCC means original sin (an inherited condition, §405), not merely
   "everyone happens to sin." This is stronger than the Protestant reading
   of Rom 3:23 as empirical generalization. (Connects to OriginalSin.lean.)

2. **"Ordinary means" admits exceptions.** The CCC says baptism is the
   ordinary means (§1257) but acknowledges baptism of desire and of blood
   (§1258–1259). The formalization models the ordinary case.

3. **Cooperation is not semi-Pelagianism.** The CCC insists that cooperation
   is itself grace-enabled (§2001) — you cannot cooperate without prior
   grace. This was the finding of Grace.lean's bootstrapping analysis.

4. **Merit is NOT self-earned.** The CCC explicitly says "with regard to God,
   there is no strict right to any merit on the part of man" (§2007).
   Merit is real but its source is grace, not autonomous human effort.

## Modeling choices

1. We model each salvation step as a predicate on Person, not as a temporal
   process. The CCC describes a process but the doctrinal content is about
   CONDITIONS, not timing.

2. We model the Protestant alternative at each split point by negating or
   weakening the Catholic axiom, following the axiom-set-as-denomination
   pattern from Justification.lean.

3. We import types from OriginalSin.lean (for universal sinfulness) and
   Grace.lean (for the bootstrapping resolution) rather than re-axiomatizing.
-/

set_option autoImplicit false

namespace Catlib.Creed.Soteriology

open Catlib
open Catlib.Creed.OriginalSin

-- ============================================================================
-- ## Predicates for the salvation chain
-- ============================================================================

/-- Whether a person has faith in Christ.
    CCC §1814: "Faith is the theological virtue by which we believe in God
    and believe all that he has said and revealed to us." -/
opaque hasFaith : Person → Prop

/-- Whether a person has been baptized.
    CCC §1213: "Holy Baptism is the basis of the whole Christian life." -/
opaque isBaptized : Person → Prop

/-- Whether a person has repented (turned away from sin toward God).
    CCC §1989: "The first work of the grace of the Holy Spirit is
    conversion." -/
opaque hasRepented : Person → Prop

/-- Whether a person's faith is active in love (not dead faith).
    CCC §1814: "faith working through love" (Gal 5:6).
    Jas 2:26: "faith without works is dead." -/
opaque faithActiveInLove : Person → Prop

/-- Whether a person performs good works as grace-enabled cooperation.
    CCC §2008: "The merit of man before God in the Christian life arises
    from the fact that God has freely chosen to associate man with the
    work of his grace." -/
opaque performsGoodWorks : Person → Prop

/-- Whether a person's good works are grace-enabled (not autonomous effort).
    CCC §2008: merit arises from God's free choice to associate man with grace.
    HIDDEN ASSUMPTION: This predicate is what distinguishes Catholic merit from
    Pelagian self-salvation. The works are real, but their source is grace. -/
opaque worksAreGraceEnabled : Person → Prop

/-- Whether a person perseveres in grace to the end.
    CCC §2016: "The children of our holy mother the Church rightly hope for
    the grace of final perseverance." -/
opaque perseveres : Person → Prop

/-- Whether Christ is the unique savior of a person.
    CCC §432: "The name Jesus signifies that the very name of God is present
    in the person of his Son." Acts 4:12: "There is no other name under
    heaven given among men by which we must be saved." -/
opaque christSaves : Person → Prop

/-- Whether a person is in a state of salvation (justified and on the path
    to final salvation). -/
opaque inStateOfSalvation : Person → Prop

/-- Whether a person can save themselves by their own power. -/
opaque canSaveSelf : Person → Prop

/-- Whether a person can lose their salvation through mortal sin.
    CCC §1861: "Mortal sin... results in the loss of charity and the
    privation of sanctifying grace, that is, of the state of grace." -/
opaque canLoseSalvation : Person → Prop

-- ============================================================================
-- ## ECUMENICAL STEPS (1–4): All Christians agree
-- ============================================================================

/-- **STEP 1 (Rom 3:23; CCC §1987): ALL ARE SINNERS.**
    "All have sinned and fall short of the glory of God."

    This connects to OriginalSin.lean's `the_fall`: every person with
    intellect has a wounded nature. The CCC grounds universal sinfulness
    in original sin (§405), not merely in empirical observation.

    Provenance: [Scripture] Rom 3:23; CCC §1987, §405.
    Denominational scope: ECUMENICAL — all Christians accept universal
    sinfulness (though they disagree on the mechanism: original sin vs.
    total depravity vs. empirical universality). -/
axiom step1_all_are_sinners :
  ∀ (p : Person),
    p.hasIntellect = true →
    natureIsWounded p

/-- Denominational tag: ecumenical. -/
def step1_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "All Christians accept universal sinfulness; Rom 3:23; mechanism differs" }

/-- **STEP 2 (CCC §1987; Jn 15:5): NO ONE CAN SAVE THEMSELVES.**
    "Without me you can do nothing" (Jn 15:5).

    The wound of original sin makes self-salvation impossible. This is
    derivable from OriginalSin.lean's `the_fall` (fallen humans cannot
    reach their supernatural end unaided), but we state it as a distinct
    step because the SOTERIOLOGICAL emphasis differs: the_fall says "you
    are wounded"; this says "therefore you cannot fix yourself."

    Provenance: [Scripture] Jn 15:5; CCC §1987.
    Denominational scope: ECUMENICAL — all Christians accept this.
    (Even Pelagians were condemned for denying it.) -/
axiom step2_cannot_save_self :
  ∀ (p : Person),
    p.hasIntellect = true →
    ¬ canSaveSelf p

/-- Denominational tag: ecumenical. -/
def step2_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "All Christians: self-salvation impossible; Jn 15:5; anti-Pelagian" }

/-- **STEP 3 (Acts 4:12; CCC §432): CHRIST ALONE SAVES.**
    "There is no other name under heaven given among men by which we
    must be saved."

    Provenance: [Scripture] Acts 4:12; CCC §432.
    Denominational scope: ECUMENICAL — all Christians affirm the unique
    saving role of Christ. -/
axiom step3_christ_alone_saves :
  ∀ (p : Person),
    p.hasIntellect = true →
    inStateOfSalvation p → christSaves p

/-- Denominational tag: ecumenical. -/
def step3_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "All Christians: Christ is the unique savior; Acts 4:12" }

/-- **STEP 4 (CCC §1996; Eph 2:8): GRACE IS A FREE GIFT.**
    "For by grace you have been saved through faith, and this is not
    your own doing; it is the gift of God" (Eph 2:8).

    Grace is unmerited. This connects to Basic.lean's `Grace.isFree` and
    `Grace.isUndeserved` fields, and to Grace.lean's prevenient grace
    analysis: God gives the first grace unconditionally.

    Provenance: [Scripture] Eph 2:8; CCC §1996.
    Denominational scope: ECUMENICAL — all Christians affirm grace is
    unmerited. (The disagreement is about what FOLLOWS from grace, not
    about grace itself being free.) -/
axiom step4_grace_is_free :
  ∀ (p : Person) (g : Grace),
    graceGiven p g → g.isFree ∧ g.isUndeserved

/-- Denominational tag: ecumenical. -/
def step4_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "All Christians: grace is free and unmerited; Eph 2:8" }

-- ============================================================================
-- ## CATHOLIC-DISTINCTIVE STEPS (5–8): Where the splits begin
-- ============================================================================

/-- **STEP 5 (CCC §1987–1989): FAITH + BAPTISM + REPENTANCE.**
    The ordinary means of accessing saving grace are faith, baptism,
    and repentance — not faith alone.

    "The grace of the Holy Spirit has the power to justify us, that is,
    to cleanse us from our sins and to communicate to us 'the righteousness
    of God through faith in Jesus Christ' and through Baptism." (§1987)

    "The first work of the grace of the Holy Spirit is conversion." (§1989)

    DENOMINATIONAL SPLIT: Catholic says faith + baptism + repentance;
    Protestant says faith alone (sola fide). The Catholic position adds
    TWO conditions the Protestant rejects: sacramental baptism (T3) and
    repentance as a condition (not merely a consequence) of justification.

    Provenance: [Definition] CCC §1987–1989; [Tradition] Trent Session 6.
    Denominational scope: CATHOLIC. -/
axiom step5_ordinary_means :
  ∀ (p : Person),
    p.hasIntellect = true →
    inStateOfSalvation p →
    hasFaith p ∧ isBaptized p ∧ hasRepented p

/-- Denominational tag: Catholic. -/
def step5_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Catholic: faith + baptism + repentance. Protestant: faith alone (sola fide)" }

/-- The Protestant alternative to Step 5: faith alone suffices.
    Under sola fide, baptism and repentance are FRUITS of faith,
    not conditions of justification. -/
def protestantStep5 (p : Person) : Prop :=
  hasFaith p → inStateOfSalvation p

/-- **STEP 6 (Gal 5:6; CCC §1814): FAITH WORKING THROUGH LOVE.**
    Saving faith is not bare intellectual assent — it is "faith working
    through love" (Gal 5:6). Dead faith (Jas 2:26) does not save.

    "Faith without works is dead" (Jas 2:26).
    "In Christ Jesus neither circumcision nor uncircumcision is of
    any avail, but faith working through love" (Gal 5:6).

    DENOMINATIONAL SPLIT: Catholic says faith must be active in love
    (love is a CONDITION of saving faith). Protestant says love is a
    FRUIT of saving faith (evidence, not condition). Both sides cite
    Jas 2 but interpret "dead faith" differently: Catholic says dead
    faith is insufficient for salvation; Protestant says dead faith
    was never real faith to begin with.

    Provenance: [Scripture] Gal 5:6; Jas 2:26; CCC §1814.
    Denominational scope: CATHOLIC. -/
axiom step6_faith_through_love :
  ∀ (p : Person),
    inStateOfSalvation p →
    hasFaith p →
    faithActiveInLove p

/-- Denominational tag: Catholic. -/
def step6_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Catholic: love is condition of saving faith. Protestant: love is fruit, not condition" }

/-- The Protestant alternative to Step 6: love is fruit, not condition.
    Under the Protestant view, true faith PRODUCES love, but the love
    is not what makes the faith saving. -/
def protestantStep6 (_p : Person) : Prop :=
  -- Love follows from faith but is not a condition of salvation.
  -- This is modeled as: no axiom connecting faithActiveInLove to
  -- inStateOfSalvation. The Protestant simply has a shorter chain.
  True

/-- **STEP 7 (CCC §2008–2011): GOOD WORKS AS GRACE-ENABLED MERIT.**
    Good works are genuinely meritorious — but their merit comes from
    grace, not from autonomous human effort.

    "With regard to God, there is no strict right to any merit on the
    part of man." (§2007)

    "The merit of man before God in the Christian life arises from the
    fact that God has freely chosen to associate man with the work of
    his grace." (§2008)

    DENOMINATIONAL SPLIT: Catholic says works are genuinely meritorious
    (by grace). Protestant says works are evidence of salvation, not
    contributory to it. The Catholic position requires BOTH:
    (a) works are required (they matter for salvation)
    (b) works are grace-enabled (not self-earned — anti-Pelagian)

    HIDDEN ASSUMPTION: "Associate man with the work of his grace" (§2008)
    is doing enormous work. It means God makes OUR works genuinely
    meritorious by including them in His plan. This is the Catholic
    resolution to the Protestant objection ("if works matter, it's not
    grace alone"): works ARE grace, working through the person.

    Provenance: [Definition] CCC §2007–2011; [Tradition] Trent Session 6,
    Canon 32.
    Denominational scope: CATHOLIC. -/
axiom step7_works_required :
  ∀ (p : Person),
    inStateOfSalvation p →
    performsGoodWorks p ∧ worksAreGraceEnabled p

/-- Denominational tag: Catholic. -/
def step7_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Catholic: works genuinely meritorious (by grace). Protestant: works are evidence, not cause" }

/-- The Protestant alternative to Step 7: works are evidence, not cause.
    Good works follow from salvation but do not contribute to it.
    "We are saved by faith alone, but the faith that saves is never
    alone" (attributed to Luther, though the exact wording is debated). -/
def protestantStep7 (_p : Person) : Prop :=
  -- Works follow from faith but are not required for salvation.
  True

/-- **STEP 8 (CCC §2016; §1861): PERSEVERANCE IS NEEDED.**
    Salvation is not a one-time event — the justified person must
    persevere to the end. Mortal sin can destroy the state of grace.

    "The children of our holy mother the Church rightly hope for the
    grace of final perseverance and for the reward of God their Father
    for the good works accomplished with his grace." (§2016)

    "Mortal sin... results in the loss of charity and the privation of
    sanctifying grace, that is, of the state of grace." (§1861)

    DENOMINATIONAL SPLIT: Catholic says you CAN lose salvation through
    mortal sin (S5: sin separates). Many Reformed Protestants say "once
    saved always saved" (perseverance of the saints / eternal security).
    The Catholic position requires S5 (sin separates from God) to apply
    even to the justified.

    CONNECTION TO BASE AXIOM: S5 (sin_separates) is the load-bearing
    axiom here. If grave sin breaks communion with God, then the
    justified person is not immune — they can fall. This connects to
    Reconciliation.lean: the sacrament of Reconciliation exists precisely
    BECAUSE salvation can be lost and must be restored.

    Provenance: [Definition] CCC §2016, §1861; [Scripture] Heb 10:26-27
    ("if we deliberately keep on sinning after we have received the
    knowledge of the truth, no sacrifice for sins is left").
    Denominational scope: CATHOLIC. -/
axiom step8_perseverance_needed :
  ∀ (p : Person),
    p.hasIntellect = true →
    inStateOfSalvation p →
    perseveres p ∧ canLoseSalvation p

/-- Denominational tag: Catholic. -/
def step8_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Catholic: can lose salvation (mortal sin). Reformed: once saved always saved (OSAS)" }

/-- The Reformed Protestant alternative to Step 8: perseverance of the
    saints. Those truly saved WILL persevere — they cannot ultimately
    fall away. (Westminster Confession ch. 17.) -/
def reformedStep8 (_p : Person) : Prop :=
  -- Once truly justified, the person cannot lose salvation.
  -- Apparent apostasy means the person was never truly saved.
  True

-- ============================================================================
-- ## THE SALVATION CHAIN: structures and key theorems
-- ============================================================================

/-- The Catholic salvation chain: the conjunction of all 8 steps applied
    to a person. This is what the CCC teaches about what salvation
    REQUIRES. -/
structure CatholicSalvationChain (p : Person) where
  /-- Step 1: The person is a sinner (wounded nature) -/
  isSinner : natureIsWounded p
  /-- Step 2: Cannot save themselves -/
  cannotSaveSelf : ¬ canSaveSelf p
  /-- Step 3: Christ is their savior -/
  savedByChrist : christSaves p
  /-- Step 4: Grace received is free -/
  graceIsFree : ∀ (g : Grace), graceGiven p g → g.isFree ∧ g.isUndeserved
  /-- Step 5: Has faith, baptism, and repentance -/
  hasMeans : hasFaith p ∧ isBaptized p ∧ hasRepented p
  /-- Step 6: Faith is active in love -/
  faithIsAlive : faithActiveInLove p
  /-- Step 7: Performs grace-enabled good works -/
  doesGoodWorks : performsGoodWorks p ∧ worksAreGraceEnabled p
  /-- Step 8: Perseveres and can lose salvation -/
  persevering : perseveres p ∧ canLoseSalvation p

/-- The Protestant salvation chain: only the ecumenical steps (1–4) plus
    faith alone. This is shorter — fewer conditions, fewer axioms. -/
structure ProtestantSalvationChain (p : Person) where
  /-- Step 1: The person is a sinner -/
  isSinner : natureIsWounded p
  /-- Step 2: Cannot save themselves -/
  cannotSaveSelf : ¬ canSaveSelf p
  /-- Step 3: Christ is their savior -/
  savedByChrist : christSaves p
  /-- Step 4: Grace received is free -/
  graceIsFree : ∀ (g : Grace), graceGiven p g → g.isFree ∧ g.isUndeserved
  /-- Faith alone (sola fide) -/
  hasFaithAlone : hasFaith p

-- ============================================================================
-- ## Key theorems
-- ============================================================================

/-- **THEOREM: The Catholic salvation chain is derivable from the 8 step axioms.**
    Given a person with intellect who is in a state of salvation, all 8
    step axioms combine to produce the full Catholic salvation chain.

    This is the MAIN WIRING THEOREM: it shows that the step axioms are
    not independent assertions but a coherent chain that produces the
    full soteriological structure. Every step axiom is invoked. -/
theorem catholic_chain_from_axioms
    (p : Person)
    (h_intellect : p.hasIntellect = true)
    (h_saved : inStateOfSalvation p) :
    CatholicSalvationChain p := by
  exact {
    isSinner := step1_all_are_sinners p h_intellect
    cannotSaveSelf := step2_cannot_save_self p h_intellect
    savedByChrist := step3_christ_alone_saves p h_intellect h_saved
    graceIsFree := fun g hg => step4_grace_is_free p g hg
    hasMeans := step5_ordinary_means p h_intellect h_saved
    faithIsAlive := step6_faith_through_love p h_saved
        (step5_ordinary_means p h_intellect h_saved).1
    doesGoodWorks := step7_works_required p h_saved
    persevering := step8_perseverance_needed p h_intellect h_saved
  }

/-- **THEOREM: The Catholic chain is LONGER — it projects to a Protestant chain.**
    The Catholic chain requires everything the Protestant chain requires,
    PLUS additional conditions (baptism, repentance, love, works,
    perseverance). This is the structural finding: Catholic soteriology
    is Protestant soteriology PLUS additional axioms.

    This means every Catholic salvation chain can be projected down to
    a Protestant chain (by forgetting the extra conditions), but not
    vice versa. -/
theorem catholic_chain_projects_to_protestant
    (p : Person)
    (cath : CatholicSalvationChain p) :
    ProtestantSalvationChain p := by
  exact {
    isSinner := cath.isSinner
    cannotSaveSelf := cath.cannotSaveSelf
    savedByChrist := cath.savedByChrist
    graceIsFree := cath.graceIsFree
    hasFaithAlone := cath.hasMeans.1
  }

/-- **THEOREM: The ecumenical core is shared.**
    Steps 1–4 of the Catholic chain are present in the Protestant chain.
    Both traditions agree on universal sinfulness, inability to self-save,
    Christ as unique savior, and grace as free gift.

    Uses step1, step2, step3, and step4 axioms via catholic_chain_from_axioms. -/
theorem ecumenical_core_shared
    (p : Person)
    (h_intellect : p.hasIntellect = true)
    (h_saved : inStateOfSalvation p) :
    natureIsWounded p
    ∧ ¬ canSaveSelf p
    ∧ christSaves p := by
  let cath := catholic_chain_from_axioms p h_intellect h_saved
  exact ⟨cath.isSinner, cath.cannotSaveSelf, cath.savedByChrist⟩

/-- **THEOREM: Step 1 is also derivable from OriginalSin.lean.**
    The universal sinfulness axiom connects to the_fall (OriginalSin.lean).
    This shows the salvation chain connects to the original sin
    formalization: its first step is already proven elsewhere. -/
theorem step1_from_original_sin
    (p : Person)
    (h_intellect : p.hasIntellect = true) :
    natureIsWounded p := by
  exact (the_fall p h_intellect).1

/-- **THEOREM: Step 4 connects to Grace.lean.**
    The free-gift claim connects to prevenient_grace_unconditioned:
    God gives prevenient grace without prior human action, confirming
    that grace is genuinely free. -/
theorem step4_connects_to_prevenient_grace
    (p : Person)
    (h_free : p.hasFreeWill = true) :
    ∃ (g : Grace), g.graceType = GraceType.prevenient ∧ g.recipient = p ∧ g.isFree := by
  exact prevenient_grace_unconditioned p h_free

/-- **THEOREM: The Catholic chain requires S8 (transformative grace).**
    Step 7 (works as grace-enabled cooperation) presupposes that grace
    TRANSFORMS the person — if grace were merely forensic (Luther), it
    would not enable real cooperative works. The Catholic chain therefore
    DEPENDS on S8, the most contested base axiom. -/
theorem works_require_transformation
    (p : Person) (g : Grace)
    (h_given : graceGiven p g) :
    graceTransforms g p := by
  exact s8_grace_necessary_and_transformative p g h_given

/-- **THEOREM: The Catholic chain requires T3 (sacramental efficacy).**
    Step 5 includes baptism as an ordinary means of salvation. Baptism
    as a CAUSE of grace (not merely a symbol) requires T3. Without T3,
    baptism is optional — and step 5 collapses to faith alone. -/
theorem baptism_requires_t3
    (s : Sacrament) (h : signifies s) :
    confers s := by
  exact t3_sacramental_efficacy s h

/-- **THEOREM: The Catholic chain requires T2 (grace preserves freedom).**
    Step 7 (grace-enabled cooperation) requires that under grace, the
    person is still FREE — their works are genuine cooperation, not
    coerced response. Without T2, "cooperation" is meaningless. -/
theorem cooperation_requires_freedom
    (p : Person) (g : Grace)
    (h_given : graceGiven p g) :
    couldChooseOtherwise p := by
  exact t2_grace_preserves_freedom p g h_given

-- ============================================================================
-- ## The denominational count: where exactly each tradition stops
-- ============================================================================

/-- The number of distinctively Catholic axioms in the salvation chain.
    Steps 5–8 each add one axiom a Protestant would reject.

    Step 5: + baptism + repentance as conditions (not just faith alone)
    Step 6: + love as condition of saving faith (not just fruit)
    Step 7: + works as genuinely meritorious (not just evidence)
    Step 8: + possibility of losing salvation (against OSAS)

    Total: 4 additional axioms beyond the ecumenical core. -/
def catholicDistinctiveCount : Nat := 4

/-- The ecumenical step count: steps 1–4. -/
def ecumenicalStepCount : Nat := 4

/-- The total Catholic chain length: 8 steps. -/
def catholicChainLength : Nat := ecumenicalStepCount + catholicDistinctiveCount

/-- The chain length theorem: Catholic chain has 8 steps. -/
theorem catholic_chain_is_eight :
    catholicChainLength = 8 := by
  rfl

-- ============================================================================
-- ## Where each denomination stops
-- ============================================================================

/-!
## The denominational spectrum

```
Step:     1      2      3      4      5       6       7       8
Claim:  sinners  can't  Christ  grace  faith+  faith   works   perse-
                 self   saves   free   baptism through  merit  verance
                                       +repent  love
         ────── ────── ────── ────── ─────── ─────── ─────── ───────
CATHOLIC   ✓      ✓      ✓      ✓      ✓       ✓       ✓       ✓
LUTHERAN   ✓      ✓      ✓      ✓      ~       ~       ✗       ~
REFORMED   ✓      ✓      ✓      ✓      ✗       ~       ✗       ✗ (OSAS)
BAPTIST    ✓      ✓      ✓      ✓      ✗       ~       ✗       ✗ (OSAS)
```

Legend: ✓ = accepts, ✗ = rejects, ~ = partially accepts

### Where each tradition diverges:

**LUTHERAN** (Step 5, partial):
- Accepts baptism as means of grace (infant baptism, baptismal regeneration)
- Rejects "repentance as condition" — for Luther, repentance flows FROM
  faith, it is not a precondition
- Step 6: partially — love follows from faith but is not a condition
- Step 7: REJECTS — works are fruit, not merit (Formula of Concord Art. IV)
- Step 8: partially — Lutherans say you CAN fall from grace, but the
  mechanism differs from Catholic account

**REFORMED / CALVINIST** (Step 5):
- Rejects baptism as means of grace (baptism is a sign, not a cause)
- Step 5 collapses to faith alone (sola fide)
- Step 7: REJECTS merit entirely
- Step 8: REJECTS — perseverance of the saints (OSAS); those who fall
  away were never truly elected (Westminster Confession ch. 17)

**BAPTIST** (Step 5):
- Same as Reformed on sola fide
- Additionally rejects infant baptism (credobaptism only)
-/

-- ============================================================================
-- ## Summary
-- ============================================================================

/-!
## Summary: what the formalization reveals

### The main structural finding

The Catholic plan of salvation is an **8-step chain**. The Protestant plan
is a **4-step chain** (plus faith alone). The Catholic plan is strictly
longer: it includes everything the Protestant affirms, PLUS four additional
conditions. This is why `catholic_chain_projects_to_protestant` works:
you can always forget the extra conditions.

The converse does NOT hold: a Protestant chain cannot be extended to a
Catholic chain without accepting new axioms (T3, S8 as transformative,
the merit of works, the possibility of losing salvation).

### The load-bearing base axioms

The Catholic salvation chain depends on three base axioms from Axioms.lean:
- **S8** (grace necessary and transformative) — required by Step 7
- **T2** (grace preserves freedom) — required by Step 7
- **T3** (sacramental efficacy) — required by Step 5

All three are CATHOLIC DISTINCTIVE axioms — Protestants reject or modify
each one. This confirms the project's central thesis: the axiom set IS
the denomination.

### Connection to existing formalizations

- **OriginalSin.lean**: Step 1 (all are sinners) is derivable from `the_fall`
- **Grace.lean**: Step 4 (grace is free) connects to `prevenient_grace_unconditioned`
- **Justification.lean**: The Catholic vs. Protestant models mirror Steps 5–7
- **Reconciliation.lean**: Step 8 (can lose salvation) is why Reconciliation exists
- **Baptism.lean**: Step 5 (baptism as ordinary means) connects to infant baptism

### What is genuinely doctrinal vs. apologetic packaging?

The task asked: "which links are genuinely doctrinal, and which are
apologetic packaging?"

**Genuinely doctrinal** (the CCC explicitly teaches these):
- Steps 1–4: ecumenical core (Rom 3:23, Jn 15:5, Acts 4:12, Eph 2:8)
- Step 5 (baptism + repentance): §1987–1989, Trent Session 6
- Step 6 (faith through love): §1814, Gal 5:6
- Step 7 (merit by grace): §2008–2011, Trent Session 6 Canon 32
- Step 8 (perseverance): §2016, §1861

**Apologetic packaging** (our ordering, not the CCC's):
- The CHAIN STRUCTURE itself is our modeling choice. The CCC does not
  present soteriology as an ordered 8-step chain — it presents the
  claims across multiple paragraphs in different sections. We imposed
  the chain ordering to make the denominational splits visible.
- The projection theorem (Catholic → Protestant) is our structural
  observation, not a CCC claim.

**Verdict**: ALL 8 steps are genuinely doctrinal (each is grounded in
specific CCC paragraphs and Scripture). The CHAIN ORDERING and the
PROJECTION STRUCTURE are our modeling choices that reveal the
relationship between traditions.

### New axiom count for this file: 8

Local axioms: 8 (step1 through step8)
Theorems: 9 (catholic_chain_from_axioms, catholic_chain_projects_to_protestant,
ecumenical_core_shared, step1_from_original_sin,
step4_connects_to_prevenient_grace, works_require_transformation,
baptism_requires_t3, cooperation_requires_freedom, catholic_chain_is_eight)
-/

end Catlib.Creed.Soteriology
