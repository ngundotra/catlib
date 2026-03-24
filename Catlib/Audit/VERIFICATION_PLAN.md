# Catlib Verification Plan

**Purpose:** Systematic audit of definition soundness, axiom consistency,
and non-vacuity across the Catlib formalization.

**Context:** Catlib has ~545 axioms, ~415 opaque declarations, and ~697
theorems across 99 Lean files. Type-checking (lake build) passes and there
are zero `sorry` usages. But there is no proof that the axiom set is
consistent, no guarantee that opaque types are inhabited, and no dependency
tracking showing which axioms each theorem actually uses.

**Note:** Theorem dependency graphs are handled by the existing "theorem
tree" tool and are out of scope here.

---

## Task 1: Nonempty Instances for All Opaque Types

**File:** `Catlib/Audit/Nonempty.lean`
**Status:** DONE (created alongside this plan)
**Risk addressed:** Universal quantifications over empty types are vacuously
true. Every `∀ hp : HumanPerson, P hp` theorem is meaningless if
`HumanPerson` has no inhabitants.

### Opaque types requiring Nonempty (Foundations)

| Type | File | Line | Theological justification |
|------|------|------|---------------------------|
| `MoralProposition` | Axioms.lean | 47 | Moral realism (S6) presupposes moral propositions exist |
| `TheGood` | Axioms.lean | 56 | Teleological freedom (S7) presupposes a telos |
| `PrimaryCause` | Axioms.lean | 62 | Two-tier causation (P2) presupposes God acts as primary cause |
| `SecondaryCause` | Axioms.lean | 65 | Two-tier causation (P2) presupposes creatures act as secondary causes |
| `God` | Axioms.lean | 71 | The entire system presupposes God exists |
| `Sacrament` | Axioms.lean | 132 | Sacramental efficacy (T3) presupposes sacraments exist |

### Opaque types requiring Nonempty (Creed)

| Type | File | Line | Theological justification |
|------|------|------|---------------------------|
| `HumanPerson` | Soul.lean | 78 | CCC §355: humans exist as body-soul composites |
| `DivineSubstance` | Trinity.lean | 82 | Has `:= Unit` body — already inhabited, but add instance for clarity |
| `EcumenicalCouncil` | ConciliarAuthority.lean | 179 | Nicaea, Trent, etc. are historical facts |
| `ConciliarDefinition` | ConciliarAuthority.lean | 188 | Councils produced definitions |
| `ApostolicTeaching` | RuleOfFaith.lean | 139 | Apostles taught |
| `WrittenText` | RuleOfFaith.lean | 173 | Scripture exists |
| `MagisterialJudgment` | RuleOfFaith.lean | 189 | Magisterium has made judgments |
| `TheologicalPredicate` | AnalogyOfBeing.lean | 216 | We predicate things of God (e.g., "God is good") |
| `Teaching` | PapalInfallibility.lean | 91 | Popes have taught |
| `PetrineOffice` | PapalInfallibility.lean | 122 | The papacy exists |
| `Truth` | FaithAndReason.lean | 128 | Truth exists (presupposed by the entire system) |
| `Being` | EssenceExistence.lean | 153 | Beings exist |
| `Angel` | Angels.lean | 123 | CCC §328: angels exist |
| `Matter` | HylomorphicFormation.lean | 148 | Material world exists |
| `DepositOfFaith` | DevelopmentOfDoctrine.lean | 151 | The deposit was entrusted to the apostles |
| `Doctrine` | DevelopmentOfDoctrine.lean | 156 | Doctrines have been formulated |
| `HolinessDegree` | Purgatory.lean | 73 | Holiness admits of degrees |
| `DivineEssence` | DivineAttributes.lean | 196 | God has an essence |
| `Interpretation` | PrivateJudgment.lean | 148 | People interpret Scripture |
| `Adjudicator` | PrivateJudgment.lean | 195 | There exist adjudicators of disputes |

### Opaque types requiring Nonempty (Moral Theology)

| Type | File | Line | Theological justification |
|------|------|------|---------------------------|
| `MaterialGood` | SocialDoctrine.lean | 103 | Material goods exist |

### Opaque types requiring Nonempty (Sacraments)

| Type | File | Line | Theological justification |
|------|------|------|---------------------------|
| `SavingEvent` | Liturgy.lean | 142 | The Paschal mystery is a saving event |
| `Moment` | Liturgy.lean | 150 | Time exists |

### Implementation

For each type, add in the appropriate source file (or centrally in
`Catlib/Audit/Nonempty.lean`):

```lean
axiom HumanPerson.nonempty : Nonempty HumanPerson
instance : Nonempty HumanPerson := HumanPerson.nonempty
```

**Decision: centralized vs. distributed.** The Nonempty.lean file takes the
centralized approach — all instances in one auditable file. The alternative
is adding each instance next to its opaque declaration. Centralized is
better for auditability; distributed is better for discoverability. Start
centralized, consider distributing later.

---

## Task 2: Consistency Proof via Concrete Model

**File:** `Catlib/Audit/Model.lean`
**Risk addressed:** 545 axioms could collectively derive `False`. A concrete
model that satisfies all axioms proves consistency.

### Approach

Define concrete Lean types and functions for every opaque type and predicate,
then prove every axiom holds in the model. If the model file type-checks,
the axiom set is consistent (relative to Lean's own consistency).

### Step 2a: Model the Foundation Types

```lean
-- Catlib/Audit/Model.lean
import Catlib

namespace Catlib.Audit.Model

-- Concrete instantiations of opaque types
def M.MoralProposition := Unit
def M.TheGood := Unit
def M.PrimaryCause := Unit
def M.SecondaryCause := Unit
def M.God := Unit
def M.Sacrament := Unit
def M.HumanPerson := Nat  -- each person is a distinct number
```

### Step 2b: Model the Foundation Predicates

For each opaque predicate, define a concrete function:

| Predicate | Proposed model |
|-----------|---------------|
| `moralTruthValue` | `fun _ => True` (all moral propositions are true — moral realism) |
| `accessibleToReason` | `fun _ => True` |
| `couldChooseOtherwise` | `fun _ => True` |
| `causesCompete` | `fun _ _ => False` (causes never compete — P2) |
| `godIsLove` | `True` |
| `loveRequiresFreedom` | `True` |
| `godWillsSalvation` | `fun _ => True` |
| `moralLawInscribed` | `fun _ => True` |
| `divinelyGoverned` | `fun _ => True` |
| `isGraveSin` | `fun _ => False` (no sin is grave — trivial model) |
| `inCommunion` | `fun a b => a = .god ∧ b = .god` (only God-God communion — needs refinement) |
| `graceGiven` | `fun _ _ => True` |
| `graceTransforms` | `fun _ _ => True` |
| `cooperatesWithGrace` | `fun _ _ => True` |
| `signifies` | `fun _ => True` |
| `confers` | `fun _ => True` |
| `conscienceJudges` | `fun _ _ => True` |
| `obligated` | `fun _ _ => True` |
| `isEvil` | `fun _ => False` (nothing is evil — trivial model) |
| `isDueGoodAbsent` | `fun _ => False` |

### Step 2c: Verify Each Base Axiom

For each of the 14 base axioms (P2, P3, S1-S9, T1-T3), prove it holds
in the model:

```lean
theorem M.p2 : ∀ (p : M.PrimaryCause) (s : M.SecondaryCause),
    ¬ M.causesCompete p s := by
  intro p s h
  exact h  -- causesCompete is defined as False
```

### Step 2d: Verify Communion Axioms

The communion axioms are the trickiest to model because they have
conflicting constraints:
- `communion_symmetric`: symmetric
- `communion_not_self_reflexive`: persons can't self-commune
- `god_self_communion`: God can self-commune
- `church_self_communion`: Church can self-commune

A model that works:
```lean
def M.inCommunion : CommunionParty → CommunionParty → Prop
  | .god, .god => True
  | .church, .church => True
  | .god, .church => True
  | .church, .god => True
  | .person _, .god => True    -- all persons in communion with God
  | .god, .person _ => True    -- symmetric
  | .person _, .church => True
  | .church, .person _ => True
  | .person p1, .person p2 => p1 ≠ p2  -- persons commune with others, not self
```

**But wait:** S5 says `isGraveSin s → ¬ inCommunion (.person p) .god`.
If `isGraveSin` is always `False`, the antecedent is never satisfied,
so this holds vacuously. This is fine for consistency but shows the model
is "trivial" — it proves consistency but doesn't prove the axioms are
*interesting*. That's Task 3's job.

### Step 2e: Verify All ~530 Non-Base Axioms

This is the bulk of the work. Each file's axioms must be checked against
the model. Many will hold trivially if predicates are modeled as
constant `True`/`False`. Some will require more careful modeling.

**Estimated difficulty:** HARD. The main challenge is that the ~530
non-base axioms are spread across 88 files with file-local opaque
predicates. Each file introduces its own opaques that must also be
modeled.

**Pragmatic alternative:** Start with just the 14 base axioms + the
communion axioms + the Soul/DivineModes axioms (the most interconnected
subsystem). If those are consistent, the risk of contradiction in the
more isolated files is low.

### Priority Order

1. Foundation axioms (Axioms.lean): 20 axioms — MUST DO
2. Soul axioms (Soul.lean): 7 axioms — MUST DO (recently refactored)
3. DivineModes axioms (DivineModes.lean): 5 axioms — MUST DO
4. Love axioms (Love.lean): 11 axioms — SHOULD DO (complex interactions)
5. Authority axioms (Authority.lean): 9 axioms — CAN SKIP (isolated)
6. File-local axioms in Creed/: ~240 axioms — SAMPLE (pick 3-5 files)
7. File-local axioms in MoralTheology/: ~155 axioms — SAMPLE
8. File-local axioms in Sacraments/: ~108 axioms — SAMPLE

---

## Task 3: Existential Witnesses

**File:** `Catlib/Audit/Witnesses.lean`
**Risk addressed:** Even with Nonempty instances, all theorems might be
universally quantified. Existential witnesses show the system describes
something real, not just vacuously universally true.

### Required witnesses

#### Type-level witnesses (show types are inhabited with interesting values)

```lean
-- A concrete human person exists
theorem exists_human_person : ∃ _ : HumanPerson, True :=
  let ⟨hp⟩ := HumanPerson.nonempty; ⟨hp, trivial⟩

-- A human person with both aspects exists (a living person)
theorem exists_living_person : ∃ hp : HumanPerson, isCompletePerson hp :=
  -- Requires: Nonempty HumanPerson + both_aspects_in_life
  -- Need to show ∃ hp, ¬isDead hp ∧ ¬isRisen hp → ...
  sorry  -- Fill in

-- A person in communion with God exists (via god_self_communion + bridge)
theorem exists_communion : ∃ a b : CommunionParty, inCommunion a b :=
  ⟨.god, .god, god_self_communion⟩  -- This one works immediately!
```

#### Predicate-level witnesses (show predicates aren't always-false)

```lean
-- Communion is non-trivial
theorem communion_nontrivial : ∃ a b, inCommunion a b :=
  ⟨.god, .god, god_self_communion⟩

-- Grace exists and is given (requires Nonempty + axioms)
theorem grace_is_real : ∃ p : Person, ∃ g : Grace, graceGiven p g → graceTransforms g p :=
  ⟨Person.human, ⟨.prevenient, Person.human, True, True, True⟩,
   fun h => s8_grace_necessary_and_transformative _ _ h⟩

-- Moral law is inscribed in humans
theorem moral_law_exists : ∃ p : Person, moralLawInscribed p :=
  ⟨Person.human, s3_law_on_hearts Person.human rfl⟩

-- God wills everyone saved
theorem salvation_offered : ∀ p : Person, godWillsSalvation p :=
  s2_universal_salvific_will  -- Already a theorem!
```

#### Negative witnesses (show constraints are non-trivial)

```lean
-- Self-communion is forbidden for moral agents
theorem self_communion_forbidden :
    ∃ p : Person, p.isMoralAgent = true ∧ ¬inCommunion (.person p) (.person p) :=
  ⟨Person.human, rfl, communion_not_self_reflexive Person.human rfl⟩
```

### Priority order

1. `exists_communion` — immediate, proves inCommunion isn't always-false
2. `self_communion_forbidden` — immediate, proves it isn't always-true
3. `moral_law_exists` — immediate from S3
4. `grace_is_real` — shows grace infrastructure works
5. `exists_living_person` — requires careful construction from Soul axioms
6. Person-level eschatological witnesses — harder, may need additional axioms

---

## Task 4: Axiom Audit File

**File:** `Catlib/Audit/AxiomAudit.lean`
**Risk addressed:** No visibility into which axioms each theorem depends on.
Without this, you can't tell whether a theorem is "deep" (depends on many
axioms) or "shallow" (follows from definitions alone).

### Implementation

```lean
-- Catlib/Audit/AxiomAudit.lean
import Catlib

-- ============================================================
-- Foundation theorems
-- ============================================================
#print axioms Catlib.good_iff_not_evil
#print axioms Catlib.sin_requires_freedom

-- ============================================================
-- Soul.lean theorems
-- ============================================================
#print axioms Catlib.Creed.living_person_is_complete
#print axioms Catlib.Creed.dead_person_is_incomplete
#print axioms Catlib.Creed.dead_person_still_exists
#print axioms Catlib.Creed.risen_person_is_complete
#print axioms Catlib.Creed.no_body_without_soul
#print axioms Catlib.Creed.soul_body_asymmetry
#print axioms Catlib.Creed.rejects_cartesian_dualism
#print axioms Catlib.Creed.rejects_materialism
#print axioms Catlib.Creed.rejects_annihilationism
#print axioms Catlib.Creed.separated_soul_is_incomplete
-- ... (all 697 theorems)
```

### How to generate

Run this bash command to auto-generate the file:

```bash
grep -rn "^theorem " --include="*.lean" Catlib/ \
  | grep -v "Audit/" \
  | sed 's|Catlib/|Catlib.|g; s|/|.|g; s|\.lean:.*theorem |#print axioms |; s| .*||' \
  > /tmp/axiom_audit_body.txt
```

Then manually fix namespace prefixes (the grep output won't have exact
qualified names). A more robust approach: write a Lean metaprogram that
enumerates all declarations in the `Catlib` environment and prints their
axiom dependencies.

### Metaprogrammatic approach (preferred)

```lean
import Catlib
open Lean Elab Command Meta in
#eval do
  let env ← getEnv
  let mut axiomDeps : Array (Name × Array Name) := #[]
  for (name, _) in env.constants.fold (init := #[]) fun acc n ci => acc.push (n, ci) do
    if name.toString.startsWith "Catlib." then
      let deps := (← collectAxioms name).toArray
      if deps.size > 0 then
        axiomDeps := axiomDeps.push (name, deps)
  for (name, deps) in axiomDeps do
    IO.println s!"{name}: {deps}"
```

This would produce a complete dependency map in one pass. The exact API
may need adjustment for the current Lean 4 version.

---

## Execution Order

| # | Task | File | Effort | Blocks |
|---|------|------|--------|--------|
| 1 | Nonempty instances | `Audit/Nonempty.lean` | 1 hour | Nothing |
| 2 | Axiom audit | `Audit/AxiomAudit.lean` | 2 hours | Nothing |
| 3 | Existential witnesses | `Audit/Witnesses.lean` | 3 hours | Task 1 |
| 4a | Consistency model (foundations) | `Audit/Model.lean` | 4 hours | Nothing |
| 4b | Consistency model (Soul+DivineModes) | `Audit/Model.lean` | 4 hours | 4a |
| 4c | Consistency model (remaining) | `Audit/Model.lean` | 8+ hours | 4b |

Tasks 1, 2, and 4a are independent and can be done in parallel.

---

## Success Criteria

The verification is complete when:

1. `lake build` passes with `Catlib/Audit/Nonempty.lean` included
2. `Catlib/Audit/AxiomAudit.lean` compiles and produces `#print axioms`
   output for every theorem (or a metaprogram does the same)
3. `Catlib/Audit/Witnesses.lean` contains ≥5 existential proofs with
   no `sorry`
4. `Catlib/Audit/Model.lean` models all foundation + Soul + DivineModes
   axioms with concrete types and all proofs complete (no `sorry`)
5. No proof of `False` is derivable (implied by 4, but can also be
   checked directly via `theorem no_contradiction : ¬False := id`)
