# Retrospective: What We Learned Building the HPMOR Site

This document captures meta-lessons from 9 cycles of site optimization
and the broader formalization project. These are process lessons, not
content lessons — they should inform how we run Catlib.

---

## What went well

### The persona review loop

The core loop (implement → 4 persona reviews → synthesize → fix) worked
extremely well. Key factors:

1. **Parallel persona execution.** Running all 4 reviewers simultaneously
   cut cycle time dramatically. No reason to run them sequentially.

2. **Convergent feedback = high signal.** When 3+ personas flag the same
   issue, it's real. When only 1 flags something, it might be persona
   noise. We learned to act on convergence and deprioritize outliers.

3. **Deliberately unsophisticated personas.** The breakthrough was making
   personas LESS intelligent in cycle 2. The early personas were too
   fluent — they understood jargon they shouldn't have. Once we made them
   regular people (dad, girlfriend, blog reader), the feedback got real.
   The key prompt technique: "If you don't understand a word, SAY SO.
   Don't fake it."

4. **The zero-context persona has veto power.** If the zero-context
   reader bounces, the page fails regardless of what insiders think.
   Weight this persona highest.

5. **The owner's own reaction is the most important signal.** In cycle 7,
   the owner said "my eyes skim over the first section." That one sentence
   was worth more than all 4 persona reviews combined. The loop should
   include the owner reading the page after each major change.

### The assumption-audit reframe (cycle 8)

This was the single biggest improvement. We spent 6 cycles optimizing a
page that pitched "we proved surprising theorems." The owner then noticed
the theorems were often trivially true within the model. The real pitch
was: "formalization forces you to name your assumptions."

**Lesson:** Don't optimize the wrong frame for 6 cycles. The reframe
should have happened earlier. We could have caught this by asking: "Is
the theorem surprising, or is the model construction surprising?" earlier.

**How to avoid in Catlib:** Before building the site, formalize 3-5
things and ask: "What was actually interesting about each one?" If the
answer is always "the assumption I had to name" and never "the proof
was hard," then the site should be about assumptions from the start.

### The finding selection conversation (cycle 7b)

The best content decisions came from the owner and coordinator
workshopping findings together:

1. We listed ALL findings in simple English
2. Owner picked favorites based on gut ("my gf and dad would care")
3. We identified a common thread across the picks
4. That thread became the site's organizing principle

**This should be a formal step in the Catlib loop.** After accumulating
5+ findings, sit down and ask: "Which of these would my dad find
interesting? What's the common thread?" That thread is the site's thesis.

---

## What didn't go well

### 1. We optimized the wrong frame for too long

Cycles 1-6 all assumed the pitch was "surprising proofs." The real pitch
("assumption audit") only emerged in cycle 8 when the owner pushed back
on the transparency theorem being trivial.

**Root cause:** The persona reviewers couldn't catch this because they
don't know enough about formal verification to notice that a theorem is
trivially true within its model. Only someone with domain knowledge
(the owner) could see that.

**Fix for Catlib:** Add a 5th reviewer persona — a domain expert
(theologian/philosopher) — with LOWER weight on accessibility feedback
but VETO POWER on whether the findings are actually interesting. Also,
the owner should read each finding and ask: "Is this actually surprising,
or is it just the model saying what I told it to say?"

### 2. Featured findings changed too many times

We changed the featured findings set 3 times (cycles 1, 3, 7b). Each
change cascaded through the worked example, the hook arrow, the section
order, and the data file. This was expensive.

**Fix for Catlib:** Don't build the site until you've finalized the
featured findings. Run the finding selection conversation FIRST (with
all findings in simple English), lock the featured set, THEN build.

### 3. The worked example was rewritten 3 times

Confirmation bias → physics → confirmation bias → transparency. Each
rewrite touched HTML, CSS, and the data file.

**Fix for Catlib:** Pick the worked example ONCE, based on: (a) is the
finding genuinely interesting to a non-expert? (b) is the hidden
assumption easy to explain? (c) is the Lean code short enough to
annotate? Lock it before building the site.

### 4. Early cycles had too-broad scope

Cycle 1 tried to fix everything: hook, progressive disclosure, thesis
structure, zero-context accessibility, tone, and "you could do this too"
— all at once. This made it hard to tell which changes helped.

**Fix for Catlib:** Start with the hero and worked example ONLY. Get
those right with 2-3 cycles. Then expand to the rest of the page.
Narrower scope per cycle = faster convergence.

### 5. We never tested with real humans

9 cycles of simulated personas, zero real human feedback. The simulated
personas are useful for catching obvious problems (jargon, structure,
bounce risk) but they can't tell you:
- Whether a finding is genuinely surprising vs. trivially true
- Whether the tone feels respectful or condescending
- Whether the page makes someone want to share it (not just claim they would)

**Fix for Catlib:** After cycle 3-4, show the page to 2-3 real humans.
Use the simulated loop to get to "not embarrassing," then switch to real
feedback for "actually good."

---

## What we could have done better

### 1. Made the finding selection a loop

We built the table of findings by hand — me listing them, the owner
picking favorites, us identifying a thread. This worked but was ad hoc.

**Better approach for Catlib:**

```
┌─────────────────────────────────────────────────┐
│  1. FORMALIZE 3-5 paragraphs                   │
├─────────────────────────────────────────────────┤
│  2. EXTRACT findings in simple English          │
│     Agent writes each finding as:               │
│     - The claim (one sentence)                  │
│     - The hidden assumption (one sentence)      │
│     - The surprise (one sentence)               │
├─────────────────────────────────────────────────┤
│  3. RANK by accessibility                       │
│     Agent + owner together ask:                 │
│     "Would my dad/gf find this interesting?"    │
│     "Can I explain the assumption in one line?" │
├─────────────────────────────────────────────────┤
│  4. IDENTIFY the common thread                  │
│     "What pattern connects the top picks?"      │
│     This becomes the site's thesis.             │
├─────────────────────────────────────────────────┤
│  5. LOCK featured set + worked example          │
│     Do not change these after this point.        │
├─────────────────────────────────────────────────┤
│  6. BUILD the site                              │
│     Run the persona design loop                  │
├─────────────────────────────────────────────────┤
│  7. GOTO 1 with the next batch of paragraphs    │
│     New findings go into case files, not featured│
│     (unless they're clearly better than current) │
└─────────────────────────────────────────────────┘
```

This turns the ad hoc conversation into a repeatable process.

### 2. Started with the thesis, not discovered it at cycle 8

We should have asked "what is actually interesting about formalization?"
BEFORE building the site. The answer ("it forces you to name your
assumptions") should have been the starting point, not a cycle-8 reframe.

**For Catlib:** Before writing any site code, formalize 3 things, then
ask: "What was interesting?" If the answer is "the assumptions I had to
name," start with the assumption-audit framing. If it's something else,
start with that.

### 3. Used the cron loop earlier

The `/loop 5m` cron pattern was powerful — it kept the cycles running
without manual intervention. We should have started it earlier and let
it run longer with tighter scope per cycle.

### 4. Separated "structural" from "copy" cycles earlier

We spent cycles 1-4 mixing structural changes (page layout, section
order) with copy changes (jargon fixes, title rewrites). These should
have been separate phases:
- Phase A: Get the structure right (3-4 cycles, broad scope)
- Phase B: Get the copy right (2-3 cycles, narrow scope, surgical)
- Phase C: Polish (1-2 cycles, cosmetic only)

We eventually did this (cycles 5-6 were surgical, cycle 6 was polish)
but stumbled into it instead of planning it.

---

## Summary: The Catlib Playbook

1. Formalize 3-5 paragraphs first (no site)
2. Extract findings in simple English
3. Workshop with owner: pick favorites, find the thread
4. Lock featured set + worked example + thesis
5. Build site using the assumption-audit frame
6. Run persona loop: structure → copy → polish (3 phases)
7. Show to real humans after cycle 3-4
8. Continue formalizing; new findings go to case files
9. Re-run finding selection when you have 5+ new findings
10. Re-run site loop only when featured set changes
