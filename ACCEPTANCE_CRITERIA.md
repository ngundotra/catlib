# Acceptance Criteria for Catlib Formalizations

> "Faith and reason are like two wings on which the human spirit rises
> to the contemplation of truth."
> — Fides et Ratio, John Paul II

This document defines what makes a formalization good enough to merge.
Adapted from the HPMOR Formalized project, where we learned that the
proofs are often simple — the value is in the assumptions you're forced
to name.

---

## Choosing What to Formalize

Before writing any Lean, ask: **would I learn something by trying?**

### The four outcome categories

| Category | What happens | Information value |
|----------|-------------|-------------------|
| **Confirms as stated** | The argument goes through with exactly the premises the Catechism states. | Low. You verified a correct argument. |
| **Confirms but reveals hidden structure** | The claim is true, but formalization forces an assumption to be explicit that the text glossed over. | High. The claim isn't wrong — it's incomplete. |
| **Requires stronger premises** | The claim doesn't follow from what the text states; you need additional axioms. The gap is the finding. | High. What MUST you assume? |
| **Resists formalization** | The claim doesn't map to a formal structure in any obvious way. | Worth recording — sometimes the resistance itself is informative. |

### How to choose

**Rank paragraphs by your uncertainty about which category they'll land in.**

| Your prediction | Action |
|-----------------|--------|
| "This is definitional, it'll be trivial" | Skip unless it's a dependency |
| "This is pure mystery, can't be modeled" | Skip — but note what "mystery" means here |
| "I think the argument works but I'm not sure what premises I'll need" | Good target |
| "I genuinely don't know if this follows from what the text says" | Best target |

### State your prediction before you start

Before opening a `.lean` file, write under a `## Prediction` heading:

```
## Prediction

I expect this to [confirm / need extra premises / resist formalization].
The assumption I'm most uncertain about is [X].
If this confirms cleanly, I'll be surprised because [Y].
```

### Report the outcome

The `## Findings` section should include:

```
- **Prediction vs. reality**: I predicted [X]. What actually happened was [Y].
- **Catholic reading axioms used**: [List any Gospel/tradition axioms required]
- **Surprise level**: [None / Mild / Significant]
```

---

## The Three Tiers

### Tier 1: Falsifiable

**Minimum bar.** The theorem could have been false. Removing a hypothesis
breaks it. If the proof is `rfl` or `simp` alone, it's a definition, not
a finding.

### Tier 2: Faithful

**Standard bar.** A theologian or philosopher would recognize the original
Catechism claim in your theorem statement. The model isn't artificially
narrow. The docstring connects the theorem to a specific paragraph number.

### Tier 3: Surprising

**This is what we're after.** Formalization revealed something the
Catechism text didn't make explicit.

What Tier 3 looks like for the Catechism:

1. **Hidden premise exposed.** The argument works, but you had to assume
   something the text didn't state. Example: a moral argument that
   requires a specific model of human freedom the paragraph didn't name.

2. **Axiom dependency mapped.** The claim requires a specific Gospel
   axiom or tradition axiom. Making that dependency explicit shows exactly
   where the reasoning connects to revelation vs. natural law.

3. **Scope clarified.** The text says "always" or "never" but
   formalization shows the claim holds under narrower conditions.
   Example: "intrinsically evil" might require a specific action
   ontology to formalize.

4. **Structural connection.** Two paragraphs that seem independent turn
   out to share a common axiom, or one implies the other.

---

## The Catholic Reading as Axiom Set

This is the key methodological point. When the Catechism cites Scripture,
we must formalize the Catholic interpretation as an explicit axiom.

Example:
```
-- Mt 16:18 under Catholic reading: Jesus confers governance authority
axiom petrine_commission :
  Authority.delegated_to peter ∧ Authority.extends_to peter.successors
```

This is NOT claiming the axiom is true. It is saying: "If you accept
this reading, here is what follows." A different reading (Protestant,
Orthodox) would yield a different axiom. The axiom set IS the theological
tradition.

**Tracking axiom provenance:**

Every axiom should be tagged with its source:

| Tag | Source | Example |
|-----|--------|---------|
| `[Scripture]` | Specific Bible verse under Catholic reading | Mt 16:18, Jn 6:53 |
| `[Tradition]` | Church Fathers, Councils, Magisterium | Nicaea, Trent, Vatican II |
| `[Natural Law]` | Philosophical reasoning without revelation | "Good is to be done and pursued" |
| `[Definition]` | Catechism's own defined term | CCC §1849 definition of sin |

---

## Plain-Language Summary (Required)

Every formalization must include a companion `.md` file with:

1. **The Catechism claim.** What does the paragraph say, in plain words?
   Include the paragraph number.
2. **How we modeled it.** What formal objects stand in for the theological
   concepts? What axioms from Scripture/Tradition did we need?
3. **What we found.** Did formalization confirm the claim, reveal a
   hidden assumption, or require premises the text didn't state?

Example:

> The Catechism (§2267) argues that legitimate defense can justify the
> use of force. We modeled this as a decision under threat with a
> proportionality constraint. The argument goes through, but only if
> you assume the defender has accurate knowledge of the threat level.
> The text doesn't state this assumption — it's doing invisible work.

---

## Findings Template

```
## Findings

- **Catechism paragraph**: §[number]
- **Hidden assumptions**: [What did we have to assume that the text didn't state?]
- **Catholic reading axioms**: [Which Scripture/Tradition axioms were needed?]
- **Scope**: [Does the claim hold universally, or under narrower conditions?]
- **Connections**: [Does this share axioms with other paragraphs?]
- **Prediction vs. reality**: [What we expected vs. what we found]
- **Assessment**: Tier [1/2/3] — [one-line justification]
```

---

## Scorecard

| Criterion | 0 | 1 | Weight |
|-----------|---|---|--------|
| **Falsifiable**: Removing a hypothesis breaks it | Definitional / vacuously true | At least one hypothesis is load-bearing | Required |
| **Non-trivial**: Proof requires real work | `rfl` / `simp` / `decide` | Multi-step reasoning | Required |
| **Faithful**: Recognizable as the Catechism claim | Artificial model, hand-wavy connection | Clear paragraph reference, theologian would agree | Required |
| **General**: Proves something about a class, not one case | Specific values, hardcoded | Universally quantified | Preferred |
| **Surprising**: Revealed a hidden assumption | Confirmed what we expected | Exposed unstated premise, clarified scope, or mapped axiom dependency | **Actively sought** |
