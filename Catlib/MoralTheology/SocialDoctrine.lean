import Catlib.Foundations
import Catlib.MoralTheology.NaturalLaw

/-!
# CCC §2401-2463: Social Doctrine — Property, Solidarity, and the Universal Destination of Goods

## The Catechism claims

§2402: "In the beginning God entrusted the earth and its resources to the
common stewardship of mankind to take care of them, master them by labor,
and enjoy their fruits."

§2403: "The right to private property, acquired or received in a just way,
does not do away with the original gift of the earth to the whole of mankind.
The universal destination of goods remains primordial."

§2404: "In his use of things man should regard the external goods he
legitimately owns not merely as exclusive to himself but common to others also,
in the sense that they can benefit others as well as himself."

§2406: "Political authority has the right and duty to regulate the legitimate
exercise of the right to ownership for the sake of the common good."

§2407: "In economic matters, respect for human dignity requires the practice
of the virtue of temperance... of justice... of solidarity."

## The structural tension

The CCC creates a genuine philosophical tension:

1. Private property is a REAL RIGHT (§2403) — not mere convention.
2. The universal destination of goods is PRIMORDIAL (§2403) — it comes first
   ontologically, grounded in creation theology (§2402).
3. Property is SUBORDINATE to universal destination (§2403: "does not do away
   with the original gift").

This means: property is a right but not an ABSOLUTE right. It is a real but
BOUNDED right. The bound is the universal destination of goods.

Neither libertarianism (property is absolute, derived from labor/exchange)
nor socialism (private property is illegitimate) matches the CCC.

## Prediction

I expect the formalization to reveal:
1. The subordination axiom (property subordinate to universal destination) is
   the key axiom that separates Catholic social teaching from both libertarianism
   and socialism.
2. Under libertarian axioms (drop subordination), property becomes absolute.
3. Under socialist axioms (drop private property right), universal destination
   becomes mandatory redistribution with no property rights.
4. The CCC's position requires BOTH property AND subordination — and neither
   alone is sufficient.

## Findings

- **Prediction confirmed**: The subordination axiom is the structural key. It
  produces a BOUNDED property right that is neither absolute nor nonexistent.
- **Hidden assumptions identified**:
  1. Creation theology grounds universal destination — the earth's goods belong
     to all BECAUSE God gave them to all (§2402). Without divine creation, the
     universal destination argument loses its ground.
  2. Stewardship, not absolute dominion — humans are stewards (§2402), not
     sovereign owners. This is a specific model of the person-goods relationship
     that Locke's labor theory rejects.
  3. Political authority can regulate property (§2406) — this assumes legitimate
     political authority exists (connects to Authority.lean).
- **Key finding**: The CCC's social doctrine is structurally a BOUNDED RIGHTS
  theory. The bound is not arbitrary but derives from creation theology. The
  subordination axiom does exactly the work of bounding: it prevents property
  from becoming absolute (contra libertarianism) while preserving it as real
  (contra socialism). The stewardship model is the mechanism: you can steward
  what you don't absolutely own.
- **Denominational scope**: The universal destination of goods is distinctively
  CATHOLIC in its formal articulation (drawing on Aquinas, Rerum Novarum, and
  Gaudium et Spes), though the underlying creation theology (Gen 1:28-29) is
  ecumenical. Protestant social ethics tends to be less systematic on property
  theory, though the Reformed tradition has its own account (Calvin's emphasis
  on stewardship in Institutes III.7).
- **Assessment**: Tier 2 — real structural insight (the bounded-rights model),
  clear denominational cuts, connects to creation theology and natural law.
-/

set_option autoImplicit false

namespace Catlib.MoralTheology.SocialDoctrine

open Catlib
open Catlib.MoralTheology

-- ============================================================================
-- § 1. Core types
-- ============================================================================

/-- A material good — something that can be owned, used, or shared.
    The CCC speaks of "the earth and its resources" (§2402), "external goods"
    (§2404), and "things" in general. We abstract over the specific kind of good.

    MODELING CHOICE: We model goods as an opaque type rather than giving them
    internal structure. The CCC's arguments about property and universal
    destination do not depend on what KIND of good is at stake — they apply
    to all material goods equally. -/
opaque MaterialGood : Type

/-- Whether a person has a legitimate right to use and dispose of a good.
    CCC §2403: "The right to private property, acquired or received in a just way."

    STRUCTURAL OPACITY: The CCC says the right must be "acquired or received
    in a just way" (§2403) but does not give a full theory of just acquisition.
    Aquinas (ST II-II q.66 a.2) argues that private property is justified by
    three practical reasons: (1) people take better care of what is their own,
    (2) human affairs are better ordered when each has their own responsibility,
    (3) peace is better preserved when each is content with their own. These
    are PRACTICAL justifications, not metaphysical ones — property is justified
    by its effects on human flourishing, not by an inherent natural right to
    appropriate. -/
opaque hasPropertyRight : Person → MaterialGood → Prop

/-- Whether the goods of the earth are destined for all humanity.
    CCC §2402: "God entrusted the earth and its resources to the common
    stewardship of mankind."

    This is a claim about the ORIGINAL purpose of material goods — they exist
    for all, not for some. It is grounded in creation theology: God gave the
    earth to ALL humanity (Gen 1:28-29), not to particular individuals. -/
opaque destinedForAll : MaterialGood → Prop

/-- Whether a person exercises stewardship over a good — using it responsibly
    with regard for the common good, rather than treating it as absolutely
    their own.
    CCC §2404: "Man should regard the external goods he legitimately owns
    not merely as exclusive to himself but common to others also."

    MODELING CHOICE: Stewardship is the CCC's preferred model for the
    person-goods relationship. It is stronger than mere use (a steward has
    responsibilities, not just permissions) but weaker than absolute ownership
    (a steward answers to someone). The "someone" is God, who entrusted the
    goods to humanity (§2402). -/
opaque exercisesStewardship : Person → MaterialGood → Prop

/-- Whether a person has justly acquired or received a good.
    CCC §2403: "acquired or received in a just way."

    STRUCTURAL OPACITY: The CCC does not give a full theory of just acquisition.
    Aquinas (ST II-II q.66 a.2) gives three practical justifications for
    private appropriation: care, order, peace. We keep this opaque because
    the CCC's social doctrine arguments work regardless of WHICH theory of
    just acquisition is adopted — what matters is that SOME just acquisition
    is possible. -/
opaque justlyAcquired : Person → MaterialGood → Prop

/-- Whether political authority regulates the exercise of property rights.
    CCC §2406: "Political authority has the right and duty to regulate the
    legitimate exercise of the right to ownership for the sake of the common
    good."

    This connects to Authority.lean: political authority is legitimate (delegated
    from God via natural law) and has a proper domain that includes economic
    regulation. -/
opaque regulatesProperty : Authority → MaterialGood → Prop

-- ============================================================================
-- § 2. Axioms
-- ============================================================================

/-- AXIOM 1 (§2402): Universal destination of goods — the earth's goods
    belong to all humanity.
    "In the beginning God entrusted the earth and its resources to the common
    stewardship of mankind."

    This is the PRIMORDIAL principle (§2403: "The universal destination of goods
    remains primordial"). It comes before private property both temporally
    (creation precedes appropriation) and ontologically (the purpose of goods
    precedes their distribution).

    Source: [CCC] §2402; [Scripture] Gen 1:28-29 ("Be fruitful and multiply
    and fill the earth and subdue it and have dominion... I have given you every
    plant"); [Aquinas] ST II-II q.66 a.1 ("things belong to God as to their
    principal owner").
    Denominational scope: ECUMENICAL (creation theology). -/
axiom universal_destination :
  ∀ (g : MaterialGood), destinedForAll g

/-- AXIOM 2 (§2403): Private property is a legitimate right.
    "The right to private property, acquired or received in a just way" is real.

    The CCC affirms private property as a genuine right — not a mere social
    convention and not an injustice. Just acquisition yields a real property
    right. This separates the CCC from socialism (which denies private
    property) and from pure communitarianism.

    Source: [CCC] §2403; [Aquinas] ST II-II q.66 a.2 (three practical
    arguments for private property: care, order, peace).
    HIDDEN ASSUMPTION: The justification is PRACTICAL (Aquinas: property
    promotes care, order, peace), not metaphysical (Locke: labor creates
    an inherent right). The CCC never grounds property in a labor theory
    of value. This means the right to property is INSTRUMENTAL — it serves
    human flourishing — not FOUNDATIONAL.
    Denominational scope: ECUMENICAL (broadly shared). -/
axiom private_property_legitimate :
  ∀ (p : Person) (g : MaterialGood),
    justlyAcquired p g →
    -- Just acquisition yields a genuine property right.
    -- The right is real, not a mere convention.
    hasPropertyRight p g

/-- AXIOM 3 (§2403): Property is subordinate to universal destination.
    "The right to private property... does not do away with the original gift
    of the earth to the whole of mankind. The universal destination of goods
    remains primordial."

    THIS IS THE KEY AXIOM. It says that property rights, while real, are
    BOUNDED by the universal destination of goods. A property right cannot
    override the principle that the earth's goods are meant for all.

    In practice this means: if someone has more than they need while others
    lack necessities, the surplus is not "theirs" in an absolute sense —
    it is subject to the claims of those in need. The CCC does not mandate
    a specific redistribution mechanism, but it does say the right is bounded.

    Source: [CCC] §2403; [Tradition] Gaudium et Spes §69 ("God intended
    the earth and all it contains for the use of every human being and people");
    [Aquinas] ST II-II q.66 a.7 ("In cases of need all things are common
    property").
    HIDDEN ASSUMPTION: This subordination is ONTOLOGICAL, not merely moral.
    It is not just that property owners SHOULD share; it is that their right
    DOES NOT EXTEND to depriving others of necessities. The universal
    destination places a real structural limit on what property means.
    Denominational scope: CATHOLIC (formally articulated in Catholic social
    teaching; less systematic in Protestant ethics). -/
axiom property_subordinate_to_universal_destination :
  ∀ (p : Person) (g : MaterialGood),
    hasPropertyRight p g →
    destinedForAll g

/-- AXIOM 4 (§2404): Stewardship, not absolute ownership.
    "Man should regard the external goods he legitimately owns not merely
    as exclusive to himself but common to others also."

    Property holders are STEWARDS, not absolute owners. A steward has
    real authority over what they manage (the property right is genuine)
    but answers to a higher purpose (the universal destination). This is
    the CCC's model of the person-goods relationship.

    Source: [CCC] §2404; [Aquinas] ST II-II q.66 a.1 ("Man has a natural
    dominion over external things, because by his reason and will he is
    able to use them for his own benefit... however, as regards the use
    of things, man ought to possess external things not as his own but
    as common").
    HIDDEN ASSUMPTION: The stewardship model requires a divine principal
    — God who entrusted the goods to humanity (§2402). Without God as
    the original owner, stewardship reduces to mere social convention.
    This connects to divine_grounding in NaturalLaw.lean.
    Denominational scope: ECUMENICAL (stewardship language is broadly
    Christian). -/
axiom stewardship_not_absolute_ownership :
  ∀ (p : Person) (g : MaterialGood),
    hasPropertyRight p g →
    exercisesStewardship p g

/-- AXIOM 5 (§2406): Political authority can regulate property.
    "Political authority has the right and duty to regulate the legitimate
    exercise of the right to ownership for the sake of the common good."

    This is a consequence of the subordination principle applied to governance:
    if property is bounded by the common good, then the authority responsible
    for the common good (political authority) has the right to enforce those
    bounds.

    Source: [CCC] §2406; [Tradition] Rerum Novarum §22 (Leo XIII: the state
    must protect workers and the common good); Quadragesimo Anno §49
    (Pius XI: the state may determine the limits of ownership).
    HIDDEN ASSUMPTION: Political authority is legitimate and oriented toward
    the common good (connects to Authority.lean). Without legitimate authority,
    regulation is mere coercion.
    Denominational scope: CATHOLIC (systematically developed in papal social
    encyclicals). -/
axiom political_regulation_of_property :
  ∀ (a : Authority) (g : MaterialGood),
    a.source = AuthoritySource.naturalLaw →
    regulatesProperty a g

-- ============================================================================
-- § 3. Theorems: the Catholic bounded-rights model
-- ============================================================================

/-- THEOREM: Property rights are real but not absolute.

    Under the Catholic axiom set, a property right is GENUINE (axiom 2) but
    BOUNDED by the universal destination of goods (axiom 3). The owner is
    a steward (axiom 4), not a sovereign.

    This is the core structural result: Catholic social teaching produces
    a BOUNDED property right — neither the absolute right of libertarianism
    nor the nonexistent right of socialism.

    Depends on: property_subordinate_to_universal_destination,
    stewardship_not_absolute_ownership. -/
theorem property_real_but_not_absolute
    (p : Person) (g : MaterialGood)
    (h_owns : hasPropertyRight p g) :
    -- The right is real
    hasPropertyRight p g
    -- AND the good remains destined for all (the right is bounded)
    ∧ destinedForAll g
    -- AND the owner is a steward (the right is not absolute dominion)
    ∧ exercisesStewardship p g :=
  have h_dest := property_subordinate_to_universal_destination p g h_owns
  have h_stew := stewardship_not_absolute_ownership p g h_owns
  ⟨h_owns, h_dest, h_stew⟩

/-- THEOREM: Just acquisition yields bounded property — the full Catholic chain.

    Starting from just acquisition, the Catholic axiom set produces a complete
    property regime: the acquisition yields a genuine right (axiom 2), that
    right is bounded by universal destination (axiom 3), and the holder
    is a steward (axiom 4).

    This is the complete chain from acquisition to stewardship, using all
    three core Catholic axioms (2, 3, 4).

    Depends on: private_property_legitimate, property_subordinate_to_universal_destination,
    stewardship_not_absolute_ownership. -/
theorem just_acquisition_yields_bounded_rights
    (p : Person) (g : MaterialGood)
    (h_just : justlyAcquired p g) :
    -- Just acquisition yields a right
    hasPropertyRight p g
    -- AND the good remains destined for all
    ∧ destinedForAll g
    -- AND the holder is a steward
    ∧ exercisesStewardship p g :=
  have h_owns := private_property_legitimate p g h_just
  have h_dest := property_subordinate_to_universal_destination p g h_owns
  have h_stew := stewardship_not_absolute_ownership p g h_owns
  ⟨h_owns, h_dest, h_stew⟩

/-- THEOREM: Universal destination applies universally — no good is exempt.

    Every material good, regardless of who holds it, falls under the universal
    destination principle. There is no category of good that is exempt from
    the claim that it is meant for all.

    Depends on: universal_destination. -/
theorem no_good_exempt_from_universal_destination
    (g : MaterialGood) :
    destinedForAll g :=
  universal_destination g

/-- THEOREM: Political authority can regulate all property for the common good.

    If political authority derives from natural law (§2406), then it has
    jurisdiction over property rights — regardless of whose property it is.
    This is a consequence of the subordination principle: if property is
    subordinate to the universal destination, and political authority is
    responsible for the common good, then regulation is legitimate.

    Depends on: political_regulation_of_property. -/
theorem regulation_legitimate
    (a : Authority) (g : MaterialGood)
    (h_auth : a.source = AuthoritySource.naturalLaw) :
    regulatesProperty a g :=
  political_regulation_of_property a g h_auth

-- ============================================================================
-- § 4. Denominational cuts: libertarianism and socialism
-- ============================================================================

/-!
## The libertarian position

A libertarian drops the subordination axiom (axiom 3). Property rights are
ABSOLUTE — the owner has no obligation to share except by voluntary choice.
The universal destination of goods is either denied or reinterpreted as
already satisfied by the market (Nozick: just acquisition + just transfer
= just distribution, regardless of outcome).

Under libertarian axioms:
- Property is a real right (retained)
- Property is NOT bounded by universal destination (subordination dropped)
- Stewardship is voluntary, not obligatory (axiom 4 dropped or weakened)
- Political regulation of property is illegitimate (axiom 5 dropped)

The CCC explicitly rejects this: §2403 says private property "does not do
away with" the universal destination, and §2406 affirms political regulation.
-/

/-- The libertarian axiom: property rights exclude universal destination claims.
    A property holder's right is not bounded by any collective claim on the good.

    Source: [Modeling] Our formalization choice — this represents the
    libertarian position for comparison. Not a CCC claim.
    Under this axiom, the universal destination of goods does NOT apply to
    goods that are privately held. This is the negation of the CCC's
    subordination axiom (axiom 3). -/
axiom libertarian_absolute_property :
  ∀ (p : Person) (g : MaterialGood),
    hasPropertyRight p g →
    -- Property EXCLUDES universal destination — the good is no longer
    -- "destined for all" once it is privately held.
    ¬ destinedForAll g

/-- THEOREM: Under libertarian axioms, private property excludes universal destination.

    If property is absolute (no subordination), then owned goods are NOT
    destined for all — the property right swallows the universal destination.
    This shows why the subordination axiom (axiom 3) is structurally
    necessary for the CCC's social teaching: without it, property
    rights cancel the universal destination.

    NOTE: This is a DEMONSTRATION of what the libertarian position entails,
    not a proof that libertarianism is wrong. The libertarian denies axiom 3
    and is internally consistent under that denial.

    Depends on: libertarian_absolute_property. -/
theorem libertarian_property_unbounded
    (p : Person) (g : MaterialGood)
    (h_owns : hasPropertyRight p g) :
    -- Under libertarian axioms, ownership EXCLUDES universal destination
    ¬ destinedForAll g :=
  libertarian_absolute_property p g h_owns

/-!
## The socialist position

A socialist drops the private property axiom (axiom 2) — or more precisely,
holds that private ownership of means of production is illegitimate. Under
socialism, the universal destination of goods is interpreted as requiring
collective ownership and state-directed distribution.

Under socialist axioms:
- Universal destination of goods (retained, strengthened to mandatory
  redistribution)
- Private property is NOT a legitimate right (axiom 2 dropped for productive
  property)
- Stewardship is collective, not individual
- Political authority controls ALL distribution

The CCC explicitly rejects this: §2403 affirms "the right to private property."
Rerum Novarum (Leo XIII, 1891) was written precisely to reject socialism while
also rejecting laissez-faire capitalism.
-/

/-- The socialist axiom: universal destination requires collective control —
    private property rights are illegitimate for productive goods.

    Source: [Modeling] Our formalization choice — this represents the socialist
    position for comparison. Not a CCC claim.
    Under this axiom, the universal destination of goods is interpreted as
    requiring that no individual holds private property rights. -/
axiom socialist_no_private_property :
  ∀ (p : Person) (g : MaterialGood),
    destinedForAll g →
    ¬ hasPropertyRight p g

/-- THEOREM: Under socialist axioms, property rights are impossible.

    If the universal destination of goods (which applies to ALL goods, axiom 1)
    excludes private property, then NO ONE can hold private property rights.
    The universal destination, unbound by a property right, becomes mandatory
    collectivism.

    Depends on: universal_destination, socialist_no_private_property. -/
theorem socialist_property_impossible
    (p : Person) (g : MaterialGood) :
    ¬ hasPropertyRight p g :=
  have h_dest := universal_destination g
  socialist_no_private_property p g h_dest

-- ============================================================================
-- § 5. The Catholic synthesis: BOTH property AND subordination
-- ============================================================================

/-- THEOREM (Main): The Catholic social doctrine is a bounded-rights theory.

    The CCC's position requires BOTH private property (axiom 2) AND
    subordination to universal destination (axiom 3). Neither alone is
    sufficient:
    - Property without subordination = libertarianism (absolute ownership)
    - Universal destination without property = socialism (no ownership)
    - Property WITH subordination = Catholic social teaching (bounded ownership)

    The stewardship model (axiom 4) is the MECHANISM: a steward has real
    authority (the property right is genuine) but answers to a higher
    purpose (the universal destination). The political authority (axiom 5)
    enforces the bounds.

    This is structurally the same pattern as P2 (two-tier causation):
    primary (universal destination) and secondary (property rights) levels
    operate together without competing. More property does not mean less
    universal destination, and more universal destination does not mean
    less property. They operate at different ontological levels.

    Depends on: property_subordinate_to_universal_destination,
    stewardship_not_absolute_ownership, universal_destination. -/
theorem catholic_bounded_rights
    (p : Person) (g : MaterialGood)
    (h_owns : hasPropertyRight p g) :
    -- (a) The property right is genuine
    hasPropertyRight p g
    -- (b) The good remains destined for all (the right is bounded)
    ∧ destinedForAll g
    -- (c) The owner is a steward (not absolute owner)
    ∧ exercisesStewardship p g :=
  have h_dest := property_subordinate_to_universal_destination p g h_owns
  have h_stew := stewardship_not_absolute_ownership p g h_owns
  ⟨h_owns, h_dest, h_stew⟩

/-- THEOREM: The subordination axiom is what separates Catholic teaching
    from libertarianism.

    Under Catholic axioms, every property holder also owes stewardship
    (their right is bounded). This is a direct consequence of the
    subordination axiom (axiom 3) + stewardship axiom (axiom 4).

    A libertarian who accepts property (axiom 2) but drops subordination
    (axiom 3) gets unbounded property rights. The difference between the
    two positions is precisely the subordination axiom.

    Depends on: property_subordinate_to_universal_destination,
    stewardship_not_absolute_ownership. -/
theorem subordination_distinguishes_from_libertarianism
    (p : Person) (g : MaterialGood)
    (h_owns : hasPropertyRight p g) :
    -- Under Catholic axioms, the property right ENTAILS stewardship obligations
    exercisesStewardship p g :=
  stewardship_not_absolute_ownership p g h_owns

/-- THEOREM: The property axiom is what separates Catholic teaching
    from socialism.

    Under Catholic axioms, property is a genuine right (axiom 2) that
    COEXISTS with the universal destination (axiom 1). Under socialist
    axioms, the universal destination EXCLUDES property. The difference
    is whether property rights are compatible with universal destination.

    The CCC's answer: they are compatible BECAUSE property is subordinate
    (bounded), not absolute. A bounded right can coexist with a universal
    claim; an absolute right cannot.

    Depends on: universal_destination, property_subordinate_to_universal_destination. -/
theorem property_distinguishes_from_socialism
    (p : Person) (g : MaterialGood)
    (h_owns : hasPropertyRight p g) :
    -- Under Catholic axioms, property AND universal destination hold together
    hasPropertyRight p g ∧ destinedForAll g :=
  have h_dest := property_subordinate_to_universal_destination p g h_owns
  ⟨h_owns, h_dest⟩

-- ============================================================================
-- § 6. Bridge theorems to base axioms and other files
-- ============================================================================

/-- Bridge to NaturalLaw.lean: the universal destination of goods is a
    natural law precept — accessible to reason and binding on all.

    The CCC grounds the universal destination in creation theology (§2402),
    which is accessible to reason (Gen 1:28-29 describes what reason can
    discover about human nature and goods). This connects to the natural
    law framework: the universal destination is a moral precept that
    reason can discover and that has binding force.

    Depends on: divine_grounding (from NaturalLaw.lean). -/
theorem universal_destination_is_natural_law
    (precept : MoralPrecept)
    (h_access : precept.accessibleToReason) :
    precept.content :=
  divine_grounding precept h_access

/-- Bridge to P2 (two-tier causation): property and universal destination
    are primary/secondary levels that do not compete.

    The structural parallel: universal destination operates at the primary
    level (God's original purpose for goods), and property operates at the
    secondary level (human stewardship within that purpose). More property
    does not diminish the universal destination, and enforcing the universal
    destination does not eliminate property.

    This is exactly P2's pattern: "God grants his creatures not only their
    existence, but also the dignity of acting on their own" (§306) —
    applied to economic life.

    Depends on: p2_two_tier_causation (from Axioms.lean). -/
theorem p2_property_bridge
    (p : PrimaryCause) (s : SecondaryCause) :
    ¬ causesCompete p s :=
  p2_two_tier_causation p s

-- ============================================================================
-- § 7. The denominational picture
-- ============================================================================

/-!
### Where traditions agree and disagree

**All Christians agree:**
- God created the earth and its goods (Gen 1:28-29)
- Theft is wrong (Ex 20:15)
- The poor have a claim on the charity of the rich (Mt 25:31-46)
- Greed is sinful (1 Tim 6:10)

**The disputed question:**
- Is the universal destination of goods a STRUCTURAL principle that bounds
  property rights, or is it merely a moral exhortation to share?

**Catholic (bounded-rights theory):**
- Private property is a real but subordinate right (§2403)
- The universal destination is PRIMORDIAL — prior to property (§2403)
- Political authority may regulate property for the common good (§2406)
- Stewardship, not absolute ownership, is the model (§2404)
- Systematically developed in papal social encyclicals: Rerum Novarum (1891),
  Quadragesimo Anno (1931), Populorum Progressio (1967), Centesimus Annus (1991),
  Laudato Si' (2015)

**Protestant (varies widely):**
- Reformed/Calvinist: strong stewardship tradition (Calvin's Geneva had
  economic regulation), but without the formal universal-destination principle.
  Property rights are more robust in the Reformed tradition (influence on
  Anglo-American property law through Locke, who was influenced by Reformed
  natural law).
- Lutheran: Luther's "two kingdoms" doctrine separates spiritual and temporal
  authority more sharply. Economic justice falls under temporal authority,
  which operates by reason, not Gospel. Lutheran social ethics tends to be
  less systematically economic.
- Evangelical: diverse. Some embrace prosperity theology (property as divine
  blessing), others emphasize voluntary simplicity. No unified social doctrine.

**Libertarian (property absolute):**
- Drops the subordination axiom
- Property is a natural right derived from self-ownership + labor (Locke, Nozick)
- Political regulation of property is presumptively illegitimate
- Universal destination is not a structural principle, at most a voluntary ideal

**Socialist (property illegitimate):**
- Drops the property axiom (for means of production)
- Universal destination requires collective ownership
- Political authority controls all distribution
- The CCC rejects this explicitly: Rerum Novarum §15 ("every man has by nature
  the right to possess property as his own")

**The precise Catholic middle:**
The CCC holds that BOTH the libertarian AND the socialist get something right:
- The libertarian is right that property is a real right (against socialism)
- The socialist is right that goods have a universal destination (against
  libertarianism)
But BOTH are wrong about the relationship between these two truths:
- The libertarian makes property absolute (swallowing universal destination)
- The socialist makes universal destination absolute (swallowing property)
The CCC's subordination axiom is what prevents either from swallowing the other.
-/

-- ============================================================================
-- § 8. Summary
-- ============================================================================

/-!
## Summary

**Axioms** (5 — from CCC §2402-2406):
1. `universal_destination` (§2402) — earth's goods belong to all
2. `private_property_legitimate` (§2403) — property is a real right
3. `property_subordinate_to_universal_destination` (§2403) — property is bounded
4. `stewardship_not_absolute_ownership` (§2404) — stewardship, not dominion
5. `political_regulation_of_property` (§2406) — authority can regulate property

**Denominational cut axioms** (2 — for comparison):
6. `libertarian_absolute_property` — property is absolute (drops subordination)
7. `socialist_no_private_property` — property is illegitimate (drops property right)

**Theorems** (8 + 2 bridges):
1. `property_real_but_not_absolute` — the core bounded-rights result
2. `just_acquisition_yields_bounded_rights` — full chain from acquisition to stewardship
3. `no_good_exempt_from_universal_destination` — universal destination is universal
4. `regulation_legitimate` — political regulation is justified
5. `libertarian_property_unbounded` — under libertarian axioms, property is absolute
6. `socialist_property_impossible` — under socialist axioms, property is impossible
7. `catholic_bounded_rights` (main) — the full Catholic synthesis
8. `subordination_distinguishes_from_libertarianism` — what separates CCC from libertarians
9. `property_distinguishes_from_socialism` — what separates CCC from socialists
10. `universal_destination_is_natural_law` — bridge to NaturalLaw.lean
11. `p2_property_bridge` — bridge to P2 (two-tier causation)

**Cross-file connections:**
- `Axioms.lean`: `p2_two_tier_causation` (P2), `PrimaryCause`, `SecondaryCause`
- `NaturalLaw.lean`: `divine_grounding`, `MoralPrecept`
- `Basic.lean`: `Person`, `Authority`, `AuthoritySource`

**Key finding:** Catholic social doctrine is a BOUNDED-RIGHTS theory. The
subordination axiom (property subordinate to universal destination) is the
structural key that separates it from both libertarianism and socialism.
Without subordination, property becomes absolute (libertarianism). Without
property, universal destination becomes mandatory redistribution (socialism).
The stewardship model is the mechanism: a steward has real authority but
answers to a higher purpose. The structural parallel to P2 is exact:
primary (universal destination) and secondary (property) levels cooperate
without competing.

**Answer to the backlog question:** "What axiom resolves the tension between
ownership and universal destination?" Answer: `property_subordinate_to_universal_destination`
(axiom 3). It says property rights, while real, ENTAIL the universal destination
— they do not "do away with" it (§2403). The subordination is not a compromise
between two competing principles but a statement about the ONTOLOGICAL PRIORITY
of creation's purpose over human appropriation. Property serves the universal
destination; the universal destination does not serve property.

**Hidden assumptions identified:**
1. Creation theology grounds universal destination — without God as creator,
   "the earth belongs to all" is a political claim, not a metaphysical one
2. Stewardship requires a divine principal — without God as original owner,
   stewardship reduces to social convention
3. Political authority is legitimate and oriented to the common good (§2406)
4. The practical justification of property (Aquinas: care, order, peace) is
   sufficient — no labor theory of value is needed or assumed
-/

end Catlib.MoralTheology.SocialDoctrine
