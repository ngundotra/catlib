# CCC §1033 + §1037: Hell as Self-Exclusion

## The Catechism claim

Hell is "definitive self-exclusion from communion with God" (§1033).
It results from dying in mortal sin without repentance. God predestines
no one to hell — it always requires "a willful turning away from God"
(§1037).

## How we modeled it

- **DeathState**: Enum — died in mortal sin, repentant, or never sinned
- **EternalDestiny**: Enum — communion with God or separated from God
- **FreeChoice**: Structure with alternatives and uncoerced properties
- Five axioms: love requires freedom, grave sin prevents love, death is
  final, no predestination, freedom is libertarian

## What we found

The argument chain works, but requires five axioms the Catechism doesn't
state explicitly:

1. **Love requires freedom** — the Catechism says "we cannot be united
   with God unless we freely choose to love him" but never explains WHY
   love requires freedom. Can a determined being love? The Catechism says
   no, but that's a philosophical commitment, not a derivation.

2. **Libertarian free will** — "by our own free choice" assumes the
   person could genuinely have chosen otherwise. Under compatibilism,
   "self-exclusion" is weaker — the person was uncoerced but may not
   have been able to want differently.

3. **Death is final** — no post-mortem change of will. Why is death
   the boundary? The Catechism asserts this without argument.

4. **Mortal sin prevents love of God** — what's the mechanism?

5. **No predestination** — hell is always self-chosen.

### The key finding

The "self-exclusion" framing ONLY works under libertarian free will.
Under compatibilism, the person acted from their desires but may not have
been able to desire otherwise. The Catechism commits to libertarian freedom
without announcing it — the proof assistant made this visible.

### Assessment

**Tier 3** — Multiple hidden premises. The dependency on libertarian
(not compatibilist) free will was the most interesting finding. The
unstated axiom that love requires freedom was genuinely surprising.
