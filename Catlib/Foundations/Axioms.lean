import Catlib.Foundations.Basic

/-!
# Catlib Foundations: The 15 Base Axioms

Every axiom in the 12 formalization files (44 total) traces back to one of these
15 foundational assumptions, organized into three groups by source:

- **P1-P5**: Philosophical commitments (Aristotle / Aquinas / natural reason)
- **S1-S5**: Scriptural axioms (specific Bible passages under Catholic reading)
- **T1-T5**: Sacred Tradition (Church Fathers, Councils, Magisterium)

This mirrors the Catechism's own epistemology: Scripture, Tradition, and natural
reason are the three pillars on which Catholic doctrine rests.

## Design

Each axiom is:
1. Declared as a Lean `axiom` (an unproven `Prop` or function)
2. Tagged with a `Provenance` value documenting its source
3. Typed using the foundational types from `Basic.lean` where applicable

The 12 formalization files should eventually derive their local axioms from
these 15 rather than declaring them independently.
-/

namespace Catlib

-- ============================================================================
-- Additional foundational types needed by the base axioms
-- ============================================================================

/-- Form — the organizing principle that makes a thing what it is.
    From Aristotle's Metaphysics, adopted by Aquinas (ST I, q.75-76). -/
opaque Form : Type

/-- Matter — the principle of potentiality and individuation.
    From Aristotle's Physics, adopted by Aquinas. -/
opaque Matter : Type

/-- A composite of form and matter. Aristotelian hylomorphism holds that
    every material substance is such a composite. -/
structure Composite where
  form : Form
  matter : Matter

/-- A moral proposition — a claim about what is good, right, or obligatory. -/
opaque MoralProposition : Type

/-- Truth value of a moral proposition, independent of any agent's beliefs. -/
opaque moralTruthValue : MoralProposition → Prop

/-- Accessibility of a moral truth to unaided reason. -/
opaque accessibleToReason : MoralProposition → Prop

/-- The good — the final cause or telos toward which freedom is ordered. -/
opaque TheGood : Type

/-- The degree of freedom an agent possesses (0 = none, higher = more). -/
opaque FreedomDegree : Type

/-- A strict ordering on freedom degrees. -/
opaque freedomLt : FreedomDegree → FreedomDegree → Prop

/-- An agent (a Person who can act). -/
opaque Agent : Type

/-- Whether an agent genuinely could have chosen otherwise in a given situation. -/
opaque couldChooseOtherwise : Agent → Prop

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

/-- Whether a person is in communion with God. -/
opaque inCommunion : Person → Prop

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
-- P1-P5: PHILOSOPHICAL AXIOMS (Aristotle / Aquinas / Natural Reason)
-- ============================================================================

/-- **P1. HYLOMORPHISM**: Every material substance is a composite of form and matter.

    *Source*: Aristotle, Metaphysics VII-IX; Aquinas, ST I q.75-76

    *Grounds*: soul-as-form-of-body (Soul.lean axioms 5-7), the unity of the
    human person, anti-Cartesian dualism. The Catechism presupposes this in
    CCC §365: "The unity of soul and body is so profound that one has to consider
    the soul to be the 'form' of the body." -/
axiom p1_hylomorphism :
  ∀ (f : Form) (m : Matter), ∃ (c : Composite), c.form = f ∧ c.matter = m

/-- Provenance tag for P1. -/
def p1_provenance : Provenance := Provenance.naturalLaw

/-- **P2. MORAL_REALISM**: Moral facts exist independently of opinion and are
    accessible to unaided human reason.

    *Source*: Aristotle, Nicomachean Ethics I; Aquinas, ST I-II q.94

    *Grounds*: natural law theory (NaturalLaw.lean axioms 1-3), the claim that
    moral truths are objective and knowable. CCC §1954: "The natural law…
    is nothing other than the light of understanding placed in us by God." -/
axiom p2_moral_realism :
  ∀ (mp : MoralProposition), moralTruthValue mp → accessibleToReason mp

/-- Provenance tag for P2. -/
def p2_provenance : Provenance := Provenance.naturalLaw

-- Helpers for P3
/-- Whether an agent is directed toward the good. -/
axiom directedTowardGood : Agent → Prop

/-- The freedom degree an agent possesses. -/
axiom agentFreedom : Agent → FreedomDegree

/-- **P3. TELEOLOGICAL_FREEDOM**: Freedom is ordered toward the good; choosing
    evil is a defect that diminishes freedom rather than expressing it.

    *Source*: Aquinas, ST I-II q.1-5 (final causality), q.109 a.2

    *Grounds*: Freedom.lean axioms 10-13 (good increases freedom, evil diminishes
    it, evil possible only in imperfect freedom, responsibility proportional to
    freedom). CCC §1733: "The more one does what is good, the freer one becomes." -/
axiom p3_teleological_freedom :
  ∀ (a1 a2 : Agent),
    directedTowardGood a1 → ¬ directedTowardGood a2 →
    freedomLt (agentFreedom a2) (agentFreedom a1)

/-- Provenance tag for P3. -/
def p3_provenance : Provenance := Provenance.naturalLaw

/-- **P4. LIBERTARIAN_FREE_WILL**: Agents can genuinely choose otherwise;
    freedom is not merely the absence of external coercion.

    *Source*: Aquinas, ST I q.83; the Catholic tradition's rejection of hard
    determinism and strict compatibilism.

    *Grounds*: Hell.lean axiom 4 (freedom_is_libertarian), moral responsibility,
    the possibility of self-exclusion from God. CCC §1730: "God created man a
    rational being, conferring on him the dignity of a person who can initiate
    and control his own actions." -/
axiom p4_libertarian_free_will :
  ∀ (a : Agent), couldChooseOtherwise a

/-- Provenance tag for P4. -/
def p4_provenance : Provenance := Provenance.naturalLaw

/-- **P5. TWO_TIER_CAUSATION**: Primary (divine) and secondary (creaturely)
    causes operate on different levels and do not compete — more divine action
    does not mean less creaturely action, and vice versa.

    *Source*: Aquinas, ST I q.105 a.5; the principle of non-contrastive
    transcendence.

    *Grounds*: Providence.lean axiom 8 (primary_secondary_non_competing),
    creaturely causation is genuine (Providence.lean axiom 42). CCC §306:
    "God grants his creatures not only their existence, but also the dignity
    of acting on their own." -/
axiom p5_two_tier_causation :
  ∀ (p : PrimaryCause) (s : SecondaryCause), ¬ causesCompete p s

/-- Provenance tag for P5. -/
def p5_provenance : Provenance := Provenance.naturalLaw

-- ============================================================================
-- S1-S5: SCRIPTURAL AXIOMS (Bible passages under Catholic reading)
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
  ∀ (p : Person) (s : Sin), isGraveSin s → s.action.agent = p → ¬ inCommunion p

/-- Provenance tag for S5. -/
def s5_provenance : Provenance := Provenance.scripture "1 Jn 3:14-15; Rom 6:23"

-- ============================================================================
-- T1-T5: SACRED TRADITION AXIOMS (Councils, Church Fathers, Magisterium)
-- ============================================================================

/-- **T1. GRACE_NECESSARY_AND_TRANSFORMATIVE**: Without grace, humans cannot
    perform saving good; and grace actually transforms the person (it does not
    merely declare them righteous extrinsically).

    *Source*: Second Council of Orange (529 AD), Canon 7: "If anyone affirms
    that we can… do anything good pertaining to salvation… without the
    illumination and inspiration of the Holy Spirit… he is deceived."
    Council of Trent, Session 6, Canon 11: anathema on forensic-only
    justification.

    *Grounds*: Grace.lean axioms 20-21 (preparation_requires_prevenient,
    prevenient_grace_unconditioned), Justification.lean axiom 23
    (grace_is_transformative). CCC §1999: "Grace… is a participation in
    the life of God." -/
axiom t1_grace_necessary_and_transformative :
  ∀ (p : Person) (g : Grace),
    graceGiven p g → graceTransforms g p

/-- Provenance tag for T1. -/
def t1_provenance : Provenance := Provenance.tradition "Orange 529 AD, Canon 7; Trent Session 6, Canon 11"

/-- **T2. GRACE_PRESERVES_FREEDOM**: Divine initiative and human freedom are
    compatible; grace enables but does not coerce cooperation.

    *Source*: Council of Trent, Session 6, Chapter 5: "Free will, moved and
    excited by God… can reject [grace]." Canon 4: anathema on the claim that
    free will "does nothing whatever and is merely passive."

    *Grounds*: Grace.lean axiom 22 (divine_initiative_preserves_freedom),
    Justification.lean axiom 24 (human_cooperation_in_justification).
    CCC §2002: "God's free initiative demands man's free response." -/
axiom t2_grace_preserves_freedom :
  ∀ (p : Person) (g : Grace),
    graceGiven p g → (cooperatesWithGrace p g ∨ ¬ cooperatesWithGrace p g)

/-- Provenance tag for T2. -/
def t2_provenance : Provenance := Provenance.tradition "Trent Session 6, Chapter 5 & Canon 4"

/-- **T3. SACRAMENTAL_EFFICACY**: Sacraments are effective signs — they confer
    the grace they signify (ex opere operato).

    *Source*: Council of Trent, Session 7, Canon 8: "If anyone says that by
    the said sacraments… grace is not conferred… but that faith alone in the
    divine promise suffices for the obtaining of grace: let him be anathema."

    *Grounds*: Justification.lean axiom 25 (baptism_confers_justification).
    CCC §1127: "Celebrated worthily in faith, the sacraments confer the grace
    that they signify." -/
axiom t3_sacramental_efficacy :
  ∀ (s : Sacrament), signifies s → confers s

/-- Provenance tag for T3. -/
def t3_provenance : Provenance := Provenance.tradition "Trent Session 7, Canon 8"

/-- **T4. CONSCIENCE_BINDS**: The certain judgment of practical reason about
    the good obliges the agent to follow it; acting against conscience is
    always wrong.

    *Source*: Aquinas, De Veritate q.17 a.3; ST I-II q.19 a.5 ("Every will
    at variance with reason… is always evil"). Vatican II, Dignitatis Humanae §3.

    *Grounds*: Conscience.lean axioms 15-19 (conscience_always_binds,
    acting_against_conscience_wrong, culpable/innocent ignorance, duty to form
    conscience). CCC §1790: "A human being must always obey the certain judgment
    of his conscience." -/
axiom t4_conscience_binds :
  ∀ (p : Person) (a : Action), conscienceJudges p a → obligated p a

/-- Provenance tag for T4. -/
def t4_provenance : Provenance := Provenance.tradition "Aquinas ST I-II q.19 a.5; Vatican II DH §3"

/-- **T5. EVIL_IS_PRIVATION**: Evil is not a positive reality but the absence
    of a due good — a privation, not a substance.

    *Source*: Augustine, Confessions VII.12 ("Evil has no existence except as
    a privation of good"); Aquinas, ST I q.48 a.1 and q.49.

    *Grounds*: Providence.lean axiom 29 (causation_asymmetry), axiom 40
    (god_not_cause_of_evil). CCC §311: "God is in no way, directly or
    indirectly, the cause of moral evil." -/
axiom t5_evil_is_privation :
  ∀ (e : Prop), isEvil e → isDueGoodAbsent e

/-- Provenance tag for T5. -/
def t5_provenance : Provenance := Provenance.tradition "Augustine Confessions VII.12; Aquinas ST I q.48-49"

-- ============================================================================
-- Summary: the complete axiom set with provenance
-- ============================================================================

/-- The 15 base axioms with their provenance tags, for programmatic access. -/
def baseAxiomProvenance : List (String × Provenance) :=
  [ ("P1_HYLOMORPHISM",                     p1_provenance)
  , ("P2_MORAL_REALISM",                    p2_provenance)
  , ("P3_TELEOLOGICAL_FREEDOM",             p3_provenance)
  , ("P4_LIBERTARIAN_FREE_WILL",            p4_provenance)
  , ("P5_TWO_TIER_CAUSATION",               p5_provenance)
  , ("S1_GOD_IS_LOVE",                      s1_provenance)
  , ("S2_UNIVERSAL_SALVIFIC_WILL",          s2_provenance)
  , ("S3_LAW_ON_HEARTS",                    s3_provenance)
  , ("S4_UNIVERSAL_PROVIDENCE",             s4_provenance)
  , ("S5_SIN_SEPARATES",                    s5_provenance)
  , ("T1_GRACE_NECESSARY_TRANSFORMATIVE",   t1_provenance)
  , ("T2_GRACE_PRESERVES_FREEDOM",          t2_provenance)
  , ("T3_SACRAMENTAL_EFFICACY",             t3_provenance)
  , ("T4_CONSCIENCE_BINDS",                 t4_provenance)
  , ("T5_EVIL_IS_PRIVATION",               t5_provenance)
  ]

end Catlib
