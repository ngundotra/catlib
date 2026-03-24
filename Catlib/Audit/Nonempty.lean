import Catlib

/-!
# Nonempty Instances for All Opaque Types

## Purpose

Every opaque type in Catlib is introduced without an `Inhabited` or
`Nonempty` instance.  This means that universally quantified axioms and
theorems over those types (e.g., `∀ hp : HumanPerson, P hp`) are
**vacuously true** if the type happens to be empty.

This file closes that gap by asserting `Nonempty` for every opaque type
in the project.  Each assertion is an axiom — it cannot be proved from
the opaque declaration alone, but it is theologically justified (the CCC
presupposes humans exist, God exists, sacraments exist, etc.).

## Design choice: axiom vs. instance-only

We declare both an `axiom` (the fact) and an `instance` (making it
available to typeclass resolution).  The axiom is named
`<Type>.nonempty` for grep-ability.

## Audit checklist

If you add a new `opaque Foo : Type` anywhere in Catlib, add a
corresponding entry here.  Running `lake build` will catch the file if
a type is removed or renamed, but it cannot catch a *missing* entry —
that requires a manual or scripted audit.

To find all opaque types:
```bash
grep -rn "^opaque.*: Type" --include="*.lean" Catlib/
```
-/

namespace Catlib.Audit.Nonempty

-- ============================================================================
-- Foundations (Catlib/Foundations/Axioms.lean)
-- ============================================================================

/-- Moral propositions exist.  Presupposed by S6 (moral realism). -/
axiom MoralProposition.nonempty : Nonempty Catlib.MoralProposition
instance : Nonempty Catlib.MoralProposition := MoralProposition.nonempty

/-- The Good exists as a telos.  Presupposed by S7 (teleological freedom). -/
axiom TheGood.nonempty : Nonempty Catlib.TheGood
instance : Nonempty Catlib.TheGood := TheGood.nonempty

/-- A primary cause exists (God acts).  Presupposed by P2 (two-tier causation). -/
axiom PrimaryCause.nonempty : Nonempty Catlib.PrimaryCause
instance : Nonempty Catlib.PrimaryCause := PrimaryCause.nonempty

/-- A secondary cause exists (creatures act).  Presupposed by P2. -/
axiom SecondaryCause.nonempty : Nonempty Catlib.SecondaryCause
instance : Nonempty Catlib.SecondaryCause := SecondaryCause.nonempty

/-- God exists.  CCC §199: "I believe in one God." -/
axiom God.nonempty : Nonempty Catlib.God
instance : Nonempty Catlib.God := God.nonempty

/-- Sacraments exist.  CCC §1210: there are seven sacraments. -/
axiom Sacrament.nonempty : Nonempty Catlib.Sacrament
instance : Nonempty Catlib.Sacrament := Sacrament.nonempty

-- ============================================================================
-- Creed — Soul (Catlib/Creed/Soul.lean, namespace Catlib.Creed)
-- ============================================================================

/-- Human persons exist.  CCC §355: "God created man in his own image." -/
axiom HumanPerson.nonempty : Nonempty Catlib.Creed.HumanPerson
instance : Nonempty Catlib.Creed.HumanPerson := HumanPerson.nonempty

-- ============================================================================
-- Creed — Trinity (Catlib/Creed/Trinity.lean, namespace Catlib.Creed)
-- ============================================================================

/-- The divine substance exists.  CCC §253: "one in substance." -/
axiom DivineSubstance.nonempty : Nonempty Catlib.Creed.DivineSubstance
instance : Nonempty Catlib.Creed.DivineSubstance := DivineSubstance.nonempty

-- ============================================================================
-- Creed — ConciliarAuthority (namespace Catlib.Creed.ConciliarAuthority)
-- ============================================================================

/-- Ecumenical councils have occurred (Nicaea, Trent, Vatican I/II, etc.). -/
axiom EcumenicalCouncil.nonempty : Nonempty Catlib.Creed.ConciliarAuthority.EcumenicalCouncil
instance : Nonempty Catlib.Creed.ConciliarAuthority.EcumenicalCouncil := EcumenicalCouncil.nonempty

/-- Councils produced binding definitions. -/
axiom ConciliarDefinition.nonempty : Nonempty Catlib.Creed.ConciliarAuthority.ConciliarDefinition
instance : Nonempty Catlib.Creed.ConciliarAuthority.ConciliarDefinition := ConciliarDefinition.nonempty

-- ============================================================================
-- Creed — RuleOfFaith (namespace Catlib.Creed.RuleOfFaith)
-- ============================================================================

/-- The apostles transmitted teachings. -/
axiom ApostolicTeaching.nonempty : Nonempty Catlib.Creed.RuleOfFaith.ApostolicTeaching
instance : Nonempty Catlib.Creed.RuleOfFaith.ApostolicTeaching := ApostolicTeaching.nonempty

/-- Written texts (Scripture) exist. -/
axiom WrittenText.nonempty : Nonempty Catlib.Creed.RuleOfFaith.WrittenText
instance : Nonempty Catlib.Creed.RuleOfFaith.WrittenText := WrittenText.nonempty

/-- The Magisterium has issued judgments. -/
axiom MagisterialJudgment.nonempty : Nonempty Catlib.Creed.RuleOfFaith.MagisterialJudgment
instance : Nonempty Catlib.Creed.RuleOfFaith.MagisterialJudgment := MagisterialJudgment.nonempty

-- ============================================================================
-- Creed — AnalogyOfBeing (namespace Catlib.Creed.AnalogyOfBeing)
-- ============================================================================

/-- We can predicate things of God (e.g., "God is good"). -/
axiom TheologicalPredicate.nonempty : Nonempty Catlib.Creed.AnalogyOfBeing.TheologicalPredicate
instance : Nonempty Catlib.Creed.AnalogyOfBeing.TheologicalPredicate := TheologicalPredicate.nonempty

-- ============================================================================
-- Creed — PapalInfallibility (namespace Catlib.Creed.PapalInfallibility)
-- ============================================================================

/-- Popes have issued teachings. -/
axiom Teaching.nonempty : Nonempty Catlib.Creed.PapalInfallibility.Teaching
instance : Nonempty Catlib.Creed.PapalInfallibility.Teaching := Teaching.nonempty

/-- The Petrine office exists.  CCC §881. -/
axiom PetrineOffice.nonempty : Nonempty Catlib.Creed.PapalInfallibility.PetrineOffice
instance : Nonempty Catlib.Creed.PapalInfallibility.PetrineOffice := PetrineOffice.nonempty

-- ============================================================================
-- Creed — FaithAndReason (namespace Catlib.Creed.FaithAndReason)
-- ============================================================================

/-- Truth exists.  Presupposed by the entire formalization. -/
axiom Truth.nonempty : Nonempty Catlib.Creed.FaithAndReason.Truth
instance : Nonempty Catlib.Creed.FaithAndReason.Truth := Truth.nonempty

-- ============================================================================
-- Creed — EssenceExistence (namespace Catlib.Creed.EssenceExistence)
-- ============================================================================

/-- Beings exist.  Self-evident. -/
axiom Being.nonempty : Nonempty Catlib.Creed.EssenceExistence.Being
instance : Nonempty Catlib.Creed.EssenceExistence.Being := Being.nonempty

-- ============================================================================
-- Creed — Angels (Catlib/Creed/Angels.lean, namespace Catlib.Creed)
-- ============================================================================

/-- Angels exist.  CCC §328: "The existence of angels — a truth of faith." -/
axiom Angel.nonempty : Nonempty Catlib.Creed.Angel
instance : Nonempty Catlib.Creed.Angel := Angel.nonempty

-- ============================================================================
-- Creed — HylomorphicFormation (namespace Catlib.Creed)
-- ============================================================================

/-- Matter exists.  The material world is real. -/
axiom Matter.nonempty : Nonempty Catlib.Creed.Matter
instance : Nonempty Catlib.Creed.Matter := Matter.nonempty

-- ============================================================================
-- Creed — DevelopmentOfDoctrine (namespace Catlib.Creed.DevelopmentOfDoctrine)
-- ============================================================================

/-- The deposit of faith was entrusted to the apostles.  CCC §84. -/
axiom DepositOfFaith.nonempty : Nonempty Catlib.Creed.DevelopmentOfDoctrine.DepositOfFaith
instance : Nonempty Catlib.Creed.DevelopmentOfDoctrine.DepositOfFaith := DepositOfFaith.nonempty

/-- Doctrines have been formulated and developed. -/
axiom Doctrine.nonempty : Nonempty Catlib.Creed.DevelopmentOfDoctrine.Doctrine
instance : Nonempty Catlib.Creed.DevelopmentOfDoctrine.Doctrine := Doctrine.nonempty

-- ============================================================================
-- Creed — Purgatory (Catlib/Creed/Purgatory.lean, namespace Catlib.Creed)
-- ============================================================================

/-- Holiness admits of degrees.  CCC §1030-1031. -/
axiom HolinessDegree.nonempty : Nonempty Catlib.Creed.HolinessDegree
instance : Nonempty Catlib.Creed.HolinessDegree := HolinessDegree.nonempty

-- ============================================================================
-- Creed — DivineAttributes (namespace Catlib.Creed.DivineAttributes)
-- ============================================================================

/-- God has an essence.  CCC §213: "I AM WHO I AM." -/
axiom DivineEssence.nonempty : Nonempty Catlib.Creed.DivineAttributes.DivineEssence
instance : Nonempty Catlib.Creed.DivineAttributes.DivineEssence := DivineEssence.nonempty

-- ============================================================================
-- Creed — PrivateJudgment (namespace Catlib.Creed.PrivateJudgment)
-- ============================================================================

/-- People form interpretations of Scripture and doctrine. -/
axiom Interpretation.nonempty : Nonempty Catlib.Creed.PrivateJudgment.Interpretation
instance : Nonempty Catlib.Creed.PrivateJudgment.Interpretation := Interpretation.nonempty

/-- Adjudicators of doctrinal disputes exist (Magisterium, councils, etc.). -/
axiom Adjudicator.nonempty : Nonempty Catlib.Creed.PrivateJudgment.Adjudicator
instance : Nonempty Catlib.Creed.PrivateJudgment.Adjudicator := Adjudicator.nonempty

-- ============================================================================
-- Moral Theology — SocialDoctrine (namespace Catlib.MoralTheology.SocialDoctrine)
-- ============================================================================

/-- Material goods exist.  CCC §2402. -/
axiom MaterialGood.nonempty : Nonempty Catlib.MoralTheology.SocialDoctrine.MaterialGood
instance : Nonempty Catlib.MoralTheology.SocialDoctrine.MaterialGood := MaterialGood.nonempty

-- ============================================================================
-- Sacraments — Liturgy (namespace Catlib.Sacraments.Liturgy)
-- ============================================================================

/-- Saving events have occurred (the Paschal mystery). -/
axiom SavingEvent.nonempty : Nonempty Catlib.Sacraments.Liturgy.SavingEvent
instance : Nonempty Catlib.Sacraments.Liturgy.SavingEvent := SavingEvent.nonempty

/-- Time exists; moments are real. -/
axiom Moment.nonempty : Nonempty Catlib.Sacraments.Liturgy.Moment
instance : Nonempty Catlib.Sacraments.Liturgy.Moment := Moment.nonempty

end Catlib.Audit.Nonempty
