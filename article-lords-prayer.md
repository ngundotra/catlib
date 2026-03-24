# What Happens When You Put the Lord's Prayer Through a Proof Assistant?

The Lord's Prayer is roughly sixty words long. Two billion Christians can recite it from memory. It has been prayed daily for two thousand years. You'd think there was nothing left to discover in it.

You'd be wrong.

I put the Lord's Prayer through [Lean 4](https://lean-lang.org/), a proof assistant — the same kind of software used to verify that mathematical theorems are actually correct. The result wasn't a devotional exercise. It was an X-ray. Forcing each petition into formal definitions exposed structure that centuries of commentary had described but never quite pinned down, and at least one finding that sheds light on a five-hundred-year-old theological dispute.

## What Is Catlib?

[Catlib](https://github.com/ngundotra/catlib) is a project to formalize the *Catechism of the Catholic Church* in Lean 4. Not to prove Catholicism is true — that's a category error — but to make its internal logic *machine-checkable*.

The idea is simple: a catechism is a system of claims. Some are axioms (taken on faith or authority); others are supposed to follow from those axioms. A proof assistant can verify that the claimed consequences actually follow, and flag where they don't. Think of it as a type-checker for theology.

The project encodes each doctrine as a Lean definition, axiom, or theorem, with explicit citations to the Catechism's paragraph numbers. When the formalization requires an assumption that the Catechism doesn't explicitly state, it gets flagged as a *hidden assumption* — one of the most valuable outputs of the whole exercise.

## Seven Petitions, Seven Claims

The Catechism (§2803) identifies seven petitions in the Lord's Prayer. Each one makes a specific theological claim. Here they are, stripped to their logical content:

| # | Petition | What it actually asks |
|---|----------|----------------------|
| 1 | Hallowed be thy name | That creation *recognize* God's holiness (not that God become holy) |
| 2 | Thy kingdom come | That persons *enter* the reign that already exists |
| 3 | Thy will be done | That human wills *align* with God's — without being overridden |
| 4 | Give us daily bread | Material sustenance *and* spiritual nourishment (dual content) |
| 5 | Forgive us our trespasses | Removal of guilt — specifically, *guilt* |
| 6 | Lead us not into temptation | Not to *fall* when tested (trials are allowed; temptation-to-sin isn't) |
| 7 | Deliver us from evil | Liberation from the Evil One — personal, not abstract |

The first three are about God: *his* name, *his* kingdom, *his* will. The last four are about us: *our* bread, *our* forgiveness, *our* protection, *our* deliverance.

In the formalization, this becomes a function from petition to orientation:

```lean
inductive PetitionOrientation where
  | godWard
  | humanWard

def PetitionKind.orientation : PetitionKind → PetitionOrientation
  | .hallowedBeThyName       => .godWard
  | .thyKingdomCome          => .godWard
  | .thyWillBeDone           => .godWard
  | .giveUsDailyBread        => .humanWard
  | .forgiveUsTrespasses     => .humanWard
  | .leadUsNotIntoTemptation => .humanWard
  | .deliverUsFromEvil       => .humanWard
```

Then we can prove that this partition is exhaustive — every petition falls into exactly one bucket:

```lean
theorem orientations_exhaustive :
    ∀ (pk : PetitionKind),
      pk.orientation = .godWard ∨ pk.orientation = .humanWard
```

This might seem trivial. It is. That's the point. The 3+4 split isn't an interpretation — it's in the text. The formalization makes that *checkable* rather than just asserted.

## The Ordo Amoris in Miniature

But the split isn't arbitrary. The Catechism's tradition calls it the *ordo amoris* — the ordering of love. God first, then neighbor. The prayer's structure enacts this priority: you orient toward God's glory before you ask for your own needs.

The proof assistant makes this structural claim visible. Three God-ward petitions, then four human-ward ones. Not interleaved, not mixed. A clean partition with a definite order. The prayer isn't just a list of requests — it's an argument about what matters most.

## "Thy Will Be Done" — Alignment, Not Override

Petition 3 raises an obvious question: if you pray for God's will to be done, are you asking God to destroy your freedom? If God gets what he wants, do you lose the ability to choose?

The formalization forces you to answer this precisely. Catlib's axiom T2 states that grace preserves freedom — it enables conformity with God's will *without* destroying the ability to choose otherwise. Applied to the Lord's Prayer:

```lean
axiom will_alignment_preserves_freedom :
  ∀ (p : Person) (g : Grace),
    graceGiven p g →
    cooperatesWithGrace p g →
    couldChooseOtherwise p
```

Read that carefully: even when a person receives grace *and* cooperates with it, they *could choose otherwise*. The aligned will isn't a puppet will. The theorem that follows makes this explicit:

```lean
theorem thy_will_done_preserves_freedom
    (p : Person) (g : Grace)
    (h_grace : graceGiven p g)
    (h_coop : cooperatesWithGrace p g) :
    couldChooseOtherwise p
```

The Catechism's own example is Jesus in Gethsemane: "Not my will, but yours be done." His human will *could* have refused. It didn't. That's not coercion — it's free alignment. The proof assistant doesn't let you fudge the distinction.

## The Forgiveness Finding

Petition 5 is where the formalization produced its most striking result.

"Forgive us our trespasses, as we forgive those who trespass against us." The Catechism (§2838) calls this the *only* petition that conditions what we receive on what we do. The axiom:

```lean
axiom forgiveness_reciprocity :
  ∀ (hp : HumanPerson),
    divinelyForgiven hp → hasForgiven (personOfHuman hp)
```

If you are divinely forgiven, then you have forgiven others. (The contrapositive: if you haven't forgiven others, you aren't divinely forgiven.) But the real finding is in *how* `divinelyForgiven` is defined.

Catlib models sin using a three-layer profile — the same structure the Catechism uses (§1472):

```lean
structure SinProfile where
  originalWound : EffectState  -- Layer 1: original sin
  guilt         : EffectState  -- Layer 2: guilt / eternal punishment
  attachment    : EffectState  -- Layer 3: temporal punishment / attachment
```

And "divinely forgiven" is defined as:

```lean
def divinelyForgiven (hp : HumanPerson) : Prop :=
  (sinProfileOf hp).guilt = EffectState.removed
```

Layer 2 — guilt — removed. *Not* Layer 3.

This matters enormously. Layer 3 — temporal punishment, lingering attachment to sin — *survives* forgiveness. It's what penance, purification, and (in Catholic theology) purgatory address. The Lord's Prayer doesn't ask for that. It asks specifically for guilt removal.

And here is where a five-hundred-year-old dispute comes into focus. The Reformation-era controversy over indulgences was, at its core, about the distinction between Layer 2 and Layer 3. Luther's objection wasn't (primarily) about corruption — it was about whether the Church had authority over temporal punishment that survives forgiveness. The formalization reveals that this same Layer 2/Layer 3 boundary is *already encoded in the Lord's Prayer itself*. "Forgive us our trespasses" targets guilt. The rest is a different mechanism entirely.

Nobody told me to look for this. The proof assistant forced precision on the definition of "forgiven," and the three-layer model was the only way to make it type-check against the Catechism's other claims about sin, penance, and purification. The finding fell out of the formalization.

## Kingdom as Communion

Petition 2 — "Thy kingdom come" — might sound like a request for a future event. But the formalization connects it to Catlib's communion infrastructure:

```lean
axiom kingdom_requires_communion :
  ∀ (hp : HumanPerson),
    participatesInKingdom (personOfHuman hp) →
    inBeatifyingCommunion hp
```

Participating in the kingdom just *is* being in beatifying communion with God. The kingdom isn't a place — it's a relationship. The proof assistant doesn't let you leave "kingdom" vague; you have to say what it maps to in the formal system, and the answer is communion.

## Temptation and Deliverance: A Linked Pair

Petitions 6 and 7 — "lead us not into temptation" and "deliver us from evil" — formalize as a linked pair. If you're fully delivered from the Evil One, you're no longer tempted toward sin:

```lean
theorem deliverance_subsumes_protection
    (p : Person) (h : deliveredFromEvil p) :
    ¬temptedTowardSin p
```

Petition 7 logically subsumes Petition 6. But the sixth petition isn't redundant — it addresses the *process* (resisting temptation in the meanwhile), while the seventh addresses the *outcome* (final liberation). A proof assistant is good at catching this kind of logical relationship that commentary tends to describe loosely.

## The Meta-Point: Precision as Discovery

The most important takeaway isn't any single theorem. It's that *forcing precision on familiar words reveals structure you didn't know was there*.

Everyone knows the Lord's Prayer has a "God part" and an "us part." But does everyone know the forgiveness petition targets guilt specifically, not temporal punishment? That the will-alignment petition is provably compatible with libertarian free will? That the kingdom petition reduces to communion?

These aren't claims I brought to the text. They're what fell out when the text had to type-check.

A proof assistant is merciless about vagueness. You can't write "forgiveness" without saying *which layer* of sin is being addressed. You can't write "thy will be done" without specifying what happens to free will. You can't write "kingdom" without saying what kind of thing a kingdom is. The Catechism has answers to all of these questions — scattered across hundreds of paragraphs, in natural language, surrounded by qualifications. The formalization forces them into one place, in one system, where the computer checks that they're consistent.

## The Bigger Picture

The Lord's Prayer formalization is one file in Catlib, which now spans over 40 formalizations covering topics from the Trinity to purgatory to angelic nature. The project's broader thesis is that your axiom set is your denomination: Catholic theology is a specific set of axioms; removing or adding axioms gives you a different tradition. The Lord's Prayer is a good test case because most of its content is *ecumenical* — all Christians agree on the prayer itself. The formal differences show up in the mechanisms (how does forgiveness work? what exactly is the Eucharist?) rather than the surface text.

Every axiom in the file is tagged with its denominational scope. Most are marked `ECUMENICAL`. The Eucharistic reading of "daily bread" is tagged `Catholic` — it relies on an axiom about sacramental efficacy that Protestants don't share. The formalization makes these dependencies visible. You can see exactly which conclusions require which axioms, and therefore which conclusions a given tradition can and cannot derive.

That's the promise of formal theology: not to settle disputes by computation, but to make the *structure* of disputes visible. When you can point to the exact axiom where two traditions diverge, you've at least upgraded the argument from "we disagree" to "we disagree about *this*."

And sometimes, if you're lucky, the computer shows you something in a two-thousand-year-old prayer that you never noticed before.
