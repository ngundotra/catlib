# theorem-tree

Dependency analysis and visualization for Lean 4 formalizations.

Two modes of operation:

| Mode | Flags | Speed | Accuracy | Requirements |
|------|-------|-------|----------|--------------|
| **Regex** | `--flow`, `--trace`, `--connections`, etc. | Fast | Approximate | Python 3 only |
| **Kernel** | `--true-islands`, `--kernel`, `--compare`, `--json`, `--props` | Slow | Exact | Python 3 + `lake build` |

Use regex mode for fast exploration and visualization. Use kernel mode when you need the definitive answer about what depends on what (or for `--props` proposition-centric analysis).

## Requirements

- Python 3 (no external dependencies)
- For kernel mode: working `lake` installation + successful `lake build`

## Usage

Run from the project root:

### Regex mode — fast, no build needed

```bash
# Tree of a single file (default: --brief mode)
./tools/theorem-tree Catlib/Foundations/Axioms.lean

# Tree of a directory
./tools/theorem-tree Catlib/Creed/

# Show cross-file connections only
./tools/theorem-tree --connections Catlib/

# Filter by declaration kind
./tools/theorem-tree --axioms-only Catlib/Foundations/
./tools/theorem-tree --theorems-only Catlib/MoralTheology/

# Brief mode (default) vs verbose (full docstrings)
./tools/theorem-tree --brief Catlib/Foundations/Axioms.lean
./tools/theorem-tree --verbose Catlib/Creed/DivineModes.lean

# Dependency flow diagram — Sankey-style left-to-right
./tools/theorem-tree --flow Catlib/MoralTheology/TheologyOfBody.lean

# Trace all transitive dependencies of a declaration
./tools/theorem-tree --trace hope_for_salvation_of_suicide Catlib/

# Show definitions and their connections
./tools/theorem-tree --defs Catlib/Creed/DivineModes.lean
```

### Kernel mode — slow, exact (requires `lake build`)

```bash
# Kernel-verified unused axioms (true islands)
./tools/theorem-tree --true-islands Catlib/

# Kernel-verified deps for a specific theorem
./tools/theorem-tree --kernel hope_for_salvation_of_suicide Catlib/

# Compare regex vs kernel dependency detection
./tools/theorem-tree --compare Catlib/

# JSON output for programmatic consumption
./tools/theorem-tree --json Catlib/

# Proposition-centric analysis: what has been proven?
./tools/theorem-tree --props Catlib/
```

## Options

### Regex mode (fast)

| Flag | Description |
|------|-------------|
| `--brief` | One-line descriptions with source/scope metadata (default) |
| `--verbose` | Full multi-line docstrings for each declaration |
| `--flow` | Sankey-style left-to-right dependency flow diagram |
| `--connections` | Show only cross-file connections |
| `--axioms-only` | Filter to show only `axiom` declarations |
| `--theorems-only` | Filter to show only `theorem` declarations |
| `--defs-only` | Filter to show only `def` declarations |
| `--trace NAME` | Trace all transitive dependencies of a declaration as a tree |
| `--defs` | Show definitions and which declarations use them |

### Kernel mode (slow, exact)

| Flag | Description |
|------|-------------|
| `--true-islands` | Kernel-verified unused `axiom` declarations (excludes `opaque` defs) |
| `--kernel NAME` | Show kernel-verified dependencies for a theorem (partial match) |
| `--compare` | Compare regex-based vs kernel-based dependency detection |
| `--json` | Output full kernel dependency report as JSON |
| `--props` | Proposition-centric analysis (what has been proven) |

## How it works

### Regex mode

Scans `.lean` source files with regex to extract declarations and build a dependency graph:

1. Identifies declarations by kind (axiom/theorem/def/structure/inductive/opaque)
2. Parses `/-- ... -/` docstrings, extracting descriptions and metadata
3. Scans declaration bodies for references to other known declarations
4. Tags cross-file references with the source file

### Kernel mode

Uses Lean's type checker directly for ground-truth dependencies:

1. Scans `.lean` files for `theorem`, `axiom`, and `opaque` declarations (namespace-aware)
2. Generates a temp Lean file with `#print axioms` for each theorem
3. Runs it via `lake env lean` (sets up LEAN_PATH correctly)
4. Parses kernel output to extract true transitive dependencies
5. Filters out Lean builtins (`propext`, `Classical.choice`, etc.)

This catches tactic-generated references, namespace-resolved names, and indirect dependencies that regex misses.

## Limitations

- **Regex mode is heuristic.** It matches top-level declarations by pattern and scans bodies for name mentions. It can miss indirect references and occasionally produce false positives.
- **Kernel mode requires a build.** `lake build` must pass before `--true-islands`, `--kernel`, `--compare`, or `--json` can run.
- **Does not resolve Lean namespaces in regex mode.** If two files declare the same name in different namespaces, regex mode treats them as the same name. Kernel mode handles this correctly.
- **Flow diagram layout is heuristic.** For very large files, the ASCII rendering may be wide.
