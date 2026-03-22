# The Three-Layer Model of Sin's Effects (from CCC §405, §1472)

## The CCC's actual structure

The Catechism describes THREE distinct effects of sin, each
removed by a different mechanism. This is NOT our invention —
it's what §405 and §1472 explicitly say.

```
LAYER    WHAT IT IS              SOURCE        REMOVED BY          CCC
──────── ─────────────────────── ──────────── ─────────────────── ────
1        Original sin:           Adam's sin   Baptism             §405
         inherited wound         (not yours)  (erases sin,
         (ignorance,                          but consequences
         concupiscence,                       persist)
         mortality)

2        Guilt of personal sin:  Your own     Reconciliation      §1472
         "eternal punishment"    choices      (absolution remits
         = loss of communion                  eternal punishment)
         with God

3        Unhealthy attachments:  Your own     Purification:       §1472
         "temporal punishment"   sins'        - In life: penance,
         = disordered habits,   RESIDUE        charity, virtue,
         clinging to creatures               indulgences
                                             - After death:
                                               purgatory
```

## Key CCC quotes

§405: "Baptism... erases original sin and turns a man back toward
God, but the consequences for nature, weakened and inclined to
evil, persist in man."

§1472: "Grave sin deprives us of communion with God and therefore
makes us incapable of eternal life, the privation of which is
called the 'eternal punishment' of sin."

§1472: "On the other hand every sin, even venial, entails an
unhealthy attachment to creatures, which must be purified either
here on earth, or after death in the state called Purgatory."

§1472: "This purification frees one from what is called the
'temporal punishment' of sin."

§1472: "These two punishments must not be conceived of as a kind
of vengeance inflicted by God from without, but as following from
the very nature of sin."

## What this means for the afterlife model

A person's afterlife state depends on which layers are resolved:

```
Layer 1     Layer 2     Layer 3     Result
(original)  (guilt)     (attachment)
──────────  ──────────  ──────────  ──────────────────────
Present     Present     Present     → Not baptized (no grace)
Removed     Present     Present     → Baptized but in mortal sin
Removed     Removed     Present     → In grace but imperfectly
                                      purified → PURGATORY
Removed     Removed     Removed     → Fully purified → HEAVEN
Present     Present     Present     → Died without grace → HELL
                                      (if free choice persists)
```

## What we need to formalize

1. A `SinEffect` type with three constructors:
   - originalWound (Layer 1)
   - guilt / eternalPunishment (Layer 2)
   - attachment / temporalPunishment (Layer 3)

2. Each layer has its own removal mechanism:
   - Baptism removes Layer 1
   - Reconciliation removes Layer 2
   - Purification (life or purgatory) removes Layer 3

3. The afterlife state is DETERMINED by which layers remain:
   - All removed → heaven
   - Layer 3 remains → purgatory
   - Layer 2 remains → hell (if died in mortal sin)

4. §1472's key claim: these are NOT vengeance from God but
   "follow from the very nature of sin." The temporal punishment
   is intrinsic to the sin, not externally imposed.

## Open questions

- Can Layer 3 be fully removed in this life? (§1472 says yes:
  "A conversion which proceeds from a fervent charity can attain
  the complete purification of the sinner in such a way that no
  punishment would remain.")

- How do the three layers interact? Is Layer 3 cumulative (each
  sin adds attachment) or does one big repentance clear everything?

- Is Layer 1's "consequences persist" the same as Layer 3's
  "unhealthy attachment"? Or are they genuinely distinct?
  (§405 says original sin consequences persist even after baptism;
  §1472 says temporal punishment from personal sin needs purifying.
  These seem to be different things — one inherited, one self-inflicted.)
