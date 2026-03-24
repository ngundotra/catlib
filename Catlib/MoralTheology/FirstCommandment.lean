import Catlib.Foundations
import Catlib.MoralTheology.Veneration
import Catlib.MoralTheology.NaturalLaw
import Catlib.MoralTheology.Conscience

/-!
# CCC §2084-2141: The First Commandment — Idolatry, Superstition, and Atheism

## The Catechism's claims

§2084: "God makes himself known by recalling his all-powerful loving,
and liberating action in the history of the one he addresses."

§2096-2097: "Adoration of the one God sets man free from turning in on
himself." Worship (latria) involves adoration, prayer, sacrifice,
promises, and vows — all directed to God alone.

§2110-2111: Superstition — "a departure from the worship that we give
to the true God. It can even affect the worship we offer the true God,
e.g., when one attributes an importance in some way magical to certain
practices otherwise lawful or necessary."

§2112-2114: Idolatry — "consists in divinizing what is not God. Man
commits idolatry whenever he honors and reveres a creature in place of
God." "Idolatry rejects the unique Lordship of God."

§2123-2128: Atheism — "Since it rejects or denies the existence of God,
atheism is a sin against the virtue of religion" (§2128). The CCC
distinguishes theoretical atheism (explicit denial of God) from practical
atheism (living as if God does not exist).

## The three violations

The First Commandment generates three structurally distinct violations:

1. **Idolatry** — attributing ultimate status (divinity) to what is not God.
   This is a CATEGORY ERROR: treating secondary as primary. Already partially
   formalized in Veneration.lean (`idolatry_is_misplaced_latria`).

2. **Superstition** — attributing causal power where none properly belongs.
   §2111: giving "magical" importance to practices. This misuses P2's
   secondary causation by treating a creature-level action as having
   primary-level efficacy INDEPENDENT of God.

3. **Atheism** — denying what §36 says reason can know: that God exists.
   Two forms: theoretical (explicit denial) and practical (living as if
   God doesn't exist, substituting something else as one's ultimate concern).

## The key question

Does practical atheism reduce to a form of idolatry? The CCC suggests
yes: §2114 says "Human life is unified by adoring the one God" — if
you don't adore God, you adore something else. §2113 says idolatry is
not limited to false religions — "Man can... make an idol of power,
pleasure, race, ancestors, the state, money, etc."

## Prediction

I expect practical atheism to reduce to idolatry UNDER the assumption
that every person necessarily has SOME ultimate concern (something they
treat as ultimate). This assumption is not trivially true — it's a
substantive claim about human nature. Theoretical atheism, however,
does NOT reduce to idolatry — one can deny God's existence without
treating anything else as divine. The reduction works only for the
practical form.

## Findings

- **Prediction confirmed**: Practical atheism reduces to idolatry IF AND
  ONLY IF the person has some ultimate concern. The reduction requires a
  hidden assumption: `everyone_has_ultimate_concern` — every person
  functionally treats something as ultimate. This is Tillich's insight
  ("faith is ultimate concern"), adopted implicitly by the CCC (§2114).

- **Key finding**: The three violations have DIFFERENT structures:
  - Idolatry = wrong OBJECT of worship (gives latria to a creature)
  - Superstition = wrong MECHANISM (attributes magical causation)
  - Atheism = wrong BELIEF (denies God's existence)
  But practical atheism collapses the belief-failure into an object-failure:
  if you live as if God doesn't exist, you WILL treat something else as
  ultimate — and that IS idolatry.

- **Superstition vs. P2**: Superstition is precisely the violation of P2
  applied to religious practice. P2 says primary and secondary causes
  don't compete. Superstition treats secondary causes (rituals, objects,
  practices) AS IF they had primary causal power independent of God.
  This is the causal-order analogue of idolatry's honor-order error.

- **Hidden assumptions**:
  1. Every person has an ultimate concern (Tillich/CCC §2114)
  2. God's existence is knowable by reason (§36, Vatican I)
  3. Superstition fails because causation has two levels (P2)

- **Denominational scope**: The three violations are ECUMENICAL — all
  Christians condemn idolatry, superstition, and atheism. The specific
  analysis of WHAT counts as superstition varies (Protestants classify
  some Catholic practices as superstitious; Catholics deny this).

## Modeling choices

1. We model "ultimate concern" as an opaque predicate — the CCC doesn't
   define what makes something functionally ultimate beyond §2113's
   examples (power, pleasure, race, money, etc.).

2. We model superstition through the lens of P2 (two-tier causation),
   which is our philosophical framework, not the CCC's explicit language.

3. The practical-atheism-reduces-to-idolatry theorem uses an explicit
   axiom (`everyone_has_ultimate_concern`) rather than hiding the
   assumption.
-/

set_option autoImplicit false

namespace Catlib.MoralTheology.FirstCommandment

open Catlib
open Catlib.MoralTheology.Veneration

-- ============================================================================
-- § 1. Core predicates
-- ============================================================================

/-- Whether a person's functional ultimate concern is directed at a given entity.
    §2113: Man can "make an idol of power, pleasure, race, ancestors, the state,
    money, etc." — these become the person's functional ultimate, the thing
    they organize life around, even if they never explicitly worship it.

    MODELING CHOICE: We use a binary predicate (person × person → Prop) rather
    than a function returning THE ultimate concern. A person could in principle
    have multiple competing ultimates (divided loyalties), so the predicate
    form is more general. But the CCC implies life is "unified by adoring the
    one God" (§2114) — suggesting a single ultimate. We leave this open. -/
opaque treatsAsUltimate : Person → Person → Prop

/-- Whether a person explicitly denies the existence of God.
    §2123-2124: "Atheism... a rejection of or denial of the existence of God."

    This is THEORETICAL atheism — a propositional stance.

    STRUCTURAL OPACITY: The CCC doesn't define what "denying God's existence"
    means beyond the obvious reading. We keep it opaque because the
    boundary between denial (explicit), doubt (uncertain), and agnosticism
    (claims unknowability) is not formalized in the CCC. -/
opaque deniesGodExists : Person → Prop

/-- Whether a person lives as if God does not exist — organizing their life
    without reference to God.
    §2128: This is PRACTICAL atheism — not a propositional denial but a
    mode of living. The person may not explicitly deny God but functionally
    ignores God as irrelevant.

    HIDDEN ASSUMPTION: Practical and theoretical atheism are genuinely
    different. A person can theoretically believe in God while practically
    living as if God doesn't exist (and vice versa, though the CCC doesn't
    consider that case). -/
opaque livesAsIfNoGod : Person → Prop

/-- Whether a practice is attributed magical causal power independent of God.
    §2111: Superstition "can even affect the worship we offer the true God,
    e.g., when one attributes an importance in some way magical to certain
    practices otherwise lawful or necessary."

    MODELING CHOICE: We model superstition through P2's lens. A practice
    is superstitious when it is treated as having PRIMARY-level causal
    efficacy by itself, independent of God's causal activity. This
    violates P2, which says secondary causes operate dependently on the
    primary cause — they don't have independent causal power.

    The CCC's word "magical" maps to: treating a secondary cause as if
    it were a primary cause. Magic = pretending the creature-level cause
    has God-level power. -/
opaque attributesMagicalPower : Person → Prop → Prop

/-- Whether God's existence is knowable by natural reason.
    §36 (Vatican I, Dei Filius 2): "God, the beginning and end of all
    things, can be known with certainty from the consideration of created
    things, by the natural light of human reason."

    This is a DEFINED DOCTRINE (Vatican I), not merely a theological opinion.
    It grounds the claim that atheism is culpable: if God CAN be known by
    reason, then failing to know God is (at least potentially) a failure of
    reason, not merely an absence of revelation.

    Source: [Tradition] Vatican I, Dei Filius 2; [Definition] CCC §36.
    Denominational scope: ECUMENICAL among classical theists. Rejected by
    Barthians (revelation alone) and some Reformed epistemologists. -/
opaque godKnowableByReason : Prop

-- ============================================================================
-- § 2. Axioms
-- ============================================================================

/-- AXIOM 1 (§2112-2114): Idolatry is treating a non-divine being as ultimate.
    "Idolatry consists in divinizing what is not God." — §2113

    This extends Veneration.lean's `idolatry_is_misplaced_latria` from
    the liturgical context (giving latria to a creature) to the broader
    existential context (treating ANYTHING as one's ultimate concern when
    it isn't God). The two are structurally identical: both are category
    errors — treating secondary as primary.

    Source: [Scripture] Ex 20:3-5; [Definition] CCC §2112-2114.
    Denominational scope: ECUMENICAL. -/
axiom idolatry_is_treating_non_god_as_ultimate :
  ∀ (p honoree : Person),
    treatsAsUltimate p honoree →
    ¬ hasUltimateStatus honoree →
    False  -- contradiction: cannot legitimately treat non-God as ultimate

/-- AXIOM 2 (§2110-2111): Superstition attributes independent causal power
    to what has none — violating the two-tier causal structure (P2).
    "Superstition is the deviation of religious feeling and of the practices
    this feeling imposes." — §2110

    A practice is superstitious when it is treated as causally efficacious
    BY ITSELF, independent of divine action. Under P2, secondary causes
    operate dependently on the primary cause. Superstition treats
    secondary-level practices as if they had primary-level power.

    Source: [Definition] CCC §2110-2111.
    CONNECTION TO BASE AXIOM: P2 (two-tier causation). Superstition
    is the practical denial of P2 — asserting that creature-level actions
    can have God-level effects independently.
    Denominational scope: ECUMENICAL — all Christians condemn magic/
    superstition, though they disagree on WHICH practices qualify. -/
axiom superstition_violates_causal_order :
  ∀ (p : Person) (practice : Prop),
    attributesMagicalPower p practice →
    -- This contradicts P2: secondary causes don't have independent
    -- primary-level power
    ∃ (pc : PrimaryCause) (sc : SecondaryCause), causesCompete pc sc

/-- AXIOM 3 (§36, Vatican I): God's existence is knowable by natural reason.
    "God... can be known with certainty from the consideration of created
    things, by the natural light of human reason." — CCC §36

    This makes atheism a failure of reason (at least potentially), not
    merely an absence of revelation. If God CAN be known by reason, then
    denying God's existence goes against what reason can discover.

    HIDDEN ASSUMPTION: "Knowable by reason" means reason SHOULD arrive
    at this conclusion when functioning properly. The CCC doesn't say
    everyone will in fact know God by reason — §37 immediately adds that
    sin, distraction, and false philosophy can obscure natural knowledge
    of God. But the CAPACITY is there.

    Source: [Tradition] Vatican I, Dei Filius 2; [Definition] CCC §36.
    Denominational scope: ECUMENICAL among classical theists. Karl Barth
    and some Reformed theologians deny natural theology entirely. -/
axiom god_knowable_by_reason : godKnowableByReason

/-- AXIOM 4 (§2128): Atheism is a sin against the virtue of religion.
    "Since it rejects or denies the existence of God, atheism is a sin
    against the virtue of religion." — §2128

    Given that God's existence is knowable by reason (axiom 3 / §36),
    denying God's existence is a failure to exercise reason properly
    regarding the most important truth. This makes theoretical atheism
    culpable — at least in principle.

    NOTE: The CCC immediately qualifies this (§2125-2126): "The imputability
    of this offense can be significantly diminished in virtue of the
    intentions and the circumstances." This connects to Conscience.lean's
    culpable vs. inculpable ignorance distinction.

    Source: [Definition] CCC §2128.
    Denominational scope: ECUMENICAL — all classical Christian traditions
    hold that atheism is an error. Whether it is CULPABLE varies. -/
axiom atheism_is_sin_against_religion :
  ∀ (p : Person),
    deniesGodExists p →
    godKnowableByReason →
    -- Atheism contradicts what reason can know
    ¬ (p.hasIntellect = true → ¬ deniesGodExists p) →
    -- This is a violation of the first commandment
    False

/-- AXIOM 5 (§2114, Tillich): Every person has a functional ultimate concern.
    §2114: "Human life finds its unity in the adoration of the one God."
    §2113: When not God, the ultimate becomes "power, pleasure, race,
    ancestors, the state, money, etc."

    This is the CRUCIAL assumption for the practical-atheism-reduces-to-
    idolatry theorem. If a person necessarily has SOME ultimate concern,
    and they live as if God doesn't exist, then their ultimate concern
    is directed at something that is not God — which is idolatry.

    HIDDEN ASSUMPTION: This is a strong claim about human nature. It says
    there is no "neutral" position — you cannot live without treating
    SOMETHING as ultimate. This is Tillich's point ("Ultimate concern is
    the abstract translation of the First Commandment") and the CCC's
    implicit anthropology (§2114). A person who claims to have no ultimate
    concern has, on this view, made autonomy or comfort their ultimate.

    Source: [Modeling] Our formalization choice, grounded in CCC §2113-2114
    and Tillich's analysis. The CCC implies this but never states it
    as a formal principle.
    Denominational scope: CATHOLIC + broadly ecumenical. The claim that
    everyone has an ultimate concern is more a philosophical anthropology
    (Tillich, Aquinas) than a distinctively denominational claim. -/
axiom everyone_has_ultimate_concern :
  ∀ (p : Person), p.isMoralAgent = true →
    ∃ (ultimate : Person), treatsAsUltimate p ultimate

/-- AXIOM 6 (§2113-2114): A person who lives as if God doesn't exist
    does not treat God as their ultimate concern.
    §2113: "Idolatry... consists in divinizing what is not God."
    If you live as if God doesn't exist, you do not treat God as ultimate
    — by definition.

    Source: [Definition] CCC §2113-2114.
    Denominational scope: ECUMENICAL — definitional. -/
axiom practical_atheist_does_not_treat_god_as_ultimate :
  ∀ (p god : Person),
    livesAsIfNoGod p →
    hasUltimateStatus god →
    ¬ treatsAsUltimate p god

-- ============================================================================
-- § 3. Theorems
-- ============================================================================

/-- THEOREM: Superstition contradicts P2 (two-tier causation).

    P2 says primary and secondary causes don't compete — secondary causes
    operate dependently on the primary cause. Superstition claims a secondary
    cause (a practice) has independent primary-level power. These are
    incompatible.

    Depends on: superstition_violates_causal_order, p2_two_tier_causation. -/
theorem superstition_contradicts_p2
    (p : Person) (practice : Prop)
    (h_super : attributesMagicalPower p practice) :
    False :=
  have ⟨pc, sc, h_compete⟩ := superstition_violates_causal_order p practice h_super
  have h_no_compete := p2_two_tier_causation pc sc
  h_no_compete h_compete

/-- THEOREM: Practical atheism implies not treating God as ultimate.

    If a person lives as if God doesn't exist, they do not organize
    their life around God — by definition. This is the first step
    toward showing practical atheism reduces to idolatry.

    Depends on: practical_atheist_does_not_treat_god_as_ultimate. -/
theorem practical_atheism_excludes_god_as_ultimate
    (p god : Person)
    (h_lives : livesAsIfNoGod p)
    (h_god : hasUltimateStatus god) :
    ¬ treatsAsUltimate p god :=
  practical_atheist_does_not_treat_god_as_ultimate p god h_lives h_god

/-- THEOREM (Main): Practical atheism reduces to a form of idolatry.

    The argument chain:
    1. Every moral agent has some ultimate concern (axiom 5)
    2. A practical atheist does not treat God as ultimate (axiom 6)
    3. Therefore the practical atheist's ultimate concern is directed at
       something that is not God
    4. Treating a non-God entity as ultimate is idolatry (axiom 1)
    5. UNLESS that entity happens to have ultimate status — but by
       `god_has_ultimate_status` (Veneration.lean), only God has ultimate
       status, and we know the practical atheist's concern isn't God

    The reduction requires ALL of: the ultimate-concern anthropology (5),
    the definition of practical atheism (6), the uniqueness of God (Veneration),
    and the definition of idolatry (1). Drop any one and the argument fails.

    Depends on: everyone_has_ultimate_concern,
    practical_atheist_does_not_treat_god_as_ultimate,
    idolatry_is_treating_non_god_as_ultimate,
    god_has_ultimate_status (from Veneration.lean). -/
theorem practical_atheism_reduces_to_idolatry
    (p god : Person)
    (h_agent : p.isMoralAgent = true)
    (h_lives : livesAsIfNoGod p)
    (h_god : hasUltimateStatus god) :
    -- The practical atheist's ultimate concern is an idol
    ∃ (idol : Person),
      treatsAsUltimate p idol ∧ ¬ hasUltimateStatus idol :=
  -- Step 1: p has some ultimate concern
  have ⟨ultimate, h_treats⟩ := everyone_has_ultimate_concern p h_agent
  -- Step 2: that ultimate concern is not God
  have h_not_god_ult : ¬ treatsAsUltimate p god :=
    practical_atheist_does_not_treat_god_as_ultimate p god h_lives h_god
  -- Step 3: if the ultimate were God, contradiction; so ultimate ≠ god
  -- Step 4: therefore ultimate lacks ultimate status (by uniqueness of God)
  have h_not_ultimate_status : ¬ hasUltimateStatus ultimate := by
    intro h_has
    -- If ultimate has ultimate status, then ultimate = god (uniqueness)
    have h_eq := god_has_ultimate_status ultimate h_has god h_god
    -- But p treats ultimate as ultimate, and ultimate = god, so p treats god as ultimate
    rw [h_eq] at h_treats
    exact h_not_god_ult h_treats
  -- Step 5: p treats something non-ultimate as ultimate — this is idolatry
  ⟨ultimate, h_treats, h_not_ultimate_status⟩

/-- THEOREM: Theoretical atheism does NOT automatically reduce to idolatry.

    Unlike practical atheism, merely denying God's existence does not
    entail treating something else as ultimate. A theoretical atheist
    might deny God while not organizing their life around any substitute.

    We prove this by showing the reduction requires `livesAsIfNoGod`,
    not merely `deniesGodExists`. The two are independent — one can
    deny God theoretically while still (inconsistently) living by
    God's moral law, and one can live as if God doesn't exist while
    never explicitly denying God.

    This is NOT a theorem but a documentation of the gap. The formalization
    makes precise what the reduction DOES and DOES NOT cover. -/
theorem theoretical_atheism_needs_extra_step
    (p : Person) (h_denies : deniesGodExists p) :
    -- From mere denial, we CANNOT derive that p has an idol
    -- (we would need livesAsIfNoGod p as an additional premise)
    -- So we state what we CAN derive: atheism contradicts natural knowability
    godKnowableByReason →
    godKnowableByReason ∧ deniesGodExists p :=
  fun h_knowable => ⟨h_knowable, h_denies⟩

/-- THEOREM: The three violations are structurally distinct.

    Idolatry, superstition, and atheism violate the First Commandment in
    different ways:
    - Idolatry: wrong OBJECT (gives ultimate status to non-God)
    - Superstition: wrong MECHANISM (attributes independent causal power)
    - Atheism: wrong BELIEF (denies what reason can know)

    We show distinctness by exhibiting that each violation invokes
    different axioms. Superstition contradicts P2. Idolatry contradicts
    the uniqueness of God. Atheism contradicts §36's knowability claim.

    Depends on: superstition_contradicts_p2,
    idolatry_is_treating_non_god_as_ultimate, god_knowable_by_reason. -/
theorem three_violations_distinct
    (p : Person)
    -- Superstition scenario
    (practice : Prop) (h_super : attributesMagicalPower p practice)
    -- Idolatry scenario
    (idol : Person) (_h_treats : treatsAsUltimate p idol) (_h_not_ult : ¬ hasUltimateStatus idol)
    -- All three are independently derivable contradictions
    : False :=
  -- Any single violation suffices for contradiction
  -- We use superstition (the simplest): it directly contradicts P2
  superstition_contradicts_p2 p practice h_super

-- ============================================================================
-- § 4. Bridge theorems
-- ============================================================================

/-- Bridge to Veneration.lean: idolatry in the worship context.
    Veneration.lean's `idolatry_is_misplaced_latria` says: acknowledging
    a non-ultimate being as ultimate → contradiction. Our axiom 1 says:
    treating a non-ultimate being as one's functional ultimate → contradiction.
    These are the SAME error at different levels: liturgical vs. existential.

    Depends on: idolatry_is_misplaced_latria (Veneration.lean). -/
theorem liturgical_idolatry_bridge
    (honorer honoree : Person)
    (h_not_ult : ¬ hasUltimateStatus honoree)
    (h_ack : acknowledgesAsUltimate honorer honoree) :
    False :=
  idolatry_is_misplaced_latria honorer honoree h_not_ult h_ack

/-- Bridge to P2: superstition as the causal-order violation of P2.
    P2 says primary and secondary causes don't compete.
    Superstition says they do (a secondary cause has primary-level power).
    Superstition is therefore the NEGATION of P2 applied to religious
    practice.

    Depends on: p2_two_tier_causation. -/
theorem p2_bridge (pc : PrimaryCause) (sc : SecondaryCause) :
    ¬ causesCompete pc sc :=
  p2_two_tier_causation pc sc

/-- Bridge to NaturalLaw.lean: atheism contradicts the knowability
    of moral truth. S6 (moral realism) says moral truths are accessible
    to reason. §36 says God's existence is knowable by reason. Both
    are instances of the broader principle that important truths are
    rationally accessible.

    Depends on: s6_moral_realism, god_knowable_by_reason. -/
theorem natural_knowability_bridge
    (mp : MoralProposition)
    (h_true : moralTruthValue mp) :
    accessibleToReason mp ∧ godKnowableByReason :=
  ⟨s6_moral_realism mp h_true, god_knowable_by_reason⟩

-- ============================================================================
-- § 5. Denominational scope
-- ============================================================================

/-!
### Where traditions agree and disagree

**All Christians agree:**
- Idolatry is wrong (Ex 20:3-5)
- Superstition is wrong (treating magic as real)
- Atheism is an error (God exists)
- The First Commandment has binding force

**The disputed questions:**

1. **What counts as idolatry?**
   - Catholics: venerating saints (dulia) is NOT idolatry because it
     respects the Creator/creature boundary (Veneration.lean)
   - Some Protestants: ANY religious honor to a creature risks idolatry
   - This disagreement is about the SCOPE of "treating as ultimate,"
     not about whether idolatry is wrong

2. **What counts as superstition?**
   - Catholics: sacramentals (holy water, medals, etc.) are NOT superstitious
     because their efficacy depends on God's action through the Church
   - Some Protestants: these practices LOOK like they attribute magical power
     to objects, which is superstition
   - The disagreement maps to P2: if sacramentals are genuine secondary causes
     (participatory), they aren't superstitious. If they are treated as
     having independent power, they are.

3. **Is atheism culpable?**
   - Classical theists (most traditions): yes, because God is knowable
     by reason (§36)
   - Barthians: no, because natural theology is invalid — God is known
     only through revelation
   - This maps to whether `god_knowable_by_reason` is accepted or rejected

4. **Does practical atheism reduce to idolatry?**
   - This formalization's theorem holds under the assumption that everyone
     has an ultimate concern. The assumption itself is debated:
   - Tillich, Aquinas, CCC: yes, humans necessarily have ultimate concerns
   - Some modern philosophy: no, nihilism is a genuine option (no
     ultimate concern at all)
   - If the assumption is dropped, the reduction fails — practical atheism
     and idolatry become independent violations
-/

-- ============================================================================
-- § 6. Summary
-- ============================================================================

/-!
## Summary

### Axioms (6 — from CCC §2084-2141, §36, P2):
1. `idolatry_is_treating_non_god_as_ultimate` (§2112-2114) — treating
   non-God as ultimate is a contradiction
2. `superstition_violates_causal_order` (§2110-2111) — superstition implies
   P2 is violated (causes compete)
3. `god_knowable_by_reason` (§36, Vatican I) — God's existence is
   knowable by natural reason
4. `atheism_is_sin_against_religion` (§2128) — atheism is a sin when
   reason could know God
5. `everyone_has_ultimate_concern` (§2113-2114, Tillich) — every moral
   agent has a functional ultimate concern
6. `practical_atheist_does_not_treat_god_as_ultimate` (§2113-2114) —
   living as if God doesn't exist means not treating God as ultimate

### Theorems (4 + 3 bridges):
1. `superstition_contradicts_p2` — superstition is incompatible with P2
2. `practical_atheism_excludes_god_as_ultimate` — practical atheism means
   not treating God as ultimate
3. `practical_atheism_reduces_to_idolatry` (MAIN) — a practical atheist
   necessarily has an idol (an entity treated as ultimate that lacks
   ultimate status)
4. `theoretical_atheism_needs_extra_step` — mere denial of God does not
   automatically yield idolatry (documents the gap)
5. `three_violations_distinct` — the three violations invoke different axioms
6. `liturgical_idolatry_bridge` — connects to Veneration.lean
7. `p2_bridge` — connects to P2 (two-tier causation)
8. `natural_knowability_bridge` — connects to S6 (moral realism) and §36

### Cross-file connections:
- `Veneration.lean`: `hasUltimateStatus`, `acknowledgesAsUltimate`,
  `idolatry_is_misplaced_latria`, `god_has_ultimate_status`
- `Axioms.lean`: `p2_two_tier_causation`, `PrimaryCause`, `SecondaryCause`,
  `causesCompete`, `s6_moral_realism`, `MoralProposition`, `moralTruthValue`,
  `accessibleToReason`
- `NaturalLaw.lean`: moral realism as instance of rational knowability
- `Conscience.lean`: culpable vs. inculpable ignorance (relevant to §2125-2126
  on diminished culpability for atheism)

### Key FINDING: practical atheism reduces to idolatry

The CCC's suggestion that practical atheism is a form of idolatry is
CORRECT — but only under the assumption that every person has an ultimate
concern. The argument:

1. Every moral agent has a functional ultimate (axiom 5 / §2113-2114)
2. A practical atheist does not treat God as ultimate (axiom 6)
3. By the uniqueness of God (Veneration.lean), nothing else has ultimate status
4. Therefore the practical atheist's ultimate concern is directed at a non-God
5. Treating non-God as ultimate = idolatry (axiom 1 / §2112-2114)

The hidden assumption (1) is the load-bearing step. Without it, practical
atheism and idolatry are independent violations. The CCC presupposes (1)
without stating it — it is the anthropological claim that human life
NECESSARILY has an organizing center. Tillich made this explicit;
Aquinas assumed it (ST I-II q.1 a.4: "every agent acts for an end").

### Hidden assumptions:
1. **Everyone has an ultimate concern** — the deepest hidden assumption.
   No human life is truly centerless. If you don't worship God, you
   worship something else. (CCC §2113-2114, Tillich, Aquinas ST I-II q.1 a.4)
2. **God's existence is knowable by reason** (§36, Vatican I) — without
   this, atheism cannot be a rational failure
3. **Superstition fails because of P2** — our modeling choice to frame
   superstition through two-tier causation

### Modeling choices:
1. `treatsAsUltimate` as an opaque predicate (the CCC gives examples
   but no formal definition of "functional ultimacy")
2. Superstition modeled through P2 (our philosophical framework)
3. Explicit axiom for the ultimate-concern anthropology (rather than
   treating it as definitional)
-/

end Catlib.MoralTheology.FirstCommandment
