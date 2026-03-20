# CCC §2001–2002: The Grace Bootstrapping Problem

## The Catechism claim

"The preparation of man for the reception of grace is already a work
of grace" (§2001). God's initiative "demands man's free response" (§2002).

## How we modeled it

- **GraceType**: Enum — prevenient (preparing) vs. sanctifying
- **TypedGrace**: Grace instance with type, recipient, and freely-given property
- **Receptivity**: Whether a person can receive sanctifying grace
- Three axioms: preparation requires prevenient grace, prevenient grace
  is unconditioned, divine initiative preserves freedom

## What we found

### The bootstrapping problem is real

§2001 says: to receive grace, you need preparation. But preparation IS
grace. This is genuinely circular — the proof assistant won't let us
write a well-founded definition that requires itself.

### The resolution requires a typed hierarchy

The circularity breaks if there are at least TWO kinds of grace:
- **Prevenient grace**: comes before any human response, given by God's
  initiative alone
- **Sanctifying grace**: requires preparation (which IS prevenient grace)

This distinction isn't stated in §2001 itself. The Catechism uses "grace"
as if it were one thing, but the formal structure requires a type hierarchy.

### Three hidden assumptions

1. **Grace type hierarchy** — at least two kinds of grace exist. Without
   this, §2001 is circular.

2. **Prevenient grace is unconditioned** — God gives it without any prior
   human action. This breaks the infinite regress.

3. **Divine initiative preserves freedom** — God causes our willing, yet
   our willing remains free. Mechanism unexplained.

### The Pelagian controversy in two paragraphs

The Catechism compresses the entire Pelagian controversy (5th century to
present) into §2001-2002. Without the anti-Pelagian axiom (preparation
requires grace), humans could prepare themselves — and grace wouldn't be
necessary. The proof assistant forced the entire controversy back open.

### Assessment

**Tier 3** — Genuine structural finding. The bootstrapping problem is real,
and the resolution requires three unstated premises. The need for a typed
grace hierarchy was the most surprising finding.
