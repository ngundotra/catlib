import Catlib.Foundations.Basic

/-!
# Human Nature — from the CCC's own categories

Built from what the Catechism ACTUALLY says, not our synthesis.

## The CCC's structure (§362-365 + §1705 + §405)

§362: "The human person is a being at once corporeal and spiritual."
§363: "Soul signifies the spiritual principle in man."
§364: "The human body shares in the dignity of the image of God."
§365: "The soul is the 'form' of the body... their union forms a
       single nature."
§1705: "By virtue of his soul and his spiritual powers of intellect
        and will, man is endowed with freedom."
§405: Original sin leaves nature "wounded in natural powers; subject
      to ignorance, suffering, and the dominion of death; and inclined
      to sin — concupiscence."

## The CCC's own model

```
HUMAN PERSON (one nature, §365)
├── Body (corporeal aspect, §362)
│   Subject to: suffering, death (§405)
└── Soul (spiritual principle, §363)
    ├── Intellect (spiritual power, §1705)
    │   Wounded by: ignorance (§405)
    └── Will (spiritual power, §1705)
        Wounded by: concupiscence (§405)
        └── Freedom ("outstanding manifestation," §1705)
```

Two levels, not four axes. Body + Soul. Soul has intellect + will.
Will manifests as freedom. This is what the CCC says — no more, no less.

## What we are NOT claiming

We are NOT claiming the CCC has a "four faculty" model. The CCC
describes body, soul, intellect, will — but "desires" as a separate
faculty is Thomistic (the sensitive appetite), not prominently in
the CCC. We model what the CCC says.
-/

namespace Catlib

/-!
## The two aspects of the person
-/

/-- The two aspects of a human person (§362).
    "A being at once corporeal and spiritual."
    NOT two separate things — one nature with two aspects (§365). -/
inductive PersonAspect where
  /-- The corporeal aspect — the body -/
  | body
  /-- The spiritual aspect — the soul -/
  | soul

/-- The two spiritual powers of the soul (§1705).
    "By virtue of his soul and his spiritual powers of intellect
    and will, man is endowed with freedom." -/
inductive SpiritualPower where
  /-- The power to know truth -/
  | intellect
  /-- The power to choose freely -/
  | will

/-- The state of a spiritual power — how wounded or healed it is.
    §405 says nature is "wounded in the natural powers" — implying
    the powers admit of degrees, not just on/off. -/
structure PowerState where
  /-- How functional is this power? 0 = fully impaired, higher = healthier -/
  level : Nat
  /-- Is this power currently wounded by original sin? -/
  isWounded : Prop

/-- The wounds of original sin, as the CCC describes them (§405).
    "Subject to ignorance, suffering, and the dominion of death;
    and inclined to sin — concupiscence." -/
structure OriginalWounds where
  /-- "Subject to ignorance" — intellect wounded (§405) -/
  ignorance : Prop
  /-- "Inclined to sin — concupiscence" — will wounded (§405) -/
  concupiscence : Prop
  /-- "Subject to suffering" — body affected (§405) -/
  suffering : Prop
  /-- "Subject to the dominion of death" — body mortal (§405) -/
  death : Prop

/-- Human nature as the CCC describes it.
    Two aspects (body + soul), two spiritual powers (intellect + will),
    and freedom as the manifestation of intellect + will working together. -/
structure HumanNature where
  /-- The person -/
  person : Person
  /-- State of the intellect -/
  intellectState : PowerState
  /-- State of the will -/
  willState : PowerState
  /-- Whether the body is subject to death -/
  bodyMortal : Prop
  /-- The wounds of original sin (if any) -/
  wounds : OriginalWounds

/-!
## Freedom as manifestation (§1705)

The CCC does NOT list freedom as a separate faculty. It says freedom
is the "outstanding manifestation" of intellect and will together.
Freedom is DERIVED from the state of your spiritual powers, not a
third independent axis.
-/

/-- Freedom level is derived from intellect + will states.
    §1705: freedom is the "manifestation" of these powers, not
    a separate power. -/
def HumanNature.freedomLevel (hn : HumanNature) : Nat :=
  -- Freedom manifests from both powers working together
  -- If either is impaired, freedom is diminished
  min hn.intellectState.level hn.willState.level

/-- A person with unwounded intellect and will has full freedom. -/
def HumanNature.hasFreedom (hn : HumanNature) : Prop :=
  hn.intellectState.level > 0 ∧ hn.willState.level > 0

/-!
## The wound (§405)

Original sin wounds the person in specific ways the CCC names.
-/

/-- The state of human nature before the Fall.
    Intellect and will at full capacity, body not mortal. -/
def originalIntegrity (p : Person) : HumanNature :=
  { person := p
    intellectState := { level := 100, isWounded := False }
    willState := { level := 100, isWounded := False }
    bodyMortal := False
    wounds := { ignorance := False
                concupiscence := False
                suffering := False
                death := False } }

/-- The state of human nature after the Fall (§405).
    "Wounded in natural powers; subject to ignorance, suffering,
    and the dominion of death; and inclined to sin." -/
def fallenNature (p : Person) : HumanNature :=
  { person := p
    intellectState := { level := 50, isWounded := True }  -- subject to ignorance
    willState := { level := 50, isWounded := True }        -- concupiscence
    bodyMortal := True                                      -- dominion of death
    wounds := { ignorance := True
                concupiscence := True
                suffering := True
                death := True } }

/-- Freedom is diminished after the Fall — because both intellect
    and will are wounded. -/
theorem fall_diminishes_freedom_from_nature (p : Person) :
    (originalIntegrity p).freedomLevel > (fallenNature p).freedomLevel := by
  simp [originalIntegrity, fallenNature, HumanNature.freedomLevel]

/-- But freedom is NOT destroyed — the CCC says nature is wounded,
    not "totally corrupted" (§405). -/
theorem freedom_survives_fall (p : Person) :
    (fallenNature p).hasFreedom := by
  simp [fallenNature, HumanNature.hasFreedom]

/-!
## What the CCC does NOT say

The CCC does NOT:
1. List "desires" as a separate faculty — concupiscence is described
   as an inclination (of the will toward sin), not a separate power
2. Treat the body as a "healing dimension" — it mentions death and
   suffering but doesn't frame the body as something grace heals
   in this life (resurrection is eschatological, not therapeutic)
3. Present a "four faculty framework" — that was our invention

What it DOES say:
1. Body + Soul, one nature (§362, §365)
2. Soul has intellect + will (§1705)
3. Freedom = manifestation of intellect + will (§1705)
4. Original sin wounds: ignorance (intellect), concupiscence (will),
   suffering + death (body) — §405
5. "Human nature has not been totally corrupted" (§405) — wounded
   but not destroyed

## Mathematical structure — what can we actually say?

From the CCC's own model:
- Human nature is TWO-DIMENSIONAL at the spiritual level
  (intellect × will), not four-dimensional
- Freedom is DERIVED (min of intellect and will), not independent
- The body is affected (mortality) but not on the same "healing
  spectrum" as the spiritual powers
- The wound is described with four effects (ignorance, concupiscence,
  suffering, death) but these map to TWO powers + ONE bodily condition,
  not four independent axes

The honest mathematical structure is simpler than we claimed:
  Spiritual healing space: Intellect × Will (2D, graded)
  Freedom: min(Intellect, Will) — derived, not independent
  Body: binary for now (mortal/glorified) — not a spectrum

This is less dramatic than "four-dimensional graded space" but
it's what the CCC actually implies.
-/

end Catlib
