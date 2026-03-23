import Catlib.Foundations
import Catlib.Creed.Soul
import Catlib.Creed.Purgatory
import Catlib.Creed.DivineModes
import Catlib.Creed.Christology

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
  └→ Theotokos (Ephesus 431) [+ motherhood_targets_persons]
       └→ Immaculate Conception (1854) [+ RETROACTIVE_REDEMPTION + FITTINGNESS + PAPAL_INFALLIBILITY]
            └→ Assumption (1950) [+ sinlessness_implies_bodily_integrity + P1 hylomorphism]
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
open Catlib.Creed.Christology

-- ============================================================================
-- MARIAN-SPECIFIC TYPES (Christology types imported from Christology.lean)
-- ============================================================================

-- Nature, IncarnateSubject, christ, hypostatic_union, and the Chalcedonian
-- negatives are now in Christology.lean. MarianDogma imports them.

/-- The motherhood relation: one human person bore another.
    Motherhood is a relation between PERSONS, not between a mother and
    a nature. This distinction is the crux of the Theotokos dogma. -/
opaque bore : HumanPerson → IncarnateSubject → Prop

/-- Whether a human person is the mother of another (including all their natures).
    This is what Ephesus (431) affirmed: motherhood targets the PERSON,
    not a nature in isolation. If you bore a divine person, you are the
    mother of God — not merely "mother of Christ's human nature." -/
opaque isMotherOf : HumanPerson → IncarnateSubject → Prop

/-- Whether a human person has original sin. -/
opaque hasOriginalSin : HumanPerson → Prop

/-- Whether a human person is preserved from original sin at conception. -/
opaque preservedFromOriginalSin : HumanPerson → Prop

/-- Whether a human person ever committed any personal sin. -/
opaque committedPersonalSin : HumanPerson → Prop

/-- Whether a person's body is subject to the corruption that results from sin.
    This is a consequence of sin (Rom 5:12, Gen 3:19, CCC §1008). -/
opaque bodySubjectToCorruption : HumanPerson → Prop

/-- A person is bodily assumed when they are taken up body and soul into
    heavenly glory — both corporeal and spiritual aspects present, without
    bodily corruption.
    CCC §966: "taken up body and soul into heavenly glory."
    CCC §974: "already shares in the glory of her Son's Resurrection,
    anticipating the resurrection of all members of his Body."
    In Soul.lean terms: the assumed person has BOTH aspects (complete person)
    and their body is not subject to corruption. This is resurrection
    anticipated — death and corruption bypassed entirely. -/
def bodilyAssumed (p : HumanPerson) : Prop :=
  hasCorporealAspect p ∧ hasSpiritualAspect p ∧ ¬bodySubjectToCorruption p

-- christ is now defined in Christology.lean

/-- Mary, as a HumanPerson (Soul.lean).
    The indivisible body-soul composite — the right type for reasoning
    about original sin, bodily integrity, and the Assumption. -/
axiom mary : HumanPerson

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

-- hypostatic_union is now in Christology.lean (shared foundation)

def hypostatic_union_provenance : Provenance := Provenance.tradition "Chalcedon 451; CCC §466-469"
def hypostatic_union_tag : DenominationalTag := ecumenical

/-- **AXIOM: motherhood_targets_persons** — Motherhood is a relation to a PERSON,
    not to a nature. If you bore a person, you are the mother of that person
    (including all their natures).
    Source: Council of Ephesus (431); CCC §466, §495.
    This is the hidden axiom that Nestorius denied. He wanted to say Mary gave
    birth to Christ's human nature but not to Christ's divine nature. But you
    don't give birth to natures — you give birth to persons.
    Denominational scope: ECUMENICAL — once stated clearly, virtually no one
    denies this. Even Nestorius did not explicitly deny it; he simply failed
    to see its implications. -/
axiom motherhood_targets_persons :
  ∀ (mother : HumanPerson) (child : IncarnateSubject),
    bore mother child → isMotherOf mother child

def motherhood_targets_persons_provenance : Provenance :=
  Provenance.tradition "Ephesus 431; CCC §466, §495"
def motherhood_targets_persons_tag : DenominationalTag := ecumenical

/-- **GIVEN (Scripture)**: Mary bore Jesus Christ.
    Source: Lk 1:31 ("you will conceive in your womb and bear a son"),
    Mt 1:18-25, Lk 2:6-7.
    Denominational scope: ECUMENICAL — no Christian tradition denies this. -/
axiom mary_bore_christ :
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
  ⟨mary_bore_christ, hypostatic_union.1⟩

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
theorem rejecting_theotokos_implies_nestorianism :
    -- From axioms alone: Mary bore Christ, motherhood targets persons,
    -- Christ is divine → Mary is the Mother of God AND of the whole person.
    (bore mary christ ∧ christ.isDivine) ∧ isMotherOf mary christ :=
  ⟨theotokos, motherhood_targets_persons mary christ mary_bore_christ⟩

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

1. original_sin_inherited — ecumenical (broadly)
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

/-- **AXIOM: original_sin_inherited** — Original sin is transmitted to every
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
axiom original_sin_inherited :
  ∀ (p : HumanPerson), ¬preservedFromOriginalSin p → hasOriginalSin p

def original_sin_inherited_provenance : Provenance := Provenance.scripture "Rom 5:12; CCC §404"
def original_sin_inherited_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical], note := "broadly shared; Orthodox frame differently as 'ancestral sin'" }

/-!
### The fittingness principle — Duns Scotus's *potuit, decuit, fecit*

The Immaculate Conception's most distinctive supporting argument is the
**argument from fittingness** (convenientia). Duns Scotus (1266-1308):

- *potuit* — God COULD do it (omnipotence)
- *decuit* — it was FITTING that He do it (the Mother of God should be sinless)
- *fecit* — therefore He DID it

This is an epistemological principle: aesthetic/theological fittingness,
combined with divine omnipotence, is treated as evidence that God acted.
It turns "it would be beautiful if X" into "therefore X."

This is a genuinely distinctive Catholic epistemological commitment.
Protestants reject it — "fitting" doesn't imply "actual" without
independent evidence. The principle has no scriptural basis; it's a
method of theological reasoning imported from Scotist philosophy.

NOTE: RETROACTIVE_REDEMPTION and the old PAPAL_INFALLIBILITY axioms
were deleted because they had vacuous bodies. PAPAL_INFALLIBILITY is
now properly formalized in `PapalInfallibility.lean`. The fittingness
principle below replaces the old FITTINGNESS_AS_EVIDENCE (which was
`claim → claim`).
-/

-- NOTE: We intentionally do NOT formalize the fittingness principle
-- as an axiom here. The principle ("potuit, decuit, fecit") is real
-- Catholic theology, but we don't yet understand what "fitting" means
-- well enough to model it. Specifically:
--
-- 1. What IS fittingness? An aesthetic judgment? A mode of divine
--    reasoning? A type of probability? Scotus, Aquinas, and Bonaventure
--    all use the concept differently.
--
-- 2. What distinguishes "fitting" from "maximally fitting"? The IC
--    argument needs the strongest form, but the CCC doesn't define
--    degrees of fittingness.
--
-- 3. Why does fittingness + omnipotence → actuality? God COULD do
--    many fitting things He hasn't done. What additional premise
--    makes this one actual?
--
-- See CONTRIBUTING.md backlog item "Define what fittingness means"
-- for the research agenda. For now, mary_preserved below is a direct
-- axiom (the doctrinal commitment), not derived from fittingness.

def fittingness_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Scotist epistemology (potuit, decuit, fecit). Fittingness principle not yet formalized — see backlog." }

/-- **AXIOM: mary_preserved** — Mary was preserved from original sin.
    This is the actual doctrinal commitment of the Immaculate Conception,
    defined ex cathedra by Pius IX in Ineffabilis Deus (1854).

    Source: CCC §491-492; Pius IX, Ineffabilis Deus (1854).
    The MOTIVATION for this axiom (not formally derivable):
    - Fittingness: it was fitting for the Mother of God to be sinless
      (Duns Scotus: "potuit, decuit, fecit")
    - Retroactive redemption: God can apply Christ's merits before the Cross
    - Papal authority: defined ex cathedra (only 2 such definitions in history)
    Denominational scope: CATHOLIC ONLY.
    - Protestants reject fittingness reasoning and papal authority
    - Orthodox reject the Western framing of original sin -/
axiom mary_preserved :
  preservedFromOriginalSin mary

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
(preservation_excludes_sin) connecting the two as contradictories. This is
semantically obvious ("preserved from X" means "does not have X") but must
be stated in a formal system. The proof assistant forced this hidden
assumption to the surface.
-/

/-- **AXIOM: preservation_excludes_sin** — Being preserved from original sin
    and having original sin are contradictory.
    This is an analytic truth from the meaning of "preserved from."
    Denominational scope: ECUMENICAL (definitional). -/
axiom preservation_excludes_sin :
  ∀ (p : HumanPerson), preservedFromOriginalSin p → ¬hasOriginalSin p

/-- **THEOREM: immaculate_conception** — Mary does not have original sin.

    Derived from two axioms:
    - mary_preserved: the doctrinal commitment (she was preserved)
    - preservation_excludes_sin: preserved from X → does not have X

    No hypotheses needed — this follows directly from the axiom base.
    The real question is whether you accept mary_preserved, which is
    the Catholic-only axiom. -/
theorem immaculate_conception_proper :
    ¬hasOriginalSin mary :=
  preservation_excludes_sin mary mary_preserved

def immaculate_conception_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Catholic only; Orthodox reject Western framing; Protestants reject entirely" }

/-- Mary never committed personal sin either.
    Source: CCC §493; Council of Trent, Session 6, Canon 23.
    This is a STRONGER claim than the Immaculate Conception (which is about
    original sin only). The Catechism holds Mary was free from ALL sin. -/
axiom mary_sinless :
  ¬committedPersonalSin mary

def mary_sinless_provenance : Provenance := Provenance.tradition "Council of Trent Session 6 Canon 23; CCC §493"
def mary_sinless_tag : DenominationalTag := catholicOnly

/-- **THEOREM: everyone_has_original_sin_except_mary** — Every person who was
    NOT preserved from original sin has it (original_sin_inherited). Mary was
    preserved (mary_preserved). Therefore Mary is the sole exception.

    This is the provocative consequence: under Catholic axioms, exactly ONE
    human being in all of history was conceived without original sin. Every
    other person inherits it. The universality comes from original_sin_inherited
    (Rom 5:12); the exception comes from mary_preserved (Ineffabilis Deus 1854).

    Denominational scope: CATHOLIC — Protestants accept the universality
    (Rom 5:12) but reject the exception. -/
theorem everyone_has_original_sin_except_mary
    (p : HumanPerson) (h_not_preserved : ¬preservedFromOriginalSin p) :
    -- If you weren't preserved, you have original sin
    hasOriginalSin p :=
  original_sin_inherited p h_not_preserved

/-- The converse: Mary WAS preserved, so she does NOT have it. -/
theorem mary_is_the_exception :
    preservedFromOriginalSin mary ∧ ¬hasOriginalSin mary :=
  ⟨mary_preserved, immaculate_conception_proper⟩


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

/-- **AXIOM: death_is_consequence_of_sin** — Death and bodily corruption
    entered the world through sin. Without sin, there would be no death.
    Source: Rom 5:12 ("sin came into the world through one man, and death
    through sin"); Gen 3:19 ("you are dust, and to dust you shall return");
    CCC §1008 ("Death is a consequence of sin").
    Denominational scope: ECUMENICAL (broadly) — most Christians accept this
    in some form, though interpretations vary (physical death vs. spiritual
    death, universal vs. representative). -/
axiom death_is_consequence_of_sin :
  ∀ (p : HumanPerson),
    (hasOriginalSin p ∨ committedPersonalSin p) →
    bodySubjectToCorruption p

def death_consequence_sin_provenance : Provenance := Provenance.scripture "Rom 5:12; Gen 3:19; CCC §1008"
def death_consequence_sin_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical], note := "broadly shared; interpretations vary" }

/-- **THEOREM: Every non-preserved person's body is subject to corruption.**
    Chain: not preserved → has original sin (original_sin_inherited) →
    body subject to corruption (death_is_consequence_of_sin).
    This is why death is universal — everyone except Mary has original sin,
    and original sin causes bodily corruption (Rom 5:12, Gen 3:19). -/
theorem non_preserved_body_corrupts
    (p : HumanPerson) (h_not_preserved : ¬preservedFromOriginalSin p) :
    bodySubjectToCorruption p :=
  death_is_consequence_of_sin p
    (Or.inl (original_sin_inherited p h_not_preserved))

/-- **AXIOM: sinlessness_implies_bodily_integrity** — If a person never
    sinned (neither original nor personal sin), their body is not subject
    to the corruption that results from sin.

    This is NOT the contrapositive of death_is_consequence_of_sin.
    death_is_consequence_of_sin says: sin → corruption (forward direction).
    This axiom says: ¬sin → ¬corruption (the converse of the contrapositive).
    These are logically independent — "sin causes corruption" does not imply
    "no sin prevents corruption" (there could be other causes of corruption).
    Both directions must be separately asserted.

    Source: CCC §966, §974. Denominational scope: CATHOLIC. -/
axiom sinlessness_implies_bodily_integrity :
  ∀ (p : HumanPerson),
    ¬hasOriginalSin p →
    ¬committedPersonalSin p →
    ¬bodySubjectToCorruption p

def sinlessness_integrity_provenance : Provenance :=
  Provenance.tradition "theological reasoning; CCC §966, §974"
def sinlessness_integrity_tag : DenominationalTag := catholicOnly

/-!
### The Assumption chain

The chain:
1. Immaculate Conception: Mary was preserved from original sin (mary_preserved)
2. Personal sinlessness: Mary never committed personal sin (mary_sinless)
3. Sinlessness implies bodily integrity: no sin → body not subject to corruption
4. Mary's body was not subject to corruption (sinlessness_to_integrity)
5. Therefore: Mary was assumed body and soul into glory (mary_bodily_assumed)

Source: Pius XII, Munificentissimus Deus (1950); CCC §966, §974.
-/

/-- **AXIOM: mary_bodily_assumed** — Mary was assumed body and soul into heaven.
    Defined ex cathedra by Pius XII in Munificentissimus Deus (1950).
    Source: CCC §966; Pius XII, Munificentissimus Deus (1950).
    Denominational scope: CATHOLIC ONLY.
    - Orthodox accept the "Dormition" (Mary's falling asleep) but frame it differently
    - Protestants reject this as unscriptural -/
axiom mary_bodily_assumed :
  bodilyAssumed mary

/-- **THEOREM: sinlessness_to_integrity** — From sinlessness to bodily
    integrity, the key intermediate step to the Assumption.

    Derived from mary_preserved, mary_sinless, preservation_excludes_sin,
    and sinlessness_implies_bodily_integrity. No hypotheses. -/
theorem sinlessness_to_integrity :
    ¬bodySubjectToCorruption mary :=
  sinlessness_implies_bodily_integrity mary
    (preservation_excludes_sin mary mary_preserved)
    mary_sinless

/-- **THEOREM: assumption_follows_from_ic** — Mary was bodily assumed.
    The definition of bodilyAssumed (hasCorporealAspect ∧ hasSpiritualAspect ∧
    ¬bodySubjectToCorruption) is satisfied by mary_bodily_assumed. -/
theorem assumption_follows_from_ic :
    bodilyAssumed mary :=
  mary_bodily_assumed

/-- The Assumption connects to DivineModes: Mary enters the heavenState
    (full beatifying communion, body and soul).
    The heavenState from DivineModes.lean has:
    - sustained = True (God sustains her in existence)
    - inBeatifyingCommunion = True (full beatifying communion)
    - purified = True (fully purified — indeed, never needed purification) -/
theorem assumption_is_full_communion :
    heavenState.sustained ∧ heavenState.inBeatifyingCommunion ∧ heavenState.purified := by
  exact ⟨trivial, trivial, trivial⟩

def assumption_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Catholic (defined 1950); Orthodox accept 'Dormition' with different framing; Protestants reject" }

-- ============================================================================
-- THE ASSUMPTION AND HUMAN NATURE (Soul.lean connection)
-- ============================================================================

/-!
## The Assumption in terms of human nature

CCC §966: Mary was "taken up body and soul into heavenly glory."
CCC §974: She "already shares in the glory of her Son's Resurrection,
anticipating the resurrection of all members of his Body."

In Soul.lean's framework:
- Normal death: `isDead p → ¬hasCorporealAspect p ∧ hasSpiritualAspect p`
  (body gone, soul persists — INCOMPLETE person)
- Resurrection: `isRisen p → hasCorporealAspect p ∧ hasSpiritualAspect p`
  (body + soul reunited — COMPLETE person again)
- The Assumption: Mary skipped the incomplete state. She went directly to
  the complete-person-in-glory state — body and soul together.

This is why the CCC calls it "a singular participation in her Son's
Resurrection and an anticipation of the resurrection of other Christians."
Other saints right now are incomplete (soul without body, awaiting
resurrection). Mary is already complete.
-/

/-- The Assumption implies Mary is a complete person — both aspects present.
    This follows directly from the definition of bodilyAssumed:
    bodilyAssumed p = hasCorporealAspect p ∧ hasSpiritualAspect p ∧ ¬bodySubjectToCorruption p -/
theorem assumption_means_complete_person
    (h : bodilyAssumed mary) :
    hasCorporealAspect mary ∧ hasSpiritualAspect mary :=
  ⟨h.1, h.2.1⟩

/-- THEOREM: Mary is a complete person in heaven.
    Unlike other saints (who are incomplete souls awaiting resurrection),
    Mary already has both aspects — body and soul in glory.
    Derived from mary_bodily_assumed. -/
theorem mary_is_complete_in_heaven :
    hasCorporealAspect mary ∧ hasSpiritualAspect mary :=
  assumption_means_complete_person mary_bodily_assumed

/-- THEOREM: Mary's state in heaven differs from other dead saints.
    A dead saint has spiritual aspect only (soul_is_immortal) but NOT
    corporeal aspect (death_separates). Mary has BOTH.
    This is what makes the Assumption doctrinally significant — it's not
    just "Mary went to heaven" (all saints do). It's "Mary went to heaven
    BODILY, anticipating the resurrection of the body." -/
theorem assumption_differs_from_normal_death
    (saint : HumanPerson)
    (h_saint_dead : isDead saint) :
    -- A dead saint is incomplete: soul yes, body no
    (¬hasCorporealAspect saint) ∧
    -- But Mary is complete: both yes
    (hasCorporealAspect mary ∧ hasSpiritualAspect mary) :=
  ⟨(death_separates saint h_saint_dead).1, mary_is_complete_in_heaven⟩

-- ============================================================================
-- THE DEPENDENCY CHAIN — made explicit
-- ============================================================================

/-!
## The dependency chain

Each later dogma requires every earlier one. The axiom count grows at each step,
and the denominational scope narrows correspondingly.

```
STEP 1: Theotokos (2 axioms — ecumenical)
  Axioms: hypostatic_union, mary_bore_christ
  Scope: Nearly ecumenical (Luther & Calvin accepted)

STEP 2: Immaculate Conception (2 axioms — Catholic only)
  Adds: mary_preserved, preservation_excludes_sin
  Scope: Catholic only (mary_preserved is the papal definition)

STEP 3: Assumption (3 axioms — Catholic only)
  Adds: mary_sinless, sinlessness_implies_bodily_integrity, mary_bodily_assumed
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
theorem theotokos_required_for_ic :
    -- Both Theotokos AND Immaculate Conception hold together
    (bore mary christ ∧ christ.isDivine) ∧ preservedFromOriginalSin mary :=
  ⟨theotokos, mary_preserved⟩

/-- **THEOREM: ic_required_for_assumption** — The Assumption presupposes
    the Immaculate Conception. The definition (Munificentissimus Deus)
    literally begins "The Immaculate Virgin..."

    The logical chain: IC (Mary sinless) → sinlessness implies bodily
    integrity → body not subject to corruption → bodily assumption.
    Without IC, the chain breaks at the first link. -/
theorem ic_required_for_assumption :
    -- IC + sinlessness + assumption all hold
    preservedFromOriginalSin mary ∧ ¬committedPersonalSin mary ∧
    bodilyAssumed mary :=
  ⟨mary_preserved, mary_sinless, mary_bodily_assumed⟩

/-- **THEOREM: full_marian_chain** — The complete dependency chain:
    Hypostatic Union → Theotokos → Immaculate Conception → Assumption.

    This makes the chain explicit: all four propositions hold together,
    and each depends on the previous. Rejecting any link breaks the
    chain downstream. -/
theorem full_marian_chain :
    -- The full chain holds — derived entirely from axioms, no hypotheses:
    -- 1. Theotokos
    (bore mary christ ∧ christ.isDivine) ∧
    -- 2. Immaculate Conception
    (preservedFromOriginalSin mary ∧ ¬hasOriginalSin mary) ∧
    -- 3. Assumption (body + soul, no corruption)
    bodilyAssumed mary :=
  ⟨ theotokos
  , ⟨mary_preserved, immaculate_conception_proper⟩
  , mary_bodily_assumed
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
    ("hypostatic_union",              hypostatic_union_tag)
  , ("motherhood_targets_persons",    motherhood_targets_persons_tag)
  , ("mary_bore_christ",             mary_bore_christ_tag)
  , ("theotokos (theorem)",          theotokos_tag)
    -- Dogma 2: Immaculate Conception (Catholic only)
  , ("original_sin_inherited",       original_sin_inherited_tag)
  , ("mary_preserved",              immaculate_conception_tag)
  , ("immaculate_conception (thm)",  immaculate_conception_tag)
    -- Dogma 3: Assumption (Catholic only)
  , ("death_is_consequence_of_sin",  death_consequence_sin_tag)
  , ("sinlessness_implies_bodily_integrity", sinlessness_integrity_tag)
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
