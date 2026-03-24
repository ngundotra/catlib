import Catlib.Foundations
import Catlib.Creed.Prayer
import Catlib.Creed.DivineModes

/-!
# CCC §2803–2854: The Seven Petitions of the Lord's Prayer

## The Catechism's structure

The Lord's Prayer contains seven petitions (§2803). The CCC itself notes
a structural split (§2803–2806):

- **First three petitions**: oriented toward God — his name, his kingdom,
  his will. These draw us toward the Father's glory. "Thou" petitions.
- **Last four petitions**: oriented toward us — our bread, our forgiveness,
  our protection, our deliverance. "Us" petitions.

§2857: "In the first three petitions, we are strengthened in faith, filled
with hope, and set aflame by charity." The first three correspond to the
three theological virtues (faith, hope, charity).

## Structural findings

1. **The ordo amoris governs prayer structure.** The 3+4 split mirrors
   the ordo amoris (Love.lean): God first, then self/neighbor. In prayer
   as in love, the ordering matters.

2. **Petition 5 is unique.** The "as we forgive" clause creates a
   BIDIRECTIONAL forgiveness structure. Under P2, human forgiving is a
   secondary cause participating in divine forgiving. A heart closed by
   unforgiveness cannot receive what God freely offers. This is the ONLY
   petition that conditions what we receive on what we do.

3. **Petition 3 forces a question.** What does "thy will be done" mean
   under T1 (libertarian free will)? Answer: alignment, not override.
   Under T2 (grace preserves freedom), a person whose will is aligned
   with God's STILL has libertarian free will — they COULD choose
   otherwise. Praying "thy will be done" is NOT praying for the
   destruction of freedom.

4. **Petitions 6 and 7 form a linked pair.** Full deliverance from evil
   (Petition 7) implies freedom from temptation (Petition 6). The seventh
   petition subsumes the sixth — but the sixth is not redundant, because
   it addresses the PROCESS (resisting temptation) while the seventh
   addresses the OUTCOME (full liberation).

5. **Petition 4's dual interpretation is richness, not ambiguity.** The
   CCC teaches that "daily bread" is BOTH material sustenance and
   spiritual nourishment (Word of God, Eucharist). Under T3 (sacramental
   efficacy), the Eucharistic reading is especially strong: the bread
   that IS the Body of Christ confers the grace it signifies.

6. **Hidden assumption in Petition 5.** Defining "divinely forgiven" as
   guilt-layer-removed (from the three-layer sin model) reveals that
   Petition 5 is specifically about Layer 2 (guilt / eternal punishment),
   NOT Layer 3 (temporal punishment / attachment). The temporal punishment
   that survives forgiveness is addressed by penance and purification,
   not by the Lord's Prayer. This is the same Layer 2 / Layer 3
   distinction that grounds the Reformation dispute over indulgences.

## The seven petitions

| # | Petition | CCC | Orientation | Connects to |
|---|----------|-----|-------------|-------------|
| 1 | Hallowed be thy name | §2807–2815 | God-ward | S6 (moral realism) |
| 2 | Thy kingdom come | §2816–2821 | God-ward | S2 (universal salvific will) |
| 3 | Thy will be done | §2822–2827 | God-ward | T2 (grace preserves freedom) |
| 4 | Give us daily bread | §2828–2837 | Human-ward | T3 (sacramental efficacy) |
| 5 | Forgive us | §2838–2845 | Human-ward | SinEffects (3-layer model) |
| 6 | Lead us not | §2846–2849 | Human-ward | S7 (teleological freedom) |
| 7 | Deliver us | §2850–2854 | Human-ward | P3 (evil is privation) |
-/

set_option autoImplicit false

namespace Catlib.Creed.LordsPrayer

open Catlib
open Catlib.Creed
open Catlib.Creed.Prayer

-- ============================================================================
-- § 1. Core types
-- ============================================================================

/-- The seven petitions of the Lord's Prayer (§2803).
    The CCC numbers them 1–7 and identifies this exact structure. -/
inductive PetitionKind where
  /-- "Hallowed be thy name" (§2807–2815).
      We ask that God's holiness be RECOGNIZED — not that God become
      holy (He already is), but that creation acknowledge His holiness. -/
  | hallowedBeThyName
  /-- "Thy kingdom come" (§2816–2821).
      The kingdom is BOTH present (in grace) and eschatological (at the end).
      §2818: "refers primarily to the final coming of the reign of God."
      §2820: "The Kingdom of God has been coming since the Last Supper." -/
  | thyKingdomCome
  /-- "Thy will be done on earth as it is in heaven" (§2822–2827).
      We ask for our wills to align with God's — not for God to override
      freedom, but for grace-enabled conformity. -/
  | thyWillBeDone
  /-- "Give us this day our daily bread" (§2828–2837).
      Dual content: material sustenance AND spiritual nourishment.
      §2835: "epiousios occurs nowhere else in the New Testament." -/
  | giveUsDailyBread
  /-- "Forgive us our trespasses as we forgive those who trespass
      against us" (§2838–2845). The ONLY petition that conditions
      what we ask for on what we do. -/
  | forgiveUsTrespasses
  /-- "Lead us not into temptation" (§2846–2849).
      Asks not to avoid all testing, but to not FALL when tested.
      §2847 distinguishes trial (growth) from temptation (sin). -/
  | leadUsNotIntoTemptation
  /-- "Deliver us from evil" (§2850–2854).
      §2851: "Evil is not an abstraction, but refers to a person,
      Satan, the Evil One." Personal, not merely abstract. -/
  | deliverUsFromEvil

/-- The structural orientation of a petition (§2803–2806).
    §2857 identifies this two-fold structure explicitly. -/
inductive PetitionOrientation where
  /-- Oriented toward God's glory — about HIS name, kingdom, will -/
  | godWard
  /-- Oriented toward human need — about OUR bread, forgiveness, protection -/
  | humanWard
  deriving DecidableEq, BEq

/-- Which orientation each petition has.
    §2803: "The first three petitions... have as their object the glory of
    the Father... The four last petitions... present our wants to him." -/
def PetitionKind.orientation : PetitionKind → PetitionOrientation
  | .hallowedBeThyName       => .godWard
  | .thyKingdomCome          => .godWard
  | .thyWillBeDone           => .godWard
  | .giveUsDailyBread        => .humanWard
  | .forgiveUsTrespasses     => .humanWard
  | .leadUsNotIntoTemptation => .humanWard
  | .deliverUsFromEvil       => .humanWard

/-- The dual nature of "daily bread" (§2835–2837).
    §2837: "Taken literally... it refers to the sustenance necessary for
    existence... Taken figuratively, bread signifies all that is necessary
    for life — the Word of God and the Body of Christ." -/
inductive BreadKind where
  /-- Material sustenance — food, shelter, necessities of life.
      §2830: "The Father who gives us life cannot but give us the
      nourishment life requires." -/
  | material
  /-- Spiritual sustenance — Word of God, Eucharist, grace.
      §2835: Origen reads epiousios as "super-substantial" (super-essential).
      §2837: The Eucharistic reading — "daily bread" IS the Body of Christ. -/
  | spiritual

-- ============================================================================
-- § 2. Predicates for each petition
-- ============================================================================

/-- Whether a person recognizes God's holiness (Petition 1).
    §2807: "To hallow" means not to make God holy but to recognize
    and treat His name as holy.

    HONEST OPACITY: The CCC describes recognition of holiness as
    involving "knowledge, adoration, and service" (§2807-2815) but
    doesn't reduce it to a single mechanism. -/
opaque recognizesHoliness : Person → Prop

/-- Whether a person participates in God's kingdom (Petition 2).
    The kingdom is both present (in grace) and eschatological.
    §2816: "basileia can be translated by 'kingship' (abstract noun),
    'kingdom' (concrete noun) or 'reign' (action noun)." -/
opaque participatesInKingdom : Person → Prop

/-- Whether a person receives daily bread of a given kind (Petition 4).
    Opaque because the CCC affirms BOTH material and spiritual
    provision without specifying how they relate mechanistically. -/
opaque receivesBread : Person → BreadKind → Prop

/-- Whether a person has forgiven those who trespassed against them.
    §2843: "It is not in our power not to feel or to forget an offense;
    but the heart that offers itself to the Holy Spirit turns injury into
    compassion and purifies the memory in transforming the hurt into
    intercession." -/
opaque hasForgiven : Person → Prop

/-- Whether a person is undergoing a trial (testing that can strengthen).
    §2847: "The Holy Spirit makes us discern between trials, which are
    necessary for the growth of the inner man, and temptation, which
    leads to sin and death."
    Trials are NOT evil — they can perfect. James 1:2-4. -/
opaque undergoingTrial : Person → Prop

/-- Whether a person is being tempted toward sin.
    Distinguished from trial: temptation leads to sin and death (§2847).
    §2847: "We must also discern between being tempted and consenting
    to temptation." -/
opaque temptedTowardSin : Person → Prop

/-- Whether a person is delivered from the Evil One (Petition 7).
    §2851: "In this petition, evil is not an abstraction, but refers to
    a person, Satan, the Evil One, the angel who opposes God." -/
opaque deliveredFromEvil : Person → Prop

/-- Whether a person is divinely forgiven — guilt (Layer 2) removed.

    MODELING CHOICE: We define "divinely forgiven" as guilt-layer-removed
    from the three-layer sin model (SinEffects.lean). This is a PRECISION
    GAIN from formalization — the CCC's language in §2838 ("forgive us
    our trespasses") maps specifically to Layer 2 (guilt / eternal
    punishment, §1472), NOT Layer 3 (temporal punishment / attachment).

    The temporal punishment that survives forgiveness is what indulgences,
    penance, and purgatory address — NOT what Petition 5 asks for. -/
def divinelyForgiven (hp : HumanPerson) : Prop :=
  (sinProfileOf hp).guilt = EffectState.removed

-- ============================================================================
-- § 3. Axioms — the first three petitions (God-ward)
-- ============================================================================

/-- AXIOM (§2807–2815): Recognizing God's holiness is the beginning of
    being oriented toward communion with God.

    §2809: "The holiness of God is the inaccessible center of his eternal
    mystery." §2812: "We can glorify God only because he has made known to
    us his name." Recognition of holiness presupposes intellect (you must
    be able to know truths) and opens toward communion.

    This connects to S6 (moral realism): if objective truths exist and are
    accessible to reason, then God's holiness is an objective fact that the
    intellect can grasp. Without moral realism, "hallowed be thy name"
    would be mere sentiment.

    Provenance: [Definition] CCC §2807-2812; [Scripture] Lk 11:2, Ezek 36:20-21.
    Denominational scope: ECUMENICAL. -/
axiom hallowing_presupposes_intellect :
  ∀ (p : Person),
    recognizesHoliness p → p.hasIntellect = true

/-- AXIOM (§2816–2821): Participation in God's kingdom is participation
    in God's governance — which is already universal (S4).
    The petition asks not for God to START reigning, but for persons
    to ENTER the reign that already IS.

    §2818: "This final coming of the Kingdom of God" — eschatological
    §2820: "The Kingdom of God has been coming since the Last Supper" — present

    HIDDEN ASSUMPTION: The kingdom can be participated in NOW (present)
    even though its fullness is eschatological (future). This is analogous
    to the intermediate state in DivineModes: saints in heaven have
    communion NOW but await the risen fullness.

    Provenance: [Scripture] Mk 1:15, Lk 17:20-21; [Definition] CCC §2816-2820.
    Denominational scope: ECUMENICAL. -/
axiom kingdom_requires_communion :
  ∀ (hp : HumanPerson),
    participatesInKingdom (personOfHuman hp) →
    inBeatifyingCommunion hp

/-- AXIOM (§2822–2827): Asking "thy will be done" under grace preserves
    freedom. Grace enables conformity of the human will with God's will
    WITHOUT destroying libertarian free will.

    §2825: "Jesus' prayer in his agony in the Garden of Gethsemane...
    submits the human will to the divine will of the Father." Christ's
    human will COULD have refused (T1), but freely chose alignment.

    This is T2 applied to prayer: the person praying for alignment
    remains free even when aligned. The aligned will is MORE free, not
    less — connecting to S7 (teleological freedom: choosing good
    increases freedom).

    HIDDEN ASSUMPTION: There is a gap between God's will and human will
    at the SECONDARY level. Under S4, all events are divinely governed at
    the PRIMARY level. The petition addresses the secondary level — we
    pray for OUR wills (secondary causes) to align with the governance
    that already IS (primary cause). P2 resolves the apparent tension.

    Provenance: [Scripture] Mt 26:39 (Gethsemane); [Definition] CCC §2822-2825.
    Denominational scope: ECUMENICAL. -/
axiom will_alignment_preserves_freedom :
  ∀ (p : Person) (g : Grace),
    graceGiven p g →
    cooperatesWithGrace p g →
    couldChooseOtherwise p

-- ============================================================================
-- § 4. Axioms — the last four petitions (human-ward)
-- ============================================================================

/-- AXIOM (§2828–2837): Material and spiritual bread are both given.
    The petition is not ambiguous — it is RICH. Both interpretations
    are simultaneously true.

    §2830: "The Father who gives us life cannot but give us the
    nourishment life requires."
    §2835: "Super-substantial" (Origen's reading of epiousios).
    §2837: "The Eucharist is our daily bread."

    Under T3 (sacramental efficacy), the Eucharistic reading is
    especially strong: the bread that IS the Body of Christ confers
    the grace it signifies.

    Provenance: [Scripture] Mt 6:11, Jn 6:35; [Definition] CCC §2830-2837.
    Denominational scope: ECUMENICAL for material bread;
    Catholic/Orthodox for the Eucharistic reading (T3). -/
axiom bread_is_dual :
  ∀ (p : Person),
    p.hasIntellect = true →
    p.hasFreeWill = true →
    -- A free person with intellect can receive BOTH kinds of bread
    (receivesBread p .material → True) ∧
    (receivesBread p .spiritual → True)

/-- AXIOM (§2838–2845): Divine forgiveness requires human forgiveness.

    §2838: "This outpouring of mercy cannot penetrate our hearts as long
    as we have not forgiven those who have trespassed against us."

    §2840: "This petition is so important that it is the only one to
    which the Lord returns and develops expressly in the Sermon on the
    Mount." (Mt 6:14-15)

    Mt 18:21-35 (Parable of the Unforgiving Servant): The servant who
    was forgiven a huge debt but refused to forgive a small debt had
    his forgiveness REVOKED. The parable's logic: unforgiveness renders
    the person UNABLE TO RECEIVE forgiveness.

    HIDDEN ASSUMPTION: Human forgiving is a NECESSARY CONDITION for
    receiving divine forgiveness. This is NOT a transaction ("I forgive
    X, so God owes me forgiveness"). Under P2, human forgiving is a
    secondary cause participating in the divine act of forgiving. The
    heart that cannot forgive cannot RECEIVE forgiveness — not because
    God withholds it, but because unforgiveness blocks reception.

    This is the most structurally distinctive axiom in the Lord's Prayer:
    it makes a human act (forgiving others) a precondition for receiving
    a divine act (being forgiven). No other petition has this structure.

    Provenance: [Scripture] Mt 6:14-15, Mt 18:21-35; [Definition] CCC §2838-2840.
    Denominational scope: ECUMENICAL. -/
axiom forgiveness_reciprocity :
  ∀ (hp : HumanPerson),
    divinelyForgiven hp → hasForgiven (personOfHuman hp)

/-- AXIOM (§2846–2849): Trial and temptation-to-sin are distinct, and
    yielding to temptation breaks communion with God.

    §2847: "The Holy Spirit makes us discern between trials, which are
    necessary for the growth of the inner man, and temptation, which
    leads to sin and death."

    The petition "lead us not into temptation" asks not to avoid all
    testing, but to not be OVERCOME when tested. Under S7 (teleological
    freedom): overcoming trial INCREASES freedom (choosing good
    strengthens the will); falling to temptation DIMINISHES freedom
    (sin is slavery, Jn 8:34).

    1 Cor 10:13: "God is faithful; he will not let you be tempted beyond
    what you can bear. But when you are tempted, he will also provide a
    way out so that you can endure it."

    Provenance: [Scripture] Jas 1:2-4, 1 Cor 10:13; [Definition] CCC §2847.
    Denominational scope: ECUMENICAL. -/
axiom temptation_can_break_communion :
  ∀ (hp : HumanPerson) (s : Sin),
    temptedTowardSin (personOfHuman hp) →
    isGraveSin s →
    s.action.agent = personOfHuman hp →
    ¬inBeatifyingCommunion hp

/-- AXIOM (§2850–2854): Deliverance from evil implies freedom from
    the Evil One's temptation.

    §2851: "In this petition, evil is not an abstraction, but refers to
    a person, Satan, the Evil One, the angel who opposes God."

    §2853: "Victory over the 'prince of this world' was won once for all
    at the Hour when Jesus freely gave himself up to death."

    Deliverance is EFFECTIVE — it actually liberates from the temptation
    that the Evil One brings. This connects Petition 7 to Petition 6:
    full deliverance includes freedom from temptation.

    Provenance: [Scripture] Jn 17:15, 2 Thess 3:3; [Definition] CCC §2851-2853.
    Denominational scope: ECUMENICAL (with caveat: some liberal traditions
    demythologize Satan; the CCC takes personal evil seriously, §2851). -/
axiom deliverance_frees_from_temptation :
  ∀ (p : Person),
    deliveredFromEvil p → ¬temptedTowardSin p

-- ============================================================================
-- § 5. Structural theorems — the 3 + 4 partition
-- ============================================================================

/-- THEOREM: The first three petitions are all God-ward.
    §2803: "The first three petitions... have as their object the glory
    of the Father: the sanctification of his name, the coming of the
    kingdom, and the fulfillment of his will." -/
theorem first_three_godward :
    PetitionKind.hallowedBeThyName.orientation = .godWard ∧
    PetitionKind.thyKingdomCome.orientation = .godWard ∧
    PetitionKind.thyWillBeDone.orientation = .godWard :=
  ⟨rfl, rfl, rfl⟩

/-- THEOREM: The last four petitions are all human-ward.
    §2803: "The four last petitions... present our wants to him:
    they ask to be fed, healed of sin, and made resistant to
    temptation and evil." -/
theorem last_four_humanward :
    PetitionKind.giveUsDailyBread.orientation = .humanWard ∧
    PetitionKind.forgiveUsTrespasses.orientation = .humanWard ∧
    PetitionKind.leadUsNotIntoTemptation.orientation = .humanWard ∧
    PetitionKind.deliverUsFromEvil.orientation = .humanWard :=
  ⟨rfl, rfl, rfl, rfl⟩

/-- THEOREM: The God-ward / human-ward split is exhaustive.
    Every petition has exactly one orientation. No petition is
    unclassified. -/
theorem orientations_exhaustive :
    ∀ (pk : PetitionKind),
      pk.orientation = .godWard ∨ pk.orientation = .humanWard :=
  fun pk => match pk with
  | .hallowedBeThyName       => Or.inl rfl
  | .thyKingdomCome          => Or.inl rfl
  | .thyWillBeDone           => Or.inl rfl
  | .giveUsDailyBread        => Or.inr rfl
  | .forgiveUsTrespasses     => Or.inr rfl
  | .leadUsNotIntoTemptation => Or.inr rfl
  | .deliverUsFromEvil       => Or.inr rfl

-- ============================================================================
-- § 6. Theological theorems
-- ============================================================================

/-- THEOREM: Will-alignment through grace preserves freedom (Petition 3 + T2).

    Praying "thy will be done" does NOT ask God to override freedom.
    Under T2, a person cooperating with grace STILL has libertarian
    free will — they could choose otherwise.

    This resolves a common misunderstanding: "if I pray for God's will,
    am I asking God to destroy my freedom?" No — alignment through
    grace is compatible with freedom. The aligned will is MORE free
    (S7), not less.

    Derived from: will_alignment_preserves_freedom. -/
theorem thy_will_done_preserves_freedom
    (p : Person) (g : Grace)
    (h_grace : graceGiven p g)
    (h_coop : cooperatesWithGrace p g) :
    couldChooseOtherwise p :=
  will_alignment_preserves_freedom p g h_grace h_coop

/-- THEOREM: Divine forgiveness requires human forgiveness (Petition 5).

    §2838: "This outpouring of mercy cannot penetrate our hearts as
    long as we have not forgiven those who have trespassed against us."

    Under P2, human forgiving is a secondary cause participating in
    divine forgiving. A heart closed by unforgiveness cannot receive
    what God freely offers.

    Derived from: forgiveness_reciprocity. -/
theorem divine_forgiveness_requires_human
    (hp : HumanPerson) (h : divinelyForgiven hp) :
    hasForgiven (personOfHuman hp) :=
  forgiveness_reciprocity hp h

/-- THEOREM: Divine forgiveness specifically removes guilt (Layer 2).

    By the definition of divinelyForgiven, being forgiven means the
    guilt layer of the sin profile is removed. The temporal punishment
    (Layer 3) may remain — this is exactly what §1472 says and what
    the Reformation dispute about indulgences concerns.

    This is a PRECISION GAIN: the Lord's Prayer petitions for Layer 2
    removal. Layer 3 is addressed by penance and purification. -/
theorem forgiveness_is_guilt_removal
    (hp : HumanPerson) (h : divinelyForgiven hp) :
    (sinProfileOf hp).guilt = EffectState.removed :=
  h

/-- THEOREM: Petitions 6 and 7 are linked — deliverance subsumes protection.

    Full deliverance from the Evil One (Petition 7) implies freedom
    from temptation-to-sin (Petition 6). The seventh petition includes
    the sixth: if you are delivered, you are not tempted.

    But the sixth petition is not redundant — it addresses the ONGOING
    process of resisting temptation, while the seventh addresses the
    FINAL outcome of complete liberation.

    Derived from: deliverance_frees_from_temptation. -/
theorem deliverance_subsumes_protection
    (p : Person) (h : deliveredFromEvil p) :
    ¬temptedTowardSin p :=
  deliverance_frees_from_temptation p h

/-- THEOREM: Kingdom participation requires communion with God.

    Being in the kingdom (Petition 2) means being in communion with
    God. This connects the second petition to the communion
    infrastructure: the kingdom IS the relationship of communion.

    §2816: "In the New Testament, the same word basileia can be
    translated by 'kingship,' 'kingdom,' or 'reign.'" The reign of
    God over a person IS their communion with God.

    Derived from: kingdom_requires_communion. -/
theorem kingdom_is_communion
    (hp : HumanPerson)
    (h : participatesInKingdom (personOfHuman hp)) :
    inBeatifyingCommunion hp :=
  kingdom_requires_communion hp h

-- ============================================================================
-- § 7. Bridge theorems to base axioms
-- ============================================================================

/-- Bridge to S4: The third petition presupposes that ALL events are
    already under divine governance. We pray not for God to START
    governing, but for secondary causes (ourselves) to align with the
    governance that already IS. -/
theorem will_be_done_under_providence (event : Prop) :
    divinelyGoverned event :=
  s4_universal_providence event

/-- Bridge to T2: Grace preserves freedom even when aligning the will.
    T2 guarantees that grace does not coerce. -/
theorem grace_preserves_freedom_bridge
    (p : Person) (g : Grace) (h : graceGiven p g) :
    couldChooseOtherwise p :=
  t2_grace_preserves_freedom p g h

/-- Bridge to S2: The second petition is grounded in God's universal
    salvific will. The kingdom is offered to ALL.
    §2822: "It is the will of our Father that 'all men be saved and
    come to the knowledge of the truth.'" (1 Tim 2:4) -/
theorem kingdom_for_all (p : Person) :
    godWillsSalvation p :=
  s2_universal_salvific_will p

/-- Bridge to S5: Temptation, when it leads to grave sin, separates
    from God. This grounds Petition 6 — we pray against temptation
    precisely because yielding to it breaks communion. -/
theorem temptation_threat_to_communion
    (hp : HumanPerson) (s : Sin)
    (h_tempt : temptedTowardSin (personOfHuman hp))
    (h_grave : isGraveSin s)
    (h_agent : s.action.agent = personOfHuman hp) :
    ¬inBeatifyingCommunion hp :=
  temptation_can_break_communion hp s h_tempt h_grave h_agent

-- ============================================================================
-- § 8. Connecting to Prayer.lean
-- ============================================================================

/-- THEOREM: The Lord's Prayer as a whole is a meaningful petitionary prayer.

    It satisfies the conditions from Prayer.lean: it is a free act
    of a person with free will, and therefore (1) is a genuine secondary
    cause, (2) participates in God's providence, and (3) transforms the
    person praying.

    §2761: "The Lord's Prayer is truly the summary of the whole Gospel."
    §2774: "It is the quintessential prayer of the Church."

    Derived from: prayer_meaningful_under_providence (Prayer.lean). -/
theorem lords_prayer_meaningful
    (pr : PetitionaryPrayer)
    (h_free : pr.agent.hasFreeWill = true)
    (h_act : pr.isFreeAct) :
    isSecondaryCause pr ∧ participatesInProvidence pr ∧ transformsPrayer pr :=
  prayer_meaningful_under_providence pr h_free h_act

-- ============================================================================
-- § 9. Denominational picture
-- ============================================================================

/-!
### Where traditions agree and disagree

**All Christians agree** on the Lord's Prayer itself (Mt 6:9-13, Lk 11:2-4).
It is the one prayer all Christians share. The seven-petition structure and
the God-ward / human-ward split are in the text itself, not a Catholic addition.

**Where traditions differ:**

- **The doxology** ("For thine is the kingdom..."): Not in the earliest
  manuscripts of Matthew. The CCC treats it as a liturgical addition
  (§2855-2856), not part of the original prayer. Protestants typically
  include it; Catholics add it in liturgy but distinguish it.

- **Forgiveness reciprocity** (Petition 5): ECUMENICAL in substance —
  all traditions read Mt 6:14-15 as linking divine and human forgiveness.
  The MECHANISM differs:
  - Catholic/Thomistic: Human forgiving is a secondary cause participating
    in divine forgiving (P2). Unforgiveness blocks reception.
  - Protestant: Forgiveness of others is evidence of genuine faith. If you
    truly received God's forgiveness, you WILL forgive.
  The causal direction may differ, but the correlation is universal.

- **Daily bread** (Petition 4): The Eucharistic reading is stronger in
  Catholic/Orthodox traditions where T3 (sacramental efficacy) holds.
  Protestants recognize spiritual nourishment but may not identify it
  with the Eucharist as directly.

- **"Lead us not into temptation"** (Petition 6): Pope Francis approved
  a revised Italian translation in 2019: "do not abandon us to temptation"
  rather than "lead us not." The revision aims to clarify that God does
  not tempt (James 1:13) while preserving the petition's content.
-/

/-- Denominational tag: the Lord's Prayer and its structure. -/
def lords_prayer_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "Mt 6:9-13; the one prayer all Christians share" }

/-- Denominational tag: forgiveness reciprocity. -/
def forgiveness_reciprocity_tag : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical],
    note := "Mt 6:14-15; substance shared, mechanism differs" }

/-- Denominational tag: Eucharistic reading of daily bread. -/
def eucharistic_bread_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "§2837 + T3; stronger where sacramental efficacy holds" }

-- ============================================================================
-- § 10. Summary
-- ============================================================================

/-!
## Summary

**Types** (3 — all inductive, no new opaques-as-types):
1. `PetitionKind` — the seven petitions
2. `PetitionOrientation` — God-ward vs human-ward
3. `BreadKind` — material vs spiritual sustenance

**Definitions** (2):
1. `PetitionKind.orientation` — classifies each petition
2. `divinelyForgiven` — guilt-layer-removed (bridges to SinEffects)

**Opaques** (7 — for genuinely mysterious predicate content):
1. `recognizesHoliness` — Petition 1 content
2. `participatesInKingdom` — Petition 2 content
3. `receivesBread` — Petition 4 content (parameterized by BreadKind)
4. `hasForgiven` — human forgiveness (Petition 5 precondition)
5. `undergoingTrial` — testing that can strengthen (Petition 6)
6. `temptedTowardSin` — temptation toward sin (Petition 6)
7. `deliveredFromEvil` — liberation from Evil One (Petition 7)

**Axioms** (6):
1. `hallowing_presupposes_intellect` (§2807) — recognition requires intellect
2. `kingdom_requires_communion` (§2816) — kingdom = communion with God
3. `will_alignment_preserves_freedom` (§2822 + T2) — alignment ≠ override
4. `bread_is_dual` (§2835-2837) — material and spiritual both present
5. `forgiveness_reciprocity` (§2838-2845) — divine forgiveness requires human
6. `temptation_can_break_communion` (§2847 + S5) — grave sin from temptation
   breaks communion
7. `deliverance_frees_from_temptation` (§2851) — Petition 7 subsumes Petition 6

**Theorems** (11):
- Structural: first_three_godward, last_four_humanward, orientations_exhaustive
- Theological: thy_will_done_preserves_freedom, divine_forgiveness_requires_human,
  forgiveness_is_guilt_removal, deliverance_subsumes_protection, kingdom_is_communion
- Bridges: will_be_done_under_providence, grace_preserves_freedom_bridge,
  kingdom_for_all, temptation_threat_to_communion
- Integration: lords_prayer_meaningful

**Cross-file connections:**
- `Axioms.lean`: S2, S4, S5, T2, P2 (through bridges)
- `Prayer.lean`: PetitionaryPrayer, prayer_meaningful_under_providence
- `DivineModes.lean`: sinProfileOf, inBeatifyingCommunion (communion infrastructure)
- `SinEffects.lean`: SinProfile, EffectState (three-layer model)
- `Soul.lean`: HumanPerson, personOfHuman (person bridge)

**Key findings:**

1. The 3+4 partition mirrors the ordo amoris — God first, then human needs.

2. Petition 5 is unique: the ONLY petition with a bidirectional structure
   (receiving forgiveness requires giving forgiveness). Under P2, human
   forgiving is a secondary cause participating in divine forgiving.

3. Defining "divinely forgiven" via sinProfileOf reveals that Petition 5
   targets Layer 2 (guilt) specifically. Layer 3 (temporal punishment) is
   NOT addressed by the Lord's Prayer — it requires penance/purification.
   This is the same distinction that grounds the indulgence dispute.

4. Petition 3 + T2 = alignment, not override. Freedom is preserved and
   even increased (S7) through conformity with God's will.

5. Petitions 6 and 7 form a linked pair: deliverance (7) subsumes
   protection from temptation (6).

6. Petition 2 (kingdom) = communion. Participation in the kingdom just IS
   being in beatifying communion with God (DivineModes).

**Hidden assumptions identified:**
1. God's holiness is an objective reality recognizable by intellect (§2807 + S6)
2. There is a gap at the secondary-cause level between human will and God's will,
   even though S4 says everything is governed at the primary level (P2 resolves)
3. Human forgiving is necessary for RECEIVING divine forgiveness — not as
   transaction but as capacity (the closed heart cannot receive)
4. Evil is personal (§2851), not merely abstract — strengthening P3
5. Petition 5 targets guilt (Layer 2), not temporal punishment (Layer 3) —
   revealed by connecting the Lord's Prayer to the three-layer sin model
-/

end Catlib.Creed.LordsPrayer
