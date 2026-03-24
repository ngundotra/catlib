import Catlib.Foundations
import Catlib.Foundations.SinEffects
import Catlib.Sacraments.Baptism
import Catlib.Sacraments.SacramentalCausation

/-!
# CCC §1285–1321: Confirmation — Completion of Baptism or Distinct Sacrament?

## The puzzle

The CCC says Confirmation is "necessary for the completion of baptismal grace"
(§1285). But what does "completion" mean? If Confirmation COMPLETES baptism,
then an unconfirmed baptized person is INCOMPLETE. What specifically is missing?

And if Confirmation is merely the "completion" of baptism, why is it a distinct
sacrament at all — rather than just part of baptism?

The East/West practice difference sharpens this: the Eastern churches confer
all three initiation sacraments (Baptism, Confirmation, Eucharist) together in
one rite (§1290-1292). The West separates them, often by years. If temporal
separation doesn't matter theologically, then Confirmation's distinct identity
is about CONTENT, not timing. If temporal separation DOES matter (e.g., for
personal ratification), then the Eastern practice is theologically different
from the Western practice — not merely practically different.

## The CCC's answer

1. **§1285**: "The sacrament of Confirmation... is necessary for the
   completion of baptismal grace."
2. **§1302-1303**: Effects — full outpouring of the Holy Spirit, increase
   and deepening of baptismal grace, deeper bond with the Church, special
   strength for spreading and defending the faith.
3. **§1304-1305**: Confirmation imprints an indelible character — the "seal"
   of the Holy Spirit. Like baptism and holy orders, it cannot be repeated.
4. **§1290-1292**: Eastern practice (all three together) vs. Western
   (separated, typically at age of reason or later).

## What this formalization reveals

The CCC's use of "completion" is AMBIGUOUS between two readings:

1. **CONSTITUTIVE completion**: Baptismal grace is genuinely PARTIAL —
   Confirmation supplies what baptism CANNOT give. An unconfirmed person
   is missing something baptism never provided.

2. **DEVELOPMENTAL completion**: Baptismal grace is FULL in kind but
   immature — Confirmation DEVELOPS what baptism planted. An unconfirmed
   person has everything in seed form but not in full flower.

The CCC's own language pulls in both directions:
- "Full outpouring of the Holy Spirit" (§1302) suggests CONSTITUTIVE —
  baptism gave a partial outpouring, Confirmation gives the full one.
- "Increase and deepening of baptismal grace" (§1303) suggests
  DEVELOPMENTAL — the same grace, more of it.
- The indelible character (§1304) suggests CONSTITUTIVE — Confirmation
  adds something ontologically NEW (a second character) that baptism
  did not and could not give.

Our formalization makes this ambiguity EXPLICIT rather than resolving it.
Both readings are modeled, and we show that the indelible character is
the strongest evidence for the constitutive reading.

## The East/West question

The Eastern practice of conferring all three initiation sacraments together
shows that temporal separation is NOT theologically required. The CCC
acknowledges both practices as valid (§1290-1292). This means:

- The CONTENT of Confirmation is the same regardless of timing.
- The Western practice of delay has PASTORAL reasons (maturity,
  personal ratification) but not THEOLOGICAL necessity.
- Under the constitutive reading, the Eastern infant receives the full
  initiation immediately; under the developmental reading, the infant
  receives all the seeds at once.

## Hidden assumptions

1. **Baptismal grace admits of completion** (§1285). The CCC assumes baptism
   does not exhaust what initiation requires. This is not argued — it is
   presupposed by calling Confirmation "necessary for completion."
2. **The Holy Spirit's outpouring admits of degrees** (§1302). Baptism
   gives the Spirit; Confirmation gives a "full outpouring." This assumes
   the Spirit's gift is gradable — a claim with Trinitarian implications.
3. **Character is the mark of non-repeatability** (§1304-1305). As in
   SacramentalCausation.lean, the indelible character is what makes
   Confirmation non-repeatable. This is shared with baptism and holy orders.

## Modeling choices

1. We model the constitutive/developmental ambiguity as two ALTERNATIVE
   readings rather than resolving it. The CCC does not clearly choose.
2. We model the East/West practice difference as a difference in TIMING,
   not in sacramental CONTENT. The CCC supports this (§1290-1292).
3. We reuse `SacramentKind.confirmation` from SacramentalCausation.lean
   and `isBaptized` from Baptism.lean to connect to the existing sacramental
   ontology.
-/

set_option autoImplicit false

namespace Catlib.Sacraments.Confirmation

open Catlib
open Catlib.Sacraments.SacramentalCausation (SacramentKind imprintsCharacter isRepeatable
  confirmation_imprints_character confirmation_not_repeatable
  causesChangeOfType confirmation_causes_dispositional confirmation_causes_ontological)
open Catlib.Sacraments.Baptism (isBaptized receivesBaptismalGrace baptism_confers_grace)

-- ============================================================================
-- § 1. Core predicates
-- ============================================================================

/-- Whether a person has received the sacrament of Confirmation.

    STRUCTURAL OPACITY: Like baptismal status, confirmation status is a
    binary fact — the sacrament was either administered or not. The CCC
    treats it as irreversible due to the indelible character (§1304). -/
opaque isConfirmed : Person → Prop

/-- Whether a person has received the FULL outpouring of the Holy Spirit
    that Confirmation confers.

    §1302: "It is evident from its celebration that the effect of the
    sacrament of Confirmation is the full outpouring of the Holy Spirit
    as once granted to the apostles on the day of Pentecost."

    HONEST OPACITY: "Full outpouring" vs. the Spirit received in baptism
    is the crux of the constitutive/developmental ambiguity. The CCC does
    not define what makes this outpouring "full" as opposed to the Spirit
    received at baptism. We track the claim without resolving the
    metaphysics of pneumatological degree. -/
opaque hasFullOutpouringOfSpirit : Person → Prop

/-- Whether a person has the STRENGTHENING for mission that Confirmation
    confers — the capacity to spread and defend the faith as a witness.

    §1303: "Confirmation brings an increase and deepening of baptismal
    grace... it gives us a special strength of the Holy Spirit to spread
    and defend the faith by word and action as true witnesses of Christ,
    to confess the name of Christ boldly, and never to be ashamed of
    the Cross."

    HONEST OPACITY: What exactly "special strength for witness" consists
    in is not defined by the CCC. It is dispositional — a capacity or
    empowerment — not merely a juridical status change. -/
opaque hasStrengthForWitness : Person → Prop

/-- Whether a person's baptismal grace is "complete" in the sense the
    CCC intends when it calls Confirmation "necessary for the completion
    of baptismal grace."

    §1285: "The sacrament of Confirmation... is necessary for the
    completion of baptismal grace."

    HONEST OPACITY: This is the key ambiguous predicate. The CCC does
    not define what "completion" means — constitutive (adding what was
    missing) or developmental (maturing what was present). We track
    the predicate as opaque to preserve the ambiguity. -/
opaque baptismalGraceComplete : Person → Prop

/-- Whether a person is FULLY INITIATED into the Catholic Church —
    having received all three sacraments of initiation.

    §1285: The three sacraments of Christian initiation are baptism,
    confirmation, and Eucharist. Together they "lay the foundations
    of every Christian life" (§1212).

    MODELING CHOICE: We model full initiation as having received
    baptism AND confirmation. The Eucharist is the third initiation
    sacrament but is repeatable — its inclusion in "full initiation"
    is about having received it AT LEAST ONCE, not a permanent state.
    We simplify here to the baptism-confirmation pair since our focus
    is on Confirmation's relationship to baptism. -/
opaque isFullyInitiated : Person → Prop

-- ============================================================================
-- § 2. Liturgical practice: East vs. West
-- ============================================================================

/-- Whether all three initiation sacraments are conferred together
    in a single rite.

    §1290: "In the East, [Confirmation] is conferred immediately after
    Baptism and is followed by participation in the Eucharist; this
    tradition highlights the unity of the three sacraments of Christian
    initiation."

    §1292: "In the West... the desire to reserve the completion of
    Baptism to the bishop is suggested as the reason for the temporal
    separation of the two sacraments."

    MODELING CHOICE: We model this as a property of liturgical practice,
    not of the sacrament's theological content. The CCC treats both
    practices as valid — the difference is pastoral, not doctrinal. -/
inductive InitiationPractice where
  /-- Eastern practice: baptism, chrismation, Eucharist together. -/
  | eastern
  /-- Western practice: baptism at birth, confirmation later (often
      at age of reason or adolescence), Eucharist between or after. -/
  | western

-- ============================================================================
-- § 3. Axioms — what the CCC teaches about Confirmation
-- ============================================================================

/-!
### Axiom 1: Confirmation requires prior baptism (§1285, §1306)

Confirmation is a COMPLETION of baptism — it presupposes baptism.
You cannot be confirmed without first being baptized. This is true
in both Eastern and Western practice (in the East, baptism simply
precedes confirmation by moments rather than years).
-/

/-- AXIOM (§1285, §1306): Confirmation presupposes baptism. A person
    must be baptized before receiving Confirmation.

    §1306: "Every baptized person not yet confirmed can and should
    receive the sacrament of Confirmation."

    This is the ordering axiom: baptism → confirmation, never the reverse.
    In Eastern practice both occur in the same rite, but baptism still
    comes first liturgically.

    Provenance: [Definition] §1285, §1306.
    Denominational scope: CATHOLIC (also Orthodox and some Anglican).
    Teaching kind: DOCTRINE. -/
axiom confirmation_requires_baptism :
  ∀ (p : Person), isConfirmed p → isBaptized p

/-!
### Axiom 2: Confirmation confers the full outpouring of the Spirit (§1302)

The defining effect of Confirmation: the "full outpouring" of the Holy Spirit
as at Pentecost. Baptism already gives the Spirit, but Confirmation gives
a special, fuller gift.
-/

/-- AXIOM (§1302): Confirmation confers the full outpouring of the Holy Spirit.

    "It is evident from its celebration that the effect of the sacrament
    of Confirmation is the full outpouring of the Holy Spirit as once
    granted to the apostles on the day of Pentecost."

    This is T3 (sacramental efficacy) applied to Confirmation: the sacrament
    CONFERS what it signifies (the gift of the Spirit in fullness).

    Provenance: [Scripture] Acts 2:1-4 (Pentecost); [Definition] §1302.
    Denominational scope: CATHOLIC.
    Teaching kind: DOCTRINE.

    CONNECTION TO BASE AXIOM: This is a direct application of T3
    (t3_sacramental_efficacy in Axioms.lean). -/
axiom confirmation_confers_full_spirit :
  ∀ (p : Person), isConfirmed p → hasFullOutpouringOfSpirit p

/-!
### Axiom 3: Confirmation confers strength for witness (§1303)

The dispositional effect: the confirmed person is empowered for mission —
to spread and defend the faith.
-/

/-- AXIOM (§1303): Confirmation confers strength to spread and defend the faith.

    "Confirmation brings an increase and deepening of baptismal grace...
    it gives us a special strength of the Holy Spirit to spread and
    defend the faith by word and action as true witnesses of Christ."

    This is the dispositional change already captured in SacramentalCausation.lean
    (confirmation_causes_dispositional). Here we give it specific content:
    the disposition is STRENGTH FOR WITNESS.

    Provenance: [Scripture] Acts 1:8 ("you will receive power when the
    Holy Spirit comes upon you; and you will be my witnesses");
    [Definition] §1303.
    Denominational scope: CATHOLIC.
    Teaching kind: DOCTRINE. -/
axiom confirmation_confers_witness_strength :
  ∀ (p : Person), isConfirmed p → hasStrengthForWitness p

/-!
### Axiom 4: Confirmation completes baptismal grace (§1285)

This is the central claim and the source of the theological tension.
-/

/-- AXIOM (§1285): Confirmation is necessary for the completion of
    baptismal grace.

    "The sacrament of Confirmation... is necessary for the completion
    of baptismal grace."

    This axiom says: if you are confirmed, your baptismal grace is
    complete. The converse — that ONLY confirmation can complete
    baptismal grace — is captured by the next axiom.

    Provenance: [Definition] §1285.
    Denominational scope: CATHOLIC.
    Teaching kind: DOCTRINE.

    HIDDEN ASSUMPTION: That baptismal grace ADMITS of completion —
    i.e., that baptism alone does not exhaust what Christian initiation
    requires. This is not argued for in the CCC; it is presupposed. -/
axiom confirmation_completes_baptism :
  ∀ (p : Person), isConfirmed p → baptismalGraceComplete p

/-- AXIOM (§1285): Confirmation is NECESSARY for the completion of
    baptismal grace — without it, baptismal grace remains incomplete.

    This is the other direction: not merely that Confirmation completes,
    but that nothing ELSE completes. Without Confirmation, the baptized
    person's initiation grace is incomplete.

    Provenance: [Definition] §1285 ("necessary for the completion").
    Denominational scope: CATHOLIC.
    Teaching kind: DOCTRINE.

    This is the axiom that creates the theological tension: it implies
    that an unconfirmed baptized person is in some sense INCOMPLETE.
    What is missing? The full outpouring of the Spirit (§1302) and
    the strength for witness (§1303). -/
axiom confirmation_necessary_for_completion :
  ∀ (p : Person), isBaptized p → ¬isConfirmed p → ¬baptismalGraceComplete p

/-!
### Axiom 5: Full initiation requires both baptism and confirmation (§1285, §1212)
-/

/-- AXIOM (§1285, §1212): Full initiation requires both baptism and
    confirmation — a person is fully initiated if and only if they
    have received both sacraments.

    §1212: "The three sacraments of Christian initiation — Baptism,
    Confirmation, and the Eucharist — lay the foundations of every
    Christian life."

    MODELING CHOICE: We model full initiation as the conjunction of
    baptism and confirmation. This simplifies from the CCC's three-fold
    initiation (which includes Eucharist) to focus on the
    baptism-confirmation relationship.

    Provenance: [Definition] §1212, §1285.
    Denominational scope: CATHOLIC.
    Teaching kind: DOCTRINE. -/
axiom full_initiation_iff :
  ∀ (p : Person), isFullyInitiated p ↔ (isBaptized p ∧ isConfirmed p)

/-!
### Axiom 6: Temporal separation does not change sacramental content (§1290-1292)

The East/West practice difference is pastoral, not theological.
-/

/-- AXIOM (§1290-1292): The sacramental content of Confirmation is the
    same regardless of whether it is conferred immediately after baptism
    (Eastern practice) or years later (Western practice).

    §1290: "In the first centuries Confirmation generally comprised a
    single celebration with Baptism..."
    §1292: "The practice of the Western Church... is suggested as the
    reason for the temporal separation of the two sacraments."

    The CCC validates BOTH practices. This means the theological content
    (what Confirmation IS and DOES) is invariant under temporal separation.

    HIDDEN ASSUMPTION: That sacramental identity is determined by content
    (matter, form, minister, effect), not by temporal context. This is a
    standard Catholic principle but it is doing real work here: it means
    an infant confirmed moments after baptism (East) receives the SAME
    sacrament as an adolescent confirmed years later (West).

    Provenance: [Tradition] §1290-1292.
    Denominational scope: CATHOLIC + ORTHODOX.
    Teaching kind: DOCTRINE. -/
axiom temporal_separation_irrelevant :
  ∀ (p : Person) (_practice : InitiationPractice),
    isConfirmed p → hasFullOutpouringOfSpirit p ∧ hasStrengthForWitness p

-- ============================================================================
-- § 4. Theorems — what the structure reveals
-- ============================================================================

/-!
### The core tension: unconfirmed baptized persons are INCOMPLETE

The combination of `baptism_confers_grace` (from Baptism.lean) and
`confirmation_necessary_for_completion` reveals that an unconfirmed
baptized person is in a state of GENUINE INCOMPLETENESS. This is not
a deficiency in baptism — baptism does everything baptism can do. It
is a structural feature of the Catholic initiation system: full
initiation requires multiple sacraments.
-/

/-- THEOREM: An unconfirmed baptized person has genuine baptismal grace
    (from baptism_confers_grace) but their baptismal grace is not complete
    (from confirmation_necessary_for_completion).

    This shows the intermediate state is REAL, not merely nominal.

    Denominational scope: CATHOLIC. -/
theorem baptized_but_incomplete
    (p : Person)
    (h_baptized : isBaptized p)
    (h_not_confirmed : ¬isConfirmed p) :
    receivesBaptismalGrace p ∧ ¬baptismalGraceComplete p :=
  ⟨baptism_confers_grace p h_baptized,
   confirmation_necessary_for_completion p h_baptized h_not_confirmed⟩

/-- THEOREM: Confirmation presupposes baptismal grace — you must already
    have baptismal grace before Confirmation can complete it.

    This is the chain: confirmation → baptized (axiom 1) → has grace
    (baptism_confers_grace from Baptism.lean). Confirmation BUILDS ON
    what baptism already gave.

    Denominational scope: CATHOLIC. -/
theorem confirmation_presupposes_grace
    (p : Person)
    (h_confirmed : isConfirmed p) :
    receivesBaptismalGrace p :=
  baptism_confers_grace p (confirmation_requires_baptism p h_confirmed)

/-- THEOREM: A confirmed person has BOTH baptismal grace and complete
    baptismal grace — the full package.

    Denominational scope: CATHOLIC. -/
theorem confirmed_has_full_grace
    (p : Person)
    (h_confirmed : isConfirmed p) :
    receivesBaptismalGrace p ∧ baptismalGraceComplete p :=
  ⟨confirmation_presupposes_grace p h_confirmed,
   confirmation_completes_baptism p h_confirmed⟩

/-- THEOREM: A confirmed person has the full outpouring of the Spirit
    AND strength for witness — both effects together.

    This packages the two effects (axioms 2 and 3) into a conjunction,
    making explicit that Confirmation is not JUST pneumatological and not
    JUST dispositional — it is both.

    Denominational scope: CATHOLIC. -/
theorem confirmation_full_effects
    (p : Person)
    (h_confirmed : isConfirmed p) :
    hasFullOutpouringOfSpirit p ∧ hasStrengthForWitness p ∧ baptismalGraceComplete p :=
  ⟨confirmation_confers_full_spirit p h_confirmed,
   confirmation_confers_witness_strength p h_confirmed,
   confirmation_completes_baptism p h_confirmed⟩

/-- THEOREM: Full initiation implies both baptismal grace and complete
    baptismal grace.

    A fully initiated person has received baptism (giving grace) and
    confirmation (completing that grace).

    Denominational scope: CATHOLIC. -/
theorem full_initiation_has_complete_grace
    (p : Person)
    (h_init : isFullyInitiated p) :
    receivesBaptismalGrace p ∧ baptismalGraceComplete p :=
  let ⟨h_bap, h_conf⟩ := (full_initiation_iff p).mp h_init
  ⟨baptism_confers_grace p h_bap,
   confirmation_completes_baptism p h_conf⟩

/-- THEOREM: An unconfirmed baptized person is NOT fully initiated.

    This follows directly from full_initiation_iff — full initiation
    requires both baptism AND confirmation.

    Denominational scope: CATHOLIC. -/
theorem unconfirmed_not_fully_initiated
    (p : Person)
    (h_not_confirmed : ¬isConfirmed p) :
    ¬isFullyInitiated p := by
  intro h_init
  exact h_not_confirmed ((full_initiation_iff p).mp h_init).2

-- ============================================================================
-- § 5. The constitutive vs. developmental reading
-- ============================================================================

/-!
### Making the ambiguity precise

The CCC's language of "completion" admits two readings. We model both
and show what each implies.
-/

/-- The CONSTITUTIVE reading: Confirmation supplies something baptism
    CANNOT give. Under this reading, baptismal grace is genuinely partial —
    missing the full outpouring of the Spirit and the strength for witness.

    Evidence for this reading:
    - "Full outpouring" (§1302) implies baptism gave a partial outpouring
    - The indelible character (§1304) is ontologically NEW — baptism's
      character is different from confirmation's character
    - Confirmation is a SEPARATE sacrament, not part of baptism

    MODELING CHOICE: We define this as the conjunction of two claims:
    (1) an unconfirmed person LACKS the full Spirit, and
    (2) an unconfirmed person LACKS strength for witness.
    These are the specific deficits that Confirmation remedies. -/
def constitutiveReading (p : Person) : Prop :=
  isBaptized p → ¬isConfirmed p →
    ¬hasFullOutpouringOfSpirit p ∧ ¬hasStrengthForWitness p

/-- The DEVELOPMENTAL reading: Baptism gives the Spirit fully in KIND
    but not in DEGREE. Confirmation matures or intensifies what baptism
    already planted.

    Evidence for this reading:
    - "Increase and deepening" (§1303) suggests MORE of the same, not
      something categorically new
    - The Eastern practice of immediate Confirmation suggests the
      "completion" is not about temporal maturation

    MODELING CHOICE: Under this reading, the unconfirmed person HAS
    the Spirit (from baptism) but the Spirit's gifts are not yet fully
    developed/intensified. We cannot distinguish this from the constitutive
    reading purely formally — the distinction is in INTERPRETATION of
    what "full outpouring" means relative to baptismal Spirit-reception.

    We model this as: the unconfirmed person has SOME form of the Spirit's
    presence, even if not the "full outpouring" of Confirmation. -/
opaque hasSpiritFromBaptism : Person → Prop

/-- Under the developmental reading, every baptized person already has
    the Spirit — baptism itself confers the Spirit, just not the "full
    outpouring."

    §1266: "The Most Holy Trinity gives the baptized sanctifying grace,
    the grace of justification."

    This is ECUMENICAL — all Christian traditions that practice baptism
    agree it involves the Holy Spirit (the Trinitarian formula itself
    invokes the Spirit).

    Provenance: [Scripture] Acts 2:38 ("you will receive the gift of
    the Holy Spirit"); [Definition] §1266.
    Denominational scope: ECUMENICAL.
    Teaching kind: DOCTRINE. -/
axiom baptism_gives_spirit :
  ∀ (p : Person), isBaptized p → hasSpiritFromBaptism p

/-- THEOREM: Under the developmental reading, even an unconfirmed
    baptized person already has the Spirit from baptism. The Spirit
    is present; what Confirmation adds is the FULL outpouring.

    This uses baptism_gives_spirit: baptism itself confers the Spirit.
    Confirmation then brings the Spirit to fullness, not from absence.

    Denominational scope: ECUMENICAL (Spirit received at baptism). -/
theorem developmental_unconfirmed_has_spirit
    (p : Person)
    (h_baptized : isBaptized p) :
    hasSpiritFromBaptism p :=
  baptism_gives_spirit p h_baptized

/-- THEOREM: Under the constitutive reading, Confirmation adds something
    baptism CANNOT provide — the confirmed person has effects the merely
    baptized person lacks.

    This is the argument for Confirmation as a genuinely distinct sacrament
    rather than merely the second half of baptism. -/
theorem constitutive_shows_distinct_content
    (p : Person)
    (h_constitutive : constitutiveReading p)
    (h_baptized : isBaptized p)
    (h_not_confirmed : ¬isConfirmed p) :
    ¬hasFullOutpouringOfSpirit p ∧ ¬hasStrengthForWitness p :=
  h_constitutive h_baptized h_not_confirmed

-- ============================================================================
-- § 6. Connection to character sacraments
-- ============================================================================

/-!
### Confirmation as the second character sacrament

Confirmation, like baptism and holy orders, imprints an indelible
character (§1304). This character is what makes it non-repeatable.
The character is ONTOLOGICALLY DISTINCT from the baptismal character —
a person can have one without the other (before confirmation) or both
(after confirmation).

This is the strongest evidence for the CONSTITUTIVE reading: if
Confirmation merely "deepened" baptism without adding something new,
why would it imprint a SEPARATE character? The separate character
implies a separate ontological effect.
-/

/-- THEOREM: Confirmation is non-repeatable because it imprints an
    indelible character — connecting to SacramentalCausation.lean.

    This theorem re-derives the non-repeatability from the character,
    showing that Confirmation.lean is consistent with the
    character/repeatability biconditional established there. -/
theorem confirmation_character_blocks_repetition :
    imprintsCharacter .confirmation ∧ ¬isRepeatable .confirmation :=
  ⟨confirmation_imprints_character, confirmation_not_repeatable⟩

/-- THEOREM: The separate character is evidence for the constitutive reading.

    If Confirmation imprints a NEW indelible character distinct from the
    baptismal character, and causes both dispositional AND ontological
    change (from SacramentalCausation.lean), then it adds something
    ontologically new — not merely more of what baptism gave.

    This is a structural argument, not a CCC proof. The CCC does not
    explicitly argue from the separate character to the constitutive
    reading. But the existence of two distinct characters strongly
    suggests two distinct ontological contributions. -/
theorem separate_character_implies_distinct_contribution :
    imprintsCharacter .confirmation
    ∧ causesChangeOfType .confirmation .ontological
    ∧ causesChangeOfType .confirmation .dispositional :=
  ⟨confirmation_imprints_character,
   confirmation_causes_ontological,
   confirmation_causes_dispositional⟩

-- ============================================================================
-- § 7. East/West invariance
-- ============================================================================

/-!
### The East/West practice is pastoral, not doctrinal

Both practices are valid. The sacrament's effects are the same.
What differs is the timing — and the CCC says the theological content
is invariant under temporal separation.
-/

/-- THEOREM: Under both Eastern and Western practice, a confirmed person
    receives the same effects.

    This follows directly from temporal_separation_irrelevant (axiom 6).
    The Eastern infant confirmed at baptism and the Western adolescent
    confirmed years later receive the SAME sacramental content.

    Denominational scope: CATHOLIC + ORTHODOX. -/
theorem east_west_same_effects
    (p : Person)
    (h_confirmed : isConfirmed p) :
    hasFullOutpouringOfSpirit p ∧ hasStrengthForWitness p :=
  -- Both practices yield the same effects; we can use either
  temporal_separation_irrelevant p .eastern h_confirmed

/-- THEOREM: The East/West difference does not affect the completion
    of baptismal grace.

    Whether Confirmation is received immediately (East) or after years
    (West), it COMPLETES baptismal grace in either case.

    Denominational scope: CATHOLIC + ORTHODOX. -/
theorem east_west_both_complete
    (p : Person)
    (h_confirmed : isConfirmed p) :
    baptismalGraceComplete p :=
  confirmation_completes_baptism p h_confirmed

-- ============================================================================
-- § 8. Denominational tags
-- ============================================================================

/-- Denominational tag for the Confirmation doctrine. -/
def confirmationTag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Also Orthodox (as Chrismation). Some Anglicans and Lutherans practice confirmation but with different theology (often not as sacrament with indelible character)." }

/-- Denominational tag for the East/West invariance. -/
def eastWestTag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Both Eastern and Western practices are valid per §1290-1292. Orthodox practice Chrismation immediately after baptism." }

-- ============================================================================
-- § 9. Summary
-- ============================================================================

/-!
## Summary: What the CCC teaches about Confirmation

**The answer to "completion or distinct sacrament?"**: BOTH — and this is
not a contradiction. Confirmation COMPLETES baptism (§1285) by adding what
baptism cannot give on its own: the full outpouring of the Spirit (§1302),
strength for witness (§1303), and a second indelible character (§1304).
It is DISTINCT because these effects are genuinely new, not merely more
of what baptism gave.

**Key structural findings:**

1. **Unconfirmed baptized persons are genuinely incomplete** — they have
   real baptismal grace (from baptism_confers_grace) but their initiation
   grace is not yet complete (from confirmation_necessary_for_completion).
   This is the intermediate state that the CCC's "necessary for completion"
   language creates.

2. **The constitutive/developmental ambiguity is real** — the CCC's own
   language supports both readings. The strongest evidence for the
   constitutive reading is the SEPARATE INDELIBLE CHARACTER: if Confirmation
   merely deepened existing grace without adding something ontologically
   new, a separate character would be otiose.

3. **The East/West practice difference is pastoral, not theological** —
   the sacramental content is invariant under temporal separation
   (temporal_separation_irrelevant). An Eastern infant confirmed at
   baptism and a Western adolescent confirmed years later receive the
   SAME effects.

4. **Confirmation connects three existing formalizations**:
   - Baptism.lean (Layer 1): Confirmation presupposes baptismal grace
   - SacramentalCausation.lean: Confirmation is the second character
     sacrament (character ↔ non-repeatable)
   - The base axiom T3 (Axioms.lean): Confirmation CONFERS what it
     signifies — both the Spirit and the strength for witness

5. **What specifically is missing in the unconfirmed?** — The full
   outpouring of the Spirit (§1302) and the strength for witness (§1303).
   These are not baptismal deficits but CONFIRMATIONAL goods that baptism
   was never designed to give. Baptism does everything baptism does; it
   does not do what Confirmation does.

**Connection to project**: This is the sixth sacrament formalization
(after Baptism, Eucharist, Reconciliation, Priestly Absolution,
Sacramental Causation, Anointing). It fills the Confirmation slot in
the seven-sacrament system and connects the baptismal character to the
confirmational character through the shared framework of
SacramentalCausation.lean.
-/

end Catlib.Sacraments.Confirmation
