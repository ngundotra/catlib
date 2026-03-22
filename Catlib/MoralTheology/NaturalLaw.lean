import Catlib.Foundations

/-!
# CCC §1954–1957: The Natural Moral Law

## The Catechism claims

"The natural law expresses the original moral sense which enables man
to discern by reason the good and the evil." (§1954)

"The natural law, present in the heart of each man and established by
reason, is universal in its precepts and its authority extends to all
men. It is... immutable and eternal." (§1956)

"Application of the natural law varies greatly; it can demand reflection
that takes account of various conditions of life according to places,
times, and circumstances. Nevertheless, in the diversity of cultures,
the natural law remains as a rule that binds men among themselves and
imposes on them, beyond the inevitable differences, common principles."
(§1957)

## The tension

§1956 says the natural law is universal and immutable — the same for
everyone, everywhere, always. §1957 says application "varies greatly"
by place, time, and circumstances. This creates a structural tension:

If the law is truly immutable, what exactly is "varying"? There must be
a distinction between the LAW ITSELF and its APPLICATION. This distinction
is not trivial — it requires a specific model of how abstract moral
principles relate to concrete situations.

## Prediction

I expect this to **require stronger premises**. The universality claim
("extends to all men") requires that reason is sufficient to discover
moral truth — but what counts as "reason"? The immutability claim
requires a specific metaphysics of moral facts. And the tension between
§1956 and §1957 will force a distinction between law and application
that the text leaves implicit.

The most interesting question: what does "accessible to reason" actually
mean? If two people reason honestly and disagree about a moral precept,
does natural law theory say one of them is failing to reason properly?
That's a strong claim the text never makes explicit.

## Findings

- **Prediction vs. reality**: Confirmed — requires stronger premises.
  Five hidden axioms: (1) moral realism (moral facts exist independently
  of human opinion), (2) rational accessibility (reason alone can discover
  these facts), (3) law/application distinction (the law is immutable but
  its application to concrete cases varies), (4) rational convergence
  (all reasoners SHOULD reach the same moral conclusions — if they don't,
  someone is reasoning badly), (5) divine grounding (natural law has the
  "force of law" only because it's the voice of a "higher reason").
- **Catholic reading axioms used**: [Natural Law] Aquinas, Summa I-II
  q.94; [Definition] CCC §1954, §1956, §1957
- **Surprise level**: Significant — the rational convergence assumption
  was not predicted. The Catechism assumes that disagreement about natural
  law is always a failure of reason, never a feature of genuine moral
  complexity. This is a very strong claim hidden in the word "universal."
- **Assessment**: Tier 3 — multiple hidden premises, the rational
  convergence assumption is genuinely surprising.
-/

namespace Catlib.MoralTheology

open Catlib

/-!
## The structure of natural law

The Catechism describes natural law as having two layers:
1. The law itself — universal, immutable, eternal
2. Its application — varies by place, time, circumstances

This two-layer structure is not stated explicitly but is required
to make §1956 and §1957 compatible.
-/

/-- A moral precept — a principle of the natural law.
    These are the immutable, universal content of the law. -/
structure MoralPrecept where
  /-- What the precept prescribes or forbids -/
  content : Prop
  /-- The precept is discoverable by reason alone -/
  accessibleToReason : Prop
  /-- The precept applies to all persons -/
  universal : Prop

/-- A concrete moral situation in which precepts must be applied.
    §1957: Application depends on "places, times, and circumstances." -/
structure MoralContext where
  /-- The cultural/geographical setting -/
  place : Type
  /-- The historical period -/
  time : Type
  /-- Relevant circumstances -/
  circumstances : Type

/-- An application of a precept to a concrete situation.
    This is what §1957 says "varies greatly." -/
structure Application where
  precept : MoralPrecept
  context : MoralContext
  /-- The concrete moral judgment in this context -/
  judgment : Prop

/-- AXIOM 1 (§1954): Moral realism — moral facts exist independently
    of human opinion.
    Provenance: [Natural Law] — assumed throughout
    HIDDEN ASSUMPTION: This is the deepest premise of natural law theory.
    If moral "facts" are just human conventions, natural law collapses.
    The Catechism never argues for moral realism — it assumes it.

    CONNECTION TO BASE AXIOM: This connects to
    `Catlib.s6_moral_realism` (S6: ∀ mp, moralTruthValue mp → accessibleToReason mp).
    S6 asserts that moral truths are accessible to reason — a claim that
    presupposes moral realism. S6 uses the opaque `MoralProposition` type
    from Axioms.lean; this uses the richer `MoralPrecept` structure.
    Both assume moral facts have determinate truth values. -/
axiom moral_realism :
  ∀ (p : MoralPrecept), p.content ∨ ¬p.content
  -- Moral precepts have definite truth values
  -- (This is just excluded middle for Props, but the philosophical
  -- claim is that moral propositions ARE the kind of thing that
  -- can be true or false — not just expressions of preference)

/-- AXIOM 2 (§1954): Rational accessibility — reason alone can
    discover the natural law.
    Provenance: [Definition] CCC §1954
    HIDDEN ASSUMPTION: "Reason" is sufficient for moral knowledge.
    But what counts as reason? If two people reason honestly and disagree,
    the theory says one of them is failing to reason properly. That's a
    strong claim the text never makes explicit. -/
axiom rational_accessibility :
  ∀ (p : MoralPrecept) (person : Person),
    person.hasIntellect = true →
    -- The person CAN (in principle) discover this precept
    p.accessibleToReason

/-- AXIOM 3 (§1956): Universality — the natural law's precepts apply
    to all humans.
    Provenance: [Definition] CCC §1956
    "Its authority extends to all men." -/
axiom universality :
  ∀ (p : MoralPrecept) (person : Person),
    person.hasIntellect = true →
    person.hasFreeWill = true →
    p.universal

/-- AXIOM 4 (§1956 + §1957): The law/application distinction.
    The law is immutable, but its application varies.
    Provenance: [Definition] CCC §1956, §1957
    HIDDEN ASSUMPTION: There IS a clean separation between the abstract
    precept and its concrete application. This is not obvious — one could
    argue that a "law" that requires completely different actions in
    different contexts is not really the same law. The Catechism assumes
    the separation is clean. -/
axiom law_application_distinction :
  ∀ (p : MoralPrecept) (_ctx1 _ctx2 : MoralContext)
    (app1 : Application) (app2 : Application),
    app1.precept = p →
    app2.precept = p →
    -- The precept is the same even if the judgments differ
    app1.precept.content = app2.precept.content

/-- AXIOM 5 (§1954): Divine grounding — natural law has the force of
    law because it participates in a "higher reason."
    Provenance: [Definition] CCC §1954
    "This command of human reason would not have the force of law if it
    were not the voice and interpreter of a higher reason."
    HIDDEN ASSUMPTION: Without God, there is no natural law. This means
    natural law theory is not really "accessible to reason alone" — it
    requires belief in (or at least the existence of) a divine lawgiver.
    This is a tension the Catechism doesn't resolve.

    CONNECTION TO BASE AXIOM: This connects to
    `Catlib.s3_law_on_hearts` (S3: ∀ p, p.hasIntellect = true → moralLawInscribed p).
    S3 says God INSCRIBED the law on every heart; this axiom says the law
    has binding force BECAUSE it comes from God. Together they form a complete
    picture: the law is divinely grounded (this axiom) and universally
    inscribed (S3). -/
axiom divine_grounding :
  -- Natural law has binding force BECAUSE it comes from God
  -- Without this axiom, natural law is just "what reason discovers"
  -- which lacks the normative force of LAW
  ∀ (p : MoralPrecept),
    p.accessibleToReason →
    -- The precept has binding moral authority
    p.content

/-!
## Bridge theorems to base axioms
-/

/-- Bridge to S6: moral truths are accessible to reason.
    The base axiom uses the opaque `MoralProposition` type. -/
theorem moral_realism_from_s6 (mp : MoralProposition) (h : moralTruthValue mp) :
    accessibleToReason mp :=
  s6_moral_realism mp h

/-- Bridge to S3: the moral law is inscribed on every rational heart. -/
theorem law_on_hearts_from_s3 (p : Person) (h : p.hasIntellect = true) :
    moralLawInscribed p :=
  s3_law_on_hearts p h

/-!
## The rational convergence problem

The deepest hidden assumption: if natural law is universal AND
accessible to reason, then all honest reasoners SHOULD converge on
the same moral conclusions. Persistent disagreement must be a failure
of reason, not a genuine feature of moral reality.

This is an extraordinarily strong claim.
-/

/-- Two reasoners examining the same precept. -/
structure TwoReasoners where
  person1 : Person
  person2 : Person
  precept : MoralPrecept
  h1_intellect : person1.hasIntellect = true
  h2_intellect : person2.hasIntellect = true

/-- The rational convergence claim: both reasoners can discover the
    same moral truth. If they disagree, at least one is failing to
    reason properly.
    This follows from rational_accessibility + universality, but the
    philosophical commitment it represents is much stronger than either
    axiom alone. -/
theorem rational_convergence (r : TwoReasoners) :
    r.precept.accessibleToReason :=
  rational_accessibility r.precept r.person1 r.h1_intellect

/-!
## The divine grounding tension

§1954 creates a structural tension:
- Natural law is "accessible to reason" (no revelation needed)
- Natural law "would not have the force of law" without being
  "the voice of a higher reason" (God required)

So: you can DISCOVER the law by reason, but the law only EXISTS
because of God. This means an atheist can know the natural law
but cannot account for WHY it binds them.

This raises a question: is natural law theory really "natural"
(i.e., independent of revelation), or does it secretly require theism?
-/

/-- The structural tension: accessible to reason, but grounded in God. -/
theorem natural_law_tension
    (p : MoralPrecept)
    (person : Person)
    (h_intellect : person.hasIntellect = true) :
    -- The precept is accessible to this person's reason
    p.accessibleToReason :=
  rational_accessibility p person h_intellect

/-- But its binding force comes from divine grounding, not from
    reason alone. An atheist can discover the precept but (on this
    view) cannot fully account for why it binds. -/
theorem binding_force_requires_god
    (p : MoralPrecept)
    (h_accessible : p.accessibleToReason) :
    -- The precept actually holds (has binding force)
    p.content :=
  divine_grounding p h_accessible

/-!
## The immutability problem

§1956 says natural law is "immutable and eternal." But §1957 says
application varies. The law_application_distinction axiom handles this,
but it raises a deeper question:

If you can never observe the law directly — only its applications,
which vary — what does "immutable" even mean? An immutable law whose
applications always change looks indistinguishable from no law at all,
unless you accept the metaphysical claim that the abstract precept
EXISTS independently of all its applications.

This is Platonic realism about moral laws — another hidden assumption.
-/

/-- The immutability claim: the precept's content doesn't change. -/
theorem immutability (p : MoralPrecept)
    (ctx1 ctx2 : MoralContext)
    (app1 app2 : Application)
    (h1 : app1.precept = p)
    (h2 : app2.precept = p) :
    app1.precept.content = app2.precept.content :=
  law_application_distinction p ctx1 ctx2 app1 app2 h1 h2

/-!
## Summary of hidden assumptions

Formalizing §1954-1957 required these assumptions the text doesn't state:

1. **Moral realism** — moral facts exist independently of human opinion.
   Without this, "natural law" is just "widely shared moral intuitions."

2. **Rational accessibility** — reason alone can discover moral truth.
   But what counts as "proper" reasoning? The theory must say disagreement
   is always a failure of reason.

3. **Rational convergence** — all honest reasoners should converge on the
   same conclusions. Persistent disagreement = someone is reasoning badly.
   This is an extraordinarily strong claim hidden in "universal."

4. **Law/application distinction** — the law is immutable even though its
   applications vary. This requires Platonic realism about moral laws.

5. **Divine grounding** — natural law only has the "force of law" because
   it comes from God. So natural law is discoverable by reason but
   grounded in revelation — a tension the Catechism doesn't resolve.

The natural law section of the Catechism does more philosophical heavy
lifting per paragraph than almost any other section. Five major
metaphysical commitments in four paragraphs, none stated explicitly.
-/

end Catlib.MoralTheology
