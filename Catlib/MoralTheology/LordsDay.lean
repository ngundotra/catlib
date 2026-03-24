import Catlib.Foundations

/-!
# CCC §2168–2176: The Lord's Day — Why Sunday, Not Saturday?

## The puzzle

The Third Commandment says "Remember the sabbath day, to keep it holy" (Ex 20:8).
The Sabbath is Saturday — the seventh day. Yet Christians worship on Sunday — the
first day of the week. Why? Is this a later corruption (as Seventh-day Adventists
claim), or a principled development rooted in the Resurrection and apostolic
practice?

## The CCC's three arguments

### 1. Resurrection (§2174)
"Jesus rose from the dead 'on the first day of the week.' Because it is the
'first day,' the day of Christ's Resurrection recalls the first creation. Because
it is the 'eighth day' following the sabbath, it signifies the new creation
ushered in by Christ's Resurrection."

Christ's resurrection reorients sacred time. The old creation's seventh-day rest
is FULFILLED by the new creation's first-day rising. The day of worship shifts
because the REASON for worship shifts — from remembering creation's completion
to celebrating new creation's inauguration.

### 2. Apostolic practice (§2175)
"Sunday is expressly distinguished from the sabbath which it follows
chronologically every week; for Christians its ceremonial observance replaces
that of the sabbath."

The early Church gathered on Sunday from the beginning: Acts 20:7 ("On the first
day of the week, when we were gathered together to break bread"), 1 Cor 16:2
("On the first day of every week"), Rev 1:10 ("the Lord's day"). This is
attested apostolic practice, not a later invention.

### 3. Fulfillment (§2175–2176)
"The celebration of Sunday observes the moral commandment inscribed by nature
in the human heart to render to God an outward, visible, public, and regular
worship."

The Sabbath commandment has TWO layers:
- **Moral core**: the duty of regular worship (natural law, universal, permanent)
- **Ceremonial specification**: worship on the seventh day (Mosaic law, particular,
  fulfilled in Christ)

The moral core is PRESERVED; the ceremonial specification is REPLACED. This
is not abolition but fulfillment — the commandment's purpose is achieved in a
new form.

## Prediction

I expect the key finding to be: the FULFILLMENT argument (argument 3) is doing
the structural load-bearing work. Without the moral/ceremonial distinction, you
cannot explain why the day changes but the obligation remains. Resurrection
provides the REASON for Sunday specifically, and apostolic practice provides the
EVIDENCE that the shift is authentic, but the fulfillment framework explains HOW
a divine commandment can change in form while persisting in substance.

The SDA position should test this: SDA rejects the moral/ceremonial distinction
(or applies it differently) and therefore concludes the seventh-day specification
is still binding.

## Findings

- **Prediction largely confirmed, with a nuance**: The fulfillment framework
  (moral/ceremonial distinction) is indeed structurally necessary — without it
  you get either full abolition or full retention of the Sabbath. But it is not
  SUFFICIENT: you also need the resurrection to explain why Sunday specifically
  (rather than any other day or no fixed day). The three arguments are genuinely
  complementary:
  - Fulfillment explains HOW the day can change (moral core persists, ceremonial
    form is replaceable)
  - Resurrection explains WHY Sunday (new creation inaugurated on the first day)
  - Apostolic practice explains WHEN and provides evidence of authenticity
    (the shift is apostolic, not medieval)

- **The SDA test**: The SDA position rejects `ceremonial_is_fulfilled` — they
  hold that the seventh-day specification is part of the moral law, not
  merely ceremonial. Under their axiom set, Sunday worship is indeed unjustified.
  The debate reduces to a single axiom: is the day-specification moral or
  ceremonial?

- **Key finding on which premise is load-bearing**: ALL THREE are needed, but
  for different things. Drop fulfillment → you cannot explain how any
  commandment changes. Drop resurrection → you cannot explain why Sunday.
  Drop apostolic practice → you lose the evidence that the shift is authentic
  (the SDA objection — "this was a later corruption" — becomes unanswerable).

  The fulfillment framework does the LOGICAL work (enables change). The
  resurrection does the MATERIAL work (specifies Sunday). Apostolic practice
  does the EVIDENTIAL work (attests the shift's antiquity). The Catholic
  argument uses all three; traditions that drop any one face a specific gap.

- **Hidden assumptions identified**:
  1. **Commandments have a two-layer structure** (moral core + ceremonial
     specification). The CCC assumes this distinction (§2175–2176) but does not
     argue for it. It comes from the Thomistic classification of Old Testament
     law into moral, ceremonial, and judicial categories (ST I-II q.99–105).
     This is a PHILOSOPHICAL framework imposed on the biblical text.
  2. **Christ's resurrection has cosmic-liturgical significance** — it reorients
     sacred time, not just individual salvation. §2174 treats the resurrection
     as inaugurating a "new creation," which presupposes a theology of sacred
     time that goes beyond the bare historical fact.
  3. **Apostolic practice is normative** — what the apostles did is what
     Christians should do. This is a Tradition axiom (the "living Tradition"
     of §2175). Sola scriptura adherents who accept Sunday worship implicitly
     accept this principle for this case.

- **Modeling choices**:
  1. We model the moral/ceremonial distinction as a predicate on commandment
     components rather than on whole commandments. This captures the CCC's
     claim that the SAME commandment has both moral and ceremonial aspects.
  2. We model "fulfilled" as meaning the ceremonial layer is no longer binding
     in its original form. This is the Thomistic reading; other readings
     (e.g., dispensationalist) model fulfillment differently.

- **Denominational scope**:
  - CATHOLIC + ORTHODOX + most PROTESTANT: accept Sunday worship
  - SEVENTH-DAY ADVENTIST: reject the shift — argue the seventh-day
    specification is moral, not ceremonial
  - The SDA position is internally consistent under different axioms
-/

set_option autoImplicit false

namespace Catlib.MoralTheology.LordsDay

open Catlib

-- ============================================================================
-- § 1. Core types
-- ============================================================================

/-- A day of the week for worship.
    MODELING CHOICE: We only need to distinguish the seventh day (Sabbath)
    from the first day (Sunday) for this formalization. Other days are
    irrelevant to the argument. -/
inductive DayOfWorship where
  /-- The seventh day — Saturday. The day God rested (Gen 2:2–3). -/
  | seventhDay
  /-- The first day — Sunday. The day Christ rose (Mk 16:2, Mt 28:1). -/
  | firstDay
  deriving DecidableEq

/-- The aspect of a commandment that determines its binding force.
    HIDDEN ASSUMPTION: Commandments have a two-layer structure.
    The CCC (following Aquinas ST I-II q.99–105) distinguishes:
    - moral precepts: grounded in natural law, universally and permanently binding
    - ceremonial precepts: specifying mode/time/manner, tied to a particular
      covenant dispensation, subject to fulfillment

    This distinction is NOT self-evident. The SDA position denies it
    (at least for the Sabbath day-specification). The entire argument
    turns on whether this classification is correct. -/
inductive CommandmentAspect where
  /-- The moral core — grounded in natural law, permanently binding.
      Example: the duty to worship God regularly. §2176: "the moral
      commandment inscribed by nature in the human heart." -/
  | moral
  /-- The ceremonial specification — tied to the Mosaic covenant,
      fulfilled in Christ. Example: the specification of Saturday. -/
  | ceremonial
  deriving DecidableEq

/-- A component of the Sabbath commandment.
    The Third Commandment has two distinguishable components:
    1. The duty of regular worship (moral)
    2. The specification of the seventh day (ceremonial, per the CCC)

    MODELING CHOICE: We decompose the commandment into components rather
    than treating it as atomic. This is itself part of the argument —
    the SDA treats the commandment as indivisible. -/
structure SabbathComponent where
  /-- What this component prescribes -/
  content : Prop
  /-- Whether this component is moral or ceremonial -/
  aspect : CommandmentAspect

-- ============================================================================
-- § 2. Core predicates
-- ============================================================================

/-- Whether Christ rose on a given day.
    STRUCTURAL OPACITY: The resurrection is a historical claim that the
    CCC treats as a foundational fact (§638–658). We do not attempt to
    formalize the evidence for the resurrection itself — only its
    liturgical consequence. -/
opaque roseOnDay : DayOfWorship → Prop

/-- Whether a practice is attested in apostolic times.
    A practice is apostolic if it is evidenced in the New Testament
    and the earliest patristic sources. Acts 20:7, 1 Cor 16:2,
    Rev 1:10, Didache 14:1.

    HONEST OPACITY: "Apostolic" is a historical claim about origins.
    The CCC affirms it (§2175) but the evidence requires historical
    judgment, not deduction. -/
opaque isApostolicPractice : Prop → Prop

/-- Whether a ceremonial precept has been fulfilled (and thus its original
    form is no longer binding).
    "Fulfilled" means the purpose of the precept has been achieved in
    Christ, so the precept persists in its moral core but not in its
    specific ceremonial form.

    HONEST OPACITY: "Fulfillment" is a theological category from
    Mt 5:17 ("I came not to abolish but to fulfill"). Its precise
    mechanism is debated. We keep it opaque because the CCC uses it
    (§2175) without giving a formal definition of what fulfillment IS. -/
opaque isFulfilled : SabbathComponent → Prop

/-- Whether a commandment component is currently binding on Christians.
    "Binding" means it obliges under the new covenant. Moral precepts
    remain binding; fulfilled ceremonial precepts do not bind in their
    original form. -/
opaque isBinding : SabbathComponent → Prop

/-- Whether a given day is the proper day for Christian worship.
    This is the conclusion we want to derive: Sunday is the proper
    day of Christian worship. -/
opaque isProperWorshipDay : DayOfWorship → Prop

/-- Whether a day inaugurates or symbolizes new creation.
    §2174: Christ's resurrection on the first day "recalls the first
    creation" and "signifies the new creation." -/
opaque signifiesNewCreation : DayOfWorship → Prop

-- ============================================================================
-- § 3. Definitions: the two components of the Sabbath commandment
-- ============================================================================

/-- The moral core of the Third Commandment: the duty of regular worship.
    §2176: "The celebration of Sunday observes the moral commandment
    inscribed by nature in the human heart to render to God an outward,
    visible, public, and regular worship." -/
opaque dutyOfRegularWorship : Prop

/-- The Mosaic day-specification: worship on the seventh day.
    Gen 2:2–3, Ex 20:8–11. -/
opaque seventhDaySpecification : Prop

/-- The moral component: regular worship is obligatory. -/
def moralComponent : SabbathComponent :=
  { content := dutyOfRegularWorship, aspect := .moral }

/-- The ceremonial component: worship falls on Saturday. -/
def ceremonialComponent : SabbathComponent :=
  { content := seventhDaySpecification, aspect := .ceremonial }

-- ============================================================================
-- § 4. Axioms
-- ============================================================================

/-!
### Axiom 1: Christ rose on the first day (§2174)

This is the historical-theological claim that grounds the shift.
"Jesus rose from the dead 'on the first day of the week.'"

Provenance: [Scripture] Mk 16:2, Mt 28:1, Lk 24:1, Jn 20:1.
Denominational scope: ECUMENICAL — all Christians affirm the Sunday
resurrection.
-/

/-- AXIOM (§2174): Christ rose on the first day of the week (Sunday). -/
axiom christ_rose_on_first_day : roseOnDay DayOfWorship.firstDay

/-- AXIOM (§2174): The day of resurrection signifies new creation.
    "Because it is the 'first day,' the day of Christ's Resurrection
    recalls the first creation. Because it is the 'eighth day' following
    the sabbath, it signifies the new creation."

    Provenance: [Scripture] 2 Cor 5:17 ("if anyone is in Christ, the new
    creation has come"); Rev 21:5 ("I am making everything new").
    Denominational scope: ECUMENICAL. -/
axiom resurrection_day_is_new_creation :
  ∀ (d : DayOfWorship), roseOnDay d → signifiesNewCreation d

/-!
### Axiom 2: Sunday worship is apostolic practice (§2175)

"Sunday is expressly distinguished from the sabbath which it follows
chronologically every week."

Provenance: [Scripture] Acts 20:7; 1 Cor 16:2; Rev 1:10.
[Tradition] Didache 14:1; Ignatius of Antioch, Magnesians 9:1.
Denominational scope: CATHOLIC + ORTHODOX + most PROTESTANT.
SDA disputes the interpretation of these passages.
-/

/-- AXIOM (§2175): Gathering for worship on the first day is an
    apostolic practice — attested in the New Testament itself. -/
axiom sunday_worship_is_apostolic :
  isApostolicPractice (isProperWorshipDay DayOfWorship.firstDay)

/-!
### Axiom 3: Moral precepts remain binding; ceremonial precepts are fulfilled (§2175–2176)

The fulfillment framework: Christ fulfills the ceremonial law while
preserving the moral law. The duty of regular worship (moral) persists;
the seventh-day specification (ceremonial) is fulfilled.

HIDDEN ASSUMPTION: This is the Thomistic classification of Old Testament
law (ST I-II q.99–105). The CCC adopts it (§2175–2176) but does not
argue for it. The SDA rejects it for the Sabbath specifically.

Provenance: [Tradition] Aquinas ST I-II q.99–105; §2175–2176.
Denominational scope: CATHOLIC + ORTHODOX + most PROTESTANT.
-/

/-- AXIOM (§2176): Moral precepts remain binding under the new covenant. -/
axiom moral_precepts_bind :
  ∀ (c : SabbathComponent), c.aspect = CommandmentAspect.moral → isBinding c

/-- AXIOM (§2175): The ceremonial day-specification is fulfilled in Christ.
    The seventh-day specification belongs to the Mosaic ceremonial law
    and is fulfilled — its purpose (honoring God's creative rest) is
    achieved in the new creation inaugurated by Christ's resurrection. -/
axiom ceremonial_is_fulfilled :
  ∀ (c : SabbathComponent), c.aspect = CommandmentAspect.ceremonial → isFulfilled c

/-- AXIOM (§2175): A fulfilled ceremonial precept is no longer binding
    in its original form. Fulfillment does not mean abolition — the moral
    core persists — but the specific ceremonial form gives way. -/
axiom fulfilled_not_binding :
  ∀ (c : SabbathComponent), isFulfilled c → ¬ isBinding c

/-!
### Axiom 4: The day of new creation is the proper day of Christian worship (§2174–2175)

This is the axiom that CONNECTS resurrection to liturgical practice.
The day that signifies new creation is the fitting day for the new
covenant's worship, because new-covenant worship celebrates new creation.

Provenance: [Tradition] §2174–2175.
Denominational scope: CATHOLIC + ORTHODOX + most PROTESTANT.
-/

/-- AXIOM (§2174): The day signifying new creation is the proper day
    for Christian worship. New-covenant worship celebrates what the
    resurrection inaugurated. -/
axiom new_creation_day_is_worship_day :
  ∀ (d : DayOfWorship), signifiesNewCreation d → isProperWorshipDay d

-- ============================================================================
-- § 5. Theorems
-- ============================================================================

/-- THEOREM: The moral core of the Sabbath commandment remains binding.
    The duty of regular worship is a moral precept (grounded in natural law,
    §2176) and therefore persists under the new covenant.

    Depends on: moral_precepts_bind. -/
theorem worship_duty_persists :
    isBinding moralComponent :=
  moral_precepts_bind moralComponent rfl

/-- THEOREM: The seventh-day specification is no longer binding.
    The ceremonial specification (Saturday) is fulfilled in Christ
    and therefore does not bind Christians in its original form.

    Depends on: ceremonial_is_fulfilled, fulfilled_not_binding. -/
theorem seventh_day_not_binding :
    ¬ isBinding ceremonialComponent :=
  have h_ful := ceremonial_is_fulfilled ceremonialComponent rfl
  fulfilled_not_binding ceremonialComponent h_ful

/-- THEOREM: Sunday signifies new creation.
    Christ rose on Sunday; the day of resurrection signifies new creation;
    therefore Sunday signifies new creation.

    Depends on: christ_rose_on_first_day, resurrection_day_is_new_creation. -/
theorem sunday_is_new_creation :
    signifiesNewCreation DayOfWorship.firstDay :=
  resurrection_day_is_new_creation DayOfWorship.firstDay christ_rose_on_first_day

/-- THEOREM: Sunday is the proper day of Christian worship.
    Resurrection + new creation symbolism + axiom connecting new creation
    to worship day → Sunday is the proper worship day.

    This is the positive argument for Sunday specifically. It requires
    the resurrection chain (axioms 1a + 1b + 4).

    Depends on: christ_rose_on_first_day, resurrection_day_is_new_creation,
    new_creation_day_is_worship_day. -/
theorem sunday_is_proper_worship_day :
    isProperWorshipDay DayOfWorship.firstDay :=
  have h_new := sunday_is_new_creation
  new_creation_day_is_worship_day DayOfWorship.firstDay h_new

/-- THEOREM (Main): The full Lord's Day argument — all three components.
    Christians worship on Sunday because:
    (a) The duty of regular worship persists (moral core preserved)
    (b) The seventh-day specification is no longer binding (ceremonial fulfilled)
    (c) Sunday is the proper day of Christian worship (resurrection + new creation)
    (d) This practice is apostolic, not a later invention

    Depends on: ALL axioms (1a, 1b, 2, 3a, 3b, 3c, 4). -/
theorem lords_day_argument :
    -- (a) Worship obligation persists
    isBinding moralComponent
    -- (b) Saturday specification no longer binding
    ∧ ¬ isBinding ceremonialComponent
    -- (c) Sunday is the proper day
    ∧ isProperWorshipDay DayOfWorship.firstDay
    -- (d) This is apostolic practice
    ∧ isApostolicPractice (isProperWorshipDay DayOfWorship.firstDay) :=
  ⟨worship_duty_persists,
   seventh_day_not_binding,
   sunday_is_proper_worship_day,
   sunday_worship_is_apostolic⟩

-- ============================================================================
-- § 6. The SDA test: what happens when you reject the ceremonial classification
-- ============================================================================

/-- THEOREM (SDA): Under SDA axioms, the seventh-day specification is binding.
    If the day-specification is moral (not ceremonial), then `moral_precepts_bind`
    applies and Saturday worship remains obligatory.

    This shows the SDA position is INTERNALLY CONSISTENT — it follows
    from different axioms, not from a logical error. The debate is about
    which axiom is true (is the day moral or ceremonial?), not about
    whether the logic works.

    NOTE: The SDA claim `sda_day_is_moral` is taken as a HYPOTHESIS
    (not a declared axiom) because it is a non-Catholic position.
    This matches the pattern used in RuleOfFaith.lean and
    PrivateJudgment.lean for Protestant alternatives.

    Depends on: [hypothesis] sda_day_is_moral, moral_precepts_bind. -/
theorem sda_seventh_day_binding
    (sda_day_is_moral : ceremonialComponent.aspect = CommandmentAspect.moral) :
    isBinding ceremonialComponent :=
  moral_precepts_bind ceremonialComponent sda_day_is_moral

/-- THEOREM: The Catholic and SDA positions are contradictory on the
    binding status of the seventh-day specification. They cannot both be
    right — one must classify the day-specification incorrectly.

    This shows the precise point of disagreement: the CLASSIFICATION
    of the day-specification as moral vs. ceremonial. Everything else
    follows from this single axiom difference.

    The SDA claim is taken as a hypothesis, not a declared axiom,
    because Catlib's axiom base is Catholic. The SDA position is an
    alternative axiom set — modeling it as a hypothesis avoids making
    the module's axiom set inconsistent.

    Depends on: seventh_day_not_binding, [hypothesis] sda_day_is_moral. -/
theorem catholic_sda_contradiction
    (sda_day_is_moral : ceremonialComponent.aspect = CommandmentAspect.moral) :
    False :=
  seventh_day_not_binding (sda_seventh_day_binding sda_day_is_moral)

/-!
**Note on the SDA contradiction.** The fact that `catholic_sda_contradiction`
derives `False` (given the SDA hypothesis) does NOT mean the SDA position is
logically wrong. It means the COMBINED axiom set (Catholic + SDA) is
inconsistent. This is expected: `ceremonialComponent.aspect = .ceremonial`
(by definition) and `sda_day_is_moral` (which says the aspect is `.moral`)
literally contradict each other. The formalization shows that the two
positions cannot be combined — you must choose one classification or the
other.

NOTE: The SDA position is modeled as a HYPOTHESIS (parameter to theorems),
not a declared axiom. This keeps the module's axiom set consistent while
still allowing us to derive consequences of the SDA position.

The real question is: IS the seventh-day specification moral or ceremonial?
- Catholic: ceremonial, because it specifies a particular day tied to the
  Mosaic covenant. The moral core (regular worship) is permanent; the day
  is not.
- SDA: moral, because it is grounded in creation (Gen 2:2–3), before
  Moses. The seventh day is not a Mosaic addition but a creation ordinance.
- The disagreement is about the SCOPE of the moral/ceremonial distinction,
  not about its existence.
-/

-- ============================================================================
-- § 7. Bridge theorems to base axioms
-- ============================================================================

/-- Bridge to S3 (law on hearts): The moral core of the Sabbath commandment
    connects to S3 — God inscribes the moral law in every human heart.
    The duty of regular worship (§2176: "the moral commandment inscribed by
    nature in the human heart") is an instance of the natural law that S3
    describes. -/
theorem s3_natural_law_bridge
    (p : Person) (h_intellect : p.hasIntellect = true) :
    moralLawInscribed p :=
  s3_law_on_hearts p h_intellect

-- ============================================================================
-- § 8. The denominational picture
-- ============================================================================

/-!
### Where traditions agree and disagree

**All Christians agree:**
- The Third Commandment ("Remember the Sabbath day") is part of the
  Decalogue and carries divine authority
- Regular worship of God is a permanent moral obligation
- Christ rose from the dead on the first day of the week (Sunday)

**The disputed question:**
- Does the resurrection authorize a CHANGE in the day of worship?
- Or does the seventh-day specification bind permanently?

**Catholic + Orthodox + most Protestant (accept Sunday worship):**
Three arguments converge:
1. The resurrection reorients sacred time → Sunday = new creation
2. Apostolic practice from the beginning → not a later corruption
3. The ceremonial specification is fulfilled → the day can change
   while the obligation persists

Each argument does different work:
- Fulfillment: the LOGICAL enabler (explains HOW a commandment can change)
- Resurrection: the MATERIAL reason (explains WHY Sunday specifically)
- Apostolic practice: the EVIDENTIAL support (shows WHEN the shift happened)

**Seventh-day Adventist (reject the shift):**
- The seventh-day specification is a creation ordinance (Gen 2:2–3), not
  merely a Mosaic ceremony
- Therefore it is moral (permanent), not ceremonial (fulfillable)
- The shift to Sunday worship was a later corruption (often attributed to
  Constantine, AD 321, or the Council of Laodicea, c. 364)
- The SDA position is internally consistent: if the day-specification is
  moral, then Saturday worship is still obligatory

**The precise point of disagreement:**
Both sides accept the moral/ceremonial distinction in general. They disagree
about whether the day-specification falls on the moral or ceremonial side.
The Catholic argument depends on classifying it as ceremonial; the SDA
argument depends on classifying it as moral. The LOGIC is the same on both
sides — the disagreement is about a single classification axiom.

**Why apostolic practice matters:**
The SDA claim that Sunday worship is a later corruption (4th century) can
be answered only by appeal to apostolic practice (1st century). The
theological arguments (fulfillment, resurrection) explain why Sunday is
fitting; the historical argument (apostolic practice) shows it is original.
Without the historical evidence, the SDA corruption narrative is at least
possible. This is why argument 2 (apostolic practice) is not merely
"evidence" but is genuinely load-bearing: it defeats the corruption
objection.
-/

-- ============================================================================
-- § 9. Summary
-- ============================================================================

/-!
## Summary

**Axioms** (7 — from CCC §2168–2176):
1. `christ_rose_on_first_day` (§2174) — Christ rose on Sunday [Scripture]
2. `resurrection_day_is_new_creation` (§2174) — resurrection day = new creation [Scripture]
3. `sunday_worship_is_apostolic` (§2175) — Sunday worship is apostolic [Scripture + Tradition]
4. `moral_precepts_bind` (§2176) — moral precepts persist [Natural law]
5. `ceremonial_is_fulfilled` (§2175) — ceremonial precepts fulfilled in Christ [Tradition]
6. `fulfilled_not_binding` (§2175) — fulfilled = no longer binding in original form [Tradition]
7. `new_creation_day_is_worship_day` (§2174–2175) — new creation day = worship day [Tradition]
+ 1 denominational hypothesis: `sda_day_is_moral` (SDA position, taken as parameter)

**Theorems** (6 + 1 bridge):
1. `worship_duty_persists` — the duty of regular worship remains binding
2. `seventh_day_not_binding` — the Saturday specification is no longer binding
3. `sunday_is_new_creation` — Sunday signifies new creation
4. `sunday_is_proper_worship_day` — Sunday is the proper day of Christian worship
5. `lords_day_argument` (main) — the full four-part argument
6. `sda_seventh_day_binding` — under SDA axioms, Saturday is still binding
7. `catholic_sda_contradiction` — the two positions are mutually exclusive
8. `s3_natural_law_bridge` — connects worship duty to S3 (natural law)

**Cross-file connections:**
- `Axioms.lean`: `s3_law_on_hearts` (S3), `moralLawInscribed`, `Person`
- Uses foundation types: `Person`, `Provenance`, `DenominationalTag`

**Key finding:** All three arguments (fulfillment, resurrection, apostolic
practice) are GENUINELY LOAD-BEARING but for DIFFERENT things:
- Fulfillment does the **logical** work (enables change)
- Resurrection does the **material** work (specifies Sunday)
- Apostolic practice does the **evidential** work (defeats the corruption
  objection)

The debate with SDA reduces to a SINGLE CLASSIFICATION AXIOM: is the
seventh-day specification moral or ceremonial? The Catholic position
classifies it as ceremonial (tied to Mosaic covenant); the SDA position
classifies it as moral (tied to creation). Both positions are internally
consistent. The logic is identical on both sides — only the classification
differs.

**Hidden assumptions:**
1. Commandments have a two-layer structure (moral core + ceremonial
   specification) — Thomistic classification, not self-evident
2. Christ's resurrection has cosmic-liturgical significance — reorients
   sacred time, not just individual salvation
3. Apostolic practice is normative — what the apostles did, Christians
   should do (a Tradition principle)
-/

end Catlib.MoralTheology.LordsDay
