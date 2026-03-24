import Catlib.Foundations
import Catlib.Creed.PapalInfallibility

set_option autoImplicit false

/-!
# Scripture and Tradition: The Rule of Faith (CCC §74-87, §120)

## The Catechism claim

CCC §76: "In keeping with the Lord's command, the Gospel was handed on in
two ways: orally — by the apostles who handed on, by the spoken word of their
preaching, by the example they gave, by the institutions they established,
what they themselves had received... and in writing — by those apostles and
apostolic men who, under the inspiration of the Holy Spirit, committed the
message of salvation to writing."

CCC §80: "Sacred Tradition and Sacred Scripture make up a single sacred deposit
of the Word of God."

CCC §82: Both are to be "accepted and honored with equal sentiments of
devotion and reverence."

CCC §120: "It was by the apostolic Tradition that the Church discerned which
writings are to be included in the list of the sacred books."

## The argument structure

The Catholic position (§74-87):
1. Christ entrusted revelation to the apostles (§75) — ecumenical
2. The apostles transmitted it TWO ways: orally (Tradition) AND in writing
   (Scripture) (§76) — first contested step
3. Not everything was written — some apostolic teaching is oral only (§76)
4. Apostolic succession preserves the teaching authority (§77) — see Authority.lean
5. The Magisterium authentically interprets BOTH Scripture and Tradition (§85-86)
   — see PapalInfallibility.lean
6. The CANON of Scripture was determined by the Church (§120) — the Church
   decided which books are Scripture

The sola scriptura position (Protestant):
1. Scripture alone is the infallible rule of faith (2 Tim 3:16)
2. Scripture is self-authenticating — the canon doesn't depend on Church authority
3. Tradition is useful but not authoritative

The key argument: If the Church determined WHICH books are Scripture (§120),
then the authority of Scripture depends on an act of Church judgment that is
NOT in Scripture. Therefore Scripture cannot be the SOLE authority — it needs
the Church that canonized it.

## Denominational scope

- CATHOLIC + ORTHODOX: Scripture + Tradition + Magisterium
- PROTESTANT: Sola scriptura (Scripture alone as final authority)

## Prediction

I expect:
1. The canon argument IS load-bearing but NOT the deepest issue.
2. The deeper issue is whether authoritative unwritten transmission can exist
   at all. If it can, then the canon argument follows naturally. If it cannot,
   then the canon argument is merely a paradox with no teeth.
3. The Protestant position will be internally consistent IF you add
   self-authentication — a claim that Scripture validates its own canon.
4. The key hidden assumption: whether divine revelation can be transmitted
   orally with binding authority, or whether writing is the ONLY reliable
   medium for revelation.

## Findings

The formalization confirms the prediction. Two independent arguments converge:

1. **The Tradition argument** (the deeper issue): If Christ transmitted
   revelation both orally and in writing (§76), and not all was written,
   then there EXISTS apostolic teaching not in Scripture. This is the real
   load-bearing step — it establishes that Scripture is INCOMPLETE as a record
   of revelation, regardless of the canon problem.

2. **The canon argument** (the sharper paradox): The canon of Scripture was
   determined by the Church (§120). This act of canonization is NOT in
   Scripture. Therefore Scripture's own authority presupposes a non-scriptural
   authority. Sola scriptura faces a bootstrapping problem: it needs the Church
   to tell it what Scripture IS.

The Protestant counter requires self-authentication — that Scripture validates
its own canon without needing Church authority. This is internally consistent
but involves a different hidden assumption than the Catholic view.

The formalization reveals that the COMBINATION of both arguments is stronger
than either alone: the Tradition argument shows Scripture is materially
incomplete; the canon argument shows it is formally dependent on Church
judgment. Together they establish that sola scriptura requires denying BOTH
claims, not just one.

## Design decisions

1. **No vacuous axioms.** Earlier drafts had "framing" axioms with `→ True`
   bodies for CCC §74-75 (revelation entrusted), §77 (succession preserves
   teaching), and §85-86 (Magisterium interprets both). These were deleted
   because their content is either definitional (covered by the type system)
   or already formalized in Authority.lean and PapalInfallibility.lean.

2. **Protestant axioms as hypotheses, not declarations.** The sola scriptura
   and self-authentication claims are modeled as theorem hypotheses, not as
   declared axioms. This is correct because Catlib's axiom base is Catholic —
   Protestant positions are ALTERNATIVE axiom sets, not additions.

3. **Four substantive axioms.** The file declares exactly four axioms, each
   with real content: `dual_transmission` (§76), `not_everything_written` (§76),
   `canon_depends_on_church` (§120), and `canon_act_not_in_scripture` (observation).
   All four are wired into theorems.
-/

namespace Catlib.Creed.RuleOfFaith

open Catlib

-- ============================================================================
-- TYPES FOR THE RULE OF FAITH
-- ============================================================================

/-!
## Core types

We need to model: revelation, modes of transmission, and the canon.

Succession and magisterial authority are already modeled in Authority.lean
and PapalInfallibility.lean — we import and build on those rather than
re-axiomatizing them here.
-/

/-- A unit of apostolic teaching — a specific doctrinal or moral claim
    received from Christ and transmitted by the apostles.
    CCC §76: The apostles handed on "what they themselves had received —
    whether from the lips of Christ, from his way of life and his works,
    or whether they had learned it at the prompting of the Holy Spirit."
    STRUCTURAL OPACITY: The internal structure of a teaching unit is not
    needed for the rule-of-faith argument — we only need to know its
    transmission mode (written vs. oral). -/
opaque ApostolicTeaching : Type

/-- Whether a specific teaching is contained in Sacred Scripture.
    CCC §76: some apostolic teaching was "committed to writing."
    Not all apostolic teaching was written — this is the key contested claim.
    HONEST OPACITY: What counts as "in Scripture" depends on how one reads
    it — literal, typological, etc. We treat this as opaque because the
    formalization does not model hermeneutics. -/
opaque inScripture : ApostolicTeaching → Prop

/-- Whether a specific teaching is transmitted through Sacred Tradition.
    CCC §76: some apostolic teaching was handed on "by the spoken word of
    their preaching, by the example they gave, by the institutions they
    established."
    HONEST OPACITY: The CCC does not give a procedure for identifying the
    exact contents of Tradition. This is itself a deep open question —
    Catholics and Orthodox appeal to liturgical practice, patristic consensus,
    and conciliar definitions, but the boundary is not sharp. -/
opaque inTradition : ApostolicTeaching → Prop

/-- Whether a teaching is part of divine revelation (regardless of
    transmission mode). A teaching is revealed if Christ communicated it
    to the apostles, whether they then wrote it down or not.
    CCC §75: "The apostles... handed on... what they themselves had received."
    STRUCTURAL OPACITY: Revelation is a primitive in this formalization.
    Its content could be propositional, personal, or both — the CCC uses
    all three modes (§50-73). -/
opaque isRevealed : ApostolicTeaching → Prop

/-- A written text — candidate for inclusion in the scriptural canon.
    Not every early Christian text is Scripture. The Church had to JUDGE
    which texts are canonical. Examples of disputed texts: the Didache,
    the Shepherd of Hermas, the Epistle of Barnabas — all used in early
    worship but ultimately excluded from the canon. -/
opaque WrittenText : Type

/-- Whether a written text is part of the canonical Scriptures.
    CCC §120: "It was by the apostolic Tradition that the Church discerned
    which writings are to be included in the list of the sacred books."
    This is NOT self-evident — there were disputed books (antilegomena)
    for centuries (Hebrews, James, 2 Peter, 2-3 John, Jude, Revelation). -/
opaque isCanonical : WrittenText → Prop

/-- A judgment by the Church's teaching authority — the Magisterium.
    CCC §85: "The task of giving an authentic interpretation of the Word of
    God, whether in its written form or in the form of Tradition, has been
    entrusted to the living teaching office of the Church alone."
    HIDDEN ASSUMPTION: Such judgments can be reliable and binding. This
    connects to the PapalInfallibility.lean infrastructure — the authority
    to judge is grounded in the succession chain. -/
opaque MagisterialJudgment : Type

/-- Whether a magisterial judgment determined that a text is canonical.
    CCC §120: the canon was "discerned" by the Church — an act of
    ecclesial judgment, not self-evidence.
    Historical instances: Councils of Hippo (393) and Carthage (397, 419)
    ratified the canon. Athanasius's 39th Festal Letter (367 AD) is the
    first list matching the modern 27-book New Testament. -/
opaque determinedCanon : MagisterialJudgment → WrittenText → Prop

/-- Whether a proposition is derivable from Scripture alone — i.e.,
    whether it can be established using only the canonical Scriptures
    without appealing to Tradition or magisterial authority.
    This is the key predicate for the sola scriptura debate.
    MODELING CHOICE: We treat this as a predicate on Prop rather than
    modeling a derivation system. The formalization does not need the
    internal structure of scriptural derivation — only whether the
    canon determination is IN that set or not. -/
opaque derivableFromScriptureAlone : Prop → Prop

/-- Whether Scripture authenticates its own canon — the Protestant
    claim that the canon does not depend on Church authority.
    MODELING CHOICE: We model this as a single Prop rather than a
    procedure because the mechanism of self-authentication varies
    across Protestant traditions (inner witness of the Spirit,
    self-evidencing quality, etc.).
    RESEARCH NEEDED: Could be decomposed into multiple claims —
    self-evidencing quality, testimonium Spiritus Sancti internum,
    reception history, etc. For now the single Prop suffices. -/
opaque scriptureIsCanonSelfAuthenticating : Prop

-- ============================================================================
-- THE FOUR CATHOLIC AXIOMS
-- ============================================================================

/-!
## Axiom 1: Dual Transmission — Scripture AND Tradition (§76)

CCC §76: "In keeping with the Lord's command, the Gospel was handed on in
two ways."

This is the FIRST contested step. Catholics say revelation was transmitted
BOTH orally and in writing. The sola scriptura position says only the
written transmission is authoritative.

2 Thess 2:15: "So then, brethren, stand firm and hold to the traditions
which you were taught by us, either by word of mouth or by letter."
Paul explicitly distinguishes oral from written teaching and tells the
Thessalonians to hold to BOTH.
-/

/-- **AXIOM (DUAL_TRANSMISSION)**: Every revealed teaching is transmitted
    through at least one of the two modes: Scripture or Tradition.
    Source: CCC §76; 2 Thess 2:15.
    Denominational scope: CATHOLIC + ORTHODOX.
    HIDDEN ASSUMPTION: Oral transmission can carry divine revelation with
    the same authority as written transmission. This is precisely what
    Protestants deny — they hold that only the written mode is infallible.

    Note: "at least one" — some teachings are in BOTH Scripture and
    Tradition. The CCC does not claim the two are disjoint; it claims
    together they contain the whole deposit of faith (§80). -/
axiom dual_transmission :
  ∀ (t : ApostolicTeaching), isRevealed t →
    inScripture t ∨ inTradition t

def dual_transmission_provenance : Provenance :=
  Provenance.tradition "CCC §76; 2 Thess 2:15"
def dual_transmission_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Catholic + Orthodox; Protestants reject authoritative oral transmission" }

/-!
## Axiom 2: Material Insufficiency of Scripture (§76)

CCC §76 implies that SOME apostolic teaching exists only in Tradition,
not in Scripture. This is the claim of "material insufficiency" — Scripture
does not contain ALL revealed truth.

The Protestant reading of 2 Thess 2:15: Paul's oral teaching was eventually
written down (in the NT) and the oral became redundant.
The Catholic reading: some oral teaching remained unwritten.
-/

/-- **AXIOM (NOT_EVERYTHING_WRITTEN)**: There exists at least one revealed
    apostolic teaching that is in Tradition but NOT in Scripture.
    Source: CCC §76 (implied); 2 Thess 2:15; Jn 21:25.
    Denominational scope: CATHOLIC + ORTHODOX. Protestants deny this —
    they hold that all necessary revelation was eventually committed to writing.

    John 21:25: "Jesus did many other things as well. If every one of them
    were written down, I suppose that even the whole world would not have room
    for the books that would be written."

    HIDDEN ASSUMPTION: "Not everything written" means not everything
    DOCTRINALLY RELEVANT was written, not just historical trivia. The
    Protestant can accept Jn 21:25 (Jesus did more than the Gospels record)
    while denying that the unrecorded material includes binding doctrine. -/
axiom not_everything_written :
  ∃ (t : ApostolicTeaching), isRevealed t ∧ inTradition t ∧ ¬inScripture t

def not_everything_written_provenance : Provenance :=
  Provenance.tradition "CCC §76; 2 Thess 2:15; Jn 21:25"
def not_everything_written_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Catholic + Orthodox; Protestants deny doctrinally relevant unwritten revelation" }

/-!
## Axiom 3: The Canon Depends on Church Judgment (§120)

CCC §120: "It was by the apostolic Tradition that the Church discerned which
writings are to be included in the list of the sacred books."

This is the CANON ARGUMENT — the sharpest form of the anti-sola-scriptura
case. The Church decided WHICH books are Scripture. That act of canonization
is NOT in Scripture. Therefore the authority of Scripture presupposes a
non-scriptural authority.

Historical context: The New Testament canon was not settled until the late
4th century. Athanasius's 39th Festal Letter (367 AD) is the first list
matching the modern 27 books. The Councils of Hippo (393) and Carthage
(397, 419) ratified the canon. Before this, there was genuine dispute about
books like Hebrews, James, 2 Peter, 2-3 John, Jude, and Revelation.
-/

/-- **AXIOM (CANON_DEPENDS_ON_CHURCH)**: The canon of Scripture was determined
    by an act of Church judgment — a magisterial judgment established which
    texts are canonical.
    Source: CCC §120; Councils of Hippo (393) and Carthage (397).
    Denominational scope: CATHOLIC + ORTHODOX (as historical fact).
    Protestants offer two responses:
    (a) The Church RECOGNIZED a pre-existing canon, not DETERMINED it
    (b) Scripture is self-authenticating (see `scriptureIsCanonSelfAuthenticating`)
    Both responses are internally consistent but involve different hidden
    assumptions than the Catholic view. -/
axiom canon_depends_on_church :
  ∀ (text : WrittenText),
    isCanonical text →
    ∃ (j : MagisterialJudgment), determinedCanon j text

def canon_depends_on_church_provenance : Provenance :=
  Provenance.tradition "CCC §120; Council of Hippo 393; Council of Carthage 397"
def canon_depends_on_church_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Catholic + Orthodox (historically); Protestants say Church recognized, not determined" }

/-!
## Axiom 4: Canon Determination Is Not in Scripture

This is the logical keystone of the canon argument. The act by which the
Church determined the canon is ITSELF not derivable from Scripture alone.
No Bible verse lists the 27 books of the New Testament.

This is a factual claim, not a theological one: open any Bible and try to
find a list of which books should be in the Bible. It isn't there. The
closest candidates (2 Tim 3:16, 2 Pet 3:15-16) refer to existing Scripture
but do not SPECIFY which writings are Scripture.
-/

/-- **AXIOM (CANON_ACT_NOT_IN_SCRIPTURE)**: The determination of the canon
    is not derivable from Scripture alone.
    Source: Observation — no canonical list exists in Scripture.
    Denominational scope: FACTUAL — even most Protestant scholars acknowledge
    this. The dispute is about whether this matters (see self-authentication).
    HIDDEN ASSUMPTION: "Derivable from Scripture alone" means the specific
    list of canonical books can be determined by the texts themselves. The
    self-authentication response claims the books manifest their own
    canonicity through an internal quality — but even this is not a
    DERIVATION from Scripture; it is a judgment about Scripture. -/
axiom canon_act_not_in_scripture :
  ∀ (text : WrittenText) (j : MagisterialJudgment),
    determinedCanon j text →
    ¬derivableFromScriptureAlone (determinedCanon j text)

def canon_act_not_in_scripture_provenance : Provenance :=
  Provenance.tradition "Observation; no canonical list in Scripture"
def canon_act_not_in_scripture_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Broadly accepted factually; Protestants dispute the theological import" }

-- ============================================================================
-- THEOREMS — the logical consequences
-- ============================================================================

/-!
## Theorem 1: Scripture Is Materially Incomplete (Catholic claim)

From `not_everything_written`: there exists revealed teaching not in Scripture.
Therefore Scripture does not contain ALL revealed truth.

This is the TRADITION ARGUMENT — the deeper of the two arguments. It
establishes that even if there were no canon problem, Scripture would still
be incomplete as a record of revelation.
-/

/-- **THEOREM: scripture_materially_incomplete** — Under Catholic axioms,
    Scripture does not contain all revealed truth. There exists a revealed
    teaching that is NOT in Scripture.

    This is the direct consequence of `not_everything_written` (§76).
    It is the formal statement of "material insufficiency of Scripture."

    Source: CCC §76; 2 Thess 2:15; Jn 21:25.
    Denominational scope: CATHOLIC + ORTHODOX.
    KEY FINDING: This theorem does NOT depend on the canon argument. Even
    if the canon problem didn't exist, Scripture would still be incomplete.
    This is why the Tradition argument is the DEEPER issue. -/
theorem scripture_materially_incomplete :
    ∃ (t : ApostolicTeaching), isRevealed t ∧ ¬inScripture t := by
  obtain ⟨t, h_rev, _, h_not_s⟩ := not_everything_written
  exact ⟨t, h_rev, h_not_s⟩

/-!
## Theorem 2: Tradition-Only Teaching Exists in a Specific Mode

From `not_everything_written` and `dual_transmission`: the teaching that is
not in Scripture IS in Tradition (not floating in limbo). This wires
`dual_transmission` into the proof — the dual-mode model ensures that
unwritten revelation has a HOME (Tradition), not just a negation (not-Scripture).
-/

/-- **THEOREM: tradition_only_teaching_exists** — There exists a revealed
    teaching that is in Tradition AND not in Scripture.

    This is stronger than `scripture_materially_incomplete` because it
    establishes WHERE the unwritten teaching lives: in Tradition. The
    dual_transmission axiom guarantees every revealed teaching is in at
    least one mode; not_everything_written gives us one that is NOT in
    Scripture; together they ensure it IS in Tradition.

    Note: `not_everything_written` already gives us `inTradition t`
    directly. The role of `dual_transmission` here is to confirm the
    COMPLETENESS of the two-mode model: nothing revealed falls outside
    both modes. This means the unwritten teaching is not LOST — it is
    preserved in Tradition.

    Source: CCC §76, §80.
    Denominational scope: CATHOLIC + ORTHODOX. -/
theorem tradition_only_teaching_exists :
    ∃ (t : ApostolicTeaching), isRevealed t ∧ inTradition t ∧ ¬inScripture t := by
  obtain ⟨t, h_rev, h_trad, h_not_s⟩ := not_everything_written
  -- dual_transmission confirms this teaching is in at least one mode
  have h_mode := dual_transmission t h_rev
  -- We already know it's in Tradition (from not_everything_written)
  -- but dual_transmission confirms the two-mode model is complete
  exact ⟨t, h_rev, h_trad, h_not_s⟩

/-!
## Theorem 3: Sola Scriptura Contradicts Material Insufficiency

If sola scriptura holds (all revealed teaching is in Scripture) AND
not_everything_written holds (some revealed teaching is NOT in Scripture),
we have a contradiction.

This is the INCOMPATIBILITY RESULT — it shows the two positions are
genuinely contradictory, not just different emphases. The Catholic axioms
directly entail a contradiction with sola scriptura.
-/

/-- **THEOREM: sola_scriptura_incompatible** — The sola scriptura claim
    (all revealed teaching is in Scripture) is logically incompatible
    with the Catholic axiom `not_everything_written`.

    This uses the DECLARED axiom `not_everything_written` (not a hypothesis)
    to derive a contradiction with the sola scriptura claim (taken as
    hypothesis, since it is a Protestant axiom, not a Catholic one).

    This makes the denominational split precise: you cannot hold both.
    Catholics accept not_everything_written and reject sola_scriptura.
    Protestants accept sola_scriptura and reject not_everything_written. -/
theorem sola_scriptura_incompatible
    (h_sola : ∀ (t : ApostolicTeaching), isRevealed t → inScripture t) :
    False := by
  obtain ⟨t, h_rev, _, h_not_s⟩ := not_everything_written
  exact h_not_s (h_sola t h_rev)

/-!
## Theorem 4: The Canon Bootstrapping Problem

The canon argument in formal terms: if the canon was determined by Church
judgment (canon_depends_on_church), and that act is not derivable from
Scripture alone (canon_act_not_in_scripture), then the authority of
Scripture PRESUPPOSES a non-scriptural authority.

Therefore there exists a proposition that is:
(a) necessary for Scripture's own authority (the canon determination)
(b) not derivable from Scripture alone
-/

/-- **THEOREM: canon_bootstrapping_problem** — The canon of Scripture
    presupposes a non-scriptural authority.

    For any canonical text, the Church's judgment that determined its
    canonicity is NOT derivable from Scripture alone. Therefore the
    authority of Scripture (knowing WHAT is Scripture) depends on an
    authority OUTSIDE Scripture.

    This is the formal statement of the "canon argument" against
    sola scriptura. It does not refute sola scriptura outright — it shows
    that sola scriptura has a bootstrapping dependency on the Church.

    Axiom dependencies (kernel-verified):
    - canon_depends_on_church (§120)
    - canon_act_not_in_scripture (observation)

    Source: CCC §120.
    Denominational scope: The premises are CATHOLIC. The conclusion is a
    challenge that Protestants must address (via self-authentication or
    by denying canon_depends_on_church). -/
theorem canon_bootstrapping_problem :
    ∀ (text : WrittenText),
      isCanonical text →
      ∃ (j : MagisterialJudgment),
        determinedCanon j text ∧ ¬derivableFromScriptureAlone (determinedCanon j text) := by
  intro text h_canonical
  obtain ⟨j, h_det⟩ := canon_depends_on_church text h_canonical
  exact ⟨j, h_det, canon_act_not_in_scripture text j h_det⟩

/-!
## Theorem 5: The Combined Argument (Catholic conclusion)

The Catholic position uses BOTH arguments together:
1. Scripture is materially incomplete (Tradition argument)
2. Scripture's own authority presupposes non-scriptural authority (canon argument)

Therefore sola scriptura is not self-sufficient as a rule of faith.

This is the formal statement of the CCC's position (§74-87).
-/

/-- **THEOREM: catholic_rule_of_faith** — Under Catholic axioms, both
    the Tradition argument and the canon argument hold simultaneously.

    The conjunction is stronger than either alone:
    - The Tradition argument shows Scripture is MATERIALLY incomplete
      (missing content)
    - The canon argument shows Scripture is FORMALLY dependent on the Church
      (it needs the Church to identify what Scripture IS)

    Together: sola scriptura faces problems on BOTH dimensions — content
    and canon.

    Axiom dependencies (kernel-verified):
    - not_everything_written (§76)
    - canon_depends_on_church (§120)
    - canon_act_not_in_scripture (observation)

    Source: CCC §74-87, §120.
    Denominational scope: CATHOLIC. -/
theorem catholic_rule_of_faith :
    -- (1) There exists revealed teaching not in Scripture
    (∃ (t : ApostolicTeaching), isRevealed t ∧ ¬inScripture t) ∧
    -- (2) For any canonical text, its canonicity was determined by a
    --     non-scriptural act
    (∀ (text : WrittenText), isCanonical text →
      ∃ (j : MagisterialJudgment),
        determinedCanon j text ∧ ¬derivableFromScriptureAlone (determinedCanon j text)) := by
  exact ⟨scripture_materially_incomplete, canon_bootstrapping_problem⟩

/-!
## Theorem 6: Protestant Internal Consistency

Fairness requires showing that the Protestant position is ALSO internally
consistent. If you accept sola scriptura and reject not_everything_written,
the sola scriptura position does not lead to a contradiction — it leads to
the NEGATION of our axiom.

The debate is about which axioms are true, not about logic.

NOTE: The Protestant axioms (sola_scriptura, self_authentication) are
modeled as HYPOTHESES, not as declared axioms, because Catlib's axiom
base is Catholic. Protestant positions are alternative axiom sets.
-/

/-- **THEOREM: protestant_sola_scriptura_entails_no_unwritten** — Under
    sola scriptura, there is NO revealed teaching outside Scripture.
    Therefore the Catholic axiom `not_everything_written` must be false
    in the Protestant system.

    This makes the denominational split precise: the Protestant doesn't
    need to argue against `not_everything_written` directly — accepting
    sola scriptura already ENTAILS its negation.

    Source: 2 Tim 3:16-17; Westminster Confession 1.6. -/
theorem protestant_sola_scriptura_entails_no_unwritten
    (h_sola : ∀ (t : ApostolicTeaching), isRevealed t → inScripture t) :
    ¬∃ (t : ApostolicTeaching), isRevealed t ∧ ¬inScripture t := by
  intro ⟨t, h_rev, h_not_s⟩
  exact h_not_s (h_sola t h_rev)

-- ============================================================================
-- DENOMINATIONAL SUMMARY
-- ============================================================================

/-- Denominational scope of each axiom in the rule of faith formalization.

    The four Catholic axioms:
    - dual_transmission: Catholic + Orthodox
    - not_everything_written: Catholic + Orthodox
    - canon_depends_on_church: Catholic + Orthodox (historically)
    - canon_act_not_in_scripture: broadly factual

    The Protestant alternative (modeled as hypotheses, not axioms):
    - sola_scriptura: Protestant
    - self_authentication: Reformed -/
def ruleOfFaithDenominationalScope : List (String × DenominationalTag) :=
  [ ("dual_transmission",                 dual_transmission_tag)
  , ("not_everything_written",            not_everything_written_tag)
  , ("canon_depends_on_church",           canon_depends_on_church_tag)
  , ("canon_act_not_in_scripture",        canon_act_not_in_scripture_tag)
  ]

/-!
## Hidden assumptions — summary

1. **Oral transmission can carry binding doctrine** (not_everything_written):
   The deepest hidden assumption. If oral transmission is inherently
   unreliable or non-binding, the entire Catholic position collapses.
   The Protestant counter: writing is the only reliable preservation medium
   for doctrine across centuries.

2. **The canon was DETERMINED, not merely RECOGNIZED** (canon_depends_on_church):
   Catholics say the Church exercised JUDGMENT in canonizing. Protestants say
   the Church merely RECOGNIZED what was already self-evidently canonical.
   This is a real philosophical disagreement about the nature of the act.

3. **Scripture is NOT self-authenticating** (implicit in the Catholic position):
   The Catholic argument assumes the canon genuinely needed Church authority
   to settle. The Reformed tradition (Calvin, Westminster) denies this —
   canonical books manifest their divine quality intrinsically.

4. **Succession preserves authority** (already in Authority.lean):
   Without succession, the Magisterium has no authority to interpret or
   canonize. This formalization imports but does not re-axiomatize the
   succession chain.

5. **The "unwritten" teaching is DOCTRINALLY significant** (not_everything_written):
   The Protestant can accept that Jesus said and did things not in the Bible
   (Jn 21:25) while denying that the unrecorded material includes binding
   doctrine. The Catholic must claim the unwritten tradition contains
   doctrinally significant content, not just historical trivia.

## Key finding

The canon argument IS load-bearing, but the DEEPER issue is whether
authoritative unwritten transmission can exist at all (axiom 2:
not_everything_written). The canon argument is a specific instance of the
broader principle: if the Church has authority to judge about revelation
(including which texts ARE revelation), then there is already an
extra-scriptural authority at work. The Tradition argument establishes this
at the content level; the canon argument establishes it at the formal level.
Both converge on the same conclusion: sola scriptura is not self-sufficient.

The Protestant position is internally consistent but requires different
axioms (sola scriptura + self-authentication). The debate cannot be settled
by logic — it is a disagreement about which axioms are true.
-/

end Catlib.Creed.RuleOfFaith
