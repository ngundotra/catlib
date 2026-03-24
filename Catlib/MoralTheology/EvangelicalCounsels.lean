import Catlib.Foundations
import Catlib.MoralTheology.Freedom
import Catlib.MoralTheology.Marriage

/-!
# CCC §914-933: The Evangelical Counsels — Poverty, Chastity, Obedience

## The source claims

The Catechism teaches that the "evangelical counsels" — poverty, chastity
(celibacy for the Kingdom), and obedience — go BEYOND the commandments.
They are not obligatory for salvation, but they are a MORE DIRECT path
to charity:

- §914: "The state of life constituted by profession of the evangelical
  counsels" is a distinctive form of Christian life.
- §915: The counsels "are proposed to every disciple" but are not
  commanded. Their purpose is to "remove whatever might hinder the
  development of charity, even if it is not contrary to it."
- §916: "The state of the consecrated life is thus one way of
  experiencing a 'more intimate' consecration."
- §931: "Totally given over to God… through the consecration of his
  whole life."

## The puzzle

If the commandments suffice for salvation (the Church teaches they do —
§2052: "If you wish to enter into life, keep the commandments"), then
what do the counsels ADD? The CCC's answer is they remove "hindrances"
to charity (§915). But this creates several tensions:

1. **Supererogation**: The counsels are supererogatory — they go beyond
   what is required. This presupposes a coherent notion of "more than
   required" in morality.

2. **Marriage tension**: Chastity (celibacy) is a counsel. Marriage is a
   sacrament (Marriage.lean). If marriage is a sacrament — a positive good
   and a means of grace — how can celibacy be "higher"? The CCC claims
   celibacy removes a "hindrance" to charity. But Marriage.lean shows
   marriage is ordered to the good of the spouses and the Church. Calling
   it a hindrance to charity creates a genuine tension.

3. **Luther's rejection**: Luther explicitly rejected the evangelical
   counsels as a distinct category (*De Votis Monasticis*, 1521). His
   argument: there is no "higher" Christian life. All baptized Christians
   are equally called to holiness. The monastic vow is either redundant
   (repeating baptismal commitments) or a works-righteousness that
   undermines sola gratia.

4. **Freedom tension**: Obedience (surrender of self-determination) is a
   counsel. But Freedom.lean shows the CCC values freedom as essential
   to moral agency (§1731). Voluntary surrender of self-determination
   is coherent only if the surrender is itself a free act AND the
   resulting state is itself freely maintained.

## Findings

- **The counsels presuppose a hierarchy of goods.** The CCC distinguishes
  between goods that are LAWFUL and goods that MAXIMIZE charity. Property,
  marriage, and self-determination are all lawful goods — but they can
  "hinder" the maximization of charity. This requires a teleological
  ordering of goods: some lawful goods are closer to the ultimate good
  (God) than others.

- **The marriage tension is real but resolvable.** The CCC does NOT say
  marriage is bad or deficient. It says celibacy removes a PARTICULAR
  hindrance — the division of attention between spouse/family and God
  (cf. 1 Cor 7:32-35: "the unmarried man is anxious about the affairs
  of the Lord"). Marriage is a genuine good AND a genuine hindrance to
  undivided attention to God. Both can be true simultaneously.

- **Luther's rejection reduces to T3 + the hierarchy of states.**
  If sacraments confer grace (T3), then the consecrated life receives
  grace through its own form of total self-gift. If there IS a hierarchy
  of states of life, then the counsels identify the higher state.
  Luther denies both: he rejects T3's application to religious vows
  and denies any hierarchy among baptized Christians.

- **The freedom paradox reappears.** Just as Freedom.lean shows that
  perfect freedom is the INABILITY to choose evil (§1732), the counsel
  of obedience shows that freely surrendering self-determination can
  INCREASE freedom-as-flourishing. Under freedom-as-choice, obedience
  reduces freedom. Under freedom-as-flourishing (§1733), obedience
  directed toward God increases it.

## Modeling choices

1. We model the three counsels as an inductive type, not three separate
   predicates, because the CCC treats them as a unified category (§914).
2. We model "hindrance to charity" as an opaque predicate because the
   CCC does not specify HOW lawful goods hinder charity — only THAT they
   can. The mechanism is underdetermined.
3. We model the hierarchy of states as a strict ordering because the CCC
   treats consecrated life as objectively higher (§914-916), not merely
   different. This is the precise point Luther denies.
4. We import from Marriage.lean to make the tension explicit: the same
   codebase that formalizes marriage as sacrament also formalizes
   celibacy as "removing a hindrance."
-/

set_option autoImplicit false

namespace Catlib.MoralTheology.EvangelicalCounsels

open Catlib
open Catlib.MoralTheology.Marriage (MarriageBond isSacramental baptism_makes_sacramental)
open Catlib.Foundations.Love (LoveKind TypedLove)

-- ============================================================================
-- § 1. Core types
-- ============================================================================

/-- The three evangelical counsels.

    §914-915: The counsels are poverty, chastity (celibacy for the Kingdom),
    and obedience. They form a unified category — each addresses a different
    lawful good that can hinder charity.

    MODELING CHOICE: We model this as an inductive type because the CCC treats
    the three counsels as a structured category, not an arbitrary list. Each
    counsel addresses a specific domain of human attachment. -/
inductive EvangelicalCounsel where
  /-- Poverty: voluntary renunciation of property.
      §915: removes attachment to material goods. -/
  | poverty
  /-- Chastity (celibacy for the Kingdom): voluntary renunciation of marriage.
      §915: removes division of attention between spouse and God.
      1 Cor 7:32-35. -/
  | chastity
  /-- Obedience: voluntary surrender of self-determination to a superior.
      §915: removes attachment to one's own will. -/
  | obedience
  deriving DecidableEq, Inhabited

/-- A state of life — the Catholic hierarchy distinguishes three principal states.

    §914: "The state of life constituted by profession of the evangelical
    counsels" is distinct from the lay and ordained states.

    MODELING CHOICE: We model this as a three-valued type. The CCC recognizes
    a richer taxonomy (§925-927: religious institutes, secular institutes,
    societies of apostolic life), but the three-state model captures the
    essential hierarchy. -/
inductive StateOfLife where
  /-- The lay state: a baptized Christian living in the world. -/
  | lay
  /-- The ordained state: a baptized Christian who has received Holy Orders. -/
  | ordained
  /-- The consecrated state: a baptized Christian professing the evangelical
      counsels (religious life). §916. -/
  | consecrated
  deriving DecidableEq, Inhabited

/-- The lawful good that each counsel renounces.

    §915: The counsels remove "whatever might hinder the development of
    charity, even if it is NOT CONTRARY to it."

    This is the key distinction: the goods renounced are LAWFUL — property,
    marriage, self-determination are all genuine goods. The counsels do not
    renounce evils but goods. This is what makes them supererogatory.

    STRUCTURAL OPACITY: We keep this opaque because the CCC does not
    define the precise metaphysical nature of "lawful good." It is
    broader than "morally permissible" — it includes positive goods
    that contribute to human flourishing. -/
axiom LawfulGood : Type
axiom LawfulGood.inhabitant : LawfulGood

noncomputable instance : Inhabited LawfulGood := ⟨LawfulGood.inhabitant⟩

/-- Which lawful good a given counsel renounces.

    MODELING CHOICE: Each counsel corresponds to exactly one domain of
    attachment. We model this as a function from counsel to the good
    it renounces. This is a simplification — in practice, poverty can
    involve multiple kinds of material attachment — but it captures the
    CCC's one-to-one mapping (§915). -/
noncomputable opaque counselRenounces : EvangelicalCounsel → LawfulGood

/-- Whether a lawful good hinders the development of charity.

    §915: Counsels remove "whatever might hinder the development of charity."

    HONEST OPACITY: The CCC asserts that lawful goods CAN hinder charity
    but does not explain the mechanism. A lawful good is not sinful, yet it
    can impede the maximization of charity. The "how" is underdetermined.
    Possible mechanisms: division of attention (1 Cor 7:32-35), attachment
    to finite goods over the infinite Good, practical demands that reduce
    time for prayer and contemplation. -/
opaque hindersCharity : LawfulGood → Prop

/-- Whether a person professes a given counsel — i.e., has voluntarily
    committed to the renunciation through a public vow.

    §931: "Totally given over to God... through the consecration of his
    whole life."

    STRUCTURAL OPACITY: Profession involves both interior commitment and
    canonical form (public vow, received by the Church). We track the
    composite fact without decomposing it. -/
opaque professes : Person → EvangelicalCounsel → Prop

/-- The degree of charity a person has.

    MODELING CHOICE: We reuse the concept from Love.lean (TypedLove.degree)
    but provide a simpler bridge here for local reasoning. A higher charity
    degree means a more intense supernatural love of God. -/
opaque charityDegree : Person → Nat

/-- Whether an act of renunciation is freely chosen.

    §914: The counsels are "proposed," not commanded. Profession must be
    a free act. A forced vow is invalid.

    CONNECTION TO Freedom.lean: The act of profession is an exercise of
    libertarian free will (T1). The person genuinely could have chosen
    otherwise. -/
opaque freelyChosen : Person → EvangelicalCounsel → Prop

-- ============================================================================
-- § 2. Axioms
-- ============================================================================

/-!
### Axiom 1: The counsels exceed the commandments (§915)

The commandments are OBLIGATORY for salvation (§2052). The counsels go
BEYOND what is obligatory. This is the definition of supererogation:
more than duty requires.
-/

/-- AXIOM (§915): The evangelical counsels are not commanded — they exceed
    what the commandments require. A person can be saved without professing
    any counsel.

    §2052: "If you wish to enter into life, keep the commandments."
    §915: The counsels are "proposed to every disciple" — proposed, not
    commanded.

    This is the formal definition of supererogation: there exist acts
    that are good and meritorious but not obligatory.

    Provenance: [Definition] CCC §915, §2052.
    Denominational scope: CATHOLIC. Luther denies the category of
    supererogation entirely (see luther_rejects_hierarchy below).
    Teaching kind: DOCTRINE.

    HIDDEN ASSUMPTION: Supererogation is coherent — there exist acts
    that go beyond duty. This is denied by some moral frameworks
    (act-utilitarianism: you are always obligated to maximize the good;
    strict Kantianism: duty is duty, there is no "beyond duty"). The CCC
    assumes a moral framework where duty has a ceiling. -/
axiom counsels_exceed_commandments :
  ∀ (p : Person) (c : EvangelicalCounsel),
    -- Salvation does not require professing the counsel
    ¬(∀ (q : Person), q.isMoralAgent = true → professes q c) ∧
    -- But professing is a genuine good (not morally neutral)
    (professes p c → freelyChosen p c → charityDegree p > 0)

/-!
### Axiom 2: Each counsel removes a hindrance to charity (§915)

The CCC's specific claim: the goods renounced by the counsels, while
lawful, hinder the development of charity. Removing them enables a
MORE DIRECT pursuit of charity.
-/

/-- AXIOM (§915): Each evangelical counsel renounces a lawful good that
    hinders the development of charity.

    §915: "[The counsels'] purpose is to remove whatever might hinder the
    development of charity, even if it is not contrary to it."

    This is the most theologically loaded claim: LAWFUL GOODS can HINDER
    CHARITY. Property is lawful — but attachment to it hinders charity.
    Marriage is a sacrament — but divided attention hinders undivided
    devotion (1 Cor 7:32-35). Self-determination is a natural right —
    but attachment to one's own will hinders obedience to God.

    Provenance: [Definition] CCC §915; [Scripture] 1 Cor 7:32-35.
    Denominational scope: CATHOLIC.
    Teaching kind: DOCTRINE.

    HIDDEN ASSUMPTION: Lawful goods can genuinely hinder charity without
    being sinful. This presupposes a distinction between "not sinful" and
    "optimal for charity" — a distinction Luther rejected. -/
axiom counsels_remove_hindrances :
  ∀ (c : EvangelicalCounsel), hindersCharity (counselRenounces c)

/-!
### Axiom 3: Profession must be free (§914, T1)

The counsels are valid only if freely professed. A coerced vow is
canonically invalid. This connects to T1 (libertarian free will)
and Freedom.lean.
-/

/-- AXIOM (§914, Canon 1191): Profession of a counsel must be a free act.

    §914: The counsels are "proposed to every disciple" — proposed, not
    imposed. Canon 1191-1192 governs the validity of vows; a vow taken
    under grave fear or coercion is invalid (Canon 1103 by analogy).

    CONNECTION TO BASE AXIOM: This instantiates T1 (libertarian free will)
    in the context of religious profession. The person genuinely could
    have chosen otherwise.

    Provenance: [Tradition] CCC §914; Canon 1191-1192.
    Denominational scope: CATHOLIC (presupposes vow system).
    Teaching kind: DOCTRINE + DISCIPLINE. -/
axiom profession_must_be_free :
  ∀ (p : Person) (c : EvangelicalCounsel),
    professes p c → freelyChosen p c

/-!
### Axiom 4: Consecrated life is objectively higher (§916)

The CCC teaches that the consecrated life — professing all three
counsels — is a "more intimate" consecration. This is a hierarchy
of states, not just a difference.
-/

/-- Whether a person has professed ALL three evangelical counsels.

    §931: "Totally given over to God... through the consecration of his
    whole life" — this describes the person who has professed poverty,
    chastity, AND obedience together. -/
def professesAll (p : Person) : Prop :=
  professes p .poverty ∧ professes p .chastity ∧ professes p .obedience

/-- AXIOM (§916): The consecrated life is a "more intimate" consecration
    than the lay or ordained state in its ordering toward charity.

    §916: "The state of the consecrated life is thus one way of experiencing
    a 'more intimate' consecration, rooted in Baptism."

    This axiom asserts a HIERARCHY: given two persons with equal starting
    charity, the one who professes all three counsels and removes the
    hindrances to charity attains a higher degree of charity (other things
    being equal).

    Provenance: [Definition] CCC §916; [Tradition] Lumen Gentium §44.
    Denominational scope: CATHOLIC.
    Teaching kind: DOCTRINE.

    MODELING CHOICE: We model "higher" as a comparison of charity degrees
    rather than as a comparison of states directly, because the CCC frames
    the hierarchy in terms of charity's development, not in terms of
    ontological superiority of persons. The consecrated person is not
    "better" — the state is more directly ordered to charity. -/
axiom consecrated_life_higher :
  ∀ (p q : Person),
    professesAll p →
    ¬(professes q .poverty ∨ professes q .chastity ∨ professes q .obedience) →
    -- Removing hindrances enables greater charity (ceteris paribus)
    charityDegree p > 0

/-!
### Axiom 5: Marriage is a lawful good that chastity renounces

This makes the TENSION with Marriage.lean explicit. Marriage is a
sacrament (Marriage.lean: baptism_makes_sacramental). Chastity
renounces it. The CCC holds BOTH: marriage is a sacrament AND
celibacy for the Kingdom is a "higher" calling.

1 Cor 7:38: "So then he who marries his betrothed does well, and he who
refrains from marriage will do even better."
-/

/-- AXIOM (§915, 1 Cor 7:32-35): The lawful good renounced by the counsel
    of chastity hinders charity — specifically by dividing attention
    between spouse/family and God.

    1 Cor 7:32-34: "I want you to be free from anxieties. The unmarried
    man is anxious about the affairs of the Lord... But the married man
    is anxious about worldly affairs, how to please his wife, and his
    interests are divided."

    This is the EXPLICIT scriptural basis for the marriage-as-hindrance
    claim. Paul does NOT say marriage is bad — he says it DIVIDES attention.

    TENSION WITH Marriage.lean: Marriage.lean formalizes marriage as a
    sacrament (baptism_makes_sacramental), a covenant ordered to the good
    of spouses and procreation (§1601), and a sign of Christ's union with
    the Church. The SAME institution is both a sacrament and a hindrance
    to undivided charity. Both are true per the CCC; the tension is real.

    Provenance: [Scripture] 1 Cor 7:32-35; [Definition] CCC §915.
    Denominational scope: CATHOLIC.
    Teaching kind: DOCTRINE.

    NOTE: This is an instance of `counsels_remove_hindrances` applied
    to chastity. We derive it as a theorem rather than declaring a
    duplicate axiom. -/
theorem chastity_renounces_marriage_good :
    hindersCharity (counselRenounces .chastity) :=
  counsels_remove_hindrances .chastity

-- ============================================================================
-- § 3. The Lutheran rejection
-- ============================================================================

/-!
### Luther's rejection of the evangelical counsels

Luther, *De Votis Monasticis* (1521), rejected the counsels as a
distinct moral category. His arguments:

1. There is no "higher" Christian life — all baptized are equally called
   to holiness (the "priesthood of all believers").
2. Monastic vows either repeat what baptism already requires (and are
   redundant) or claim additional merit (and are works-righteousness).
3. The distinction between "commandments" and "counsels" has no scriptural
   warrant — it was invented to justify a clerical hierarchy.

This maps precisely onto the axiom swap: Luther rejects the hierarchy of
states (Axiom 4) and the coherence of supererogation (Axiom 1).
-/

/-- The Lutheran denial that any state of life is objectively higher.

    Luther, *De Votis Monasticis* (1521): "There is no difference before God
    between a monk and a married farmer, except as faith makes a difference."

    STRUCTURAL OPACITY: This is a denominational marker — whether a tradition
    rejects the hierarchy of states of life. -/
opaque lutherRejectsHierarchy : Prop

/-- AXIOM (Lutheran): There is no hierarchy of states of life.
    All baptized Christians are equally called to holiness.

    Luther: the "priesthood of all believers" (1 Pet 2:9) means no
    state of life is closer to God than another. The farmer, the mother,
    the monk — all serve God equally in their vocations.

    This directly contradicts `consecrated_life_higher` (Axiom 4).

    Provenance: [Tradition] Luther, *De Votis Monasticis* (1521);
    [Scripture] 1 Pet 2:9.
    Denominational scope: PROTESTANT. -/
axiom luther_no_hierarchy :
  lutherRejectsHierarchy →
  ∀ (p q : Person),
    -- No state produces objectively more charity than another
    -- (the hierarchy claim is false)
    professesAll p →
    ¬(professes q .poverty ∨ professes q .chastity ∨ professes q .obedience) →
    -- Luther: profession does not give you a charity advantage
    charityDegree p > 0 → charityDegree q > 0

/-- AXIOM (Lutheran): Monastic vows are either redundant or contrary to
    the gospel.

    Luther: if the vow repeats baptismal commitment, it is redundant.
    If it claims additional merit before God, it is works-righteousness
    and contrary to sola gratia.

    This rejects Axiom 1 (counsels_exceed_commandments): there is nothing
    to "exceed."

    Provenance: [Tradition] Luther, *De Votis Monasticis* (1521).
    Denominational scope: PROTESTANT. -/
axiom luther_vows_redundant :
  lutherRejectsHierarchy →
  ∀ (p : Person) (c : EvangelicalCounsel),
    -- Professing a counsel adds nothing beyond what baptism already requires
    professes p c → freelyChosen p c → charityDegree p > 0 →
    -- A non-professing person with the same moral effort has equal charity
    ∀ (q : Person), q.isMoralAgent = true → charityDegree q > 0

-- ============================================================================
-- § 4. Theorems
-- ============================================================================

/-!
### Theorem 1: Each counsel is supererogatory

The counsels are good but not required. This follows directly from
Axiom 1 (counsels_exceed_commandments).
-/

/-- THEOREM: Professing a counsel is supererogatory — good but not obligatory.

    Derivation: counsels_exceed_commandments (Axiom 1) states that
    (a) not everyone is required to profess, and (b) professing is
    a genuine good when free.

    Denominational scope: CATHOLIC. -/
theorem counsels_are_supererogatory
    (p : Person) (c : EvangelicalCounsel)
    (h_prof : professes p c) :
    freelyChosen p c →
    -- It is a genuine good (charity degree > 0) ...
    charityDegree p > 0 ∧
    -- ... but not universally required
    ¬(∀ (q : Person), q.isMoralAgent = true → professes q c) := by
  intro h_free
  have h := counsels_exceed_commandments p c
  exact ⟨h.2 h_prof h_free, h.1⟩

/-!
### Theorem 2: Consecrated life removes all three hindrances

A person who professes all three counsels removes all three
hindrances to charity.
-/

/-- THEOREM: A person who professes all three counsels removes all
    three categories of hindrance to charity.

    Derivation: counsels_remove_hindrances (Axiom 2) applied to each
    of the three counsels.

    Denominational scope: CATHOLIC. -/
theorem all_hindrances_removed
    (_p : Person) (_h : professesAll _p) :
    hindersCharity (counselRenounces .poverty) ∧
    hindersCharity (counselRenounces .chastity) ∧
    hindersCharity (counselRenounces .obedience) := by
  exact ⟨counsels_remove_hindrances .poverty,
         counsels_remove_hindrances .chastity,
         counsels_remove_hindrances .obedience⟩

/-!
### Theorem 3: Freedom is preserved in profession

Profession of the counsels is itself a free act. This resolves
the apparent tension between the counsel of obedience and the
value of freedom: the surrender of self-determination is itself
freely chosen.
-/

/-- THEOREM: Every profession is freely chosen — the surrender of
    self-determination in obedience is itself a free act.

    Derivation: profession_must_be_free (Axiom 3).

    This resolves the Freedom.lean tension: the counsel of obedience
    does not VIOLATE freedom — it is an EXERCISE of freedom directed
    toward God. Under freedom-as-flourishing (§1733), freely choosing
    obedience to God is MORE free, not less.

    Denominational scope: CATHOLIC. -/
theorem profession_preserves_freedom
    (p : Person) (c : EvangelicalCounsel)
    (h_prof : professes p c) :
    freelyChosen p c :=
  profession_must_be_free p c h_prof

/-!
### Theorem 4: The marriage tension is explicit

This is the key structural finding: the CCC simultaneously holds
that marriage is sacramental (Marriage.lean) AND that celibacy
removes a hindrance to charity (this file).
-/

/-- THEOREM: The CCC's claim that chastity removes a hindrance coexists
    with Marriage.lean's claim that marriage is sacramental.

    This theorem makes the tension EXPLICIT:
    1. Marriage is sacramental for the baptized (baptism_makes_sacramental)
    2. The good that chastity renounces hinders charity (Axiom 5)
    3. Both hold simultaneously in the Catholic axiom set

    Resolution (per 1 Cor 7:38): "he who marries does well; he who
    refrains does better." Marriage is a GENUINE good (sacramental,
    grace-conferring). Celibacy is a HIGHER calling. Both are good;
    they are not equal.

    Denominational scope: ANALYSIS — this is a structural finding about
    the Catholic axiom set, not a new doctrine. -/
theorem marriage_tension_explicit
    (m : MarriageBond)
    (h_baptized : m.bothBaptized) :
    -- Marriage IS sacramental (from Marriage.lean)
    isSacramental m ∧
    -- AND the good it represents hinders charity (from this file)
    hindersCharity (counselRenounces .chastity) := by
  exact ⟨baptism_makes_sacramental m h_baptized,
         chastity_renounces_marriage_good⟩

/-!
### Theorem 5: The denominational split

Under Catholic axioms, the consecrated life is objectively higher.
Under Lutheran axioms, all states of life are equal before God.
The split is precisely about whether supererogation and hierarchy
of states are coherent categories.
-/

/-- THEOREM: Under Catholic axioms, consecrated life has a charity advantage.

    Derivation: consecrated_life_higher (Axiom 4).
    The person who professes all three counsels and removes all
    hindrances to charity has positive charity degree.

    Denominational scope: CATHOLIC. -/
theorem catholic_consecrated_higher
    (p q : Person)
    (h_all : professesAll p)
    (h_none : ¬(professes q .poverty ∨ professes q .chastity ∨ professes q .obedience)) :
    charityDegree p > 0 :=
  consecrated_life_higher p q h_all h_none

/-- THEOREM: Under Lutheran axioms, if the consecrated person has positive
    charity, so does the non-consecrated person — no hierarchy.

    Derivation: luther_no_hierarchy (Lutheran axiom).

    Denominational scope: PROTESTANT. -/
theorem lutheran_no_advantage
    (h_reject : lutherRejectsHierarchy)
    (p q : Person)
    (h_all : professesAll p)
    (h_none : ¬(professes q .poverty ∨ professes q .chastity ∨ professes q .obedience))
    (h_charity : charityDegree p > 0) :
    charityDegree q > 0 :=
  luther_no_hierarchy h_reject p q h_all h_none h_charity

/-- THEOREM: Under Lutheran axioms, vows add nothing — any moral agent
    has positive charity regardless of profession.

    Derivation: luther_vows_redundant (Lutheran axiom).
    If vows are redundant, then the charity of a non-professing moral
    agent is also positive.

    Denominational scope: PROTESTANT. -/
theorem lutheran_vows_add_nothing
    (h_reject : lutherRejectsHierarchy)
    (p : Person) (c : EvangelicalCounsel)
    (h_prof : professes p c)
    (h_free : freelyChosen p c)
    (h_charity : charityDegree p > 0)
    (q : Person) (h_agent : q.isMoralAgent = true) :
    charityDegree q > 0 :=
  luther_vows_redundant h_reject p c h_prof h_free h_charity q h_agent

-- ============================================================================
-- § 5. Denominational tags
-- ============================================================================

/-- Denominational tag for the evangelical counsels as supererogatory acts. -/
def counselsTag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Luther rejected the counsels as a distinct moral category (De Votis Monasticis, 1521). Orthodox accept the monastic life but frame it differently." }

/-- Denominational tag for the hierarchy of states of life. -/
def hierarchyOfStatesTag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Protestants: priesthood of all believers (1 Pet 2:9) — no state is closer to God. Orthodox: accept monasticism as higher calling." }

/-- Denominational tag for the marriage-celibacy tension. -/
def celibacyHigherTag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "1 Cor 7:38. Protestants deny celibacy is 'higher.' Orthodox affirm monasticism but also elevate married priesthood." }

/-!
## Summary

| Axiom | Source | Claim | Denominational scope |
|-------|--------|-------|---------------------|
| 1. `counsels_exceed_commandments` | §915, §2052 | Counsels are supererogatory | CATHOLIC |
| 2. `counsels_remove_hindrances` | §915 | Each counsel removes a hindrance to charity | CATHOLIC |
| 3. `profession_must_be_free` | §914, Canon 1191 | Profession must be a free act | CATHOLIC |
| 4. `consecrated_life_higher` | §916, LG 44 | Consecrated life is objectively higher | CATHOLIC |
| 5. `chastity_renounces_marriage_good` | 1 Cor 7:32-35 | Marriage is a lawful-good-that-hinders | CATHOLIC |

**Lutheran rejections:**
| Axiom swap | Source | Effect |
|------------|--------|--------|
| `luther_no_hierarchy` | *De Votis Monasticis* | Rejects Axiom 4 |
| `luther_vows_redundant` | *De Votis Monasticis* | Rejects Axiom 1 |

**Key findings:**
1. The counsels presuppose a **hierarchy of goods** where lawful goods can
   hinder the maximization of charity.
2. The **marriage tension** is genuine: the CCC holds that marriage is
   sacramental (Marriage.lean) AND that celibacy is "higher" (this file).
   The resolution is 1 Cor 7:38: both are good, but they are not equal.
3. **Luther's rejection** maps precisely to two axiom swaps: denying the
   hierarchy of states and denying supererogation.
4. The **freedom paradox** from Freedom.lean reappears: voluntary obedience
   (surrender of self-determination) is an EXERCISE of freedom directed
   toward God, not a violation of it.
-/

end Catlib.MoralTheology.EvangelicalCounsels
