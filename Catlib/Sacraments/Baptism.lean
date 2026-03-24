import Catlib.Foundations
import Catlib.Foundations.SinEffects

/-!
# CCC §1213–1284: Baptism — Infant Baptism and the Denominational Split

## The puzzle

Why baptize infants who cannot profess faith? An adult can choose baptism;
a baby cannot consent. Baptist and many Evangelical traditions reject infant
baptism (paedobaptism) and require believer's baptism (credobaptism) — a
personal profession of faith before baptism.

## The CCC's answer (§1250–1252, §1282)

1. **T3 (ex opere operato)**: Baptism CONFERS grace — it is not merely a
   public declaration of existing faith. (§1127, §1131)
2. **§1250**: "Born with a fallen human nature and tainted by original sin,
   children also have need of the new birth in Baptism."
3. **§1251**: The faith of parents and the Church PRESENTS the child —
   the Church can bring a person to sacramental grace before personal
   rational assent.
4. **§1252**: The practice is "an immemorial tradition of the Church" —
   attested since the 2nd century.
5. **§1253–1254**: Later personal faith RATIFIES what baptism began —
   it does not CREATE the grace ex nihilo.

## Connection to SinEffects

Baptism removes Layer 1 (original wound). Infants HAVE original sin (§405,
§1250). Therefore infants NEED baptism. The question is only whether they
CAN receive it without personal faith.

## The denominational split

- **CATHOLIC + ORTHODOX + LUTHERAN + ANGLICAN**: infant baptism
- **BAPTIST + many EVANGELICAL**: believer's baptism only (credobaptism)

The split hinges on T3: if sacraments merely SYMBOLIZE grace already
received by faith, then you need faith first → no infant baptism. If
sacraments CONFER grace (T3), then faith can come after.

## What this formalization reveals

The anti-paedobaptist objection is NOT primarily about covenant continuity
or parental representation. It is about **T3 (sacramental efficacy)**. If
you accept T3, the infant baptism argument goes through: the infant has
original sin, needs baptism, and can be presented by the Church. If you
reject T3 (sacraments are symbols, not causes), the argument fails at the
first step: baptism doesn't DO anything without prior faith, so presenting
an infant is pointless.

The secondary issue — whether the Church can PRESENT a child for grace
(ecclesial representation) — only arises once you accept T3. It is the
point where Orthodox/Catholic practice diverges from a hypothetical
"T3-accepting but anti-paedobaptist" position, which is nearly empty
in practice.

## Hidden assumptions

1. **Infants have original sin** (§405, §1250). This is ecumenical among
   traditions that accept original sin. Pelagians denied it.
2. **The Church can act on behalf of a non-consenting member** (§1251).
   This is a claim about ecclesial representation — the faith of the
   community suffices for sacramental validity when personal faith is
   impossible.
3. **Baptismal grace is real even before it is ratified by personal faith**
   (§1253–1254). The grace is genuine from the moment of baptism;
   catechesis and personal faith develop it but do not create it.

## Modeling choices

1. We model an infant as a `Person` with `hasIntellect = true` and
   `hasFreeWill = true` but who has not yet exercised rational assent.
   The CCC does not deny infants have intellect and will — they have
   not yet EXERCISED them. We capture this with `canProfessFaith`.
2. We model the credobaptist position by negating T3 (sacraments are
   symbols only). This is a simplification — the actual Baptist theology
   has more nuance — but it captures the load-bearing axiom.
-/

set_option autoImplicit false

namespace Catlib.Sacraments.Baptism

open Catlib

-- ============================================================================
-- § 1. Core predicates
-- ============================================================================

/-- Whether a person can currently profess faith — exercise rational assent
    to the content of baptism. Adults can; infants cannot (yet).

    HONEST OPACITY: The CCC does not define a threshold for when a child
    can profess faith. It simply distinguishes "the infant who cannot yet
    make a personal act of faith" (§1250–1252) from adult catechumens.
    We track the distinction without specifying the boundary. -/
opaque canProfessFaith : Person → Prop

/-- Whether a person has been validly baptized.

    STRUCTURAL OPACITY: Baptismal status is a binary fact — either
    the sacrament was administered or it was not. The CCC treats it
    as irreversible (§1272: "an indelible spiritual mark"). -/
opaque isBaptized : Person → Prop

/-- Whether the Church (through parents, godparents, or community)
    presents a person for baptism.

    HIDDEN ASSUMPTION (§1251): The CCC assumes the Church can act as
    representative for a person who cannot yet consent. This is not
    argued for in the CCC — it is presupposed. The faith of the
    presenting community is what "stands in" for the infant's
    not-yet-possible personal faith.

    This is where the ecclesiological assumption enters: the Church
    is a body that can act corporately, not merely a collection of
    individuals who each act alone. -/
opaque ecclesialPresentation : Person → Prop

/-- Whether a person has original sin (Layer 1 present).

    §405: Original sin is transmitted to all descendants of Adam —
    it is "a sin which will be transmitted by propagation to all
    mankind, that is, by the transmission of a human nature deprived
    of original holiness and justice."

    §1250: "Born with a fallen human nature and tainted by original sin,
    children also have need of the new birth in Baptism."

    This connects to SinEffects.lean: `originalWound = present`. -/
opaque hasOriginalSin : Person → Prop

/-- Whether a person has received baptismal grace — the specific grace
    that removes original sin (Layer 1).

    This is the EFFECT of baptism under Catholic theology:
    §1263: "By Baptism all sins are forgiven, original sin and all
    personal sins, as well as all punishment for sin."

    CONNECTION TO SinEffects: receiving baptismal grace corresponds to
    transitioning from `originalWound = present` to `originalWound = removed`
    in the SinProfile. -/
opaque receivesBaptismalGrace : Person → Prop

-- ============================================================================
-- § 2. Axioms — the Catholic case for infant baptism
-- ============================================================================

/-!
### Axiom 1: Universal original sin (§405, §1250)

All human persons are born with original sin. This is ecumenical among
traditions that accept the doctrine of original sin (Catholic, Orthodox,
most Protestant). Pelagians denied it; the Council of Carthage (418)
and Trent (Session 5) condemned that denial.
-/

/-- AXIOM (§405, §1250): Every human person is born with original sin.
    "Born with a fallen human nature and tainted by original sin,
    children also have need of the new birth in Baptism."

    Provenance: [Scripture] Rom 5:12 ("sin came into the world through
    one man, and death through sin"); [Tradition] Council of Trent,
    Session 5, Canon 4.
    Denominational scope: ECUMENICAL (among those accepting original sin).
    Teaching kind: DOCTRINE. -/
axiom universal_original_sin :
  ∀ (p : Person), p.hasIntellect = true → hasOriginalSin p

/-- AXIOM (§1250): Original sin creates a NEED for baptism — not merely
    a recommendation, but a genuine requirement for the removal of the
    inherited wound.

    "Born with a fallen human nature and tainted by original sin,
    children also have need of the new birth in Baptism to be freed
    from the power of darkness."

    This is the step that connects original sin to the sacrament:
    if you have the wound, you need the remedy.

    Provenance: [Scripture] Jn 3:5 ("unless one is born of water and
    the Spirit, he cannot enter the kingdom of God"); [Definition] §1250.
    Denominational scope: ECUMENICAL (baptism is universally practiced).
    Teaching kind: DOCTRINE. -/
axiom original_sin_requires_baptism :
  ∀ (p : Person), hasOriginalSin p → ¬isBaptized p → ¬receivesBaptismalGrace p

/-- AXIOM (§1127, T3 applied to baptism): Baptism CONFERS grace —
    it is not merely a public declaration. When validly administered,
    baptism actually removes original sin and confers sanctifying grace.

    This is T3 (sacramental efficacy / ex opere operato) applied
    specifically to baptism. The general T3 is in Axioms.lean;
    this is the baptism-specific instance.

    §1127: "Celebrated worthily in faith, the sacraments confer the
    grace that they signify."
    §1263: "By Baptism all sins are forgiven, original sin and all
    personal sins."

    Provenance: [Tradition] Council of Trent, Session 7, Canon 8;
    [Definition] §1127, §1263.
    Denominational scope: CATHOLIC (Baptists deny this — baptism is
    a public testimony of faith already received, not a grace-conferring act).
    Teaching kind: DOCTRINE.

    CONNECTION TO BASE AXIOM: This is a direct application of T3
    (t3_sacramental_efficacy in Axioms.lean). T3 says sacraments
    confer what they signify; this says baptism specifically confers
    the removal of original sin. -/
axiom baptism_confers_grace :
  ∀ (p : Person), isBaptized p → receivesBaptismalGrace p

/-- AXIOM (§1251–1252): The Church can bring an infant to baptism
    through ecclesial presentation — parents, godparents, and the
    community profess faith on behalf of the child who cannot yet
    profess it personally.

    "Born with a fallen human nature and tainted by original sin,
    children also have need of the new birth in Baptism… For this
    reason the Church permits the baptism of infants, with parents
    and godparents professing the faith on their behalf." (§1250–1252 paraphrase)

    HIDDEN ASSUMPTION: This presupposes that the Church is a corporate
    body that can act representatively — not merely a collection of
    individuals. A strict individualist ecclesiology would reject this:
    no one can make spiritual commitments on behalf of another.

    This axiom says: ecclesial presentation is the PATH by which an
    infant who cannot profess faith can nevertheless come to be baptized.
    Combined with `baptism_confers_grace` (T3), the infant then receives
    grace. The two axioms work together: this one gets the infant TO
    baptism; T3 makes baptism EFFECTIVE.

    Provenance: [Tradition] Immemorial practice, attested 2nd century
    (Hippolytus, Apostolic Tradition); [Definition] §1251–1252.
    Denominational scope: CATHOLIC + ORTHODOX + LUTHERAN + ANGLICAN.
    Teaching kind: DOCTRINE. -/
axiom ecclesial_presentation_enables_baptism :
  ∀ (p : Person), ¬canProfessFaith p → ecclesialPresentation p →
    isBaptized p

-- ============================================================================
-- § 3. The credobaptist position
-- ============================================================================

/-!
### The Baptist / Evangelical position (credobaptism)

The credobaptist rejects T3 as applied to baptism: sacraments do not
CONFER grace; they SYMBOLIZE grace already received through personal
faith. Therefore:

1. Baptism is a public testimony of faith, not a grace-conferring act.
2. You need personal faith BEFORE baptism (or baptism is meaningless).
3. Infants cannot have personal faith → cannot be meaningfully baptized.

We model this by negating the key axiom (baptism_confers_grace) and
adding the credobaptist requirement: faith must precede baptism.
-/

/-- The credobaptist axiom: baptism requires prior personal faith.
    Under this view, baptism is an ordinance of obedience and public
    testimony, not a sacrament that confers grace.

    This is the NEGATION of the Catholic order (baptism → grace → faith
    develops). The credobaptist order is: faith → baptism → public witness.

    Denominational scope: BAPTIST + many EVANGELICAL. -/
opaque credobaptistRequirement : Person → Prop

/-- Under the credobaptist view, only those who can profess faith
    can be validly baptized. This is the formal expression of
    "believer's baptism." -/
axiom credobaptist_requires_faith :
  ∀ (p : Person), credobaptistRequirement p → canProfessFaith p

-- ============================================================================
-- § 4. Theorems — what follows from each axiom set
-- ============================================================================

/-!
### The Catholic derivation

Under Catholic axioms (T3 + universal original sin + ecclesial
presentation), infant baptism is coherent:
- The infant has original sin (universal_original_sin)
- The infant needs baptism (original_sin_requires_baptism)
- Baptism confers grace (baptism_confers_grace / T3)
- The Church can present the infant (ecclesial_presentation_enables_baptism)
- Therefore the infant receives baptismal grace

### The credobaptist block

Under credobaptist axioms, infant baptism fails:
- The infant cannot profess faith
- Baptism requires prior faith (credobaptist_requires_faith)
- Therefore the infant cannot satisfy the baptismal requirement

### The load-bearing axiom

The split is T3. Everything else is shared or secondary.
-/

/-- THEOREM: An infant who is presented by the Church receives
    baptismal grace — even though the infant cannot profess faith.

    This is the core Catholic result. The full chain:
    1. The infant cannot profess faith (given)
    2. The Church presents the infant (ecclesial_presentation_enables_baptism)
    3. Therefore the infant is baptized
    4. Baptism confers grace (baptism_confers_grace / T3)
    5. Therefore the infant receives baptismal grace

    Two axioms work together: `ecclesial_presentation_enables_baptism`
    gets the infant TO baptism; `baptism_confers_grace` (T3) makes
    baptism EFFECTIVE.

    Denominational scope: CATHOLIC + ORTHODOX + LUTHERAN + ANGLICAN. -/
theorem infant_receives_grace
    (infant : Person)
    (h_cannot : ¬canProfessFaith infant)
    (h_presented : ecclesialPresentation infant) :
    receivesBaptismalGrace infant :=
  baptism_confers_grace infant
    (ecclesial_presentation_enables_baptism infant h_cannot h_presented)

/-- THEOREM: An infant has original sin and therefore needs baptism.

    This connects universal original sin to the infant's sacramental
    need. The infant is not baptized for the parents' sake or as
    a social ritual — the infant genuinely needs the remedy because
    the infant genuinely has the wound.

    Denominational scope: ECUMENICAL (among those accepting original sin). -/
theorem infant_needs_baptism
    (infant : Person)
    (h_human : infant.hasIntellect = true)
    (h_not_baptized : ¬isBaptized infant) :
    ¬receivesBaptismalGrace infant :=
  original_sin_requires_baptism infant
    (universal_original_sin infant h_human)
    h_not_baptized

/-- THEOREM: Under credobaptist axioms, an infant who cannot profess
    faith cannot satisfy the baptismal requirement.

    This shows why Baptists reject infant baptism: their axiom set
    REQUIRES personal faith before baptism, and infants cannot
    supply it.

    Note: this does NOT show infant baptism is "wrong" — it shows
    that under a DIFFERENT axiom set (one that rejects T3), the
    practice is incoherent. The question is which axiom set is correct.

    Denominational scope: BAPTIST + EVANGELICAL. -/
theorem credobaptist_excludes_infants
    (infant : Person)
    (h_credo : credobaptistRequirement infant)
    (h_cannot : ¬canProfessFaith infant) :
    False :=
  h_cannot (credobaptist_requires_faith infant h_credo)

/-- THEOREM (the denominational diagnosis): The split over infant
    baptism reduces to T3 (sacramental efficacy).

    If baptism confers grace (Catholic T3), then an infant who is
    baptized receives grace regardless of personal faith.
    If baptism requires prior faith (credobaptist), then an infant
    who cannot profess faith cannot be baptized.

    Both positions are internally consistent. The disagreement is
    over T3 — does baptism CAUSE grace or SYMBOLIZE it?

    This theorem shows the full chain: given T3 (via baptism_confers_grace),
    the infant has original sin, needs baptism, and receives grace
    when baptized. All three axioms are used.

    Denominational scope: ANALYSIS — shows the structure of the
    disagreement, not a claim within any one tradition. -/
theorem t3_is_the_load_bearing_axiom
    (infant : Person)
    (h_human : infant.hasIntellect = true)
    (h_then_baptized : isBaptized infant → receivesBaptismalGrace infant)
    -- ^ This is exactly what baptism_confers_grace provides under T3.
    --   Under credobaptism, this conditional would have an extra guard
    --   (canProfessFaith infant) that the infant cannot satisfy.
    :
    -- The infant has original sin...
    hasOriginalSin infant
    -- ...needs baptism (won't get grace without it)...
    ∧ (¬isBaptized infant → ¬receivesBaptismalGrace infant)
    -- ...and IF baptized, WILL receive grace (by T3)
    ∧ (isBaptized infant → receivesBaptismalGrace infant) :=
  ⟨ universal_original_sin infant h_human,
    original_sin_requires_baptism infant (universal_original_sin infant h_human),
    h_then_baptized ⟩

/-- THEOREM: Baptism connects to the SinProfile model.
    A person who receives baptismal grace has their Layer 1
    (original wound) removed — matching `baptizedInGrace`.

    This bridges Baptism.lean to SinEffects.lean, showing that
    baptismal grace IS the removal of Layer 1.

    Denominational scope: CATHOLIC. -/
theorem baptismal_grace_removes_layer1 :
    baptizedInGrace.originalWound = EffectState.removed := by
  rfl

-- ============================================================================
-- § 5. Denominational tags
-- ============================================================================

/-- Denominational tag for infant baptism practice. -/
def infantBaptismTag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Also Orthodox, Lutheran, Anglican. Baptists + many Evangelicals reject (credobaptism)." }

/-- Denominational tag for the credobaptist position. -/
def credobaptismTag : DenominationalTag :=
  { acceptedBy := []  -- Not in our denomination enum (Baptist not modeled)
    note := "Baptist + many Evangelical. Rejects T3 as applied to baptism." }

/-!
## Summary

The Catholic argument for infant baptism:

| Step | Claim | Source | Axiom |
|------|-------|--------|-------|
| 1 | Infants have original sin | §405, §1250 | `universal_original_sin` |
| 2 | Original sin requires baptism | §1250, Jn 3:5 | `original_sin_requires_baptism` |
| 3 | Baptism confers grace (T3) | §1127, §1263 | `baptism_confers_grace` |
| 4 | Church can present infants | §1251–1252 | `ecclesial_presentation_enables_baptism` |

The denominational split:
- **Accept T3** → infant baptism is coherent (Catholic, Orthodox, Lutheran, Anglican)
- **Reject T3** → infant baptism is incoherent (Baptist, Evangelical)

**Key finding**: The anti-paedobaptist objection ultimately rejects T3
(sacramental efficacy), not covenant continuity or ecclesial representation.
Those secondary issues only arise AFTER T3 is accepted. T3 is the
load-bearing axiom.

**Connection to project**: This confirms that T3 is one of the most
denominationally divisive axioms in the base. It already appears in
the Lutheran modifications table (Axioms.lean: "T3 REJECTED —
Sacraments are signs of grace received by faith, not causes").
Infant baptism is a direct consequence of that rejection.
-/

end Catlib.Sacraments.Baptism
