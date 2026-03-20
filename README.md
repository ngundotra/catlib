# Catlib

**Formalizing the Catholic Catechism in Lean 4.**

A proof assistant won't let you skip steps. It forces you to say out loud what you were assuming in silence. We pointed one at the Catholic Catechism — not to attack it, but to see what it assumes.

This is a love letter to the Catholic intellectual tradition. The Church has 2,000 years of rigorous philosophical reasoning — Aquinas, Augustine, the Scholastics. We are doing what they did — examining premises — with a tool they didn't have.

## What we found

We formalized 12 passages from the Catechism. Every one revealed assumptions the text didn't state. All findings are Tier 3 (genuinely surprising).

| Passage | Finding |
|---------|---------|
| **Sources of Morality** (§1750–1756) | "Intrinsically evil" requires an unstated axiom: an action's moral character is fixed regardless of context |
| **Sin** (§1849–1864) | The mortal/venial system requires five binary assumptions the text never states |
| **Hell** (§1033+1037) | "Self-exclusion" only works under libertarian free will — and the text never explains why love requires freedom |
| **Grace** (§2001–2002) | "You need grace to prepare for grace" is a genuine circularity requiring a typed grace hierarchy |
| **Trinity** (§253–255) | Cannot be modeled with standard equality — requires relative identity ("same God" ≠ "same person") |
| **Natural Law** (§1954–1957) | If universal AND accessible to reason, then disagreement is always a failure of reason — an extraordinarily strong hidden claim |
| **Conscience** (§1776–1791) | The erring conscience paradox: acting against conscience is categorically worse than following an erring one |
| **Providence** (§302–311) | God "operates through" good but only "permits" evil — requires evil to be a privation, not a positive reality |
| **Soul** (§355–365) | The Catechism adopts Aristotelian hylomorphism without naming it — incompatible with common-sense dualism |
| **Freedom** (§1730–1738) | Perfect freedom is the *inability* to sin — directly contradicts what most people mean by "freedom" |
| **Legitimate Defense** (§2263–2267) | Proportionality assumes accurate threat assessment under crisis conditions — an epistemic gap the text ignores |
| **Justification** (§1987–1993) | Catholic vs. Protestant = difference in axiom sets; the axiom set IS the denomination |

## The thesis

The proofs are often simple. The value is in the modeling choices — the assumptions you're forced to name. The finding is never "is this true?" but "what must you assume for this to hold?"

## Building

Requires [Lean 4](https://lean-lang.org/) (v4.16.0).

```bash
lake build
```

## Project structure

```
Catlib/
├── Foundations/       ← Core types (Person, Action, Grace, Sin, Authority)
├── Creed/            ← Part I: Hell, Grace, Trinity, Providence, Soul
└── MoralTheology/    ← Part III: Sources, Sin, Natural Law, Conscience,
                        Freedom, Legitimate Defense, Justification
site/                 ← Public microsite (HTML/CSS, no JS framework)
```

Each formalization has a companion `.md` file with:
- The Catechism claim in plain words
- How we modeled it
- What we found (hidden assumptions, prediction vs. reality)

## The microsite

Open `site/index.html` in a browser. The site uses the assumption-audit framing: "We tried to formalize X. Before we could write the theorem, the proof assistant asked: [question the original text never answers]."

## Spirit

This is NOT:
- A takedown or a debunking
- "Science vs. religion"
- Cherry-picking absurdities

This IS:
- An assumption audit
- A record of what the reasoning requires
- A love letter written in Lean

## License

The Catechism text is from the [Vatican's official English translation](https://www.vatican.va/archive/ENG0015/_INDEX.HTM). The formalizations and site are original work.
