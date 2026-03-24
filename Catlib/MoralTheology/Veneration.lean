import Catlib.Foundations
import Catlib.Creed.Soul
import Catlib.Creed.Intercession

/-!
# CCC §2096-2097, §2132, §971, §2112-2114: Veneration vs. Worship

## The puzzle

If God alone deserves religious honor, isn't honoring saints (icons, prayers,
feast days) a form of idolatry? Protestants often argue that ANY religious
honor given to a creature is worship — and worship is due to God alone.
Catholics and Orthodox distinguish veneration (dulia) from worship (latria)
and claim they are categorically different.

## The CCC's answer

§2096: "Adoration of the one God... sets man free from turning in on himself."

§2097: "To adore God is to acknowledge him as God, as the Creator and Savior,
the Lord and Master of everything that exists, as infinite and merciful Love."

§2132 (Council of Nicaea II, 787): "The honor rendered to an image passes to
its prototype." — Honor given to an icon of a saint passes THROUGH the image
to the person depicted, and ultimately to God whose grace made the saint holy.

§971: "The Church's devotion to the Blessed Virgin is intrinsic to Christian
worship... differs ESSENTIALLY from the adoration which is given to the
incarnate Word."

§2112-2114: Idolatry — "consists in divinizing what is not God." Idolatry is
NOT merely "honoring something a lot" — it is treating a creature as if it
were divine, as if it had ultimate metaphysical status.

## The classical distinction (Aquinas ST II-II q.84 and q.103)

- **Latria** (worship/adoration): due to God ALONE — acknowledges absolute
  divine ultimacy. The worshiper relates to the object AS ultimate, AS the
  source and end of all being.
- **Dulia** (veneration/honor): due to saints — honors excellence or holiness
  that PARTICIPATES in God's grace. The honorer relates to the object AS a
  participant in divine goodness, not as ultimate in itself.
- **Hyperdulia**: special veneration of Mary — higher than dulia but
  categorically below latria. Mary's grace is singular (§971) but she
  remains a creature.

## The structural insight

The boundary between worship and veneration is NOT:
- merely the intensity of the honor (you can venerate intensely without it
  becoming worship)
- merely the intention of the honorer (though intention matters)

The boundary IS the **metaphysical status of the one honored**:
- Latria: directed at something ACKNOWLEDGED AS ULTIMATE (divine)
- Dulia: directed at something ACKNOWLEDGED AS PARTICIPANT (creaturely
  excellence from divine grace)

This parallels P2 (two-tier causation): just as primary and secondary causes
don't compete (more creaturely action ≠ less divine action), worship and
veneration don't compete (honoring a saint ≠ less honor for God). In fact,
dulia INCREASES honor to God — you're honoring God's work in the saint
(§2132: "the honor passes to the prototype").

## Prediction

I expect the key finding to be: the latria/dulia distinction maps onto the
primary/secondary distinction from P2. Idolatry is precisely the error of
treating a secondary (creature) as if it were primary (divine). Dulia
is safe because it explicitly maintains the creature's secondary status.

## Findings

- **Prediction confirmed**: The latria/dulia distinction maps exactly onto
  the primary/secondary metaphysical levels. Idolatry = category error
  (treating secondary as primary). Dulia = correctly honoring at the
  secondary level.
- **Key finding**: The principled boundary is metaphysical status, not
  intention or intensity. A person could have the "right intention" while
  giving latria to a creature — the error is in what they ACKNOWLEDGE the
  creature as being, not what they meant to do. Conversely, intense dulia
  (hyperdulia for Mary) does not become latria because the metaphysical
  acknowledgment remains creaturely.
- **Hidden assumptions identified**:
  1. Creatures can genuinely participate in divine grace — holiness is
     REAL in the saint, not merely imputed (connects to S8: grace is
     transformative, not merely forensic).
  2. The metaphysical distinction between Creator and creature is stable
     and knowable — you CAN tell the difference. The CCC assumes this
     (§2096) but it requires metaphysical realism.
  3. Honor is TRANSITIVE through participation: honoring the participant
     honors the source (§2132). This is not obvious — it requires that
     the participation relation is transparent, not opaque.
- **Denominational scope**:
  - CATHOLIC + ORTHODOX: accept the latria/dulia distinction
  - PROTESTANT: most reject it — "all religious honor risks idolatry;
    the safest position is to honor God alone directly." The Protestant
    concern is not purely theoretical — it is pastoral: in practice,
    devotion to saints CAN become functionally indistinguishable from
    worship (the danger of practical idolatry even if theological
    categories are maintained).
- **Assessment**: Tier 2 — applies P2 (primary/secondary non-competition)
  to a new domain (honor/worship) and identifies the precise boundary
  principle (metaphysical status of the honoree).
-/

set_option autoImplicit false

namespace Catlib.MoralTheology.Veneration

open Catlib
open Catlib.Creed
open Catlib.Creed.Intercession

-- ============================================================================
-- § 1. Core types: the three levels of honor
-- ============================================================================

/-- The three levels of religious honor in Catholic theology.

    This is the classical Thomistic distinction (ST II-II q.84, q.103):
    - Latria: adoration/worship due to God alone
    - Dulia: veneration due to saints (honors excellence participating in grace)
    - Hyperdulia: special veneration of Mary (singular grace, still creaturely)

    MODELING CHOICE: We model these as an inductive type rather than a
    spectrum. The CCC and Aquinas treat the three as categorically distinct,
    not points on a continuum. The key boundary is between latria and
    dulia/hyperdulia — this is the Creator/creature divide.

    Provenance: [Tradition] Aquinas ST II-II q.84, q.103; Council of Nicaea II
    (787); CCC §971, §2096-2097.
    Denominational scope: CATHOLIC + ORTHODOX. -/
inductive HonorLevel where
  /-- Latria — adoration/worship. Acknowledges the honoree as ULTIMATE:
      the source and end of all being, infinite, uncreated.
      Due to God alone (§2096). -/
  | latria
  /-- Dulia — veneration. Acknowledges the honoree as PARTICIPANT in
      divine grace: excellent, holy, but creaturely and dependent.
      Due to saints. -/
  | dulia
  /-- Hyperdulia — special veneration of Mary. Recognizes her singular
      grace (§971: "full of grace") while maintaining her creaturely
      status. Higher than dulia, categorically below latria. -/
  | hyperdulia
  deriving DecidableEq

-- ============================================================================
-- § 2. Core predicates
-- ============================================================================

/-- Whether the one honored has ultimate metaphysical status — that is,
    whether they are divine (uncreated, infinite, the source and end of all).

    This is the KEY predicate. The latria/dulia boundary tracks this:
    latria is appropriate when and only when the honoree has ultimate status.

    STRUCTURAL OPACITY: The CCC affirms that God alone is ultimate (§2096:
    "Creator and Savior, the Lord and Master of everything that exists")
    but does not give a formal definition of "ultimate metaphysical status"
    beyond identifying it with being God. We keep it opaque because the
    CCC treats divinity as a primitive — you recognize it, you don't
    construct it from simpler parts. -/
opaque hasUltimateStatus : Person → Prop

/-- Whether a person participates in divine grace — their excellence
    derives from God's grace, not from their own independent divinity.

    §2132: The honor given to a saint "passes to its prototype" — the
    saint's holiness is a PARTICIPATION in God's holiness, not an
    independent source.

    HIDDEN ASSUMPTION: Grace is TRANSFORMATIVE (S8) — it actually MAKES
    the person holy, not merely declares them so. Without transformative
    grace, there is nothing IN the creature to honor — the holiness
    would be extrinsic (merely imputed). The latria/dulia distinction
    requires that creatures genuinely participate in divine goodness.

    This connects to S8 (grace_necessary_and_transformative): if grace
    only covers sin forensically (Luther), then the creature has no
    intrinsic holiness to venerate — dulia loses its object. The
    transformative reading of grace is a hidden precondition for the
    entire veneration framework. -/
opaque participatesInGrace : Person → Prop

/-- Whether an act of honor acknowledges the honoree as ultimate.

    This captures the FORMAL structure of worship: not the emotion
    or intensity, but what the act TREATS the honoree as being.
    Worship (latria) treats the honoree as ultimate — the uncreated
    source and end. Veneration (dulia) treats the honoree as a
    participant in the ultimate, not as ultimate itself.

    MODELING CHOICE: We distinguish the act's formal structure (what it
    acknowledges) from its subjective intensity. A person can pray
    fervently to a saint (intense dulia) without that intensity
    converting the act into latria. The difference is in what the act
    TREATS the honoree as being, not how strongly it treats them. -/
opaque acknowledgesAsUltimate : Person → Person → Prop

/-- Whether honor given to a participant passes to its source.
    §2132 (Nicaea II): "The honor rendered to an image passes to its
    prototype." Honor given to a saint for their holiness honors God,
    because the saint's holiness IS God's grace in them.

    HIDDEN ASSUMPTION: The participation relation is TRANSPARENT —
    honoring the participant genuinely reaches the source. This is not
    obvious; it requires that participation is a real metaphysical
    relation, not merely a metaphor. -/
opaque honorPassesToSource : Person → Prop

-- ============================================================================
-- § 3. Axioms
-- ============================================================================

/-- AXIOM 1 (§2096): God has ultimate metaphysical status — and God alone.
    God is the Creator, the source and end of all being — uncreated,
    infinite, self-subsistent. No creature shares this status.
    If two beings both had ultimate status, they would be the same being.

    This captures the monotheistic claim: there is at most one God.
    Combined with axiom 2 (idolatry), this ensures that worship of
    multiple "gods" is not just wrong but INCOHERENT — there cannot
    be two ultimate beings.

    Provenance: [Scripture] Is 44:6 ("I am the first and I am the last;
    besides me there is no god"); Dt 6:4 (Shema). [Definition] CCC §2096.
    Denominational scope: ECUMENICAL. -/
axiom god_has_ultimate_status :
  ∀ (p : Person), hasUltimateStatus p →
    ∀ (q : Person), hasUltimateStatus q → p = q

/-- AXIOM 2 (§2112-2114): Idolatry is giving latria to a creature.
    "Idolatry consists in divinizing what is not God." — §2113
    The formal definition: acknowledging a non-ultimate being AS ultimate
    is idolatry. This is a category error — treating secondary as primary.

    Note: we model the idolatrous ACT, not the idolatrous person.
    The act is wrong regardless of whether the person realizes it.

    Provenance: [Scripture] Ex 20:4-5; [Definition] CCC §2112-2114.
    Denominational scope: ECUMENICAL — all Christians condemn idolatry. -/
axiom idolatry_is_misplaced_latria :
  ∀ (honorer honoree : Person),
    ¬ hasUltimateStatus honoree →
    acknowledgesAsUltimate honorer honoree →
    False  -- contradiction: this cannot legitimately occur

/-- AXIOM 3 (§2132, Nicaea II): Honor to participants passes to the source.
    "The honor rendered to an image passes to its prototype."
    When we honor a saint for their holiness (a participation in divine
    grace), that honor passes through to God — the source of the grace.

    This means dulia does not take honor FROM God but gives honor TO God
    through the saint. More veneration of saints = more honor to God,
    not less. This is P2 applied to honor: primary and secondary levels
    of honor do not compete.

    HIDDEN ASSUMPTION: Participation in grace is a REAL metaphysical
    relation that makes honor-transfer possible. If grace is merely
    forensic (imputed but not infused), there is nothing in the creature
    through which honor could pass.

    Provenance: [Tradition] Council of Nicaea II (787); CCC §2132.
    Denominational scope: CATHOLIC + ORTHODOX. Protestants who reject
    icon veneration reject this principle. -/
axiom honor_passes_through_participants :
  ∀ (p : Person),
    participatesInGrace p →
    honorPassesToSource p

/-- AXIOM 4 (§971 + S8): Creatures who participate in grace have real
    holiness that can be honored — but this holiness is derivative,
    not ultimate.

    This connects the veneration framework to S8 (grace is transformative).
    If grace TRANSFORMS the person (not merely covers them), then the
    saint has genuine holiness — a real participation in divine goodness.
    That real holiness is what dulia honors.

    The key constraint: participation in grace does NOT confer ultimate
    status. The saint is holy BECAUSE of God's grace, not independently.
    This is what keeps dulia from collapsing into latria.

    Provenance: [Scripture] 2 Cor 3:18 ("being transformed into the same
    image from glory to glory"); [Definition] CCC §§828, 2683.
    Denominational scope: CATHOLIC + ORTHODOX (transformative grace).
    Protestants who hold forensic justification deny that creatures have
    intrinsic holiness to venerate. -/
axiom grace_participation_not_ultimate :
  ∀ (p : Person),
    participatesInGrace p →
    ¬ hasUltimateStatus p

/-- AXIOM 5: Dulia acknowledges the honoree as participant, not ultimate.
    When a person venerates a saint (dulia), the act treats the saint as
    a creature whose excellence participates in divine grace — NOT as an
    ultimate being. The formal structure of dulia is: "I honor you FOR
    your holiness, which comes from God."

    This is a DEFINITIONAL axiom: it captures what dulia IS as a formal
    act. If someone treated a saint as ultimate, that would not be dulia
    — it would be misplaced latria (idolatry).

    Provenance: [Definition] Aquinas ST II-II q.103 a.3; CCC §971.
    Denominational scope: CATHOLIC + ORTHODOX. -/
axiom dulia_does_not_acknowledge_ultimate :
  ∀ (honorer honoree : Person),
    participatesInGrace honoree →
    ¬ acknowledgesAsUltimate honorer honoree

-- ============================================================================
-- § 4. Theorems
-- ============================================================================

/-- THEOREM: Dulia (veneration of a grace-participant) is not idolatry.

    This is the core result. Veneration of saints does not collapse into
    idolatry BECAUSE:
    1. Dulia does not acknowledge the honoree as ultimate (axiom 6)
    2. Idolatry requires acknowledging a non-ultimate being as ultimate (axiom 3)
    3. Therefore dulia cannot be idolatry — the formal structure is different.

    The difference is in the METAPHYSICAL STATUS acknowledged, not the
    intensity of the honor or the intention of the honorer.

    Depends on: dulia_does_not_acknowledge_ultimate. -/
theorem dulia_is_not_idolatry
    (honorer honoree : Person)
    (h_participates : participatesInGrace honoree) :
    ¬ acknowledgesAsUltimate honorer honoree :=
  dulia_does_not_acknowledge_ultimate honorer honoree h_participates

/-- THEOREM: Veneration of saints honors God (through participation).

    When a person venerates a saint who participates in grace, the honor
    passes to the source (God). Veneration is not honor DIVERTED from God
    but honor DIRECTED to God through the saint.

    This parallels P2: more saintly intercession ≠ less Christ (Intercession.lean).
    Similarly, more veneration of saints ≠ less honor to God.

    Depends on: honor_passes_through_participants. -/
theorem veneration_honors_god
    (honoree : Person)
    (h_participates : participatesInGrace honoree) :
    honorPassesToSource honoree :=
  honor_passes_through_participants honoree h_participates

/-- THEOREM: Grace participants cannot be legitimate objects of latria.

    A creature who participates in divine grace is NOT ultimate (axiom 5).
    Therefore acknowledging them as ultimate is impossible without
    contradiction (axiom 3).

    This shows why hyperdulia (Mary) does not become latria no matter how
    high the honor: Mary participates in grace singularly (§971: "full of
    grace") but remains a creature. The metaphysical boundary is absolute.

    Depends on: grace_participation_not_ultimate, idolatry_is_misplaced_latria. -/
theorem no_latria_for_participants
    (honorer honoree : Person)
    (h_participates : participatesInGrace honoree)
    (h_ack : acknowledgesAsUltimate honorer honoree) :
    False :=
  have h_not_ultimate := grace_participation_not_ultimate honoree h_participates
  idolatry_is_misplaced_latria honorer honoree h_not_ultimate h_ack

/-- THEOREM: Worship has a unique proper object.

    If two beings are both legitimate objects of worship (both have
    ultimate status), they must be the same being. This captures the
    monotheistic claim at the heart of the first commandment: there
    is at most one God, so there is at most one proper object of latria.

    Polytheism is not just wrong but incoherent under this framework —
    multiple ultimate beings is a contradiction (each would have to be
    the source and end of all, which requires identity).

    Depends on: god_has_ultimate_status. -/
theorem worship_has_unique_object
    (p q : Person)
    (hp : hasUltimateStatus p)
    (hq : hasUltimateStatus q) :
    p = q :=
  god_has_ultimate_status p hp q hq

/-- THEOREM (Main): The veneration-worship distinction is principled.

    For any grace-participant (saint), veneration of that saint is:
    (a) NOT idolatry — the act does not acknowledge the saint as ultimate
    (b) Honor to God — the honor passes through the participant to the source
    (c) Categorically distinct from latria — the saint cannot be a
        legitimate object of worship because they lack ultimate status

    The principled boundary is METAPHYSICAL STATUS: latria acknowledges
    something as ultimate (divine), dulia acknowledges something as
    participant (creaturely holiness from grace). The difference is in
    what the act treats the honoree AS BEING, not in the intensity or
    intention of the honor.

    Depends on: dulia_does_not_acknowledge_ultimate,
    honor_passes_through_participants, grace_participation_not_ultimate. -/
theorem veneration_worship_distinction
    (honorer honoree : Person)
    (h_participates : participatesInGrace honoree) :
    -- (a) Not idolatry: dulia does not acknowledge as ultimate
    ¬ acknowledgesAsUltimate honorer honoree
    -- (b) Honor passes to God
    ∧ honorPassesToSource honoree
    -- (c) The saint lacks ultimate status (Creator/creature boundary)
    ∧ ¬ hasUltimateStatus honoree :=
  have h_not_ack := dulia_does_not_acknowledge_ultimate honorer honoree h_participates
  have h_passes := honor_passes_through_participants honoree h_participates
  have h_not_ult := grace_participation_not_ultimate honoree h_participates
  ⟨h_not_ack, h_passes, h_not_ult⟩

-- ============================================================================
-- § 5. Bridge theorems to base axioms
-- ============================================================================

/-- Bridge to P2: primary and secondary causes don't compete.
    The veneration framework is a P2 instance: primary honor (latria to God)
    and secondary honor (dulia to saints) operate at different levels and
    do not compete. More veneration ≠ less worship, just as more creaturely
    causation ≠ less divine causation. -/
theorem p2_non_competition_bridge
    (p : PrimaryCause) (s : SecondaryCause) :
    ¬ causesCompete p s :=
  p2_two_tier_causation p s

/-- Bridge to S8: grace is transformative.
    The veneration framework REQUIRES transformative grace (S8). If grace is
    merely forensic (Luther), then the creature has no intrinsic holiness to
    venerate — dulia loses its object. The real holiness in the saint (what
    dulia honors) exists only because grace actually TRANSFORMS, not merely
    covers. -/
theorem s8_bridge
    (p : Person) (g : Grace)
    (h_given : graceGiven p g) :
    graceTransforms g p :=
  s8_grace_necessary_and_transformative p g h_given

/-- Bridge to intercession: veneration and intercession are complementary.
    A glorified saint who participates in grace AND intercedes for the living
    is both an object of dulia and an active intercessor. The two practices
    (asking saints to pray for us + honoring saints) share the same P2
    structure: secondary-level activity that participates in, rather than
    competes with, primary-level divine action. -/
theorem intercession_and_veneration_compatible
    (s : HumanPerson) (beneficiary : Person)
    (h_saint : isGlorifiedSaint s) :
    intercedesFor (Person.human) beneficiary
    ∧ participatesInMediation (Person.human) :=
  intercession_is_participatory s beneficiary h_saint

-- ============================================================================
-- § 6. The denominational picture
-- ============================================================================

/-!
### Where traditions agree and disagree

**All Christians agree:**
- God alone deserves worship/adoration (Ex 20:3-5)
- Idolatry is wrong — treating creatures as gods is condemned
- The saints were genuinely holy people who loved God

**The disputed question:**
- Is there a category of religious honor (dulia) that is NOT worship?
- Can such honor be given to creatures without idolatry?

**Catholic + Orthodox (accept the latria/dulia distinction):**
- Latria (worship) and dulia (veneration) are categorically different
- The difference is in the METAPHYSICAL STATUS of the honoree:
  God = ultimate, saints = participants in divine grace
- Honor to saints passes to God (Nicaea II, §2132)
- Hyperdulia for Mary: singular grace, still creaturely
- The practice safeguards against idolatry precisely BY maintaining the
  Creator/creature distinction at the level of what the act acknowledges
- CCC §971: Marian devotion "differs ESSENTIALLY from the adoration which
  is given to the incarnate Word"

**Protestant (reject the distinction — most traditions):**
- "All religious honor is worship, and worship is due to God alone"
- The latria/dulia distinction is:
  (a) unbiblical — Scripture does not draw this line
  (b) pastorally dangerous — even if theologically correct, in practice
      devotion to saints easily becomes functionally indistinguishable
      from worship (statues, prayers, feast days, litanies)
  (c) unnecessary — we can honor the saints by imitating their example
      without any religious devotion directed at them
- The Protestant concern is legitimate: the distinction requires
  theological sophistication to maintain, and popular piety does not
  always maintain it. The Catholic response: the solution to potential
  abuse is correct practice, not abolition of the practice.

**The precise point of disagreement:**
The Protestant does NOT deny that saints were holy. The Protestant denies
that there exists a category of RELIGIOUS honor that is not worship. For
the Protestant, "religious" and "worship" are coextensive. The Catholic
claims that "religious honor" is broader than "worship" — it includes
both latria (worship, for God) and dulia (veneration, for creatures who
participate in God's grace).

This connects to S8 (transformative grace): if grace is forensic (merely
declared righteous), then the creature has no intrinsic holiness to venerate.
If grace is transformative (actually makes holy), then the creature has real
participated holiness — a genuine object for dulia. The latria/dulia
distinction DEPENDS on the Catholic reading of grace.

**Anglican position:**
Varies. The Thirty-Nine Articles (Article XXII) condemn "invocation of saints"
as "repugnant to the Word of God." But Anglo-Catholics maintain practices
close to Catholic veneration. This mirrors the broader Anglican pattern of
containing both Protestant and Catholic instincts.
-/

-- ============================================================================
-- § 7. Summary
-- ============================================================================

/-!
## Summary

**Axioms** (5 — from CCC §2096-2097, §2112-2114, §2132, §971, Nicaea II):
1. `god_has_ultimate_status` (§2096) — only God is ultimate (monotheism)
2. `idolatry_is_misplaced_latria` (§2112-2114) — worshiping a creature = contradiction
3. `honor_passes_through_participants` (§2132, Nicaea II) — honor to saints honors God
4. `grace_participation_not_ultimate` (§971 + S8) — grace does not make creatures divine
5. `dulia_does_not_acknowledge_ultimate` (ST II-II q.103) — veneration ≠ worship in form

**Theorems** (5 + 3 bridges):
1. `dulia_is_not_idolatry` — veneration of saints is not idolatry
2. `veneration_honors_god` — honor to saints passes to God
3. `no_latria_for_participants` — creatures in grace cannot be objects of latria
4. `worship_has_unique_object` — there is at most one proper object of worship
5. `veneration_worship_distinction` (main) — the full result: dulia is not idolatry,
   honors God, and is categorically distinct from latria
6. `p2_non_competition_bridge` — connects to P2 (primary/secondary non-competition)
7. `s8_bridge` — connects to S8 (transformative grace)
8. `intercession_and_veneration_compatible` — connects to Intercession.lean

**Cross-file connections:**
- `Axioms.lean`: `p2_two_tier_causation` (P2), `s8_grace_necessary_and_transformative` (S8),
  `PrimaryCause`, `SecondaryCause`, `causesCompete`, `graceGiven`, `graceTransforms`
- `Soul.lean`: `HumanPerson`, `hasSpiritualAspect`
- `Intercession.lean`: `isGlorifiedSaint`, `intercedesFor`, `participatesInMediation`,
  `intercession_is_participatory`

**Key finding:** The principled boundary between veneration and worship is
METAPHYSICAL STATUS — what the act acknowledges the honoree as being.
Latria acknowledges something as ultimate (divine). Dulia acknowledges
something as participant (creaturely holiness from grace). The difference
is NOT intention, NOT intensity, but what the honoree IS. This maps onto
P2: worship/veneration are primary/secondary honor levels that do not
compete.

**Answer to the backlog question:** "Where is the principled boundary —
intention, object, mode of offering, or metaphysical status of the one
honored?" Answer: METAPHYSICAL STATUS of the one honored. Latria treats
the honoree as ultimate (divine); dulia treats the honoree as participant
(creaturely). Intention and mode of offering are secondary — the decisive
factor is the Creator/creature distinction. A person with correct
intention who gives latria to a creature is still committing idolatry;
a person who intensely venerates a saint (hyperdulia for Mary) is not
worshiping because the act maintains the creaturely acknowledgment.

**Hidden assumptions identified:**
1. Creatures can genuinely participate in divine grace — holiness is REAL
   in the saint (requires S8: transformative, not forensic grace)
2. The Creator/creature distinction is stable and knowable — metaphysical
   realism about the divine/creaturely boundary
3. Honor is transitive through participation — honoring the participant
   genuinely honors the source (Nicaea II, §2132)
-/

end Catlib.MoralTheology.Veneration
