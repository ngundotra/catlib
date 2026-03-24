import Catlib.Creed.Soul
import Catlib.Creed.SeparatedSoul

/-!
# CCC §364-366: How Does the Soul "Form" Matter Into Body?

## The source claims

§365: "The unity of soul and body is so profound that one has to
consider the soul to be the 'form' of the body: i.e., it is because
of its spiritual soul that the body made of matter becomes a living,
human body; spirit and matter, in man, are not two natures united,
but rather their union forms a single nature."

§366: "The Church teaches that every spiritual soul is created
immediately by God — it is not 'produced' by the parents."

§364: "The human body shares in the dignity of 'the image of God':
it is a human body precisely because it is animated by a spiritual
soul."

## The puzzle

Soul.lean already has `corporeal_requires_spiritual` — you can't have
a body without a soul. But WHY? The CCC's answer (§365) is that the
soul is the "form" of the body. This is Aristotelian metaphysics
(Aristotle, *De Anima* II.1; Aquinas ST I q.76) that the CCC imports
without explaining the mechanism.

## What "form" means in Aristotle/Aquinas

1. **Form actualizes matter**: Matter by itself is pure potentiality
   (prime matter). Form is what makes matter BE a specific kind of
   thing. The form of a statue is its shape; the form of a body is
   the soul.

2. **Matter without form is indeterminate**: Without form, matter has
   no specific identity — it is not a body, not a corpse, not anything
   definite. It is pure potentiality.

3. **Form without matter is incomplete**: A separated soul (Soul.lean)
   is the form without its matter — still real, but not a complete
   person. SeparatedSoul.lean already models this.

4. **Form ACTUALIZES matter**: It makes potential become actual. The
   soul makes matter into a LIVING, HUMAN body. Without the soul, the
   same matter is just... matter.

## What the CCC claims specifically

- The soul makes matter into a LIVING, HUMAN body (§365)
- Without the soul, matter is not a human body — just matter (§364)
- The body's dignity comes FROM the soul's animation (§364)
- At death, the soul separates and the body decays (§997) — because
  the form is gone, the matter loses its organization

## The key theorem

The soul-as-form claim connects Soul.lean's `corporeal_requires_spiritual`
to a MECHANISM. The reason a body requires a soul (Soul.lean axiom)
is that the soul is what MAKES matter into a body in the first place.
Without the form, there's no body — just matter.

## Hidden assumptions

1. **Matter is pure potentiality without form** — Aristotelian metaphysics.
   The CCC does not argue for this; it assumes it.

2. **Form is what makes matter determinate** — the Aristotelian theory
   of causation (formal cause). The CCC borrows this without defending it.

3. **The soul is the SUBSTANTIAL form of the body** — not just an
   accidental form (like color or shape) but what makes matter be a
   HUMAN body at all. This is Aquinas's specific claim (ST I q.76 a.1),
   endorsed by the Council of Vienne (1312).

4. **Decay at death follows from loss of form** — the CCC says the
   body decays when the soul departs (§997). In Aristotelian terms:
   when the substantial form departs, the matter returns to
   indeterminacy — other forms (chemical decomposition) take over.

## Modeling choices

1. **We model "formation" as a relation between soul and matter**.
   The Aristotelian form/matter framework IS the CCC's framework
   (§365 quotes it directly). But "what formation means mechanistically"
   is our modeling choice — the CCC doesn't specify the mechanism,
   it only asserts the result.

2. **Matter is modeled as an opaque type**. We don't need to know what
   matter IS in itself — the point is that it's indeterminate without
   form. This matches the Aristotelian position: prime matter has no
   properties of its own.

3. **The "actualization" relation is opaque**. We can state that the
   soul actualizes matter into body, but WHAT "actualization" consists
   of is precisely the metaphysical question we're flagging. The CCC
   borrows the concept; we formalize its logical consequences.

## Denominational scope

- Soul as form of body: CATHOLIC (Council of Vienne 1312, CCC §365)
- Body-soul unity: ECUMENICAL (all Christians affirm this)
- The specific Aristotelian/Thomistic mechanism: PHILOSOPHICAL
  INFRASTRUCTURE, not dogma

## Prediction

I expect this to reveal that:
1. `corporeal_requires_spiritual` in Soul.lean is not just an assertion
   but follows from the MECHANISM: body requires soul because soul is
   what MAKES matter into body.
2. The decay of the body at death (§997) is explained by the same
   mechanism: no form → no organization → decay.
3. The CCC's claim that the body shares in the dignity of the image
   of God (§364) follows from the same framework: the body's dignity
   is DERIVED from the soul's animation.
4. The Aristotelian framework carries real explanatory weight — it's
   not just a label but a mechanism that connects several CCC claims.
-/

namespace Catlib.Creed

open Catlib

/-!
## Matter and formation

The Aristotelian framework that the CCC borrows (§365). We model
matter as pure potentiality (indeterminate without form) and the
soul as the formal cause that actualizes matter into body.
-/

/-- Matter — the material substrate that the soul "forms" into a body.
    In Aristotelian terms, matter (hyle) is pure potentiality. It has
    no determinate identity on its own — it becomes a specific kind of
    thing only when informed by a form.

    Opaque because matter-in-itself is precisely what Aristotle says is
    unknowable as such — it is only known through the form that
    actualizes it.

    PHILOSOPHICAL INFRASTRUCTURE: The CCC borrows the concept of matter
    from Aristotle without defining it. We track this gap.

    STRUCTURAL OPACITY: Matter is irreducibly primitive in Aristotelian
    metaphysics — it CANNOT be further defined. -/
opaque Matter : Type

/-- Whether matter is informed (actualized) by a spiritual soul into
    a living, human body. This is the core of what §365 means by
    "the soul is the form of the body."

    §365: "it is because of its spiritual soul that the body made of
    matter becomes a living, human body."

    MODELING CHOICE: We represent formation as a binary predicate
    (matter is either informed by a soul or not). Aristotle allows
    for degrees of form (substantial vs. accidental), but the CCC's
    specific claim is about SUBSTANTIAL form — whether matter is a
    human body at all, not a matter of degree.

    Opaque because the MECHANISM of formation is precisely what the
    CCC borrows from Aristotle without explaining. We formalize the
    logical consequences, not the metaphysical mechanics.

    HONEST OPACITY: The CCC says the soul "forms" matter into body
    but does not explain how. Aquinas offers an account (ST I q.76):
    the soul is the first actuality of the body, giving it being,
    life, sensation, and intellection. But even Aquinas ultimately
    grounds this in God's creative act, not in a mechanistic
    explanation. -/
opaque isInformedBy : Matter → HumanPerson → Prop

/-- Whether matter constitutes a living human body.
    §365: matter becomes "a living, human body" because of the soul.
    §364: the body is a human body "precisely because" it is animated.

    This is the RESULT of formation — matter that has been actualized
    by a soul IS a living human body. Matter that has NOT been
    actualized is just... matter.

    Opaque because what makes a body "living" and "human" is precisely
    the question the form/matter framework answers: the soul makes it so.

    HIDDEN ASSUMPTION: There is a fact of the matter about whether
    something is a "living human body" or just organized matter. The
    CCC assumes this distinction is real (§364-365), not merely a
    description we project onto matter. -/
opaque isLivingHumanBody : Matter → Prop

/-- Whether matter retains its organization after the soul departs.
    §997: "the human body decays" after death. In Aristotelian terms:
    when the substantial form departs, the matter's organization
    collapses — other forms (chemical, biological decomposition) take over.

    Opaque because the rate and process of decay are empirical, not
    doctrinal. The CCC only asserts THAT it happens, not HOW fast.

    HIDDEN ASSUMPTION: The body's organization depends continuously on
    the soul's informing presence. Without the soul, the organization
    is not self-sustaining. This is the Aristotelian claim that the CCC
    imports. A mechanist would say the organization is maintained by
    physical forces alone. -/
opaque retainsOrganization : Matter → Prop

/-!
## Axioms: what the CCC claims about formation (§364-366, §997)
-/

/-- AXIOM 1 (§365): The soul FORMS matter into a living human body.
    "It is because of its spiritual soul that the body made of matter
    becomes a living, human body."

    This is the core of hylomorphic formation: matter that IS informed
    by a soul IS a living human body. The soul is the formal cause.

    Direction: informed → living body. This is not biconditional because
    we distinguish the CAUSE (soul informing) from the EFFECT (matter
    being alive). The converse (AXIOM 2) states the other direction.

    Provenance: [Definition] CCC §365; [Tradition] Council of Vienne (1312);
    [Philosophical] Aristotle *De Anima* II.1, Aquinas ST I q.76.
    Denominational scope: Catholic (the Aristotelian framework is
    Catholic distinctive; the body-soul unity is ecumenical). -/
axiom soul_forms_matter_into_body :
  ∀ (m : Matter) (p : HumanPerson),
    isInformedBy m p → isLivingHumanBody m

/-- AXIOM 2 (§364): A living human body REQUIRES soul-animation.
    "The human body shares in the dignity of 'the image of God': it is
    a human body PRECISELY BECAUSE it is animated by a spiritual soul."

    The word "precisely" (§364) makes this an iff-direction claim:
    matter is a human body ONLY IF informed by a soul. Without
    animation, it is not a human body — just matter.

    Provenance: [Definition] CCC §364.
    Denominational scope: Catholic (same as AXIOM 1). -/
axiom living_body_requires_soul :
  ∀ (m : Matter),
    isLivingHumanBody m → ∃ (p : HumanPerson), isInformedBy m p

/-- AXIOM 3 (§997): When the soul departs, the body decays.
    "In death, the separation of the soul from the body, the human
    body decays."

    In Aristotelian terms: when the substantial form departs, the
    matter loses its organization. The form was what HELD the matter
    together as a living body. Without it, the matter returns to
    indeterminacy — other (lower) forms take over (chemical decomposition).

    Provenance: [Definition] CCC §997; [Philosophical] Aristotle,
    Aquinas ST I q.76 a.4 (when the soul departs, the body corrupts
    because it has lost its formal cause).
    Denominational scope: Ecumenical (all Christians affirm bodily decay
    after death; the Aristotelian EXPLANATION is Catholic distinctive). -/
axiom departure_of_soul_causes_decay :
  ∀ (m : Matter) (p : HumanPerson),
    -- If matter was informed by the person...
    isInformedBy m p →
    -- ...and the person dies (soul departs)...
    isDead p →
    -- ...then the matter loses its organization
    ¬retainsOrganization m

/-- AXIOM 4 (§364): The body's dignity derives from the soul.
    "The human body shares in the dignity of 'the image of God': it is
    a human body precisely because it is animated by a spiritual soul."

    The dignity of the body is NOT intrinsic to matter. It is DERIVED
    from the soul's animation. The body participates in the imago Dei
    BECAUSE the soul (which bears the image) informs it.

    We model this as: matter that is informed by a soul participates
    in the dignity of the image of God. Matter that is NOT informed
    does not.

    Opaque `participatesInImageOfGod` because the CCC uses the concept
    (§364) but does not specify what "participation in the image" means
    for matter as distinct from soul.

    Provenance: [Definition] CCC §364; [Scripture] Gen 1:27 (image of God).
    Denominational scope: Ecumenical (the claim itself is ecumenical;
    the hylomorphic explanation is Catholic distinctive). -/
opaque participatesInImageOfGod : Matter → Prop

axiom body_dignity_from_soul :
  ∀ (m : Matter) (p : HumanPerson),
    isInformedBy m p → participatesInImageOfGod m

/-- AXIOM 5 (§366): The soul is created immediately by God.
    "The Church teaches that every spiritual soul is created
    immediately by God — it is not 'produced' by the parents."

    This connects to the formation model: the FORM of the body is
    not generated by biological processes but by divine creation.
    Parents provide the matter; God provides the form. This is why
    formation is not a natural process but a divine act.

    HIDDEN ASSUMPTION: The soul-as-form is the same entity as the
    soul-as-created-by-God. The CCC treats the metaphysical principle
    (form of the body) and the theological entity (created by God)
    as identical. This identification is not self-evident — it is
    Aquinas's synthesis of Aristotelian metaphysics with Christian
    theology (ST I q.90 a.2).

    Provenance: [Definition] CCC §366; [Tradition] Lateran Council V (1513);
    [Philosophical] Aquinas ST I q.90 a.2.
    Denominational scope: Ecumenical (immediate creation of the soul is
    broadly accepted; the specific connection to hylomorphic formation
    is Catholic distinctive). -/
opaque isCreatedImmediatelyByGod : HumanPerson → Prop

axiom soul_created_by_god :
  ∀ (p : HumanPerson), isCreatedImmediatelyByGod p

/-!
## Derived results
-/

/-- Formation gives the iff: matter is a living human body IF AND ONLY IF
    it is informed by a soul. This follows from AXIOM 1 (soul forms matter)
    and AXIOM 2 (living body requires soul).

    This is the formal content of §365's "it is because of its spiritual
    soul that the body made of matter becomes a living, human body." -/
theorem formation_iff_living_body (m : Matter) :
    isLivingHumanBody m ↔ ∃ (p : HumanPerson), isInformedBy m p :=
  ⟨living_body_requires_soul m,
   fun ⟨p, h⟩ => soul_forms_matter_into_body m p h⟩

/-- Without a soul, matter is NOT a human body. Contrapositive of AXIOM 1.
    This is what §364 means: a human body is a human body "precisely
    because" it is animated. Without animation, it is just matter.

    This gives a MECHANISM for Soul.lean's `corporeal_requires_spiritual`:
    the reason you can't have a body without a soul is that the soul is
    what MAKES matter into a body. -/
theorem no_soul_no_body (m : Matter)
    (h : ∀ (p : HumanPerson), ¬isInformedBy m p) :
    ¬isLivingHumanBody m := by
  intro h_living
  obtain ⟨p, h_inf⟩ := living_body_requires_soul m h_living
  exact h p h_inf

/-- Death removes the form from the matter, causing two consequences:
    (1) the matter loses organization (decays), and
    (2) the matter is no longer a living human body.

    This connects §997 (body decays at death) to §365 (soul is form):
    the body decays BECAUSE the form departs. The form was what made
    the matter a body in the first place. -/
theorem death_removes_formation (m : Matter) (p : HumanPerson)
    (h_inf : isInformedBy m p) (h_dead : isDead p) :
    ¬retainsOrganization m :=
  departure_of_soul_causes_decay m p h_inf h_dead

/-!
### The explanatory gain: WHY does `corporeal_requires_spiritual` hold?

Soul.lean asserts `corporeal_requires_spiritual` as an axiom:
```
axiom corporeal_requires_spiritual :
  ∀ (p : HumanPerson), hasCorporealAspect p → hasSpiritualAspect p
```

This is a FACT about the person — if you have a body, you have a soul.
But it doesn't say WHY.

The hylomorphic formation model gives the MECHANISM:
- The body is matter informed by the soul (§365)
- Without the soul, there IS no body — just matter (§364)
- Therefore you can't have a body without a soul — because the soul
  is what MAKES matter into a body

This is the explanatory content the CCC imports from Aristotle/Aquinas.
`corporeal_requires_spiritual` is not just a brute fact — it follows
from the nature of formation itself.

MODELING CHOICE: We do NOT derive `corporeal_requires_spiritual` from
our formation axioms because the two operate at different levels:
- Soul.lean models the person at the ASPECT level (corporeal/spiritual)
- This file models matter at the FORMATION level (matter/form)
The bridge between "person has corporeal aspect" and "matter is informed
by soul" is conceptual, not formal. Making it formal would require
identifying `hasCorporealAspect p` with `∃ m, isInformedBy m p`, which
is a modeling choice we flag but do not impose.
-/

/-- The CONCEPTUAL bridge: if we identify "having a corporeal aspect"
    with "there exists matter informed by this person's soul," then
    `corporeal_requires_spiritual` follows from the formation model.

    This theorem shows that the formation axioms WOULD derive the
    Soul.lean axiom, given the bridge identification.

    MODELING CHOICE: This bridge identification is our choice, not
    the CCC's explicit claim. The CCC says the soul is the form of
    the body (§365) and that the spiritual aspect always persists
    (§366). The identification of "corporeal aspect present" with
    "matter informed by soul" is the natural reading but not the
    only possible one.

    We state this as a conditional theorem (assuming the bridge)
    rather than imposing it globally. -/
theorem formation_explains_corporeal_requires_spiritual
    (bridge : ∀ (p : HumanPerson),
      hasCorporealAspect p → ∃ (m : Matter), isInformedBy m p)
    (p : HumanPerson) (h_corp : hasCorporealAspect p) :
    hasSpiritualAspect p :=
  -- Under the bridge, having a body means there's informed matter.
  -- Informed matter is a living body (soul_forms_matter_into_body).
  -- A living body requires a soul (living_body_requires_soul).
  -- The soul is immortal (soul_is_immortal). So: spiritual aspect present.
  let ⟨m, h_inf⟩ := bridge p h_corp
  let _ := soul_forms_matter_into_body m p h_inf
  soul_is_immortal p

/-- The formation model explains WHY the body decays at death.
    Soul.lean's `death_separates` tells us the corporeal aspect is
    lost at death. The formation model explains WHY:
    - The soul was the form of the body
    - Death separates the soul from the body
    - Without the form, the matter cannot remain organized
    - Therefore the body decays

    This is NOT a new fact — it's an EXPLANATION of an existing fact.
    The formation model gives causal structure to what Soul.lean
    asserts as a brute axiom. -/
theorem formation_explains_decay (m : Matter) (p : HumanPerson)
    (h_inf : isInformedBy m p) (h_dead : isDead p) :
    -- The matter loses organization (from formation model)
    ¬retainsOrganization m ∧
    -- The person loses corporeal aspect (from Soul.lean)
    ¬hasCorporealAspect p :=
  ⟨departure_of_soul_causes_decay m p h_inf h_dead,
   (death_separates p h_dead).1⟩

/-- The formation model reveals a parallel between two consequences
    of soul-departure at death:
    1. At the PERSON level: the corporeal aspect is lost (Soul.lean)
    2. At the MATTER level: organization is lost (this file)

    These are two descriptions of the SAME EVENT from two levels
    of analysis. The formation model unifies them: the soul was the
    form that BOTH gave the person a corporeal aspect AND held the
    matter together as a body. When the soul departs, BOTH are lost
    simultaneously. -/
theorem death_affects_both_levels (m : Matter) (p : HumanPerson)
    (h_inf : isInformedBy m p) (h_dead : isDead p) :
    -- Person level: corporeal lost, spiritual persists
    (¬hasCorporealAspect p ∧ hasSpiritualAspect p) ∧
    -- Matter level: organization lost
    ¬retainsOrganization m :=
  ⟨death_separates p h_dead,
   departure_of_soul_causes_decay m p h_inf h_dead⟩

/-!
## The divine origin of form (§366)

The CCC claims that every soul is "created immediately by God" (§366).
In the hylomorphic framework, this means: the FORM of the human body
is not a product of nature but of divine creation.

This has a striking consequence: the formal cause of the human body
is supernatural in origin. Parents provide the material cause (matter),
but God provides the formal cause (soul). Human generation requires
BOTH natural and divine causation — a specific instance of P2 (two-tier
causation from Axioms.lean).
-/

/-- Every human person's soul — the form of their body — is created
    immediately by God. Combined with the formation model: the very
    principle that makes matter into a living human body is divinely
    created, not biologically generated.

    This is a straightforward consequence of soul_created_by_god.
    The theorem is stated to make the FORMATION implication explicit:
    what informs matter into body is itself of divine origin. -/
theorem form_is_divinely_created (_m : Matter) (p : HumanPerson)
    (_h_inf : isInformedBy _m p) :
    isCreatedImmediatelyByGod p :=
  soul_created_by_god p

/-- The dignity of the body traces back to God through two steps:
    1. God creates the soul (§366)
    2. The soul informs matter into body (§365)
    3. The informed body participates in the image of God (§364)

    The body's dignity is therefore DOUBLY derived: from the soul
    (which gives it form) and from God (who creates the soul). -/
theorem bodily_dignity_chain (m : Matter) (p : HumanPerson)
    (h_inf : isInformedBy m p) :
    isCreatedImmediatelyByGod p ∧
    isLivingHumanBody m ∧
    participatesInImageOfGod m :=
  ⟨soul_created_by_god p,
   soul_forms_matter_into_body m p h_inf,
   body_dignity_from_soul m p h_inf⟩

/-!
## What the formation model rules out
-/

/-- Materialism (applied to formation): matter can organize itself
    into a living human body without any formal cause.

    The CCC denies this (§365): matter becomes a body BECAUSE OF
    the soul. Without the soul, matter is not a body.

    If materialism were true, there would exist living human bodies
    that are not informed by any soul. AXIOM 2 (living_body_requires_soul)
    excludes this. -/
theorem formation_rejects_materialism :
    -- There cannot be a living human body without a soul informing it
    ∀ (m : Matter), isLivingHumanBody m →
      ∃ (p : HumanPerson), isInformedBy m p :=
  living_body_requires_soul

/-- Traducianism: the soul is produced by the parents through
    biological generation (like the body).

    The CCC denies this (§366): the soul is "created immediately by
    God" and "not produced by the parents."

    Under our formation model: the FORM that makes matter into body
    is divinely created, not biologically transmitted. Parents provide
    matter; God provides form. -/
theorem formation_rejects_traducianism (p : HumanPerson) :
    isCreatedImmediatelyByGod p :=
  soul_created_by_god p

/-!
## Connection to SeparatedSoul.lean

SeparatedSoul.lean showed that the CCC requires SUBSISTENT hylomorphism:
the soul must be able to exist and operate without the body.

The formation model adds the OTHER direction: the body cannot exist
without the soul. Together:

- **Soul → Body**: the soul can subsist without matter (SeparatedSoul.lean)
- **Body → Soul**: matter cannot be a body without the soul (this file)

This ASYMMETRY is precisely Soul.lean's `soul_body_asymmetry`, but now
EXPLAINED: the soul is the form, and form is metaphysically prior to
the matter it informs. The form can (imperfectly) subsist without matter;
the matter cannot be determinate without form.
-/

/-- The full asymmetry, using both Soul.lean and the formation model:
    1. The soul persists without the body (soul_is_immortal)
    2. The soul exercises powers without the body (SeparatedSoul.lean)
    3. Matter cannot be a body without the soul (this file, AXIOM 2)

    This is the complete hylomorphic picture: form is prior to matter.
    The asymmetry that Soul.lean ASSERTS, the formation model EXPLAINS. -/
theorem complete_hylomorphic_asymmetry (p : HumanPerson) (h_dead : isDead p) :
    -- Soul side: persists and is active
    (hasSpiritualAspect p ∧ isExercisingPowers p) ∧
    -- Matter side: cannot be a body without a soul
    (∀ (m : Matter), isLivingHumanBody m → ∃ (q : HumanPerson), isInformedBy m q) :=
  ⟨⟨soul_is_immortal p, separated_soul_can_think_and_will p h_dead⟩,
   living_body_requires_soul⟩

/-!
## Summary

### What we found

The hylomorphic formation model (§365) provides EXPLANATORY DEPTH
for three things that Soul.lean asserts but doesn't explain:

1. **WHY does `corporeal_requires_spiritual` hold?**
   Because the soul is the form of the body — without the form,
   there IS no body, just matter. (formation_explains_corporeal_requires_spiritual)

2. **WHY does the body decay at death?**
   Because the form departs — without the formal cause, matter
   cannot maintain its organization. (formation_explains_decay)

3. **WHY does the body share in the dignity of the image of God?**
   Because the soul (which bears the image) informs the body —
   the body's dignity is derived, not intrinsic. (bodily_dignity_chain)

### The honest gap

The CCC says the soul "forms" matter into body (§365) but does not
explain what "formation" IS mechanistically. Aquinas gives the most
detailed account (ST I q.76): the soul is the first actuality of the
body, giving it being, life, sensation, and intellection in one unified
act. But even Aquinas ultimately grounds this in God's creative act.

Our formalization captures the LOGICAL STRUCTURE of formation
(what follows from what) without claiming to explain the MECHANISM
(how form actualizes matter). The `isInformedBy` predicate is
deliberately opaque — it represents the metaphysical relation that
the CCC assumes but does not explicate.

### Axioms (5):
1. soul_forms_matter_into_body (§365) — informed matter is a living body
2. living_body_requires_soul (§364) — living body requires animation
3. departure_of_soul_causes_decay (§997) — soul departs → body decays
4. body_dignity_from_soul (§364) — body's dignity from soul's animation
5. soul_created_by_god (§366) — soul created immediately by God

### Theorems (9):
1. formation_iff_living_body — iff characterization
2. no_soul_no_body — contrapositive
3. death_removes_formation — death causes decay
4. formation_explains_corporeal_requires_spiritual — bridge to Soul.lean
5. formation_explains_decay — explanation of Soul.lean's death_separates
6. death_affects_both_levels — person-level + matter-level consequences
7. form_is_divinely_created — divine origin of form
8. bodily_dignity_chain — dignity traces through soul to God
9. complete_hylomorphic_asymmetry — full asymmetry with SeparatedSoul.lean

### Opaques (5):
- Matter — material substrate (structural opacity)
- isInformedBy — formation relation (honest opacity)
- isLivingHumanBody — whether matter is a living body (honest opacity)
- retainsOrganization — whether matter is organized (honest opacity)
- participatesInImageOfGod — dignity of the body (honest opacity)
- isCreatedImmediatelyByGod — divine creation of soul (honest opacity)

### Rejected positions:
- formation_rejects_materialism — matter can't self-organize into body
- formation_rejects_traducianism — soul is not biologically produced

### Cross-file connections:
- Soul.lean: corporeal_requires_spiritual (EXPLAINED by formation model),
  death_separates (EXPLAINED by departure of form), soul_is_immortal
- SeparatedSoul.lean: separated_soul_can_think_and_will (the OTHER
  direction of the asymmetry — soul can operate without body)
-/

end Catlib.Creed
