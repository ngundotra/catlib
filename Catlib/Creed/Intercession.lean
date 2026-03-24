import Catlib.Foundations
import Catlib.Creed.Soul
import Catlib.Creed.Prayer

/-!
# CCC §956, §2683, §2692: Saintly Intercession and the One Mediator

## The puzzle

1 Tim 2:5: "There is one mediator between God and men, the man Christ Jesus."

If Christ is the ONE mediator, isn't asking saints to pray for you adding rival
mediators? This is a central Protestant objection to Catholic and Orthodox
practice. The puzzle: how can saintly intercession be legitimate without
contradicting Paul's claim about Christ's unique mediation?

## The CCC's answer

§956: "Being more closely united to Christ, those who dwell in heaven...
do not cease to intercede with the Father for us, as they proffer the merits
which they acquired on earth through the one mediator between God and men,
Christ Jesus."

§2683: "The witnesses who have preceded us into the kingdom, especially those
whom the Church recognizes as saints, share in the living tradition of prayer
by the example of their lives... Their intercession is their most exalted
service to God's plan."

§2692: "The communion of saints... means that the saints in heaven... take
an active part in the whole life of the Church."

## The structural insight

The answer is P2 (two-tier causation) applied to mediation:

1. Christ is the UNIQUE PRINCIPAL mediator (primary level)
2. Saints intercede INSTRUMENTALLY — they participate in Christ's mediation
   (secondary level)
3. P2: primary and secondary don't compete — more saintly intercession does
   NOT mean less Christ

This is the SAME pattern as:
- P2 in causation: God causes + creatures cause → don't compete
- P2 in prayer: God acts + person prays → don't compete
- P2 in absolution: Christ forgives + priest absolves → don't compete
- P2 in intercession: Christ mediates + saints intercede → don't compete

P2 does quadruple duty across the project. This is a finding.

## What principle distinguishes subordinate mediation from usurpation?

The backlog question. The answer: P2 itself IS the principle. Subordinate
mediation operates at the secondary-cause level and participates in (rather
than replaces) the primary cause. Usurpation would claim to operate at the
primary level — to mediate independently of Christ. The CCC's position is
that saintly intercession is ALWAYS through, with, and in Christ (§956:
"through the one mediator"). It is secondary causation, not rival primary
causation.

The Protestant position is essentially: P2 doesn't apply to mediation the way
it applies to causation. For Protestants, "one mediator" means NO secondary
mediators at all — the exclusivity is absolute, not tiered. This is a genuine
disagreement about the scope of P2.

## Prediction

I expect this to confirm the P2 pattern yet again. The resolution should be
structurally identical to Prayer.lean. The interesting question is whether any
NEW hidden assumptions emerge beyond P2 itself.

## Findings

- **Prediction vs. reality**: Confirmed — P2 is the load-bearing principle.
  The resolution is structurally identical to prayer and absolution.
- **Key finding**: P2 does quadruple duty: causation, prayer, absolution,
  intercession. The same two-tier non-competition principle resolves four
  distinct theological puzzles. This is a significant structural finding —
  what looks like four separate Catholic doctrines are really four instances
  of one principle.
- **Hidden assumptions identified**:
  1. The saints are ALIVE in Christ (not dead) — soul_is_immortal + beatifying
     communion. If the saints were simply gone, intercession would be nonsensical.
  2. Members of Christ's body can participate instrumentally in His mediation.
     The CCC assumes this (§956) but it requires that membership in the Body of
     Christ carries real causal power — not just honorific status.
  3. The scope of P2 extends to mediation, not just physical causation. This is
     the hidden assumption the Protestant objects to. The CCC treats it as
     obvious (§956 doesn't argue for it), but it IS an extension of the principle.
- **Denominational scope**:
  - CATHOLIC + ORTHODOX: accept saintly intercession (§956, §2683)
  - PROTESTANT: reject it — "one mediator" is exclusive, not tiered.
    The Protestant position is: P2 applies to causation but NOT to mediation.
- **Assessment**: Tier 2 — applies P2 to a new domain and identifies the
  precise point of disagreement (scope of P2).
-/

set_option autoImplicit false

namespace Catlib.Creed.Intercession

open Catlib
open Catlib.Creed
open Catlib.Creed.Prayer

-- ============================================================================
-- § 1. Core concepts
-- ============================================================================

/-- Whether a person mediates between God and humanity at the PRIMARY level.
    1 Tim 2:5: "There is one mediator between God and men, the man Christ Jesus."
    Primary mediation means being the unique, irreplaceable channel of
    reconciliation between God and humanity.

    STRUCTURAL OPACITY: The CCC affirms Christ is the unique principal mediator
    but never defines what "primary mediation" is in formal terms beyond the
    scriptural assertion. The content is: Christ's mediation is the foundation
    without which all other intercession is impossible. -/
opaque isPrincipalMediator : Person → Prop

/-- Whether a person intercedes for another — praying on their behalf.
    Intercession is a specific form of prayer: asking God for something
    on behalf of someone else (CCC §2634-2636).

    This differs from `PetitionaryPrayer` (Prayer.lean) in two ways:
    (1) it is on behalf of ANOTHER person, not oneself
    (2) it can be performed by the living OR the dead (saints in heaven)

    MODELING CHOICE: We model intercession as a relation between persons
    (intercessor, beneficiary). The CCC treats it as a genuine act even
    for the dead, because the saints are alive in Christ. -/
opaque intercedesFor : Person → Person → Prop

/-- Whether a person's intercession participates in Christ's mediation
    instrumentally — operating at the secondary-cause level, not as a
    rival primary mediator.

    This is the key concept. The CCC's claim (§956) is that saintly
    intercession doesn't compete with Christ's mediation because it
    PARTICIPATES in it. The saint intercedes "through the one mediator"
    — not independently.

    HONEST OPACITY: The CCC asserts participatory mediation (§956) without
    explaining the metaphysical mechanism. HOW does a saint's prayer
    participate in Christ's mediation? Possible answers: (1) the saint is
    a member of Christ's body, so their act is Christ's act in some sense;
    (2) the saint's prayer has efficacy only because Christ mediates it to
    the Father; (3) the saint's holiness is itself a participation in
    Christ's holiness, so their intercession extends that participation.
    The CCC implies all three but doesn't commit to one theory. -/
opaque participatesInMediation : Person → Prop

/-- Whether a person is in beatifying communion with God AND alive as
    a saint in heaven — both spiritually alive (soul_is_immortal) and
    in the state of glory.

    This combines two facts the CCC presupposes for saintly intercession:
    (a) the saint's soul persists after death (§366, soul_is_immortal)
    (b) the saint is in communion with God (§1023, beatifying communion)

    Without BOTH, intercession of the dead would be nonsensical: if the
    saints were annihilated, they couldn't pray; if they existed but
    weren't in communion, they'd have no access to God.

    HIDDEN ASSUMPTION: The CCC treats the saints' aliveness as obvious
    (§956 "those who dwell in heaven"), but it depends on soul_is_immortal
    (§366) — which is a substantial metaphysical commitment. -/
opaque isGlorifiedSaint : HumanPerson → Prop

/-- Whether two forms of mediation compete — more of one means less of
    the other. This is the mediation-specific analogue of `causesCompete`
    from Axioms.lean.

    MODELING CHOICE: We introduce a separate predicate rather than reusing
    `causesCompete` directly, because mediation is not identical to physical
    causation. The PRINCIPLE is the same (P2: primary and secondary don't
    compete), but the domain is different. The Protestant objection is
    precisely that P2 applies to causation but not to mediation. -/
opaque mediationsCompete : Person → Person → Prop

-- ============================================================================
-- § 2. Axioms
-- ============================================================================

/-- AXIOM 1 (§956, 1 Tim 2:5): Christ is the unique principal mediator.
    "There is one mediator between God and men, the man Christ Jesus."

    This is the non-negotiable starting point — shared by ALL Christians.
    The question is not WHETHER Christ is the one mediator, but whether
    "one" excludes secondary participation or only rival primary mediators.

    Provenance: [Scripture] 1 Tim 2:5
    Denominational scope: ECUMENICAL — all Christians affirm this. -/
axiom christ_is_unique_mediator :
  ∀ (p q : Person), isPrincipalMediator p → isPrincipalMediator q → p = q

/-- AXIOM 2 (§956): The saints are alive and intercede in heaven.
    "Being more closely united to Christ, those who dwell in heaven...
    do not cease to intercede with the Father for us."

    This axiom combines two CCC claims:
    (a) The saints in glory are ALIVE — their souls persist (§366)
    (b) They actively intercede — they don't merely rest, they pray (§956)

    The axiom says: for any glorified saint, they intercede for every person.
    This is the CCC's maximalist claim — the saints pray for ALL of us,
    not just those who ask.

    HIDDEN ASSUMPTION: The saints can ACT after death. soul_is_immortal
    says the spiritual aspect persists, but persistence alone doesn't
    guarantee agency. The CCC assumes that a separated soul in glory retains
    the capacity for intentional action (prayer, intercession). This is a
    substantial metaphysical claim beyond mere survival.

    Provenance: [Definition] CCC §956, §2683
    Denominational scope: CATHOLIC + ORTHODOX. -/
axiom saints_intercede :
  ∀ (s : HumanPerson) (beneficiary : Person),
    isGlorifiedSaint s →
    intercedesFor (Person.human) beneficiary

/-- AXIOM 3 (§956 + P2 applied to mediation): Saintly intercession
    participates in Christ's mediation, not as rival but as instrument.
    "...as they proffer the merits which they acquired on earth through
    the one mediator between God and men, Christ Jesus." (§956)

    The key word is "through" — the saints intercede THROUGH Christ, not
    independently of Him. Their intercession is a secondary-level participation
    in the primary mediation of Christ.

    This is P2 applied to mediation: just as creaturely causation participates
    in divine causation without competing (Axioms.lean), saintly intercession
    participates in Christ's mediation without competing.

    HIDDEN ASSUMPTION: P2's scope extends to mediation. The CCC treats this
    as obvious (§956 doesn't argue for it — it just says "through the one
    mediator"). But extending the non-competition principle from causation
    to mediation IS a substantive claim. The Protestant denies exactly this:
    "one mediator" means no secondary mediators at all, not that secondary
    mediators participate in the one mediator.

    Provenance: [Definition] CCC §956; [Philosophical] P2 (Aquinas, ST III q.26)
    Denominational scope: CATHOLIC + ORTHODOX. -/
axiom intercession_participates_in_mediation :
  ∀ (s : HumanPerson) (beneficiary : Person),
    isGlorifiedSaint s →
    intercedesFor (Person.human) beneficiary →
    participatesInMediation (Person.human)

/-- AXIOM 4 (P2 applied to mediation): Christ's mediation and saintly
    intercession do not compete — more intercession does not mean less Christ.

    This is the mediation-specific instance of P2 (two-tier causation):
    primary and secondary causes do not compete. Applied here: the primary
    mediator (Christ) and secondary intercessors (saints) do not compete.
    More saintly intercession does not diminish Christ's mediation — just as
    more creaturely causation does not diminish God's causation.

    This is the SAME structural principle that resolves:
    - Causation: God causes + creatures cause → don't compete (Axioms.lean)
    - Prayer: God acts + person prays → don't compete (Prayer.lean)
    - Intercession: Christ mediates + saints intercede → don't compete (here)

    Provenance: [Philosophical] P2 (Aquinas, ST I q.105 a.5; III q.26 a.1)
    Denominational scope: CATHOLIC + ORTHODOX. Protestants REJECT this for
    mediation specifically — they accept P2 for causation but not mediation. -/
axiom mediation_non_competition :
  ∀ (christ : Person) (saint : Person),
    isPrincipalMediator christ →
    participatesInMediation saint →
    ¬ mediationsCompete christ saint

-- ============================================================================
-- § 3. Bridge theorems to base axioms
-- ============================================================================

/-- Bridge to P2: primary and secondary causes don't compete.
    This makes explicit the structural parallel: the intercession argument
    uses the same non-competition principle as causation (P2). -/
theorem causation_non_competition_bridge
    (p : PrimaryCause) (s : SecondaryCause) :
    ¬ causesCompete p s :=
  p2_two_tier_causation p s

/-- Bridge to soul_is_immortal: the saints are ALIVE.
    Saintly intercession requires that the saints persist after death.
    This is not a trivial presupposition — it is a substantial metaphysical
    commitment (§366). Without this, the entire intercession argument collapses. -/
theorem saints_are_alive_bridge (s : HumanPerson) :
    hasSpiritualAspect s :=
  soul_is_immortal s

-- ============================================================================
-- § 4. Theorems: resolving the puzzle
-- ============================================================================

/-- THEOREM: Saintly intercession is participatory, not rivalrous.

    For any glorified saint and any beneficiary: the saint intercedes for the
    beneficiary, and that intercession participates in Christ's mediation.
    The saint is not a rival mediator — they are an instrument of the one
    mediator.

    Depends on: saints_intercede, intercession_participates_in_mediation. -/
theorem intercession_is_participatory
    (s : HumanPerson) (beneficiary : Person)
    (h_saint : isGlorifiedSaint s) :
    intercedesFor (Person.human) beneficiary ∧
    participatesInMediation (Person.human) :=
  have h_int := saints_intercede s beneficiary h_saint
  have h_part := intercession_participates_in_mediation s beneficiary h_saint h_int
  ⟨h_int, h_part⟩

/-- THEOREM: Saintly intercession does not compete with Christ's mediation.

    For any principal mediator (Christ) and any glorified saint: the saint's
    intercession does not compete with Christ's mediation. More saintly
    prayer does not mean less Christ. This is P2 applied to mediation.

    Depends on: saints_intercede, intercession_participates_in_mediation,
    mediation_non_competition. -/
theorem intercession_does_not_diminish_christ
    (christ : Person) (s : HumanPerson) (beneficiary : Person)
    (h_mediator : isPrincipalMediator christ)
    (h_saint : isGlorifiedSaint s) :
    ¬ mediationsCompete christ (Person.human) :=
  have h_int := saints_intercede s beneficiary h_saint
  have h_part := intercession_participates_in_mediation s beneficiary h_saint h_int
  mediation_non_competition christ (Person.human) h_mediator h_part

/-- THEOREM (Main): The one-mediator puzzle is resolved by P2.

    For any principal mediator (Christ), any glorified saint, and any
    beneficiary:
    1. Christ remains the unique principal mediator (no rivals at the primary level)
    2. The saint intercedes for the beneficiary (secondary level)
    3. That intercession participates in Christ's mediation (not independent)
    4. They do not compete (P2 applied to mediation)

    This resolves the puzzle: 1 Tim 2:5 ("one mediator") excludes rival
    PRIMARY mediators, not instrumental SECONDARY intercessors who participate
    in the one mediator's work.

    Depends on: christ_is_unique_mediator, saints_intercede,
    intercession_participates_in_mediation, mediation_non_competition. -/
theorem one_mediator_with_participatory_intercession
    (christ : Person) (s : HumanPerson) (beneficiary : Person)
    (h_mediator : isPrincipalMediator christ)
    (h_saint : isGlorifiedSaint s) :
    -- (a) Christ is unique at the primary level
    (∀ (q : Person), isPrincipalMediator q → q = christ)
    -- (b) The saint intercedes
    ∧ intercedesFor (Person.human) beneficiary
    -- (c) That intercession participates in Christ's mediation
    ∧ participatesInMediation (Person.human)
    -- (d) They don't compete
    ∧ ¬ mediationsCompete christ (Person.human) :=
  have h_unique : ∀ (q : Person), isPrincipalMediator q → q = christ :=
    fun q hq => by
      have := christ_is_unique_mediator q christ hq h_mediator
      exact this
  have h_int := saints_intercede s beneficiary h_saint
  have h_part := intercession_participates_in_mediation s beneficiary h_saint h_int
  have h_nc := mediation_non_competition christ (Person.human) h_mediator h_part
  ⟨h_unique, h_int, h_part, h_nc⟩

-- ============================================================================
-- § 5. The denominational picture
-- ============================================================================

/-!
### Where traditions agree and disagree

**All Christians agree:**
- Christ is the one mediator (1 Tim 2:5)
- Christians can and should pray for one another (Jas 5:16: "pray for one another")
- The living can ask the living to pray for them

**The disputed question:**
- Can the DEAD (saints in heaven) intercede?
- If so, does asking them to pray add rival mediators?

**Catholic + Orthodox (accept saintly intercession):**
- The saints are alive in Christ (soul_is_immortal + beatifying communion)
- Their intercession participates in Christ's mediation (P2 applied to mediation)
- "One mediator" excludes rival primary mediators, not instrumental participants
- §956: "those who dwell in heaven... do not cease to intercede"

**Protestant (reject saintly intercession):**
- "One mediator" means NO secondary mediators — the exclusivity is absolute
- P2 applies to causation but NOT to mediation
- Even if the saints are alive, Scripture nowhere commands asking them to pray
- Risk of practical idolatry: devotion to saints can overshadow Christ in practice

**The precise point of disagreement:**
The Protestant does NOT deny P2 for causation (God causes + creatures cause).
The Protestant denies P2 for MEDIATION specifically. The claim is that
1 Tim 2:5 establishes an exclusivity that is different in kind from the
causation case. Christ's mediation is not merely "primary" — it is
EXCLUSIVELY sufficient, and adding secondary mediators (even instrumental ones)
undermines that sufficiency.

The Catholic response: if asking a living friend to pray for you doesn't
violate 1 Tim 2:5, why would asking a dead-but-alive saint? The saint is
more alive in Christ than the living friend. The Protestant response: the
dead are in a different category — the Bible prohibits necromancy (Deut 18:11)
and nowhere models post-mortem prayer requests. The Catholic counter: the
saints in glory are not "dead" in the relevant sense — they are alive in
Christ (Lk 20:38: "He is not God of the dead, but of the living").
-/

-- ============================================================================
-- § 6. The P2 quadruple-duty finding
-- ============================================================================

/-!
### P2 does quadruple duty

The same non-competition principle (P2: primary and secondary causes don't
compete) resolves four distinct theological puzzles:

| Domain | Primary Level | Secondary Level | File |
|--------|---------------|-----------------|------|
| **Causation** | God causes | Creatures cause | Axioms.lean |
| **Prayer** | God acts/governs | Person prays | Prayer.lean |
| **Absolution** | Christ forgives | Priest absolves | Reconciliation.lean |
| **Intercession** | Christ mediates | Saints intercede | this file |

In each case:
1. The primary actor is unique and irreplaceable
2. The secondary actor participates in (not rivals) the primary actor
3. More secondary activity ≠ less primary activity
4. The secondary actor's efficacy derives FROM the primary, not independently

This is a structural finding: what looks like four separate Catholic doctrines
(providence, prayer, sacramental authority, saintly intercession) are really
four instances of one metaphysical principle. P2 is the deepest load-bearing
axiom in the entire project.

**Ecumenical note**: All four traditions accept P2 for causation. The Catholic
distinctive is applying P2 to the other three domains. Each domain has its
own denominational cut:
- Prayer: broadly ecumenical (all Christians pray)
- Absolution: Catholic + Orthodox (sacramental authority)
- Intercession: Catholic + Orthodox (saints alive and active)
-/

-- ============================================================================
-- § 7. Summary
-- ============================================================================

/-!
## Summary

**Axioms** (4 — from CCC §956 + P2, connected to existing infrastructure):
1. `christ_is_unique_mediator` (1 Tim 2:5) — Christ alone is principal mediator
2. `saints_intercede` (§956) — glorified saints intercede for all
3. `intercession_participates_in_mediation` (§956 + P2) — intercession is
   instrumental, not independent
4. `mediation_non_competition` (P2 applied to mediation) — mediation levels
   don't compete

**Theorems** (4):
1. `intercession_is_participatory` — saints intercede AND participate in Christ's mediation
2. `intercession_does_not_diminish_christ` — saintly intercession doesn't compete with Christ
3. `one_mediator_with_participatory_intercession` — the full resolution: Christ is unique
   AND saints intercede instrumentally AND they don't compete
4. `causation_non_competition_bridge` + `saints_are_alive_bridge` — bridge theorems

**Cross-file connections:**
- `Axioms.lean`: `p2_two_tier_causation` (base axiom P2), `PrimaryCause`,
  `SecondaryCause`, `causesCompete`
- `Soul.lean`: `soul_is_immortal` (§366), `HumanPerson`, `hasSpiritualAspect`
- `Prayer.lean`: structural parallel (P2 in prayer domain)

**Key finding:** P2 does quadruple duty — causation, prayer, absolution,
intercession. The same non-competition principle resolves four distinct puzzles.
This is a significant structural finding about the unity of Catholic doctrine.

**Answer to the backlog question:** "What principle distinguishes subordinate
mediation from usurpation?" Answer: P2 itself IS the principle. Subordinate
mediation operates at the secondary-cause level and participates in (rather
than replaces) the primary cause. Usurpation would claim to operate at the
primary level — to mediate independently of Christ. The CCC's position is
that saintly intercession is ALWAYS "through the one mediator" (§956).

**Hidden assumptions identified:**
1. The saints are alive and can ACT after death — not just persist, but pray
   (soul_is_immortal gives persistence; agency after death is an additional claim)
2. Members of Christ's body can participate instrumentally in His mediation
   (membership carries real causal power, not just honorific status)
3. P2's scope extends to mediation (the CCC treats this as obvious; the
   Protestant denies it — this is the precise point of disagreement)
-/

end Catlib.Creed.Intercession
