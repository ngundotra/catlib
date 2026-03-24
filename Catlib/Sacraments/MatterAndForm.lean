import Catlib.Foundations
import Catlib.Sacraments.SacramentalCausation
import Catlib.Sacraments.Baptism
import Catlib.Sacraments.Eucharist

/-!
# CCC §1131 + Aquinas ST III q.60 a.6: Matter and Form of Each Sacrament

## The source claims

Aquinas (ST III q.60 a.6): "In the sacraments the words are as the form and
the sensible things are as the matter." Sacraments are SIGNS, and signs
require both a determinable element (matter — the physical component) and
a determining element (form — the verbal component). This is hylomorphism
applied to sacramental signs: just as a human person is the composite of
body (matter) and soul (form), a sacrament is the composite of physical
element (matter) and ritual words (form).

The CCC teaches the specific matter and form for each sacrament:
- **Baptism** (§1239-1240): water + Trinitarian formula ("I baptize you
  in the name of the Father, and of the Son, and of the Holy Spirit")
- **Eucharist** (§1333-1336): bread and wine + words of institution
  ("This is my body... This is my blood")
- **Confirmation** (§1300): sacred chrism + "Be sealed with the Gift
  of the Holy Spirit"
- **Reconciliation** (§1449): confession of sins + absolution formula
  ("I absolve you from your sins...")
- **Anointing** (§1519): oil of the sick + prayer of the priest
- **Holy Orders** (§1573): laying on of hands + consecratory prayer
- **Marriage** (§1626-1627): the persons themselves + mutual consent

## The puzzle

Why does EVERY sacrament have BOTH a material and a verbal component?
Why not words alone? Why not matter alone?

## The hylomorphic answer (Aquinas ST III q.60 a.6)

Aquinas applies the matter/form (hylomorphic) framework to SIGNS:

1. A sign must signify something DETERMINATE (a splash of water by
   itself could mean washing, play, or baptism).
2. The matter (physical element) is the DETERMINABLE component —
   it provides the raw sign-material but is ambiguous on its own.
3. The form (words) is the DETERMINING component — it specifies
   WHICH signification the matter bears.
4. Therefore every sacrament needs both: matter to provide the
   sensible sign, form to determine its meaning.

This is NOT the hylomorphism of PERSONS (body-soul unity, §365).
It is hylomorphism applied to SIGNS. The analogy is:
- Person = body (matter) + soul (form)
- Sacrament = physical element (matter) + words (form)

The CCC assumes this Thomistic framework without making it explicit.
It simply lists the matter and form for each sacrament as if the
pattern were obvious. Our formalization makes the pattern and its
philosophical basis explicit.

## Hidden assumptions

1. **Signs have hylomorphic structure** (Aquinas ST III q.60 a.6).
   The CCC does not argue for this — it inherits it from Aquinas.
   This is a PHILOSOPHICAL INFRASTRUCTURE commitment, not a revealed
   doctrine. An alternative: signs could be holistic (no matter/form
   distinction), or conventional (meaning assigned by community
   agreement, not requiring any physical element).

2. **Matter is determinable, form determines** (Aristotle, Metaphysics
   Z). The asymmetry between matter and form — matter is open to
   multiple determinations, form specifies one — is the core of the
   hylomorphic framework. Applied to sacraments: water alone is
   ambiguous, but "I baptize you in the name of..." fixes the meaning.

3. **Validity requires BOTH components** (Council of Florence, Decretum
   pro Armenis, 1439). A sacrament with only matter (water without the
   Trinitarian formula) or only form (words without water) is INVALID.
   This follows from the hylomorphic structure: a sign without both
   components is not a sign at all.

4. **Marriage is the anomalous case**: the "matter" is the persons
   themselves and the "form" is their mutual consent (§1626-1627).
   This stretches the hylomorphic analogy — the persons are not
   consumed or transformed the way water or bread is used. Aquinas
   himself acknowledges this (ST III Suppl. q.42 a.1): in marriage,
   the contracting parties are both the matter and the ministers.

## Modeling choices

1. We model matter and form as opaque predicates indexed by
   `SacramentKind`, not as concrete physical descriptions. The CCC
   specifies what the matter and form ARE for each sacrament; we
   track whether they are PRESENT, not what they consist of.

2. We model validity as requiring both matter and form. This is the
   key structural claim: neither alone suffices.

3. We model the marriage anomaly explicitly: marriage has matter and
   form, but its matter is the persons themselves (not an external
   physical element). This is an honest departure from the standard
   pattern, flagged as such.

4. We connect to SacramentalCausation.lean: the matter/form structure
   is what makes a sacrament a SIGN, and SacramentalCausation models
   what the sign CAUSES.

## Denominational scope

- The hylomorphic analysis of sacraments is CATHOLIC (Aquinas/Trent).
- The claim that sacraments HAVE specific matter and form is shared by
  Catholic and Orthodox.
- Protestants who retain two sacraments (baptism, Lord's Supper) still
  recognize matter and form for those two — water + Trinitarian formula,
  bread/wine + words of institution.
- The PHILOSOPHICAL FRAMEWORK (hylomorphism applied to signs) is
  specifically Thomistic, not ecumenical.
-/

set_option autoImplicit false

namespace Catlib.Sacraments.MatterAndForm

open Catlib
open Catlib.Sacraments.SacramentalCausation (SacramentKind ChangeType causesChangeOfType
  every_sacrament_causes_change)

-- ============================================================================
-- § 1. Core Predicates: Sacramental Matter and Form
-- ============================================================================

/-- Whether the appropriate MATTER (physical/sensible element) is present
    for a given sacrament.

    Aquinas ST III q.60 a.6: "the sensible things are as the matter."
    The matter is the DETERMINABLE component — the physical sign-material
    that is ambiguous without the words.

    Each sacrament has specific matter:
    - Baptism: water (§1239)
    - Eucharist: bread and wine (§1333)
    - Confirmation: sacred chrism (§1300)
    - Reconciliation: the acts of the penitent, i.e. confession of sins (§1449)
    - Anointing: oil of the sick (§1519)
    - Holy Orders: laying on of hands (§1573)
    - Marriage: the persons of the spouses themselves (§1626)

    HONEST OPACITY: We do not define WHAT the matter consists of for each
    sacrament — we track WHETHER it is present. The CCC specifies the matter;
    we formalize the STRUCTURE (every sacrament needs matter), not the
    CONTENT (what specific matter each sacrament uses). -/
opaque hasMatter : SacramentKind → Prop

/-- Whether the appropriate FORM (verbal/ritual words) is present
    for a given sacrament.

    Aquinas ST III q.60 a.6: "the words are as the form."
    The form is the DETERMINING component — the words that specify
    which signification the matter bears.

    Each sacrament has specific form:
    - Baptism: "I baptize you in the name of the Father, and of the Son,
      and of the Holy Spirit" (§1240)
    - Eucharist: words of institution — "This is my body... This is the
      chalice of my blood..." (§1333-1336)
    - Confirmation: "Be sealed with the Gift of the Holy Spirit" (§1300)
    - Reconciliation: "I absolve you from your sins in the name of the
      Father, and of the Son, and of the Holy Spirit" (§1449)
    - Anointing: "Through this holy anointing may the Lord in his mercy
      help you with the grace of the Holy Spirit..." (§1519)
    - Holy Orders: consecratory prayer specific to each degree (§1573)
    - Marriage: mutual consent expressed in words (§1626-1627)

    HONEST OPACITY: Same rationale as `hasMatter` — we track presence,
    not specific content. -/
opaque hasForm : SacramentKind → Prop

/-- Whether a sacrament is validly celebrated — the sacrament achieves
    its effect (confers grace per T3).

    HONEST OPACITY: Validity depends on more than just matter and form
    (it also requires proper minister and intention — §1127-1128). We
    model only the matter/form component of validity here, not the
    full validity conditions. The axioms below constrain this predicate
    to require at minimum both matter and form. -/
opaque isValidlyCelebrated : SacramentKind → Prop

/-- Whether a sacramental sign is DETERMINATE — i.e., it unambiguously
    signifies what the sacrament intends.

    Aquinas ST III q.60 a.6: matter alone is indeterminate (water could
    mean many things); form determines the matter to signify baptism
    specifically. A determinate sign has both components.

    MODELING CHOICE: We introduce this predicate to capture the Thomistic
    insight that the FUNCTION of having both matter and form is to produce
    a determinate sign. This is our analytical tool; the CCC does not use
    this terminology. -/
opaque isDeterminateSign : SacramentKind → Prop

-- ============================================================================
-- § 2. Marriage: The Anomalous Case
-- ============================================================================

/-- Whether the matter of a sacrament is an EXTERNAL physical element
    (water, bread, oil, etc.) or the PERSONS THEMSELVES.

    For six of seven sacraments, the matter is an external element used
    in the rite. For marriage, the "matter" is the contracting parties
    themselves — their persons, given to each other.

    MODELING CHOICE: This distinction is our way of flagging marriage's
    anomaly within the hylomorphic framework. Aquinas acknowledges it
    (ST III Suppl. q.42 a.1): in marriage, the contracting parties are
    both the matter and the ministers. -/
opaque hasExternalMatter : SacramentKind → Prop

-- ============================================================================
-- § 3. Denominational Tags
-- ============================================================================

/-- The hylomorphic analysis of sacraments is Thomistic philosophical
    infrastructure, not revealed doctrine. The CCC inherits it from
    Aquinas without arguing for it. -/
def hylomorphicSignTag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Thomistic framework (ST III q.60 a.6). Orthodox share the matter/form analysis. Protestants retain it for baptism and Lord's Supper." }

/-- The specific matter and form for each sacrament is CATHOLIC
    (defined by Council of Florence and Council of Trent). -/
def matterFormSpecificsTag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Council of Florence, Decretum pro Armenis (1439); Council of Trent. Orthodox agree on the seven sacraments' matter and form." }

-- ============================================================================
-- § 4. Axioms — The Hylomorphic Structure of Sacramental Signs
-- ============================================================================

/-!
### Axiom 1: Every sacrament has matter (Aquinas ST III q.60 a.6, CCC §1131)

Signs require a sensible component. Sacraments are signs (§1131: "efficacious
signs of grace"). Therefore every sacrament has a physical/sensible element.
-/

/-- AXIOM (ST III q.60 a.6, §1131): Every sacrament has matter —
    a physical or sensible component that serves as the determinable
    element of the sacramental sign.

    This is the MATERIAL UNIVERSALITY claim: not just some sacraments
    but ALL SEVEN have matter (even marriage, where the "matter" is
    the persons themselves).

    Provenance: [Tradition] Aquinas ST III q.60 a.6; Council of Florence,
    Decretum pro Armenis (1439); [CCC] §1131.
    Denominational scope: CATHOLIC.

    HIDDEN ASSUMPTION (Aquinas): Signs are hylomorphic — they have
    matter/form structure. This is a philosophical claim about the
    nature of signification, not a revealed doctrine. -/
axiom every_sacrament_has_matter :
  ∀ (s : SacramentKind), hasMatter s

/-!
### Axiom 2: Every sacrament has form (Aquinas ST III q.60 a.6, CCC §1131)

The words determine what the matter signifies. Without words, the physical
element is ambiguous.
-/

/-- AXIOM (ST III q.60 a.6, §1131): Every sacrament has form —
    a verbal/ritual component that determines what the matter signifies.

    Provenance: [Tradition] Aquinas ST III q.60 a.6; Council of Florence,
    Decretum pro Armenis (1439); [CCC] §1131.
    Denominational scope: CATHOLIC.

    HIDDEN ASSUMPTION (Aquinas): The verbal component DETERMINES the
    meaning of the physical component. This is the form/matter
    asymmetry applied to signs: matter is determinable, form
    determines. -/
axiom every_sacrament_has_form :
  ∀ (s : SacramentKind), hasForm s

/-!
### Axiom 3: Validity requires both matter and form

A sacrament celebrated without its proper matter or without its proper
form is INVALID — it does not confer grace. This is the structural
consequence of hylomorphism: just as a person without body or soul is
not a complete person, a sacrament without matter or form is not a
complete (valid) sacrament.
-/

/-- AXIOM (Council of Florence, 1439; CCC §1127-1128): A sacrament is
    validly celebrated only if both matter and form are present.

    This is the JOINT NECESSITY claim: matter alone is insufficient
    (water without the Trinitarian formula is not baptism), and form
    alone is insufficient (saying "I baptize you..." over nothing is
    not baptism either).

    Provenance: [Tradition] Council of Florence, Decretum pro Armenis
    (1439) — lists matter and form for each sacrament as conditions
    of validity; [CCC] §1127-1128.
    Denominational scope: CATHOLIC.

    NOTE: This axiom captures only the matter/form condition for
    validity. Full validity also requires proper minister and intention
    (§1127-1128), which we do not model here. -/
axiom validity_requires_both :
  ∀ (s : SacramentKind), isValidlyCelebrated s → hasMatter s ∧ hasForm s

/-!
### Axiom 4: Matter without form is indeterminate

The core of Aquinas's argument: the physical element alone does not
signify anything determinate. Water could mean purification, refreshment,
drowning, or baptism. Only the words fix the meaning.
-/

/-- AXIOM (ST III q.60 a.6): Matter without form does not produce a
    determinate sign. The physical element alone is ambiguous.

    Aquinas: "the signification of the sacrament is completed by the
    words" (ST III q.60 a.7). Without the words, the matter is open
    to multiple interpretations and therefore cannot function as a
    sacramental sign.

    Provenance: [Tradition] Aquinas ST III q.60 a.6-7.
    Denominational scope: CATHOLIC (Thomistic philosophical framework).

    HIDDEN ASSUMPTION: Determinacy of signification requires verbal
    specification. This is a claim about how signs work — matter is
    semantically underdetermined without form. -/
axiom matter_alone_indeterminate :
  ∀ (s : SacramentKind), hasMatter s → ¬hasForm s → ¬isDeterminateSign s

/-!
### Axiom 5: Both matter and form together produce a determinate sign

When both components are present, the sacramental sign is determinate:
it signifies exactly what the sacrament intends (e.g., water + Trinitarian
formula = baptism, not mere washing).
-/

/-- AXIOM (ST III q.60 a.6-7): Matter and form together produce a
    determinate sacramental sign.

    The form DETERMINES the matter: it specifies which of the matter's
    possible significations is actual. The result is an unambiguous sign.

    Provenance: [Tradition] Aquinas ST III q.60 a.6-7.
    Denominational scope: CATHOLIC (Thomistic framework).

    MODELING CHOICE: We state this as matter + form → determinate sign.
    Aquinas's full account also requires proper intention and minister,
    but for the matter/form analysis, this is the core claim. -/
axiom matter_and_form_determine :
  ∀ (s : SacramentKind), hasMatter s → hasForm s → isDeterminateSign s

/-!
### Axiom 6: Valid sacraments produce determinate signs

A validly celebrated sacrament is a determinate sign — it signifies what
it intends. This connects validity to determinacy.
-/

/-- THEOREM (§1127-1131): A validly celebrated sacrament is a determinate sign.

    This follows from validity requiring both matter and form (axiom 3)
    and both together producing a determinate sign (axiom 5).

    Depends on: validity_requires_both, matter_and_form_determine. -/
theorem valid_sacrament_is_determinate :
    ∀ (s : SacramentKind), isValidlyCelebrated s → isDeterminateSign s :=
  fun s h_valid =>
    let ⟨h_mat, h_form⟩ := validity_requires_both s h_valid
    matter_and_form_determine s h_mat h_form

/-!
### Axiom 7: Marriage's matter is not external

Marriage is the anomalous case. In the other six sacraments, the matter
is an external physical element (water, bread, oil, chrism, hands). In
marriage, the "matter" is the persons themselves.
-/

/-- AXIOM (§1626-1627, Aquinas ST III Suppl. q.42 a.1): Six sacraments
    have external matter (a physical element used in the rite). Marriage
    does not — its "matter" is the persons of the spouses themselves.

    §1626: "The Church holds the exchange of consent between the spouses
    to be the indispensable element that 'makes the marriage.'"

    §1627: "The consent consists in a 'human act by which the partners
    mutually give themselves to each other.'"

    The spouses are both the matter (they give themselves) and the
    ministers (they confer the sacrament on each other). This is unique
    among the seven sacraments.

    Provenance: [CCC] §1626-1627; [Tradition] Aquinas ST III Suppl. q.42 a.1.
    Denominational scope: CATHOLIC. -/
axiom marriage_matter_is_persons :
  ¬hasExternalMatter .marriage

/-- AXIOM (§1239, §1333, §1300, §1449, §1519, §1573): The other six
    sacraments have external matter — a physical element distinct from
    the persons involved.

    - Baptism: water (§1239)
    - Eucharist: bread and wine (§1333)
    - Confirmation: sacred chrism (§1300)
    - Reconciliation: acts of the penitent (§1449)
    - Anointing: oil of the sick (§1519)
    - Holy Orders: laying on of hands (§1573)

    Provenance: [CCC] §1239, §1333, §1300, §1449, §1519, §1573.
    Denominational scope: CATHOLIC. -/
axiom six_sacraments_have_external_matter :
  hasExternalMatter .baptism
  ∧ hasExternalMatter .eucharist
  ∧ hasExternalMatter .confirmation
  ∧ hasExternalMatter .reconciliation
  ∧ hasExternalMatter .anointingOfTheSick
  ∧ hasExternalMatter .holyOrders

-- ============================================================================
-- § 5. Theorems — What the Structure Reveals
-- ============================================================================

/-!
### Key findings

1. **Every sacrament is a composite sign** — matter + form together,
   never one without the other. This is hylomorphism applied to signs.

2. **Matter without form is insufficient** — the physical element alone
   cannot function as a sacramental sign because it is semantically
   indeterminate.

3. **Marriage is structurally anomalous** — it satisfies the matter/form
   schema but its matter is not an external element. Marriage is the
   ONLY sacrament where the persons are the matter.

4. **Validity and determinacy are linked** — a valid sacrament is always
   a determinate sign (valid → determinate), and determinacy requires
   both matter and form.
-/

/-- THEOREM: Every sacrament is a composite of matter and form.
    No sacrament lacks either component.

    This is the universal hylomorphic structure of sacramental signs.
    It follows directly from axioms 1 and 2.

    Depends on: every_sacrament_has_matter, every_sacrament_has_form. -/
theorem every_sacrament_is_composite :
    ∀ (s : SacramentKind), hasMatter s ∧ hasForm s :=
  fun s => ⟨every_sacrament_has_matter s, every_sacrament_has_form s⟩

/-- THEOREM: Every sacrament is a determinate sign — it signifies
    something unambiguous, because both matter and form are present.

    Depends on: every_sacrament_has_matter, every_sacrament_has_form,
    matter_and_form_determine. -/
theorem every_sacrament_is_determinate :
    ∀ (s : SacramentKind), isDeterminateSign s :=
  fun s => matter_and_form_determine s (every_sacrament_has_matter s) (every_sacrament_has_form s)

/-- THEOREM: Matter without form never produces a valid sacrament.

    If only matter is present (no form), the sacrament cannot be valid.
    This is the contrapositive of validity_requires_both: valid → form,
    so ¬form → ¬valid.

    This captures the practical consequence: pouring water on someone's
    head without the Trinitarian formula is NOT baptism.

    Depends on: validity_requires_both. -/
theorem matter_without_form_invalid :
    ∀ (s : SacramentKind), hasMatter s → ¬hasForm s →
      ¬isValidlyCelebrated s := by
  intro s _h_mat h_no_form h_valid
  exact h_no_form (validity_requires_both s h_valid).2

/-- THEOREM: Form without matter never produces a valid sacrament.

    Saying the baptismal formula over nothing (no water) is not baptism.

    Depends on: validity_requires_both. -/
theorem form_without_matter_invalid :
    ∀ (s : SacramentKind), hasForm s → ¬hasMatter s →
      ¬isValidlyCelebrated s := by
  intro s _h_form h_no_mat h_valid
  exact h_no_mat (validity_requires_both s h_valid).1

/-- THEOREM: Marriage is the unique sacrament without external matter.

    For every sacrament kind: it has external matter if and only if it
    is not marriage. Marriage's "matter" is the persons themselves.

    Depends on: marriage_matter_is_persons, six_sacraments_have_external_matter. -/
theorem marriage_uniquely_non_external :
    ∀ (s : SacramentKind), hasExternalMatter s ↔ s ≠ .marriage := by
  intro s
  constructor
  · intro h_ext h_eq
    cases h_eq
    exact marriage_matter_is_persons h_ext
  · intro h_ne
    have ⟨hb, he, hc, hr, ha, ho⟩ := six_sacraments_have_external_matter
    cases s with
    | baptism => exact hb
    | eucharist => exact he
    | confirmation => exact hc
    | reconciliation => exact hr
    | anointingOfTheSick => exact ha
    | holyOrders => exact ho
    | marriage => exact absurd rfl h_ne

/-- THEOREM: Despite marriage's anomalous matter, it still satisfies the
    hylomorphic schema — it has both matter (the persons) and form (consent).
    The anomaly is in the KIND of matter, not in having matter at all.

    Depends on: every_sacrament_has_matter, every_sacrament_has_form. -/
theorem marriage_still_hylomorphic :
    hasMatter .marriage ∧ hasForm .marriage :=
  ⟨every_sacrament_has_matter .marriage, every_sacrament_has_form .marriage⟩

-- ============================================================================
-- § 6. Connection to SacramentalCausation — Signs that Cause
-- ============================================================================

/-!
### The bridge: determinate signs that cause real change

SacramentalCausation.lean establishes that every sacrament causes at least
one type of change (relational, ontological, juridical, dispositional).
This file establishes that every sacrament is a determinate sign (matter +
form).

Together: every sacrament is a DETERMINATE SIGN that CAUSES REAL CHANGE.
This is the full content of CCC §1131: "efficacious signs of grace."
- "Signs" = determinate (this file: matter + form)
- "Efficacious" = causing real change (SacramentalCausation)
- "of grace" = the change is grace-conferring (T3, Axioms.lean)
-/

/-- THEOREM: Every sacrament is both a determinate sign AND a cause of
    real change. This composes the two halves of "efficacious sign":
    - determinate sign (from matter + form)
    - causes real change (from SacramentalCausation)

    This is the formal content of §1131: "efficacious signs of grace,
    instituted by Christ and entrusted to the Church."

    Depends on: every_sacrament_is_determinate (this file),
    every_sacrament_causes_change (SacramentalCausation.lean). -/
theorem efficacious_sign :
    ∀ (s : SacramentKind),
      isDeterminateSign s ∧ ∃ (ct : ChangeType), causesChangeOfType s ct :=
  fun s => ⟨every_sacrament_is_determinate s, every_sacrament_causes_change s⟩

/-- THEOREM: Matter alone is never a determinate sacramental sign AND
    every sacrament is in fact determinate. This shows that the form
    (verbal component) is doing essential work — it is not optional or
    decorative but constitutive of the sacrament's signification.

    Depends on: matter_alone_indeterminate, every_sacrament_is_determinate,
    every_sacrament_has_matter. -/
theorem form_is_essential :
    ∀ (s : SacramentKind),
      -- The sacrament IS determinate...
      isDeterminateSign s
      -- ...but would NOT be without its form
      ∧ (¬hasForm s → ¬isDeterminateSign s) :=
  fun s =>
    ⟨ every_sacrament_is_determinate s,
      fun h_no_form => matter_alone_indeterminate s (every_sacrament_has_matter s) h_no_form ⟩

-- ============================================================================
-- § 7. The Hylomorphic Analogy — Signs Parallel Persons
-- ============================================================================

/-!
### The deeper pattern: hylomorphism at two levels

The CCC uses hylomorphism at TWO levels:

**Level 1 — Persons (§365):** The human person is a composite of body
(matter) and soul (form). Neither alone is a person. The soul actualizes
matter into a living human body. (Soul.lean, HylomorphicFormation.lean)

**Level 2 — Signs (ST III q.60 a.6):** A sacramental sign is a composite
of physical element (matter) and words (form). Neither alone is a
sacrament. The words actualize the physical element into a sacramental sign.

This is NOT an accidental parallel. Aquinas explicitly draws the analogy:
the matter/form structure of signs mirrors the matter/form structure of
natural substances. The CCC inherits this framework.

The hidden assumption: the hylomorphic analysis of substances (Level 1)
generalizes to the hylomorphic analysis of signs (Level 2). This is a
philosophical extension that the CCC assumes but does not argue for.
One could accept hylomorphism for persons (§365) and reject it for signs
(preferring a different semiotics). The CCC does not consider this option.
-/

/-- Whether the hylomorphic analogy holds: sacramental signs have the
    SAME matter/form structure as natural substances.

    This is the Thomistic claim that unifies Levels 1 and 2. It is
    PHILOSOPHICAL INFRASTRUCTURE — the CCC assumes it without stating it.

    MODELING CHOICE: We model this as a simple Prop rather than
    attempting to formalize what "same structure" means. The important
    point is to FLAG the analogy as a hidden assumption, not to prove
    it mechanically. -/
opaque hylomorphicAnalogyHolds : Prop

/-- THEOREM: IF the hylomorphic analogy holds (the Thomistic claim that
    sign-structure mirrors substance-structure), THEN every sacrament
    has both matter and form.

    This is already guaranteed by `every_sacrament_has_matter` and
    `every_sacrament_has_form`. The purpose of this theorem is to
    make the PHILOSOPHICAL JUSTIFICATION explicit: the hylomorphic
    analogy is WHY every sacrament has both components.

    The CCC inherits this Thomistic semiotics without arguing for it.
    A different theory of signs would yield a different account of why
    sacraments have the components they do.

    Provenance: [Tradition] Aquinas ST III q.60 a.6.

    Depends on: every_sacrament_has_matter, every_sacrament_has_form. -/
theorem hylomorphic_analogy :
    hylomorphicAnalogyHolds →
      ∀ (s : SacramentKind), hasMatter s ∧ hasForm s :=
  fun _ s => ⟨every_sacrament_has_matter s, every_sacrament_has_form s⟩

-- ============================================================================
-- § 8. Summary
-- ============================================================================

/-!
## Summary: What the formalization reveals

**The answer to "why both matter and form?"**: Because sacraments are
SIGNS, and signs (under the Thomistic analysis) have hylomorphic structure.
Matter provides the raw sensible element; form determines what it signifies.
Neither alone suffices — matter without form is indeterminate, and form
without matter has nothing to determine. This is Aquinas's application of
Aristotelian hylomorphism from substances to signs.

**Key structural findings:**

1. **Every sacrament is a composite sign** (`every_sacrament_is_composite`) —
   all seven have both matter and form. This is universal, not just a pattern
   in the better-known sacraments (baptism, Eucharist).

2. **Matter without form is indeterminate** (`matter_alone_indeterminate`) —
   the physical element alone cannot function as a sacramental sign. The words
   are essential, not decorative.

3. **Validity requires both** (`matter_without_form_invalid`,
   `form_without_matter_invalid`) — either component missing = invalid
   sacrament. This has direct practical consequences for liturgical practice.

4. **Marriage is structurally anomalous** (`marriage_uniquely_non_external`) —
   it satisfies the hylomorphic schema but with the persons as matter, not
   an external element. It is the ONLY sacrament with this structure.

5. **The bridge to SacramentalCausation** (`efficacious_sign`) — every
   sacrament is both a determinate sign (this file) and a cause of real
   change (SacramentalCausation.lean). Together these give formal content
   to §1131: "efficacious signs of grace."

6. **The hidden philosophical infrastructure** — the hylomorphic analysis of
   signs is ASSUMED by the CCC, inherited from Aquinas, not argued for. This
   is the deepest hidden assumption: a specific theory of signs (Thomistic
   semiotics) underlies the entire matter/form framework.

**Axiom count:** 7 axioms, 10 theorems.

**Cross-file connections:**
- `SacramentalCausation.lean`: SacramentKind, ChangeType, causesChangeOfType,
  every_sacrament_causes_change
- `Baptism.lean`: uses the same SacramentKind.baptism
- `Eucharist.lean`: the EucharisticSpecies/substance model is the Eucharist's
  specific matter + transubstantiation at consecration
- `HylomorphicFormation.lean` / `Soul.lean`: the person-level hylomorphism
  (Level 1) that the sign-level hylomorphism (Level 2) parallels

**What is NOT formalized here:**
- The specific CONTENT of each sacrament's matter and form (what the words
  are, what the physical element is). We track the STRUCTURE, not the content.
- The full validity conditions (minister, intention — §1127-1128). We model
  only the matter/form component.
- The theological question of WHO instituted each sacrament's matter and form
  (Christ directly, or apostolic/ecclesial determination? — a live debate).
-/

end Catlib.Sacraments.MatterAndForm
