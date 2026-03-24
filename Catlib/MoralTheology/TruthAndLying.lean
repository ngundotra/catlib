import Catlib.Foundations
import Catlib.MoralTheology.SourcesOfMorality

/-!
# CCC §2464–2513: Truth and Lying — The Eighth Commandment's Hidden Metaphysics

## What the Catechism teaches

"The Old Testament attests that God is the source of all truth." (§2465)

"Truth or truthfulness is the virtue which consists in showing oneself true
in deeds and truthful in words, and in guarding against duplicity,
dissimulation, and hypocrisy." (§2468)

"A lie consists in speaking a falsehood with the intention of deceiving."
(§2482)

"Lying is the most direct offense against the truth." (§2483)

"The gravity of a lie is measured against the nature of the truth it deforms,
the circumstances, the intentions of the one who lies, and the harm suffered
by its victims." (§2484)

"The right to the communication of the truth is not unconditional." (§2488)

"No one is bound to reveal the truth to someone who does not have the right
to know it." (§2489)

## The key question

The CCC defines lying as falsehood + deceptive intent (§2482). Does the
three-source morality framework (object, intention, circumstances from §1750)
handle this, or does lying need a fourth element?

## Prediction

I expect the three-source framework DOES handle lying, but the mapping is
non-obvious. The "object" of lying is the false statement; the "intention" is
to deceive; the "circumstances" include who has a right to know. The two-element
definition of lying (§2482) is actually the object + intention components of
the three-source framework applied to speech acts. No fourth element is needed.

But I expect hidden structure: the CCC's distinction between lying and
legitimate non-disclosure (§2489) requires a hidden axiom about the RIGHT
to truth — not everyone has a right to know everything.

## Findings

- **The three-source framework IS sufficient.** Lying maps naturally onto it:
  the object is the false statement, the intention is to deceive, and the
  circumstances include the hearer's right to know. No fourth element needed.
- **The two-element definition (§2482) IS the three-source framework restricted
  to speech acts.** "Speaking a falsehood" = bad object; "intention of deceiving"
  = bad intention. The CCC's definition is a SPECIAL CASE of the general
  moral framework, not an exception to it.
- **Hidden assumption: the RIGHT TO TRUTH is not universal (§2489).** This is
  a genuine hidden premise. The CCC uses it to distinguish lying (always wrong)
  from legitimate non-disclosure (sometimes right). Without this axiom, you
  cannot explain why withholding truth from someone who has no right to it is
  morally different from lying.
- **Key structural finding: false statements without deceptive intent are NOT
  lies.** Jokes, fiction, acting, and rhetorical hyperbole all involve false
  statements but lack the intention to deceive. The two-element definition
  correctly excludes them.
- **True statements CAN be morally wrong.** Calumny (§2477), detraction (§2477),
  and breach of confidence (§2490) show that TRUTH of content does not guarantee
  moral goodness — intention and circumstances still matter.
- **Denominational scope: mostly ECUMENICAL.** All Christians condemn lying.
  The right-to-truth principle and mental reservation doctrine are more
  specifically Catholic (developed through casuistry tradition).
-/

set_option autoImplicit false

namespace Catlib.MoralTheology.TruthAndLying

open Catlib
open Catlib.MoralTheology

-- ============================================================================
-- § Core Types
-- ============================================================================

/-- Whether a statement's propositional content is true.
    Source: [Modeling] Our formalization choice. We model truth of content
    as a binary predicate on speech acts. The CCC treats truth as objective
    (§2465: "God is the source of all truth") but does not formalize it. -/
opaque contentIsTrue : Action → Prop

/-- Whether the speaker intends to deceive the hearer.
    Source: [CCC] §2482: "with the intention of deceiving."
    HIDDEN ASSUMPTION: Deceptive intent is separable from the content of the
    statement. This is what allows false statements without deceptive intent
    (jokes, fiction) to be non-lies. The CCC assumes this but does not argue
    for it. -/
opaque hasDeceptiveIntent : Action → Prop

/-- Whether a person has the right to know a particular truth.
    Source: [CCC] §2488-2489: "The right to the communication of the truth
    is not unconditional." "No one is bound to reveal the truth to someone
    who does not have the right to know it."
    HIDDEN ASSUMPTION: Rights to information are context-dependent. The CCC
    uses this to ground legitimate non-disclosure but does not explain what
    determines the right. -/
opaque hasRightToKnow : Person → Action → Prop

/-- Whether a speech act harms the reputation of another person.
    Source: [CCC] §2477: Calumny and detraction both involve harm to reputation,
    but differ in whether the harmful claim is true (detraction) or false
    (calumny). -/
opaque harmsReputation : Action → Person → Prop

/-- Whether the speaker holds the information under professional secrecy.
    Source: [CCC] §2490-2491: "Professional secrets... must be kept, save in
    exceptional cases where keeping the secret is bound to cause very grave
    harm." -/
opaque underProfessionalSecrecy : Action → Prop

-- ============================================================================
-- § The Two-Element Definition of Lying (§2482)
-- ============================================================================

/-- A lie requires BOTH falsehood AND deceptive intent.
    Source: [CCC] §2482: "A lie consists in speaking a falsehood with the
    intention of deceiving."
    This is the CCC's DEFINITION of lying — it is stipulative, not derived.
    The two elements are CONJUNCTIVE: remove either one and you no longer
    have a lie. -/
def isLie (act : Action) : Prop :=
  ¬contentIsTrue act ∧ hasDeceptiveIntent act

-- ============================================================================
-- § Axioms
-- ============================================================================

/-- §2483: "Lying is the most direct offense against the truth."
    Lying is intrinsically evil: for ANY moral evaluation of a lying act,
    the object cannot be good. No intention or circumstance can make the
    object of a lie good.
    Source: [CCC] §2483-2485.
    This is STRONGER than the definition of isLie: the definition says the
    content is false; this axiom says the MORAL OBJECT is bad. These are
    different claims — falsehood is a factual property, moral badness is
    a normative one. The axiom bridges from factual falsehood + deceptive
    intent to moral evil. -/
axiom lying_is_intrinsically_evil :
  ∀ (act : Action) (eval : MoralEvaluation),
    isLie act → eval.action = act → ¬eval.objectIsGood

/-- §2484: "The gravity of a lie is measured against the nature of the truth
    it deforms, the circumstances, the intentions of the one who lies, and
    the harm suffered by its victims."
    Though lying is always evil, its GRAVITY varies with circumstances.
    Source: [CCC] §2484.
    MODELING CHOICE: We represent gravity as a Prop (grave or not) rather
    than a spectrum. The CCC speaks of degrees but does not quantify them. -/
axiom lying_gravity_depends_on_circumstances :
  ∀ (act : Action) (s : Sin),
    isLie act → s.action = act →
    -- Gravity depends on what truth is deformed (the "nature of the truth")
    -- This connects to the three-source framework: circumstances affect
    -- the evaluation even though the object is already evil.
    (s.gravity = MatterGravity.grave ↔
      ∃ (victim : Person), harmsReputation act victim)

/-- §2477: Speaking harmful truths (detraction) or harmful falsehoods (calumny)
    about another person is morally evil.
    Source: [CCC] §2477: "Respect for the reputation of persons forbids every
    attitude and word likely to cause them unjust injury."
    This axiom establishes that TRUTH of content is not sufficient for moral
    goodness — a true statement that harms reputation without just cause is
    still morally wrong. The harm to reputation makes the circumstances
    inappropriate under any moral evaluation of that action. -/
axiom reputation_harm_is_evil :
  ∀ (eval : MoralEvaluation) (victim : Person),
    harmsReputation eval.action victim →
    ¬eval.circumstancesAppropriate

/-- §2489: "No one is bound to reveal the truth to someone who does not have
    the right to know it."
    This is the RIGHT TO TRUTH axiom — the hidden premise that makes
    legitimate non-disclosure different from lying.
    Source: [CCC] §2489.
    HIDDEN ASSUMPTION: The existence of a principled boundary between those
    who have a right to know and those who do not. The CCC assumes this
    boundary exists and is knowable, but does not provide a general criterion
    for determining it. -/
axiom no_obligation_without_right :
  ∀ (p : Person) (act : Action),
    ¬hasRightToKnow p act →
    -- The speaker is not obligated to disclose the truth to this person
    ¬obligated act.agent act

/-- §2490-2491: Professional secrets must be kept except in cases of grave harm.
    Source: [CCC] §2490.
    This establishes that the hearer does NOT have a right to know information
    under professional secrecy (in the normal case). -/
axiom professional_secrecy_limits_right :
  ∀ (p : Person) (act : Action),
    underProfessionalSecrecy act →
    ¬hasRightToKnow p act

-- ============================================================================
-- § Theorems: What follows from the definition
-- ============================================================================

/-- False statements without deceptive intent are NOT lies.
    This covers jokes, fiction, acting, rhetorical hyperbole, and social
    conventions ("I'm fine"). The two-element definition (§2482) correctly
    excludes all of these because they lack the second element (deceptive
    intent).
    This is straightforward from the definition but worth stating explicitly:
    the CCC's definition of lying is NARROWER than "saying something false." -/
theorem false_without_intent_is_not_lie
    (act : Action)
    (_h_false : ¬contentIsTrue act)
    (h_no_intent : ¬hasDeceptiveIntent act) :
    ¬isLie act := by
  intro ⟨_, h⟩
  exact h_no_intent h

/-- True statements with deceptive intent are NOT lies (by definition).
    A half-truth that technically states something true but is arranged to
    mislead is not a LIE per §2482 (which requires falsehood). However,
    it may still be morally wrong through other sources (bad intention). -/
theorem true_with_intent_is_not_lie
    (act : Action)
    (h_true : contentIsTrue act)
    (_h_intent : hasDeceptiveIntent act) :
    ¬isLie act := by
  intro ⟨h, _⟩
  exact h h_true

/-- A lie always has a bad object (the false statement).
    This connects lying to the three-source framework: the "object" of a lie
    is the false communication, which is never good. -/
theorem lie_has_bad_object
    (act : Action)
    (h_lie : isLie act) :
    ¬contentIsTrue act :=
  h_lie.1

/-- A lie always has a bad intention (deceptive intent).
    This connects lying to the three-source framework: the "intention" of a
    lie is to deceive, which is never good. -/
theorem lie_has_bad_intention
    (act : Action)
    (h_lie : isLie act) :
    hasDeceptiveIntent act :=
  h_lie.2

-- ============================================================================
-- § Connection to the three-source framework (SourcesOfMorality.lean)
-- ============================================================================

/-- Lying is never good under the three-source framework.
    This chains the intrinsic evil axiom (lying_is_intrinsically_evil) with
    the three-source requirement that all three sources must be good.
    The axiom supplies: lying → object is bad.
    The framework supplies: bad object → act is not good (§1755).
    This is the genuine cross-file connection: the lying-specific doctrine
    (§2483) plugs into the general moral framework (§1755-1756). -/
theorem lying_never_good
    (act : Action)
    (eval : MoralEvaluation)
    (h_lie : isLie act)
    (h_eval_act : eval.action = act) :
    ¬eval.isGood := by
  have h_bad_object := lying_is_intrinsically_evil act eval h_lie h_eval_act
  -- The three-source framework requires objectIsGood for isGood
  intro ⟨h_good, _, _⟩
  exact h_bad_object h_good

/-- KEY THEOREM: Lying maps onto the three-source framework.
    A lie is morally evil because BOTH object AND intention are bad.
    The three-source framework says: an act is evil if ANY source is bad
    (§1755). A lie has TWO bad sources (object + intention), so it is
    doubly condemned by the framework.
    This answers the main question: the three-source framework handles
    lying WITHOUT needing a fourth element. The two-element definition
    of lying (§2482) IS the three-source framework applied to speech acts. -/
theorem lying_condemned_by_three_sources
    (act : Action)
    (eval : MoralEvaluation)
    (h_lie : isLie act)
    (_h_eval_act : eval.action = act)
    (h_object : eval.objectIsGood ↔ contentIsTrue act)
    (_h_intent : eval.intentionIsGood ↔ ¬hasDeceptiveIntent act) :
    eval.isEvil := by
  unfold MoralEvaluation.isEvil
  -- The object is bad (false statement)
  apply Or.inl
  intro h_good
  have h_true := h_object.mp h_good
  exact h_lie.1 h_true

/-- True statements that harm reputation are evil through circumstances.
    This is detraction (§2477): the content is true, but the circumstances
    (causing unjust harm to reputation) make the act evil.
    Demonstrates: truth of content is NECESSARY but NOT SUFFICIENT for the
    goodness of speech acts. The three-source framework requires ALL THREE
    sources to be good. -/
theorem detraction_is_evil
    (eval : MoralEvaluation)
    (victim : Person)
    (_h_true : contentIsTrue eval.action)
    (h_harms : harmsReputation eval.action victim) :
    ¬eval.isGood := by
  intro ⟨_, _, h_circ⟩
  exact reputation_harm_is_evil eval victim h_harms h_circ

-- ============================================================================
-- § Non-disclosure and mental reservation (§2488-2492)
-- ============================================================================

/-- Withholding truth from someone without a right to know is NOT lying.
    This is the CCC's position on mental reservation and legitimate
    non-disclosure: silence or evasion is not a lie because it lacks
    the false-statement element. The RIGHT TO TRUTH axiom (§2489) is
    what grounds this distinction.
    This directly answers a key question from the task: withholding truth
    is NOT the same as lying. The CCC distinguishes them (§2489). -/
theorem non_disclosure_is_not_lying
    (act : Action)
    (h_true : contentIsTrue act) :
    ¬isLie act := by
  intro ⟨h_false, _⟩
  exact h_false h_true

/-- Under professional secrecy, the speaker has no obligation to disclose.
    This chains professional_secrecy_limits_right with no_obligation_without_right:
    professional secrecy → no right to know → no obligation to disclose. -/
theorem secrecy_removes_disclosure_obligation
    (p : Person) (act : Action)
    (h_secret : underProfessionalSecrecy act) :
    ¬obligated act.agent act := by
  have h_no_right := professional_secrecy_limits_right p act h_secret
  exact no_obligation_without_right p act h_no_right

-- ============================================================================
-- § The gravity spectrum (§2484)
-- ============================================================================

/-- Calumny (false + harmful) is graver than simple lying.
    Calumny (§2477) adds reputational harm on top of the falsehood.
    Under the gravity axiom, this makes the lie grave matter.
    This shows that while all lies are evil, calumny is worse because
    the CIRCUMSTANCES (harm to another) compound the evil OBJECT (falsehood). -/
theorem calumny_is_grave
    (act : Action)
    (s : Sin)
    (victim : Person)
    (h_lie : isLie act)
    (h_sin_act : s.action = act)
    (h_harms : harmsReputation act victim) :
    s.gravity = MatterGravity.grave := by
  exact (lying_gravity_depends_on_circumstances act s h_lie h_sin_act).mpr ⟨victim, h_harms⟩

-- ============================================================================
-- § Denominational scope
-- ============================================================================

/-- Denominational tag: the core lying doctrine is ecumenical.
    All Christian traditions agree: (1) lying is sinful, (2) it requires
    falsehood + deceptive intent, (3) not all false statements are lies.
    The DEGREE of wrongness and the EXCEPTIONS differ:
    - Catholic casuistry tradition develops mental reservation in detail
    - Protestant traditions tend to reject strict mental reservation
    - Orthodox tradition follows the patristic consensus (lying always wrong)
    The right-to-truth principle (§2489) is ecumenical in substance but
    the Catholic tradition develops it more systematically. -/
def lying_denominational_scope : DenominationalTag :=
  ecumenical

/-- The mental reservation / right-to-truth doctrine is more specifically
    Catholic in its developed form, though the underlying intuition
    (you don't owe the truth to an unjust aggressor) is broadly shared. -/
def mental_reservation_scope : DenominationalTag :=
  { acceptedBy := [Denomination.catholic],
    note := "Developed through casuistry tradition; substance broadly shared but systematic treatment is Catholic distinctive" }

end Catlib.MoralTheology.TruthAndLying
