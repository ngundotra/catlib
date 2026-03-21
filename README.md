# Catlib

**Formalizing the Catholic Catechism in Lean 4.**

A proof assistant won't let you skip steps. It forces you to say out loud what you were assuming in silence. We pointed one at the Catholic Catechism — not to attack it, but to see what it assumes.

This is a love letter to the Catholic intellectual tradition. The Church has 2,000 years of rigorous philosophical reasoning — Aquinas, Augustine, the Scholastics. We are doing what they did — examining premises — with a tool they didn't have.

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
```

Every answer shows its axiom dependencies and denominational scope. You can see exactly what you'd need to accept or reject to hold a different position.

## The axiom base: 3 / 9 / 3

We traced 44 hidden assumptions across 13 formalizations back to **15 base axioms**:

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

**3 Philosophical** — the irreducible non-scriptural residue:

| Axiom | Origin | Scope |
|-------|--------|-------|
| P1. Hylomorphism (soul as form of body) | Aristotle via Aquinas | Catholic |
| P2. Two-tier causation | Aquinas | Broadly shared |
| P3. Evil is privation | Augustine/Aquinas | Broadly shared |

**The denominational insight:** S8, T1, T2, T3 are the axioms that make you Catholic. Luther's Reformation was a specific set of modifications to these 4 axioms — forensic grace, monergism, faith alone, signs not causes. Change these axioms, change the denomination. See the [full analysis](site/articles/luther.html).

## What we found

13 formalizations, all revealing hidden assumptions:

| Passage | Finding |
|---------|---------|
| **Sources of Morality** (§1750–1756) | "Intrinsically evil" requires an unstated axiom: an action's moral character is fixed regardless of context |
| **Sin** (§1849–1864) | The mortal/venial system requires five binary assumptions the text never states |
| **Hell** (§1033+1037) | "Self-exclusion" only works under libertarian free will — and the text never explains why love requires freedom |
| **Grace** (§2001–2002) | "You need grace to prepare for grace" is a genuine circularity requiring a typed grace hierarchy |
| **Trinity** (§253–255) | Cannot be modeled with standard equality — requires relative identity ("same God" ≠ "same person") |
| **Natural Law** (§1954–1957) | If universal AND accessible to reason, then disagreement is always a failure of reason |
| **Conscience** (§1776–1791) | The erring conscience paradox: acting against conscience is categorically worse than following an erring one |
| **Providence** (§302–311) | God "operates through" good but only "permits" evil — requires evil to be a privation |
| **Soul** (§355–365) | The Catechism adopts Aristotelian hylomorphism without naming it |
| **Freedom** (§1730–1738) | Perfect freedom is the *inability* to sin |
| **Legitimate Defense** (§2263–2267) | Proportionality assumes accurate threat assessment under crisis conditions |
| **Justification** (§1987–1993) | Catholic vs. Protestant = difference in axiom sets; the axiom set IS the denomination |
| **Exorcism** (§1673) | Authority chain Christ→Apostles→Bishops→Priests; demons are literal personal agents |

## How we reason about questions

When someone asks a theological question, the system:

1. **Identifies relevant axioms** from the 15 base axioms
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

## Project structure

```
Catlib/
├── Foundations/
│   ├── Basic.lean         ← Core types + Denomination tags
│   └── Axioms.lean        ← The 15 base axioms (3P/9S/3T)
├── Creed/                 ← Part I: Hell, Grace, Trinity, Providence, Soul
├── MoralTheology/         ← Part III: Sources, Sin, Natural Law, Conscience,
│                            Freedom, Legitimate Defense, Justification
└── Sacraments/            ← Part II: Exorcism (and more to come)
site/
├── index.html             ← Public microsite (illuminated manuscript aesthetic)
├── styles.css             ← Cinzel + Cormorant Garamond + UnifrakturMaguntia
└── articles/              ← Deep dives (Luther, etc.)
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

The Catechism text is from the [Vatican's official English translation](https://www.vatican.va/archive/ENG0015/_INDEX.HTM). The formalizations and site are original work.
