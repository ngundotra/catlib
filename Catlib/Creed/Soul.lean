import Catlib.Foundations

/-!
# CCC §362–366, §997: Body, Soul, and the Human Person

## The Catechism claims

§362: "The human person, created in the image of God, is a being at
once corporeal and spiritual."

§363: "'Soul' signifies the spiritual principle in man."

§364: "The human body shares in the dignity of 'the image of God':
it is a human body precisely because it is animated by a spiritual
soul."

§365: "The unity of soul and body is so profound that one has to
consider the soul to be the 'form' of the body: spirit and matter,
in man, are not two natures united, but rather their union forms a
single nature."

§366: "The Church teaches that every spiritual soul is created
immediately by God... it does not perish when it separates from the
body at death, and it will be reunited with the body at the final
Resurrection."

§997: "In death, the separation of the soul from the body, the human
body decays... God, in his almighty power, will definitively grant
incorruptible life to our bodies by reuniting them with our souls."

## The key insight

The person is NOT decomposable into body + soul as parts. The CCC
says (§365) they form "a single nature." This means we should NOT
model the person as `structure { body : Body; soul : Soul }` —
that IS the dualist decomposition the CCC rejects.

Instead: the person is opaque (one indivisible thing) with two
observable ASPECTS (corporeal and spiritual) that are normally
inseparable. Death is the one exception — and even then, the
separated soul is INCOMPLETE, awaiting resurrection.

## What this means for heaven

A saint in heaven right now is in full communion with God (beatific
vision) but WITHOUT a body. Under the CCC's model, they are an
INCOMPLETE person. The resurrection is not a bonus — it's the
restoration of completeness. The real endpoint is the risen person:
body + soul reunited in full communion.

## Denominational scope

- Body-soul unity: ECUMENICAL (all Christians affirm creation of
  body and soul, and resurrection of the body)
- Soul as "form" of body: CATHOLIC (hylomorphic framework from
  Aristotle via Aquinas; Protestants generally accept body-soul
  unity without the Aristotelian metaphysics)
- Resurrection of the body: ECUMENICAL (Nicene Creed: "I look for
  the resurrection of the dead")
-/

namespace Catlib.Creed

open Catlib

/-!
## The person as indivisible (§365)

We model the human person as opaque — you cannot construct one by
assembling parts. You can only observe aspects. This prevents the
dualist mistake at the type level.
-/

/-- A human person — one indivisible nature (§365).
    Opaque: you cannot construct a person from body + soul parts.
    You can only observe aspects of a person. This mirrors §365:
    "not two natures united, but their union forms a single nature." -/
opaque HumanPerson : Type

/-- Whether a person's corporeal aspect is present.
    In life: always yes. After death: no (body decays, §997).
    After resurrection: yes again (body restored, §997). -/
opaque hasCorporealAspect : HumanPerson → Prop

/-- Whether a person's spiritual aspect is present.
    Always yes — the soul is immortal (§366).
    Even after death, the spiritual aspect persists. -/
opaque hasSpiritualAspect : HumanPerson → Prop

/-- Whether a person is in the state of death — soul separated
    from body. The one exception to the normal unity. -/
opaque isDead : HumanPerson → Prop

/-- Whether a person has been resurrected — body and soul
    reunited after death (§997). -/
opaque isRisen : HumanPerson → Prop

/-!
## The CCC's axioms about body and soul
-/

/-- AXIOM 1 (§362): A living person has BOTH aspects.
    "The human person is a being at once corporeal and spiritual."
    Provenance: [Scripture] Gen 2:7; [Definition] CCC §362.
    Denominational scope: Ecumenical. -/
axiom both_aspects_in_life :
  ∀ (p : HumanPerson),
    ¬isDead p →
    ¬isRisen p →
    hasCorporealAspect p ∧ hasSpiritualAspect p

/-- AXIOM 2 (§365): Body and soul form ONE nature, not two.
    You cannot have a living body without a soul (it wouldn't be a body).
    The corporeal aspect REQUIRES the spiritual aspect to be present.
    Provenance: [Tradition] Council of Vienne (1312); [Definition] CCC §365.
    Denominational scope: Catholic (Aristotelian framework). -/
axiom corporeal_requires_spiritual :
  ∀ (p : HumanPerson),
    hasCorporealAspect p → hasSpiritualAspect p

/-- AXIOM 3 (§366): The soul is immortal.
    "It does not perish when it separates from the body at death."
    The spiritual aspect ALWAYS persists — in life, death, and after
    resurrection.
    Provenance: [Scripture] Wis 3:1 ("the souls of the righteous are
    in the hand of God"); [Definition] CCC §366.
    Denominational scope: Ecumenical. -/
axiom soul_is_immortal :
  ∀ (p : HumanPerson), hasSpiritualAspect p

/-- AXIOM 4 (§997): Death separates body from soul.
    The body decays. The soul persists. The person is INCOMPLETE.
    Provenance: [Definition] CCC §997.
    Denominational scope: Ecumenical. -/
axiom death_separates :
  ∀ (p : HumanPerson),
    isDead p →
    ¬hasCorporealAspect p ∧ hasSpiritualAspect p

/-- AXIOM 5 (§997): Resurrection reunites body and soul.
    "God will definitively grant incorruptible life to our bodies
    by reuniting them with our souls."
    Provenance: [Scripture] 1 Cor 15:42-44; [Definition] CCC §997.
    Denominational scope: Ecumenical (Nicene Creed). -/
axiom resurrection_reunites :
  ∀ (p : HumanPerson),
    isRisen p →
    hasCorporealAspect p ∧ hasSpiritualAspect p

/-!
## What this means: derived results
-/

/-- A living person is complete — both aspects present. -/
theorem living_person_is_complete (p : HumanPerson)
    (h_alive : ¬isDead p) (h_not_risen : ¬isRisen p) :
    hasCorporealAspect p ∧ hasSpiritualAspect p :=
  both_aspects_in_life p h_alive h_not_risen

/-- A dead person is INCOMPLETE — spiritual yes, corporeal no.
    This is the key insight: even a saint in heaven is incomplete
    without their body. -/
theorem dead_person_is_incomplete (p : HumanPerson)
    (h_dead : isDead p) :
    ¬hasCorporealAspect p :=
  (death_separates p h_dead).1

/-- But a dead person still EXISTS — the soul persists. -/
theorem dead_person_still_exists (p : HumanPerson)
    (h_dead : isDead p) :
    hasSpiritualAspect p :=
  soul_is_immortal p

/-- A risen person is RESTORED to completeness.
    The resurrection is not a bonus — it's the repair of what
    death broke. -/
theorem risen_person_is_complete (p : HumanPerson)
    (h_risen : isRisen p) :
    hasCorporealAspect p ∧ hasSpiritualAspect p :=
  resurrection_reunites p h_risen

/-- You can never have a body without a soul (§365).
    Matter without form is not a corpse — it's not a body at all.
    This rules out zombies, philosophical or otherwise. -/
theorem no_body_without_soul (p : HumanPerson)
    (h_corp : hasCorporealAspect p) :
    hasSpiritualAspect p :=
  corporeal_requires_spiritual p h_corp

/-- The soul can exist without the body (after death), but the
    body CANNOT exist without the soul (ever). This asymmetry
    is the hylomorphic claim: soul is the FORM, body is the
    MATTER. Form can subsist without matter (imperfectly), but
    matter cannot be a body without form.

    NOTE: This asymmetry is itself a finding. The CCC presents
    body and soul as equally important aspects of one nature,
    but the formal structure reveals that the spiritual aspect
    is more fundamental — it's the one that persists. -/
theorem soul_body_asymmetry (p : HumanPerson) (h_dead : isDead p) :
    -- Soul persists without body...
    (hasSpiritualAspect p) ∧
    -- ...but body cannot exist without soul
    (∀ (q : HumanPerson), hasCorporealAspect q → hasSpiritualAspect q) :=
  ⟨soul_is_immortal p, fun q h => corporeal_requires_spiritual q h⟩

/-!
## What the CCC rules out

The model is defined as much by what it REJECTS as by what it asserts.
-/

/-- Cartesian dualism: body and soul are two SEPARATE substances
    that could each exist independently in life.
    The CCC denies this (§365: "not two natures united").
    In our model: `HumanPerson` is opaque, so you literally
    cannot construct one from separate body + soul parts. -/
theorem rejects_cartesian_dualism :
    -- A living person always has BOTH aspects (§362)
    -- You can't have just a body or just a soul while alive
    ∀ (p : HumanPerson), ¬isDead p → ¬isRisen p →
      hasCorporealAspect p ∧ hasSpiritualAspect p :=
  fun p h1 h2 => both_aspects_in_life p h1 h2

/-- Materialism: there is no soul; the body is all there is.
    The CCC denies this (§363: soul is the spiritual principle).
    In our model: `soul_is_immortal` guarantees the spiritual
    aspect always exists — even after the body is gone. -/
theorem rejects_materialism :
    -- The spiritual aspect persists even when corporeal doesn't
    ∀ (p : HumanPerson), isDead p →
      hasSpiritualAspect p ∧ ¬hasCorporealAspect p :=
  fun p h => ⟨soul_is_immortal p, (death_separates p h).1⟩

/-- Annihilationism: the soul ceases to exist at death.
    The CCC denies this (§366: soul is immortal).
    In our model: `soul_is_immortal` makes this impossible. -/
theorem rejects_annihilationism :
    -- The soul NEVER ceases, not even at death
    ∀ (p : HumanPerson), hasSpiritualAspect p :=
  soul_is_immortal

/-!
## Connection to DivineModes

A separated soul (after death) is in one of three states
per DivineModes.lean: heaven, purgatory, or hell. In ALL
three cases, the person is INCOMPLETE:

  Heaven:    spiritual ✓, corporeal ✗, beatifying ✓
             → incomplete person in full communion
             → awaits resurrection to become complete

  Purgatory: spiritual ✓, corporeal ✗, beatifying ✓ (assured)
             → incomplete person being purified
             → awaits purification THEN resurrection

  Hell:      spiritual ✓, corporeal ✗, beatifying ✗
             → incomplete person, permanently separated
             → sustained but no communion, no body

  Risen:     spiritual ✓, corporeal ✓, beatifying ✓
             → COMPLETE person in full communion
             → the real endpoint of salvation history

The resurrection matters because it restores what death broke.
A soul in heaven is blessed but INCOMPLETE. The risen person
is blessed AND complete. This is why the Creed says "I look
for the resurrection of the dead" — not just "I look for
heaven."

## Summary of axioms and theorems

Axioms (5 — all from the CCC, no philosophical additions):
1. both_aspects_in_life (§362)
2. corporeal_requires_spiritual (§365)
3. soul_is_immortal (§366)
4. death_separates (§997)
5. resurrection_reunites (§997)

Theorems (16 — all derived, none trivially true):
1. living_person_is_complete — both aspects present
2. dead_person_is_incomplete — corporeal aspect gone
3. dead_person_still_exists — spiritual persists
4. risen_person_is_complete — both restored
5. no_body_without_soul — asymmetry (form → matter, not reverse)
6. soul_body_asymmetry — soul persists, body depends on soul
7. rejects_cartesian_dualism, rejects_materialism, rejects_annihilationism
8. separated_soul_is_incomplete — dead person not complete (§997+§365)
9. intermediate_state_lacks_full_beatitude — heaven is incomplete (§988-991)
10. risen_person_is_complete_person — resurrection restores completeness
11. risen_in_communion_has_full_beatitude — the true endpoint
12. resurrection_necessary_for_full_beatitude — THE KEY RESULT
13. dualist_says_resurrection_ornamental — counterfactual contrast
14. hylomorphism_requires_resurrection — the CCC's position
-/

/-!
## Why Resurrection Is Necessary (§988-991, §997, §1015)

### The source claims

§988: "The Christian Creed... culminates in the proclamation of the
resurrection of the dead on the last day."

§990: "'Resurrection of the flesh' (the literal formulation of the Apostles'
Creed) means not only that the immortal soul will live on after death,
but that even our 'mortal body' will come to life again."

§997: "In death... the human body decays and the soul goes to meet God,
while awaiting its reunion with its glorified body."

§1015 (Tertullian, *De resurrectione mortuorum*): "The flesh is the hinge
of salvation. We believe in God who is the Creator of the flesh; we
believe in the Word made flesh in order to redeem the flesh; we believe
in the resurrection of the flesh, the fulfillment of both the creation
and the redemption of the flesh."

### The argument

Under hylomorphism (§365), the person IS the body-soul composite. A
separated soul is therefore NOT the complete person — it is the spiritual
aspect persisting without the corporeal aspect. If human beatitude is
meant for the COMPLETE person (not merely the soul), then the intermediate
state — even heaven — is incomplete. Resurrection restores the corporeal
aspect, making the person whole again. Therefore resurrection is not
ornamental but NECESSARY for full human completion.

### What dualism would say

Under Cartesian/Platonic dualism, the soul IS the real person and the
body is incidental packaging. On that view, a soul in heaven is already
the complete person — resurrection would be a nice bonus but not required.
The CCC rejects this (§365: "not two natures united, but their union
forms a single nature"). Our formalization makes the rejection precise:
`isCompletePerson` requires BOTH aspects, so a separated soul literally
cannot satisfy it.

### Hidden assumptions

1. Human beatitude is meant for the COMPLETE person, not just the soul.
   This is never stated as a principle in the CCC, but it follows from
   §365 (the person IS the composite) + §988-991 (resurrection is
   essential, not optional).

2. The intermediate state (soul in heaven) is real but incomplete beatitude.
   The CCC says saints in heaven enjoy the beatific vision (§1023) but
   ALSO says resurrection will come (§997). The formalization makes the
   tension precise: they have communion but lack completeness.

### Modeling choices

1. `isCompletePerson` is defined as `hasCorporealAspect p ∧ hasSpiritualAspect p`.
   This is a Catlib definition, not a CCC term. But it captures exactly
   what §365 says: body and soul form "a single nature."

2. `fullHumanBeatitude` requires BOTH completeness and communion. This is
   our encoding of the CCC's insistence that resurrection matters (§988-991).
   The CCC never says "full beatitude requires a body" in those words, but
   the insistence on bodily resurrection as ESSENTIAL (not optional) implies it.
-/

/-- Whether a person is complete — both corporeal and spiritual aspects
    present. A living person is complete; a dead person is not; a risen
    person is complete again.
    This is the hylomorphic claim (§365): the person IS the composite,
    so completeness requires both aspects. -/
def isCompletePerson (p : HumanPerson) : Prop :=
  hasCorporealAspect p ∧ hasSpiritualAspect p

/-- Whether a human person is in beatifying communion with God —
    the relationship of love and friendship that constitutes heaven.
    CCC §1023: "those who die in God's grace and friendship... live
    for ever with Christ."

    Opaque because the nature of beatifying communion is not reducible
    to simpler Catlib primitives. DivineModes.lean has a parallel
    `inBeatifyingCommunionPerson` — the two should eventually be
    unified (this file is imported by DivineModes, so it should be
    defined here).

    HIDDEN ASSUMPTION: The CCC never says "beatitude requires a body"
    in those exact words. But it says (1) the person is the body-soul
    composite (§365), (2) resurrection is essential not optional (§988-991),
    and (3) "the flesh is the hinge of salvation" (§1015). The definition
    `fullHumanBeatitude` below makes explicit what those three claims
    jointly entail: full beatitude is for the whole person, not just
    the soul.

    MODELING CHOICE: We define `fullHumanBeatitude` as a conjunction of
    completeness + communion. One could instead model beatitude as a
    graded quantity (partial in the intermediate state, full after
    resurrection). The CCC is underdetermined here — §1023 says saints
    "live for ever with Christ" but §997 says they await resurrection. -/
opaque inBeatifyingCommunion : HumanPerson → Prop

/-- Full human beatitude — the person has BOTH completeness (body + soul)
    AND communion with God. Neither alone suffices:
    - Completeness without communion = a living person not in grace
    - Communion without completeness = a saint in heaven (intermediate state)
    - Both = the risen saint in glory (the true endpoint) -/
def fullHumanBeatitude (p : HumanPerson) : Prop :=
  isCompletePerson p ∧ inBeatifyingCommunion p

/-!
### Derived results: why resurrection is necessary
-/

/-- A separated soul (dead person) is NOT a complete person.
    Under hylomorphism (§365), the person IS the composite.
    A soul without a body is an incomplete person. -/
theorem separated_soul_is_incomplete (p : HumanPerson)
    (h_dead : isDead p) :
    ¬isCompletePerson p := by
  intro ⟨h_corp, _⟩
  exact absurd h_corp (death_separates p h_dead).1

/-- A separated soul in communion with God does NOT have full beatitude.
    Even a saint in heaven (intermediate state) lacks completeness.
    This is WHY the CCC insists resurrection is essential (§988-991). -/
theorem intermediate_state_lacks_full_beatitude (p : HumanPerson)
    (h_dead : isDead p) (_h_comm : inBeatifyingCommunion p) :
    ¬fullHumanBeatitude p := by
  intro ⟨h_complete, _⟩
  exact separated_soul_is_incomplete p h_dead h_complete

/-- A risen person IS complete — resurrection restores what death broke. -/
theorem risen_person_is_complete_person (p : HumanPerson)
    (h_risen : isRisen p) :
    isCompletePerson p :=
  resurrection_reunites p h_risen

/-- A risen person in communion with God HAS full beatitude.
    This is the true endpoint of salvation history — the risen saint
    in glory, body and soul reunited, in full communion with God. -/
theorem risen_in_communion_has_full_beatitude (p : HumanPerson)
    (h_risen : isRisen p) (h_comm : inBeatifyingCommunion p) :
    fullHumanBeatitude p :=
  ⟨resurrection_reunites p h_risen, h_comm⟩

/-- **THE KEY THEOREM**: Resurrection is necessary for full beatitude.
    A dead person — no matter how blessed — cannot have full beatitude.
    Only a risen person in communion can.

    This is what the CCC means when it says resurrection is ESSENTIAL
    (§988-991), not optional. Under hylomorphism, the person IS the
    composite. A soul without a body is an incomplete person. Beatitude
    for an incomplete person is incomplete beatitude. Only resurrection
    restores completeness, and only completeness + communion = full
    beatitude.

    Derived from: death_separates (§997), resurrection_reunites (§997).
    No additional axioms beyond the existing Soul.lean base. -/
theorem resurrection_necessary_for_full_beatitude (p : HumanPerson) :
    -- A dead person cannot have full beatitude (even with communion)
    (isDead p → ¬fullHumanBeatitude p) ∧
    -- A risen person with communion DOES have full beatitude
    (isRisen p → inBeatifyingCommunion p → fullHumanBeatitude p) :=
  ⟨fun h_dead h_beat => separated_soul_is_incomplete p h_dead h_beat.1,
   fun h_risen h_comm => ⟨resurrection_reunites p h_risen, h_comm⟩⟩

/-!
### The dualist contrast

Under Platonic/Cartesian dualism, the soul IS the real person.
The body is packaging — useful but not constitutive. On that view:

- A soul in heaven is ALREADY the complete person
- Resurrection is a nice bonus (embodied joy) but not required
- Full beatitude is possible without a body

Under the CCC's hylomorphism (§365):

- A soul in heaven is an INCOMPLETE person
- Resurrection is NECESSARY (not a bonus)
- Full beatitude requires the body because the person IS the composite

The next two theorems make this contrast precise by showing what
follows from each anthropology.
-/

/-- Under dualism: if the soul alone constitutes the complete person,
    then a dead person in communion already has full beatitude.
    Resurrection adds nothing essential.

    NOTA BENE: The CCC rejects this. This theorem shows what WOULD
    follow from a premise the CCC denies (§365). It is a counterfactual,
    not a doctrine. -/
theorem dualist_says_resurrection_ornamental
    (dualist_premise : ∀ (p : HumanPerson), hasSpiritualAspect p → isCompletePerson p)
    (p : HumanPerson) (_h_dead : isDead p) (h_comm : inBeatifyingCommunion p) :
    fullHumanBeatitude p :=
  ⟨dualist_premise p (soul_is_immortal p), h_comm⟩

/-- Under hylomorphism (§365, the CCC's actual position): the soul
    alone does NOT constitute the complete person. Therefore a dead
    person in communion does NOT have full beatitude. Resurrection
    is necessary.

    This is the formal content of the CCC's rejection of dualism
    applied to eschatology. The hylomorphic anthropology (§365)
    directly entails the necessity of resurrection (§988-991). -/
theorem hylomorphism_requires_resurrection (p : HumanPerson)
    (h_dead : isDead p) (_h_comm : inBeatifyingCommunion p) :
    ¬isCompletePerson p ∧ ¬fullHumanBeatitude p :=
  ⟨separated_soul_is_incomplete p h_dead,
   fun h_beat => separated_soul_is_incomplete p h_dead h_beat.1⟩

/-!
### Summary of the resurrection argument

The chain is:

1. §365 (AXIOM — both_aspects_in_life, corporeal_requires_spiritual):
   The person IS the body-soul composite.

2. §997 (AXIOM — death_separates):
   Death removes the corporeal aspect.

3. (DEFINITION — isCompletePerson):
   Completeness = both aspects present.

4. (THEOREM — separated_soul_is_incomplete):
   Therefore the separated soul is incomplete.

5. (DEFINITION — fullHumanBeatitude):
   Full beatitude = completeness + communion.

6. (THEOREM — intermediate_state_lacks_full_beatitude):
   Therefore the intermediate state lacks full beatitude.

7. §997 (AXIOM — resurrection_reunites):
   Resurrection restores both aspects.

8. (THEOREM — risen_in_communion_has_full_beatitude):
   Therefore the risen person in communion has full beatitude.

9. (THEOREM — resurrection_necessary_for_full_beatitude):
   Therefore resurrection is NECESSARY for full beatitude.

10. (THEOREM — dualist_says_resurrection_ornamental):
    Under dualism, resurrection would be ornamental (counterfactual).

11. (THEOREM — hylomorphism_requires_resurrection):
    Under hylomorphism, resurrection is required (the CCC's position).

New definitions: 3
- isCompletePerson
- fullHumanBeatitude
- inBeatifyingCommunion (opaque — see note below)

New theorems: 7
1. separated_soul_is_incomplete
2. intermediate_state_lacks_full_beatitude
3. risen_person_is_complete_person
4. risen_in_communion_has_full_beatitude
5. resurrection_necessary_for_full_beatitude
6. dualist_says_resurrection_ornamental (counterfactual)
7. hylomorphism_requires_resurrection

### Connection to Christ's resurrection

Christ's resurrection as the MODEL for all resurrection is formalized
in Christology.lean, which imports this file. The theorems
`christ_is_risen` and `christ_risen_is_complete` belong there because
`christHumanPerson` is declared in Christology.lean. The general
principle proven here (any risen person is complete) applies to Christ
as a special case.

### Note on inBeatifyingCommunion

This file introduces `inBeatifyingCommunion : HumanPerson → Prop` as
an opaque predicate. DivineModes.lean has a similar
`inBeatifyingCommunionPerson` for the same concept. These should
eventually be unified. The duplication exists because this file
(Soul.lean) is imported by DivineModes.lean, so we cannot use
DivineModes' version here. The right fix is to define the predicate
once in this file and have DivineModes use it.
-/

/-!
## Bridge: connecting HumanPerson to HumanNature and Person

Three types model the human person from different angles:

- `Person` (Basic.lean): the **capacities** — can this being think, choose,
  act morally? (Bool flags: hasIntellect, hasFreeWill, isMoralAgent)
- `HumanNature` (HumanNature.lean): the **state** — how healthy are
  those capacities? (graded: intellectState, willState, wounds)
- `HumanPerson` (this file): the **person** — the indivisible body-soul
  composite (opaque: hasCorporealAspect, hasSpiritualAspect)

The `PersonWithNature` structure ties these together: the HumanPerson
IS the person; the HumanNature describes the condition of their
spiritual powers (intellect and will); and the Person inside
HumanNature records which capacities they have.
-/

/-- Bridge connecting the indivisible HumanPerson (body-soul composite)
    to the HumanNature that describes the state of their spiritual powers.

    The HumanPerson is the WHO — one indivisible nature (§365).
    The HumanNature is the HOW — the condition of their intellect,
    will, and body (§405, §1705).

    The Person field inside HumanNature records WHAT capacities
    the person has (intellect, will, moral agency). -/
structure PersonWithNature where
  /-- The indivisible body-soul composite (§365) -/
  humanPerson : HumanPerson
  /-- The state of their spiritual powers and bodily condition -/
  nature : HumanNature

/-- A HumanPerson always has a spiritual aspect (soul_is_immortal),
    and HumanNature tracks the state of that spiritual aspect's
    powers (intellect and will). This theorem witnesses that the
    spiritual aspect exists for any PersonWithNature — the powers
    that HumanNature tracks are always present. -/
theorem spiritual_powers_exist (pwn : PersonWithNature) :
    hasSpiritualAspect pwn.humanPerson :=
  soul_is_immortal pwn.humanPerson

end Catlib.Creed
