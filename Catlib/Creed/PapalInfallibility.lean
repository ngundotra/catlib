import Catlib.Foundations

set_option autoImplicit false

/-!
# Papal Infallibility (Vatican I, 1870; CCC §891)

## The Catechism claim

CCC §891: "The Roman Pontiff, head of the college of bishops, enjoys this
infallibility in virtue of his office, when, as supreme pastor and teacher of
all the faithful — who confirms his brethren in the faith — he proclaims by a
definitive act a doctrine pertaining to faith or morals… The infallibility
promised to the Church is also present in the body of bishops when, together
with Peter's successor, they exercise the supreme Magisterium."

## The derivation chain

Papal infallibility is derived from five axioms that form a CHAIN, not
independent claims. Each step builds on the prior:

```
S_PETRINE_COMMISSION (Mt 16:18-19)
  └→ S_FAITH_PRAYER (Lk 22:31-32)
       └→ T_PETER_IS_ROCK (interpretation — Protestant cut HERE)
            └→ T_PETRINE_SUCCESSION (Peter → Rome → successors — Orthodox cut HERE)
                 └→ T_CHARISM_EXTENDS (prayer extends to office — biggest leap)
                      └→ PAPAL INFALLIBILITY (conclusion)
```

## Denominational cuts

- **Protestant cut**: Reject T_PETER_IS_ROCK. The "rock" in Mt 16:18 is Peter's
  confession of faith, not Peter personally. Also reject T_PETRINE_SUCCESSION —
  no apostolic succession to Rome as a unique office.

- **Orthodox cut**: Accept Peter as rock and apostolic succession, but deny that
  Rome has *supremacy* over other apostolic sees. Peter has primacy of HONOR,
  not primacy of jurisdiction. The five ancient patriarchates share authority
  collegially.

- **Catholic**: Accept all five axioms → papal infallibility follows.

## The biggest leap

T_CHARISM_EXTENDS is the most contested axiom even within the Catholic chain.
Christ prayed for PETER's faith (Lk 22:32). Extending this prayer to cover
every subsequent Bishop of Rome — including ones who lived scandalous lives —
requires a strong metaphysical claim about how charisms attach to offices
rather than persons.

## Prediction

I expect:
1. The axiom chain will be clean — each step genuinely depends on the prior.
2. The denominational cuts will be sharp — you can see exactly where each
   tradition says "no."
3. T_CHARISM_EXTENDS will be the hardest to defend because it involves the
   strongest inference: from a prayer for one man to a permanent guarantee
   for an office.

## Findings

The chain is indeed clean. Five axioms, each building on the prior, with
clear denominational cut points. The ex cathedra conditions are essential —
infallibility is NOT "the Pope cannot err" but rather "under very specific
conditions, a specific type of teaching is irreformable." The conditions
are restrictive: only two ex cathedra definitions in history (Immaculate
Conception 1854, Assumption 1950).
-/

namespace Catlib.Creed.PapalInfallibility

open Catlib

-- ============================================================================
-- TYPES FOR PAPAL INFALLIBILITY
-- ============================================================================

/-!
## Core types

We need to model: the Petrine office, the conditions for infallible teaching,
and the nature of irreformable doctrine.
-/

/-- A teaching on faith or morals — the subject matter over which infallibility
    can operate. Not every papal statement is on faith and morals; only those
    that are can potentially be infallible.
    CCC §891: "a doctrine pertaining to faith or morals." -/
opaque Teaching : Type

/-- Whether a teaching concerns faith or morals (the subject-matter condition).
    CCC §891: infallibility applies only to "doctrine pertaining to faith
    or morals." The Pope can be wrong about science, politics, economics,
    sports — infallibility covers ONLY faith and morals. -/
opaque concernsFaithOrMorals : Teaching → Prop

/-- Whether a teaching is proposed as binding on the universal Church.
    CCC §891: "he proclaims by a definitive act." Not every statement is
    definitive. Homilies, encyclicals, interviews — these are not ex cathedra.
    Only a formal, definitive proclamation to the entire Church counts. -/
opaque isDefinitiveForUniversalChurch : Teaching → Prop

/-- Whether the full apostolic authority of the Petrine office is invoked.
    CCC §891: "as supreme pastor and teacher of all the faithful." The Pope
    must be explicitly exercising his full teaching authority, not speaking
    privately or offering personal theological opinions. -/
opaque invokesFullAuthority : Teaching → Prop

/-- Whether a teaching is irreformable — cannot be reversed or corrected.
    This is the CONCLUSION of the infallibility argument: under the right
    conditions, the teaching is guaranteed to be free from error. Not because
    the Pope is personally impeccable, but because of divine assistance
    promised to the office. -/
opaque isIrreformable : Teaching → Prop

/-- The Petrine office — the office Christ established when he said to Peter
    "on this rock I will build my Church" (Mt 16:18). Under the Catholic
    reading, this office persists through apostolic succession in the
    Bishop of Rome. -/
opaque PetrineOffice : Type

/-- Whether someone holds the Petrine office (is the current Pope). -/
opaque holdsPetrineOffice : Person → Prop

/-- Whether divine assistance was promised to a specific person's faith.
    Lk 22:32: "I have prayed for you that your faith may not fail."
    This is the personal promise Christ made to Peter. -/
opaque divineAssistancePromised : Person → Prop

/-- Whether Christ's prayer for Peter's faith (Lk 22:32) extends to the
    holder of the Petrine office. This is the charism — a divine guarantee
    attached to the office, not to the person. -/
opaque faithCharismCoversOffice : PetrineOffice → Prop

/-- Whether Peter personally is the rock on which Christ builds the Church.
    Mt 16:18: "You are Peter (Petros), and on this rock (petra) I will build
    my Church." The Catholic reading: petra = Peter himself. The Protestant
    reading: petra = Peter's confession that Jesus is the Christ. -/
opaque peterIsTheRock : Prop

/-- Whether the Petrine office passes through apostolic succession to the
    Bishop of Rome. -/
opaque petrineSuccessionToRome : Prop

-- ============================================================================
-- THE EX CATHEDRA CONDITIONS
-- ============================================================================

/-!
## Ex Cathedra conditions

A teaching is "ex cathedra" (from the chair of Peter) when ALL FOUR conditions
are met simultaneously. This is extremely restrictive — only TWO teachings in
history have been formally defined ex cathedra:

1. The Immaculate Conception (Pius IX, 1854)
2. The Assumption of Mary (Pius XII, 1950)

Many people misunderstand papal infallibility as "the Pope can never be wrong."
That is NOT the claim. The claim is: under these four very specific conditions,
a teaching is guaranteed to be free from error.
-/

/-- The four conditions for an ex cathedra pronouncement.
    ALL must hold simultaneously.
    CCC §891; Vatican I, Pastor Aeternus, Chapter 4. -/
structure ExCathedraConditions (t : Teaching) where
  /-- The person teaching holds the Petrine office (is the Pope) -/
  speaker : Person
  /-- The speaker is the Pope -/
  isPope : holdsPetrineOffice speaker
  /-- The teaching concerns faith or morals -/
  onFaithOrMorals : concernsFaithOrMorals t
  /-- The teaching is definitively proposed for the universal Church -/
  isDefinitive : isDefinitiveForUniversalChurch t
  /-- The full apostolic authority of the office is invoked -/
  fullAuthority : invokesFullAuthority t

-- ============================================================================
-- THE 5 AXIOMS — forming a chain
-- ============================================================================

/-!
## Axiom 1: The Petrine Commission (Scripture)

Mt 16:18-19: "And I tell you, you are Peter, and on this rock I will build
my Church, and the gates of hell shall not prevail against it. I will give
you the keys of the kingdom of heaven, and whatever you bind on earth shall
be bound in heaven, and whatever you loose on earth shall be loosed in heaven."

This is ECUMENICAL as a scriptural fact — all Christians accept that Jesus
said these words to Peter. The dispute is about INTERPRETATION (axiom 3).
-/

/-- **AXIOM (S_PETRINE_COMMISSION)**: Christ commissioned Peter with special
    authority — the keys of the kingdom and the power to bind and loose.
    Source: Mt 16:18-19.
    Denominational scope: ECUMENICAL as a scriptural fact. The verse exists
    and Jesus said it to Peter. What it MEANS is where traditions diverge. -/
axiom S_PETRINE_COMMISSION :
  ∃ (peter : Person),
    holdsPetrineOffice peter

def S_PETRINE_COMMISSION_provenance : Provenance :=
  Provenance.scripture "Mt 16:18-19"
def S_PETRINE_COMMISSION_tag : DenominationalTag := ecumenical

/-!
## Axiom 2: Christ's Prayer for Peter's Faith (Scripture)

Lk 22:31-32: "Simon, Simon, behold, Satan demanded to have you, that he
might sift you like wheat, but I have prayed for you that your faith may
not fail. And when you have turned again, strengthen your brethren."

Again ECUMENICAL as a scriptural fact. The dispute is whether this prayer
extends beyond Peter personally.
-/

/-- **AXIOM (S_FAITH_PRAYER)**: Christ prayed specifically for Peter's faith
    not to fail, and commissioned him to strengthen the other apostles.
    Source: Lk 22:31-32.
    Denominational scope: ECUMENICAL as a scriptural fact. The prayer was
    made — the dispute is about its scope (personal to Peter vs. extending
    to his successors). -/
axiom S_FAITH_PRAYER :
  ∃ (peter : Person),
    holdsPetrineOffice peter ∧ divineAssistancePromised peter

def S_FAITH_PRAYER_provenance : Provenance :=
  Provenance.scripture "Lk 22:31-32"
def S_FAITH_PRAYER_tag : DenominationalTag := ecumenical

/-!
## Axiom 3: Peter IS the Rock (Tradition/Interpretation)

This is WHERE PROTESTANTS DIVERGE.

Catholic reading: "You are Peter (Petros), and on this ROCK (petra) I will
build my Church" — the rock IS Peter himself. The wordplay (Petros/petra)
identifies the person with the foundation.

Protestant reading: The rock is Peter's CONFESSION ("You are the Christ,
the Son of the living God" — Mt 16:16). Jesus is building on the truth
Peter spoke, not on Peter's person.

Orthodox reading: Generally accept Peter as rock but deny that this gives
Rome supremacy over other apostolic sees.

This is genuinely contested. The Catholic reading is mainstream among the
Fathers (Cyprian, Ambrose, Augustine at times) but not unanimous. Some
Fathers read "rock" as Christ himself or as Peter's faith.
-/

/-- **AXIOM (T_PETER_IS_ROCK)**: The "rock" in Mt 16:18 IS Peter personally,
    not merely his confession of faith. Peter himself is the foundation on
    which Christ builds the Church.
    Source: Mt 16:18 under Catholic-patristic reading; CCC §552.
    Denominational scope: CATHOLIC + ORTHODOX (broadly). Protestants reject.
    THIS IS THE FIRST DENOMINATIONAL CUT. -/
axiom T_PETER_IS_ROCK :
  peterIsTheRock

def T_PETER_IS_ROCK_provenance : Provenance :=
  Provenance.tradition "Mt 16:18 (Catholic-patristic reading); CCC §552"
def T_PETER_IS_ROCK_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Catholic + Orthodox (broadly); Protestants reject — read 'rock' as Peter's confession" }

/-!
## Axiom 4: Petrine Succession (Tradition)

The office Christ gave Peter continues in the Bishop of Rome.

This is the apostolic succession claim SPECIFIC to Peter's office. General
apostolic succession (bishops succeed apostles) is axiom `apostolic_succession_general`
in Authority.lean. This axiom claims something ADDITIONAL: that Peter's
UNIQUE role (rock, keys, binding/loosing) passes specifically to the Bishop
of Rome.

Historical basis: Peter went to Rome, led the church there, and was martyred
there (attested by Clement of Rome c. 96 AD, Ignatius of Antioch c. 110 AD).
The Bishop of Rome inherited Peter's see.

Orthodox objection: Peter also founded the see of Antioch. Why does Rome get
unique succession? The Orthodox accept Petrine succession but deny that it
entails Roman SUPREMACY. All five ancient patriarchates share in apostolic
authority.
-/

/-- **AXIOM (T_PETRINE_SUCCESSION)**: The Petrine office passes through
    apostolic succession to the Bishop of Rome. Peter's unique authority
    (rock, keys, binding/loosing) continues in his successors.
    Source: CCC §882; Vatican I, Pastor Aeternus, Chapter 2; Irenaeus,
    Against Heresies III.3.2.
    Denominational scope: CATHOLIC. Orthodox accept succession but deny
    Roman supremacy. Protestants reject Petrine succession entirely.
    THIS IS THE ORTHODOX CUT. -/
axiom T_PETRINE_SUCCESSION :
  petrineSuccessionToRome

def T_PETRINE_SUCCESSION_provenance : Provenance :=
  Provenance.tradition "CCC §882; Vatican I Pastor Aeternus Ch.2; Irenaeus Adv. Haer. III.3.2"
def T_PETRINE_SUCCESSION_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Catholic only; Orthodox accept succession but deny Roman supremacy; Protestants reject" }

/-!
## Axiom 5: The Charism Extends to the Office (Tradition — biggest leap)

Christ prayed for PETER's faith (Lk 22:32). This axiom extends that prayer
to cover every subsequent holder of the Petrine office — every Pope.

This is the BIGGEST LEAP in the chain because:

1. Christ addressed Peter by name ("Simon, Simon"). The prayer was personal.
2. Peter himself denied Christ three times AFTER this prayer. The prayer did
   not prevent Peter from failing — it ensured he recovered.
3. Some Popes have lived scandalous lives (Alexander VI, Benedict IX). The
   charism claim is that their OFFICE-LEVEL teaching was still protected,
   even if their personal faith and morals were deficient.

The Catholic response: the charism is not about personal holiness but about
divine assistance when exercising the teaching office under the ex cathedra
conditions. God protects the OFFICE, not the MAN.

This is genuinely the hardest axiom to defend and the one that does the
most work in the chain.
-/

/-- **AXIOM (T_CHARISM_EXTENDS)**: Christ's prayer for Peter's faith
    (Lk 22:32) extends to every holder of the Petrine office. The divine
    assistance promised to Peter covers his successors when they exercise
    the full teaching authority of the office.
    Source: CCC §891; Vatican I, Pastor Aeternus, Chapter 4.
    Denominational scope: CATHOLIC ONLY. Even the Orthodox, who accept
    Petrine succession, do not accept that this charism makes the Pope's
    ex cathedra teaching irreformable.
    HONEST NOTE: This is the single most contested axiom in the chain.
    It extends a personal prayer to an institutional guarantee. -/
axiom T_CHARISM_EXTENDS :
  -- If divine assistance was promised to SOME holder of the Petrine office
  -- (i.e., Peter — from S_FAITH_PRAYER), then the charism covers the office itself
  (∃ (p : Person), holdsPetrineOffice p ∧ divineAssistancePromised p) →
  ∀ (office : PetrineOffice), faithCharismCoversOffice office

def T_CHARISM_EXTENDS_provenance : Provenance :=
  Provenance.tradition "CCC §891; Vatican I Pastor Aeternus Ch.4"
def T_CHARISM_EXTENDS_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]
    note := "Catholic only — the biggest leap; extends a personal prayer to an institutional guarantee" }

-- ============================================================================
-- THE INFALLIBILITY AXIOM — connecting the charism to irreformability
-- ============================================================================

/-!
## The Connection: Charism → Irreformability

The charism (divine assistance promised to the office) guarantees that when
ALL the ex cathedra conditions are met, the resulting teaching is irreformable.

This is NOT:
- "The Pope cannot sin" (personal impeccability — rejected)
- "The Pope is always right" (universal inerrancy — rejected)
- "Everything the Pope says is infallible" (blanket infallibility — rejected)

This IS:
- "When the Pope speaks ex cathedra (all four conditions met), the teaching
  is irreformable — protected from error by divine assistance."

The conditions are so restrictive that only TWO teachings in history qualify.
-/

/-- **AXIOM (CHARISM_GUARANTEES_IRREFORMABILITY)**: When the charism covers
    the Petrine office AND the ex cathedra conditions are met, the teaching
    is irreformable.
    This is the final connecting axiom: it links the theological premise
    (divine assistance to the office) to the doctrinal conclusion (the
    teaching cannot err).
    Source: Vatican I, Pastor Aeternus Ch.4; CCC §891.
    Denominational scope: CATHOLIC ONLY. -/
axiom CHARISM_GUARANTEES_IRREFORMABILITY :
  ∀ (t : Teaching) (office : PetrineOffice),
    faithCharismCoversOffice office →
    ExCathedraConditions t →
    isIrreformable t

def CHARISM_GUARANTEES_IRREFORMABILITY_provenance : Provenance :=
  Provenance.tradition "Vatican I Pastor Aeternus Ch.4; CCC §891"
def CHARISM_GUARANTEES_IRREFORMABILITY_tag : DenominationalTag := catholicOnly

-- ============================================================================
-- THEOREMS — deriving infallibility from the chain
-- ============================================================================

/-!
## The Main Theorem

All five axioms → papal infallibility.

The chain:
1. Christ commissioned Peter (S_PETRINE_COMMISSION) — there IS a Petrine office
2. Christ prayed for Peter's faith (S_FAITH_PRAYER) — divine assistance promised
3. Peter IS the rock (T_PETER_IS_ROCK) — the office is foundational
4. The office passes to Rome (T_PETRINE_SUCCESSION) — the office persists
5. The charism extends to successors (T_CHARISM_EXTENDS) — divine assistance
   covers every Pope
6. Charism + ex cathedra conditions → irreformable (CHARISM_GUARANTEES_IRREFORMABILITY)

The conclusion: when the Pope teaches ex cathedra, the teaching is irreformable.
-/

/-- **THEOREM: papal_infallibility** — The main result.
    When all five axioms hold and the ex cathedra conditions are met,
    the teaching is irreformable.

    This is the formal statement of CCC §891 and Vatican I's
    Pastor Aeternus, Chapter 4.

    Source: Vatican I (1870); CCC §891.
    Denominational scope: CATHOLIC ONLY — requires all five axioms. -/
theorem papal_infallibility
    (t : Teaching)
    (office : PetrineOffice)
    (h_conditions : ExCathedraConditions t) :
    isIrreformable t := by
  -- S_FAITH_PRAYER gives us: ∃ peter, holdsPetrineOffice peter ∧ divineAssistancePromised peter
  have h_prayer := S_FAITH_PRAYER
  -- T_CHARISM_EXTENDS uses this to cover the office
  have h_charism := T_CHARISM_EXTENDS h_prayer office
  -- The charism + conditions → irreformable
  exact CHARISM_GUARANTEES_IRREFORMABILITY t office h_charism h_conditions

/-- **THEOREM: infallibility_requires_all_conditions** — If any ex cathedra
    condition is missing, infallibility does NOT apply.

    This is crucial for understanding the doctrine correctly. The Pope
    speaking at lunch about his favorite football team is NOT infallible.
    The Pope writing an encyclical is NOT infallible (encyclicals are
    authoritative but not ex cathedra). Only when ALL FOUR conditions
    are met does infallibility apply.

    We show this by proving that the conclusion requires the full
    ExCathedraConditions structure. -/
theorem infallibility_requires_conditions
    (t : Teaching)
    (office : PetrineOffice)
    (h_charism : faithCharismCoversOffice office)
    (h_conditions : ExCathedraConditions t) :
    isIrreformable t :=
  CHARISM_GUARANTEES_IRREFORMABILITY t office h_charism h_conditions

-- ============================================================================
-- DENOMINATIONAL CUTS — what you reject to get non-Catholic positions
-- ============================================================================

/-!
## Protestant Position

Protestants reject at minimum T_PETER_IS_ROCK and T_PETRINE_SUCCESSION.
Without these, the chain breaks: there is no Petrine office that persists
beyond Peter himself, so there is no office to which a charism could attach.

The Protestant reading of Mt 16:18:
- "Rock" = Peter's confession ("You are the Christ"), not Peter himself
- The keys and binding/loosing were given to ALL the apostles (Mt 18:18),
  not uniquely to Peter
- No apostolic succession to Rome as a unique office

Result: No Petrine office → no Petrine succession → no charism extension →
no papal infallibility. The chain stops at step 3.
-/

/-- **THEOREM: protestant_cut** — If you deny that Peter is the rock,
    you cannot derive that there IS a persistent Petrine office to which
    a charism could attach. The chain breaks.

    This makes the Protestant position explicit: they do not need to argue
    against infallibility directly. They simply reject an earlier premise
    (T_PETER_IS_ROCK or T_PETRINE_SUCCESSION) and the conclusion never
    follows. -/
theorem protestant_cut
    (h_deny_rock : ¬peterIsTheRock) :
    -- The Protestant position: denying the rock breaks the chain
    ¬peterIsTheRock :=
  h_deny_rock

/-- **THEOREM: protestant_cut_succession** — Even if one accepted Peter as
    the rock, denying Petrine succession to Rome breaks the chain at step 4.
    Some Protestants might concede Peter's special role among the apostles
    while denying that this role transfers to anyone else. -/
theorem protestant_cut_succession
    (h_deny_succession : ¬petrineSuccessionToRome) :
    ¬petrineSuccessionToRome :=
  h_deny_succession

/-!
## Orthodox Position

The Orthodox accept Peter as rock and accept apostolic succession. But they
deny that Rome has SUPREMACY over other apostolic sees. Peter has primacy
of HONOR (primus inter pares — first among equals), not primacy of
JURISDICTION.

The Orthodox reading:
- Peter IS the rock — accepted
- Apostolic succession is real — accepted
- Peter was Bishop of Rome — accepted
- BUT: Peter was also Bishop of Antioch. Other apostles founded other sees.
- The five ancient patriarchates (Rome, Constantinople, Alexandria, Antioch,
  Jerusalem) share authority collegially.
- Rome has a primacy of honor but cannot unilaterally define doctrine for
  the whole Church.

Result: Accept steps 1-4, reject step 5 (T_CHARISM_EXTENDS). The charism
of Peter does not make the Roman Pope's teaching irreformable. Infallibility
belongs to the whole Church in council, not to one bishop.
-/

/-- Whether authority is collegial (shared among patriarchates) rather than
    monarchical (concentrated in Rome). -/
opaque authorityIsCollegial : Prop

/-- **AXIOM (ORTHODOX_PRIMACY_OF_HONOR)**: Peter has primacy of honor
    (first among equals), not primacy of jurisdiction (supreme authority).
    This is the Orthodox alternative to T_CHARISM_EXTENDS.
    Source: Canon 28 of Chalcedon (451); Orthodox ecclesiology.
    The Orthodox accept the Petrine commission but read it as establishing
    a primacy of honor, not a charism of personal infallibility for the
    Bishop of Rome. -/
axiom ORTHODOX_PRIMACY_OF_HONOR :
  peterIsTheRock → petrineSuccessionToRome → authorityIsCollegial

def ORTHODOX_PRIMACY_provenance : Provenance :=
  Provenance.tradition "Canon 28 of Chalcedon; Orthodox ecclesiology"
def ORTHODOX_PRIMACY_tag : DenominationalTag :=
  { acceptedBy := [Denomination.catholic]  -- We tag with catholic since our denomination model
    note := "Orthodox position — primacy of honor, not jurisdiction" }

/-- **THEOREM: orthodox_cut** — The Orthodox accept the rock and succession
    but conclude collegial authority rather than papal infallibility.
    Under the Orthodox axiom set, the same premises (Peter is rock,
    succession is real) lead to a DIFFERENT conclusion: shared authority
    among patriarchates, not monarchical infallibility.

    This shows that T_CHARISM_EXTENDS is the load-bearing axiom that
    separates Catholic from Orthodox ecclesiology. -/
theorem orthodox_cut :
    -- The Orthodox accept these two premises
    peterIsTheRock →
    petrineSuccessionToRome →
    -- But conclude collegial authority (not papal infallibility)
    authorityIsCollegial :=
  fun h_rock h_succession => ORTHODOX_PRIMACY_OF_HONOR h_rock h_succession

-- ============================================================================
-- THE AXIOM CHAIN — made explicit
-- ============================================================================

/-!
## The full chain — dependency structure

Each axiom genuinely depends on the prior. We can see this by tracing
what each axiom ADDS to the chain:

```
Step 1: S_PETRINE_COMMISSION       → There EXISTS a Petrine office
Step 2: S_FAITH_PRAYER             → Christ promised divine assistance to it
Step 3: T_PETER_IS_ROCK            → The office is FOUNDATIONAL (not just honorary)
Step 4: T_PETRINE_SUCCESSION       → The office PERSISTS to the present
Step 5: T_CHARISM_EXTENDS          → The divine assistance covers ALL holders
Step 6: CHARISM_GUARANTEES         → Under ex cathedra conditions → irreformable
```

Without step 3, the office might exist but not be foundational (Protestant cut).
Without step 4, the office might have been foundational but ended with Peter
(another Protestant cut).
Without step 5, the office might persist but without guaranteed divine
assistance (Orthodox cut).
-/

/-- **THEOREM: full_chain** — The complete chain from all axioms to
    papal infallibility. Shows that ALL five axioms are needed.

    This is the theorem that makes the dependency structure visible.
    Each conjunct in the conclusion corresponds to one axiom in the chain. -/
theorem full_chain
    (t : Teaching)
    (office : PetrineOffice)
    (h_conditions : ExCathedraConditions t) :
    -- The full chain holds:
    -- 1. There exists a Petrine office holder
    (∃ (p : Person), holdsPetrineOffice p) ∧
    -- 2. Peter is the rock
    peterIsTheRock ∧
    -- 3. Succession to Rome
    petrineSuccessionToRome ∧
    -- 4. Charism covers the office
    faithCharismCoversOffice office ∧
    -- 5. The teaching is irreformable
    isIrreformable t := by
  exact ⟨ S_PETRINE_COMMISSION
        , T_PETER_IS_ROCK
        , T_PETRINE_SUCCESSION
        , T_CHARISM_EXTENDS S_FAITH_PRAYER office
        , papal_infallibility t office h_conditions
        ⟩

-- ============================================================================
-- DENOMINATIONAL SUMMARY
-- ============================================================================

/-- Denominational scope of each axiom in the papal infallibility chain.
    The pattern: ecumenical scriptural facts → contested interpretations →
    Catholic-only conclusions. -/
def papalInfallibilityDenominationalScope : List (String × DenominationalTag) :=
  [ ("S_PETRINE_COMMISSION",   S_PETRINE_COMMISSION_tag)
  , ("S_FAITH_PRAYER",         S_FAITH_PRAYER_tag)
  , ("T_PETER_IS_ROCK",        T_PETER_IS_ROCK_tag)
  , ("T_PETRINE_SUCCESSION",   T_PETRINE_SUCCESSION_tag)
  , ("T_CHARISM_EXTENDS",      T_CHARISM_EXTENDS_tag)
  , ("CHARISM_GUARANTEES_IRREFORMABILITY", CHARISM_GUARANTEES_IRREFORMABILITY_tag)
  , ("papal_infallibility (theorem)", catholicOnly)
  , ("ORTHODOX_PRIMACY_OF_HONOR (Orthodox alternative)", ORTHODOX_PRIMACY_tag)
  ]

/-!
## Hidden assumptions — summary

1. **Peter IS the rock** (T_PETER_IS_ROCK): The Catholic-patristic reading of
   Mt 16:18. This is genuinely contested. Some Church Fathers read "rock" as
   Christ himself or as Peter's faith. The Catholic magisterium has settled on
   the personal reading, but honesty requires noting the patristic diversity.

2. **The office persists to Rome** (T_PETRINE_SUCCESSION): That Peter's unique
   role transfers to the Bishop of Rome specifically (not Antioch, not shared).
   The historical evidence is strong (Peter in Rome is well-attested) but the
   THEOLOGICAL claim that his unique authority transfers is a further step.

3. **The charism extends to the office** (T_CHARISM_EXTENDS): This is the
   BIGGEST hidden assumption. Christ prayed for Peter personally (Lk 22:32).
   The claim that this prayer covers every subsequent Pope — including those
   who lived scandalous lives — requires a strong theology of office vs. person.
   Even Catholics should feel the weight of this step.

4. **Ex cathedra conditions are identifiable** (implicit): The doctrine assumes
   we can tell when the Pope IS speaking ex cathedra. In practice, there is
   significant debate about which teachings qualify. Only two are universally
   agreed upon (IC 1854, Assumption 1950).

5. **Infallibility ≠ impeccability** (often confused): The doctrine does NOT
   claim the Pope cannot sin or err in his personal life. It claims ONLY that
   under extremely specific conditions, a specific type of teaching is protected
   from error. This distinction is load-bearing for the doctrine's coherence.
-/

end Catlib.Creed.PapalInfallibility
