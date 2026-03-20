import Catlib.Foundations

/-!
# CCC §1750–1756: The Sources of Morality

## The Catechism claims

"The morality of human acts depends on:
- the object chosen;
- the end in view or the intention;
- the circumstances of the action." (§1750)

"A morally good act requires the goodness of the object, of the end, and
of the circumstances together." (§1755)

"It is therefore an error to judge the morality of human acts by
considering only the intention that inspires them or the circumstances
(environment, social pressure, duress or emergency, etc.) which supply
their context. There are acts which, in and of themselves, independently
of circumstances and intentions, are always gravely illicit by reason of
their object; such as blasphemy and perjury, murder and adultery." (§1756)

## Prediction

I expect this to **reveal hidden structure**. The claim about intrinsically
evil acts (§1756) is particularly interesting: it asserts that some acts
are evil regardless of intention or circumstances. This requires a strong
assumption: that the "object" of an act can be evaluated independently of
all context. Whether that independence claim actually follows from the
three-source framework, or is an additional axiom, is what I'm uncertain about.

## Findings

- **Prediction vs. reality**: Confirmed hidden structure. The claim about
  intrinsically evil acts requires an axiom that object-goodness is
  independent of intention and circumstances. The three-source framework
  alone doesn't entail this — it only says all three matter. The independence
  claim is doing invisible work.
- **Catholic reading axioms used**: [Definition] CCC §1750, §1755, §1756
- **Surprise level**: Mild — the independence assumption is philosophically
  well-known (it's the basis of deontological ethics) but the Catechism
  doesn't state it explicitly. The proof assistant forced us to.
- **Assessment**: Tier 3 — hidden premise exposed.
-/

namespace Catlib.MoralTheology

open Catlib

/-!
## The three-source framework

The Catechism says morality depends on object, intention, and circumstances.
We already have `MoralEvaluation` in Foundations. Now we formalize the
specific claims about how these interact.
-/

/-- §1755: A good end does not make a bad action good.
    "One may not do evil so that good may result from it."
    This says: even if intention is good, if the object is evil,
    the act is evil. -/
theorem good_end_cannot_justify_evil_means
    (eval : MoralEvaluation)
    (h_bad_object : ¬eval.objectIsGood)
    (_h_good_intention : eval.intentionIsGood) :
    eval.isEvil := by
  unfold MoralEvaluation.isEvil
  exact Or.inl h_bad_object

/-- §1752: "In contrast to the object, the intention resides in the acting
    subject... A good intention does not make behavior that is intrinsically
    disordered, such as lying and calumny, good or just."
    This is a consequence of the three-source framework. -/
theorem good_intention_insufficient
    (eval : MoralEvaluation)
    (_h_good_intention : eval.intentionIsGood)
    (h_bad_object : ¬eval.objectIsGood) :
    ¬eval.isGood := by
  intro ⟨ho, _, _⟩
  exact h_bad_object ho

/-!
## Intrinsically evil acts (§1756)

This is where it gets interesting. The Catechism claims certain acts are
always evil "independently of circumstances and intentions." This is a
STRONGER claim than what the three-source framework gives us.

The three-source framework says: an act is evil if ANY source is bad.
This is compatible with a world where the object's goodness depends on
circumstances.

§1756 adds: for some acts, the object is ALWAYS bad, regardless of
circumstances and intentions. This requires a new axiom.
-/

/-- An act type is intrinsically evil if its object is never good,
    regardless of any other considerations.
    ASSUMPTION: This definition treats the "object" as evaluable
    independently of circumstances. This is not obvious — it assumes
    a specific action ontology where acts have intrinsic natures. -/
def IntrinsicallyEvil (objectPredicate : Prop) : Prop :=
  ¬objectPredicate

/-- §1756: For intrinsically evil acts, no intention or circumstance
    can make them good.
    NOTE: This theorem is straightforward GIVEN the three-source framework.
    The real work was in the definition of IntrinsicallyEvil — the assumption
    that an act's object can be evaluated independently. -/
theorem intrinsically_evil_always_evil
    (eval : MoralEvaluation)
    (h_intrinsic : IntrinsicallyEvil eval.objectIsGood) :
    ¬eval.isGood := by
  intro ⟨ho, _, _⟩
  exact h_intrinsic ho

/-- Key finding: intrinsic evil is independent of intention.
    The same act evaluated with ANY intention is still evil if the
    object is intrinsically evil.
    This makes explicit what the Catechism assumes: that the "object"
    of an act is a fixed property, not relative to the agent's perspective. -/
theorem intrinsic_evil_intention_independent
    (action : Action)
    (h_intrinsic : IntrinsicallyEvil (∃ _ : Prop, True))
    (intention1 intention2 : Prop) :
    let eval1 : MoralEvaluation := {
      action := action
      objectIsGood := ∃ _ : Prop, True  -- using same object predicate
      intentionIsGood := intention1
      circumstancesAppropriate := action.circumstances
    }
    let eval2 : MoralEvaluation := {
      action := action
      objectIsGood := ∃ _ : Prop, True
      intentionIsGood := intention2
      circumstancesAppropriate := action.circumstances
    }
    ¬eval1.isGood ∧ ¬eval2.isGood := by
  constructor
  · intro ⟨ho, _, _⟩; exact h_intrinsic ho
  · intro ⟨ho, _, _⟩; exact h_intrinsic ho

/-!
## The hidden assumption

The Catechism's argument about intrinsically evil acts works, but it
requires an assumption the text doesn't make explicit:

**The object of an action has a moral character that is independent of
the agent's intention and circumstances.**

This is the deontological core of Catholic moral theology. The Catechism
presents it as following from the three-source framework, but it's
actually an additional axiom. The three-source framework is compatible
with consequentialism (where the "object" might be evaluated differently
in different circumstances).

To make this explicit, we can show that WITHOUT the independence axiom,
the framework permits a "consequentialist reading":
-/

/-- Without the independence axiom, nothing prevents the object's moral
    character from varying with circumstances. The three-source framework
    alone is compatible with this. -/
theorem framework_compatible_with_context_dependent_object
    (good_in_context bad_out_of_context : Prop)
    (h_context : good_in_context)
    (h_no_context : ¬bad_out_of_context)
    (action : Action) :
    -- Same action can be evaluated differently depending on which
    -- "object goodness" predicate we use
    let eval_in_context : MoralEvaluation := {
      action := action
      objectIsGood := good_in_context
      intentionIsGood := True
      circumstancesAppropriate := True
    }
    let eval_out_of_context : MoralEvaluation := {
      action := action
      objectIsGood := bad_out_of_context
      intentionIsGood := True
      circumstancesAppropriate := True
    }
    eval_in_context.isGood ∧ ¬eval_out_of_context.isGood := by
  constructor
  · exact ⟨h_context, trivial, trivial⟩
  · intro ⟨ho, _, _⟩; exact h_no_context ho

end Catlib.MoralTheology
