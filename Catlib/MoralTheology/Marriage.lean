import Catlib.Foundations

/-!
# CCC §1601–1658, §2382–2386: Marriage — Indissolubility and its Grounds

## The puzzle

What makes marriage permanent? The CCC gives FOUR distinct grounds for
indissolubility, and the question is which is load-bearing:

1. **Covenantal** (§1601): Marriage is a covenant (not a contract).
   Covenants bind persons totally; contracts bind for services.
2. **Sacramental** (§1612–1617): For the baptized, marriage is a sacrament —
   a sign of Christ's union with the Church (Eph 5:25–32). Since Christ's
   union with the Church is permanent, the sign must be permanent too.
3. **Consummation** (§1640): A "concluded and consummated" marriage between
   baptized persons "can never be dissolved." The bodily union seals the
   covenant.
4. **Natural law** (§1644): The love itself requires indissolubility
   "of its very nature" — even apart from sacramentality.

## Prediction

I expect the sacramental ground (Christ-Church analogy) to be what makes
Catholic indissolubility ABSOLUTE (no exceptions), while the natural-law
ground alone produces a strong-but-defeasible bond. The covenantal ground
gives the form; the sacramental ground gives the absoluteness; consummation
seals it. Dropping the sacramental ground (Protestant) should yield a
dissoluble marriage. Dropping only consummation (pre-consummation) should
yield an annullable marriage (which matches Canon Law: ratum sed non
consummatum can be dissolved by the Pope).

## Findings

- **The sacramental ground IS the load-bearing axiom for ABSOLUTE
  indissolubility.** Natural law gives a strong-but-defeasible bond;
  the covenantal form gives total personal commitment; but only the
  Christ-Church analogy makes indissolubility exceptionless. The
  reasoning: Christ's union with the Church CANNOT fail (divine
  fidelity is indefectible), so the sacramental sign of that union
  cannot fail either.

- **Consummation is a necessary condition alongside sacramentality.**
  Canon Law actually permits dissolution of a ratum sed non consummatum
  marriage (a valid sacramental marriage that was never consummated).
  This means sacramentality alone is not sufficient — consummation
  completes the sign. The body seals what the covenant initiates.

- **The three-tier structure is clean:**
  - Natural law alone → strong but defeasible (Orthodox economia,
    Protestant divorce for cause)
  - Natural law + sacrament → very strong but incomplete (ratum non
    consummatum — dissoluble by papal authority)
  - Natural law + sacrament + consummation → absolute (no power on
    earth can dissolve)

- **The denominational cuts are precise:**
  - PROTESTANT: reject sacramentality of marriage → only natural-law
    bond → dissoluble (at least for adultery, per Mt 19:9)
  - ORTHODOX: accept sacramentality but apply economia (pastoral mercy
    can override the bond) → dissoluble under specific conditions
  - CATHOLIC: sacrament + consummation → absolutely indissoluble
    (no exceptions, no economia)

- **Hidden assumption: divine fidelity is indefectible.** The entire
  sacramental argument rests on the premise that Christ's union with
  the Church cannot fail. This is asserted (Eph 5:25–32) but the
  formalization makes it load-bearing: if divine fidelity were
  defectible, the sacramental ground would collapse.

## Modeling choices

1. We model the bond strength as an opaque function `bondStrength` from
   `MarriageBond` to `BondStrength`, with axioms constraining its behavior.
   This ensures the Lean kernel actually tracks which axioms each theorem
   depends on (avoiding the `X = X` tautology problem).
2. We use opaque predicates for key concepts (sacramental, economia)
   because the CCC treats these as primitive categories.
3. We model the Orthodox position as accepting sacramentality but adding
   an economia override, which is how Orthodox theology actually works.
4. We model the Protestant position as rejecting the sacramental ground
   entirely, which captures the Reformation's core move on marriage.
-/

set_option autoImplicit false

namespace Catlib.MoralTheology.Marriage

open Catlib

-- ============================================================================
-- § 1. Core types and predicates
-- ============================================================================

/-- A marriage bond between two persons.

    §1601: "The matrimonial covenant, by which a man and a woman establish
    between themselves a partnership of the whole of life, is by its very
    nature ordered toward the good of the spouses and the procreation and
    education of offspring."

    STRUCTURAL OPACITY: Marriage is a primitive relation in Catholic theology.
    It is not reducible to contract, affection, or cohabitation. The CCC
    treats it as a distinct metaphysical category. -/
structure MarriageBond where
  /-- The first spouse -/
  spouse1 : Person
  /-- The second spouse -/
  spouse2 : Person
  /-- Whether the marriage is covenantal (total personal commitment,
      not merely a contract for services). §1601. -/
  isCovenantal : Prop
  /-- Whether both spouses are baptized (prerequisite for sacramentality).
      §1617: "Between the baptized, a valid marriage contract cannot exist
      that is not by that very fact a sacrament." -/
  bothBaptized : Prop
  /-- Whether the marriage has been consummated — bodily union that seals
      the covenant. §1640.

      HONEST OPACITY: The CCC does not define consummation beyond
      "conjugal act" (Canon 1061 §1). We track the distinction without
      specifying further. -/
  isConsummated : Prop

/-- The strength of a marital bond — how resistant it is to dissolution.

    MODELING CHOICE: The CCC recognizes three effective levels:
    - Natural bonds can be dissolved (Pauline privilege, Canon 1143)
    - Sacramental-but-unconsummated bonds can be dissolved by the Pope
      (Canon 1142)
    - Sacramental-and-consummated bonds cannot be dissolved by any power

    We model this as a three-valued type rather than a binary, because
    the intermediate case (ratum non consummatum) is real Canon Law. -/
inductive BondStrength where
  /-- Strong but defeasible — can be dissolved under certain conditions.
      This is the natural-law bond: marriage is permanent by nature,
      but not absolutely so. -/
  | defeasible
  /-- Very strong — dissoluble only by supreme ecclesial authority.
      This is ratum sed non consummatum: sacramental but not yet
      sealed by bodily union. Canon 1142. -/
  | quasiAbsolute
  /-- Absolutely indissoluble — no power on earth can dissolve it.
      This is ratum et consummatum between baptized persons. §1640. -/
  | absolute
  deriving DecidableEq, Inhabited

-- ============================================================================
-- § 2. Key predicates
-- ============================================================================

/-- Whether a marriage is sacramental — a sign of Christ's union with the
    Church.

    §1617: "Between the baptized, a valid marriage contract cannot exist
    that is not by that very fact a sacrament."

    This means that for the baptized, sacramentality is AUTOMATIC — it
    is not an optional add-on. The couple does not "choose" to make their
    marriage a sacrament; if both are baptized, it IS one.

    HIDDEN ASSUMPTION (in the CCC): sacramentality requires BOTH parties
    to be baptized. A marriage between a baptized and an unbaptized person
    is valid but not sacramental (Canon 1086). -/
opaque isSacramental : MarriageBond → Prop

/-- Whether Christ's union with the Church is permanent (indefectible).

    §796: "The unity of Christ and the Church, head and members of one
    Body, also implies the distinction of the two in a personal relationship."

    Eph 5:25–32: "Christ loved the Church and gave himself up for her."

    HIDDEN ASSUMPTION: This is the deepest premise in the argument.
    The entire sacramental ground for indissolubility rests on divine
    fidelity being indefectible. If Christ could abandon the Church,
    the sign could fail, and sacramental indissolubility would collapse. -/
opaque christChurchUnionPermanent : Prop

/-- Whether a sacramental sign must mirror the permanence of what it
    signifies.

    §1617: Marriage is "the efficacious sign of the covenant between Christ
    and the Church."

    HIDDEN ASSUMPTION: Signs of permanent realities must themselves be
    permanent. This is not argued for in the CCC — it is assumed by the
    sacramental worldview. A nominalist could deny it: the sign is just
    a label, not ontologically linked to the signified.

    This is where T3 (sacramental efficacy) does its work: if sacraments
    are merely symbols (Protestant view), the sign need not mirror the
    permanence of what it points to. If sacraments are efficacious signs
    (T3), then the sign participates in the reality, and a sign of a
    permanent union must be permanent. -/
opaque signMirrorsPermanence : Prop

/-- Whether a pastoral override (economia) can dissolve a specific bond.

    MODELING CHOICE: The Orthodox tradition accepts that marriage is
    sacramental and in principle permanent, but permits dissolution
    under economia — a pastoral principle of mercy that can override
    strict law for the salvation of souls.

    The Catholic tradition denies that economia can override absolute
    indissolubility. The disagreement is not about whether mercy matters
    but about whether mercy can dissolve a bond established by God. -/
opaque economiaOverrides : MarriageBond → Prop

/-- The strength of a specific marriage bond. This is the key function
    that the axioms constrain.

    MODELING CHOICE: We make this opaque so that theorems must invoke
    axioms to determine the bond strength — the Lean kernel cannot
    reduce it by computation. This ensures genuine axiom dependencies. -/
opaque bondStrength : MarriageBond → BondStrength

/-- Whether a bond is dissoluble — can be dissolved by some authority.

    A bond is dissoluble if and only if it is not absolute. Defeasible
    bonds can be dissolved by various authorities; quasi-absolute bonds
    only by the Pope; absolute bonds by no one.

    STRUCTURAL OPACITY: We keep this opaque because dissolvability is
    a complex canonical concept that varies by bond type. The axioms
    constrain it. -/
opaque isDissolvable : MarriageBond → Prop

-- ============================================================================
-- § 3. Axioms
-- ============================================================================

/-!
### Axiom 1: Covenant grounds personal permanence (§1601–1602)

A covenantal marriage is ordered to permanence by its very nature.
Covenants are total personal commitments, unlike contracts (which
bind for specific services and can be terminated by agreement).

This is the NATURAL LAW ground: even apart from sacramentality,
marriage's covenantal nature makes it inherently permanent — but
only defeasibly so.
-/

/-- AXIOM (§1601–1602): A covenantal marriage establishes a defeasible bond.

    §1638: "From a valid marriage arises a bond between the spouses which
    by its very nature is perpetual and exclusive."

    §1644: "The love of the spouses requires, of its very nature, the
    unity and indissolubility of the spouses' community of persons."

    This is the WEAKEST ground for indissolubility — it produces a
    defeasible bond. The natural law says marriage SHOULD be permanent,
    but natural-law obligations can be overridden in extreme cases
    (Pauline privilege, Canon 1143).

    Provenance: [Scripture] Gen 2:24 ("the two become one flesh");
    Mt 19:6 ("what God has joined together, let no one separate").
    Denominational scope: ECUMENICAL — all major traditions accept that
    marriage is naturally ordered to permanence.
    Teaching kind: DOCTRINE. -/
axiom covenant_grounds_permanence :
  ∀ (m : MarriageBond), m.isCovenantal → ¬isSacramental m →
    bondStrength m = BondStrength.defeasible

/-!
### Axiom 2: Baptism makes marriage sacramental (§1617)

For the baptized, marriage is automatically a sacrament — the covenant
IS the sacramental sign. This is not optional: "between the baptized,
a valid marriage contract cannot exist that is not by that very fact
a sacrament" (Canon 1055 §2).
-/

/-- AXIOM (§1617, Canon 1055 §2): If both spouses are baptized, the
    marriage is sacramental — automatically and necessarily.

    Provenance: [Tradition] Council of Trent, Session 24; Canon 1055 §2.
    Denominational scope: CATHOLIC. Protestants deny marriage is a sacrament
    (Luther removed it from the sacramental list in 1520).
    Teaching kind: DOCTRINE. -/
axiom baptism_makes_sacramental :
  ∀ (m : MarriageBond), m.bothBaptized → isSacramental m

/-!
### Axiom 3: Divine fidelity is indefectible (Eph 5:25–32)

Christ's union with the Church is permanent — he will never abandon
his bride. This is the premise that, combined with the sacramental
sign principle, produces absolute indissolubility.
-/

/-- AXIOM (Eph 5:25–32, §796): Christ's union with the Church is permanent.

    "Christ loved the Church and gave himself up for her" (Eph 5:25).
    "I am with you always, to the end of the age" (Mt 28:20).

    HIDDEN ASSUMPTION: This is the deepest load-bearing premise. If divine
    fidelity were defectible, the sacramental argument would collapse:
    the sign could break because the signified could break.

    Provenance: [Scripture] Eph 5:25–32; Mt 28:20.
    Denominational scope: ECUMENICAL — all Christians affirm Christ's
    faithfulness to the Church. The dispute is whether this premise
    entails marital indissolubility.
    Teaching kind: DOCTRINE. -/
axiom divine_fidelity_indefectible : christChurchUnionPermanent

/-!
### Axiom 4: Sacramental signs mirror the permanence of what they signify

If a sacrament is an efficacious sign (T3), then it participates in
the reality it signifies. A sign of a permanent union must itself be
permanent.
-/

/-- AXIOM (§1617, implicit from T3): The sacramental sign of Christ's
    permanent union must itself be permanent.

    This is where T3 (sacramental efficacy) enters the marriage argument.
    Under T3, sacraments are not merely labels — they participate in what
    they signify. Therefore a sacramental sign of an indefectible union
    must itself be indefectible.

    Under the Protestant view (sacraments are symbols only), this axiom
    fails: a symbol of permanence need not itself be permanent.

    Provenance: [Tradition] Implicit in T3 (Council of Trent, Session 7);
    explicit in §1617.
    Denominational scope: CATHOLIC. Depends on T3.
    Teaching kind: DOCTRINE.

    CONNECTION TO BASE AXIOM: This is T3 applied to marriage — the same
    base axiom that drives infant baptism (Baptism.lean), Eucharistic
    real presence (Eucharist.lean), and the body-as-sign principle
    (TheologyOfBody.lean). -/
axiom sign_mirrors_permanence :
  christChurchUnionPermanent → signMirrorsPermanence

/-!
### Axiom 5: Sacramental-but-unconsummated marriage is quasi-absolute

When marriage is sacramental but not yet consummated, the bond is
elevated beyond the natural-law level but not yet absolute. The Pope
can dissolve a ratum sed non consummatum (Canon 1142).
-/

/-- AXIOM (§1640, Canon 1142): A sacramental marriage that has NOT been
    consummated is quasi-absolute — dissoluble only by supreme ecclesial
    authority (the Pope).

    This is the intermediate case — stronger than a natural bond (which
    can be dissolved by the Pauline privilege) but not yet absolute.

    This axiom captures the CCC's own position: sacramentality alone
    is NECESSARY but NOT SUFFICIENT for absolute indissolubility.
    Consummation is also required.

    Provenance: [Tradition] Canon 1142; long-standing papal practice.
    Denominational scope: CATHOLIC.
    Teaching kind: DISCIPLINE (the canonical procedure) backed by
    DOCTRINE (the theological principle). -/
axiom sacramental_unconsummated_quasi :
  ∀ (m : MarriageBond),
    isSacramental m → ¬m.isConsummated →
    bondStrength m = BondStrength.quasiAbsolute

/-!
### Axiom 6: Consummation seals the sacramental bond absolutely

A sacramental marriage that HAS been consummated — ratum et consummatum
— is absolutely indissoluble. No power on earth can dissolve it.
-/

/-- AXIOM (§1640): A concluded and consummated marriage between baptized
    persons can never be dissolved.

    §1640: "Thus the marriage bond has been established by God himself in
    such a way that a marriage concluded and consummated between baptized
    persons can never be dissolved."

    The bodily union SEALS the covenant — the body makes visible the
    invisible commitment (connecting to TheologyOfBody.lean: the body
    as sign). Consummation completes the sacramental sign: the total
    gift of persons, spiritual AND bodily.

    Provenance: [Tradition] Canon 1141: "A marriage that is ratum et
    consummatum can be dissolved by no human power and by no cause,
    except death." [Scripture] Gen 2:24; Mt 19:6.
    Denominational scope: CATHOLIC.
    Teaching kind: DOCTRINE. -/
axiom consummation_seals_bond :
  ∀ (m : MarriageBond),
    isSacramental m → m.isConsummated → signMirrorsPermanence →
    bondStrength m = BondStrength.absolute

/-!
### Axiom 7: Absolute bonds are not dissoluble

An absolute bond cannot be dissolved by any authority — human or
ecclesial. This connects `bondStrength` to `isDissolvable`.
-/

/-- AXIOM (Canon 1141): A bond of absolute strength cannot be dissolved.

    Canon 1141: "A marriage that is ratum et consummatum can be dissolved
    by no human power and by no cause, except death."

    Provenance: [Tradition] Canon 1141; constant Catholic teaching.
    Denominational scope: CATHOLIC.
    Teaching kind: DOCTRINE. -/
axiom absolute_bond_not_dissolvable :
  ∀ (m : MarriageBond),
    bondStrength m = BondStrength.absolute → ¬isDissolvable m

/-!
### Axiom 8: Catholic rejection of economia for absolute bonds

The Catholic tradition holds that no pastoral authority — not even
the Pope — can dissolve a ratum et consummatum marriage.
-/

/-- AXIOM (§1640, Canon 1141): Economia (pastoral mercy) cannot override
    an absolutely indissoluble bond.

    The Orthodox tradition permits dissolution under economia even for
    sacramental-and-consummated marriages. The Catholic tradition denies
    this absolutely: "no human power and no cause, except death."

    Provenance: [Tradition] Canon 1141; constant Catholic teaching.
    Denominational scope: CATHOLIC (Orthodox disagree).
    Teaching kind: DOCTRINE. -/
axiom no_economia_for_absolute :
  ∀ (m : MarriageBond),
    isSacramental m → m.isConsummated → ¬economiaOverrides m

-- ============================================================================
-- § 4. The Protestant position — marriage is not a sacrament
-- ============================================================================

/-!
### The Reformation axiom swap

Luther removed marriage from the list of sacraments in 1520
(*De Captivitate Babylonica*). His argument: sacraments require
a divine promise of grace attached to a visible sign (his reading
of Augustine). Marriage has no such promise in Scripture. Therefore
it is a "worldly thing" (*weltlich Ding*), subject to civil law.

The consequence: if marriage is not a sacrament, the sacramental
ground for indissolubility vanishes. Only the natural-law ground
remains — which is defeasible.
-/

/-- The Protestant rejection of marriage as sacrament.

    Luther, *De Captivitate Babylonica* (1520): marriage is a worldly
    institution, not a sacrament. Therefore it is subject to civil
    dissolution.

    STRUCTURAL OPACITY: This is a denominational marker — whether
    a tradition rejects sacramentality of marriage. -/
opaque protestantRejectsSacramentality : MarriageBond → Prop

/-- AXIOM (Protestant): Marriage between Christians is NOT sacramental.
    This is the negation of `baptism_makes_sacramental`.

    Under this view, baptism does not elevate marriage to a sacramental
    sign. Marriage remains a good and holy estate, but it is a natural
    institution, not a means of grace.

    Denominational scope: PROTESTANT. -/
axiom protestant_no_sacrament :
  ∀ (m : MarriageBond),
    protestantRejectsSacramentality m → ¬isSacramental m

/-- AXIOM (Protestant): A defeasible bond is dissoluble — divorce is
    possible under certain conditions.

    When the bond is only natural-law-based (defeasible), dissolution
    is possible. Jesus's exception clause (Mt 19:9, porneia) is then
    operative. Most Protestant traditions permit divorce for adultery,
    abandonment, or abuse.

    Denominational scope: PROTESTANT. -/
axiom defeasible_bond_dissolvable :
  ∀ (m : MarriageBond),
    bondStrength m = BondStrength.defeasible → isDissolvable m

-- ============================================================================
-- § 5. The Orthodox position — economia
-- ============================================================================

/-!
### The Orthodox divergence

The Orthodox tradition accepts that marriage is sacramental and in
principle permanent. But it permits divorce and remarriage under
economia — pastoral mercy for the salvation of souls.

The Orthodox do not deny indissolubility as an IDEAL. They deny
that it is EXCEPTIONLESS.
-/

/-- AXIOM (Orthodox): Economia can override the marital bond, even for
    sacramental marriages, when pastoral necessity requires it.

    The Orthodox Church grants divorces (typically for adultery,
    abandonment, or severe abuse) and permits remarriage — up to three
    marriages total. The second and third marriages use a penitential
    rite, acknowledging the ideal of permanence.

    Denominational scope: ORTHODOX. -/
axiom orthodox_economia_applies :
  ∀ (m : MarriageBond),
    isSacramental m → economiaOverrides m

-- ============================================================================
-- § 6. Theorems — what follows from each axiom set
-- ============================================================================

/-!
### The Catholic result: absolute indissolubility

Under Catholic axioms (sacramentality + consummation + sign mirrors
permanence), a marriage between baptized persons that has been
consummated is absolutely indissoluble.
-/

/-- THEOREM: A baptized marriage is sacramental.

    This is the first step: if both spouses are baptized, the marriage
    is automatically sacramental (Axiom 2).

    Denominational scope: CATHOLIC. -/
theorem baptized_marriage_is_sacramental
    (m : MarriageBond)
    (h_baptized : m.bothBaptized) :
    isSacramental m :=
  baptism_makes_sacramental m h_baptized

/-- THEOREM: The sign of Christ's union must be permanent.

    The chain: Christ's union with the Church is permanent
    (divine_fidelity_indefectible) → the sacramental sign must mirror
    that permanence (sign_mirrors_permanence).

    Denominational scope: CATHOLIC (depends on T3). -/
theorem sacramental_sign_is_permanent : signMirrorsPermanence :=
  sign_mirrors_permanence divine_fidelity_indefectible

/-- THEOREM (§1640 — the key Catholic result): A concluded and consummated
    marriage between baptized persons has an absolute bond.

    The full derivation chain:
    1. Both spouses are baptized → marriage is sacramental (Axiom 2)
    2. Christ's union with the Church is permanent (Axiom 3)
    3. The sacramental sign mirrors that permanence (Axiom 4)
    4. The marriage is consummated (given)
    5. Consummation seals the sacramental bond absolutely (Axiom 6)
    6. Therefore: bondStrength m = BondStrength.absolute

    Uses axioms: baptism_makes_sacramental, divine_fidelity_indefectible,
    sign_mirrors_permanence, consummation_seals_bond.

    Denominational scope: CATHOLIC. -/
theorem catholic_absolute_indissolubility
    (m : MarriageBond)
    (h_baptized : m.bothBaptized)
    (h_consummated : m.isConsummated) :
    bondStrength m = BondStrength.absolute :=
  consummation_seals_bond m
    (baptism_makes_sacramental m h_baptized)
    h_consummated
    sacramental_sign_is_permanent

/-- THEOREM (§1640): A consummated sacramental marriage cannot be dissolved.

    Combines `catholic_absolute_indissolubility` with
    `absolute_bond_not_dissolvable`. The full chain from baptism
    through consummation to indissolubility.

    Denominational scope: CATHOLIC. -/
theorem catholic_marriage_not_dissolvable
    (m : MarriageBond)
    (h_baptized : m.bothBaptized)
    (h_consummated : m.isConsummated) :
    ¬isDissolvable m :=
  absolute_bond_not_dissolvable m
    (catholic_absolute_indissolubility m h_baptized h_consummated)

/-- THEOREM: Economia cannot dissolve a consummated sacramental marriage
    (Catholic position).

    Under Catholic axioms, no pastoral override can dissolve a ratum et
    consummatum bond. This is the specific point where Catholic and
    Orthodox teaching diverge.

    Denominational scope: CATHOLIC. -/
theorem no_pastoral_dissolution
    (m : MarriageBond)
    (h_baptized : m.bothBaptized)
    (h_consummated : m.isConsummated) :
    ¬economiaOverrides m :=
  no_economia_for_absolute m
    (baptism_makes_sacramental m h_baptized)
    h_consummated

/-!
### The sacramental-but-unconsummated case

A sacramental marriage that has NOT been consummated is quasi-absolute:
dissoluble only by the Pope. This intermediate case proves that
consummation is genuinely load-bearing — sacramentality alone is
not sufficient for absolute indissolubility.
-/

/-- THEOREM: A sacramental-but-unconsummated marriage is quasi-absolute.

    Canon 1142 permits the Pope to dissolve a ratum sed non consummatum
    for a just cause. This shows consummation is necessary for
    absoluteness.

    Denominational scope: CATHOLIC. -/
theorem unconsummated_sacramental_is_quasi
    (m : MarriageBond)
    (h_baptized : m.bothBaptized)
    (h_not_consummated : ¬m.isConsummated) :
    bondStrength m = BondStrength.quasiAbsolute :=
  sacramental_unconsummated_quasi m
    (baptism_makes_sacramental m h_baptized)
    h_not_consummated

/-!
### The Protestant result: dissoluble marriage

Under Protestant axioms (marriage is not a sacrament), only the
natural-law bond remains — and that bond is defeasible and therefore
dissoluble.
-/

/-- THEOREM: Under Protestant axioms, marriage is not sacramental, so
    the sacramental ground for indissolubility is unavailable.

    Denominational scope: PROTESTANT. -/
theorem protestant_marriage_not_sacramental
    (m : MarriageBond)
    (h_reject : protestantRejectsSacramentality m) :
    ¬isSacramental m :=
  protestant_no_sacrament m h_reject

/-- THEOREM: Under Protestant axioms, a covenantal marriage has only
    a defeasible (dissoluble) bond.

    The Protestant removes the sacramental premise. What remains is
    only the natural-law bond (covenant_grounds_permanence), which
    produces a defeasible bond. Jesus's exception clause (Mt 19:9,
    porneia) is then operative.

    Denominational scope: PROTESTANT. -/
theorem protestant_bond_is_defeasible
    (m : MarriageBond)
    (h_covenantal : m.isCovenantal)
    (h_reject : protestantRejectsSacramentality m) :
    bondStrength m = BondStrength.defeasible :=
  covenant_grounds_permanence m h_covenantal
    (protestant_no_sacrament m h_reject)

/-- THEOREM: Under Protestant axioms, marriage is dissoluble.

    Combines the defeasible bond with the principle that defeasible
    bonds are dissoluble. This is the formal version of the Protestant
    permission for divorce.

    Denominational scope: PROTESTANT. -/
theorem protestant_marriage_dissoluble
    (m : MarriageBond)
    (h_covenantal : m.isCovenantal)
    (h_reject : protestantRejectsSacramentality m) :
    isDissolvable m :=
  defeasible_bond_dissolvable m
    (protestant_bond_is_defeasible m h_covenantal h_reject)

/-!
### The Orthodox result: dissoluble under economia

Under Orthodox axioms, marriage IS sacramental, but economia can
override the bond.
-/

/-- THEOREM: Under Orthodox axioms, even a sacramental marriage can be
    dissolved by economia.

    The Orthodox affirm both sacramentality AND economia. This produces
    a position between Catholic (no exceptions) and Protestant (not
    sacramental): marriage is sacramental AND dissoluble under extreme
    circumstances.

    Denominational scope: ORTHODOX. -/
theorem orthodox_permits_dissolution
    (m : MarriageBond)
    (h_baptized : m.bothBaptized) :
    economiaOverrides m :=
  orthodox_economia_applies m
    (baptism_makes_sacramental m h_baptized)

/-!
### The denominational diagnosis

The key theorem: the sacramental ground (Christ-Church analogy) is
what distinguishes Catholic absolute indissolubility from the
defeasible permanence that all traditions share.

The denominational split is a three-way axiom difference:
- Protestant: reject Axiom 2 (baptism_makes_sacramental)
- Orthodox: accept Axiom 2, reject Axiom 8 (no_economia_for_absolute)
- Catholic: accept all axioms
-/

/-- THEOREM: Catholic and Orthodox DISAGREE on whether economia applies.

    Given a consummated sacramental marriage:
    - Catholic: ¬economiaOverrides m (Axiom 8)
    - Orthodox: economiaOverrides m (orthodox_economia_applies)

    This is a genuine contradiction — the two traditions cannot both
    be right about the same marriage.

    Denominational scope: ANALYSIS. -/
theorem economia_is_the_catholic_orthodox_split
    (m : MarriageBond)
    (h_baptized : m.bothBaptized)
    (h_consummated : m.isConsummated) :
    ¬economiaOverrides m :=
  no_economia_for_absolute m
    (baptism_makes_sacramental m h_baptized)
    h_consummated

-- ============================================================================
-- § 7. Denominational tags
-- ============================================================================

/-- Denominational tag for absolute indissolubility. -/
def absoluteIndissolubilityTag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Orthodox accept sacramentality but permit economia. Protestants reject sacramentality of marriage." }

/-- Denominational tag for the sacramentality of marriage. -/
def marriageSacramentTag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Also Orthodox. Protestants reject (Luther, De Captivitate Babylonica, 1520)." }

/-- Denominational tag for the natural-law permanence of marriage. -/
def naturalPermanenceTag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical]
    note := "All major traditions affirm marriage is naturally ordered to permanence (Gen 2:24, Mt 19:6)." }

/-!
## Summary

The Catholic argument for absolute indissolubility:

| Step | Claim | Source | Axiom |
|------|-------|--------|-------|
| 1 | Marriage is a covenant | §1601–1602 | `covenant_grounds_permanence` |
| 2 | Baptism makes marriage sacramental | §1617, Canon 1055 | `baptism_makes_sacramental` |
| 3 | Christ's union with the Church is permanent | Eph 5:25–32 | `divine_fidelity_indefectible` |
| 4 | Sacramental signs mirror what they signify | §1617, T3 | `sign_mirrors_permanence` |
| 5 | Sacrament alone is quasi-absolute | Canon 1142 | `sacramental_unconsummated_quasi` |
| 6 | Consummation seals the bond absolutely | §1640, Canon 1141 | `consummation_seals_bond` |
| 7 | Absolute bonds are not dissoluble | Canon 1141 | `absolute_bond_not_dissolvable` |
| 8 | No economia for absolute bonds | Canon 1141 | `no_economia_for_absolute` |

The denominational split:

| Tradition | Accepts sacramentality? | Accepts economia? | Result |
|-----------|------------------------|-------------------|--------|
| CATHOLIC | Yes (Axiom 2) | No (Axiom 8) | Absolute indissolubility |
| ORTHODOX | Yes (Axiom 2) | Yes (overrides Axiom 8) | Dissoluble under mercy |
| PROTESTANT | No (rejects Axiom 2) | N/A | Dissoluble (natural bond only) |

**Key finding**: The sacramental ground (Axioms 2–4) is what makes Catholic
indissolubility ABSOLUTE rather than merely strong. The natural-law ground
(Axiom 1) is ecumenical but defeasible. The Catholic-Orthodox split is
specifically about economia (Axiom 8). The Catholic-Protestant split is
specifically about sacramentality (Axiom 2). Consummation (Axiom 6) is
necessary for absoluteness — without it, even the Catholic Church permits
dissolution (Canon 1142).
-/

end Catlib.MoralTheology.Marriage
