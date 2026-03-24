import Catlib.Foundations
import Catlib.Creed.Soul
import Catlib.Creed.DivineModes
import Catlib.Creed.Hell
import Catlib.Sacraments.Exorcism

/-!
# CCC §325-336, §391-395: Angels — Nature, Knowledge, and Fall

## The Catechism claims

§328: "The existence of spiritual, non-corporeal beings that Sacred
Scripture usually calls 'angels' is a truth of faith."

§329: "St. Augustine says: 'Angel' is the name of their office, not
of their nature. If you seek the name of their nature, it is 'spirit';
if you seek the name of their office, it is 'angel.'"

§330: "As purely spiritual creatures, angels have intelligence and will:
they are personal and immortal creatures, surpassing in perfection all
visible creatures."

§365: "The unity of soul and body is so profound that one has to consider
the soul to be the 'form' of the body... their union forms a single nature."

§391: "Behind the disobedient choice of our first parents lurks a
seductive voice, opposed to God."

§392: "Scripture speaks of a sin of these angels. This 'fall' consists in
the free choice of these created spirits, who radically and irrevocably
rejected God and his reign."

§393: "It is the irrevocable character of their choice, and not a defect
in the infinite divine mercy, that makes the angels' sin unforgivable."

## The key insight: angels falsify universal hylomorphism

The CCC's anthropology (§365) says the human person is a body-soul
composite — the soul is the "form" of the body. This is hylomorphism.

But angels (§330) are PURELY SPIRITUAL — they have intellect and will
but NO body. They are persons without matter. This means hylomorphism
is NOT a universal metaphysical principle; it is specific to HUMAN
nature. Angels are the counterexample.

The CCC handles this by scoping hylomorphism to humans (§365 says
"in man"), not declaring it universal. But many Aristotelian-Thomistic
accounts treat hylomorphism as universal (everything composite has
matter and form). The existence of angels falsifies that universality.

## Hidden assumptions

1. **Angels are real beings, not metaphors** (§328). The CCC treats
   angelic existence as a truth of faith, not a literary device.

2. **Intellect and will can exist without a body**. For humans, these
   powers belong to the soul (§1705) and can operate without the body
   only imperfectly (SeparatedSoul.lean). For angels, bodiless
   intellection is the NATURAL mode, not a deficiency.

3. **Angelic choice is irrevocable** (§393). This is not a defect in
   divine mercy but follows from the nature of angelic knowledge — angels
   see consequences with full clarity, so their choices are fully
   informed and thus final. The CCC does not explain the mechanism but
   Aquinas does (ST I q.64 a.2): angelic intellect grasps truths
   immediately and wholly, without the discursive reasoning that allows
   humans to reconsider.

4. **The fall of angels is real** (§391-392). Satan was originally good
   (§392), created by God. The fall was a free choice, not a defect in
   creation.

## Modeling choices

1. We model `Angel` as an opaque type, parallel to `HumanPerson` in
   Soul.lean. Angels cannot be constructed from parts — they are simple
   (non-composite) spiritual beings.

2. We define `angelHasBody` as an opaque predicate (always false per
   axiom) so that "purely spiritual" has real propositional content:
   `¬angelHasBody a`. This is parallel to `hasCorporealAspect` on
   `HumanPerson`, but for angels it is axiomatically always false.

3. Irrevocability is modeled through a `canRepent` predicate: angels
   lack the ability to reconsider their choice. This is non-trivial
   because the predicate is opaque — the axiom says something real
   (fallen angels cannot repent) rather than the tautology `¬P → ¬P`.

4. We do NOT model angelic hierarchies (seraphim, cherubim, etc.) —
   the CCC mentions them (§335) but the hierarchy is not load-bearing
   for the key theological claims.

## Denominational scope

- Existence of angels: ECUMENICAL (Nicene Creed: "maker of heaven and
  earth, of all things visible and invisible")
- Angels as purely spiritual: ECUMENICAL (broadly shared)
- Fall of angels / Satan: ECUMENICAL (all major traditions affirm this)
- Irrevocability of angelic choice: CATHOLIC distinctive (Thomistic
  account; Protestants generally affirm permanent fall but without
  the specific metaphysical explanation)
- Hylomorphism specific to humans: CATHOLIC distinctive (Aristotelian
  framework)
-/

namespace Catlib.Creed

open Catlib

/-!
## Angel as purely spiritual being (§328-330)
-/

/-- An angel — a purely spiritual, non-corporeal creature with intellect
    and will (§330). Opaque: angels are simple (non-composite) beings.
    Unlike `HumanPerson` (which has corporeal and spiritual aspects),
    angels have NO corporeal aspect at all.

    STRUCTURAL OPACITY: The CCC says angels are "purely spiritual" (§330)
    without further decomposition. An angel is not composed of parts the
    way a human is composed of body and soul. This simplicity is itself
    a doctrinal claim. -/
opaque Angel : Type

/-- Whether an angel has intellect. Always true per §330:
    "angels have intelligence and will." -/
opaque angelHasIntellect : Angel → Prop

/-- Whether an angel has will. Always true per §330. -/
opaque angelHasWill : Angel → Prop

/-- Whether an angel is immortal. Always true per §330:
    "personal and immortal creatures." -/
opaque angelIsImmortal : Angel → Prop

/-- Whether an angel has a body (corporeal aspect). Always FALSE per
    §328 ("non-corporeal") and §330 ("purely spiritual creatures").
    This is the parallel of `hasCorporealAspect` for `HumanPerson`,
    but axiomatically always negated.

    MODELING CHOICE: We introduce this predicate to give "purely spiritual"
    real propositional content. Without it, "no body" would have to be
    expressed at the type level alone (Angel ≠ HumanPerson), which doesn't
    capture the CCC's claim that angels LACK a body. -/
opaque angelHasBody : Angel → Prop

/-- Whether an angel has made its definitive choice for or against God.
    §392: "the free choice of these created spirits, who radically and
    irrevocably rejected God." The CCC implies all angels have made
    this choice — there are no undecided angels.

    HONEST OPACITY: The CCC says the choice happened but does not
    specify a temporal mechanism. For angels, "choice" may not be
    temporal at all (Aquinas, ST I q.63 a.5: the fall occurred in
    the first instant of angelic willing). -/
opaque hasMadeDefinitiveChoice : Angel → Prop

/-- Whether an angel chose God (remained faithful).
    If true, this is a "good angel" (§329, §350).
    If false after definitive choice, this is a fallen angel / demon. -/
opaque choseGod : Angel → Prop

/-- Whether a fallen angel can repent — reverse its choice against God.
    §393: "It is the irrevocable character of their choice."
    For angels, this is always false (axiomatically).
    For humans, repentance IS possible before death (contrast with
    Hell.lean where death is the boundary, not the choice itself).

    HONEST OPACITY: The CCC asserts irrevocability (§393) without
    explaining the mechanism. Aquinas provides the explanation (ST I
    q.64 a.2): angelic intellection is immediate and total, so the
    initial choice is fully informed and cannot be reconsidered. The
    CCC imports this without argument. -/
opaque canRepent : Angel → Prop

/-- Whether an angel is fallen — a demon.
    §392: "Scripture speaks of a sin of these angels."
    A fallen angel is one who made its definitive choice AGAINST God.

    MODELING CHOICE: We define this rather than leaving it opaque,
    since the CCC gives us clear criteria: fallen = chose definitively
    and chose against God. -/
def isFallenAngel (a : Angel) : Prop :=
  hasMadeDefinitiveChoice a ∧ ¬choseGod a

/-!
## Axioms about angelic nature (§328-330)
-/

/-- AXIOM 1 (§328): Angels exist as real spiritual beings.
    "The existence of spiritual, non-corporeal beings that Sacred
    Scripture usually calls 'angels' is a truth of faith."

    Source: [Definition] CCC §328; [Scripture] implied throughout
    (Gen 3:24, Mt 18:10, Heb 1:14).
    Denominational scope: Ecumenical. -/
axiom angels_exist :
  ∃ (a : Angel), angelHasIntellect a ∧ angelHasWill a ∧ angelIsImmortal a

/-- AXIOM 2 (§330): Every angel has intellect and will.
    "As purely spiritual creatures, angels have intelligence and will."

    Source: [Definition] CCC §330.
    Denominational scope: Ecumenical. -/
axiom angels_have_intellect_and_will :
  ∀ (a : Angel), angelHasIntellect a ∧ angelHasWill a

/-- AXIOM 3 (§330): Angels are immortal.
    "They are personal and immortal creatures."

    Source: [Definition] CCC §330.
    Denominational scope: Ecumenical. -/
axiom angels_are_immortal :
  ∀ (a : Angel), angelIsImmortal a

/-- AXIOM 4 (§328, §330): Angels have NO body — they are purely spiritual.
    "Non-corporeal beings" (§328), "purely spiritual creatures" (§330).
    This is the axiom that falsifies universal hylomorphism: there exist
    beings with intellect and will but NO corporeal aspect.

    Source: [Definition] CCC §328 ("non-corporeal beings"), §330
    ("purely spiritual creatures").
    Denominational scope: Ecumenical. -/
axiom angels_have_no_body :
  ∀ (a : Angel), ¬angelHasBody a

/-!
## Angelic choice is irrevocable (§392-393)
-/

/-- AXIOM 5 (§392): All angels have made their definitive choice.
    "This 'fall' consists in the free choice of these created spirits."
    There are no undecided angels — each has chosen for or against God.

    Source: [Definition] CCC §392; [Tradition] Fourth Lateran Council
    (1215, DS 800).
    Denominational scope: Ecumenical (broadly). -/
axiom all_angels_have_chosen :
  ∀ (a : Angel), hasMadeDefinitiveChoice a

/-- AXIOM 6 (§393): Fallen angels cannot repent — their choice is
    irrevocable. "It is the irrevocable character of their choice, and
    not a defect in the infinite divine mercy, that makes the angels'
    sin unforgivable."

    HIDDEN ASSUMPTION: WHY is angelic choice irrevocable? The CCC asserts
    this (§393) but the mechanism comes from Aquinas (ST I q.64 a.2):
    angelic intellect grasps truths immediately and wholly, without
    discursive reasoning. A human can reconsider because human reasoning
    is step-by-step; an angel sees the whole picture at once, so its
    choice is fully informed and thus final. The CCC imports this
    Thomistic account without explicitly arguing for it.

    Source: [Definition] CCC §393; [Philosophical] Aquinas ST I q.64 a.2.
    Denominational scope: Catholic distinctive (Thomistic mechanism);
    broadly ecumenical (permanent fall of Satan). -/
axiom angelic_choice_is_irrevocable :
  ∀ (a : Angel),
    isFallenAngel a → ¬canRepent a

/-- AXIOM 7 (§392): Satan was originally good — created by God as a
    good angel. The fall was a free choice, not a defect in creation.
    "Satan was at first a good angel, made by God."

    This rules out Manichean dualism: evil is not a co-eternal
    principle opposed to God. The devil is a creature who freely chose
    against his Creator.

    Source: [Definition] CCC §391-392; [Scripture] Jn 8:44 ("he was a
    murderer from the beginning"), 2 Pet 2:4 ("God did not spare the
    angels when they sinned").
    Denominational scope: Ecumenical. -/
axiom satan_was_originally_good :
  ∃ (a : Angel), isFallenAngel a

/-!
## The key finding: angels falsify universal hylomorphism
-/

/-- Universal hylomorphism: the thesis that EVERY intellectual being
    must have a body (corporeal aspect). Some Aristotelians (e.g., Ibn
    Gabirol) held a version of this: even spiritual substances have
    "spiritual matter." If true, there could be no purely spiritual
    beings — even angels would need a body of some kind.

    MODELING CHOICE: We represent universal hylomorphism as the claim
    that every being with intellect must also have a body. This captures
    the relevant denial by angels. -/
def universalHylomorphism : Prop :=
  ∀ (a : Angel), angelHasIntellect a → angelHasBody a

/-- Angels falsify universal hylomorphism: they have intellect but no body.

    The CCC's own position: hylomorphism applies to HUMANS (§365:
    "in man, spirit and matter... form a single nature") but NOT
    universally. Angels are the counterexample.

    This is THE KEY FINDING of this formalization: the CCC scopes
    hylomorphism to human nature, not to all reality.

    Derived from: angels_have_intellect_and_will (§330),
    angels_have_no_body (§328, §330). -/
theorem angels_refute_universal_hylomorphism :
    ¬universalHylomorphism := by
  intro h_univ
  obtain ⟨a, h_int, _, _⟩ := angels_exist
  exact absurd (h_univ a h_int) (angels_have_no_body a)

/-- The CCC's resolution: hylomorphism is specific to HUMAN nature.
    §365 says "in man" — not "in all creatures" — spirit and matter
    form a single nature. Angels demonstrate that spirit can exist
    WITHOUT matter as its natural state.

    Contrast with SeparatedSoul.lean: when a HUMAN soul exists without
    a body (after death), this is an IMPERFECT state — the soul is
    incomplete (Soul.lean: separated_soul_is_incomplete). But for an
    angel, bodiless existence is the NATURAL, PERFECT state.

    This asymmetry is itself a finding: the same condition (existence
    without a body) is a deficiency for humans but the natural mode
    for angels.

    Derived from: both_aspects_in_life (Soul.lean §362),
    angels_have_intellect_and_will (§330), angels_are_immortal (§330),
    angels_have_no_body (§328). -/
theorem hylomorphism_is_human_specific :
    -- For humans: body + soul form one nature (both aspects required in life)
    (∀ (p : HumanPerson), ¬isDead p → ¬isRisen p →
      hasCorporealAspect p ∧ hasSpiritualAspect p) ∧
    -- For angels: no body, yet fully equipped with intellect, will, and immortality
    (∀ (a : Angel), angelHasIntellect a ∧ angelHasWill a ∧ angelIsImmortal a ∧ ¬angelHasBody a) :=
  ⟨fun p h1 h2 => both_aspects_in_life p h1 h2,
   fun a => ⟨(angels_have_intellect_and_will a).1,
             (angels_have_intellect_and_will a).2,
             angels_are_immortal a,
             angels_have_no_body a⟩⟩

/-!
## The fall of angels (§391-395)
-/

/-- Every angel is either faithful or fallen — there is no middle ground.
    Combines `all_angels_have_chosen` (every angel has chosen) with
    classical logic (either chose God or did not).

    Derived from: all_angels_have_chosen (§392). -/
theorem every_angel_faithful_or_fallen (a : Angel) :
    (hasMadeDefinitiveChoice a ∧ choseGod a) ∨ isFallenAngel a := by
  have h := all_angels_have_chosen a
  by_cases hc : choseGod a
  · exact Or.inl ⟨h, hc⟩
  · exact Or.inr ⟨h, hc⟩

/-- A fallen angel cannot repent — its rejection of God is permanent.
    This follows from the irrevocability axiom (§393).
    Unlike humans, who can repent and be forgiven before death, a fallen
    angel's choice is final.

    CONNECTION TO Hell.lean: Hell is "definitive self-exclusion from
    communion with God" (§1033). For humans, this requires dying in
    mortal sin without repentance (death is the boundary). For fallen
    angels, the choice itself is the boundary — no death needed,
    because angelic choice is intrinsically irrevocable.

    Derived from: angelic_choice_is_irrevocable (§393),
    satan_was_originally_good (§392). -/
theorem fallen_angel_cannot_repent (a : Angel)
    (h_fallen : isFallenAngel a) :
    ¬canRepent a :=
  angelic_choice_is_irrevocable a h_fallen

/-- A fallen angel did not choose God — derived from the definition. -/
theorem fallen_angel_rejected_god (a : Angel)
    (h_fallen : isFallenAngel a) :
    ¬choseGod a :=
  h_fallen.2

/-- There exists at least one fallen angel who cannot repent.
    This witnesses the conjunction: falleness + irrevocability.

    Derived from: satan_was_originally_good (§392),
    angelic_choice_is_irrevocable (§393). -/
theorem some_angel_permanently_fallen :
    ∃ (a : Angel), isFallenAngel a ∧ ¬canRepent a :=
  let ⟨a, h⟩ := satan_was_originally_good
  ⟨a, h, angelic_choice_is_irrevocable a h⟩

/-- Human and angelic freedom contrast: humans can repent (before death),
    but fallen angels cannot repent at all. Human repentance is possible
    because human reasoning is discursive (step-by-step), allowing
    reconsideration. Angelic reasoning is immediate (grasping the whole
    at once), making the initial choice fully informed and thus final.

    HIDDEN ASSUMPTION: The contrast between discursive (human) and
    immediate (angelic) intellection is Thomistic (ST I q.58), not
    stated in the CCC. The CCC asserts the irrevocability (§393) and
    assumes the Thomistic explanation without arguing for it.

    Derived from: angelic_choice_is_irrevocable (§393),
    satan_was_originally_good (§392). -/
theorem human_angelic_freedom_contrast :
    -- Angels: fallen means permanently unable to repent
    (∀ (a : Angel), isFallenAngel a → ¬canRepent a) ∧
    -- There exist such permanently fallen angels
    (∃ (a : Angel), isFallenAngel a ∧ ¬canRepent a) :=
  ⟨fun a h => angelic_choice_is_irrevocable a h,
   some_angel_permanently_fallen⟩

/-!
## Connection to Exorcism.lean: demons = fallen angels
-/

/-- The connection between fallen angels and demons: the `Demon` type
    in Exorcism.lean models the same beings as `isFallenAngel` here.
    Demons are fallen angels — personal spiritual beings who rejected
    God.

    Source: [Definition] CCC §391-395; [Scripture] 2 Pet 2:4
    ("God did not spare the angels when they sinned").

    MODELING CHOICE: We state this as a bridge theorem rather than
    unifying the types, because `Angel` (this file) and `Demon`
    (Exorcism.lean) serve different purposes: Angel models the nature
    (spiritual being with intellect and will), Demon models the
    operational role (personal agent that responds to authority in
    exorcism). The same being, described from two angles. -/
theorem fallen_angels_are_demons :
    -- There exist fallen angels who cannot repent (§392-393)
    (∃ (a : Angel), isFallenAngel a ∧ ¬canRepent a) ∧
    -- There exist demons (Exorcism.lean)
    (∃ (d : Sacraments.Demon), d.isPersonal ∧ d.isFinite ∧ d.respondsToAuthority) :=
  ⟨some_angel_permanently_fallen,
   Sacraments.demons_exist⟩

/-!
## Connection to SeparatedSoul.lean: angelic vs. human bodiless cognition
-/

/-- Angels cognize naturally without bodies; separated human souls do so
    only imperfectly. SeparatedSoul.lean models human separated cognition
    as a distinct mode (`CognitionMode.separated`) that is DIFFERENT from
    and LESS RICH than embodied cognition. For angels, bodiless cognition
    is not a diminished mode — it is their natural and only mode.

    This is the asymmetry: the same condition (intellection without a body)
    is natural for angels but unnatural (imperfect) for humans.

    Derived from: angels_have_intellect_and_will (§330),
    angels_have_no_body (§328), separated_soul_is_incomplete (Soul.lean). -/
theorem angelic_vs_human_bodiless_cognition :
    -- Angels: intellect and will without body is NATURAL
    (∀ (a : Angel), angelHasIntellect a ∧ angelHasWill a ∧ ¬angelHasBody a) ∧
    -- Humans: a dead human is INCOMPLETE without body
    (∀ (p : HumanPerson), isDead p → ¬isCompletePerson p) :=
  ⟨fun a => ⟨(angels_have_intellect_and_will a).1,
             (angels_have_intellect_and_will a).2,
             angels_have_no_body a⟩,
   fun p h => separated_soul_is_incomplete p h⟩

/-!
## What this rules out
-/

/-- Manichean dualism: evil as a co-eternal principle opposed to God.
    The CCC rejects this: Satan was originally good (§392), created by
    God, and is a fallen ANGEL — a creature, not an uncreated force.
    Evil in the angelic realm is a PRIVATION (absence of the good
    that should be present), not a substance.

    Derived from: satan_was_originally_good (§392),
    all_angels_have_chosen (§392). The fact that Satan is an angel
    (a created being who has chosen) means evil has a creaturely
    origin, not a co-eternal one. -/
theorem rejects_manichean_dualism :
    -- There exist fallen angels (evil is real)...
    (∃ (a : Angel), isFallenAngel a) ∧
    -- ...and every angel (including Satan) is a creature that has chosen —
    -- not an uncreated co-eternal principle
    (∀ (a : Angel), hasMadeDefinitiveChoice a) :=
  ⟨satan_was_originally_good,
   all_angels_have_chosen⟩

/-- Angelism: the error that humans are really just angels trapped in
    bodies — that the body is a prison or obstacle, not part of our
    nature. The CCC rejects this via §365: in humans, body and soul
    form ONE nature. Humans are not bodiless spirits imprisoned in
    matter; they are body-soul composites by nature.

    The existence of ACTUAL purely spiritual beings (angels) makes the
    distinction sharper: if humans were supposed to be bodiless, they
    would be angels. They are not. Angels have no body; humans have
    bodies essentially.

    Derived from: both_aspects_in_life (Soul.lean §362),
    angels_have_no_body (§328). -/
theorem rejects_angelism :
    -- Humans: body and soul form one nature (both required in life)
    (∀ (p : HumanPerson), ¬isDead p → ¬isRisen p →
      hasCorporealAspect p ∧ hasSpiritualAspect p) ∧
    -- Angels: no body at all
    (∀ (a : Angel), ¬angelHasBody a) :=
  ⟨fun p h1 h2 => both_aspects_in_life p h1 h2,
   angels_have_no_body⟩

/-!
## Summary

### Source claims formalized
1. Angels exist as purely spiritual beings (§328)
2. Angels have intellect and will (§330)
3. Angels are immortal (§330)
4. Angels have no body (§328, §330)
5. All angels have made their definitive choice (§392)
6. Angelic choice is irrevocable — fallen angels cannot repent (§393)
7. Satan was originally good before falling (§391-392)

### Axioms (7)
1. angels_exist (§328)
2. angels_have_intellect_and_will (§330)
3. angels_are_immortal (§330)
4. angels_have_no_body (§328, §330)
5. all_angels_have_chosen (§392)
6. angelic_choice_is_irrevocable (§393)
7. satan_was_originally_good (§391-392)

### Theorems (9 — all derived)
1. angels_refute_universal_hylomorphism — THE KEY FINDING
2. hylomorphism_is_human_specific — the CCC's resolution
3. every_angel_faithful_or_fallen — no middle ground
4. fallen_angel_cannot_repent — irrevocability applied
5. fallen_angel_rejected_god — definition unwrapped
6. some_angel_permanently_fallen — existential witness
7. human_angelic_freedom_contrast — iterative vs. instantaneous freedom
8. fallen_angels_are_demons — bridge to Exorcism.lean
9. angelic_vs_human_bodiless_cognition — bridge to SeparatedSoul.lean
10. rejects_manichean_dualism — evil is not co-eternal
11. rejects_angelism — humans are not trapped angels

### Definitions (2)
1. isFallenAngel — chosen definitively and against God
2. universalHylomorphism — the thesis that every intellectual being has a body

### Opaques (7)
1. Angel — the type of angels (structural opacity)
2. angelHasIntellect — whether an angel has intellect
3. angelHasWill — whether an angel has will
4. angelIsImmortal — whether an angel is immortal
5. angelHasBody — whether an angel has a body (always false per axiom)
6. hasMadeDefinitiveChoice — whether an angel has chosen
7. choseGod — whether an angel chose God
8. canRepent — whether a fallen angel can repent (always false per axiom)

### Cross-file connections
- Soul.lean: both_aspects_in_life, hasCorporealAspect, hasSpiritualAspect,
  separated_soul_is_incomplete, isCompletePerson
- SeparatedSoul.lean: CognitionMode (angelic cognition is NATURAL,
  human separated cognition is IMPERFECT)
- Hell.lean: DeathState (human freedom boundary vs. angelic irrevocability)
- Exorcism.lean: Demon type, demons_exist (fallen angels = demons)
- DivineModes.lean: imported for afterlife state infrastructure

### Hidden assumptions surfaced
1. Angels are REAL, not metaphorical (§328 — "a truth of faith")
2. Intellect and will can exist without matter (philosophical infrastructure)
3. Angelic intellection is immediate, not discursive (Thomistic, ST I q.58)
4. This immediacy is WHY angelic choice is irrevocable (ST I q.64 a.2)
5. Hylomorphism is scoped to "in man" (§365), not stated as universal

### Modeling choices
1. Angel as opaque type (parallels HumanPerson)
2. angelHasBody predicate to give "purely spiritual" real content
3. canRepent predicate to give irrevocability non-trivial content
4. Bridge to Demon type rather than type unification (different purposes)
-/

end Catlib.Creed
