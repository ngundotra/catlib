# Contributing to Catlib

## Running items — things we want to come back to

### Priority 1: Formalization quality fixes (from project review)

- [x] **Fix T2 formalization** — Was `P ∨ ¬P` (LEM tautology). Now asserts `couldChooseOtherwise` under grace — what Trent Canon 4 actually says and what Calvinists (irresistible grace) deny.

- [ ] **Fix FITTINGNESS_AS_EVIDENCE** in MarianDogma.lean — currently `claim → claim` (identity function). Should model the actual epistemological principle: "if something is maximally fitting for God's plan, and God is omnipotent, then God did it." This needs real content.

- [ ] **Fix PAPAL_INFALLIBILITY** in MarianDogma.lean — currently `claim → claim`. Should model the conditions (ex cathedra, on faith and morals) and the conclusion (irreformable).

- [ ] **Fix trivial theorems** — Several theorems are definitionally true (`trivial` / `rfl`). Either reformalize so they're genuinely falsifiable, or relabel as "structural lemmas" / Tier 0. Key offenders: `all_states_sustained`, `nfp_object_not_evil`, `THREE_STATE_ANTHROPOLOGY`.

- [ ] **Add "modeling choice vs. hidden assumption" distinction** — Each formalization should note: "Is this a hidden assumption IN the Catechism, or a modeling choice WE made?" The DivineModes sustaining/beatifying distinction is a modeling choice; the object-independence axiom is genuinely hidden.

### Priority 2: Axiom base honesty

- [ ] **Revisit 3/9/3 reclassification** — S6 (moral realism), S7 (teleological freedom), S8 (grace transformative) have philosophical components the current "Scriptural" classification obscures. Add a note that the classification is debatable and a Protestant would reasonably classify some differently.

- [ ] **Refactor S1 (loveRequiresFreedom)** — This is over-general. Should be restricted to agape specifically. Eros doesn't require freedom (involuntary attraction). See Love.lean (when complete).

- [ ] **Formalize "God IS love" properly** — `godIsLove : Prop` is a bare flag. The claim is an identity (God's essence = love), not just a predicate. This is the deepest open modeling question.

### Priority 3: New formalizations

**Already formalized / update the docs instead of treating as backlog debt**

- [x] **Mary as Mother of God / divine maternity** — Substantively formalized in `MarianDogma.lean` as the Theotokos theorem. Remaining work is documentation polish or extension, not first-pass formalization.

- [x] **Eucharist / Real Presence** — Substantively formalized in `Sacraments/Eucharist.lean`, including real presence, who-can-receive structure, and doctrine/discipline distinctions.

- [x] **Suicide (CCC §2280-2283)** — Formalized in `MoralTheology/Suicide.lean`, including grave matter, diminished culpability, and hope for salvation.

**Partially formalized — keep open because the sharper question remains**

- [ ] **What makes a sin mortal rather than merely grave in effect?** — `Sin.lean` already formalizes the binary mortal/venial structure, but the threshold logic is still underexplored. Candidate chain: grave matter, knowledge, and consent must interact in a way that destroys charity; not every objectively grave act does so; therefore mortal sin requires a specific conjunction of conditions. Main question: is the key hidden structure a threshold surface, a causal break in communion, or both?

- [ ] **Why does resurrection matter if the soul already survives?** — `Soul.lean` already argues that the separated soul is incomplete and resurrection restores what death broke, but the explanatory pressure remains. Candidate chain: the separated soul survives death but is not the complete human person; human beatitude is meant for embodied creatures; therefore resurrection is not ornamental but required for full human completion. Main question: what exactly is lacking in the intermediate state that resurrection restores?

- [ ] **Formalize love properly** — `Foundations/Love.lean` is in progress, but the typed vocabulary and per-kind properties still need to be finished.

**Metaphysical and Christological foundations**

- [x] **Theological grounds for scientific inquiry** — Formalized in `Creed/ScientificInquiry.lean`. Derives two propositions: (A) the world is logical (from §299 + §306 + P2) and (B) humans can understand that logic (from §1700/imago_dei + §299 + §36). Key finding: P2 (two-tier causation) and imago_dei are equally load-bearing — drop P2 and you get occasionalism, drop imago_dei and you have no reason to trust reason. The *adaequatio rei et intellectus* (Aquinas) is hiding inside the CCC.

- [ ] **Define what "the world is logical" means** — `worldIsLogical` in `ScientificInquiry.lean` is currently opaque. The CCC grounds science metaphysically but never commits to a specific philosophy of science. Three candidate definitions, each progressively stronger: (1) **Regularity** — same causes produce same effects. Weakest; even an occasionalist can observe regularities, they just ground them in God's habits. (2) **Essentialism** — things have stable natures with real causal powers. Fire burns BECAUSE OF WHAT FIRE IS. This is Aristotelian and aligns with P2/secondary causation. (3) **Mathematical describability** — the world's order is expressible in mathematical language (Galileo's "book of nature is written in mathematics"; Wigner's "unreasonable effectiveness of mathematics"). CCC §299 ("measure and number and weight") leans toward this but doesn't commit. Main question: does the CCC's argument require a specific account of natural order, or does it work with any of the three? If it works with all three, that's itself a finding — the metaphysical grounding is more general than the specific philosophy of science.

- [ ] **Christ as Word / Logos** — Formalize the Johannine and conciliar claim that Christ is the eternal Logos through whom all things were made, and clarify what explanatory work "Logos" is doing beyond a title. Candidate chain: the Son is eternally with God and is God; creation is through the Logos; divine wisdom/order is not external to God but personal in the Son; therefore Christ as Logos grounds intelligibility, revelation, and mediation between Creator and creation in a way that bare monotheism does not. Main question: is "Logos" functioning primarily as a metaphysical principle of cosmic order, a Christological identity claim, or both at once?

- [ ] **Why should truth be intelligible at all?** — Formalize the metaphysical assumptions behind reason's fit to reality. Candidate chain: reality is ordered rather than brute chaos; intellect is proportioned to being; truth is discoverable because being is intelligible; therefore rational inquiry is not an accident but a participation in an ordered world. Main question: does this rest primarily on Logos theology, metaphysical realism, or both?

- [ ] **Why did God become man rather than save some other way?** — Formalize the fittingness or necessity claims behind the Incarnation and atonement. Candidate chain: humanity needs reconciliation; the mediator must bridge God and man; fitting repair comes through one who is both divine and human; therefore the Incarnation is not arbitrary. Main question: is the Incarnation strictly necessary, maximally fitting, or only one possible mode of salvation?

- [ ] **Why is the Cross necessary if God can simply forgive?** — Formalize the logic of satisfaction, sacrifice, justice, mercy, and covenant repair. Candidate chain: sin is not merely a private offense but a rupture in right order; forgiveness does not erase the need for restoration; the Cross accomplishes what bare waiver would not; therefore salvation through the Passion is not redundant. Main question: what exactly is the Cross doing that a divine declaration of pardon alone would not do?

- [ ] **Divine attributes (CCC §198-231)** — Omnipotence, omniscience, divine simplicity. Simplicity may productively resist formalization.

- [ ] **Why does evil permission not collapse into evil causation?** — Deepen the providence line by formalizing the difference between permitting evil and causing it. Candidate chain: God sustains all being; evil is a privation rather than a positive created substance; creaturely wills are real secondary causes; therefore divine permission of evil does not make God its moral author in the same way creatures are. Main question: is the privation theory enough, or is a stronger causal distinction required?

**Sacraments, mediation, and ecclesial life**

- [ ] **What exactly changes in a sacrament?** — Formalize sacramental causation rather than only sacramental validity or authority. Candidate chain: sacraments are efficacious signs; they signify and confer grace; some change is ontological rather than merely declarative; therefore reception alters the person in a real way. Main question: what kind of change is this — relational, ontological, juridical, dispositional, or some combination?

- [ ] **Why does confession to a priest make sense if God alone forgives sins?** — Formalize principal vs instrumental causation in sacramental absolution. Candidate chain: God alone is the principal forgiver; Christ delegated a ministry of reconciliation; priests act instrumentally in his name; therefore priestly absolution does not compete with divine forgiveness. Main question: is the load-bearing step delegated authority, sacramental instrumentality, or the ecclesial visibility of reconciliation?

- [ ] **Why pray if God already knows and wills the good?** — Formalize petitionary prayer under providence. Candidate chain: God's providence includes secondary causes; prayer is one such cause; divine foreknowledge does not render creaturely participation pointless; therefore petitionary prayer can be meaningful without changing God's mind in a crude sense. Main question: does prayer change outcomes, change the person praying, or both?

- [ ] **Why ask saints to pray for us if Christ is the one mediator?** — Formalize participatory mediation without collapsing into rivalry with Christ. Candidate chain: Christ is the unique principal mediator; members of his body can share instrumentally in intercession; the saints remain alive in Christ; therefore heavenly intercession participates in, rather than competes with, Christ's mediation. Main question: what principle distinguishes subordinate mediation from usurpation?

- [ ] **What is the exact difference between veneration and worship?** — Formalize the distinction between honor given to creatures and adoration due to God alone. Candidate chain: not all honor is worship; some honor tracks excellence or participation in divine grace; worship uniquely involves absolute divine ultimacy; therefore veneration of saints need not collapse into idolatry. Main question: where is the principled boundary — intention, object, mode of offering, or metaphysical status of the one honored?

- [ ] **Infant Baptism** — Formalize the Catholic case for baptizing infants rather than only professing believers. Candidate chain: baptism is a grace-conferring sacrament, not merely a public testimony; entry into the covenant is not limited by age; the Church can present a child for sacramental grace before personal rational assent; later faith ratifies rather than creates the sacramental gift. Main question: which premise does the anti-paedobaptist objection actually reject — sacramental efficacy, covenant continuity, or representation by the Church/parents?

- [ ] **What makes marriage indissoluble?** — Formalize the Catholic logic of marital permanence. Candidate chain: marriage is covenant, sacrament, and bodily union ordered to a comprehensive common life; what God joins is not merely contractual; therefore indissolubility follows from the nature of the bond, not just an external rule. Main question: which premise is load-bearing — covenantal form, sacramentality, consummation, or the Christ-Church analogy?

- [ ] **Sabbath or Sunday / Lord's Day** — Formalize the Catholic argument that the old covenant Sabbath is no longer binding in the same way and that Christian worship properly gathers on Sunday, the Lord's Day. Candidate chain: Christ's resurrection reorients sacred time; apostolic and early Church practice gathers on the first day; ceremonial observances of the old covenant are not binding as before; therefore Sunday worship is not a later corruption but an apostolic development. Main question: which premise is doing the real work — resurrection symbolism, apostolic practice, or the abrogation/fulfillment of Mosaic ceremonial law?

**Authority, canon, and doctrinal development**

- [ ] **Why can't private judgment settle doctrine by itself?** — Formalize the anti-individualist logic behind magisterial authority. Candidate chain: revelation requires correct interpretation; sincere readers can disagree without a final internal resolver; Christ established a teaching authority in the Church; therefore private judgment cannot be the ultimate rule of faith. Main question: is the decisive problem epistemic disagreement, canon dependence, or the absence of a principled adjudicator?

- [ ] **Scripture and Tradition / rule of faith** — Formalize the Catholic claim that divine revelation is transmitted through both Scripture and apostolic Tradition under the Church's teaching authority. Candidate chain: Christ entrusted teaching authority to the apostles; not all apostolic teaching was written; succession preserves that authority; the canon itself depends on Church judgment; therefore sola scriptura is not self-sufficient as a rule of faith. Main question: is the canon argument the load-bearing step, or is the deeper issue whether authoritative unwritten transmission can exist at all?

- [ ] **Nicaea, conciliar authority, and the biblical canon** — Formalize the historical-theological chain connecting ecumenical councils, doctrinal settlement, and canon discernment. Candidate chain: the Church exercised binding teaching authority at councils like Nicaea before a universally settled New Testament canon was functionally closed; the canon was recognized through ecclesial judgment rather than self-attestation; later councils ratified the scriptural corpus used in the Church's life; therefore sola scriptura depends on an authority structure it cannot fully explain from Scripture alone. Main question: is the decisive anti-sola-scriptura point the canon problem, the conciliar problem, or the combination of both?

- [ ] **Papal Infallibility (Vatican I, 1870)** — Derive from 5 axioms: S_PETRINE_COMMISSION (Mt 16:18-19), S_FAITH_PRAYER (Lk 22:31-32), T_PETER_IS_ROCK (interpretation — this is where Protestants diverge), T_PETRINE_SUCCESSION (Peter→Rome→successors), T_CHARISM_EXTENDS (prayer for Peter extends to the office — the biggest leap). The load-bearing axiom is T_CHARISM_EXTENDS. Replace the current vacuous `claim → claim` in MarianDogma.lean with this real derivation chain. Orthodox cut: accept succession but deny infallibility (primacy of honor only). Protestant cut: reject T_PETER_IS_ROCK and T_PETRINE_SUCCESSION entirely.

- [ ] **Can development of doctrine be principled rather than ad hoc?** — Formalize the logic by which doctrine can develop while remaining identical in substance. Candidate chain: revelation is complete in Christ, but understanding unfolds over time; later definitions can clarify what was implicit without inventing new revelation; therefore doctrinal development need not be corruption. Main question: what criteria distinguish legitimate development from retrospective rationalization?

**Broad synthesis / methodology**

- [ ] **Soteriology / plan of salvation** — Formalize the Catholic salvation chain as a single argument structure rather than leaving it scattered across Grace.lean and Justification.lean. Candidate chain: all are sinners and cannot save themselves; Christ alone saves; grace is a free gift; that gift is ordinarily accessed through repentance, faith, and baptism; saving faith is lived through love; good works are required as grace-enabled obedience, not self-salvation. Main question: which links are genuinely doctrinal, and which are apologetic packaging?

- [ ] **Add a formalization that shows an argument FAILING** — Where the conclusion genuinely doesn't follow from stated premises without adding significant unstated axioms. Would strengthen intellectual honesty.

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

- [ ] **Mathematics of grace/healing** — NOTE: our earlier "4D faculty" model was our invention, not the CCC's. The CCC describes body + soul, with intellect + will as powers of the soul (§1705). Healing space is 2D (intellect × will) at the spiritual level, not 4D. Needs rework based on HumanNature.lean. Central open question remains: how do sacraments map to healing?

### Priority 6: Body & Soul open questions (from HumanNature formalization)

- [ ] **What is a separated soul's experience?** — After death, the soul exists without the body (§366). The CCC implies awareness (purgatory and hell involve suffering/purification). But what can a soul DO without a body? Can it think? Will? The CCC doesn't specify the mechanism. Connects to P1 (hylomorphism): if the soul is the form of the body, what does "form without matter" mean?

- [ ] **What does resurrection ADD?** — Saints in heaven are already in full communion with God (§1023). But they're INCOMPLETE persons — soul without body. Resurrection restores the body (§997). What does completeness add to someone already in beatific vision? Is it experiential (embodied joy)? Ontological (they become fully what they are)? The CCC says resurrection is essential but doesn't explain what the soul was MISSING.

- [ ] **Can a separated soul think and will?** — The CCC implies yes (purgatory involves progressive purification, hell involves awareness of separation). But under strict hylomorphism (P1), intellect and will are powers of the SOUL — so they should persist. Aquinas argues (ST I q.89) that separated souls know differently (not through bodily senses). Worth formalizing: does our HumanNature model support cognition without corporeality?

- [ ] **How does soul "form" matter into body?** — §365 says the soul is the "form" of the body — but this is an Aristotelian MECHANISM the CCC borrows without explaining. The CCC uses the word "form" but doesn't specify how form constitutes matter into a living body. This is philosophical infrastructure the CCC assumes (P1). Formalizing it would require modeling what "formation" means — not just asserting it.

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
