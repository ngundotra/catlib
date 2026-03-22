# Contributing to Catlib

## Running items — things we want to come back to

### Priority 1: Formalization quality fixes (from project review)

- [ ] **Fix T2 formalization** — `t2_grace_preserves_freedom` in Axioms.lean is currently `P ∨ ¬P` (law of excluded middle). This is a tautology — a Lutheran would accept it trivially. Should assert something a monergist would DENY: "there exists a state where grace is given and the person genuinely could either cooperate or not."

- [ ] **Fix FITTINGNESS_AS_EVIDENCE** in MarianDogma.lean — currently `claim → claim` (identity function). Should model the actual epistemological principle: "if something is maximally fitting for God's plan, and God is omnipotent, then God did it." This needs real content.

- [ ] **Fix PAPAL_INFALLIBILITY** in MarianDogma.lean — currently `claim → claim`. Should model the conditions (ex cathedra, on faith and morals) and the conclusion (irreformable).

- [ ] **Fix trivial theorems** — Several theorems are definitionally true (`trivial` / `rfl`). Either reformalize so they're genuinely falsifiable, or relabel as "structural lemmas" / Tier 0. Key offenders: `all_states_sustained`, `nfp_object_not_evil`, `THREE_STATE_ANTHROPOLOGY`.

- [ ] **Add "modeling choice vs. hidden assumption" distinction** — Each formalization should note: "Is this a hidden assumption IN the Catechism, or a modeling choice WE made?" The DivineModes sustaining/beatifying distinction is a modeling choice; the object-independence axiom is genuinely hidden.

### Priority 2: Axiom base honesty

- [ ] **Revisit 3/9/3 reclassification** — S6 (moral realism), S7 (teleological freedom), S8 (grace transformative) have philosophical components the current "Scriptural" classification obscures. Add a note that the classification is debatable and a Protestant would reasonably classify some differently.

- [ ] **Refactor S1 (loveRequiresFreedom)** — This is over-general. Should be restricted to agape specifically. Eros doesn't require freedom (involuntary attraction). See Love.lean (when complete).

- [ ] **Formalize "God IS love" properly** — `godIsLove : Prop` is a bare flag. The claim is an identity (God's essence = love), not just a predicate. This is the deepest open modeling question.

### Priority 3: New formalizations

- [ ] **Formalize love properly** — Foundations/Love.lean with LoveKind (agape/eros/philia/selfLove), typed relations, per-kind properties. IN PROGRESS.

- [ ] **Add a formalization that shows an argument FAILING** — Where the conclusion genuinely doesn't follow from stated premises without adding significant unstated axioms. Would strengthen intellectual honesty.

- [ ] **Papal Infallibility (Vatican I, 1870)** — Derive from 5 axioms: S_PETRINE_COMMISSION (Mt 16:18-19), S_FAITH_PRAYER (Lk 22:31-32), T_PETER_IS_ROCK (interpretation — this is where Protestants diverge), T_PETRINE_SUCCESSION (Peter→Rome→successors), T_CHARISM_EXTENDS (prayer for Peter extends to the office — the biggest leap). The load-bearing axiom is T_CHARISM_EXTENDS. Replace the current vacuous `claim → claim` in MarianDogma.lean with this real derivation chain. Orthodox cut: accept succession but deny infallibility (primacy of honor only). Protestant cut: reject T_PETER_IS_ROCK and T_PETRINE_SUCCESSION entirely.

- [ ] **Eucharist / Real Presence** — Major sacramental doctrine, connects to P1 (hylomorphism), body-as-sign, Authority chain

- [ ] **Suicide (CCC §2280-2283)** — Pastoral + connects to freedom (diminished culpability), conscience, natural law

- [ ] **Divine attributes (CCC §198-231)** — Omnipotence, omniscience, divine simplicity. Simplicity may productively resist formalization.

### Priority 4: Infrastructure

- [ ] **Move inline `<style>` blocks to shared CSS** — divine-modes.html (355 lines) and culpability-math.html (181 lines) have inline styles that should be in articles.css

- [ ] **Eliminate inline `style="..."` attributes** — conjugal-ethics.html and limits.html use inline styles instead of CSS classes

- [ ] **Add `id` attributes to all `<h2>` elements** — enables deep linking and future table of contents

- [ ] **Add `<caption>` to tables** — accessibility improvement

- [ ] **Inter-article navigation** — "Related articles" links at bottom of each article

- [ ] **Table of contents** — for long articles (luther, conjugal-ethics, divine-modes)

- [ ] **Print styles** — `@media print` for scholarly use

### Priority 5: Open mathematical questions

These are genuine gaps in the Catechism's reasoning that formalization exposed:

- [ ] **Culpability diminisher composition** — How do fear, habit, ignorance, anxiety compound? Additive? Multiplicative? Unknown. (See culpability-math article)

- [ ] **Love-kind composition** — How do agape + eros combine in conjugal love? Same open question. (See love-math article when complete)

- [ ] **Can love/culpability reach zero?** — For a free agent, can either quantity reach absolute zero? The Catechism implies a floor but never specifies.

- [ ] **The mortal/venial threshold surface** — Is it a sharp boundary or a fuzzy region? The Catechism uses binary language but pastoral practice implies gradation.

- [ ] **Mathematics of grace/healing** — Grace heals four wounded faculties (intellect, will, desires, body) independently and progressively. The healing space is a 4D product, graded and partially ordered — structurally parallel to culpability and love. The central open question: how do sacraments map to per-faculty healing? Same class of problem as diminisher composition (culpability) and love-kind composition (love). Existing formalizations (FreedomDegree, NuptialCapacity, TypedLove.agape.degree, HolinessDegree) are projections of this space but lack a unifying framework. See `specs/grace-healing-math-research.md`.

## How to contribute

### Formalizations

1. Pick a CCC paragraph from CATECHISM_CLAIMS.md (or propose a new one)
2. Write your prediction BEFORE formalizing (what do you expect to find?)
3. Formalize in Lean 4 (no Mathlib dependency)
4. Write a companion `.md` file with the finding
5. Tag every axiom with Provenance and DenominationalTag
6. Run `./tools/theorem-tree --flow YourFile.lean` to verify the dependency structure
7. Note whether each finding is a "hidden assumption in the CCC" or a "modeling choice we made"

### Articles

1. Read `.claude/skills/write-catlib-article.md` for the template
2. Reference existing theorems (don't inline Lean code)
3. Tag everything denominationally
4. Show where traditions AGREE before showing disagreements
5. Be maximally loving and truthful

### Tone

This is a love letter. Not a takedown, not a debate tool. Every article should pass this test: would a practicing Catholic feel respected? Would a Protestant feel their position is fairly represented? If not, revise.

## Project stats

```
22 formalizations | ~8,000 lines of Lean | 25+ files | 9 articles
118 axioms | 77 theorems | 466 total declarations
15 base axioms (3 Philosophical / 9 Scriptural / 3 Tradition)
```
