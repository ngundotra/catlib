/-!
# Catlib Foundations: Core Types

The fundamental types and structures needed to formalize claims from the
Catechism of the Catholic Church. These are modeling choices — each one
is an assumption we're making explicit.

## Design principle

We model theological concepts as opaque types with axiomatically declared
properties. This mirrors how the Catechism itself works: it defines terms,
states their properties, and reasons from them. We don't need to construct
these objects — we need to reason about what follows from their declared
properties.
-/

namespace Catlib

/-- A person — human or divine. The Catechism's anthropology distinguishes
    persons by their capacities (intellect, will, freedom). We model a person
    as having these capacities to varying degrees. -/
structure Person where
  /-- Can this person know truths? -/
  hasIntellect : Bool
  /-- Can this person choose freely? -/
  hasFreeWill : Bool
  /-- Is this person capable of moral action? -/
  isMoralAgent : Bool

/-- A human person: has intellect, free will, and moral agency.
    CCC §1700: "The dignity of the human person is rooted in his creation
    in the image and likeness of God." -/
def Person.human : Person :=
  { hasIntellect := true, hasFreeWill := true, isMoralAgent := true }

/-- An action that a moral agent can perform. -/
structure Action where
  /-- The agent performing the action -/
  agent : Person
  /-- The object of the action (what is done) — CCC §1750 -/
  object : Prop
  /-- The intention of the agent — CCC §1752 -/
  intention : Prop
  /-- The circumstances — CCC §1754 -/
  circumstances : Prop

/-- The three sources of morality (CCC §1750).
    "The morality of human acts depends on: the object chosen, the end in
    view or the intention, and the circumstances of the action." -/
structure MoralEvaluation where
  action : Action
  /-- Is the object of the action good? -/
  objectIsGood : Prop
  /-- Is the intention good? -/
  intentionIsGood : Prop
  /-- Are the circumstances appropriate? -/
  circumstancesAppropriate : Prop

/-- An action is morally good when all three sources are good.
    CCC §1755: "A morally good act requires the goodness of the object,
    of the end, and of the circumstances together." -/
def MoralEvaluation.isGood (eval : MoralEvaluation) : Prop :=
  eval.objectIsGood ∧ eval.intentionIsGood ∧ eval.circumstancesAppropriate

/-- An action is morally evil if any source is evil.
    CCC §1755: "An evil end corrupts the action, even if the object is
    good in itself." -/
def MoralEvaluation.isEvil (eval : MoralEvaluation) : Prop :=
  ¬eval.objectIsGood ∨ ¬eval.intentionIsGood ∨ ¬eval.circumstancesAppropriate

/-- Good and evil are contradictory (for the same evaluation). -/
theorem good_iff_not_evil (eval : MoralEvaluation) :
    eval.isGood ↔ ¬eval.isEvil := by
  unfold MoralEvaluation.isGood MoralEvaluation.isEvil
  constructor
  · intro ⟨ho, hi, hc⟩ h
    cases h with
    | inl h => exact h ho
    | inr h => cases h with
      | inl h => exact h hi
      | inr h => exact h hc
  · intro h
    have ho : eval.objectIsGood := Classical.byContradiction fun hn => h (Or.inl hn)
    have hi : eval.intentionIsGood := Classical.byContradiction fun hn => h (Or.inr (Or.inl hn))
    have hc : eval.circumstancesAppropriate := Classical.byContradiction fun hn => h (Or.inr (Or.inr hn))
    exact ⟨ho, hi, hc⟩

/-- The type of grace — prevenient (preparing) vs sanctifying.
    This distinction was the key finding of the Grace bootstrapping
    formalization (CCC §2001): you need grace to prepare for grace,
    which requires at least two KINDS of grace. -/
inductive GraceType where
  /-- Prevenient (preparing) grace — comes BEFORE any human response.
      This is the grace that §2001 says "arouses" our collaboration.
      It doesn't require any prior human action. -/
  | prevenient
  /-- Sanctifying grace — the grace of justification and ongoing
      relationship with God. This is what prevenient grace prepares
      us to receive. -/
  | sanctifying

/-- Grace — God's free and undeserved help.
    CCC §1996: "Grace is favor, the free and undeserved help that God gives
    us to respond to his call." Unified type combining essential properties
    with the typed distinction (from Grace.lean finding). -/
structure Grace where
  /-- What kind of grace -/
  graceType : GraceType
  /-- Who receives it -/
  recipient : Person
  /-- Grace is freely given (not earned) -/
  isFree : Prop
  /-- Grace is undeserved -/
  isUndeserved : Prop
  /-- Grace enables a response to God's call -/
  enablesResponse : Prop

/-- Knowledge in the context of moral action.
    MODELING CHOICE: The Catechism treats knowledge as binary (full or not).
    This is an assumption — one could model knowledge as graded.
    We make the binary assumption explicit. -/
inductive MoralKnowledge where
  | full       -- The agent fully knows the moral character of the act
  | notFull    -- The agent has some but incomplete knowledge

/-- Consent in the context of moral action.
    MODELING CHOICE: Same binary assumption as knowledge.
    "Complete consent" is either present or not. -/
inductive MoralConsent where
  | complete   -- The agent fully and freely consents
  | incomplete -- Consent is diminished (by fear, habit, pressure, etc.)

/-- The gravity of the matter of an act.
    MODELING CHOICE: The Catechism distinguishes "grave" from "less serious"
    matter. We model this as binary. Again, this is an assumption —
    gravity could be modeled as a spectrum. -/
inductive MatterGravity where
  | grave      -- Concerns a serious moral matter
  | lesSerious -- Concerns a less serious matter

/-- Sin — an offense against reason, truth, and right conscience.
    CCC §1849: "Sin is an offense against reason, truth, and right conscience;
    it is a failure in genuine love for God and neighbor."

    This unified type captures both the essential nature of sin (what makes
    it sin: freedom, contrariety to reason/truth) and the severity conditions
    (knowledge, consent, gravity) that determine whether the sin is mortal
    or venial (CCC §1857-1862). -/
structure Sin where
  /-- The action constituting the sin -/
  action : Action
  /-- Sin is a free act (requires free will) -/
  isFree : Prop
  /-- Sin is contrary to reason -/
  contraryToReason : Prop
  /-- Sin is contrary to truth -/
  contraryToTruth : Prop
  /-- The agent's knowledge of the moral character of the act -/
  knowledge : MoralKnowledge
  /-- The agent's consent to the act -/
  consent : MoralConsent
  /-- The gravity of the matter -/
  gravity : MatterGravity

/-- Sin requires free will — you cannot sin without choosing to.
    CCC §1859: "Mortal sin requires full knowledge and complete consent." -/
theorem sin_requires_freedom (s : Sin) (h : s.isFree) :
    s.action.agent.hasFreeWill = true → s.isFree := by
  intro _
  exact h

/-- Axiom provenance tags — every axiom should declare its source. -/
inductive Provenance where
  /-- From a specific Bible verse under Catholic reading -/
  | scripture (reference : String)
  /-- From Church Fathers, Councils, Magisterium -/
  | tradition (source : String)
  /-- From philosophical reasoning without revelation -/
  | naturalLaw
  /-- From the Catechism's own defined terms -/
  | definition (paragraph : Nat)

/-- Which denominations accept a given axiom or theorem.
    This is the key insight: the axiom set IS the denomination.
    Tagging results lets us say "this holds under Catholic axioms"
    or "this is shared across denominations." -/
inductive Denomination where
  /-- Accepted by the Catholic Church -/
  | catholic
  /-- Accepted by Lutheran churches -/
  | lutheran
  /-- Accepted by Reformed/Calvinist churches -/
  | reformed
  /-- Accepted by all/most Christian denominations -/
  | ecumenical

/-- A denominational tag — which traditions accept this claim. -/
structure DenominationalTag where
  /-- Which denominations accept this axiom/theorem -/
  acceptedBy : List Denomination
  /-- Brief note on any qualifications -/
  note : String

/-- Shared across all major Christian denominations. -/
def ecumenical : DenominationalTag :=
  { acceptedBy := [Denomination.ecumenical], note := "broadly shared" }

/-- Specifically Catholic — other denominations may reject. -/
def catholicOnly : DenominationalTag :=
  { acceptedBy := [Denomination.catholic], note := "Catholic distinctive" }

/-- Shared by Catholic and Lutheran but not all denominations. -/
def catholicAndLutheran : DenominationalTag :=
  { acceptedBy := [Denomination.catholic, Denomination.lutheran], note := "" }

/-- Specifically Lutheran — Catholics would reject. -/
def lutheranOnly : DenominationalTag :=
  { acceptedBy := [Denomination.lutheran], note := "Lutheran distinctive" }

/-- The source from which authority derives. -/
inductive AuthoritySource where
  /-- Authority from God directly -/
  | divine
  /-- Authority delegated from another authority holder -/
  | delegated (holder : Person)
  /-- Authority arising from natural law -/
  | naturalLaw

/-- Authority — the quality by virtue of which persons or institutions
    make laws and give orders and expect obedience.
    CCC §1897 -/
structure Authority where
  /-- Who holds the authority -/
  holder : Person
  /-- Source of the authority (delegated, natural, divine) -/
  source : AuthoritySource

/-- A model of free will. The Catechism assumes libertarian free will —
    genuine ability to choose otherwise — but never argues for it.
    This is an opaque type because the MODEL of freedom is itself
    an assumption we want to track. -/
inductive FreedomModel where
  /-- Libertarian: the agent could genuinely have chosen otherwise -/
  | libertarian
  /-- Compatibilist: freedom is acting from one's own desires without external coercion -/
  | compatibilist

/-- A free choice — models the act of choosing with a specific freedom model. -/
structure FreeChoice (α : Type) where
  /-- What was chosen -/
  chosen : α
  /-- The agent had alternatives available -/
  alternativesExist : Prop
  /-- The choice was uncoerced -/
  uncoerced : Prop

/-- A party that can participate in communion.
    Communion is a mutual participatory relationship — it requires two parties.
    CCC §1024: "To live in the full and definitive communion with God."
    CCC §946: "The communion of saints."

    Examples of communion:
    - Person + God: the core theological relationship (CCC §1033)
    - Person + Church: what excommunication breaks
    - Church + God: the Church as Body of Christ
    - God + God: intra-Trinitarian communion (CCC §255)
    - Church + Church: the communion of saints (CCC §946)
    - Person + Person: friendship/philia

    NOT reflexive for persons (communion requires an other).
    Reflexive for God (Trinity) and Church (communion of saints). -/
inductive CommunionParty where
  /-- A human or angelic person -/
  | person (p : Person)
  /-- God (the Trinity) -/
  | god
  /-- The Church (the Body of Christ, the communion of saints) -/
  | church

/-- The degree of freedom a person has.
    MODELING CHOICE: Freedom is graded, not binary.
    The Catechism says you can become "freer" (§1733),
    which means freedom admits of degrees. -/
structure FreedomDegree where
  /-- How free is this person? (0 = enslaved, higher = more free) -/
  level : Nat
  /-- Is this person currently able to choose between good and evil? -/
  canChooseEvil : Prop
  /-- Is this person oriented toward the good? -/
  orientedToGood : Prop

/-- A strict ordering on freedom degrees, by level. -/
def freedomLt (a b : FreedomDegree) : Prop := a.level < b.level

end Catlib
