import Catlib.Foundations.Basic

/-!
# Catlib Foundations: The 14 Base Axioms

Every axiom in the formalization files traces back to one of these
14 foundational assumptions, organized into three groups by source:

- **P2-P3**: Philosophical commitments (Aristotle / Aquinas / natural reason)
- **S1-S9**: Scriptural axioms (specific Bible passages under Catholic reading)
- **T1-T3**: Sacred Tradition (Church Fathers, Councils, Magisterium)

**Note on the 5/5/5 → 2/9/3 reclassification.** An earlier draft split the
axioms evenly across Philosophy, Scripture, and Tradition. Closer analysis
showed that several axioms originally classified as Philosophical or Traditional
actually have strong *direct* scriptural grounding: Paul explicitly teaches
moral realism (Rom 1:20; 2:14-15), Jesus explicitly teaches teleological freedom
(Jn 8:34-36; Gal 5:1), multiple New-Testament passages assert the necessity and
transformative power of grace (Jn 15:5; 2 Cor 5:17; Ezek 36:26), and Paul
explicitly grounds the binding force of conscience (Rom 14:23; Acts 24:16).
Most of the system's assumptions therefore trace to Scripture; only two
irreducibly philosophical models and three distinctively conciliar formulations
remain outside the scriptural core.

This mirrors the Catechism's own epistemology: Scripture, Tradition, and natural
reason are the three pillars on which Catholic doctrine rests.

## Design

Each axiom is:
1. Declared as a Lean `axiom` (an unproven `Prop` or function)
2. Tagged with a `Provenance` value documenting its source
3. Typed using the foundational types from `Basic.lean` where applicable

The formalization files should eventually derive their local axioms from
these 14 rather than declaring them independently.
-/

namespace Catlib

-- ============================================================================
-- Additional foundational types needed by the base axioms
-- ============================================================================


/-- A moral proposition — a claim about what is good, right, or obligatory. -/
opaque MoralProposition : Type

/-- Truth value of a moral proposition, independent of any agent's beliefs. -/
opaque moralTruthValue : MoralProposition → Prop

/-- Accessibility of a moral truth to unaided reason. -/
opaque accessibleToReason : MoralProposition → Prop

/-- The good — the final cause or telos toward which freedom is ordered. -/
opaque TheGood : Type

/-- Whether a person genuinely could have chosen otherwise in a given situation. -/
opaque couldChooseOtherwise : Person → Prop

/-- Primary cause — God's causal activity as first cause. -/
opaque PrimaryCause : Type

/-- Secondary cause — a creature's own genuine causal activity. -/
opaque SecondaryCause : Type

/-- Whether two causes compete (i.e. more of one means less of the other). -/
opaque causesCompete : PrimaryCause → SecondaryCause → Prop

/-- God, modeled as a distinguished entity. -/
opaque God : Type

/-- God's nature is love. -/
opaque godIsLove : Prop

/-- Love between persons. -/
opaque loves : Person → Person → Prop

/-- Whether genuine love requires freedom. -/
opaque loveRequiresFreedom : Prop

/-- God desires a given person to be saved. -/
opaque godWillsSalvation : Person → Prop

/-- The moral law written on the heart of a person. -/
opaque moralLawInscribed : Person → Prop

/-- God governs (providentially orders) a given event or state. -/
opaque divinelyGoverned : Prop → Prop

/-- Whether a sin is grave (mortal). -/
opaque isGraveSin : Sin → Prop

/-- Whether two parties are in communion with each other.
    Communion is a mutual participatory relationship (Latin: communio,
    "sharing in common"). It is binary — it relates two parties.
    CCC §1024, §946, §1033. -/
opaque inCommunion : CommunionParty → CommunionParty → Prop

/-- Communion is symmetric: if A is in communion with B, B is in communion with A.
    Communion is mutual by definition — it is shared participation. -/
axiom communion_symmetric :
  ∀ (a b : CommunionParty), inCommunion a b → inCommunion b a

/-- Persons are not in communion with themselves — communion requires an other. -/
axiom communion_not_self_reflexive :
  ∀ (p : Person), p.isMoralAgent = true → ¬ inCommunion (.person p) (.person p)

/-- God is in communion with Godself (the Trinity is eternal mutual communion).
    CCC §255: The divine persons are subsistent relations. -/
axiom god_self_communion : inCommunion .god .god

/-- The Church is in communion with itself (the communion of saints).
    CCC §946: "The communion of saints." -/
axiom church_self_communion : inCommunion .church .church

/-- Grace given to a person. -/
opaque graceGiven : Person → Grace → Prop

/-- Whether grace transforms (not merely covers) the person. -/
opaque graceTransforms : Grace → Person → Prop

/-- Whether a person cooperates freely with grace. -/
opaque cooperatesWithGrace : Person → Grace → Prop

/-- A sacrament. -/
opaque Sacrament : Type

/-- What a sacrament signifies (its sign-content). -/
opaque signifies : Sacrament → Prop

/-- What a sacrament actually confers (its effect). -/
opaque confers : Sacrament → Prop

/-- The judgment of conscience about an action. -/
opaque conscienceJudges : Person → Action → Prop

/-- Whether an agent is obligated to perform an action. -/
opaque obligated : Person → Action → Prop

/-- Whether something is evil. -/
opaque isEvil : Prop → Prop

/-- Whether something is a due good that is absent. -/
opaque isDueGoodAbsent : Prop → Prop

-- ============================================================================
-- P2-P3: PHILOSOPHICAL AXIOMS — the irreducible non-scriptural residue (2)
-- ============================================================================


/-- **P2. TWO_TIER_CAUSATION**: Primary (divine) and secondary (creaturely)
    causes operate on different levels and do not compete — more divine action
    does not mean less creaturely action, and vice versa.

    *Source*: Aquinas, ST I q.105 a.5; the principle of non-contrastive
    transcendence.

    Phil 2:13 ("it is God who works in you, both to will and to work") describes
    the phenomenon, but the two-tier causal *model* is a philosophical
    contribution by Aquinas.

    *Grounds*: Providence.lean axiom 8 (primary_secondary_non_competing),
    creaturely causation is genuine (Providence.lean axiom 42). CCC §306:
    "God grants his creatures not only their existence, but also the dignity
    of acting on their own." -/
axiom p2_two_tier_causation :
  ∀ (p : PrimaryCause) (s : SecondaryCause), ¬ causesCompete p s

/-- Provenance tag for P2. -/
def p2_provenance : Provenance := Provenance.naturalLaw

/-- **P3. EVIL_IS_PRIVATION**: Evil is not a positive reality but the absence
    of a due good — a privation, not a substance.

    *Source*: Augustine, Confessions VII.12 ("Evil has no existence except as
    a privation of good"); Aquinas, ST I q.48 a.1 and q.49.

    Gen 1:31 ("God saw all that he had made, and it was very good") is a seed,
    but the formal privation theory is a philosophical contribution by
    Augustine and Aquinas.

    *Grounds*: Providence.lean axiom 29 (causation_asymmetry), axiom 40
    (god_not_cause_of_evil). CCC §311: "God is in no way, directly or
    indirectly, the cause of moral evil." -/
axiom p3_evil_is_privation :
  ∀ (e : Prop), isEvil e → isDueGoodAbsent e

/-- Provenance tag for P3. -/
def p3_provenance : Provenance := Provenance.naturalLaw

-- ============================================================================
-- S1-S9: SCRIPTURAL AXIOMS — with full verse references (9)
-- ============================================================================

/-- **S1. GOD_IS_LOVE**: God's very nature is love, and genuine love requires
    the beloved's freedom.

    *Source*: 1 John 4:8 ("God is love"); Deuteronomy 30:19 ("I have set
    before you life and death… choose life").

    *Grounds*: Hell.lean axiom 30 (love_requires_freedom), the impossibility
    of predestination to damnation. CCC §214: "God is Love." CCC §1861: love
    as the fundamental orientation that hell's self-exclusion negates. -/
axiom s1_god_is_love :
  godIsLove ∧ loveRequiresFreedom

/-- Provenance tag for S1. -/
def s1_provenance : Provenance := Provenance.scripture "1 Jn 4:8; Dt 30:19"

/-- **S2. UNIVERSAL_SALVIFIC_WILL**: God desires all human persons to be saved;
    no one is predestined to damnation.

    *Source*: 1 Timothy 2:4 ("God desires all people to be saved and to come
    to the knowledge of the truth").

    *Grounds*: Hell.lean axiom 32 (no_predestination_to_hell), the universal
    offer of grace. CCC §1037: "God predestines no one to go to hell." -/
axiom s2_universal_salvific_will :
  ∀ (p : Person), godWillsSalvation p

/-- Provenance tag for S2. -/
def s2_provenance : Provenance := Provenance.scripture "1 Tim 2:4"

/-- **S3. LAW_ON_HEARTS**: God has inscribed the moral law in every human heart,
    making it accessible even without special revelation.

    *Source*: Romans 2:14-15 ("When Gentiles who do not have the law do by
    nature things required by the law… they show that the requirements of the
    law are written on their hearts").

    *Grounds*: NaturalLaw.lean axioms 33-34 (divine_grounding, universality).
    CCC §1954: "The natural law… is nothing other than the light of
    understanding placed in us by God." -/
axiom s3_law_on_hearts :
  ∀ (p : Person), p.hasIntellect = true → moralLawInscribed p

/-- Provenance tag for S3. -/
def s3_provenance : Provenance := Provenance.scripture "Rom 2:14-15"

/-- **S4. UNIVERSAL_PROVIDENCE**: God governs all things, including free actions,
    without negating creaturely freedom.

    *Source*: Matthew 10:29 ("Not a single sparrow falls to the ground without
    your Father's will"); Isaiah 46:10 ("My purpose will stand, and I will do
    all that I please").

    *Grounds*: Providence.lean axiom 35 (providence_universal), foreknowledge
    compatible with freedom. CCC §302: "Creation has its own goodness and proper
    perfection, but it did not spring forth complete from the hands of the
    Creator." CCC §303: "God carries out his plan through secondary causes." -/
axiom s4_universal_providence :
  ∀ (event : Prop), divinelyGoverned event

/-- Provenance tag for S4. -/
def s4_provenance : Provenance := Provenance.scripture "Mt 10:29; Is 46:10"

/-- **S5. SIN_SEPARATES**: Grave sin breaks communion with God.

    *Source*: 1 John 3:14-15 ("Anyone who hates a brother or sister is a
    murderer, and you know that no murderer has eternal life residing in him");
    Romans 6:23 ("The wages of sin is death").

    *Grounds*: Sin.lean axiom 14 (mortal_sin_causes_loss_of_grace), Hell.lean
    axiom 31 (grave_sin_prevents_love). CCC §1855: "Mortal sin destroys
    charity in the heart of man." -/
axiom s5_sin_separates :
  ∀ (p : Person) (s : Sin), isGraveSin s → s.action.agent = p →
    ¬ inCommunion (.person p) .god

/-- Provenance tag for S5. -/
def s5_provenance : Provenance := Provenance.scripture "1 Jn 3:14-15; Rom 6:23"

/-- **S6. MORAL_REALISM**: Moral facts exist independently of opinion and are
    accessible to unaided human reason.

    *Source*: Romans 1:20 ("So that they are without excuse"); Romans 2:14-15
    ("the requirements of the law are written on their hearts, their
    consciences also bearing witness"). Paul explicitly says moral knowledge
    is accessible without special revelation.

    *Grounds*: natural law theory (NaturalLaw.lean axioms 1-3), the claim that
    moral truths are objective and knowable. CCC §1954: "The natural law…
    is nothing other than the light of understanding placed in us by God." -/
axiom s6_moral_realism :
  ∀ (mp : MoralProposition), moralTruthValue mp → accessibleToReason mp

/-- Provenance tag for S6. -/
def s6_provenance : Provenance := Provenance.scripture "Rom 1:20; Rom 2:14-15"

-- Helpers for S7
/-- Whether a person is directed toward the good. -/
axiom directedTowardGood : Person → Prop

/-- The freedom degree a person possesses. -/
axiom agentFreedom : Person → FreedomDegree

/-- **S7. TELEOLOGICAL_FREEDOM**: Freedom is ordered toward the good; choosing
    evil is a defect that diminishes freedom rather than expressing it.

    *Source*: John 8:34 ("everyone who sins is a slave to sin"); John 8:36
    ("if the Son sets you free, you will be free indeed"); Galatians 5:1
    ("for freedom Christ has set us free"). Jesus explicitly teaches that
    freedom is directed toward the good and that sin is bondage, not freedom.

    *Grounds*: Freedom.lean axioms 10-13 (good increases freedom, evil diminishes
    it, evil possible only in imperfect freedom, responsibility proportional to
    freedom). CCC §1733: "The more one does what is good, the freer one becomes." -/
axiom s7_teleological_freedom :
  ∀ (a1 a2 : Person),
    directedTowardGood a1 → ¬ directedTowardGood a2 →
    freedomLt (agentFreedom a2) (agentFreedom a1)

/-- Provenance tag for S7. -/
def s7_provenance : Provenance := Provenance.scripture "Jn 8:34-36; Gal 5:1"

/-- **S8. GRACE_NECESSARY_AND_TRANSFORMATIVE**: Without grace, humans cannot
    perform saving good; and grace actually transforms the person (it does not
    merely declare them righteous extrinsically).

    *Source*: John 15:5 ("without me you can do nothing"); 2 Corinthians 5:17
    ("if anyone is in Christ, he is a new creation"); Ezekiel 36:26 ("I will
    give you a new heart and put a new spirit in you"). Multiple passages
    explicitly assert both the necessity of grace and its transformative
    (not merely forensic) character.

    *Grounds*: Grace.lean axioms 20-21 (preparation_requires_prevenient,
    prevenient_grace_unconditioned), Justification.lean axiom 23
    (grace_is_transformative). CCC §1999: "Grace… is a participation in
    the life of God." -/
axiom s8_grace_necessary_and_transformative :
  ∀ (p : Person) (g : Grace),
    graceGiven p g → graceTransforms g p

/-- Provenance tag for S8. -/
def s8_provenance : Provenance := Provenance.scripture "Jn 15:5; 2 Cor 5:17; Ezek 36:26"

/-- **S9. CONSCIENCE_BINDS**: The certain judgment of practical reason about
    the good obliges the agent to follow it; acting against conscience is
    always wrong.

    *Source*: Romans 14:23 ("whatever does not proceed from faith is sin");
    Acts 24:16 ("I strive always to keep my conscience clear before God and
    man"). Paul explicitly grounds the binding force of conscience in the
    obligation to act from conviction.

    *Grounds*: Conscience.lean axioms 15-19 (conscience_always_binds,
    acting_against_conscience_wrong, culpable/innocent ignorance, duty to form
    conscience). CCC §1790: "A human being must always obey the certain judgment
    of his conscience." -/
axiom s9_conscience_binds :
  ∀ (p : Person) (a : Action), conscienceJudges p a → obligated p a

/-- Provenance tag for S9. -/
def s9_provenance : Provenance := Provenance.scripture "Rom 14:23; Acts 24:16"

-- ============================================================================
-- T1-T3: SACRED TRADITION AXIOMS — with Council references (3)
-- ============================================================================

/-- **T1. LIBERTARIAN_FREE_WILL**: Agents can genuinely choose otherwise;
    freedom is not merely the absence of external coercion.

    *Source*: Council of Trent, Session 6, Canon 4: anathema on the claim that
    free will "does nothing whatever and is merely passive." Sirach 15:14-17
    ("It was he who created man in the beginning, and he left him in the power
    of his own inclination") provides scriptural basis, but the distinctively
    *libertarian* (as opposed to compatibilist) reading is a theological
    inference crystallized at Trent.

    *Grounds*: Hell.lean axiom 4 (freedom_is_libertarian), moral responsibility,
    the possibility of self-exclusion from God. CCC §1730: "God created man a
    rational being, conferring on him the dignity of a person who can initiate
    and control his own actions." -/
axiom t1_libertarian_free_will :
  ∀ (a : Person), couldChooseOtherwise a

/-- Provenance tag for T1. -/
def t1_provenance : Provenance := Provenance.tradition "Sir 15:14; Trent Session 6"

/-- **T2. GRACE_PRESERVES_FREEDOM**: Divine initiative and human freedom are
    compatible; grace enables but does not coerce cooperation.

    *Source*: Council of Trent, Session 6, Chapter 5: "Free will, moved and
    excited by God… can reject [grace]." Canon 4: anathema on the claim that
    free will "does nothing whatever and is merely passive." Phil 2:12-13
    ("work out your own salvation with fear and trembling, for it is God who
    works in you") provides the scriptural basis.

    *Grounds*: Grace.lean axiom 22 (divine_initiative_preserves_freedom),
    Justification.lean axiom 24 (human_cooperation_in_justification).
    CCC §2002: "God's free initiative demands man's free response." -/
axiom t2_grace_preserves_freedom :
  ∀ (p : Person) (g : Grace),
    graceGiven p g → (cooperatesWithGrace p g ∨ ¬ cooperatesWithGrace p g)

/-- Provenance tag for T2. -/
def t2_provenance : Provenance := Provenance.tradition "Phil 2:12-13; Trent Session 6"

/-- **T3. SACRAMENTAL_EFFICACY**: Sacraments are effective signs — they confer
    the grace they signify (ex opere operato).

    *Source*: Council of Trent, Session 7, Canon 8: "If anyone says that by
    the said sacraments… grace is not conferred… but that faith alone in the
    divine promise suffices for the obtaining of grace: let him be anathema."
    John 3:5 ("unless one is born of water and the Spirit") and Acts 2:38
    ("be baptized… for the forgiveness of your sins") provide scriptural basis.

    *Grounds*: Justification.lean axiom 25 (baptism_confers_justification).
    CCC §1127: "Celebrated worthily in faith, the sacraments confer the grace
    that they signify." -/
axiom t3_sacramental_efficacy :
  ∀ (s : Sacrament), signifies s → confers s

/-- Provenance tag for T3. -/
def t3_provenance : Provenance := Provenance.tradition "Jn 3:5; Acts 2:38; Trent Session 7"

-- ============================================================================
-- Summary: the complete axiom set with provenance
-- ============================================================================

/-- The 14 base axioms with their provenance tags, for programmatic access.
    Organized 2 Philosophical / 9 Scriptural / 3 Tradition (reclassified from
    the original 5/5/5 split — most assumptions trace to Scripture). -/
def baseAxiomProvenance : List (String × Provenance) :=
  [ ("P2_TWO_TIER_CAUSATION",               p2_provenance)
  , ("P3_EVIL_IS_PRIVATION",                p3_provenance)
  , ("S1_GOD_IS_LOVE",                      s1_provenance)
  , ("S2_UNIVERSAL_SALVIFIC_WILL",          s2_provenance)
  , ("S3_LAW_ON_HEARTS",                    s3_provenance)
  , ("S4_UNIVERSAL_PROVIDENCE",             s4_provenance)
  , ("S5_SIN_SEPARATES",                    s5_provenance)
  , ("S6_MORAL_REALISM",                    s6_provenance)
  , ("S7_TELEOLOGICAL_FREEDOM",             s7_provenance)
  , ("S8_GRACE_NECESSARY_TRANSFORMATIVE",   s8_provenance)
  , ("S9_CONSCIENCE_BINDS",                 s9_provenance)
  , ("T1_LIBERTARIAN_FREE_WILL",            t1_provenance)
  , ("T2_GRACE_PRESERVES_FREEDOM",          t2_provenance)
  , ("T3_SACRAMENTAL_EFFICACY",             t3_provenance)
  ]

-- ============================================================================
-- Denominational tagging: which traditions accept each axiom
-- ============================================================================

/-- Denominational scope of each base axiom.
    This is the key to answering "was Luther right?" — you can see
    exactly which axioms he accepted, rejected, or modified. -/
def axiomDenominationalScope : List (String × DenominationalTag) :=
  [ -- Philosophical: broadly shared (all Christians who engage philosophy)
    ("P2_TWO_TIER_CAUSATION",           ecumenical)         -- Most traditions accept implicitly
  , ("P3_EVIL_IS_PRIVATION",            ecumenical)         -- Augustine shared across traditions
    -- Scriptural: ecumenical (broadly shared)
  , ("S1_GOD_IS_LOVE",                  ecumenical)
  , ("S2_UNIVERSAL_SALVIFIC_WILL",      catholicAndLutheran) -- Calvinists reject (limited atonement)
  , ("S3_LAW_ON_HEARTS",               ecumenical)
  , ("S4_UNIVERSAL_PROVIDENCE",         ecumenical)
  , ("S5_SIN_SEPARATES",               ecumenical)
  , ("S6_MORAL_REALISM",               ecumenical)
  , ("S7_TELEOLOGICAL_FREEDOM",        ecumenical)
  , ("S8_GRACE_NECESSARY_TRANSFORMATIVE",
      catholicOnly)     -- Luther: grace is forensic, not transformative
  , ("S9_CONSCIENCE_BINDS",            ecumenical)
    -- Tradition: denominationally specific
  , ("T1_LIBERTARIAN_FREE_WILL",
      { acceptedBy := [Denomination.catholic], note := "Luther/Calvin reject; emphasize bondage of will" })
  , ("T2_GRACE_PRESERVES_FREEDOM",
      { acceptedBy := [Denomination.catholic], note := "Lutherans: grace is irresistible (monergism)" })
  , ("T3_SACRAMENTAL_EFFICACY",
      catholicOnly)     -- Protestants: sacraments are signs, not causes of grace
  ]

/-- The Lutheran axiom modifications — what Luther changed.
    These are NOT in our axiom base (catlib is Catholic) but we
    document them for ecumenical comparison. -/
def lutheranModifications : List (String × String) :=
  [ ("S8 MODIFIED",  "Grace is forensic (declarative), not transformative — Rom 4:5 'credits righteousness'")
  , ("T1 REPLACED",  "Will is in bondage to sin, not libertarianly free — Rom 7:15 'what I do I do not want to do'")
  , ("T2 REPLACED",  "Grace is monergistic (God alone acts), not synergistic — Eph 2:8-9 'not of works'")
  , ("T3 REJECTED",  "Sacraments are signs of grace received by faith, not causes — rejected ex opere operato")
  , ("ADDED: SOLA_SCRIPTURA", "Scripture alone is the supreme authority — 2 Tim 3:16 'all Scripture is God-breathed'")
  ]

end Catlib
