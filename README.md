# Catlib

**Formalizing the Catholic Catechism in Lean 4.**

A proof assistant won't let you skip steps. It forces you to say out loud what you were assuming in silence. We pointed one at the Catholic Catechism — not to attack it, but to see what it assumes.

This is a love letter to the Catholic intellectual tradition. The Church has 2,000 years of rigorous philosophical reasoning — Aquinas, Augustine, the Scholastics. We are doing what they did — examining premises — with a tool they didn't have.

Formal verification doesn't tell you who's right. It tells you exactly which assumptions produce which conclusions — and when 1,900 years of consensus broke, it can show you the single axiom that changed.

## The vision

Catlib is building toward a **formally verified theological reasoning engine** — ask a question in natural language, get a machine-checked answer grounded in Scripture and Tradition, with the axioms visible.

```
"Can a priest perform an exorcism without the bishop's permission?"
  → No. The authority chain requires: Christ → Apostles → Bishops → Priests.
    Ordination gives potential; the bishop's permission activates it.
    [Axioms: Mk 6:7, Heb 5:4, CCC §1673]
    [Denomination: Catholic ✓ | Orthodox ✓ | Protestant: varies]

"Was Martin Luther right about justification?"
  → Under Catholic axioms (S8, T2, T3): No — grace transforms, humans cooperate,
    sacraments confer grace.
  → Under Lutheran axioms (S8', T2', drop T3): Yes — grace declares righteous,
    God alone acts, faith alone suffices.
  → The disagreement reduces to 4 axiom swaps. Both sides reason correctly
    from their premises. The question is which axioms to accept.
    [See: site/articles/luther.html]

"What does the Catechism say about suicide?"
  → CCC §2280-2283. Suicide contradicts natural law (S6) and love of self/God (S1).
    BUT §2283: psychological suffering can diminish culpability (ties to Freedom
    axiom S7 — diminished freedom = diminished responsibility).
    "We should not despair of the eternal salvation of persons who have taken
    their own lives." God's mercy (S2) extends beyond our understanding.
    [Denomination: Ecumenical ✓]

"How should Catholics think about contraception?"
  → The inseparability principle (Humanae Vitae §12): every conjugal act
    must retain both unitive and procreative meaning.
  → For 1,900 years, ALL Christians agreed. Then Lambeth 1930 made one
    axiom swap — and every Protestant denomination followed within decades.
  → Under Catholic axioms (inseparability): contraception is intrinsically evil.
  → Under Protestant axioms (separability, post-1930): contraception
    is permitted in marriage.
  → The entire debate is one axiom.
    [See: site/articles/conjugal-ethics.html]
```

Every answer shows its axiom dependencies and denominational scope. You can see exactly what you'd need to accept or reject to hold a different position.

## The axiom base: 2 / 9 / 3

We traced the hidden assumptions across our formalizations back to **14 base axioms**:

**9 Scriptural** — with full verse references:

| Axiom | Key verses | Scope |
|-------|-----------|-------|
| S1. God is love; love requires freedom | 1 Jn 4:8; Dt 30:19 | Ecumenical |
| S2. God desires all to be saved | 1 Tim 2:4 | Catholic + Lutheran |
| S3. Moral law written on hearts | Rom 2:14-15 | Ecumenical |
| S4. Universal providence | Mt 10:29; Is 46:10 | Ecumenical |
| S5. Sin separates from God | 1 Jn 3:14-15; Rom 6:23 | Ecumenical |
| S6. Moral realism | Rom 1:20; Rom 2:14-15 | Ecumenical |
| S7. Freedom aims at the good; sin = slavery | Jn 8:34-36; Gal 5:1 | Ecumenical |
| S8. Grace necessary and transformative | Jn 15:5; 2 Cor 5:17; Ezek 36:26 | **Catholic** |
| S9. Conscience binds | Rom 14:23; Acts 24:16 | Ecumenical |

**3 Tradition** — with Council references:

| Axiom | Sources | Scope |
|-------|---------|-------|
| T1. Libertarian free will | Sir 15:14; Trent Session 6 | **Catholic** |
| T2. Grace preserves freedom (synergism) | Phil 2:12-13; Trent Session 6 | **Catholic** |
| T3. Sacraments confer grace (ex opere operato) | Jn 3:5; Acts 2:38; Trent Session 7 | **Catholic** |

**2 Philosophical** — the irreducible non-scriptural residue:

| Axiom | Origin | Scope |
|-------|--------|-------|
| P2. Two-tier causation | Aquinas | Broadly shared |
| P3. Evil is privation | Augustine/Aquinas | Broadly shared |

(An earlier draft included a third philosophical axiom, P1 hylomorphism. That content now lives in `Soul.lean` as the `HumanPerson` type rather than as a base axiom — the body-soul composite is modeled structurally, not asserted propositionally.)

**The denominational insight:** S8, T1, T2, T3 are the axioms that make you Catholic. Luther's Reformation was a specific set of modifications to these 4 axioms — forensic grace, monergism, faith alone, signs not causes. Change these axioms, change the denomination. See the [full analysis](site/articles/luther.html).

## Philosophical machinery we import

Formalizing the Catechism in Lean 4 requires machinery that is not in the Catechism itself — and in some cases, not in Scripture either. We are transparent about this. The proof assistant requires precision the original texts do not provide, and filling those gaps means making philosophical commitments.

### Teleological realism

The Catechism assumes that things have natural ends (purposes) and that deliberately thwarting those ends is wrong. §1955 says the natural law "shows man the way to practice the good **and attain his end**." Humanae Vitae §12 says the conjugal act has an "inseparable connection" between its unitive and procreative meanings — a teleological claim.

But the Catechism never names this framework. It does not cite Aristotle's *Physics* or Aquinas's formal/final cause distinction. It *assumes* teleological realism without stating it as a principle.

We make it explicit: `teleological_realism` and `frustration_is_evil` in `NaturalLaw.lean`, built on the `NaturalEnd` structure and the `deliberatelyFrustrates` predicate. These axioms say that natural ends are real features of the world and that deliberately thwarting them is intrinsically evil. Together they generate the inseparability principle (now a theorem in `ConjugalEthics.lean`, not an axiom) and the entire Catholic position on contraception.

**This is Aristotle, not the Gospels.** The teleological framework comes from Greek philosophy, adopted by Aquinas, and woven so deeply into Catholic moral theology that the Catechism treats it as obvious. We flag it because someone approaching the CCC from a non-Aristotelian tradition (most Protestants, most secular ethicists) would not share this starting point — and the conclusions (on contraception, on natural law, on the moral significance of physical acts) only follow if you accept it.

### Law of excluded middle

Lean 4 uses classical logic, which includes the law of excluded middle: every proposition is either true or false. Our `moral_realism` axiom (`∀ p, p.content ∨ ¬p.content`) is technically just excluded middle applied to moral propositions. But the *philosophical claim* matters: we are assuming that moral propositions have definite truth values, not that they are expressions of preference, culture, or emotion.

This is a commitment to **moral cognitivism** — the view that moral statements are truth-apt. The Catechism assumes this throughout (§1954: the natural law "enables man to discern by reason the good and the evil"). But it is not a universally shared philosophical position, and our formalization bakes it in at the deepest level.

### The body matters (hylomorphic anthropology)

Our `HumanPerson` opaque type in `Soul.lean` (following §365: "the soul is the form of the body") treats the person as an indivisible body-soul composite. The body is not packaging for the soul — it is constitutive of personhood. This Aristotelian-Thomistic anthropology is modeled structurally (as the `HumanPerson` type with corporeal and spiritual aspects) rather than as a propositional axiom. It drives our formalization of:

- **The Assumption** of Mary (she was taken up *body and soul* — a complete person, not just a soul)
- **Conjugal ethics** (what you do *to the physical act* determines its moral object, independent of intent)
- **The resurrection** (the endpoint is not a disembodied soul in heaven but a *risen body*)

This is not a neutral modeling choice. A Cartesian dualist (soul and body as separate substances) or a materialist (no soul) would model these doctrines very differently — and some conclusions would not follow.

### Substance and accidents (transubstantiation)

The Eucharist formalization requires the Aristotelian distinction between **substance** (what a thing IS) and **accidents** (what a thing APPEARS to be). §1376 says the "whole substance" of bread is converted into the substance of Christ's body, while "the appearances of bread and wine remain."

This distinction is not from Scripture. It is Aristotelian metaphysics, adopted by Aquinas (ST III, q.75), codified at the Council of Trent (Session XIII, 1551). The Catechism uses it without naming Aristotle — it just says "substance" and "species" as if these are obvious categories.

We make it explicit: `EucharisticSubstance` and `EucharisticAccidents` in `Eucharist.lean`. Consecration changes the substance (bread → Christ) while preserving the accidents (still looks and tastes like bread). This is what makes transubstantiation coherent: `corporeal_requires_spiritual` from Soul.lean (a body requires a soul) is satisfied because the **substance** present after consecration is Christ (who has a soul), not bread. The bread-like appearances are accidents — they don't need a soul because they're not a substance.

**This is Aristotle and Aquinas, not the Gospels.** A philosopher who rejects the substance/accident distinction (most modern analytic philosophers, most Protestants) would find the transubstantiation claim literally inexpressible in their framework. The Lutheran alternative (consubstantiation — Christ present "in, with, and under" the bread, which remains bread) does not require this Aristotelian machinery. We flag the dependency because it is load-bearing: without substance/accident, transubstantiation cannot even be stated.

### Adequation of intellect to reality (*adaequatio rei et intellectus*)

The CCC asserts in §36 that God "can be known with certainty from the created world by the natural light of human reason." But it never explains *why* human reason should be reliable. The answer requires combining two separate CCC claims:

- §299: "Because God creates through **wisdom**, his creation is ordered"
- §1700: "The dignity of the human person is rooted in his creation in the **image** and likeness of God"

The same rational wisdom that *ordered the world* also *structured the mind that studies it*. The match between knower and known is not a coincidence — both are products of the same rational source. This is Aquinas's definition of truth: *adaequatio rei et intellectus* ("the adequation of the thing and the intellect," ST I q.16 a.1). The intellect is adequate to reality because both participate in divine wisdom.

We make this explicit in `ScientificInquiry.lean`, which derives two propositions from CCC axioms: (A) the world is logical (from §299 + §306 + P2) and (B) humans can understand that logic (from §1700/imago_dei + §299 + §36). Proposition B depends on Proposition A — you can't understand a logical world unless it *is* logical first. Together they provide the metaphysical preconditions for scientific inquiry.

**This is Aquinas, not the Gospels.** The *adaequatio* thesis presupposes that human cognitive faculties are reliably aimed at truth — a commitment the CCC inherits from Thomistic epistemology without naming it. A Humean skeptic (our categories may not match reality), a Kantian (we know appearances, not things-in-themselves), or a Barthian (reason is too fallen to know God from nature) would each reject a different step in this chain.

### What this means

We are not smuggling in conclusions. We are being honest: the Catechism's positions on contraception, the body, natural law, moral realism, and the reliability of reason *require* philosophical machinery that comes from the Aristotelian-Thomistic tradition, not from Scripture alone. The Catechism rarely acknowledges this. We do.

If you reject teleological realism, the inseparability principle falls. If you reject moral cognitivism, natural law theory loses its foundation. If you reject hylomorphic anthropology, the Assumption is just "Mary went to heaven" rather than "Mary went to heaven *bodily*." If you reject the *adaequatio*, you lose the grounding for natural theology and the CCC's claim that God is knowable by reason. Each philosophical commitment is load-bearing, and we label each one.

## What we found

23 formalizations, all revealing hidden assumptions:

| Passage | Finding |
|---------|---------|
| **Sources of Morality** (§1750-1756) | "Intrinsically evil" requires an unstated axiom: an action's moral character is fixed regardless of context |
| **Sin** (§1849-1864) | The mortal/venial system requires five binary assumptions the text never states |
| **Hell** (§1033+1037) | "Self-exclusion" only works under libertarian free will — and the text never explains why love requires freedom |
| **Grace** (§2001-2002) | "You need grace to prepare for grace" is a genuine circularity requiring a typed grace hierarchy |
| **Trinity** (§253-255) | Cannot be modeled with standard equality — requires relative identity ("same God" ≠ "same person") |
| **Natural Law** (§1954-1957) | If universal AND accessible to reason, then disagreement is always a failure of reason. Teleological framework (`NaturalEnd`, `teleological_realism`, `frustration_is_evil`) makes the Aristotelian roots explicit |
| **Conscience** (§1776-1791) | The erring conscience paradox: acting against conscience is categorically worse than following an erring one |
| **Providence** (§302-311) | God "operates through" good but only "permits" evil — requires evil to be a privation |
| **Soul** (§355-365) | The Catechism adopts Aristotelian hylomorphism without naming it. `HumanPerson` is the body-soul composite type |
| **Freedom** (§1730-1738) | Perfect freedom is the *inability* to sin |
| **Legitimate Defense** (§2263-2267) | Proportionality assumes accurate threat assessment under crisis conditions |
| **Justification** (§1987-1993) | Catholic vs. Protestant = difference in axiom sets; the axiom set IS the denomination |
| **Exorcism** (§1673) | Authority delegation chain Christ→Apostles→Bishops→Priests; demons are literal personal agents |
| **Purgatory** (§1030-1032) | Post-mortem purification requires distinguishing "death finalizes choice" from "death finalizes state"; strongest proof text (2 Macc 12:46) depends on which canon you accept |
| **Divine Modes** (§301 + §1033) | God relates to creation in two modes: sustaining (holds in being) and beatifying (offers communion). Hell is separation from beatifying mode only — the damned still exist because God sustains them. Unifies hell, purgatory, providence, and evil-as-privation into one framework |
| **Conjugal Ethics** (§2366-2372) | The inseparability principle (now a theorem derived from `teleological_realism` + `frustration_is_evil`): 1,900 years of Christian consensus broken by one axiom swap at Lambeth 1930. `physical_act_determines_object` grounds the claim that the physical act itself has moral content |
| **Christology** (§464-478) | The four Chalcedonian negatives (without confusion/change/division/separation) each rule out exactly one heresy. Christ's human nature follows the same body-soul rules as Soul.lean |
| **Eucharist** (§1322-1419) | Each sacrament maps to a layer: Baptism→L1, Reconciliation→L2, Eucharist→L3. The CCC never states this — it emerges from formalization. Transubstantiation requires the Aristotelian substance/accident distinction; `corporeal_requires_spiritual` is satisfied because the substance is Christ (who has a soul), not bread |
| **Marian Dogma** (§490-511, §966) | Four Marian dogmas (Theotokos, Immaculate Conception, Perpetual Virginity, Assumption) all require `HumanPerson` (body-soul composite). The Assumption (`bodilyAssumed`) means bodily — not just "went to heaven" |
| **Original Sin** (§396-409) | Universal inheritance of original sin, with formal exception for Mary (Immaculate Conception). The inheritance axiom + preservation axiom yield the exception as a theorem |
| **Reconciliation** (§1440-1449) | Sacramental restoration of communion with God — sin breaks `inCommunion (.person p) .god`, reconciliation restores it |
| **Suicide** (§2280-2283) | Suicide contradicts natural law, but psychological suffering can diminish culpability. Hope for salvation follows from God's mercy (S2) + diminished freedom (S7) |
| **Theology of the Body** | The personalist norm: the body is not an instrument but constitutive of the person. Grounds the inseparability principle from a different direction than teleological realism |

## Articles

| Article | Question answered |
|---------|------------------|
| [Luther's Axioms](site/articles/luther.html) | Where do Catholics and Lutherans actually disagree? (4 axiom swaps) |
| [Forgiveness](site/articles/forgiveness.html) | Why do Catholics believe priests can forgive sins? |
| [Purgatory](site/articles/purgatory.html) | How do we know purgatory exists? (depends on which Bible) |
| [Divine Modes](site/articles/divine-modes.html) | If God sustains everything, how can hell be "separation from God"? |
| [Conjugal Ethics](site/articles/conjugal-ethics.html) | How should Catholics think about family size and contraception? |
| [The Limits of Proof](site/articles/limits.html) | Where does formalization stop? (the self-control hypothesis) |
| [Priestly Authority](site/articles/priestly-authority.html) | Where does priestly authority come from, specifically? |
| [The Mathematics of Culpability](site/articles/culpability-math.html) | What mathematical structure does culpability have? |
| [Communion](site/articles/communion.html) | What is "communion"? (a binary relation the Catechism never defines) |
| [Body and Soul](site/articles/body-and-soul.html) | What does the Catechism mean by "the soul is the form of the body"? |
| [The Geometry of Grace](site/articles/geometry-of-grace.html) | What shape does grace have? |
| [The Mathematics of Love](site/articles/love-math.html) | What mathematical structure does love have? |
| [Reconciliation](site/articles/reconciliation.html) | How does sacramental reconciliation restore communion? |

## What formalization can and cannot do

| Question type | Can formalization help? | Example |
|--------------|------------------------|---------|
| "What does the Catechism assume?" | **YES** — this is our core strength | Object independence axiom |
| "Is this logically consistent?" | **YES** — proof assistant checks this | Trinity requires relative identity |
| "Where do denominations disagree?" | **YES** — axiom set comparison | Lutheran 4-axis swap |
| "What follows from these axioms?" | **YES** — theorem derivation | Contraception is intrinsically evil (given inseparability) |
| "Did axiom X cause real-world effect Y?" | **NO** — this is empirical, not logical | Did the separability axiom cause declining sexual temperance? |
| "Which axiom set is TRUE?" | **NO** — that's faith, not logic | Is the inseparability principle true? |
| "What would have happened if...?" | **NO** — counterfactuals need data | What if Lambeth 1930 hadn't happened? |

Being honest about limits is part of the love letter. Knowing where formalization stops is as important as knowing where it starts.

## How we reason about questions

When someone asks a theological question, the system:

1. **Identifies relevant axioms** from the 14 base axioms
2. **Checks for cached theorems** — has this been formally proven before?
3. **If not cached, reasons from axioms** — constructs a proof attempt
4. **Tags the result** with denominational scope — Catholic? Lutheran? Ecumenical?
5. **Shows axiom dependencies** — which Scripture, Tradition, or philosophical commitments does the answer rest on?
6. **Caches the result** as a new theorem in catlib

This means you can ask: "Under what assumptions was Luther's position logical?" and get a precise answer: "Under axioms S1-S7, S9 (shared), plus L1-L4 (Lutheran distinctives), his position is internally consistent."

## Building

Requires [Lean 4](https://lean-lang.org/) (v4.16.0).

```bash
lake build
```

## Tools

`theorem-tree` — dependency analysis and visualization with two modes:

| Mode | Speed | Accuracy | Requirements |
|------|-------|----------|--------------|
| Regex (`--flow`, `--trace`, `--connections`, etc.) | Fast | Approximate | Python 3 only |
| Kernel (`--true-islands`, `--kernel`, `--compare`, `--props`) | Slow | Exact | Python 3 + `lake build` |

```bash
# Quick overview: what does this file declare and depend on?
./tools/theorem-tree Catlib/Creed/Hell.lean

# Dependency flow: axioms → theorems → derived results
./tools/theorem-tree --flow Catlib/MoralTheology/TheologyOfBody.lean

# Kernel-verified unused axioms (slow, needs lake)
./tools/theorem-tree --true-islands Catlib/

# What axioms does a specific theorem actually depend on?
./tools/theorem-tree --kernel hope_for_salvation_of_suicide Catlib/

# Proposition-centric analysis: what has been proven?
./tools/theorem-tree --props Catlib/
```

`axiom-wiki` — generates a browsable wiki of all axioms with cross-references.

See [`tools/README.md`](tools/README.md) for full documentation.

## Project structure

```
Catlib/
├── Foundations/
│   ├── Basic.lean         ← Core types + Denomination tags
│   ├── Axioms.lean        ← The 14 base axioms (2P/9S/3T)
│   ├── Authority.lean     ← General authority delegation chain
│   ├── HumanNature.lean   ← Shared human nature predicates
│   ├── Love.lean          ← Love vocabulary and axioms
│   └── SinEffects.lean    ← Sin effects on communion and grace
├── Creed/                 ← Christology, Hell, Grace, Trinity, Providence, Soul,
│                            Purgatory, DivineModes, MarianDogma, OriginalSin
├── MoralTheology/         ← Sources, Sin, Natural Law, Conscience, Freedom,
│                            Legitimate Defense, Justification, ConjugalEthics,
│                            TheologyOfBody, Suicide
└── Sacraments/            ← Eucharist, Exorcism, Reconciliation
tools/
├── theorem-tree           ← Dependency analysis and visualization
└── axiom-wiki             ← Browsable axiom wiki generator
site/
├── index.html
├── styles.css
└── articles/              ← Luther, Forgiveness, Purgatory, Divine Modes,
                             Conjugal Ethics, Limits, Priestly Authority,
                             Culpability Math, Communion, Body & Soul,
                             Geometry of Grace, Love Math, Reconciliation
```

## Spirit

This is NOT:
- A takedown or a debunking
- "Science vs. religion"
- Cherry-picking absurdities
- A tool for winning arguments

This IS:
- An assumption audit
- A record of what the reasoning requires
- A tool for ecumenical understanding — seeing exactly where traditions agree and disagree
- A love letter written in Lean

## License

Catlib's original code, formalizations, tools, and site content are licensed under the [MIT License](LICENSE).

The Catechism text is from the [Vatican's official English translation](https://www.vatican.va/archive/ENG0015/_INDEX.HTM) and remains subject to its own source terms.
