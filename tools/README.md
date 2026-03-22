# theorem-tree

Generate tree-style breakdowns of Lean 4 theorems, axioms, and their connections.

## What it does

Parses Lean 4 `.lean` files and produces a tree visualization showing:

- **Declarations**: axiom, theorem, def, structure, inductive, opaque
- **Descriptions**: extracted from `/-- ... -/` docstring blocks (smart extraction avoids repeating the name)
- **Metadata**: source references, denominational scope, hidden assumptions, provenance type tags
- **Dependencies**: what each declaration references (other axioms, theorems, defs)
- **Cross-file connections**: when a theorem in file A uses an axiom from file B
- **Flow diagrams**: Sankey-style left-to-right dependency visualization (axioms -> theorems -> derived)

## Requirements

- Python 3 (no external dependencies)

## Usage

Run from the project root (`/home/ngundotra/Documents/catlib/`):

```bash
# Tree of a single file (default: --brief mode)
./tools/theorem-tree Catlib/Foundations/Axioms.lean

# Tree of a directory
./tools/theorem-tree Catlib/Creed/

# Tree of everything
./tools/theorem-tree Catlib/

# Show cross-file connections only
./tools/theorem-tree --connections Catlib/

# Show just axioms
./tools/theorem-tree --axioms-only Catlib/Foundations/

# Show just theorems
./tools/theorem-tree --theorems-only Catlib/MoralTheology/

# Brief mode (default) — one-line description + source/scope metadata
./tools/theorem-tree --brief Catlib/Foundations/Axioms.lean

# Verbose mode — full multi-line docstrings
./tools/theorem-tree --verbose Catlib/Creed/DivineModes.lean

# Dependency flow diagram — Sankey-style left-to-right
./tools/theorem-tree --flow Catlib/MoralTheology/TheologyOfBody.lean
./tools/theorem-tree --flow Catlib/Creed/MarianDogma.lean

# Graph queries — analyze the dependency structure
./tools/theorem-tree --top-axioms 5 Catlib/          # Most load-bearing axioms
./tools/theorem-tree --top-theorems 5 Catlib/         # Most complex theorems
./tools/theorem-tree --bottom-axioms 5 Catlib/        # Least-connected axioms
./tools/theorem-tree --islands Catlib/                 # Isolated/unused axioms
./tools/theorem-tree --trace hope_for_salvation_of_suicide Catlib/  # Trace a theorem's deps
./tools/theorem-tree --defs Catlib/Creed/DivineModes.lean           # Definitions and their users
```

## Example output

### Brief mode (default)

```
Theorem Tree: Catlib/Foundations/Axioms.lean
============================================================

└── Catlib/Foundations/
    └── Axioms.lean
        ├── [axiom] p1_hylomorphism
        │   │   "HYLOMORPHISM: Every material substance is a composite of form and matter."
        │   │   Source: Aristotle, Metaphysics VII-IX; Aquinas, ST I q.75-76
        │   └── <- uses: Composite
        ├── [axiom] s1_god_is_love
        │   │   "GOD_IS_LOVE: God's very nature is love, and genuine love requires"
        │   │   Source: 1 John 4:8 ("God is love"); Deuteronomy 30:19 ...
        ...

Summary: 68 declarations (17 axioms, 18 defs, 32 opaques, 1 structure)
```

### Flow mode

```
Dependency Flow: Catlib/MoralTheology/TheologyOfBody.lean
============================================================

AXIOMS               THEOREMS                        DERIVED
───────────────────  ──────────────────────────────  ─────────────────────────────
inherentMeaning [opaque] ───▶ contraception_is_body_lie, contradictsInherentMeaning
  contradictsInherentMeaning [def] ───▶ SIGN_TRUTHFULNESS, contraception_is_body_lie
    SIGN_TRUTHFULNESS [axiom] ───▶ contraception_is_body_lie
      contraception_is_body_lie [theorem]

Flow: AXIOMS: 9 -> THEOREMS: 16 -> DERIVED (L2): 5 -> DERIVED (L3): 2 -> DERIVED: 1
```

## Options

| Flag | Description |
|------|-------------|
| `--brief` | One-line descriptions with source/scope metadata (default) |
| `--verbose` | Full multi-line docstrings for each declaration |
| `--flow` | Sankey-style left-to-right dependency flow diagram |
| `--connections` | Show only cross-file connections |
| `--axioms-only` | Filter to show only `axiom` declarations |
| `--theorems-only` | Filter to show only `theorem` declarations |
| `--defs-only` | Filter to show only `def` declarations |
| `--top-axioms K` | Show the K most load-bearing axioms (by transitive theorem dependents) |
| `--top-theorems M` | Show the M most-dependent theorems (by transitive axiom count) |
| `--bottom-axioms K` | Show the K least-connected axioms (candidates for removal) |
| `--islands` | Show isolated axioms not used by any theorem |
| `--trace NAME` | Trace all transitive dependencies of a declaration as a tree |
| `--defs` | Show definitions and which declarations use them |
| `-h`, `--help` | Show help message |

## Docstring metadata extraction

The tool parses `/-- ... -/` docstring blocks and extracts:

- **Short description**: First meaningful sentence (skips name-in-caps repetition, labels, section headers)
- **Source**: `*Source*:` or `PROVENANCE:` lines (e.g., "Aristotle, Metaphysics VII-IX")
- **Scope**: `Denominational scope:` lines (e.g., "Ecumenical", "Catholic only")
- **Hidden assumptions**: `HIDDEN ASSUMPTION:` lines (flagged with a warning symbol)
- **Provenance type**: `[Scripture]`, `[Tradition]`, `[Definition]` tags

## How it works

The tool uses regex-based parsing to extract declarations from Lean 4 source files. For each declaration it:

1. Identifies the kind (axiom/theorem/def/structure/inductive/opaque)
2. Extracts the name
3. Parses the full `/-- ... -/` docstring, extracting a smart one-line description plus structured metadata
4. Scans the declaration body for references to other known declarations
5. Tags cross-file references with the source file

For `--flow` mode, it additionally:

6. Builds a dependency graph (which declarations use which others)
7. Topologically sorts declarations by depth (axioms left, derived results right)
8. Groups connected components vertically
9. Draws ASCII arrows showing the dependency flow
10. Annotates cross-file dependencies with `(from File)` labels

## Limitations

- **Regex-based, not a full Lean parser.** It matches top-level declarations by pattern. Nested or unusual formatting may be missed.
- **Reference detection is heuristic.** It scans declaration bodies for whole-word matches of known declaration names. This can miss indirect references and occasionally produce false positives.
- **Denomination tags and provenance defs are filtered out** from the default view (they are metadata, not logical content). Use `--defs-only` to see all defs.
- **Does not resolve Lean namespaces.** If two files declare the same name in different namespaces, the tool treats them as the same name.
- **Flow diagram layout is heuristic.** For very large files with many interconnections, the ASCII rendering may be wide. Connected components are grouped separately to improve readability.
