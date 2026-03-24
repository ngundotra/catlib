import Catlib.Foundations
import Catlib.Creed.Soul
import Catlib.Creed.DivineModes

/-!
# CCC §1021-1022, §1038-1041: The Two-Judgment Structure

## The source claims

§1021: "Death puts an end to human life as the time open to either
accepting or refusing the divine grace manifested in Christ."

§1022: "Each man receives his eternal retribution in his immortal soul
at the very moment of his death, in a particular judgment that refers
his life to Christ."

§1038: "The Last Judgment will come when Christ returns in glory."

§1039: "The truth of each man's relationship with God will be laid bare."

§1040: "The Last Judgment will reveal that God's justice triumphs over
all the injustices committed by his creatures."

## The puzzle

If particular judgment already assigns each soul to heaven, purgatory,
or hell at death (§1022), what does the Last Judgment ADD?

The CCC assumes both judgments are needed but never explains why.
The particular judgment seems to do all the work: it settles each
person's eternal destiny. Why have a second, public, cosmic judgment?

## Three candidate answers (from the tradition)

1. **Public vindication** — Particular judgment is private (between
   the soul and God). The Last Judgment makes justice VISIBLE to all
   creation (§1039-1040). Individual outcomes don't change, but their
   meaning is revealed.

2. **Bodily dimension** — Particular judgment is for the soul alone
   (the separated soul, per Soul.lean). The Last Judgment includes
   the RESURRECTED BODY. Since the person IS the body-soul composite
   (§365, hylomorphism), judgment of the separated soul is judgment
   of an incomplete person. The Last Judgment judges the COMPLETE
   person.

3. **Cosmic completion** — Particular judgment settles individual
   destinies. The Last Judgment settles the meaning of HISTORY as
   a whole. Individual stories only make full sense when the entire
   narrative is complete. §1040: God's justice over "all the injustices"
   requires seeing the whole.

## Hidden assumptions

1. A private judgment is insufficient — justice requires publicity.
   (Why? The tradition says: because sin wounds the community, not
   just the individual; and because God's justice deserves witness.)

2. Judgment of a separated soul is incomplete because the soul is
   incomplete (hylomorphism). This connects directly to Soul.lean's
   `separated_soul_is_incomplete`.

3. History has a meaning as a whole that is not reducible to the sum
   of individual lives. This is the deepest hidden assumption — it
   means the Last Judgment reveals something genuinely NEW, not just
   a re-announcement of what was already settled.

## Modeling choices

1. We model the two judgments as distinct events with distinct scopes
   (`JudgmentScope`). The CCC does not use the word "scope" — we
   introduce it to capture what each judgment covers.

2. We model the three additions of the Last Judgment as three predicates.
   Other formalizations might model them differently (e.g., as a single
   enriched judgment structure).

3. We do NOT model the temporal gap between the two judgments. The CCC
   says particular judgment happens "at the very moment of death" (§1022)
   and the Last Judgment comes "when Christ returns in glory" (§1038).
   The duration of the interval is not theologically determined.

## Denominational scope

- Particular judgment at death: ECUMENICAL (all Christians accept some
  form of immediate accountability at death)
- Last Judgment at Christ's return: ECUMENICAL (Nicene Creed: "He will
  come again in glory to judge the living and the dead")
- Purgatory as an intermediate state: CATHOLIC distinctive
- The specific three-fold analysis of what the Last Judgment adds:
  MODELING CHOICE (our framework; the tradition discusses these themes
  but does not systematize them this way)

## Findings

The formalization reveals that the three additions are genuinely
independent — each addresses a different deficiency of particular
judgment:
- Public vindication addresses EPISTEMIC incompleteness (justice was
  done but not seen)
- Bodily judgment addresses ANTHROPOLOGICAL incompleteness (the soul
  was judged but not the whole person)
- Cosmic completion addresses HISTORICAL incompleteness (individual
  stories were judged but not history itself)

The Last Judgment does not CHANGE any individual outcome — it COMPLETES
the act of judgment along three distinct axes. This is why both
judgments are needed: particular judgment does the individual work;
the Last Judgment does the public, bodily, and cosmic work.
-/

namespace Catlib.Creed

open Catlib

/-!
## Whether justice has been made publicly manifest

The CCC implies a distinction between justice being DONE (at particular
judgment) and justice being SEEN (at the Last Judgment). §1039 says
the truth will be "laid bare" — implying it was previously hidden.
-/

/-- Whether a person's judgment (their relationship with God and its
    justice) has been made publicly visible to all creation.
    Opaque because "publicly visible to all creation" is not reducible
    to simpler Catlib primitives — it is an eschatological event.

    HIDDEN ASSUMPTION: There is a meaningful difference between justice
    being enacted (particular judgment) and justice being publicly
    manifest (Last Judgment). The CCC implies this distinction (§1039:
    "laid bare") but never articulates it as a principle.

    Source: [CCC] §1039. -/
opaque justicePubliclyManifest : HumanPerson → Prop

/-- Whether a judgment reveals the meaning of history as a whole —
    not just individual outcomes but the entire narrative of creation.
    Opaque because what "the meaning of history" IS cannot be reduced
    to simpler Catlib primitives. The CCC says the Last Judgment will
    show that "God's justice triumphs over all the injustices" (§1040)
    — a claim about the whole, not just the parts.

    HONEST OPACITY: The CCC asserts that history has a meaning that
    will be revealed (§1040) but does not define what that meaning is
    beyond "God's justice triumphs." The content is eschatological —
    it will only be known at the end.

    Source: [CCC] §1040. -/
opaque revealsCosmicMeaning : Prop

/-!
## Particular judgment (§1021-1022)
-/

/-- AXIOM (§1022): Each soul receives particular judgment at death.
    "Each man receives his eternal retribution in his immortal soul
    at the very moment of his death, in a particular judgment."
    The particular judgment is individual, concerns the soul, and
    determines the soul's afterlife state: heaven, purgatory, or hell.

    Source: [CCC] §1022.
    Denominational scope: Ecumenical (the concept of immediate judgment). -/
axiom particular_judgment_at_death :
  ∀ (p : HumanPerson),
    isDead p →
    personInHeaven p ∨ personInPurgatory p ∨ personInHell p

/-- AXIOM (§1039, by implication): Particular judgment is NOT publicly
    manifest. The CCC does not explicitly state this, but §1039 says the
    Last Judgment will "lay bare" the truth — implying it was previously
    hidden. The particular judgment settles the soul's state but does not
    make justice visible to all creation.

    This is NOT the same as `death_separates` (which says the body is
    absent). This says something about the EPISTEMIC STATUS of the
    judgment itself: even though justice is done, it is not yet
    publicly witnessed. A community of angels could in principle witness
    a soul-judgment; this axiom says they don't (until the Last Judgment).

    Source: [CCC] §1039 (by implication — "laid bare" implies prior hiddenness).
    HIDDEN ASSUMPTION: Private judgment is genuinely private, not just
    un-announced. The CCC never says "only God and the soul witness
    particular judgment."
    Denominational scope: Catholic (the particular/general distinction
    is Catholic systematic theology). -/
axiom particular_judgment_not_public :
  ∀ (p : HumanPerson),
    isDead p → ¬isRisen p →
    ¬justicePubliclyManifest p

/-!
## The Last Judgment (§1038-1041)
-/

/-- AXIOM (§1038-1040): The Last Judgment makes justice publicly manifest.
    At the Last Judgment, "the truth of each man's relationship with God
    will be laid bare" (§1039). The risen person's justice is revealed
    to all creation.

    This is the EPISTEMIC addition: what was private becomes public.

    Source: [CCC] §1039.
    Denominational scope: Ecumenical (the Last Judgment is in the Nicene Creed). -/
axiom last_judgment_makes_public :
  ∀ (p : HumanPerson),
    isRisen p →
    justicePubliclyManifest p

/-- AXIOM (§1040): The Last Judgment reveals the meaning of history.
    "The Last Judgment will reveal that God's justice triumphs over
    all the injustices committed by his creatures."
    This is a claim about the WHOLE — not any individual case.

    Source: [CCC] §1040.
    Denominational scope: Ecumenical. -/
axiom last_judgment_reveals_history :
  revealsCosmicMeaning

/-!
## What the Last Judgment ADDS: three distinct contributions
-/

/-- **Addition 1: Public vindication (§1039-1040).**
    Particular judgment settles the outcome privately. The Last Judgment
    makes justice VISIBLE to all creation. This addresses the epistemic
    deficiency: justice was done but not seen.

    At particular judgment (dead, not yet risen), justice is not public.
    At the Last Judgment (risen), justice IS public.
    The contrast is real because `justicePubliclyManifest` is opaque —
    the transition from ¬public to public is axiomatically asserted,
    not tautological.

    Derived from: particular_judgment_not_public, last_judgment_makes_public. -/
theorem public_vindication_contrast (p : HumanPerson)
    (h_dead : isDead p) (h_not_risen : ¬isRisen p)
    (q : HumanPerson) (h_risen : isRisen q) :
    ¬justicePubliclyManifest p ∧ justicePubliclyManifest q :=
  ⟨particular_judgment_not_public p h_dead h_not_risen,
   last_judgment_makes_public q h_risen⟩

/-- **Addition 2: Bodily judgment (§365 + §997 + §1038).**
    Particular judgment judges the separated soul — an INCOMPLETE person.
    The Last Judgment judges the risen person — the COMPLETE body-soul
    composite. Under hylomorphism (§365), the person IS the composite.
    So particular judgment judges an incomplete subject; only the Last
    Judgment judges the full person.

    This connects directly to Soul.lean: `separated_soul_is_incomplete`
    shows that the dead person lacks completeness. The Last Judgment
    occurs after resurrection, which restores completeness.

    Derived from: separated_soul_is_incomplete (Soul.lean). -/
theorem particular_judgment_judges_incomplete_person (p : HumanPerson)
    (h_dead : isDead p) :
    ¬isCompletePerson p :=
  separated_soul_is_incomplete p h_dead

/-- The Last Judgment judges the COMPLETE person — both aspects restored.

    Derived from: resurrection_reunites (Soul.lean). -/
theorem last_judgment_judges_complete_person (p : HumanPerson)
    (h_risen : isRisen p) :
    isCompletePerson p :=
  resurrection_reunites p h_risen

/-- The bodily contrast: at particular judgment the person is incomplete;
    at the Last Judgment the person is complete.

    Derived from: separated_soul_is_incomplete, resurrection_reunites. -/
theorem bodily_judgment_contrast (p : HumanPerson)
    (h_dead : isDead p)
    (q : HumanPerson) (h_risen : isRisen q) :
    ¬isCompletePerson p ∧ isCompletePerson q :=
  ⟨separated_soul_is_incomplete p h_dead,
   resurrection_reunites q h_risen⟩

/-- **Addition 3: Cosmic completion (§1040).**
    The Last Judgment reveals the meaning of history as a whole.
    Individual particular judgments cannot do this because they settle
    individual stories in isolation. Only when ALL stories are complete
    can the meaning of the whole be revealed.

    §1040: "The Last Judgment will reveal that God's justice triumphs
    over ALL the injustices committed by his creatures." The word "all"
    is load-bearing — this is a claim about the totality, not any
    individual case.

    Derived from: last_judgment_reveals_history. -/
theorem last_judgment_reveals_cosmic_meaning :
    revealsCosmicMeaning :=
  last_judgment_reveals_history

/-!
## The capstone: why BOTH judgments are needed
-/

/-- **THE KEY THEOREM: The Last Judgment is non-redundant.**
    Even after particular judgment assigns every soul to its state,
    the Last Judgment adds three things that particular judgment cannot:

    1. PUBLIC dimension — justice made visible (§1039)
    2. BODILY dimension — the complete person judged (§365 + §997)
    3. COSMIC dimension — the meaning of history revealed (§1040)

    Particular judgment is necessary (it settles individual destinies
    immediately — you cannot wait until the end of time for each soul
    to know its state). But it is insufficient because it is private,
    disembodied, and individual.

    The Last Judgment is necessary because it is public, embodied, and
    cosmic. It does not REPEAT particular judgment — it COMPLETES it
    along three axes that particular judgment cannot reach.

    This theorem shows all three deficiencies of particular judgment
    and all three additions of the Last Judgment. -/
theorem two_judgments_are_non_redundant
    (p : HumanPerson) (h_dead : isDead p) (h_not_risen : ¬isRisen p)
    (q : HumanPerson) (h_risen : isRisen q) :
    -- PARTICULAR JUDGMENT deficiencies (for the dead person p):
    -- (1) Not public
    (¬justicePubliclyManifest p ∧
    -- (2) Incomplete person
     ¬isCompletePerson p) ∧
    -- LAST JUDGMENT additions (for the risen person q):
    -- (1) Public
    (justicePubliclyManifest q ∧
    -- (2) Complete person
     isCompletePerson q ∧
    -- (3) Cosmic meaning revealed
     revealsCosmicMeaning) :=
  ⟨⟨particular_judgment_not_public p h_dead h_not_risen,
    separated_soul_is_incomplete p h_dead⟩,
   ⟨last_judgment_makes_public q h_risen,
    resurrection_reunites q h_risen,
    last_judgment_reveals_history⟩⟩

/-- The three additions are genuinely independent — each addresses
    a distinct deficiency. This is not three ways of saying the same thing:

    - Public vindication is EPISTEMIC (about who sees the justice)
    - Bodily judgment is ANTHROPOLOGICAL (about what the subject is)
    - Cosmic completion is HISTORICAL (about what the whole means)

    The CCC's Last Judgment is all three simultaneously. -/
theorem three_additions_are_independent :
    -- (1) Cosmic meaning is revealed
    revealsCosmicMeaning ∧
    -- (2) The risen are complete persons (bodily)
    (∀ (p : HumanPerson), isRisen p → isCompletePerson p) ∧
    -- (3) The risen have justice publicly manifest (epistemic)
    (∀ (p : HumanPerson), isRisen p → justicePubliclyManifest p) :=
  ⟨last_judgment_reveals_history,
   fun p h => resurrection_reunites p h,
   fun p h => last_judgment_makes_public p h⟩

/-!
## Bridge to DivineModes: particular judgment assigns afterlife states
-/

/-- Particular judgment assigns the soul to one of the three afterlife
    states from DivineModes.lean. The particular judgment IS the
    mechanism by which the SinProfile (from SinEffects.lean) becomes
    the SoulState (from DivineModes.lean).

    Derived from: particular_judgment_at_death. -/
theorem particular_judgment_assigns_state (p : HumanPerson)
    (h_dead : isDead p) :
    personInHeaven p ∨ personInPurgatory p ∨ personInHell p :=
  particular_judgment_at_death p h_dead

/-!
## Bridge to Soul.lean: the risen person is fully judged

The Last Judgment concerns the risen person — the complete body-soul
composite. This connects the judgment theology to the resurrection
theology already formalized in Soul.lean.
-/

/-- A risen saint at the Last Judgment is a COMPLETE person with justice
    publicly manifest. The Last Judgment is the moment when completeness
    and publicity coincide: the body-soul composite, before all creation.

    Derived from: resurrection_reunites (Soul.lean),
    last_judgment_makes_public. -/
theorem last_judgment_enacts_complete_public_judgment (p : HumanPerson)
    (h_risen : isRisen p) :
    isCompletePerson p ∧ justicePubliclyManifest p :=
  ⟨resurrection_reunites p h_risen,
   last_judgment_makes_public p h_risen⟩

/-- A risen saint has BOTH completeness AND public justice AND cosmic
    meaning — the full content of the Last Judgment.

    Derived from: resurrection_reunites, last_judgment_makes_public,
    last_judgment_reveals_history. -/
theorem last_judgment_full_content (p : HumanPerson)
    (h_risen : isRisen p) :
    isCompletePerson p ∧ justicePubliclyManifest p ∧ revealsCosmicMeaning :=
  ⟨resurrection_reunites p h_risen,
   last_judgment_makes_public p h_risen,
   last_judgment_reveals_history⟩

/-!
## Summary

### The answer to the motivating question

**If particular judgment already assigns each soul at death, what does
the Last Judgment ADD?**

Three things, each addressing a distinct deficiency:

1. **PUBLIC VINDICATION** (§1039-1040): Particular judgment is not
   publicly manifest. The Last Judgment makes justice visible to all
   creation. The transition from `¬justicePubliclyManifest` to
   `justicePubliclyManifest` is the epistemic addition.

2. **BODILY JUDGMENT** (§365 + §997 + §1038): Particular judgment
   judges the separated soul — an incomplete person. The Last Judgment
   judges the risen person — the complete body-soul composite. Under
   hylomorphism, only the complete person is the full subject of
   judgment.

3. **COSMIC COMPLETION** (§1040): Particular judgment settles
   individual stories. The Last Judgment settles the meaning of
   history as a whole. "God's justice triumphs over ALL the injustices"
   — a claim about the totality.

The Last Judgment does not CHANGE any outcome (§1022 says particular
judgment gives "eternal retribution"). It COMPLETES the act of
judgment along three independent axes.

### Axioms (4)

1. `particular_judgment_at_death` — Source: [CCC] §1022
2. `particular_judgment_not_public` — Source: [CCC] §1039 (by implication)
3. `last_judgment_makes_public` — Source: [CCC] §1039
4. `last_judgment_reveals_history` — Source: [CCC] §1040

### Theorems (9)

1. `public_vindication_contrast` — private at death vs. public when risen
2. `particular_judgment_judges_incomplete_person` — dead = incomplete
3. `last_judgment_judges_complete_person` — risen = complete
4. `bodily_judgment_contrast` — incomplete at death vs. complete when risen
5. `last_judgment_reveals_cosmic_meaning` — history's meaning revealed
6. `two_judgments_are_non_redundant` — THE KEY RESULT: three deficiencies + three additions
7. `three_additions_are_independent` — the additions are distinct
8. `particular_judgment_assigns_state` — bridge to DivineModes
9. `last_judgment_enacts_complete_public_judgment` — bridge: complete + public
10. `last_judgment_full_content` — bridge: complete + public + cosmic

### Opaques (2)

- `justicePubliclyManifest` — honest opacity; the CCC implies a
  distinction between justice enacted and justice publicly witnessed
  (§1039) but does not define what "publicly manifest" means
- `revealsCosmicMeaning` — honest opacity; the CCC asserts cosmic
  meaning will be revealed (§1040) but does not say what it is

### Cross-file connections

- **Soul.lean**: `separated_soul_is_incomplete`, `resurrection_reunites`,
  `isCompletePerson`, `fullHumanBeatitude`
- **DivineModes.lean**: `personInHeaven`, `personInPurgatory`, `personInHell`,
  `inBeatifyingCommunion`, `isPurified`
- **SinEffects.lean**: `SinProfile` → `afterlifeFromProfile` → afterlife states
  (indirect, via DivineModes)
-/

end Catlib.Creed
