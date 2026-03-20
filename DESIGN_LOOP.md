# The Catlib Loop

This document describes the full iterative process for the project.
There are two loops: one for producing formalizations, one for the site.
They feed each other.

---

## Loop 1: Formalization Loop

```
┌────────────────────────────────────────────────────────┐
│  1. SELECT                                             │
│     Pick a Catechism paragraph or argument chain.      │
│     Rank by uncertainty, not importance.                │
│     State your prediction before starting.              │
├────────────────────────────────────────────────────────┤
│  2. MODEL                                              │
│     Define the formal objects. This is the hard part.   │
│     - What type represents "person"? "grace"? "sin"?   │
│     - What axioms from Scripture/Tradition are needed?  │
│     - What is the "Catholic reading" axiom set?         │
│     Tag every axiom with its provenance.                │
├────────────────────────────────────────────────────────┤
│  3. FORMALIZE                                          │
│     Write the Lean theorem and proof.                   │
│     The proof is often simple. That's fine.              │
│     The modeling choices ARE the finding.                │
├────────────────────────────────────────────────────────┤
│  4. RECORD                                             │
│     Write the companion .md file.                       │
│     Compare prediction to outcome.                      │
│     Record hidden assumptions, axiom dependencies,      │
│     and surprise level.                                 │
│     Update ROADMAP.md with the finding.                 │
├────────────────────────────────────────────────────────┤
│  5. ASSESS                                             │
│     Score against acceptance criteria.                  │
│     Tier 3 = surprise found. Record it.                 │
│     Tier 2 = faithful, merge it.                        │
│     Tier 1 only = needs justification.                  │
├────────────────────────────────────────────────────────┤
│  6. FEED THE SITE                                      │
│     Add the finding to findings.json.                   │
│     Write the "hidden assumption" callout.              │
│     Write the plain-English summary.                    │
│     Run the site design loop if enough new findings.    │
└────────────────────────────────────────────────────────┘
```

### Parallelizing with agents

The formalization loop can be parallelized across independent paragraphs:

- **Research agent**: Reads the Catechism paragraph, identifies the
  logical chain, extracts the claims, and proposes what to formalize.
  Also does web search for existing formalizations or philosophical
  analysis of the argument.

- **Modeling agent**: Proposes formal definitions and axiom sets.
  This is the creative step — multiple modelings should be considered.

- **Formalization agent**: Writes the Lean code and proof.

- **Review agent**: Checks faithfulness (does the theorem match the
  paragraph?), scores against acceptance criteria, and writes the
  companion .md file.

These can run in parallel on different paragraphs, but modeling and
formalization for the SAME paragraph must be sequential.

---

## Loop 2: Site Design Loop

Adapted from the HPMOR project, where we ran 9 cycles and learned:

### Key lessons (do NOT relearn these)

1. **Lead with the most accessible finding, not the most technical.**
2. **The assumption-audit framing works.** "Before we could write the
   theorem, the proof assistant asked: [question the text never answers]."
3. **Personas must be deliberately unsophisticated.** If a persona
   already understands theology or formal verification, the prompt is
   too generous.
4. **Kill marketing tone immediately.** Understatement builds trust.
5. **The worked example is the MVP.** One finding, 4 steps: the claim →
   we tried to formalize it → the assumption we were forced to state →
   what the computer checked.
6. **Progressive disclosure.** English first, Lean on demand.
7. **"You can stop here" summary box** after the worked example gives
   casual readers a satisfying conclusion.
8. **Trim relentlessly.** Vanity metrics, insider jargon, dashboard
   stats, project management sections — cut them all.
9. **The code block needs a "just read the comments" hint.**
10. **3 CTAs max.** Read the source, browse the findings, check our work.

### The site loop

```
┌──────────────────────────────────────────────────┐
│  1. DESIGN + IMPLEMENT                          │
│     One subagent reads the brief, prior reviews, │
│     and current site files. Proposes AND          │
│     implements changes.                           │
├──────────────────────────────────────────────────┤
│  2. REVIEW (4 persona subagents, in parallel)    │
│     Each reads the updated site cold.             │
│     Personas are regular people, not experts.     │
├──────────────────────────────────────────────────┤
│  3. SYNTHESIZE                                   │
│     Read all reviews, identify convergent issues, │
│     decide priorities for next cycle.              │
├──────────────────────────────────────────────────┤
│  4. FIX + GOTO 1                                 │
└──────────────────────────────────────────────────┘
```

### Personas for the Catechism site

| Persona | Description | Weight |
|---------|-------------|--------|
| A — Practicing Catholic | Goes to Mass, knows the Catechism exists but hasn't read most of it. Wants to understand their faith better. Skeptical of "attacks" on the Church. | High |
| B — Your dad | 55-year-old professional. Not particularly religious. Smart. Doesn't know what formal verification is. "What's a catechism?" | High |
| C — Your girlfriend | Non-technical, maybe spiritual but not practicing. Supportive but honest. Will tune out if it gets too academic. | High |
| D — Zero-context curious person | Found this via Twitter. Intellectually curious. Zero knowledge of Catholicism beyond cultural basics, zero knowledge of Lean. | Highest |
| E — Catholic theologian/philosopher | Knows Aquinas, knows the arguments. Will catch any misrepresentation. Skeptical that a computer can add value to 2000 years of tradition. | Normal (but veto power on faithfulness) |

### Standard question set

Each persona answers:
1. First screen — interested or lost?
2. What does this project do? Explain it back.
3. Does it feel respectful or like an attack?
4. What was actually interesting?
5. Where did your eyes glaze over?
6. Would you share this? With whom?

---

## Bootstrapping sequence

The project needs a critical mass of findings before the site is worth
building. Suggested order:

### Phase 1: Foundations (weeks 1-2)
- Define core types: God, Person, Grace, Sin, Virtue, Authority
- Establish the axiom provenance system
- Formalize 2-3 "easy" paragraphs to calibrate the tooling

### Phase 2: First findings (weeks 3-6)
- Target 5-8 paragraphs across Parts I and III
- Prioritize by uncertainty — look for hidden assumptions
- Write companion .md files for all

### Phase 3: Site v1 (week 7)
- Create findings.json from Phase 2 results
- Build the microsite (copy the HPMOR site structure)
- Run 3-4 persona review cycles
- Deploy

### Phase 4: Expand (ongoing)
- Continue formalization loop
- Update site as findings accumulate
- Run site design loop every 5-10 new findings

---

## What makes this project different from HPMOR

| Dimension | HPMOR | Catechism |
|-----------|-------|-----------|
| Source material | A novel (one author, one voice) | A 2,865-paragraph institutional document |
| Axiom source | Mathematical definitions, decision theory | Scripture, Tradition, Natural Law |
| "Catholic reading" equivalent | N/A (claims are self-contained) | Explicit — the denominational reading IS the axiom set |
| Audience risk | "It's about Harry Potter fanfic" (credibility tax) | "It's attacking my religion" (emotional tax) |
| Tone calibration | Irreverent, witty | Respectful, precise, genuinely loving |
| Formalizability | Most claims map to known math | Many claims require novel ontological modeling |
| Surprise potential | High (rationalist claims are testable) | Very high (2000 years of arguments, many never formalized) |
