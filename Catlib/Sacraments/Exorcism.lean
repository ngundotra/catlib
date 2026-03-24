import Catlib.Foundations

/-!
# CCC §1673: Exorcism — The Authority Chain

## The Catechism claims

"Jesus performed exorcisms and from him the Church has received the
power and office of exorcizing." (§1673)

"The solemn exorcism, called 'a major exorcism,' can be performed only
by a priest and with the permission of the bishop." (§1673)

## The authority delegation chain

The Catechism claims a specific chain of authority for exorcism:
1. Jesus has authority over demons (Scripture: Mk 1:27, Lk 11:20)
2. Jesus delegated this to the Apostles (Scripture: Mk 6:7, Lk 10:17)
3. The Apostles delegated to their successors (Tradition: apostolic succession)
4. Bishops hold this authority today
5. Bishops can delegate to priests (with permission)

## What we formalize

The delegation chain and its hidden assumptions:
- Authority can be DELEGATED without being DIMINISHED
- The chain is UNBROKEN from Jesus to the present
- Delegation requires AUTHORIZATION from above
- The delegated power is the SAME power, not a lesser version

## Prediction

I expect this to **reveal hidden structure**. The delegation model
requires assumptions about authority transfer that the text doesn't
state: Can delegated authority be revoked? Can it expire? Is it
automatic with ordination or does each exorcism need fresh permission?

## Findings

- **Prediction vs. reality**: Confirmed. The authority chain requires:
  (1) authority is transferable without loss, (2) the chain is unbroken
  (apostolic succession), (3) a two-tier permission system (ordination
  gives potential, bishop gives activation), (4) the power operates on
  a specific ontology where demons are personal agents that can be
  commanded.
- **Surprise level**: Moderate — the two-tier permission model
  (ordination + bishop's permission) was not predicted. It's an
  interesting access control system.
- **Assessment**: Tier 2/3 — the authority chain is well-structured
  but the demon ontology is the genuinely interesting hidden assumption.
-/

namespace Catlib.Sacraments

open Catlib

/-!
## Authority delegation model
-/

/-- A role in the Church hierarchy. -/
inductive ChurchRole where
  | christ        -- Jesus Christ
  | apostle       -- The original twelve + Paul
  | bishop        -- Successor of the apostles
  | priest        -- Ordained by a bishop
  | layperson     -- Baptized but not ordained

/-- An authority — a specific power to act in a domain. -/
structure SpiritualAuthority where
  /-- What domain does this authority cover? -/
  domain : String
  /-- Who currently holds it? -/
  holder : ChurchRole
  /-- Where did it come from? -/
  source : ChurchRole

/-- The exorcism authority. -/
def exorcismAuthority (holder : ChurchRole) (source : ChurchRole) :
    SpiritualAuthority :=
  { domain := "exorcism", holder := holder, source := source }

/-- AXIOM 1 (Scripture): Jesus has authority over demons.
    Provenance: [Scripture] Mk 1:27 ("He commands even the unclean
    spirits, and they obey him"), Lk 11:20 ("by the finger of God
    I cast out demons"). -/
axiom christ_has_exorcism_authority :
  ∃ (a : SpiritualAuthority),
    a.domain = "exorcism" ∧ a.holder = ChurchRole.christ

/-- AXIOM 2 (Scripture): Jesus delegated authority to the Apostles.
    Provenance: [Scripture] Mk 6:7 ("He gave them authority over
    unclean spirits"), Lk 10:17 ("Lord, even the demons are subject
    to us in your name"). -/
axiom christ_delegated_to_apostles :
  ∃ (a : SpiritualAuthority),
    a.domain = "exorcism" ∧
    a.holder = ChurchRole.apostle ∧
    a.source = ChurchRole.christ

/-- AXIOM 3 (Tradition): Apostolic succession — the Apostles'
    authority passed to their successors (bishops).
    Provenance: [Tradition] CCC §77, §861-862. This is the core
    claim of apostolic succession. Without it, the chain breaks.
    HIDDEN ASSUMPTION: Authority transfer is valid across generations
    without loss or expiration.

    CONNECTION TO BASE AXIOMS: Authority.lean provides
    `Catlib.apostolic_succession_general` and `Catlib.christ_delegates_exorcism`,
    but the general succession axiom is VACUOUS (concludes with True).
    This local axiom has REAL content (existential witness for exorcism
    domain specifically). The Authority.lean axiom needs strengthening
    in a future phase before this local axiom can be derived from it.

    Authority.lean's `christ_delegates_exorcism` does confirm that
    `exorcismDomain.christDelegatedIt` holds, which is the first link
    in the chain. -/
axiom apostolic_succession :
  ∃ (a : SpiritualAuthority),
    a.domain = "exorcism" ∧
    a.holder = ChurchRole.bishop ∧
    a.source = ChurchRole.apostle

/-- AXIOM 4 (§1673): Bishops can delegate exorcism to priests.
    "Can be performed only by a priest and with the permission
    of the bishop."
    HIDDEN ASSUMPTION: Two-tier permission model. Ordination gives
    the POTENTIAL to exorcize; the bishop's permission ACTIVATES it
    for a specific case. This is an access control system. -/
axiom bishop_delegates_to_priest :
  ∃ (a : SpiritualAuthority),
    a.domain = "exorcism" ∧
    a.holder = ChurchRole.priest ∧
    a.source = ChurchRole.bishop

/-- Bridge to Authority.lean: Christ has exorcism authority and
    specifically delegated it. This connects the local exorcism model
    to the general authority framework in Authority.lean. -/
theorem exorcism_delegated_from_authority_lean :
    exorcismDomain.christHasIt ∧ exorcismDomain.christDelegatedIt :=
  exorcism_authority

/-- The complete authority chain: Christ → Apostles → Bishops → Priests.
    This is derivable from the four axioms above. -/
theorem exorcism_authority_chain :
    -- Christ has it
    (∃ a : SpiritualAuthority, a.domain = "exorcism" ∧ a.holder = ChurchRole.christ) ∧
    -- Delegated to apostles
    (∃ a : SpiritualAuthority, a.domain = "exorcism" ∧ a.holder = ChurchRole.apostle) ∧
    -- Passed to bishops
    (∃ a : SpiritualAuthority, a.domain = "exorcism" ∧ a.holder = ChurchRole.bishop) ∧
    -- Delegated to priests
    (∃ a : SpiritualAuthority, a.domain = "exorcism" ∧ a.holder = ChurchRole.priest) := by
  refine ⟨christ_has_exorcism_authority, ?_, ?_, ?_⟩
  · obtain ⟨a, hd, hh, _⟩ := christ_delegated_to_apostles; exact ⟨a, hd, hh⟩
  · obtain ⟨a, hd, hh, _⟩ := apostolic_succession; exact ⟨a, hd, hh⟩
  · obtain ⟨a, hd, hh, _⟩ := bishop_delegates_to_priest; exact ⟨a, hd, hh⟩

/-- AXIOM: Spiritual authority must come from above — you cannot
    be your own source of spiritual authority.
    Provenance: [Scripture] Jn 15:5 ("without me you can do nothing"),
    Heb 5:4 ("no one takes this honor on himself").
    HIDDEN ASSUMPTION: Authority is not democratically distributed.
    The chain is hierarchical by design. -/
axiom authority_requires_higher_source :
  ∀ (a : SpiritualAuthority),
    a.domain = "exorcism" → a.holder = a.source → False

theorem laypersons_cannot_exorcize :
    ¬(∃ (a : SpiritualAuthority),
      a.domain = "exorcism" ∧
      a.holder = ChurchRole.layperson ∧
      a.source = ChurchRole.layperson) := by
  intro ⟨a, hd, hh, hs⟩
  have : a.holder = a.source := by rw [hh, hs]
  exact authority_requires_higher_source a hd this

/-!
## The demon ontology

The exorcism teaching assumes a specific ontology:
- Demons are PERSONAL agents (they can be "commanded")
- They can POSSESS persons (occupy/control)
- They respond to AUTHORITY (they obey commands)
- They are FINITE (they can be expelled)

This is a rich ontological commitment the Catechism makes without
argument. The existence of demons is declared "a truth of faith"
(§328 for angels; §391 for fallen angels/demons).
-/

/-- A demon — a fallen angel, personal spiritual being. -/
structure Demon where
  /-- Demons are personal — they have intellect and will -/
  isPersonal : Prop
  /-- Demons are finite — limited in power -/
  isFinite : Prop
  /-- Demons can be commanded by proper authority -/
  respondsToAuthority : Prop

/-- AXIOM 5 (§391-395): Demons exist as personal spiritual beings.
    Provenance: [Scripture] Mt 4:1-11 (temptation), Mk 5:1-20
    (Gerasene demoniac); [Tradition] Fourth Lateran Council (1215).
    HIDDEN ASSUMPTION: This is a literal ontological claim, not a
    metaphor for evil or mental illness. The Catechism explicitly
    distinguishes demonic possession from psychological illness (§1673). -/
axiom demons_exist :
  ∃ (d : Demon), d.isPersonal ∧ d.isFinite ∧ d.respondsToAuthority

-- REMOVED AXIOM: possession_distinguishable_from_illness (was vacuous — body was True).
-- §1673: Possession is distinguishable from illness.
-- "Illness, especially psychological illness, is a very different
-- matter; treating this is the concern of medical science."
-- HIDDEN ASSUMPTION: There exists a reliable way to distinguish
-- demonic possession from mental illness. The Catechism asserts
-- the distinction but gives NO diagnostic criteria. This is
-- perhaps the biggest epistemic gap in the exorcism teaching.

/-!
## Summary of hidden assumptions

1. **Authority transfers without loss** — delegated power = original power
2. **The chain is unbroken** — apostolic succession (the biggest assumption)
3. **Two-tier permission** — ordination gives potential, bishop activates
4. **Hierarchical, not democratic** — laypersons excluded
5. **Demons are personal agents** — literal, not metaphorical
6. **Possession ≠ illness** — distinguishable but criteria unstated
-/

end Catlib.Sacraments
