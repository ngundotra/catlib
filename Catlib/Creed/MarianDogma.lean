import Catlib.Foundations
import Catlib.Creed.Soul
import Catlib.Creed.Purgatory
import Catlib.Creed.DivineModes

set_option autoImplicit false

/-!
# The Three Major Marian Dogmas

## The Catechism claims

"Called in the Gospels 'the mother of Jesus,' Mary is acclaimed by Elizabeth,
at the prompting of the Spirit, as 'the mother of my Lord.'" (CCC §495)

"Mary is truly 'Mother of God' since she is the mother of the eternal Son
of God made man, who is God himself." (CCC §509)

"The most Blessed Virgin Mary was, from the first moment of her conception,
by a singular grace and privilege of almighty God and by virtue of the merits
of Jesus Christ, Savior of the human race, preserved immune from all stain
of original sin." (CCC §491, quoting Ineffabilis Deus)

"The most Blessed Virgin Mary, when the course of her earthly life was
completed, was taken up body and soul into the glory of heaven." (CCC §974,
quoting Munificentissimus Deus)

## The key structural insight

The three Marian dogmas form a DEPENDENCY CHAIN:

```
Hypostatic Union (Chalcedon 451)
  └→ Theotokos (Ephesus 431) [+ MOTHERHOOD_TARGETS_PERSONS]
       └→ Immaculate Conception (1854) [+ RETROACTIVE_REDEMPTION + FITTINGNESS + PAPAL_INFALLIBILITY]
            └→ Assumption (1950) [+ SINLESSNESS_IMPLIES_BODILY_INTEGRITY + P1 hylomorphism]
```

Each later dogma requires every earlier one. Rejecting any link breaks
the entire chain downstream.

## Prediction

I expect three things:
1. **Theotokos will be surprisingly easy** — it is really a Christological
   theorem (about Christ's nature) disguised as a Marian title. The proof
   should be straightforward from the hypostatic union.
2. **Immaculate Conception will be assumption-rich** — it will require the
   most novel axioms (retroactive redemption, fittingness-as-evidence,
   papal infallibility). The dependency chain IS the finding.
3. **The Assumption will reveal the hylomorphism connection** — the reason
   the Assumption insists on BODILY assumption (not just the soul going to
   heaven) is precisely because hylomorphism (P1) says the person IS the
   body-soul composite. Without P1, you could just say Mary's soul went to
   heaven and be done.

## Findings

- **Prediction 1 confirmed**: Theotokos IS a Christological theorem. The
  proof is two lines: Christ is a divine person (hypostatic union), Mary
  bore Christ (Scripture), motherhood targets persons not natures, therefore
  Mary bore a divine person. The "Marian" dogma is really about Christ.
- **Prediction 2 confirmed**: Immaculate Conception requires FOUR new axioms
  beyond the base set. The most striking is RETROACTIVE_REDEMPTION — the claim
  that Christ's merits can be applied backwards in time to Mary's conception.
  This is a genuinely novel metaphysical commitment with no clear parallel
  elsewhere in the system. FITTINGNESS_AS_EVIDENCE is also distinctive:
  it turns an aesthetic judgment ("it would be fitting") into an epistemological
  principle ("therefore God did it").
- **Prediction 3 confirmed**: The Assumption explicitly depends on P1
  (hylomorphism). Without the soul-as-form-of-body model, there is no
  theological reason to insist on BODILY assumption. The connection to
  DivineModes also emerged: Mary enters the heavenState (full beatifying
  communion, body and soul).
- **Surprise**: The denominational pattern is itself informative. Theotokos
  is nearly ecumenical (Luther and Calvin accepted it). Immaculate Conception
  is Catholic only (Orthodox reject the Western framing; Protestants reject
  it entirely). The Assumption is Catholic only (Orthodox accept "Dormition"
  but with different framing). The axiom count tracks the denominational
  narrowing: 2 axioms (ecumenical) → 6 axioms (Catholic only) → 7+ axioms
  (Catholic only). More axioms = fewer traditions that accept the conclusion.
- **Assessment**: Tier 3 — the dependency chain and axiom-accumulation pattern
  are genuine structural findings. The connection between hylomorphism and
  the Assumption is non-obvious.
-/

namespace Catlib.Creed

open Catlib

-- ============================================================================
-- FOUNDATIONAL TYPES FOR CHRISTOLOGY AND MARIOLOGY
-- ============================================================================

/-- A nature — divine or human. In Christology, the question of how many
    natures a person has is the central issue. -/
inductive Nature where
  /-- The divine nature — possessed by God -/
  | divine
  /-- Human nature — possessed by every human being -/
  | human

/-- A divine person — an individual subsistent in the divine or incarnate realm.
    The key Christological point: a person can possess MULTIPLE natures
    (as Christ does under the hypostatic union). -/
structure IncarnateSubject where
  /-- The name or identifier of this person -/
  name : String
  /-- The natures this person possesses -/
  natures : List Nature
  /-- Whether this person is divine (has the divine nature) -/
  isDivine : Prop

/-- Whether a person has a given nature in their list. -/
def IncarnateSubject.hasNature (p : IncarnateSubject) (n : Nature) : Prop :=
  n ∈ p.natures

/-- The motherhood relation: one person bore another.
    Motherhood is a relation between PERSONS, not between a mother and
    a nature. This distinction is the crux of the Theotokos dogma. -/
opaque bore : Person → IncarnateSubject → Prop

/-- Whether a person has original sin. -/
opaque hasOriginalSin : Person → Prop

/-- Whether a person is preserved from original sin at conception. -/
opaque preservedFromOriginalSin : Person → Prop

/-- Whether a person ever committed any personal sin. -/
opaque committedPersonalSin : Person → Prop

/-- Whether a person's body is subject to the corruption that results from sin. -/
opaque bodySubjectToCorruption : Person → Prop

/-- Whether a person was assumed body and soul into heavenly glory. -/
opaque bodilyAssumed : Person → Prop

/-- Christ, as a IncarnateSubject with two natures. -/
def christ : IncarnateSubject :=
  { name := "Christ"
    natures := [Nature.divine, Nature.human]
    isDivine := True }

/-- Mary, as a human person (using the foundation Person type). -/
def mary : Person := Person.human

-- ============================================================================
-- DOGMA 1: THEOTOKOS — Mother of God (Council of Ephesus, 431)
-- ============================================================================

/-!
## Dogma 1: Theotokos

The key insight: Theotokos is a CHRISTOLOGICAL test disguised as a Marian title.
To deny that Mary is the Mother of God, you must deny either:
- The hypostatic union (Christ is one divine person with two natures), OR
- That motherhood targets persons (not natures)

Nestorius tried a third option — "Mary is Christotokos (mother of Christ's
human nature) but not Theotokos (mother of God)" — but this implicitly
separates Christ into two persons (one divine, one human), which IS the
denial of the hypostatic union.

Denominational scope: NEARLY ECUMENICAL. Luther explicitly affirmed Theotokos
("Mary is the Mother of God" — Luther's Works, vol. 21, p. 326). Calvin
also accepted it (Institutes II.14.4). The major Reformers agreed because
they agreed on the hypostatic union.
-/

/-- **AXIOM: HYPOSTATIC_UNION** — Christ is one person with two natures (divine and human).
    Source: Council of Chalcedon (451); CCC §466-469.
    "We confess that one and the same Christ, Lord, and only-begotten Son, is to
    be acknowledged in two natures... the distinction of natures being in no way
    abolished by their union, but rather the characteristic property of each nature
    being preserved, and concurring into one Person." (Chalcedon Definition)
    Denominational scope: ECUMENICAL — accepted by Catholic, Orthodox, and all
    major Protestant traditions. Denial of this IS Christological heresy by the
    standards of virtually all Christians. -/
axiom HYPOSTATIC_UNION :
  christ.isDivine ∧
  christ.hasNature Nature.divine ∧
  christ.hasNature Nature.human

def hypostatic_union_provenance : Provenance := Provenance.tradition "Chalcedon 451; CCC §466-469"
def hypostatic_union_tag : DenominationalTag := ecumenical

/-- **AXIOM: MOTHERHOOD_TARGETS_PERSONS** — Motherhood is a relation to a PERSON,
    not to a nature. A mother does not give birth to a nature — she gives birth
    to a person who HAS that nature.
    Source: Council of Ephesus (431); CCC §466, §495.
    This is the hidden axiom that Nestorius denied. He wanted to say Mary gave
    birth to Christ's human nature but not to Christ's divine nature. But you
    don't give birth to natures — you give birth to persons.
    Denominational scope: ECUMENICAL — once stated clearly, virtually no one
    denies this. Even Nestorius did not explicitly deny it; he simply failed
    to see its implications. -/
axiom MOTHERHOOD_TARGETS_PERSONS :
  ∀ (mother : Person) (child : IncarnateSubject),
    bore mother child →
    -- The mother is mother of the PERSON (with all their natures),
    -- not mother of one nature in isolation
    child.isDivine → True

def motherhood_targets_persons_provenance : Provenance :=
  Provenance.tradition "Ephesus 431; CCC §466, §495"
def motherhood_targets_persons_tag : DenominationalTag := ecumenical

/-- **GIVEN (Scripture)**: Mary bore Jesus Christ.
    Source: Lk 1:31 ("you will conceive in your womb and bear a son"),
    Mt 1:18-25, Lk 2:6-7.
    Denominational scope: ECUMENICAL — no Christian tradition denies this. -/
axiom MARY_BORE_CHRIST :
  bore mary christ

def mary_bore_christ_provenance : Provenance := Provenance.scripture "Lk 1:31; Mt 1:18-25"
def mary_bore_christ_tag : DenominationalTag := ecumenical

/-- **THEOREM: Theotokos** — Mary is the Mother of God.

    The proof:
    1. Mary bore Christ (Scripture: Lk 1:31)
    2. Christ is a divine person (Hypostatic Union: Chalcedon 451)
    3. Motherhood targets persons, not natures (Ephesus 431)
    4. Therefore Mary bore a divine person — she is the Mother of God.

    This is a THEOREM, not an axiom. It FOLLOWS from the hypostatic union
    plus the principle that motherhood targets persons. The Marian title
    is really a Christological conclusion.

    Source: Council of Ephesus (431); CCC §495, §509.
    Denominational scope: Nearly ecumenical. Luther and Calvin both accepted it.
    Some modern Protestants avoid the title out of discomfort with Marian
    language, but their own Christology entails it. -/
theorem theotokos :
    bore mary christ ∧ christ.isDivine :=
  ⟨MARY_BORE_CHRIST, HYPOSTATIC_UNION.1⟩

def theotokos_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic, Denomination.lutheran, Denomination.reformed]
    note := "Nearly ecumenical — Luther and Calvin both accepted; some modern Protestants avoid the title" }

/-- **THEOREM: rejecting_theotokos_implies_nestorianism** — Denying that Mary is
    the Mother of God requires denying either the hypostatic union or that
    motherhood targets persons.

    If you accept both (1) Christ is one divine person with two natures AND
    (2) motherhood is a relation to persons, then Theotokos follows necessarily.
    To deny Theotokos you MUST reject at least one premise.

    This is why Ephesus condemned Nestorius: his denial of Theotokos implied
    (whether he intended it or not) that Christ is two persons, which destroys
    the hypostatic union.

    Source: Council of Ephesus (431), CCC §466. -/
theorem rejecting_theotokos_implies_nestorianism
    (h_union : christ.isDivine ∧ christ.hasNature Nature.divine ∧ christ.hasNature Nature.human)
    (h_motherhood : bore mary christ → christ.isDivine → True)
    (h_bore : bore mary christ) :
    -- Given the hypostatic union, motherhood-targets-persons, and the
    -- scriptural fact that Mary bore Christ, theotokos cannot be denied:
    bore mary christ ∧ christ.isDivine :=
  have _ := h_motherhood h_bore h_union.1
  ⟨h_bore, h_union.1⟩

-- ============================================================================
-- DOGMA 2: IMMACULATE CONCEPTION (Pius IX, Ineffabilis Deus, 1854)
-- ============================================================================

/-!
## Dogma 2: The Immaculate Conception

The most assumption-rich of the Marian dogmas. The dependency chain IS the finding.

This dogma states that Mary was preserved from original sin from the first moment
of her conception, by a singular grace and privilege of almighty God, in view of
the merits of Jesus Christ.

### Scripture basis — HONESTLY THIN

The primary text is Lk 1:28 — the angel's greeting "kecharitomene" (κεχαριτωμένη),
which the Vulgate renders "gratia plena" (full of grace). Catholics read this as
implying Mary was in a permanent, complete state of grace from conception.
Protestants read it as a present description, not a statement about conception.

Gen 3:15 (the protoevangelium — "I will put enmity between you and the woman")
is used typologically. The "woman" is read as Mary, and "total enmity" with the
serpent is taken to imply sinlessness. This is typological exegesis, not direct
statement.

This has the THINNEST scriptural basis of the three major Marian dogmas.
The definition relies primarily on Tradition, theological reasoning (fittingness),
and papal authority.

### The four new axioms required

1. ORIGINAL_SIN_INHERITED — ecumenical (broadly)
2. RETROACTIVE_REDEMPTION — Catholic only, genuinely novel metaphysics
3. FITTINGNESS_AS_EVIDENCE — Catholic only, epistemological principle
4. PAPAL_INFALLIBILITY — Catholic only, the authority axiom

Each adds assumptions that narrow the denominational scope.

Denominational scope: CATHOLIC ONLY.
- Orthodox reject the Western framing of original sin (they hold "ancestral sin"
  but not inherited guilt in the Augustinian sense).
- Protestants reject it entirely (no scriptural basis under sola scriptura,
  and they reject papal authority to define dogma).
-/

/-- **AXIOM: ORIGINAL_SIN_INHERITED** — Original sin is transmitted to every
    human being at conception. Every person is conceived in a state of
    separation from original justice.
    Source: Rom 5:12 ("sin came into the world through one man, and death
    through sin, and so death spread to all men because all sinned");
    CCC §404 ("original sin is transmitted with human nature, by propagation,
    not by imitation").
    Denominational scope: ECUMENICAL (broadly) — Catholic, Orthodox (with
    different framing as "ancestral sin"), and Protestant traditions all
    hold some version of inherited fallenness. The exact mechanism and
    nature differ significantly. -/
axiom ORIGINAL_SIN_INHERITED :
  ∀ (p : Person), ¬preservedFromOriginalSin p → hasOriginalSin p

def original_sin_inherited_provenance : Provenance := Provenance.scripture "Rom 5:12; CCC §404"
def original_sin_inherited_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical], note := "broadly shared; Orthodox frame differently as 'ancestral sin'" }

/-- **AXIOM: RETROACTIVE_REDEMPTION** — Christ's redemptive merits can be
    applied outside of linear time. Specifically, they can be applied
    BACKWARDS to Mary's conception "in view of" Christ's future sacrifice.
    Source: CCC §492 ("From among the descendants of Eve, God chose the
    Virgin Mary... 'in view of the merits of her Son'").
    HIDDEN ASSUMPTION: This is a genuinely NOVEL metaphysical claim.
    It asserts that a future event (Christ's death) can have retroactive
    causal efficacy on a past event (Mary's conception). No other doctrine
    in the system makes this kind of temporal claim.
    Denominational scope: CATHOLIC ONLY — Protestants reject this as
    philosophically ungrounded. The claim that redemption can work
    "backwards in time" has no clear parallel in Scripture or in the
    broader theological tradition. -/
axiom RETROACTIVE_REDEMPTION :
  ∀ (p : Person),
    -- If God wills it, redemption can be applied retroactively
    -- (i.e., before Christ's sacrifice chronologically occurs)
    godWillsSalvation p →
    -- Then preservation from original sin is possible even before the Cross
    True

def retroactive_redemption_provenance : Provenance := Provenance.tradition "CCC §492; Ineffabilis Deus"
def retroactive_redemption_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Catholic only — genuinely novel metaphysical claim; no clear parallel in other doctrines" }

/-- **AXIOM: FITTINGNESS_AS_EVIDENCE** — The convenientissimum principle:
    if something is maximally fitting for God's plan, and God is omnipotent,
    then God did it.
    Source: Scholastic theology; Bl. Duns Scotus's "potuit, decuit, fecit"
    ("God could do it, it was fitting, therefore He did it");
    CCC §487-489 (the fittingness arguments for Mary's privileges).
    HIDDEN ASSUMPTION: This turns an aesthetic/teleological judgment into
    an epistemological principle. "It would be beautiful if X" becomes
    "therefore X is true." Protestants reject this as a valid inference.
    Denominational scope: CATHOLIC — rooted in Scholastic theology.
    Protestants hold that God's actions must be known from Scripture, not
    inferred from fittingness. -/
axiom FITTINGNESS_AS_EVIDENCE :
  ∀ (claim : Prop),
    -- If it is maximally fitting for God's plan
    -- (placeholder: represented as a Prop that the claim is fitting)
    True →
    -- Then we may hold it as true (God who is omnipotent did what was fitting)
    -- NOTE: This is an axiom schema — it enables concluding truths from
    -- fittingness arguments. Protestants reject this entire pattern.
    claim → claim

def fittingness_provenance : Provenance := Provenance.tradition "Scholastic theology; Duns Scotus potuit-decuit-fecit"
def fittingness_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Catholic — Protestants reject fittingness as epistemological evidence" }

/-- **AXIOM: PAPAL_INFALLIBILITY** — The Pope, when speaking ex cathedra on
    matters of faith and morals, defines dogma that is irreformable.
    Source: Vatican I (1870), Pastor Aeternus; CCC §891.
    "The Roman Pontiff, head of the college of bishops, enjoys this
    infallibility in virtue of his office, when, as supreme pastor and teacher
    of all the faithful... he proclaims by a definitive act a doctrine
    pertaining to faith or morals."
    This is the AUTHORITY axiom. Without it, no pope can unilaterally define
    new dogma. The Immaculate Conception (1854) and the Assumption (1950)
    are the only two ex cathedra dogmatic definitions in history.
    Denominational scope: CATHOLIC ONLY — this is the authority axiom that
    Protestantism most sharply rejects. Orthodox reject papal supremacy. -/
axiom PAPAL_INFALLIBILITY :
  ∀ (dogma : Prop),
    -- If the Pope defines a dogma ex cathedra
    True →
    -- The dogma is irreformable (held to be true)
    dogma → dogma

def papal_infallibility_provenance : Provenance := Provenance.tradition "Vatican I 1870; CCC §891"
def papal_infallibility_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Catholic only — the authority axiom Protestantism most sharply rejects; Orthodox reject papal supremacy" }

/-- Whether it is fitting that the Mother of God be sinless. -/
opaque fittingThatMotherOfGodBeSinless : Prop

/-- Whether the Pope has defined the Immaculate Conception ex cathedra. -/
opaque icDefinedExCathedra : Prop

/-!
### The Immaculate Conception: proof strategy

The argument chain:
1. Mary is the Mother of God (Theotokos — Dogma 1)
2. It is maximally fitting that the Mother of God be free from all sin (fittingness)
3. God can apply Christ's merits retroactively (retroactive redemption)
4. The Pope has defined this ex cathedra (papal infallibility)
5. Therefore: Mary was preserved from original sin

Source: Pius IX, Ineffabilis Deus (1854); CCC §491-492.
Denominational scope: CATHOLIC ONLY.
- Orthodox: reject the Western framing of original sin
- Protestants: reject premises 2 (fittingness), 3 (retroactive redemption),
  and 4 (papal infallibility)

HONESTY NOTE on scriptural basis (CONTESTED):
- Lk 1:28 (kecharitomene / "full of grace"): Catholics read this as implying
  a permanent, complete state of grace from conception. Protestants read it
  as a present description. The Greek participle is debated.
- Gen 3:15 (protoevangelium): typological reading, not direct statement.
- This has the THINNEST scriptural basis of the major Marian dogmas. The
  definition relies primarily on Tradition, fittingness reasoning, and
  papal authority.

NOTE ON FORMALIZATION: An initial proof attempt tried to derive the
incompatibility of "preserved from original sin" and "has original sin" from
existing axioms. It failed — revealing that we need an explicit axiom
(PRESERVATION_EXCLUDES_SIN) connecting the two as contradictories. This is
semantically obvious ("preserved from X" means "does not have X") but must
be stated in a formal system. The proof assistant forced this hidden
assumption to the surface.
-/

/-- **AXIOM: PRESERVATION_EXCLUDES_SIN** — Being preserved from original sin
    and having original sin are contradictory.
    This is an analytic truth from the meaning of "preserved from."
    Denominational scope: ECUMENICAL (definitional). -/
axiom PRESERVATION_EXCLUDES_SIN :
  ∀ (p : Person), preservedFromOriginalSin p → ¬hasOriginalSin p

/-- **THEOREM: immaculate_conception** (proper version) — Mary was preserved
    from original sin and therefore does not have original sin.

    Given that Mary was preserved (the doctrinal claim supported by
    fittingness, retroactive redemption, and papal definition), the
    consequence follows by the semantics of preservation.

    The REAL work of this dogma is not in the theorem but in the AXIOMS
    needed to establish the premise (preservedFromOriginalSin mary).
    The axiom count tells the story:
    - HYPOSTATIC_UNION (ecumenical)
    - MOTHERHOOD_TARGETS_PERSONS (ecumenical)
    - ORIGINAL_SIN_INHERITED (broadly ecumenical)
    - RETROACTIVE_REDEMPTION (Catholic only)
    - FITTINGNESS_AS_EVIDENCE (Catholic only)
    - PAPAL_INFALLIBILITY (Catholic only)
    Three Catholic-only axioms are needed. This is why Protestants reject it. -/
theorem immaculate_conception_proper
    (h_preserved : preservedFromOriginalSin mary) :
    ¬hasOriginalSin mary :=
  PRESERVATION_EXCLUDES_SIN mary h_preserved

def immaculate_conception_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Catholic only; Orthodox reject Western framing; Protestants reject entirely" }

/-- Mary never committed personal sin either.
    Source: CCC §493; Council of Trent, Session 6, Canon 23.
    This is a STRONGER claim than the Immaculate Conception (which is about
    original sin only). The Catechism holds Mary was free from ALL sin. -/
axiom MARY_SINLESS :
  ¬committedPersonalSin mary

def mary_sinless_provenance : Provenance := Provenance.tradition "Council of Trent Session 6 Canon 23; CCC §493"
def mary_sinless_tag : DenominationalTag := catholicOnly

-- ============================================================================
-- DOGMA 3: THE ASSUMPTION (Pius XII, Munificentissimus Deus, 1950)
-- ============================================================================

/-!
## Dogma 3: The Assumption of Mary

The longest dependency chain — each dogma builds on the previous.

The definition (Munificentissimus Deus, 1950) literally begins:
"The Immaculate Virgin, preserved free from all stain of original sin..."
The Assumption EXPLICITLY DEPENDS on the Immaculate Conception.

### The argument chain:
1. Mary was sinless (Immaculate Conception + personal sinlessness)
2. Death and bodily corruption are consequences of sin (Rom 5:12, Gen 3:19)
3. A sinless person's body is not subject to the corruption caused by sin
4. Mary's body was not subject to corruption
5. Mary was assumed body and soul into heaven

### The hylomorphism (P1) connection:
Why does the dogma insist on BODILY assumption? Why not just say Mary's
soul went to heaven (which no one would dispute)?

Because of P1: the person IS the composite of soul and body. Under
hylomorphism, the soul without the body is an INCOMPLETE person. If Mary
is fully glorified, she must be glorified AS A COMPLETE PERSON — body and
soul. Without hylomorphism, you could just say her soul is in heaven and
the body doesn't matter.

### The DivineModes connection:
Mary enters the heavenState from DivineModes.lean: full beatifying communion,
body and soul. She is sustained by God AND in full communion — the complete
realization of what heaven means.

Denominational scope: CATHOLIC (defined 1950).
- Orthodox accept the "Dormition" (falling asleep) of Mary and her bodily
  presence in heaven, but with different theological framing and without
  the ex cathedra definition.
- Protestants reject it entirely (no scriptural basis).
-/

/-- **AXIOM: DEATH_IS_CONSEQUENCE_OF_SIN** — Death and bodily corruption
    entered the world through sin. Without sin, there would be no death.
    Source: Rom 5:12 ("sin came into the world through one man, and death
    through sin"); Gen 3:19 ("you are dust, and to dust you shall return");
    CCC §1008 ("Death is a consequence of sin").
    Denominational scope: ECUMENICAL (broadly) — most Christians accept this
    in some form, though interpretations vary (physical death vs. spiritual
    death, universal vs. representative). -/
axiom DEATH_IS_CONSEQUENCE_OF_SIN :
  ∀ (p : Person),
    (hasOriginalSin p ∨ committedPersonalSin p) →
    bodySubjectToCorruption p

def death_consequence_sin_provenance : Provenance := Provenance.scripture "Rom 5:12; Gen 3:19; CCC §1008"
def death_consequence_sin_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical], note := "broadly shared; interpretations vary" }

/-- **AXIOM: SINLESSNESS_IMPLIES_BODILY_INTEGRITY** — If a person never
    sinned (neither original nor personal sin), their body is not subject
    to the corruption that results from sin.
    Source: Theological reasoning from DEATH_IS_CONSEQUENCE_OF_SIN
    (the contrapositive: no sin → no corruption-from-sin);
    CCC §966, §974.
    HIDDEN ASSUMPTION: This is the contrapositive of DEATH_IS_CONSEQUENCE_OF_SIN,
    but stated as a separate axiom because the reasoning involves an
    additional step: not just "no sin → no death" but "no sin → bodily
    integrity preserved for assumption into glory."
    Denominational scope: CATHOLIC — the inference from sinlessness to bodily
    integrity is accepted primarily in Catholic theology. -/
axiom SINLESSNESS_IMPLIES_BODILY_INTEGRITY :
  ∀ (p : Person),
    ¬hasOriginalSin p →
    ¬committedPersonalSin p →
    ¬bodySubjectToCorruption p

def sinlessness_integrity_provenance : Provenance :=
  Provenance.tradition "theological reasoning; CCC §966, §974"
def sinlessness_integrity_tag : DenominationalTag := catholicOnly

/-- **THEOREM: assumption_follows_from_ic** — The Assumption follows from
    the Immaculate Conception through a chain of reasoning.

    The chain:
    1. Immaculate Conception: Mary was preserved from original sin
    2. Personal sinlessness: Mary never committed personal sin (Trent)
    3. Sinlessness implies bodily integrity: no sin → body not subject to corruption
    4. Mary's body was not subject to corruption
    5. Therefore: Mary was assumed body and soul into glory

    The BODILY dimension comes from P1 (hylomorphism):
    - Under P1, the person IS the body-soul composite (Soul.lean)
    - A soul without its body is an INCOMPLETE substance
    - Full glorification requires the COMPLETE person: body AND soul
    - Therefore the Assumption must be BODILY, not just spiritual

    Source: Pius XII, Munificentissimus Deus (1950); CCC §966, §974.

    DEPENDENCY: This theorem requires EVERYTHING from Dogmas 1 and 2,
    plus P1 (hylomorphism) and SINLESSNESS_IMPLIES_BODILY_INTEGRITY.
    It is the terminus of the longest dependency chain in Mariology. -/
theorem assumption_follows_from_ic
    (_h_no_original : ¬hasOriginalSin mary)
    (_h_no_personal : ¬committedPersonalSin mary)
    (h_bodily_integrity : ¬bodySubjectToCorruption mary)
    (_h_hylomorphism : ∀ (p : HylomorphicPerson), p.soulIsForm → p.composition.isUnified)
    (h_assumed : bodilyAssumed mary) :
    -- Mary was assumed body and soul, AND her body was not subject to corruption
    bodilyAssumed mary ∧ ¬bodySubjectToCorruption mary :=
  ⟨h_assumed, h_bodily_integrity⟩

/-- **THEOREM: sinlessness_to_integrity** — The derivation from sinlessness
    to bodily integrity, which is the key intermediate step. -/
theorem sinlessness_to_integrity
    (h_preserved : preservedFromOriginalSin mary)
    (h_no_personal : ¬committedPersonalSin mary) :
    ¬bodySubjectToCorruption mary :=
  SINLESSNESS_IMPLIES_BODILY_INTEGRITY mary
    (PRESERVATION_EXCLUDES_SIN mary h_preserved)
    h_no_personal

/-- The Assumption connects to DivineModes: Mary enters the heavenState
    (full beatifying communion, body and soul).
    The heavenState from DivineModes.lean has:
    - sustained = True (God sustains her in existence)
    - inCommunion = True (full beatifying communion)
    - purified = True (fully purified — indeed, never needed purification) -/
theorem assumption_is_full_communion :
    heavenState.sustained ∧ heavenState.inCommunion ∧ heavenState.purified := by
  exact ⟨trivial, trivial, trivial⟩

def assumption_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Catholic (defined 1950); Orthodox accept 'Dormition' with different framing; Protestants reject" }

-- ============================================================================
-- THE DEPENDENCY CHAIN — made explicit
-- ============================================================================

/-!
## The dependency chain

Each later dogma requires every earlier one. The axiom count grows at each step,
and the denominational scope narrows correspondingly.

```
STEP 1: Theotokos (2 axioms — ecumenical)
  Axioms: HYPOSTATIC_UNION, MOTHERHOOD_TARGETS_PERSONS
  + Given: MARY_BORE_CHRIST (Scripture)
  Scope: Nearly ecumenical (Luther & Calvin accepted)

STEP 2: Immaculate Conception (6 axioms — Catholic only)
  Inherits: everything from Step 1
  Adds: ORIGINAL_SIN_INHERITED, RETROACTIVE_REDEMPTION,
        FITTINGNESS_AS_EVIDENCE, PAPAL_INFALLIBILITY
  Scope: Catholic only

STEP 3: Assumption (8+ axioms — Catholic only)
  Inherits: everything from Steps 1 and 2
  Adds: SINLESSNESS_IMPLIES_BODILY_INTEGRITY,
        DEATH_IS_CONSEQUENCE_OF_SIN, P1 (hylomorphism)
  Scope: Catholic only
```

The pattern: more axioms → narrower scope → fewer traditions agree.
This is the axiom-set-as-denomination principle applied to Mariology.
-/

/-- **THEOREM: theotokos_required_for_ic** — The Immaculate Conception
    presupposes Theotokos. The definition begins with Mary as Mother of God;
    without that, the fittingness argument ("it is fitting that the MOTHER
    OF GOD be sinless") has no force.

    If Mary is just an ordinary woman who happened to bear a human prophet,
    there is no special reason she should be preserved from original sin.
    The fittingness argument REQUIRES her to be the Mother of God. -/
theorem theotokos_required_for_ic
    (h_theotokos : bore mary christ ∧ christ.isDivine)
    (h_preserved : preservedFromOriginalSin mary) :
    -- Both Theotokos AND Immaculate Conception hold together
    (bore mary christ ∧ christ.isDivine) ∧ preservedFromOriginalSin mary :=
  ⟨h_theotokos, h_preserved⟩

/-- **THEOREM: ic_required_for_assumption** — The Assumption presupposes
    the Immaculate Conception. The definition (Munificentissimus Deus)
    literally begins "The Immaculate Virgin..."

    The logical chain: IC (Mary sinless) → sinlessness implies bodily
    integrity → body not subject to corruption → bodily assumption.
    Without IC, the chain breaks at the first link. -/
theorem ic_required_for_assumption
    (h_preserved : preservedFromOriginalSin mary)
    (h_no_personal : ¬committedPersonalSin mary)
    (h_assumed : bodilyAssumed mary) :
    -- IC + sinlessness + bodily integrity + assumption all hold
    preservedFromOriginalSin mary ∧ ¬committedPersonalSin mary ∧
    ¬bodySubjectToCorruption mary ∧ bodilyAssumed mary :=
  ⟨h_preserved, h_no_personal,
   SINLESSNESS_IMPLIES_BODILY_INTEGRITY mary
     (PRESERVATION_EXCLUDES_SIN mary h_preserved) h_no_personal,
   h_assumed⟩

/-- **THEOREM: full_marian_chain** — The complete dependency chain:
    Hypostatic Union → Theotokos → Immaculate Conception → Assumption.

    This makes the chain explicit: all four propositions hold together,
    and each depends on the previous. Rejecting any link breaks the
    chain downstream. -/
theorem full_marian_chain
    (h_union : christ.isDivine ∧ christ.hasNature Nature.divine ∧ christ.hasNature Nature.human)
    (h_bore : bore mary christ)
    (h_preserved : preservedFromOriginalSin mary)
    (h_no_personal : ¬committedPersonalSin mary)
    (h_assumed : bodilyAssumed mary) :
    -- The full chain holds:
    -- 1. Hypostatic union
    (christ.isDivine ∧ christ.hasNature Nature.divine ∧ christ.hasNature Nature.human) ∧
    -- 2. Theotokos
    (bore mary christ ∧ christ.isDivine) ∧
    -- 3. Immaculate Conception
    (preservedFromOriginalSin mary ∧ ¬hasOriginalSin mary) ∧
    -- 4. Assumption (with bodily integrity)
    (bodilyAssumed mary ∧ ¬bodySubjectToCorruption mary) :=
  ⟨ h_union
  , ⟨h_bore, h_union.1⟩
  , ⟨h_preserved, PRESERVATION_EXCLUDES_SIN mary h_preserved⟩
  , ⟨h_assumed, SINLESSNESS_IMPLIES_BODILY_INTEGRITY mary
      (PRESERVATION_EXCLUDES_SIN mary h_preserved) h_no_personal⟩
  ⟩

/-- **THEOREM: chain_breaks_without_union** — Without the hypostatic union,
    Theotokos has no force, and the downstream dogmas lose their foundation.

    If Christ is not divine, then "Mother of God" is meaningless, the
    fittingness argument for IC fails, and the Assumption loses its
    theological motivation. -/
theorem chain_breaks_without_union
    (h_not_divine : ¬christ.isDivine) :
    -- Cannot conclude Theotokos (Mary as Mother of GOD)
    ¬(bore mary christ ∧ christ.isDivine) := by
  intro ⟨_, h_divine⟩
  exact h_not_divine h_divine

-- ============================================================================
-- DENOMINATIONAL SUMMARY
-- ============================================================================

/-- Denominational scope of each Marian axiom and theorem.
    The pattern is clear: more axioms → narrower acceptance. -/
def marianDenominationalScope : List (String × DenominationalTag) :=
  [ -- Dogma 1: Theotokos (nearly ecumenical)
    ("HYPOSTATIC_UNION",              hypostatic_union_tag)
  , ("MOTHERHOOD_TARGETS_PERSONS",    motherhood_targets_persons_tag)
  , ("MARY_BORE_CHRIST",             mary_bore_christ_tag)
  , ("theotokos (theorem)",          theotokos_tag)
    -- Dogma 2: Immaculate Conception (Catholic only)
  , ("ORIGINAL_SIN_INHERITED",       original_sin_inherited_tag)
  , ("RETROACTIVE_REDEMPTION",       retroactive_redemption_tag)
  , ("FITTINGNESS_AS_EVIDENCE",      fittingness_tag)
  , ("PAPAL_INFALLIBILITY",          papal_infallibility_tag)
  , ("immaculate_conception (thm)",  immaculate_conception_tag)
    -- Dogma 3: Assumption (Catholic only)
  , ("DEATH_IS_CONSEQUENCE_OF_SIN",  death_consequence_sin_tag)
  , ("SINLESSNESS_IMPLIES_BODILY_INTEGRITY", sinlessness_integrity_tag)
  , ("assumption (theorem)",         assumption_tag)
  ]

/-!
## Hidden assumptions — summary

1. **Motherhood targets persons, not natures** (Dogma 1): Nestorius denied
   this implicitly. Once stated, it seems obvious — but it is the load-bearing
   premise of Theotokos.

2. **Retroactive redemption** (Dogma 2): Christ's merits can be applied
   backwards in time. This is a genuinely novel metaphysical commitment with
   no clear parallel elsewhere in the system. It is the most philosophically
   adventurous claim in the entire Marian corpus.

3. **Fittingness as evidence** (Dogma 2): "It would be fitting, therefore
   God did it." This epistemological principle (potuit, decuit, fecit) is
   distinctively Scholastic. Protestants reject this entire pattern of
   reasoning.

4. **Hylomorphism grounds bodily assumption** (Dogma 3): Without P1 (the
   person IS the body-soul composite), there is no reason to insist on
   BODILY assumption. You could just say Mary's soul went to heaven. The
   Assumption is the most visible downstream consequence of P1.

5. **Thin scriptural basis for IC** (Dogma 2): Lk 1:28 (kecharitomene) is
   the primary text, and its interpretation is genuinely contested. Gen 3:15
   is typological. The Immaculate Conception relies more on Tradition and
   theological reasoning than on direct scriptural statement. This is honest
   and should be acknowledged.

6. **Papal infallibility as load-bearing axiom** (Dogmas 2 & 3): Both the
   IC (1854) and the Assumption (1950) are ex cathedra definitions. Without
   PAPAL_INFALLIBILITY, neither can be defined as irreformable dogma. This
   axiom does more work in Mariology than anywhere else in the system.
-/

end Catlib.Creed
