# The Hidden Geometry of Grace -- ASCII Diagrams

Five diagrams representing the four mathematical structures
discovered in catlib: culpability, love, freedom, and grace.

Source: formal verification of the Catholic Catechism in Lean 4.
Project: https://github.com/ngundotra/catlib

---

## Diagram 1: The Four Graded Spaces

```
  CULPABILITY                         LOVE
  Knowledge x Consent x Matter        Agape x Eros x Philia x Self-love

  Knowledge                           Agape
      ^                                   ^
    1 |          . * MORTAL             1 |  *  Saint
      |        . *  SIN                   |  |  (all four
      |      . *  zone                    |  |   loves high)
      |    . * ............               |  |
      |  . *  threshold   :           .5  +--+------ mortal sin
      |. *    surface     :               |  X  agape DESTROYED
      | *  VENIAL SIN     :               |  |  but eros, philia,
    0 +---*-----------*---> Consent       |  |  self-love SURVIVE
      0   :           1                 0 +--+------------> Eros
          :                               0              1
          v Matter (into page)
                                        Philia, Self-love
  3D space. The mortal/venial             (2 more axes, not shown)
  boundary is a SURFACE, not
  a line. Some sinners cannot           4D space. Mortal sin is
  be compared (partial order).          SELECTIVE: it kills charity
                                        but leaves the rest intact.

  FREEDOM                              GRACE / HEALING
  Level x Oriented-to-good             Intellect x Will x Desires x Body

  Freedom                              Healing
  Level                                Level
      ^                                    ^
    1 |  ************ God              1.0 |  I---W---D---B  HEAVEN
      |  *  Saints   (perfectly            |  |   |   |   |  (1,1,1,1)
      |  *           free)                 |  I---W---D   |
      |  *                                 |  |   |   |   |  Purgatory
      |  * "more good = more free"     .5  |  I---W   |   |  (partial)
      |  *                                 |  |   |   |   |
      |  * Addiction, habit                |  I   |   |   |
      |  *   (diminished)                  |  |   |   |   |
    0 +--*-------------------->        0.0 +--+---+---+---+- WOUNDED
      Total                                   I   W   D   B
      Coercion     Perfect                                |
      (no          Alignment                  Body LOCKED at 0
      freedom)     with Good                  until resurrection

  NOT binary (free / unfree).           4 faculties healed
  A spectrum. The surprise:             INDEPENDENTLY. A saint
  inability to sin IS freedom,          before resurrection:
  not the loss of it.                   (1, 1, 1, 0).
```

---

## Diagram 2: The Unified System

```
 ┌─────────────────────────────────────────────────┐
 │              GRACE / HEALING                     │
 │                                                  │
 │   Intellect  x  Will  x  Desires  x  Body       │
 │      |           |          |          |         │
 │   darkened    weakened   disordered  mortal      │
 │      |           |          |          |         │
 │   faith       charity    virtue    resurrection  │
 │   illumines   strengthens  orders   glorifies    │
 │                                                  │
 │            Heaven = (1, 1, 1, 1)                 │
 └────────┬─────────┬──────────┬───────────────────┘
          |         |          |
          |  Will-  |  Desire- |
          |  healing|  healing |
          |         |          |
          v         |          v
 ┌────────────────┐ |  ┌─────────────────────────┐
 │    FREEDOM     │ |  │         LOVE             │
 │                │ |  │                           │
 │  Freedom level │ |  │  Agape = will-healing    │
 │  IS the will-  │ |  │    expressed as charity  │
 │  healing level │ |  │                           │
 │                │ |  │  Nuptial capacity =      │
 │  More good     │ |  │    desire-healing        │
 │  = more free   │ |  │    expressed as love     │
 └───────┬────────┘ |  └───────────┬───────────────┘
         |          |              |
         |  diminished freedom    |  mortal sin
         |  = diminished          |  destroys agape
         |    consent             |  (charity killed,
         |                        |   eros survives)
         v                        v
 ┌──────────────────────────────────────────────────┐
 │              CULPABILITY                          │
 │                                                   │
 │   Knowledge  x  Consent  x  Matter               │
 │                    ^                              │
 │                    |                              │
 │   Freedom level ---+ (your healing level          │
 │   affects how fully you can consent)              │
 │                                                   │
 │   The four domains are NESTED, not parallel.      │
 └───────────────────────────────────────────────────┘

 Reading the arrows:

   Grace heals the Will ──> which IS Freedom
   Grace heals Desires ──> which IS Nuptial Capacity
   Freedom level ──> determines Consent capacity
   Consent capacity ──> determines Culpability

 One structure. Four measurements.
```

---

## Diagram 3: The Reconciliation Flow

```
       STATE OF GRACE                         MORTAL SIN
 ┌──────────────────────────┐          ┌──────────────────────────┐
 │                          │          │                          │
 │  Healing:  progressing   │          │  Healing:  REVERSED      │
 │  ░░░░░░░░░████████████   │          │  ░░░░░░░░░░░░░░░░░░░██  │
 │                          │          │                          │
 │  Agape:   ALIVE          │          │  Agape:   DESTROYED      │
 │  ████████████████████    │   SIN    │  ░░░░░░░░░░░░░░░░░░░░░  │
 │                          │ ──────▶  │                          │
 │  Freedom: high           │          │  Freedom: diminished     │
 │  ░░░░░████████████████   │          │  ░░░░░░░░░░████░░░░░░░  │
 │                          │          │                          │
 │  Culpability: low        │          │  Culpability: HIGH       │
 │  ██░░░░░░░░░░░░░░░░░░   │          │  ░░░░░░░░░░░░░░░░░████  │
 │                          │          │                          │
 └──────────────────────────┘          └────────────┬─────────────┘
             ^                                      │
             │                                      │
             │                                      │
             │         RECONCILIATION               │
             │                                      │
             │    ┌───────────────────────────┐      │
             │    │                           │      │
             │    │  1. Prevenient grace      │      │
             │    │     (God moves first)     │◀─────┘
             │    │            |              │
             │    │            v              │
             │    │  2. Contrition            │
             │    │     (sorrow for sin)      │
             │    │            |              │
             │    │            v              │
             │    │  3. Confession            │
             │    │     (acknowledgment)      │
             │    │            |              │
             │    │            v              │
             │    │  4. Absolution            │
             │    │     (sacramental grace)   │
             │    │            |              │
             │    │            v              │
             └────│  5. Agape RESTORED        │
                  │     Healing resumes       │
                  │                           │
                  └───────────────────────────┘

 Key insight: eros, philia, and self-love are
 UNTOUCHED by this cycle. Only agape (charity)
 is destroyed and restored. The other loves
 persist through mortal sin.
```

---

## Diagram 4: The Same Open Question, Four Times

```
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║            THE SAME OPEN QUESTION  x  4                           ║
║                                                                   ║
║   The Catechism asserts EXISTENCE but never ALGEBRA.              ║
║   It names the ingredients but never gives the recipe.            ║
║                                                                   ║
╠═══════════════════════════════════════════════════════════════════╣
║                                                                   ║
║   CULPABILITY                                                     ║
║   ───────────                                                     ║
║   fear + habit + ignorance + anxiety = ???                         ║
║                                                                   ║
║   Each DIMINISHES culpability. But how do they COMBINE?           ║
║   Additive? Multiplicative? Max wins? Unknown.                    ║
║   Every confessor implicitly picks an operator.                   ║
║                                                                   ║
╠───────────────────────────────────────────────────────────────────╣
║                                                                   ║
║   LOVE                                                            ║
║   ────                                                            ║
║   agape + eros + philia + self-love = ???                          ║
║                                                                   ║
║   All four operate in marriage. But what IS conjugal love?        ║
║   A sum? A product? A minimum? The Catechism never says.          ║
║   Every married couple implicitly lives an answer.                ║
║                                                                   ║
╠───────────────────────────────────────────────────────────────────╣
║                                                                   ║
║   FREEDOM                                                         ║
║   ───────                                                         ║
║   intellect clarity + will strength + desire order = ???           ║
║                                                                   ║
║   Where is the threshold between diminished and destroyed?        ║
║   How much coercion nullifies consent entirely?                   ║
║   The Catechism says "diminished" -- never how much.              ║
║                                                                   ║
╠───────────────────────────────────────────────────────────────────╣
║                                                                   ║
║   GRACE / HEALING                                                 ║
║   ───────────────                                                 ║
║   sacrament  ──▶  per-faculty healing = ???                        ║
║                                                                   ║
║   Does confession heal the will more than the intellect?          ║
║   Does the Eucharist heal desires? Which sacrament heals what?    ║
║   The Catechism asserts healing. Never the mapping.               ║
║                                                                   ║
╠═══════════════════════════════════════════════════════════════════╣
║                                                                   ║
║   Same structure.  Same gap.  Four times.                         ║
║                                                                   ║
║   The proof assistant found both the geometry and the silence.    ║
║   Both matter.                                                    ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝
```

---

## Diagram 5: The Healing Spectrum

```
                    The Four Faculties: Wounded to Healed

              HELL        EARTH         PURGATORY       HEAVEN
              (total      (fallen,      (purification   (fully
              rejection)  grace avail.) in progress)    healed)
              :           :             :               :
 ─────────────:───────────:─────────────:───────────────:──────
              :           :             :               :
 Intellect    :           :             :               :
  (darkened   ▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒████████
  -> clear)   0                                              1
              :           :             :               :
 Will         :           :             :               :
  (weakened   ▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒████████
  -> strong)  0                                              1
              :           :             :               :
 Desires      :           :             :               :
  (disordered ▓▓▓▓▓▓▓▓▓▓▓░░░░░░░░░░░░░▒▒▒▒▒▒▒▒▒▒▒████████
  -> ordered) 0                                              1
              :           :             :               :
 Body         :           :             :               :
  (mortal     ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓████
  -> glorified) 0                                            1
              :           :             :               :
 ─────────────:───────────:─────────────:───────────────:──────

 Legend:  ▓ = wounded    ░ = grace available    ▒ = purifying    █ = healed

 KEY OBSERVATIONS:

 1. The first three faculties (intellect, will, desires) can be
    healed progressively during earthly life through grace,
    virtue, and the sacraments.

 2. The body is LOCKED AT ZERO until the resurrection.
    No amount of spiritual progress heals mortality.
    A saint on earth: (high, high, high, 0).
    A saint in heaven before resurrection: (1, 1, 1, 0).
    Full healing: (1, 1, 1, 1) -- only after resurrection.

 3. Mortal sin REVERSES healing of the will (destroys charity)
    and can damage the other spiritual faculties.
    But the body dimension is unaffected by sin --
    it was already at zero.

 4. Purgatory completes the purification of intellect, will,
    and desires to their maximum. It does not heal the body.

 5. Hell is the refusal of healing -- all faculties remain
    at their wounded state, by the person's own fixed choice.
```

---

## Summary: One Structure, Four Faces

```
                        ┌─────────┐
                        │  GRACE  │
                        │ (root)  │
                        └────┬────┘
                             │
                 ┌───────────┼───────────┐
                 │           │           │
                 v           v           v
            ┌────────┐ ┌────────┐ ┌──────────┐
            │FREEDOM │ │  LOVE  │ │ HEALING  │
            │(will)  │ │(agape) │ │(desires) │
            └───┬────┘ └───┬────┘ └────┬─────┘
                │          │           │
                └──────────┼───────────┘
                           │
                           v
                   ┌──────────────┐
                   │ CULPABILITY  │
                   │ (resultant)  │
                   └──────────────┘

   "Four theological concepts. One mathematical shape.
    Multi-dimensional, graded, partially ordered spaces
    with a shared open question about composition.

    We did not expect this."

                         -- catlib
```
