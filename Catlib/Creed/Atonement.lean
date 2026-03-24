import Catlib.Foundations
import Catlib.Creed.Christology
import Catlib.Creed.OriginalSin

/-!
# CCC §599-618: Why the Cross? The Logic of Atonement

## The source claim

The puzzle: if God is omnipotent and merciful, why can't He simply FORGIVE
sin by divine decree? Why does someone have to die? Isn't the Cross
redundant if God can issue a pardon?

The CCC's answer (drawing on Aquinas ST III q.46-49 and §599-618):

1. Sin is not merely a private offense — it is a RUPTURE in the order of
   justice between God and creation (§615)
2. Mere pardon (bare waiver) addresses the offense but NOT the rupture
3. SATISFACTION restores the order — it repairs what sin broke
4. Only a DIVINE-HUMAN mediator can provide adequate satisfaction:
   divine (the offended party's dignity requires infinite satisfaction) +
   human (humanity must participate in its own restoration)
5. The Cross accomplishes what bare pardon cannot: restoration of ORDER,
   not just cancellation of debt

## The three theories of atonement

The Christian tradition offers three primary models of what the Cross does:

**Satisfaction** (Anselm/Aquinas — CCC's primary model):
Christ restores the order of justice. Sin created a disorder; Christ's
obedient self-offering re-orders the relationship. The key concept is
"making right" what was made wrong — not punishment, but repair.
CCC §615: "By his most holy Passion on the wood of the cross Jesus
merited justification for us."

**Penal substitution** (Calvin — Protestant primary model):
Christ bears the PUNISHMENT that sinners deserve. The key concept is
transferred penalty: God's wrath against sin falls on Christ instead
of on us. This is a judicial model.

**Moral exemplar** (Abelard — liberal Protestant/moral influence):
Christ's death inspires love and repentance. The key concept is
transformation by example: the Cross changes US (our hearts), not
God's disposition toward us.

The CCC uses satisfaction language primarily (§615) but incorporates
elements of all three: Christ "merited justification" (satisfaction),
"died for our sins" (substitutionary language, §601), and his Passion
is a "sacrifice that communicates" grace (transformative, §613).

## Hidden assumptions

1. **Sin creates objective disorder, not just subjective offense.**
   The CCC assumes moral realism (S6): sin damages a real order of
   justice, not just God's feelings. This is Aquinas's framework.

2. **Bare pardon does not repair disorder.** This is the key hidden
   assumption. A king can pardon a criminal, but that doesn't rebuild
   the burned house. Similarly, God can forgive the offense, but the
   rupture in the order of justice remains. This is NOT obvious — a
   divine voluntarist (Ockham) would say God's pardon IS the repair,
   because justice is whatever God declares.

3. **Adequate satisfaction requires proportionality.** The satisfaction
   must be proportional to the offense. Since the offended party is
   infinite (God), finite human satisfaction is inherently inadequate.
   Only someone with infinite dignity (divine nature) can provide
   adequate satisfaction. This is Anselm's argument (Cur Deus Homo).

4. **Humanity must participate in its own restoration.** God could
   repair the order unilaterally, but the CCC insists that genuine
   restoration requires human participation (consistent with T2: grace
   preserves freedom). The mediator must be human so that the human
   race is not merely a passive recipient of repair.

## Modeling choices

1. We model the three atonement theories as three predicates on a
   single sacrificial act. The CCC's position is that satisfaction is
   primary, but incorporates the other two.

2. We model "order of justice" as an opaque predicate. The CCC does
   not give a formal definition of this order — it is borrowed from
   Aquinas's Aristotelian framework. This is structural opacity.

3. We model the adequacy of satisfaction via the mediator's nature
   (divine + human), connecting to Christology.lean's hypostatic union.

4. We model bare pardon as addressing offense but not rupture. This
   is the key structural claim: pardon and satisfaction have different
   TARGETS (offense vs. disorder).
-/

set_option autoImplicit false

namespace Catlib.Creed.Atonement

open Catlib
open Catlib.Creed.Christology
open Catlib.Creed.OriginalSin

-- ============================================================================
-- § 1. Core Types and Predicates
-- ============================================================================

/-- Whether the order of justice between God and creation is intact.
    The "order of justice" is Aquinas's term (ST III q.46 a.3) for the
    right relationship between God and creation. Sin ruptures this order;
    atonement restores it.

    STRUCTURAL OPACITY: The CCC does not define "order of justice"
    formally. It borrows the concept from Aquinas's Aristotelian
    framework. We leave it opaque because the CCC treats it as a
    primitive — it is what sin breaks and what the Cross repairs. -/
opaque orderOfJusticeIntact : Prop

/-- Whether a given act addresses the OFFENSE of sin (the insult or
    affront to God's honor/goodness).
    Addressing the offense = canceling the debt, waiving the penalty.
    This is what forgiveness by decree does. -/
opaque addressesOffense : Prop → Prop

/-- Whether a given act addresses the RUPTURE in the order of justice
    (the objective disorder that sin creates in the God-creation
    relationship).
    Addressing the rupture = restoring the order, repairing the break.
    This is what satisfaction does. -/
opaque addressesRupture : Prop → Prop

/-- Whether a given act is a bare pardon — a divine declaration of
    forgiveness without an accompanying act of restoration.
    A bare pardon says "I forgive you" but does nothing to repair
    the damage. -/
opaque isBarePardon : Prop → Prop

/-- Whether a given act constitutes satisfaction in Aquinas's sense:
    a voluntary offering that restores the order of justice.
    ST III q.48 a.2: Christ's Passion was satisfactory because it was
    a voluntary act of love offered by one whose dignity exceeded the
    disorder caused by all sin. -/
opaque isSatisfaction : Prop → Prop

/-- Whether a given act constitutes penal substitution: the mediator
    bears the punishment that sinners deserve, and God's justice is
    satisfied by the transferred penalty. -/
opaque isPenalSubstitution : Prop → Prop

/-- Whether a given act constitutes a moral exemplar: the act inspires
    love and repentance in those who witness or contemplate it, changing
    their hearts. -/
opaque isMoralExemplar : Prop → Prop

/-- Whether a person can provide ADEQUATE satisfaction — satisfaction
    proportional to the offense against God's infinite dignity.
    Anselm's argument (Cur Deus Homo I.11): since the offended party
    is infinite, only someone with infinite dignity can satisfy. -/
opaque canProvideAdequateSatisfaction : IncarnateSubject → Prop

/-- Whether a person represents humanity in an act (acts ON BEHALF OF
    the human race, not just for themselves).
    Christ's human nature enables him to act as humanity's representative
    (Rom 5:19: "through the obedience of the one man the many will be
    made righteous"). -/
opaque representsHumanity : IncarnateSubject → Prop

/-- The Cross — Christ's sacrificial death, modeled as a proposition. -/
opaque theCross : Prop

-- ============================================================================
-- § 2. Axioms: The Logic of Sin as Rupture
-- ============================================================================

/-- **AXIOM 1 (CCC §615, §1849; ST III q.46 a.3): SIN RUPTURES ORDER.**
    Sin is not merely a private offense against God — it creates an
    objective rupture in the order of justice between God and creation.
    The disorder is REAL, not just a metaphor for hurt feelings.

    This depends on moral realism (S6): if moral facts are objective,
    then sin creates objective disorder, not just subjective displeasure.

    §1849: "Sin is an offense against reason, truth, and right conscience."
    §615: Christ's Passion "merited justification for us" — implying
    there was a real deficit (in justice) that needed to be made up.

    Provenance: [Scripture] Rom 5:12 ("sin entered the world through
    one man, and death through sin"); [Definition] CCC §615, §1849;
    [Philosophy] Aquinas ST III q.46 a.3.
    Denominational scope: ECUMENICAL — all Christians accept that sin
    creates a real problem between God and humanity. The specific model
    of that problem (rupture in order vs. penalty incurred vs. relational
    breach) varies by tradition. -/
axiom sin_ruptures_order :
  ∀ (p : Person) (s : Sin),
    s.action.agent = p →
    ¬ orderOfJusticeIntact

/-- Denominational tag: ecumenical for "sin creates a real problem";
    Catholic for the specific "order of justice" model. -/
def sin_ruptures_order_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "All Christians: sin is a real problem. 'Order of justice' model is Thomistic/Catholic" }

-- ============================================================================
-- § 3. Axioms: Bare Pardon vs. Satisfaction
-- ============================================================================

/-- **AXIOM 2 (implicit in CCC §615; Aquinas ST III q.46 a.3):
    BARE PARDON ADDRESSES OFFENSE ONLY.**
    A divine declaration of forgiveness cancels the debt — it addresses
    the OFFENSE. But it does not restore the ORDER of justice. The
    damage to the God-creation relationship remains.

    Analogy: a judge can dismiss charges against a vandal (pardon the
    offense), but the vandalized building is still damaged. Pardon
    addresses culpability; it does not repair the thing broken.

    HIDDEN ASSUMPTION: This is the deepest hidden assumption in the
    atonement theology. A divine voluntarist (Ockham, Scotus in some
    readings) would deny this: if God's will constitutes justice, then
    God's pardon IS the restoration of order, because order is whatever
    God says it is. The Thomistic position (which the CCC follows)
    treats the order of justice as something even God respects — not
    because God is bound by an external law, but because the order
    reflects God's own nature (wisdom and goodness).

    Provenance: [Philosophy] Aquinas ST III q.46 a.3; implicit in
    CCC §615 ("merited justification" — implying justification needed
    to be merited, not just declared).
    Denominational scope: CATHOLIC (Thomistic). Protestant traditions
    that follow penal substitution have an analogous claim (punishment
    must be borne, not just waived) but frame it differently. -/
axiom bare_pardon_insufficient :
  ∀ (act : Prop),
    isBarePardon act →
    addressesOffense act ∧ ¬ addressesRupture act

/-- Denominational tag: Catholic for the satisfaction framework;
    Protestant penal substitution has an analogous but different claim. -/
def bare_pardon_insufficient_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Catholic/Thomistic: pardon ≠ repair. Protestant PSub: analogous (punishment must be borne)" }

/-- **AXIOM 3 (CCC §615; Aquinas ST III q.48 a.2):
    SATISFACTION ADDRESSES BOTH OFFENSE AND RUPTURE.**
    A voluntary offering of satisfaction both cancels the debt (addresses
    the offense) AND restores the order of justice (addresses the rupture).
    Satisfaction does everything pardon does, plus the repair that pardon
    cannot do.

    §615: "By his most holy Passion on the wood of the cross Jesus
    merited justification for us." "Merited" = earned/restored through
    a positive act, not merely received by decree.

    Provenance: [Definition] CCC §615; [Philosophy] Aquinas ST III q.48 a.2.
    Denominational scope: CATHOLIC — this is the satisfaction theory's
    core claim. -/
axiom satisfaction_addresses_both :
  ∀ (act : Prop),
    isSatisfaction act →
    addressesOffense act ∧ addressesRupture act

/-- Denominational tag: Catholic. -/
def satisfaction_addresses_both_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Catholic: satisfaction restores order AND cancels debt; CCC §615" }

-- ============================================================================
-- § 4. Axioms: The Mediator Must Be Divine AND Human
-- ============================================================================

/-- **AXIOM 4 (CCC §616; Anselm, Cur Deus Homo I.11; ST III q.1 a.2):
    ADEQUATE SATISFACTION REQUIRES A DIVINE NATURE.**
    Because the offended party (God) has infinite dignity, adequate
    satisfaction requires a satisfier with infinite dignity — i.e.,
    a divine nature. No merely human offering can bridge the infinite
    gap between the offense (against infinite goodness) and finite
    human capacity.

    §616: "It is love 'to the end' (Jn 13:1) that confers on Christ's
    sacrifice its value as redemption and reparation, as atonement and
    satisfaction." The "value" comes from WHO offers it — and that value
    must be commensurate with the offense.

    HIDDEN ASSUMPTION: Proportionality of satisfaction. Aquinas and
    Anselm both assume that satisfaction must be proportional to the
    offense. This is a principle of commutative justice borrowed from
    Aristotle. Without this principle, God could accept any human
    offering as sufficient (a view some theologians have held).

    Provenance: [Tradition] Anselm, Cur Deus Homo I.11; Aquinas
    ST III q.1 a.2; [Definition] CCC §616.
    Denominational scope: ECUMENICAL for the claim that Christ's divine
    nature is necessary for salvation. The specific "proportionality"
    argument is Anselmian/Catholic. -/
axiom adequate_satisfaction_requires_divine :
  ∀ (s : IncarnateSubject),
    canProvideAdequateSatisfaction s →
    s.hasNature Nature.divine

/-- Denominational tag: ecumenical for necessity of divine nature;
    proportionality argument is Anselmian/Catholic. -/
def adequate_satisfaction_requires_divine_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "All: Christ's divinity necessary. Proportionality argument is Anselmian" }

/-- **AXIOM 5 (CCC §615; Rom 5:19; ST III q.48 a.2):
    ADEQUATE SATISFACTION REQUIRES A HUMAN NATURE.**
    The mediator must also be human, because humanity must PARTICIPATE
    in its own restoration. God does not save humanity as passive objects
    — genuine restoration requires that a human representative freely
    offers the satisfaction on behalf of the race.

    Rom 5:19: "For just as through the disobedience of the one man the
    many were made sinners, so also through the obedience of the one man
    the many will be made righteous."

    This connects to T2 (grace preserves freedom): even in the act of
    cosmic salvation, human freedom and participation are preserved.
    The human race is not merely repaired FROM OUTSIDE — it participates
    in its own healing through Christ's human nature.

    Provenance: [Scripture] Rom 5:19; [Definition] CCC §615;
    [Philosophy] Aquinas ST III q.48 a.2.
    Denominational scope: ECUMENICAL — all Christians affirm Christ's
    humanity is essential to salvation. -/
axiom adequate_satisfaction_requires_human :
  ∀ (s : IncarnateSubject),
    canProvideAdequateSatisfaction s →
    representsHumanity s →
    s.hasNature Nature.human

/-- Denominational tag: ecumenical. -/
def adequate_satisfaction_requires_human_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "All Christians: Christ's humanity essential to salvation; Rom 5:19" }

-- ============================================================================
-- § 5. Axioms: The Cross as Satisfaction
-- ============================================================================

/-- **AXIOM 6 (CCC §613-615; §601):
    THE CROSS IS SATISFACTION.**
    Christ's death on the Cross IS the act of satisfaction that restores
    the order of justice. It is a voluntary self-offering ("No one takes
    [my life] from me, but I lay it down of my own accord" — Jn 10:18)
    that constitutes satisfaction in Aquinas's sense.

    §613: "Christ's death is both the Paschal sacrifice that accomplishes
    the definitive redemption of men... and the sacrifice of the New
    Covenant."
    §601: "Christ died for our sins in accordance with the Scriptures."

    Provenance: [Scripture] 1 Cor 15:3 (§601); Jn 10:18;
    [Definition] CCC §613-615.
    Denominational scope: ECUMENICAL that the Cross saves. The specific
    mechanism (satisfaction vs. penal substitution vs. moral influence)
    is where traditions differ. -/
axiom cross_is_satisfaction : isSatisfaction theCross

/-- Denominational tag: ecumenical that the Cross saves; the
    satisfaction model is Catholic/Thomistic. -/
def cross_is_satisfaction_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Catholic: Cross is satisfaction (Aquinas). Protestant: Cross is penal substitution (Calvin)" }

/-- **AXIOM 7 (CCC §616; §604):
    CHRIST CAN PROVIDE ADEQUATE SATISFACTION.**
    Because Christ is both divine (infinite dignity) and human
    (represents humanity), he uniquely can provide adequate satisfaction.

    §604: "God proves his love for us in that while we were still
    sinners Christ died for us" (Rom 5:8).
    §616: Christ's sacrifice is UNIVERSAL — "there is not, never has
    been, and never will be a single human being for whom Christ did
    not suffer."

    This is where Christology.lean connects to atonement: the hypostatic
    union is not just a metaphysical fact about Christ — it is what MAKES
    the Cross effective. Without two natures in one person, the Cross
    cannot accomplish what it needs to accomplish.

    Provenance: [Scripture] Rom 5:8 (§604); [Definition] CCC §616.
    Denominational scope: ECUMENICAL — all Christians affirm Christ's
    unique adequacy as savior. -/
axiom christ_can_satisfy :
  canProvideAdequateSatisfaction christ ∧ representsHumanity christ

/-- Denominational tag: ecumenical. -/
def christ_can_satisfy_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "All Christians: Christ uniquely adequate as savior; CCC §616" }

-- ============================================================================
-- § 6. Axiom: The CCC Incorporates All Three Models
-- ============================================================================

/-- **AXIOM 8 (CCC §601, §613, §615):
    THE CROSS INCORPORATES ALL THREE ATONEMENT MODELS.**
    The CCC's position is not exclusively one theory — it uses
    satisfaction as the primary model but incorporates substitutionary
    and exemplar elements.

    - Satisfaction (primary): §615 "merited justification"
    - Substitutionary element: §601 "died for our sins" (ὑπέρ, "on
      behalf of / in place of")
    - Exemplar element: §604 "God proves his love" — the Cross
      manifests love, which transforms those who contemplate it

    This is a MODELING CHOICE: the CCC does not explicitly taxonomize
    these three theories. We identify them in the text and note that
    the CCC incorporates all three while giving primacy to satisfaction.

    Provenance: [Definition] CCC §601, §613, §615.
    Denominational scope: CATHOLIC for the specific synthesis.
    Protestants may prioritize penal substitution over satisfaction. -/
axiom cross_incorporates_all_models :
  isSatisfaction theCross ∧
  isPenalSubstitution theCross ∧
  isMoralExemplar theCross

/-- Denominational tag: Catholic for the synthesis. -/
def cross_incorporates_all_models_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Catholic: satisfaction primary, incorporates substitution + exemplar. Protestant: PSub primary" }

-- ============================================================================
-- § 7. Theorems
-- ============================================================================

/-- **THEOREM: Bare pardon is INSUFFICIENT for full restoration.**
    Under the satisfaction model, bare pardon addresses the offense
    but leaves the rupture in the order of justice unrepaired. The
    Cross is therefore not redundant — it does something pardon cannot.

    This is THE answer to the puzzle "why can't God just forgive?":
    God CAN forgive (address the offense), but forgiveness alone does
    not RESTORE THE ORDER. The Cross restores the order.

    DERIVATION:
    - bare_pardon_insufficient: pardon addresses offense, not rupture
    - satisfaction_addresses_both: satisfaction addresses both
    - ∴ satisfaction does something pardon cannot (addresses rupture)

    Uses: bare_pardon_insufficient, satisfaction_addresses_both. -/
theorem pardon_insufficient_satisfaction_needed
    (pardon_act : Prop)
    (sat_act : Prop)
    (h_pardon : isBarePardon pardon_act)
    (h_sat : isSatisfaction sat_act) :
    -- Pardon does NOT address the rupture
    ¬ addressesRupture pardon_act
    -- BUT satisfaction DOES address the rupture
    ∧ addressesRupture sat_act := by
  exact ⟨(bare_pardon_insufficient pardon_act h_pardon).2,
         (satisfaction_addresses_both sat_act h_sat).2⟩

/-- **THEOREM: The Cross addresses BOTH offense and rupture.**
    Applying satisfaction_addresses_both to theCross (which is
    satisfaction by cross_is_satisfaction).

    Uses: cross_is_satisfaction, satisfaction_addresses_both. -/
theorem cross_addresses_both :
    addressesOffense theCross ∧ addressesRupture theCross := by
  exact satisfaction_addresses_both theCross cross_is_satisfaction

/-- **THEOREM: The Cross does what bare pardon cannot.**
    The Cross addresses the rupture; bare pardon does not.
    Therefore the Cross is NOT redundant — it accomplishes something
    that a bare divine declaration of forgiveness would not.

    This is the formal answer to the title question: "What exactly
    is the Cross doing that a divine declaration of pardon alone
    would not do?" ANSWER: restoring the order of justice.

    Uses: cross_addresses_both, bare_pardon_insufficient. -/
theorem cross_not_redundant
    (pardon_act : Prop)
    (h_pardon : isBarePardon pardon_act) :
    -- The Cross addresses the rupture
    addressesRupture theCross
    -- But bare pardon does NOT
    ∧ ¬ addressesRupture pardon_act := by
  exact ⟨cross_addresses_both.2,
         (bare_pardon_insufficient pardon_act h_pardon).2⟩

/-- **THEOREM: Sin destroys the order of justice.**
    Any sin by any person ruptures the order of justice between God
    and creation. This is what makes sin a cosmic problem, not just
    a private one.

    Uses: sin_ruptures_order. -/
theorem sin_breaks_order
    (p : Person) (s : Sin)
    (h_agent : s.action.agent = p) :
    ¬ orderOfJusticeIntact := by
  exact sin_ruptures_order p s h_agent

/-- **THEOREM: The Cross is simultaneously satisfaction, substitution,
    and moral exemplar.**
    The CCC's position is that the Cross works on all three levels:
    it restores order (satisfaction), it is offered on our behalf
    (substitution), and it inspires transformation (exemplar).

    Uses: cross_incorporates_all_models. -/
theorem cross_works_on_all_three_levels :
    isSatisfaction theCross
    ∧ isPenalSubstitution theCross
    ∧ isMoralExemplar theCross := by
  exact cross_incorporates_all_models

/-- **THEOREM: Christ's divine nature is necessary for the Cross.**
    The Cross provides adequate satisfaction (axiom 7), and adequate
    satisfaction requires a divine nature (axiom 4). Therefore Christ's
    divine nature is necessary for the atonement.

    Uses: christ_can_satisfy, adequate_satisfaction_requires_divine. -/
theorem cross_requires_divine_nature :
    christ.hasNature Nature.divine := by
  exact adequate_satisfaction_requires_divine christ
    christ_can_satisfy.1

/-- **THEOREM: Christ's human nature is necessary for the Cross.**
    The Cross provides adequate satisfaction (axiom 7), Christ represents
    humanity (axiom 7), and adequate satisfaction by a representative
    requires a human nature (axiom 5). Therefore Christ's human nature
    is necessary for the atonement.

    Uses: christ_can_satisfy, adequate_satisfaction_requires_human. -/
theorem cross_requires_human_nature :
    christ.hasNature Nature.human := by
  exact adequate_satisfaction_requires_human christ
    christ_can_satisfy.1 christ_can_satisfy.2

/-- **THEOREM: The Incarnation is necessary for the Atonement.**
    The Cross requires BOTH a divine nature (for adequate satisfaction)
    AND a human nature (for representative participation). Therefore
    the mediator must be both God and man — which is exactly what
    the hypostatic union (Christology.lean) asserts.

    This is why the Incarnation and the Cross are inseparable: you
    cannot have effective atonement without a divine-human mediator,
    and you cannot have a divine-human mediator without the Incarnation.

    Uses: cross_requires_divine_nature, cross_requires_human_nature. -/
theorem incarnation_necessary_for_atonement :
    christ.hasNature Nature.divine ∧ christ.hasNature Nature.human := by
  exact ⟨cross_requires_divine_nature, cross_requires_human_nature⟩

/-- **THEOREM: The hypostatic union grounds the atonement.**
    The hypostatic union from Christology.lean asserts exactly what
    the atonement requires: Christ has both natures. This shows that
    the Christological dogma is not just metaphysics — it is the
    necessary precondition for soteriology.

    Uses: hypostatic_union (from Christology.lean). -/
theorem hypostatic_union_grounds_atonement :
    christ.hasNature Nature.divine ∧ christ.hasNature Nature.human :=
  ⟨hypostatic_union.2.1, hypostatic_union.2.2⟩

/-- **THEOREM: The satisfaction model shows why the Cross restores
    what pardon alone cannot restore.**
    This is the SUMMARY THEOREM: it combines the key results into
    a single statement. Under the Catholic satisfaction model:
    1. The Cross is an act of satisfaction
    2. Satisfaction addresses both offense and rupture
    3. Bare pardon addresses only the offense
    4. Therefore the Cross is necessary (not redundant)
    5. The mediator must be both divine and human

    Uses: cross_is_satisfaction, cross_addresses_both,
    incarnation_necessary_for_atonement. -/
theorem atonement_summary :
    -- The Cross is satisfaction
    isSatisfaction theCross
    -- The Cross addresses both offense and rupture
    ∧ (addressesOffense theCross ∧ addressesRupture theCross)
    -- The mediator has both natures
    ∧ (christ.hasNature Nature.divine ∧ christ.hasNature Nature.human) := by
  exact ⟨cross_is_satisfaction,
         cross_addresses_both,
         incarnation_necessary_for_atonement⟩

-- ============================================================================
-- § 8. Connection to OriginalSin.lean: What the Cross is Healing
-- ============================================================================

/-!
## The wound and the repair

OriginalSin.lean formalizes WHAT went wrong: the Fall wounded human
nature, making the supernatural end unreachable (the_fall). This file
formalizes HOW it is repaired: through satisfaction, not bare pardon.

The connection:
- OriginalSin.lean: the Fall creates a wound (natureIsWounded)
- This file: the wound is specifically a rupture in the order of justice
- OriginalSin.lean: grace heals the wound (grace_is_the_healing)
- This file: the Cross IS the act that makes that healing possible

The Cross is not just any act of grace — it is the specific act of
satisfaction that restores the order of justice, which in turn makes
all subsequent grace possible. §613: Christ's death is "the sacrifice
of the New Covenant" — the covenant repair that enables the flow of
grace through the sacraments.
-/

/-- **THEOREM: The Fall grounds the NEED for the Cross.**
    original sin (the_fall) shows human nature is wounded and the
    supernatural end is unreachable. The Cross provides the satisfaction
    that addresses this rupture. Without the Fall, there would be
    no rupture to repair.

    Uses: the_fall (from OriginalSin.lean), cross_addresses_both. -/
theorem fall_grounds_need_for_cross
    (p : Person)
    (h_intellect : p.hasIntellect = true) :
    -- The wound exists (from OriginalSin.lean)
    natureIsWounded p
    -- AND the Cross addresses the rupture
    ∧ addressesRupture theCross := by
  exact ⟨(the_fall p h_intellect).1, cross_addresses_both.2⟩

-- ============================================================================
-- § 9. Denominational Comparison: The Three Models
-- ============================================================================

/-!
## Where traditions diverge

The three atonement models correspond roughly to three traditions:

```
Model:           SATISFACTION     PENAL SUBSTITUTION    MORAL EXEMPLAR
Primary in:      Catholic         Reformed/Calvinist    Liberal Protestant
Key concept:     Restores order   Bears punishment      Inspires love
Key metaphor:    Repair           Court/Judge           Teacher/Example
What changes:    The order         God's wrath/justice   The human heart
Christ's role:   Mediator/Priest  Substitute/Victim     Example/Revealer
CCC language:    §615 "merited"   §601 "died for"       §604 "proves love"
```

### Why the CCC prefers satisfaction over penal substitution

The CCC never uses the phrase "penal substitution." It uses "died for
our sins" (§601, quoting 1 Cor 15:3) which has substitutionary overtones,
but the primary framework is satisfaction (§615 "merited justification").

The theological reason: under penal substitution, God's justice is
satisfied by PUNISHMENT. Under satisfaction, God's justice is satisfied
by LOVE ("it is love 'to the end' that confers on Christ's sacrifice
its value" — §616). The Catholic model is that the Cross works because
of Christ's obedient love, not because God needed someone to punish.

### The Protestant objection to satisfaction

Some Protestant theologians argue that the satisfaction model is too
"transactional" — it makes salvation sound like a debt repayment
rather than a relationship restored. The penal substitution model,
they argue, better captures the scandal of the Cross: God Himself
bears the consequence of human sin.

### The moral exemplar's insufficiency (Catholic view)

The CCC would consider the moral exemplar model INSUFFICIENT on its
own. If the Cross only inspires, it does not actually repair anything.
You can be deeply moved by an example without the order of justice
being restored. The exemplar model works as a SUPPLEMENT to satisfaction
(the Cross inspires because it IS the act of cosmic repair), not as
a standalone theory.
-/

/-- The Protestant penal substitution model as a denominational
    alternative. Under this model, the Cross primarily bears
    punishment rather than restoring order. -/
def protestantPenalSubstitution : DenominationalTag :=
  { acceptedBy := [Denomination.reformed],
    note := "Reformed: Cross primarily bears punishment (penal substitution); Calvin, Institutes II.16" }

/-- The moral exemplar model as a denominational alternative. -/
def moralExemplarModel : DenominationalTag :=
  { acceptedBy := [],
    note := "Liberal Protestant: Cross primarily inspires (moral influence); Abelard. CCC considers this insufficient alone" }

-- ============================================================================
-- § 10. Summary
-- ============================================================================

/-!
## Summary: What the formalization reveals

### The answer to the puzzle

**Why can't God just forgive?** Because sin creates TWO problems:
1. An **offense** against God (can be addressed by pardon)
2. A **rupture** in the order of justice (CANNOT be addressed by pardon alone)

Bare pardon addresses (1) but not (2). The Cross, as an act of
satisfaction, addresses BOTH. Therefore the Cross is NOT redundant —
it does something that bare pardon cannot do: it restores the ORDER,
not just the relationship.

### The load-bearing axiom

The deepest hidden assumption is **bare_pardon_insufficient**: the claim
that pardon addresses offense but NOT rupture. This is where a divine
voluntarist would object: if justice is whatever God says it is, then
God's pardon IS the restoration of order. The Thomistic framework
(which the CCC follows) treats the order of justice as reflecting
God's nature, not God's arbitrary will — and therefore not something
even God "bypasses" by decree.

### The Christological connection

The formalization shows that the hypostatic union (Christology.lean) is
not just a metaphysical curiosity — it is what MAKES the atonement
possible. Without two natures in one person:
- A merely divine satisfier could repair the order but humanity would
  be passive (violates T2: grace preserves freedom)
- A merely human satisfier could represent humanity but lacks infinite
  dignity for adequate satisfaction
- ONLY a divine-human person can do both

### Connection to other formalizations

- **Christology.lean**: hypostatic_union provides the two-nature mediator
  that the atonement requires
- **OriginalSin.lean**: the_fall provides the wound that the atonement heals
- **Soteriology.lean**: the 8-step salvation chain presupposes what this
  file formalizes (Christ's salvific work is step 3's content)
- **Axioms.lean**: S5 (sin separates) is the base-level claim that sin
  creates a real break; this file models the SPECIFIC kind of break
  (rupture in order) and the SPECIFIC kind of repair (satisfaction)

### Axiom count for this file: 8

Local axioms: 8 (sin_ruptures_order, bare_pardon_insufficient,
satisfaction_addresses_both, adequate_satisfaction_requires_divine,
adequate_satisfaction_requires_human, cross_is_satisfaction,
christ_can_satisfy, cross_incorporates_all_models)

Theorems: 11 (pardon_insufficient_satisfaction_needed,
cross_addresses_both, cross_not_redundant, sin_breaks_order,
cross_works_on_all_three_levels, cross_requires_divine_nature,
cross_requires_human_nature, incarnation_necessary_for_atonement,
hypostatic_union_grounds_atonement, atonement_summary,
fall_grounds_need_for_cross)

Opaques: 10 (orderOfJusticeIntact, addressesOffense, addressesRupture,
isBarePardon, isSatisfaction, isPenalSubstitution, isMoralExemplar,
canProvideAdequateSatisfaction, representsHumanity, theCross)
-/

end Catlib.Creed.Atonement
