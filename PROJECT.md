# Catlib: Formalizing the Catholic Catechism

## What this is

A Lean 4 project that translates claims from the Catechism of the Catholic
Church into machine-checked formalizations — not to attack them, but to
discover what they assume.

## The thesis (from the HPMOR project)

We learned from formalizing HPMOR that the proofs are often simple. The
hard part — and the interesting part — is that a proof assistant won't
let you state a claim until you've named every assumption it depends on.

The finding is never the proof. The finding is the assumption you didn't
know you were making.

Applied to the Catechism: Catholic teaching contains chains of reasoning
that rest on premises — some stated, some not. Formalization forces every
premise into the open. The interesting output is not "is this true?" but
"what must you assume for this to hold?"

## Spirit

This is a love letter to the Catholic intellectual tradition. The Church
has 2000 years of rigorous philosophical reasoning — Aquinas, Augustine,
the Scholastics. Formalization honors that tradition by taking the
arguments seriously enough to check every step.

The tone is: "We took your arguments as seriously as you do. Here is what
we found when we tried to write them down with total precision."

This is NOT:
- A takedown or a debunking
- "Science vs. religion"
- Cherry-picking absurdities
- Condescending to believers

This IS:
- An assumption audit
- A record of what the reasoning requires
- A love letter written in Lean

## What we learned from the HPMOR project

These lessons are hard-won and should be baked into this project from day one.

### On formalization

1. **The proofs are often trivial.** The value is in the modeling choices,
   not the proof difficulty. Choosing the right definitions, noticing what
   assumptions you need — that's where the insight lives.

2. **State your prediction before you start.** Before formalizing a
   paragraph, write what you expect to find. Compare afterward. The gap
   between prediction and reality is the finding.

3. **Rank claims by your uncertainty about the outcome.** If you already
   know what will happen, don't bother. The best targets are claims where
   you genuinely can't predict whether they'll confirm, reveal a hidden
   assumption, or resist formalization entirely.

4. **The "Catholic reading" IS the axiom set.** We will need to model
   things like: what does "eternal" mean? What is the structure of grace?
   What model of causation applies to God? These modeling choices are not
   bugs — they are the entire point. Each one is an assumption we're
   making explicit.

5. **Record what surprises you.** The project's value comes from the gap
   between "what we expected" and "what we found." If nothing surprises
   you, the claim was too easy.

### On the site

6. **Lead with the most accessible finding, not the most technical.**
   Order by "would my dad find this interesting?" not by proof difficulty.

7. **The assumption-audit framing works.** "We tried to formalize X.
   Before we could write the theorem, the proof assistant asked: [question
   the original text never answers]." This is the narrative structure
   for every finding.

8. **Explain formal verification once, simply.** "A tool that won't let
   you skip steps. It forces you to say out loud what you were assuming
   in silence." Then never re-explain.

9. **Use personas who are deliberately unsophisticated.** Test the site
   with simulated readers who don't know what Lean is, what formal
   verification means, or why anyone would do this. If they bounce, the
   page failed.

10. **Progressive disclosure.** English first, Lean on demand. Most
    readers will never look at the code. The annotations and plain-English
    summaries do the real communication.

## Categorizing the Catechism

Not all paragraphs are amenable to formalization. The Catechism has
~2,865 paragraphs across 4 parts:

| Part | Content | Formalizability |
|------|---------|-----------------|
| **I: The Profession of Faith** | Creed, theology proper, Christology, pneumatology, ecclesiology, eschatology | HIGH — contains logical chains, causal claims, definitions with structure |
| **II: The Celebration of the Christian Mystery** | Sacraments, liturgy | MEDIUM — some structural claims (validity conditions, effects), much is ritual/pastoral |
| **III: Life in Christ** | Moral theology, virtues, commandments | HIGH — ethical reasoning, moral logic, natural law arguments with premise chains |
| **IV: Christian Prayer** | Prayer, Our Father commentary | LOW — mostly devotional, some structural claims about prayer's nature |

### What to formalize

- **Logical chains**: "Because X, therefore Y" — does Y actually follow from X?
- **Definitions with structure**: "Grace is..." — what does this definition entail?
- **Moral reasoning**: "It is wrong to X because Y" — what assumptions bridge Y to the conclusion?
- **Claims about nature**: "The human person is..." — what model of personhood is assumed?
- **Necessity claims**: "X is necessary for Y" — is it? Under what conditions?

### What NOT to formalize

- Pure devotional text (prayers, exhortations)
- Historical narrative without logical claims
- Aesthetic or liturgical prescriptions
- Claims that are explicitly declared mystery (Trinity's inner life, etc.)
  — though we CAN formalize what "mystery" means structurally

### What we might need to model from the Gospels

Some Catechism arguments rest on Gospel events or sayings. We will need
to formalize these as axioms — not proving them true, but stating them
precisely enough to reason from them. Examples:

- "Jesus said to Peter: 'You are Peter, and on this rock I will build my
  church'" → axiom about delegation of authority
- The Last Supper narrative → axioms about sacramental institution
- The Resurrection → axiom about a specific event with specific properties

The Catholic reading of these texts is itself an assumption we make
explicit. A Protestant reading would yield different axioms. That's not
a problem — it's a feature. The axiom set IS the denomination.

## Project structure (planned)

```
catlib/
├── lakefile.lean
├── lean-toolchain
├── Catlib/
│   ├── Foundations/          ← Core definitions (God, grace, nature, person)
│   ├── Creed/               ← Part I formalization
│   ├── Sacraments/          ← Part II (selective)
│   ├── MoralTheology/       ← Part III formalization
│   └── Prayer/              ← Part IV (selective)
├── CATECHISM_CLAIMS.md       ← Extracted claims, ranked by uncertainty
├── ACCEPTANCE_CRITERIA.md    ← Tier system adapted from HPMOR project
├── ROADMAP.md                ← Findings tracker
├── site/                     ← Public microsite
│   ├── index.html
│   ├── styles.css
│   ├── app.js
│   └── data/findings.json
└── DESIGN_LOOP.md            ← Site optimization process
```
