# theorem-tree

Generate tree-style breakdowns of Lean 4 theorems, axioms, and their connections.

## What it does

Parses Lean 4 `.lean` files and produces a tree visualization showing:

- **Declarations**: axiom, theorem, def, structure, inductive, opaque
- **Descriptions**: extracted from `/-- ... -/` docstring blocks
- **Dependencies**: what each declaration references (other axioms, theorems, defs)
- **Cross-file connections**: when a theorem in file A uses an axiom from file B

## Requirements

- Python 3 (no external dependencies)

## Usage

Run from the project root (`/home/ngundotra/Documents/catlib/`):

```bash
# Tree of a single file
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
```

## Example output

```
Theorem Tree: Catlib/Foundations/Axioms.lean
============================================================

└── Catlib/Foundations/
    └── Axioms.lean
        ├── [axiom] p1_hylomorphism -- HYLOMORPHISM: Every material substance is a composite of form and matter
        │   └── <- uses: Composite
        ├── [axiom] s1_god_is_love -- GOD_IS_LOVE: God's very nature is love, and genuine love requires...
        │   ├── <- uses: godIsLove
        │   └── <- uses: loveRequiresFreedom
        ├── [axiom] t3_sacramental_efficacy -- SACRAMENTAL_EFFICACY: Sacraments are effective signs...
        │   ├── <- uses: Sacrament
        │   ├── <- uses: confers
        │   └── <- uses: signifies
        ...

Summary: 68 declarations (17 axioms, 18 defs, 32 opaques, 1 structure)
```

## Options

| Flag | Description |
|------|-------------|
| `--connections` | Show only cross-file connections (which declarations reference declarations in other files) |
| `--axioms-only` | Filter to show only `axiom` declarations |
| `--theorems-only` | Filter to show only `theorem` declarations |
| `--defs-only` | Filter to show only `def` declarations |
| `-h`, `--help` | Show help message |

## How it works

The tool uses regex-based parsing to extract declarations from Lean 4 source files. For each declaration it:

1. Identifies the kind (axiom/theorem/def/structure/inductive/opaque)
2. Extracts the name
3. Pulls the first line of any preceding `/-- ... -/` docstring as a description
4. Scans the declaration body for references to other known declarations
5. Tags cross-file references with the source file

## Limitations

- **Regex-based, not a full Lean parser.** It matches top-level declarations by pattern. Nested or unusual formatting may be missed.
- **Reference detection is heuristic.** It scans declaration bodies for whole-word matches of known declaration names. This can miss indirect references and occasionally produce false positives.
- **Denomination tags and provenance defs are filtered out** from the default view (they are metadata, not logical content). Use `--defs-only` to see all defs.
- **Does not resolve Lean namespaces.** If two files declare the same name in different namespaces, the tool treats them as the same name.
