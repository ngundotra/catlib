# Catlib Review Feedback — For Next Agent

This document captures the output of three review agents run against the
project. Feed this to a future agent to address remaining issues.

---

## 1. Project Adherence Review — Honest Assessment: 70%

### What we nailed
- "Axiom set IS the denomination" — the core contribution, well-executed
- Denominational tagging system — excellent
- Luther article — nearly flawless in tone
- Limits article — genuine intellectual honesty
- Authority.lean — best formalization (addresses Protestant objection head-on)
- DivineModes finding — genuinely interesting structural insight
- Marian dependency chain — legitimate finding

### Critical issues to fix

#### A. Many theorems are definitionally true (not falsifiable)
These "theorems" restate their definitions and could not have been false:
- `all_states_sustained` (DivineModes.lean) — proved by `trivial` because states DEFINED with `sustained := True`
- `nfp_object_not_evil` (ConjugalEthics.lean) — `NFPObject` is literally `True`
- `contraception_violates_inseparability` — tautology about conjunctions
- `nfp_is_permissible` — restates `isGood` as a conjunction
- `THREE_STATE_ANTHROPOLOGY` (TheologyOfBody.lean) — every branch returns `True`
- `FITTINGNESS_AS_EVIDENCE` (MarianDogma.lean) — formalized as `claim → claim` (identity function)
- `PAPAL_INFALLIBILITY` (MarianDogma.lean) — same problem: `claim → claim`

**Fix:** Either reformalize so they're genuinely falsifiable, or relabel as "structural lemmas" / Tier 0 (definitional).

#### B. "Hidden assumptions" vs. "our modeling choices" — not distinguished
- DivineModes sustaining/beatifying distinction: presented as "the proof assistant forced this" but WE chose how to model `SoulState`. The proof assistant confirmed our definitions, not discovered the distinction.
- Purgatory `death_finalizes_choice_not_state`: introduced as an axiom WE wrote, not a theorem derived.
- Inseparability principle: called "hidden" but it's explicitly stated in Humanae Vitae §12 and CCC §2366.

**Fix:** Each formalization should have a section: "Is this a hidden assumption IN the Catechism, or a modeling choice WE made?"

#### C. The 3/9/3 reclassification inflates scriptural grounding
- S6 (Moral Realism): Paul says people know right from wrong. He does NOT weigh in on the realism/anti-realism debate in meta-ethics.
- S7 (Teleological Freedom): Jesus says "sin is slavery." The full Thomistic framework is a philosophical extension.
- S8 (Grace Transformative): Lutherans cite the SAME verses and reach different conclusions. Tagging as "Scriptural" obscures that the transformative reading is the Catholic interpretive tradition.

**Fix:** Either revert to 4P/6S/5T or add a note that the classification is debatable and a Protestant would classify some differently.

#### D. T2 is a tautology
`t2_grace_preserves_freedom` is formalized as `P ∨ ¬P` (law of excluded middle). A Lutheran accepts this trivially. The real T2 should assert something a monergist would DENY.

**Fix:** Replace with: "there exists a state where grace is given and the person genuinely could either cooperate or not, and neither outcome is determined by grace alone."

#### E. Missing: a formalization that shows an argument FAILING
The project would be stronger with one case where the conclusion genuinely doesn't follow from stated premises. The IC is close (requires 4+ new axioms) but the conclusion DOES follow given those axioms.

### Tone slips (minor)
- Conjugal ethics article: slippery-slope argument presented uncritically ("The Catholic Church saw this coming")
- README: "ALL Christians agreed" with ALL-caps is advocacy tone
- TheologyOfBody.lean: editorial commentary ("This directly challenges the consent-only framework") embedded in formalization

---

## 2. Frontend Design Review — Prioritized Fixes

### P0 — Must Fix (being addressed by subagent)
1. Sidebar keyboard accessibility — checkbox `display: none` removes from tab order
2. Tables overflow on mobile — need `overflow-x: auto` wrappers
3. No article index — readers can't discover articles from main site

### P1 — Should Fix
4. Move 536 lines of inline `<style>` blocks (divine-modes, culpability-math) to shared CSS
5. Eliminate inline `style="..."` attributes in conjugal-ethics and limits
6. Responsive versal sizing (4.5rem = 72px on mobile — 20% of viewport width)
7. Add `id` attributes to `<h2>` elements for deep linking
8. Add `<caption>` to tables for accessibility
9. Mobile fallback for sidebar content (hidden on mobile = code inaccessible)

### P2 — Nice to Have
10. Trim unused Google Font weights (11 loaded, ~3 never used)
11. Consolidate hardcoded colors into CSS variables
12. Inter-article navigation ("Related articles" links)
13. Table of contents for long articles (luther, conjugal-ethics, divine-modes)
14. Print styles
15. Custom parchment-styled scrollbar instead of hidden
16. Improve `.tag-shared` contrast for AAA compliance

---

## 3. Theorem Tree CLI Output

### Project-wide stats
```
466 declarations | 118 axioms | 77 theorems | 143 defs | 25 inductives | 56 opaques | 47 structures
```

### Cross-file connection highlights
- DivineModes.lean depends heavily on Axioms.lean (`inCommunion`)
- MarianDogma.lean connects to Soul.lean (`HylomorphicPerson`) and DivineModes.lean (`heavenState`)
- Purgatory.lean connects to Hell.lean (`death_is_final` — the tension)
- TheologyOfBody.lean connects to ConjugalEthics, Freedom, and Axioms
- Authority.lean connects to MarianDogma.lean (`Nature` type)

### Theology of the Body tree
```
TheologyOfBody.lean
├── CLAIM 1: Personalist Norm
│   ├── [axiom] PERSONALIST_NORM — only Love respects dignity
│   ├── [axiom] DIGNITY_IS_INTRINSIC
│   ├── [axiom] CONSENT_DOES_NOT_LEGITIMIZE_USE
│   └── [theorem] personalist_norm_grounds_inseparability ★
│       └── PROVES inseparability follows from personalist norm
│
├── CLAIM 2: Concupiscence
│   ├── [axiom] THREE_STATE_ANTHROPOLOGY
│   ├── [axiom] CONCUPISCENCE_DIMINISHES_NOT_DESTROYS
│   ├── [axiom] REDEMPTION_IS_PROGRESSIVE
│   ├── [axiom] COOPERATION_REQUIRED
│   └── [theorem] fallen_not_total_depravity ★
│       └── Locates Catholic between Pelagianism and Calvinism
│
└── CLAIM 3: Body as Sign
    ├── [axiom] BODY_AS_SIGN
    ├── [axiom] MATERIAL_MEDIATION
    ├── [axiom] SIGN_TRUTHFULNESS
    ├── [theorem] body_sign_grounds_sacraments ★
    │   └── PROVES T3 (sacramental efficacy) follows from body-as-sign
    └── [theorem] contraception_is_body_lie ★
```

### Marian Dogma dependency chain
```
MarianDogma.lean
├── DOGMA 1: Theotokos (2 axioms, ECUMENICAL)
│   ├── [axiom] HYPOSTATIC_UNION
│   ├── [axiom] MOTHERHOOD_TARGETS_PERSONS
│   └── [theorem] theotokos ★ (DERIVED, not axiom!)
│       └── rejecting_theotokos_implies_nestorianism
│
├── DOGMA 2: Immaculate Conception (6 axioms, CATHOLIC ONLY)
│   ├── [axiom] ORIGINAL_SIN_INHERITED
│   ├── [axiom] RETROACTIVE_REDEMPTION
│   ├── [axiom] FITTINGNESS_AS_EVIDENCE ⚠️ (formalized as identity function)
│   ├── [axiom] PAPAL_INFALLIBILITY ⚠️ (formalized as identity function)
│   ├── [axiom] PRESERVATION_EXCLUDES_SIN (discovered during proof attempt)
│   └── [theorem] immaculate_conception_proper
│
├── DOGMA 3: Assumption (8+ axioms, CATHOLIC ONLY)
│   ├── [axiom] DEATH_IS_CONSEQUENCE_OF_SIN
│   ├── [axiom] SINLESSNESS_IMPLIES_BODILY_INTEGRITY
│   └── [theorem] assumption_follows_from_ic
│
└── CHAIN:
    └── [theorem] full_marian_chain ★
        Union → Theotokos → IC → Assumption
        chain_breaks_without_union: deny Chalcedon, everything falls
```

---

## Priority order for next agent

1. **Fix T2 formalization** — currently a tautology (P ∨ ¬P)
2. **Fix FITTINGNESS and PAPAL_INFALLIBILITY** — currently identity functions
3. **Add "modeling choice vs. hidden assumption" distinction** to key formalizations
4. **Address 3/9/3 honesty** — add note that classification is debatable
5. **Fix trivial theorems** — either reformalize or relabel as structural lemmas
6. **Move inline styles to shared CSS** (P1 from frontend review)
7. **Add an argument that FAILS** — where conclusion doesn't follow from stated premises
