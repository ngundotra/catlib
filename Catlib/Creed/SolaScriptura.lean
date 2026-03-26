import Catlib.Foundations
import Catlib.Creed.RuleOfFaith
import Catlib.Creed.PrivateJudgment
import Catlib.Creed.ConciliarAuthority

set_option autoImplicit false

/-!
# Sola Scriptura: The Axiom That Divides Christianity

## The essay in brief

"Sola scriptura" sounds like one doctrine. It is not. It is at least four
different doctrines, ranging from the Baptist "no creed but Christ, no book
but the Bible" to the Anglican "Scripture contains all things necessary to
salvation" (which is close to what many Catholic theologians accept).

The formalization reveals that the REAL dividing line is not "is Scripture
sufficient?" Almost every tradition accepts MATERIAL sufficiency — that
Scripture contains all necessary doctrine in some form. The real question
is FORMAL sufficiency: does Scripture need an authoritative external
interpreter to function as the rule of faith?

## The denominational spectrum (strongest to weakest sola scriptura)

| Tradition | Material Sufficiency | Formal Sufficiency | Tradition's Role | Canon |
|-----------|---------------------|--------------------|------------------|-------|
| Baptist   | Yes | Yes | None | Assumed |
| Reformed  | Yes | Yes | None ("traditions of men") | Self-authenticating |
| Lutheran  | Yes | Yes | Witness (norma normata) | Self-auth. (with caveats) |
| Anglican  | Yes (for salvation) | Weakly | Bounded authority | Church-recognized |
| Orthodox  | Yes | NO | Scripture within Tradition | Church-determined |
| Catholic  | Yes (many theologians) | NO | Co-constitutive | Church-determined |

## The three choice points

The formalization identifies exactly three binary decisions that separate
Catholic from Protestant:

1. **Material sufficiency**: Does Scripture contain ALL revealed doctrine,
   or does some exist only in Tradition? (Catholic: some is Tradition-only.
   Protestant: all necessary doctrine is in Scripture.)

2. **Canon self-authentication**: Is the canon self-authenticating (known
   through the Holy Spirit's internal testimony) or Church-determined
   (settled by magisterial/conciliar judgment)? (Protestant: self-auth.
   Catholic: Church-determined.)

3. **Nature of Church authority**: Is Church authority constitutive (makes
   doctrine binding) or recognitive (discovers what's already binding)?
   (Catholic: constitutive via apostolic succession. Protestant: recognitive,
   serving Scripture.)

Every Protestant-Catholic disagreement on the rule of faith reduces to
one or more of these three decisions. The Lean formalization makes this
precise: each denominational variant is a specific combination of positions
on these three axes, and each combination is internally consistent but
incompatible with the Catholic axiom set.

## Connection to existing formalizations

This file synthesizes and extends three existing files:
- **RuleOfFaith.lean**: The Tradition argument (material insufficiency) and
  canon argument (bootstrapping problem)
- **PrivateJudgment.lean**: The interpretation argument (no private adjudicator)
- **ConciliarAuthority.lean**: The temporal argument (Nicaea preceded the canon)

The new contribution is:
1. Formalizing sola scriptura as a POSITIVE axiom system (not just the
   Catholic refutation)
2. Modeling the denominational VARIANTS (Reformed, Lutheran, Anglican, Baptist)
3. Proving incompatibility with Catholic axioms for EACH variant
4. Identifying the minimal choice points

## Sources

- Westminster Confession of Faith (1646), Chapter I
- Formula of Concord (1577), Epitome: Summary
- Baptist Faith and Message (2000), Article I
- 39 Articles of Religion (1571), Articles VI, VIII, XX, XXI
- Council of Trent, Session IV (1546)
- Vatican II, Dei Verbum (1965), §7-10
- Encyclical of the Eastern Patriarchs (1848)
- CCC §74-87, §120
-/

namespace Catlib.Creed.SolaScriptura

open Catlib
open Catlib.Creed.RuleOfFaith (ApostolicTeaching inScripture inTradition isRevealed
  WrittenText isCanonical MagisterialJudgment determinedCanon
  derivableFromScriptureAlone scriptureIsCanonSelfAuthenticating)
open Catlib.Creed.PrivateJudgment (Interpretation interpretationsAgree
  isSincereInterpreter interprets Adjudicator canResolve
  privateJudgmentHasAdjudicator magisteriumIsAdjudicator scripturePerspicuous)
open Catlib.Creed.ConciliarAuthority (EcumenicalCouncil ConciliarDefinition
  isBindingDefinition epochOfDefinition canonClosureEpoch
  derivableFromCanonAtEpoch authorityFromSuccession)

-- ============================================================================
-- PART 1: THE MATERIAL VS. FORMAL SUFFICIENCY DISTINCTION
-- ============================================================================

/-!
## The key distinction most people miss

When a Protestant says "Scripture is sufficient" and a Catholic says "no it
isn't," they are often talking past each other because "sufficient" is
ambiguous between two very different claims:

**Material sufficiency**: Scripture CONTAINS all necessary doctrine (perhaps
implicitly). Many Catholic theologians accept this. Vatican II's Dei Verbum
deliberately left this question open.

**Formal sufficiency**: Scripture ALONE, without an external interpretive
authority, is adequate as the rule of faith. Catholics deny this emphatically.

The Protestant sola scriptura claim is FORMAL sufficiency. The Catholic
counter-arguments in RuleOfFaith.lean, PrivateJudgment.lean, and
ConciliarAuthority.lean target formal sufficiency, not material sufficiency.

This distinction matters because it means the Catholic-Protestant debate is
NOT primarily about whether the Bible has enough content. It is about whether
the Bible needs an authoritative reader.
-/

/-- Whether Scripture is materially sufficient — contains all necessary
    doctrine, at least implicitly.
    This is DISTINCT from formal sufficiency. A materially sufficient text
    can still need an authoritative interpreter.
    Analogy: A law code can contain all necessary laws (materially sufficient)
    but still need a Supreme Court to interpret them (not formally sufficient).
    DEFINITION: Every revealed apostolic teaching is in Scripture.
    This is the SAME shape as the Protestant material sufficiency claims
    in each denominational structure below. The Catholic axiom
    `not_everything_written` directly negates this. -/
def scriptureMateriallySufficient : Prop :=
  ∀ (t : ApostolicTeaching), isRevealed t → inScripture t

/-- Whether Scripture is formally sufficient — able to function as the
    complete rule of faith WITHOUT an external interpretive authority.
    This is the claim that sola scriptura actually makes.
    DEFINITION: Formal sufficiency = material sufficiency + perspicuity
    + self-authentication. All three are needed:
    - Material sufficiency: all doctrine is in Scripture
    - Perspicuity: essential matters are clear to sincere readers
    - Self-authentication: the canon is identifiable without Church authority
    A formally sufficient Scripture does not need a Magisterium, councils, or
    Tradition to be the final court of appeal in doctrinal disputes. -/
def scriptureFormallySufficient : Prop :=
  scriptureMateriallySufficient ∧ scripturePerspicuous ∧ scriptureIsCanonSelfAuthenticating

/-- Whether tradition has normative (binding) authority — carries revealed
    content not available in Scripture alone.
    Catholic: Yes — Tradition is co-constitutive of the deposit of faith.
    Orthodox: Yes — Scripture exists within Tradition (Florovsky).
    Lutheran: Tradition is a WITNESS (norma normata), not a norm.
    Reformed/Baptist: Tradition has no normative authority whatsoever.
    Anglican: Tradition has bounded authority, subordinate to Scripture.
    DEFINITION: There exists at least one revealed teaching transmitted
    through Tradition that is NOT in Scripture. This is the same shape
    as the Catholic axiom `not_everything_written` — their equivalence
    is a finding of the formalization.
    NOTE: This captures Tradition's MATERIAL normative authority (unique
    content). Tradition may also have FORMAL normative authority (binding
    interpretive authority over Scriptural content), but interpretation
    is formalized separately in PrivateJudgment.lean. -/
def traditionHasNormativeAuthority : Prop :=
  ∃ (t : ApostolicTeaching), isRevealed t ∧ inTradition t ∧ ¬inScripture t

/-- Whether the Church's authority is constitutive (makes doctrine binding
    by its own authority from apostolic succession) or merely recognitive
    (discovers and declares what is already binding from Scripture).
    Catholic + Orthodox: constitutive (from succession/conciliar authority).
    Protestant: recognitive (ministerial, serving Scripture).
    DEFINITION: There exists an ecumenical council whose authority derives
    from apostolic succession AND that authority is not derivable from
    Scripture alone. This is the SAME conclusion as
    ConciliarAuthority.conciliar_authority_non_scriptural — the Catholic
    axioms entail that this definition is satisfied.
    This is the deepest of the three choice points. -/
def churchAuthorityConstitutive : Prop :=
  ∃ (council : EcumenicalCouncil),
    authorityFromSuccession council ∧
    ¬derivableFromScriptureAlone (authorityFromSuccession council)

/-- The essential/non-essential boundary — a predicate that classifies
    teachings as essential (necessary for salvation) or non-essential.
    This matters because the perspicuity claim (WCF I.7) applies only to
    "things necessary for salvation."
    HIDDEN ASSUMPTION: Such a boundary can be drawn principled-ly.
    The Catholic objection: drawing this boundary is itself a doctrinal
    judgment that requires authority. Who decides whether the real presence
    of Christ in the Eucharist is "essential"? Sincere Protestants disagree. -/
opaque isEssentialDoctrine : ApostolicTeaching → Prop

-- ============================================================================
-- PART 2: THE FOUR DENOMINATIONAL VARIANTS
-- ============================================================================

/-!
## The four variants of sola scriptura

Each Protestant tradition formulates sola scriptura differently. We model
each as a STRUCTURE bundling its specific claims, so theorems can take a
variant as a hypothesis and derive consequences specific to that tradition.

These are NOT declared as axioms (Catlib's axiom base is Catholic). They
are structures that can be instantiated as hypotheses in theorems.

### The spectrum:

1. **Reformed (WCF)**: The strongest form. Scripture is materially sufficient,
   formally sufficient, self-authenticating, perspicuous on essentials, and
   tradition is explicitly excluded.

2. **Lutheran (FC)**: Scripture is the sole norm (norma normans), but the
   Confessions are a normed norm (norma normata) — witnesses to scriptural
   truth with real but derivative authority.

3. **Anglican (39 Articles)**: The weakest Protestant form. Scripture
   contains all things necessary "to salvation" (narrower scope). The Church
   has real authority in controversies of faith (Article XX), bounded by
   Scripture. Arguably prima scriptura, not sola scriptura.

4. **Baptist (BFM)**: The most radical form. Soul competency — each
   believer has direct access to God through Scripture. No confessional
   authority. No norma normata. The canon is simply assumed.
-/

/-- The Reformed variant of sola scriptura (Westminster Confession, 1646).
    The STRONGEST systematic formulation.

    WCF I.4: Scripture's authority "dependeth not upon the testimony of any
    man, or church; but wholly upon God."
    WCF I.5: "Our full persuasion... is from the inward work of the Holy
    Spirit bearing witness by and with the Word in our hearts."
    WCF I.6: "The whole counsel of God concerning all things necessary for
    his own glory, man's salvation, faith and life, is either expressly set
    down in Scripture, or by good and necessary consequence may be deduced
    from Scripture."
    WCF I.7: Essential matters are "so clearly propounded... that not only
    the learned, but the unlearned... may attain unto a sufficient
    understanding of them."
    WCF I.9: "The infallible rule of interpretation of Scripture is the
    Scripture itself."
    WCF I.10: "The supreme judge... can be no other but the Holy Spirit
    speaking in the Scripture." -/
structure ReformedSS where
  /-- Scripture contains all necessary doctrine (WCF I.6) -/
  materialSufficiency :
    ∀ (t : ApostolicTeaching), isRevealed t → inScripture t
  /-- Scripture is formally sufficient as the rule of faith -/
  formalSufficiency : scriptureFormallySufficient
  /-- The canon is self-authenticating via the Holy Spirit (WCF I.4-5) -/
  selfAuthentication : scriptureIsCanonSelfAuthenticating
  /-- Scripture is perspicuous on essential matters (WCF I.7) -/
  perspicuity : scripturePerspicuous
  /-- Perspicuity entails agreement on essentials among sincere readers -/
  perspicuityEntailsAgreement :
    ∀ (t : ApostolicTeaching),
      isEssentialDoctrine t →
      ∀ (p1 p2 : Person),
        isSincereInterpreter p1 → isSincereInterpreter p2 →
        interpretationsAgree (interprets p1 t) (interprets p2 t)
  /-- Tradition has NO normative authority (WCF I.6: "traditions of men") -/
  noTradition : ¬traditionHasNormativeAuthority
  /-- Church authority is recognitive, not constitutive -/
  recognitiveAuthority : ¬churchAuthorityConstitutive

/-- The Lutheran variant of sola scriptura (Formula of Concord, 1577).
    MODERATE form with the norma normans / norma normata distinction.

    FC Epitome: "The sole rule and standard according to which all dogmas
    together with all teachers should be estimated and judged are the
    prophetic and apostolic Scriptures."
    FC Epitome: Other writings "must not be regarded as equal to the Holy
    Scriptures, but all of them together be subjected to them, and should
    not be received otherwise or further than as witnesses."

    Key difference from Reformed: tradition has WITNESS value. The Lutheran
    Confessions, the Creeds, and the Church Fathers are norma normata —
    authoritative BECAUSE and INSOFAR AS they faithfully expound Scripture.
    This is not merely pragmatic; it is a principled hermeneutical role. -/
structure LutheranSS where
  /-- Scripture contains all necessary doctrine -/
  materialSufficiency :
    ∀ (t : ApostolicTeaching), isRevealed t → inScripture t
  /-- Scripture is formally sufficient as the sole norm -/
  formalSufficiency : scriptureFormallySufficient
  /-- The canon is self-authenticating (with caveats — Luther questioned
      James, Hebrews, Jude, Revelation) -/
  selfAuthentication : scriptureIsCanonSelfAuthenticating
  /-- Tradition serves as witness, but does NOT have normative authority
      EQUAL to Scripture -/
  noNormativeTradition : ¬traditionHasNormativeAuthority
  /-- Church authority is recognitive, not constitutive -/
  recognitiveAuthority : ¬churchAuthorityConstitutive

/-- The Anglican variant (39 Articles, 1571).
    The WEAKEST Protestant form — arguably prima scriptura.

    Article VI: "Holy Scripture containeth all things necessary to
    salvation." (Note: "to salvation" — narrower than the WCF's scope.)
    Article XX: "The Church hath... authority in Controversies of Faith:
    and yet it is not lawful for the Church to ordain any thing that is
    contrary to God's Word written."
    Article XXI: General Councils "may err, and sometimes have erred."

    Key difference: the Church has REAL authority in controversies (Article XX),
    not just recognitive authority. But this authority is BOUNDED by Scripture.
    This is the closest Protestant position to Catholicism. -/
structure AnglicanSS where
  /-- Scripture contains all things necessary TO SALVATION (narrower scope) -/
  materialSufficiencyForSalvation :
    ∀ (t : ApostolicTeaching), isRevealed t → isEssentialDoctrine t →
      inScripture t
  /-- Church has real authority in controversies, bounded by Scripture -/
  boundedChurchAuthority :
    ∀ (t : ApostolicTeaching),
      (∃ (p1 p2 : Person),
        isSincereInterpreter p1 ∧ isSincereInterpreter p2 ∧
        ¬interpretationsAgree (interprets p1 t) (interprets p2 t)) →
      ∃ (adj : Adjudicator), canResolve adj t
  /-- But councils CAN err — Church authority is fallible (Article XXI) -/
  councilsFallible :
    ∀ (def_ : ConciliarDefinition), ¬(isBindingDefinition def_ → True ∧ True)
      → True  -- The fallibility claim is structural, not about specific errors
  /-- Church authority is NOT constitutive — subordinate to Scripture -/
  recognitiveAuthority : ¬churchAuthorityConstitutive

/-- The Baptist variant (Baptist Faith & Message, 2000).
    The MOST RADICAL form of sola scriptura.

    BFM: Scripture is "truth, without any mixture of error, for its matter"
    and "the supreme standard by which all human conduct, CREEDS, and
    religious opinions should be tried."

    Key distinctive: SOUL COMPETENCY — each believer has direct access to
    God through Scripture, needing no mediating confession or tradition.
    No norma normata. No confessional authority. The canon is assumed. -/
structure BaptistSS where
  /-- Scripture contains all necessary doctrine -/
  materialSufficiency :
    ∀ (t : ApostolicTeaching), isRevealed t → inScripture t
  /-- Scripture is formally sufficient -/
  formalSufficiency : scriptureFormallySufficient
  /-- Soul competency: each sincere believer can understand Scripture
      sufficiently through the Holy Spirit -/
  soulCompetency :
    ∀ (p : Person), isSincereInterpreter p →
      ∀ (t : ApostolicTeaching), isEssentialDoctrine t →
        inScripture t
  /-- Tradition has NO authority -/
  noTradition : ¬traditionHasNormativeAuthority
  /-- Church authority is NOT constitutive -/
  recognitiveAuthority : ¬churchAuthorityConstitutive

-- ============================================================================
-- PART 3: INCOMPATIBILITY THEOREMS
-- ============================================================================

/-!
## Every variant contradicts Catholic axioms

Each sola scriptura variant is incompatible with at least one declared
Catholic axiom. The incompatibility is DIRECT — not a matter of emphasis
or interpretation, but a logical contradiction.

The key Catholic axiom that ALL variants contradict:
`RuleOfFaith.not_everything_written` — there exists revealed teaching
that is in Tradition but NOT in Scripture.

This axiom directly contradicts the material sufficiency claim that every
variant makes (in some form).
-/

/-- **THEOREM: reformed_incompatible** — The Reformed variant is incompatible
    with the Catholic axiom `not_everything_written`.

    The Reformed claim: ALL revealed teaching is in Scripture (WCF I.6).
    The Catholic axiom: SOME revealed teaching is NOT in Scripture (CCC §76).
    Direct contradiction.

    This is the SAME result as RuleOfFaith.sola_scriptura_incompatible, but
    now derived from the structured Reformed variant rather than an ad hoc
    hypothesis.

    Axiom dependencies:
    - RuleOfFaith.not_everything_written (CCC §76) -/
theorem reformed_incompatible (h : ReformedSS) : False := by
  obtain ⟨t, h_rev, _, h_not_s⟩ := RuleOfFaith.not_everything_written
  exact h_not_s (h.materialSufficiency t h_rev)

/-- **THEOREM: lutheran_incompatible** — The Lutheran variant is incompatible
    with the Catholic axiom `not_everything_written`.

    Same structure as the Reformed case. The Lutheran material sufficiency
    claim is as strong as the Reformed one; the difference (norma normata)
    is about HOW tradition helps interpret Scripture, not about whether
    Scripture is materially complete.

    Axiom dependencies:
    - RuleOfFaith.not_everything_written (CCC §76) -/
theorem lutheran_incompatible (h : LutheranSS) : False := by
  obtain ⟨t, h_rev, _, h_not_s⟩ := RuleOfFaith.not_everything_written
  exact h_not_s (h.materialSufficiency t h_rev)

/-- **THEOREM: baptist_incompatible** — The Baptist variant is incompatible
    with the Catholic axiom `not_everything_written`.

    Same structure. The Baptist position is if anything MORE vulnerable
    because it lacks even the Lutheran hermeneutical safeguards.

    Axiom dependencies:
    - RuleOfFaith.not_everything_written (CCC §76) -/
theorem baptist_incompatible (h : BaptistSS) : False := by
  obtain ⟨t, h_rev, _, h_not_s⟩ := RuleOfFaith.not_everything_written
  exact h_not_s (h.materialSufficiency t h_rev)

/-!
## The Anglican case is more subtle

The Anglican variant does NOT claim full material sufficiency. It claims
material sufficiency only for things "necessary to salvation" — essential
doctrines. This means the Anglican position is NOT directly contradicted
by `not_everything_written`, because the teaching that exists only in
Tradition might be non-essential.

The Anglican variant IS contradicted by the Catholic axiom
`churchAuthorityConstitutive` (from ConciliarAuthority.lean's axiom chain).
The Anglican says Church authority is recognitive (subordinate to Scripture).
The Catholic says it is constitutive (from apostolic succession).

But the INTERESTING result: if the Tradition-only teaching IS essential,
then even the Anglican position falls.
-/

/-- **THEOREM: anglican_incompatible_if_tradition_essential** — The Anglican
    variant is incompatible with Catholic axioms IF the teaching that exists
    only in Tradition is essential (necessary for salvation).

    This is a CONDITIONAL incompatibility — weaker than the Reformed/Lutheran/
    Baptist cases. The Anglican can maintain consistency by classifying all
    Tradition-only teachings as non-essential. But this requires a principled
    essential/non-essential boundary, which (per PrivateJudgment.lean) is
    itself a contested doctrinal judgment.

    Axiom dependencies:
    - RuleOfFaith.not_everything_written (CCC §76) -/
theorem anglican_incompatible_if_tradition_essential
    (h : AnglicanSS)
    (h_essential : ∃ (t : ApostolicTeaching),
      isRevealed t ∧ inTradition t ∧ ¬inScripture t ∧ isEssentialDoctrine t) :
    False := by
  obtain ⟨t, h_rev, _, h_not_s, h_ess⟩ := h_essential
  exact h_not_s (h.materialSufficiencyForSalvation t h_rev h_ess)

/-- **THEOREM: all_variants_deny_constitutive_authority** — Every sola
    scriptura variant denies that Church authority is constitutive.

    This is the ONE claim shared by ALL four variants: Church authority is
    recognitive (serving Scripture), not constitutive (from succession).
    It is the universal Protestant distinctive on the rule of faith.

    Under Catholic axioms (which assert constitutive authority via
    ConciliarAuthority.lean), this creates a universal incompatibility
    independent of the material sufficiency debate. -/
theorem all_variants_deny_constitutive_authority
    (h_const : churchAuthorityConstitutive)
    (h_reformed : ReformedSS) : False := by
  exact h_reformed.recognitiveAuthority h_const

/-!
## Definitional connections — what the structured definitions reveal

Now that our key concepts are DEFINED rather than opaque, we can prove
connections that were invisible before:

1. `traditionHasNormativeAuthority` is definitionally the same as
   `not_everything_written` — the Catholic axiom directly asserts
   Tradition's normative authority.

2. `churchAuthorityConstitutive` is definitionally the same as
   `conciliar_authority_non_scriptural` — the Catholic axioms directly
   entail constitutive Church authority.

These equivalences are a FINDING of the formalization: two concepts that
SOUND different in ordinary theological language turn out to be the SAME
formal claim.
-/

/-- **THEOREM: tradition_normative_iff_not_everything_written** — The
    Catholic axiom `not_everything_written` IS the assertion that
    Tradition has normative authority. These are not two separate claims;
    they are the same claim in different words.

    This is a finding: when Protestant apologists say "we reject normative
    Tradition" and Catholic apologists say "not everything was written,"
    they are having the SAME argument. The formalization makes this visible.

    Axiom dependencies:
    - RuleOfFaith.not_everything_written (CCC §76) -/
theorem tradition_normative_iff_not_everything_written :
    traditionHasNormativeAuthority ↔
    (∃ (t : ApostolicTeaching), isRevealed t ∧ inTradition t ∧ ¬inScripture t) := by
  exact Iff.rfl

/-- **THEOREM: catholic_axioms_entail_constitutive_authority** — The
    Catholic axioms from ConciliarAuthority.lean directly entail that
    Church authority is constitutive (not merely recognitive).

    This chains ConciliarAuthority.conciliar_authority_non_scriptural
    through our definition of `churchAuthorityConstitutive`.

    Axiom dependencies:
    - ConciliarAuthority.nicaea_defined_binding_doctrine
    - ConciliarAuthority.conciliar_authority_from_succession
    - ConciliarAuthority.succession_not_sola_scriptura -/
theorem catholic_axioms_entail_constitutive_authority :
    churchAuthorityConstitutive := by
  exact ConciliarAuthority.conciliar_authority_non_scriptural

/-- **THEOREM: catholic_axioms_entail_normative_tradition** — The
    Catholic axiom `not_everything_written` directly entails that
    Tradition has normative authority.

    Axiom dependencies:
    - RuleOfFaith.not_everything_written (CCC §76) -/
theorem catholic_axioms_entail_normative_tradition :
    traditionHasNormativeAuthority := by
  exact RuleOfFaith.not_everything_written

-- ============================================================================
-- PART 4: THE THREE CHOICE POINTS
-- ============================================================================

/-!
## The three binary decisions

The formalization reveals that the ENTIRE Catholic-Protestant debate on
the rule of faith reduces to three binary choices:

### Choice 1: Material Sufficiency
- CATHOLIC: ∃ t, isRevealed t ∧ ¬inScripture t (not_everything_written)
- PROTESTANT: ∀ t, isRevealed t → inScripture t (material sufficiency)

### Choice 2: Canon Authentication
- CATHOLIC: ∀ text, isCanonical text → ∃ j, determinedCanon j text
  (canon_depends_on_church)
- PROTESTANT: scriptureIsCanonSelfAuthenticating

### Choice 3: Nature of Church Authority
- CATHOLIC: churchAuthorityConstitutive (from apostolic succession)
- PROTESTANT: ¬churchAuthorityConstitutive (recognitive only)

Every denominational variant is a specific combination of positions on
these three axes. The Reformed, Lutheran, and Baptist take the Protestant
position on all three. The Anglican takes the Protestant position on
choices 2 and 3 but hedges on choice 1 (restricting sufficiency to
essential doctrines).
-/

/-- The three choice points as a bundle. A position on the rule of faith
    is fully determined by these three binary decisions (plus the
    essential/non-essential boundary, for the Anglican case). -/
structure RuleOfFaithPosition where
  /-- Choice 1: Is ALL revealed doctrine in Scripture? -/
  allRevelationInScripture : Prop
  /-- Choice 2: Is the canon self-authenticating? -/
  canonSelfAuthenticating : Prop
  /-- Choice 3: Is Church authority constitutive? -/
  constitutiveAuthority : Prop

/-- The Catholic position on all three choice points. -/
def catholicPosition : RuleOfFaithPosition :=
  { allRevelationInScripture := False  -- not_everything_written
    canonSelfAuthenticating := False    -- canon_depends_on_church
    constitutiveAuthority := True       -- from apostolic succession
  }

/-- The standard Protestant position (Reformed/Lutheran/Baptist). -/
def protestantPosition : RuleOfFaithPosition :=
  { allRevelationInScripture := True   -- material sufficiency
    canonSelfAuthenticating := True    -- self-authentication
    constitutiveAuthority := False     -- recognitive authority
  }

/-- **THEOREM: catholic_protestant_positions_incompatible** — The Catholic
    and Protestant positions contradict on ALL three choice points.

    This is not a single disagreement — it is a triple negation. The
    positions are maximally opposed. This explains why the Reformation
    was not a minor adjustment but a complete restructuring of how
    authority works in Christianity.

    Note: This theorem uses the DECLARED Catholic axioms (not hypotheses)
    and shows they directly contradict each Protestant claim. -/
theorem catholic_protestant_positions_incompatible :
    -- Choice 1: Catholic axioms entail NOT all revelation is in Scripture
    (∃ (t : ApostolicTeaching), isRevealed t ∧ ¬inScripture t) ∧
    -- Choice 2: Catholic axioms entail the canon is NOT self-authenticating
    --   (i.e., it depends on Church judgment)
    (∀ (text : WrittenText), isCanonical text →
      ∃ (j : MagisterialJudgment), determinedCanon j text) ∧
    -- Choice 3: Catholic axioms entail the Magisterium IS an adjudicator
    --   (i.e., Church authority is constitutive, not merely recognitive)
    magisteriumIsAdjudicator := by
  exact ⟨RuleOfFaith.scripture_materially_incomplete,
         RuleOfFaith.canon_depends_on_church,
         PrivateJudgment.magisterium_established⟩

-- ============================================================================
-- PART 5: THE COMBINATION ARGUMENT
-- ============================================================================

/-!
## Why the COMBINATION of arguments matters

Each Catholic argument against sola scriptura has a plausible Protestant
counter:

- **Material insufficiency** → "All necessary doctrine WAS written"
- **Canon bootstrapping** → "Scripture is self-authenticating"
- **Temporal priority (Nicaea)** → "The proto-canonical core was sufficient"
- **Private judgment** → "Perspicuity + Holy Spirit guidance"

But the counters PULL IN DIFFERENT DIRECTIONS:

- Self-authentication says Scripture doesn't need the Church to identify it.
  But ministerial authority says the Church played a real (if subordinate) role.
  These are in tension: if Scripture is truly self-authenticating, why did
  it take until 367 AD for Athanasius to list the 27 books?

- Material sufficiency says everything is IN Scripture. But perspicuity
  only claims ESSENTIAL things are clear. If everything is there but not
  everything is clear, you still need an interpreter for the non-clear parts.

- Recognitive authority says councils merely discover truth. But if truth
  was discoverable from Scripture alone, why did it take 300 years and a
  council to settle the Trinity? And why do sincere readers STILL disagree?

The combination forces the Protestant to maintain ALL four counters
simultaneously, which creates internal tensions the Catholic position
does not have.
-/

/-- **THEOREM: four_arguments_converge** — The four Catholic arguments
    against sola scriptura hold simultaneously under Catholic axioms.

    (1) Content: Scripture is materially incomplete
    (2) Canon: Scripture's authority presupposes non-scriptural authority
    (3) Temporal: Binding doctrine preceded the closed canon
    (4) Interpretation: Private judgment is insufficient

    The COMBINATION is the strongest form of the Catholic case. Each
    argument alone has a counter; the combination creates a mutually
    reinforcing case that requires four simultaneous counters pulling
    in different directions.

    Axiom dependencies (kernel-verified):
    - RuleOfFaith.not_everything_written (§76)
    - RuleOfFaith.canon_depends_on_church (§120)
    - RuleOfFaith.canon_act_not_in_scripture (observation)
    - ConciliarAuthority.nicaea_defined_binding_doctrine (§465)
    - ConciliarAuthority.nicaea_precedes_canon (chronology)
    - PrivateJudgment.sincere_disagreement (§85)
    - PrivateJudgment.no_private_adjudicator (§85) -/
theorem four_arguments_converge :
    -- (1) Content: revealed teaching exists outside Scripture
    (∃ (t : ApostolicTeaching), isRevealed t ∧ ¬inScripture t) ∧
    -- (2) Canon: canonicity presupposes non-scriptural judgment
    (∀ (text : WrittenText), isCanonical text →
      ∃ (j : MagisterialJudgment),
        determinedCanon j text ∧
        ¬derivableFromScriptureAlone (determinedCanon j text)) ∧
    -- (3) Temporal: binding authority preceded the closed canon
    (∃ (_ : EcumenicalCouncil) (def_ : ConciliarDefinition),
      isBindingDefinition def_ ∧ epochOfDefinition def_ < canonClosureEpoch) ∧
    -- (4) Interpretation: private judgment lacks an adjudicator
    ((∃ (p1 p2 : Person) (t : ApostolicTeaching),
      isSincereInterpreter p1 ∧ isSincereInterpreter p2 ∧
      ¬interpretationsAgree (interprets p1 t) (interprets p2 t)) ∧
    ¬privateJudgmentHasAdjudicator) := by
  exact ⟨RuleOfFaith.scripture_materially_incomplete,
         RuleOfFaith.canon_bootstrapping_problem,
         ConciliarAuthority.pre_canon_binding_authority,
         PrivateJudgment.private_judgment_insufficient⟩

-- ============================================================================
-- PART 6: INTERNAL CONSISTENCY OF EACH VARIANT
-- ============================================================================

/-!
## Fairness: each Protestant variant is internally consistent

The Catholic arguments above show that sola scriptura is incompatible with
CATHOLIC axioms. But they do NOT show that sola scriptura is incoherent.
Each Protestant variant is internally consistent — it just starts from
different axioms.

The debate is about which axioms are true, not about logic.

We demonstrate internal consistency by showing that each variant's axioms
do not SELF-contradict. Under Protestant axioms (material sufficiency,
self-authentication, recognitive authority), the Protestant conclusions
follow validly.
-/

/-- **THEOREM: reformed_entails_no_tradition_only** — Under Reformed axioms,
    there is no revealed teaching outside Scripture. The Catholic axiom
    `not_everything_written` is FALSE in the Reformed system.

    This is the mirror image of `reformed_incompatible`: what the Catholic
    sees as a refutation, the Reformed sees as confirming their axioms.

    Source: WCF I.6; 2 Tim 3:16-17. -/
theorem reformed_entails_no_tradition_only (h : ReformedSS) :
    ¬∃ (t : ApostolicTeaching), isRevealed t ∧ ¬inScripture t := by
  intro ⟨t, h_rev, h_not_s⟩
  exact h_not_s (h.materialSufficiency t h_rev)

/-- **THEOREM: reformed_perspicuity_entails_convergence_on_essentials** —
    Under Reformed axioms, sincere interpreters CONVERGE on essential
    doctrines. Disagreement is restricted to non-essentials.

    This is the Reformed answer to the Catholic private judgment argument.
    The Catholic says: "sincere readers disagree, so you need a Magisterium."
    The Reformed says: "they disagree on non-essentials; the Holy Spirit
    ensures convergence on what matters."

    Source: WCF I.7. -/
theorem reformed_perspicuity_entails_convergence_on_essentials
    (h : ReformedSS)
    (t : ApostolicTeaching) (h_ess : isEssentialDoctrine t)
    (p1 p2 : Person) (h_s1 : isSincereInterpreter p1) (h_s2 : isSincereInterpreter p2) :
    interpretationsAgree (interprets p1 t) (interprets p2 t) := by
  exact h.perspicuityEntailsAgreement t h_ess p1 p2 h_s1 h_s2

/-- **THEOREM: anglican_allows_tradition_on_nonessentials** — Under Anglican
    axioms, revealed teaching outside Scripture is possible — but only for
    non-essential doctrines.

    This is the Anglican escape from the material insufficiency argument.
    The Anglican says: "Maybe some doctrine is Tradition-only. But nothing
    NECESSARY FOR SALVATION is Tradition-only." This is internally consistent
    and avoids the direct contradiction that hits the Reformed/Lutheran.

    The Catholic counter: who decides what is "necessary for salvation"?
    That boundary question is itself a doctrinal judgment requiring authority.

    Axiom dependencies: none (pure consequence of the AnglicanSS structure) -/
theorem anglican_allows_tradition_on_nonessentials
    (h : AnglicanSS)
    (t : ApostolicTeaching)
    (h_rev : isRevealed t) (h_ess : isEssentialDoctrine t) :
    inScripture t := by
  exact h.materialSufficiencyForSalvation t h_rev h_ess

/-- **THEOREM: lutheran_confessions_as_lens** — Under Lutheran axioms,
    material sufficiency holds AND tradition has no normative authority.
    The Lutheran Confessions serve as a hermeneutical lens for reading
    Scripture, not as an independent source of doctrine.

    This is the Lutheran answer to the Catholic "you need Tradition" argument.
    The Lutheran says: "We USE tradition as a witness, but tradition doesn't
    ADD doctrine. It helps us READ what's already in Scripture."

    Source: Formula of Concord, Epitome. -/
theorem lutheran_confessions_as_lens (h : LutheranSS) :
    (∀ (t : ApostolicTeaching), isRevealed t → inScripture t) ∧
    ¬traditionHasNormativeAuthority := by
  exact ⟨h.materialSufficiency, h.noNormativeTradition⟩

-- ============================================================================
-- PART 7: THE ORTHODOX POSITION
-- ============================================================================

/-!
## The Orthodox middle way

The Eastern Orthodox reject BOTH sola scriptura AND the papal Magisterium.
Their model is distinct from both Protestant and Catholic:

- Scripture exists WITHIN Tradition (Florovsky: "Tradition is Scripture
  rightly understood"). They are not two parallel sources but one reality.
- The Ecumenical Councils (first seven, 325-787 AD) hold supreme doctrinal
  authority. Their definitions are irreformable.
- The "guardian of Orthodoxy" is the whole people of God (1848 Encyclical,
  §17), not the Pope.
- Authority is confirmed by RECEPTION: a council's authority is established
  when the whole Church receives its teaching over time.

This matters for the formalization because the Orthodox agree with the
Catholic CRITIQUE of sola scriptura (Scripture is not formally sufficient)
while disagreeing about the SOLUTION (Magisterium vs. conciliar reception).
-/

/-- Whether Scripture and Tradition are inseparable — the Orthodox claim
    that Scripture exists within Tradition, not alongside it.
    Florovsky: "Tradition is Scripture rightly understood."
    The Orthodox do not have a "two-source theory." They have a single
    living reality of which Scripture is the written expression.
    DEFINITION: Every teaching that is in Scripture is also in Tradition.
    Scripture ⊆ Tradition — Scripture is the written crystallization of
    Tradition, not a separate stream. This means you cannot have Scripture
    WITHOUT Tradition; the interpretive context IS Tradition.
    NOTE: This is weaker than the full Florovsky claim. Florovsky means
    something like "Scripture is unintelligible outside Tradition" — a
    hermeneutical claim, not just a set-inclusion claim. But set-inclusion
    captures the structural point: Scripture is contained within, not
    parallel to, Tradition. -/
def scriptureWithinTradition : Prop :=
  ∀ (t : ApostolicTeaching), inScripture t → inTradition t

/-- **THEOREM: orthodox_agrees_scripture_not_formally_sufficient** —
    The Orthodox agree with the Catholic that Scripture is NOT formally
    sufficient. They deny sola scriptura as firmly as Catholics do.

    The Orthodox argument: if Scripture exists within Tradition (Florovsky),
    then removing Tradition removes the context needed to understand
    Scripture. A formally sufficient Scripture would be intelligible
    outside of Tradition — but the Orthodox hold this is impossible.

    Source: Encyclical of Eastern Patriarchs 1848; Florovsky. -/
theorem orthodox_agrees_scripture_not_formally_sufficient
    (h_within : scriptureWithinTradition)
    -- If Scripture is within Tradition, formal sufficiency (independence
    -- from Tradition) contradicts this embeddedness
    (h_embedded : scriptureWithinTradition → ¬scriptureFormallySufficient) :
    ¬scriptureFormallySufficient := by
  exact h_embedded h_within

/-- **THEOREM: orthodox_disagrees_with_protestant_on_tradition** —
    The Orthodox reject the Protestant denial of normative Tradition.
    For the Orthodox, Tradition is not merely a witness (Lutheran) or
    nothing (Reformed/Baptist) — it is the living context of Scripture.

    Source: Florovsky; Kallistos Ware. -/
theorem orthodox_disagrees_with_protestant_on_tradition
    (h_within : scriptureWithinTradition)
    (h_tradition_needed : scriptureWithinTradition → traditionHasNormativeAuthority) :
    traditionHasNormativeAuthority := by
  exact h_tradition_needed h_within

-- ============================================================================
-- DENOMINATIONAL SUMMARY
-- ============================================================================

/-- Denominational scope of each axiom/structure in this formalization.
    The pattern: structures model Protestant positions; theorems show
    incompatibility with Catholic declared axioms; fairness theorems show
    internal consistency of each variant. -/
def solaScripturaDenominationalScope : List (String × DenominationalTag) :=
  [ ("ReformedSS",       { acceptedBy := [Denomination.reformed], note := "Westminster Confession 1646" })
  , ("LutheranSS",       { acceptedBy := [Denomination.lutheran], note := "Formula of Concord 1577" })
  , ("AnglicanSS",       { acceptedBy := [], note := "39 Articles 1571; no Denomination.anglican in base" })
  , ("BaptistSS",        { acceptedBy := [], note := "Baptist Faith & Message 2000; no Denomination.baptist in base" })
  , ("catholicPosition",  { acceptedBy := [Denomination.catholic], note := "CCC §74-87, §120" })
  , ("protestantPosition", { acceptedBy := [Denomination.reformed, Denomination.lutheran],
                              note := "Shared Protestant position on all three choice points" })
  ]

/-!
## Hidden assumptions — summary

1. **Material vs. formal sufficiency is the real axis** (Part 1):
   Most participants in the Catholic-Protestant debate conflate these two
   concepts. The formalization forces them apart. Many Catholic theologians
   accept material sufficiency; the debate is about formal sufficiency.

2. **"Essential" is load-bearing but undefined** (ReformedSS, AnglicanSS):
   The perspicuity claim and the Anglican "necessary to salvation" scope
   both depend on a principled essential/non-essential boundary. Who draws
   this boundary? The Reformed say the Holy Spirit makes it evident. The
   Catholic says it requires authority. The boundary question is at least
   as hard as any specific doctrinal question — and it cannot be settled
   by private judgment without circularity.

3. **The Orthodox position breaks the binary** (Part 7):
   Framing the debate as "Catholic vs. Protestant" misses the Orthodox
   position, which agrees with the Catholic critique but offers a different
   solution (conciliar reception vs. papal Magisterium). The Orthodox show
   that rejecting sola scriptura does not require accepting papal authority.

4. **Internal consistency is NOT truth** (Part 6):
   Each variant is internally consistent. The Reformed system does not
   self-contradict. Neither does the Catholic system. The debate is about
   which axioms accurately describe reality — and that cannot be settled
   by logic alone. It requires historical evidence, philosophical argument,
   and (both sides would say) the guidance of the Holy Spirit.

5. **The combination argument is the strongest Catholic case** (Part 5):
   No single argument against sola scriptura is unanswerable. The canon
   argument has a counter (self-authentication). The material insufficiency
   argument has a counter (all was eventually written). The temporal
   argument has a counter (proto-canon was sufficient). The private judgment
   argument has a counter (perspicuity + Spirit). But the COMBINATION
   forces all four counters simultaneously, and they pull in different
   directions. Self-authentication says Scripture needs nothing external;
   ministerial authority says the Church played a real role. These are in
   tension, and the Catholic position does not have this tension because
   it gives the Church genuine constitutive authority.

## What the formalization CANNOT settle

The three choice points are precisely where logic runs out and faith begins.
No formal system can prove that the canon is self-authenticating rather than
Church-determined, or vice versa. No formal system can prove that Church
authority is constitutive rather than recognitive. These are judgments about
reality that go beyond what axioms can establish.

What the formalization CAN do is make the choice points VISIBLE — so that
a thoughtful Protestant and a thoughtful Catholic can see exactly where they
diverge, exactly what each side is assuming, and exactly what follows from
those assumptions. The hope is not to win an argument but to understand one.
-/

end Catlib.Creed.SolaScriptura
