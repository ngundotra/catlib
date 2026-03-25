#!/usr/bin/env python3
"""Generate HTML explorer pages for Catlib Lean source files.

Usage:
    python3 tools/gen_explorer_pages.py

Reads Lean files from Catlib/Sacraments/ and Catlib/Foundations/,
parses declarations, builds dependency chains, and generates
HTML explorer pages at site/explorer/{Category}_{Module}.html.
"""

import os
import re
import html
from collections import OrderedDict

# ---------------------------------------------------------------------------
# Configuration
# ---------------------------------------------------------------------------

PROJECT_ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))

MODULES = [
    # (category, module_name)
    # NEW
    ("Sacraments", "Anointing"),
    ("Sacraments", "Confirmation"),
    ("Sacraments", "HolyOrders"),
    ("Sacraments", "Liturgy"),
    ("Sacraments", "MatterAndForm"),
    ("Sacraments", "TransubstantiationDepth"),
    # UPDATE
    ("Sacraments", "Baptism"),
    ("Sacraments", "Eucharist"),
    ("Sacraments", "Exorcism"),
    ("Sacraments", "PriestlyAbsolution"),
    ("Sacraments", "Reconciliation"),
    ("Sacraments", "SacramentalCausation"),
    ("Foundations", "Axioms"),
    ("Foundations", "Authority"),
    ("Foundations", "Basic"),
    ("Foundations", "HumanNature"),
    ("Foundations", "Love"),
    ("Foundations", "SinEffects"),
]

OUTPUT_DIR = os.path.join(PROJECT_ROOT, "site", "explorer")

# Declaration keywords we recognize at the start of a line (possibly after whitespace)
DECL_KEYWORDS = ["axiom", "theorem", "def", "opaque", "inductive", "structure", "instance", "abbrev"]

# ---------------------------------------------------------------------------
# Lean parser
# ---------------------------------------------------------------------------

def read_lean_file(category, module):
    """Read a Lean source file and return its contents."""
    path = os.path.join(PROJECT_ROOT, "Catlib", category, f"{module}.lean")
    if not os.path.exists(path):
        print(f"  WARNING: {path} not found, skipping")
        return None
    with open(path, "r", encoding="utf-8") as f:
        return f.read()


def extract_docstrings(source):
    """Extract /-- ... -/ docstrings and map them to line numbers.

    Returns a dict mapping the line number AFTER the docstring ends
    to the docstring text.
    """
    docstrings = {}
    # Match /-- ... -/ (possibly multiline)
    pattern = re.compile(r'/--\s*(.*?)\s*-/', re.DOTALL)
    for m in pattern.finditer(source):
        # Find the line number where the docstring ends
        end_pos = m.end()
        # Count newlines up to end_pos
        line_num = source[:end_pos].count('\n')
        # The declaration should be on the next non-blank line after the docstring
        docstrings[line_num] = m.group(1).strip()
    return docstrings


def parse_declarations(source):
    """Parse Lean declarations from source text.

    Returns a list of dicts with keys:
        kind, name, signature, body, docstring, line_num
    """
    lines = source.split('\n')
    docstrings = extract_docstrings(source)

    declarations = []
    i = 0
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()

        # Skip empty lines, comments, imports, open, set_option, namespace, end, section
        if not stripped or stripped.startswith('--') or stripped.startswith('import ') \
                or stripped.startswith('open ') or stripped.startswith('set_option') \
                or stripped.startswith('namespace ') or stripped.startswith('end ') \
                or stripped.startswith('section ') or stripped.startswith('/-'):
            i += 1
            continue

        # Check for module-level docstrings /-! ... -/
        if stripped.startswith('/-!'):
            # Skip until -/
            while i < len(lines) and '-/' not in lines[i]:
                i += 1
            i += 1
            continue

        # Check if line starts with a declaration keyword
        decl_match = None
        for kw in DECL_KEYWORDS:
            # Match keyword at start (possibly indented), followed by space or non-alpha
            pat = re.compile(rf'^(\s*){kw}\b')
            m = pat.match(line)
            if m:
                decl_match = kw
                break

        if not decl_match:
            i += 1
            continue

        kind = decl_match
        decl_start_line = i

        # Extract the name
        # For instance, the name may be omitted or be a pattern
        rest = stripped[len(kind):].strip()

        # Extract name: first identifier after keyword
        # Handle special cases: instance may have no explicit name
        name_match = re.match(r'([a-zA-Z_][a-zA-Z0-9_\.\']*)', rest)
        if name_match:
            name = name_match.group(1)
            # Skip names that are actually Lean keywords used as modifiers
            if name in ('noncomputable', 'private', 'protected', 'partial', 'unsafe'):
                # Look for the real name after
                rest2 = rest[name_match.end():].strip()
                # Check if the next word is actually a declaration keyword
                for kw2 in DECL_KEYWORDS:
                    if rest2.startswith(kw2 + ' ') or rest2.startswith(kw2 + '\n'):
                        kind = kw2
                        rest2 = rest2[len(kw2):].strip()
                        break
                name_match2 = re.match(r'([a-zA-Z_][a-zA-Z0-9_\.\']*)', rest2)
                if name_match2:
                    name = name_match2.group(1)
                else:
                    name = f"unnamed_{i}"
        else:
            name = f"unnamed_{i}"

        # For instance without a name, generate one
        if kind == 'instance' and name.startswith((':',  '[')):
            name = f"instance_{i}"

        # Collect the full signature + body
        sig_lines = [lines[i]]
        j = i + 1

        # Determine termination: we need to find where this declaration ends
        # Heuristic: collect lines until we hit another top-level declaration,
        # a blank line followed by a non-indented line, or end of file
        brace_depth = 0
        found_body_start = False

        while j < len(lines):
            l = lines[j]
            ls = l.strip()

            # Track braces for structure/inductive bodies
            brace_depth += l.count('{') - l.count('}')

            # Check if we've hit the body marker
            if not found_body_start:
                if ':=' in l or 'where' in ls or ls == 'by' or ls.endswith(' by') or ls.endswith(':= by'):
                    found_body_start = True

            # Check if this line starts a new top-level declaration
            if ls and not ls.startswith('--') and not ls.startswith('|') \
                    and not ls.startswith('/') and not ls.startswith('#'):
                is_new_decl = False
                for kw in DECL_KEYWORDS:
                    if re.match(rf'^{kw}\b', ls):
                        is_new_decl = True
                        break
                # Also check for noncomputable/private prefix
                for prefix in ('noncomputable ', 'private ', 'protected '):
                    if ls.startswith(prefix):
                        for kw in DECL_KEYWORDS:
                            if re.match(rf'^{kw}\b', ls[len(prefix):].strip()):
                                is_new_decl = True
                                break

                if is_new_decl and brace_depth <= 0:
                    break

            # Check for docstring start (next declaration's docstring)
            if ls.startswith('/--') or ls.startswith('/-!'):
                break

            sig_lines.append(l)
            j += 1

        full_text = '\n'.join(sig_lines).strip()

        # Extract signature (up to := or where or by)
        sig = extract_signature(full_text, kind)

        # Extract body (after := or where or by)
        body = extract_body(full_text, kind)

        # Find docstring for this declaration
        doc = find_docstring_for_line(docstrings, decl_start_line, lines)

        # Determine if this is a proposition (def returning Prop)
        actual_kind = kind
        if kind == 'def':
            if is_proposition(sig, full_text):
                actual_kind = 'proposition'

        declarations.append({
            'kind': actual_kind,
            'name': name,
            'signature': sig,
            'body': body,
            'full_text': full_text,
            'docstring': doc,
            'line_num': decl_start_line,
        })

        i = j

    return declarations


def extract_signature(full_text, kind):
    """Extract the type signature from a declaration's full text."""
    # For structures and inductives, signature is up to "where"
    if kind in ('structure', 'inductive'):
        m = re.search(r'\bwhere\b', full_text)
        if m:
            return full_text[:m.start()].strip() + ' where'
        return full_text.split('\n')[0].strip()

    # For theorems, axioms, etc.: up to := or by (at appropriate level)
    # First try :=
    # We want the signature part: everything before := or the proof
    lines = full_text.split('\n')
    sig_parts = []
    for line in lines:
        ls = line.strip()
        # Check for body start markers
        if ls == ':= by' or ls == ':=':
            break
        if ls.endswith(':= by'):
            sig_parts.append(line.rstrip()[:-len(':= by')].rstrip())
            break
        if ls.endswith(':='):
            sig_parts.append(line.rstrip()[:-len(':=')].rstrip())
            break
        if re.match(r'^\s*:=\s', ls) or ls == ':=' :
            break
        # For single-line defs like "def foo : Type := expr"
        m = re.search(r'\s:=\s', line)
        if m:
            sig_parts.append(line[:m.start()])
            break
        # "by" as proof start (on its own line or at end)
        if ls == 'by':
            break
        if ls.endswith(' by') and not ls.endswith('sorted by'):
            sig_parts.append(line.rstrip()[:-3].rstrip())
            break
        sig_parts.append(line)

    sig = '\n'.join(sig_parts).strip()
    if not sig:
        sig = lines[0].strip()
    return sig


def extract_body(full_text, kind):
    """Extract the body/proof text from a declaration."""
    # Find everything after := or where or by
    # Try := first
    m = re.search(r':=\s*', full_text)
    if m:
        return full_text[m.end():].strip()

    m = re.search(r'\bwhere\b', full_text)
    if m:
        return full_text[m.end():].strip()

    m = re.search(r'\bby\b', full_text)
    if m:
        return full_text[m.end():].strip()

    return ''


def find_docstring_for_line(docstrings, decl_line, lines):
    """Find the docstring that belongs to a declaration at the given line."""
    # The docstring ends on a line just before (or a few lines before) the declaration
    best_doc = None
    best_dist = float('inf')
    for doc_end_line, doc_text in docstrings.items():
        # The docstring should end within a few lines before the declaration
        dist = decl_line - doc_end_line
        if 0 <= dist <= 3 and dist < best_dist:
            # Check that intervening lines are blank or whitespace
            all_blank = True
            for k in range(doc_end_line + 1, decl_line):
                if k < len(lines) and lines[k].strip():
                    all_blank = False
                    break
            if all_blank:
                best_doc = doc_text
                best_dist = dist
    return best_doc


def is_proposition(sig, full_text):
    """Check if a def declaration returns Prop."""
    # Look for patterns where the return type is Prop
    # Remove parameter blocks and look at the final return type

    # Pattern 1: ": Prop" or "→ Prop" at the end of signature
    sig_clean = sig.strip()
    if re.search(r'→\s*Prop\s*$', sig_clean):
        return True
    if re.search(r':\s*Prop\s*$', sig_clean):
        return True

    # Pattern 2: the type ends with Prop after removing trailing whitespace/comments
    # Normalize: join lines, collapse whitespace
    sig_one = ' '.join(sig_clean.split())
    if sig_one.endswith('→ Prop') or sig_one.endswith(': Prop'):
        return True

    # Pattern 3: look for Prop as return type in multi-line
    if re.search(r'→\s*Prop\b', sig_one):
        # Make sure Prop is the final return type, not an intermediate one
        # Remove everything in parentheses/braces
        cleaned = re.sub(r'\([^)]*\)', '', sig_one)
        cleaned = re.sub(r'\{[^}]*\}', '', cleaned)
        cleaned = re.sub(r'\[[^\]]*\]', '', cleaned)
        cleaned = cleaned.strip()
        if cleaned.endswith('→ Prop') or cleaned.endswith(': Prop'):
            return True

    return False


# ---------------------------------------------------------------------------
# Dependency analysis
# ---------------------------------------------------------------------------

def build_dependencies(declarations):
    """Build dependency edges between declarations in the same file.

    For each declaration, scan its body for references to other declaration names.
    Returns (depends_on, used_by) dicts mapping name -> list of names.
    """
    names = set(d['name'] for d in declarations)
    depends_on = {d['name']: [] for d in declarations}
    used_by = {d['name']: [] for d in declarations}

    for decl in declarations:
        body = decl.get('body', '') or ''
        full = decl.get('full_text', '') or ''
        # Use body + signature for dependency detection
        # But exclude the declaration's own name from the search text initially
        search_text = body

        for other_name in names:
            if other_name == decl['name']:
                continue
            # Check if other_name appears as a word boundary in the body
            if re.search(r'\b' + re.escape(other_name) + r'\b', search_text):
                if other_name not in depends_on[decl['name']]:
                    depends_on[decl['name']].append(other_name)
                if decl['name'] not in used_by[other_name]:
                    used_by[other_name].append(decl['name'])

    return depends_on, used_by


# ---------------------------------------------------------------------------
# CCC section extraction
# ---------------------------------------------------------------------------

def extract_ccc_sections(declarations):
    """Extract unique CCC section numbers from docstrings."""
    sections = set()
    for decl in declarations:
        doc = decl.get('docstring', '') or ''
        # Match §NNNN patterns
        for m in re.finditer(r'§(\d+)', doc):
            sections.add(int(m.group(1)))
        # Also check the signature/full_text for CCC references
        full = decl.get('full_text', '') or ''
        for m in re.finditer(r'§(\d+)', full):
            sections.add(int(m.group(1)))
    return sorted(sections)


# ---------------------------------------------------------------------------
# HTML generation
# ---------------------------------------------------------------------------

CSS = """:root {
  --text: #2a1f14;
  --text-light: #5c4a3a;
  --text-muted: #8a7a6a;
  --bg: #f4ead5;
  --bg-parchment: #efe3c8;
  --bg-vellum: #e8d9b8;
  --accent: #7a2e0e;
  --accent-gold: #b8860b;
  --accent-gold-light: #d4a937;
  --border: #c4a872;
  --border-dark: #a08050;
  --code-bg: #1e1a15;
  --code-text: #e8d9b8;

  /* Node type colors */
  --axiom-bg: #f5e6d8;
  --axiom-border: #c4713a;
  --axiom-dot: #b8510e;
  --theorem-bg: #dde8f0;
  --theorem-border: #5a8aaa;
  --theorem-dot: #2a6a8a;
  --def-bg: #e4ead4;
  --def-border: #7a9a5a;
  --def-dot: #4a7a2a;
  --opaque-bg: #ebe0d0;
  --opaque-border: #a08050;
  --opaque-dot: #7a6030;
  --structure-bg: #e8daf0;
  --structure-border: #8a6aaa;
  --structure-dot: #6a4a8a;
  --inductive-bg: #e8daf0;
  --inductive-border: #8a6aaa;
  --inductive-dot: #6a4a8a;
  --proposition-bg: #f0e0e4;
  --proposition-border: #aa5a6a;
  --proposition-dot: #8a2a4a;
}

@media (prefers-color-scheme: dark) {
  :root {
    --text: #e0d5c0;
    --text-light: #b8a890;
    --text-muted: #8a7a6a;
    --bg: #1a1510;
    --bg-parchment: #221c14;
    --bg-vellum: #2a2218;
    --accent: #d4856a;
    --accent-gold: #d4a937;
    --accent-gold-light: #e8c050;
    --border: #4a3a28;
    --border-dark: #6a5a40;
    --code-bg: #0e0c08;
    --code-text: #e8d9b8;

    --axiom-bg: #2a1e14;
    --axiom-border: #8a4a20;
    --axiom-dot: #d4856a;
    --theorem-bg: #14202a;
    --theorem-border: #3a6a8a;
    --theorem-dot: #6aaad4;
    --def-bg: #1a2214;
    --def-border: #4a6a3a;
    --def-dot: #8aba6a;
    --opaque-bg: #221c14;
    --opaque-border: #6a5030;
    --opaque-dot: #b8a060;
    --structure-bg: #201a28;
    --structure-border: #6a4a8a;
    --structure-dot: #aa8ad4;
    --inductive-bg: #201a28;
    --inductive-border: #6a4a8a;
    --inductive-dot: #aa8ad4;
    --proposition-bg: #2a1420;
    --proposition-border: #8a3a5a;
    --proposition-dot: #d46a8a;
  }
}

* { margin: 0; padding: 0; box-sizing: border-box; }

html {
  font-size: 17px;
  -webkit-font-smoothing: antialiased;
  scroll-behavior: smooth;
}

body {
  font-family: 'Cormorant Garamond', Georgia, serif;
  color: var(--text);
  background: var(--bg);
  line-height: 1.7;
  min-height: 100vh;
  -webkit-text-size-adjust: 100%;
}

.container {
  max-width: 720px;
  margin: 0 auto;
  padding: 1.5rem 1rem 3rem;
}

a { color: var(--accent); text-decoration: none; }
a:hover { text-decoration: underline; }

h1 {
  font-family: Cinzel, Georgia, serif;
  font-size: 1.6rem;
  font-weight: 400;
  text-align: center;
  letter-spacing: 0.04em;
  margin-bottom: 0.3rem;
  color: var(--text);
}

.subtitle {
  text-align: center;
  font-size: 0.95rem;
  color: var(--text-light);
  font-style: italic;
  margin-bottom: 1.5rem;
}

.serve-note {
  background: var(--code-bg);
  color: var(--code-text);
  padding: 0.8rem 1rem;
  border-radius: 4px;
  font-family: monospace;
  font-size: 0.75rem;
  margin-bottom: 1.5rem;
  overflow-x: auto;
  line-height: 1.6;
}

/* ── Search ── */
.search-box {
  width: 100%;
  padding: 0.8rem 1rem;
  font-family: 'Cormorant Garamond', Georgia, serif;
  font-size: 1.05rem;
  border: 1px solid var(--border);
  border-radius: 4px;
  background: var(--bg-parchment);
  color: var(--text);
  margin-bottom: 1.5rem;
  outline: none;
}

.search-box:focus {
  border-color: var(--accent-gold);
  box-shadow: 0 0 0 2px rgba(184, 134, 11, 0.2);
}

.search-box::placeholder {
  color: var(--text-muted);
  font-style: italic;
}

/* ── Category sections ── */
.category-header {
  font-family: Cinzel, Georgia, serif;
  font-size: 1.1rem;
  font-weight: 400;
  color: var(--accent);
  letter-spacing: 0.06em;
  text-transform: uppercase;
  font-variant: small-caps;
  margin: 1.8rem 0 0.8rem;
  padding-bottom: 0.4rem;
  border-bottom: 1px solid var(--border);
}

/* ── File cards ── */
.file-card {
  display: block;
  padding: 1rem 1.1rem;
  margin-bottom: 0.5rem;
  background: var(--bg-parchment);
  border: 1px solid var(--border);
  border-radius: 4px;
  text-decoration: none;
  color: var(--text);
  transition: background 0.15s, border-color 0.15s;
  -webkit-tap-highlight-color: transparent;
}

.file-card:hover, .file-card:active {
  background: var(--bg-vellum);
  border-color: var(--accent-gold);
  text-decoration: none;
}

.file-card-name {
  font-family: Cinzel, Georgia, serif;
  font-size: 1rem;
  font-weight: 600;
  letter-spacing: 0.02em;
  margin-bottom: 0.3rem;
}

.file-card-meta {
  display: flex;
  flex-wrap: wrap;
  gap: 0.6rem;
  font-size: 0.82rem;
  color: var(--text-light);
}

.file-card-meta .tag {
  display: inline-block;
  padding: 0.15rem 0.5rem;
  border-radius: 3px;
  font-size: 0.75rem;
  font-family: Cinzel, Georgia, serif;
  letter-spacing: 0.03em;
}

.tag-axiom { background: var(--axiom-bg); color: var(--axiom-dot); border: 1px solid var(--axiom-border); }
.tag-theorem { background: var(--theorem-bg); color: var(--theorem-dot); border: 1px solid var(--theorem-border); }
.tag-def { background: var(--def-bg); color: var(--def-dot); border: 1px solid var(--def-border); }
.tag-proposition { background: var(--proposition-bg); color: var(--proposition-dot); border: 1px solid var(--proposition-border); }

.file-card-ccc {
  font-size: 0.78rem;
  color: var(--text-muted);
  margin-top: 0.3rem;
}

/* ── Summary stats ── */
.stats-bar {
  display: flex;
  justify-content: center;
  gap: 1.5rem;
  flex-wrap: wrap;
  margin-bottom: 1.5rem;
  font-size: 0.9rem;
  color: var(--text-light);
  font-style: italic;
}

.stats-bar span { white-space: nowrap; }

/* ── Node cards (per-file page) ── */
.node-card {
  margin-bottom: 0.4rem;
  border: 1px solid var(--border);
  border-radius: 4px;
  overflow: hidden;
  border-left: 4px solid var(--border);
}

.node-card.kind-axiom { border-left-color: var(--axiom-dot); }
.node-card.kind-theorem { border-left-color: var(--theorem-dot); }
.node-card.kind-def { border-left-color: var(--def-dot); }
.node-card.kind-opaque { border-left-color: var(--opaque-dot); }
.node-card.kind-structure { border-left-color: var(--structure-dot); }
.node-card.kind-inductive { border-left-color: var(--inductive-dot); }
.node-card.kind-proposition { border-left-color: var(--proposition-dot); }
.node-card.kind-instance { border-left-color: var(--def-dot); }
.node-card.kind-abbrev { border-left-color: var(--def-dot); }

.node-header {
  display: flex;
  align-items: center;
  gap: 0.6rem;
  padding: 0.8rem 1rem;
  cursor: pointer;
  -webkit-tap-highlight-color: transparent;
  user-select: none;
  background: var(--bg-parchment);
  transition: background 0.15s;
}

.node-header:active {
  background: var(--bg-vellum);
}

.node-kind-badge {
  flex-shrink: 0;
  font-family: monospace;
  font-size: 0.65rem;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  padding: 0.15rem 0.4rem;
  border-radius: 3px;
  font-weight: bold;
}

.kind-axiom .node-kind-badge { background: var(--axiom-bg); color: var(--axiom-dot); }
.kind-theorem .node-kind-badge { background: var(--theorem-bg); color: var(--theorem-dot); }
.kind-def .node-kind-badge { background: var(--def-bg); color: var(--def-dot); }
.kind-opaque .node-kind-badge { background: var(--opaque-bg); color: var(--opaque-dot); }
.kind-structure .node-kind-badge { background: var(--structure-bg); color: var(--structure-dot); }
.kind-inductive .node-kind-badge { background: var(--inductive-bg); color: var(--inductive-dot); }
.kind-proposition .node-kind-badge { background: var(--proposition-bg); color: var(--proposition-dot); }
.kind-instance .node-kind-badge { background: var(--def-bg); color: var(--def-dot); }
.kind-abbrev .node-kind-badge { background: var(--def-bg); color: var(--def-dot); }

.node-name {
  flex: 1;
  font-family: 'JetBrains Mono', 'Fira Code', monospace;
  font-size: 0.82rem;
  word-break: break-all;
}

.node-chevron {
  flex-shrink: 0;
  font-size: 0.8rem;
  color: var(--text-muted);
  transition: transform 0.2s;
}

.node-card.open .node-chevron {
  transform: rotate(90deg);
}

.node-details {
  display: none;
  padding: 0.6rem 1rem 0.8rem;
  font-size: 0.9rem;
  border-top: 1px solid var(--border);
  background: var(--bg);
}

.node-card.open .node-details {
  display: block;
}

.node-prop {
  margin-bottom: 0.5rem;
}

.node-prop pre {
  background: var(--code-bg);
  color: var(--code-text);
  padding: 0.6rem 0.8rem;
  border-radius: 4px;
  font-size: 0.75rem;
  line-height: 1.5;
  overflow-x: auto;
  -webkit-overflow-scrolling: touch;
  white-space: pre;
  margin: 0;
}

.node-prop code {
  font-family: 'JetBrains Mono', 'Fira Code', 'SF Mono', Menlo, monospace;
  font-size: 0.75rem;
}

.node-desc {
  margin-bottom: 0.5rem;
  font-style: italic;
  color: var(--text-light);
  line-height: 1.5;
}

.node-dep-section {
  margin-top: 0.4rem;
}

.node-dep-label {
  font-family: Cinzel, Georgia, serif;
  font-size: 0.72rem;
  text-transform: uppercase;
  letter-spacing: 0.06em;
  color: var(--text-muted);
  margin-bottom: 0.2rem;
}

.node-dep-list {
  display: flex;
  flex-wrap: wrap;
  gap: 0.3rem;
}

.dep-chip {
  display: inline-block;
  font-family: monospace;
  font-size: 0.72rem;
  padding: 0.15rem 0.5rem;
  border-radius: 3px;
  background: var(--bg-vellum);
  border: 1px solid var(--border);
  color: var(--text-light);
  cursor: pointer;
  -webkit-tap-highlight-color: transparent;
}

.dep-chip:active {
  background: var(--accent-gold);
  color: var(--code-bg);
}

.node-scope {
  margin-top: 0.4rem;
  font-size: 0.78rem;
  color: var(--text-muted);
}

/* ── Flow diagram header ── */
.flow-summary {
  display: flex;
  justify-content: center;
  gap: 0.3rem;
  margin-bottom: 1.2rem;
  flex-wrap: wrap;
  align-items: center;
  font-family: Cinzel, Georgia, serif;
  font-size: 0.85rem;
  color: var(--text-light);
}

.flow-count {
  display: inline-block;
  padding: 0.3rem 0.7rem;
  border-radius: 4px;
  font-weight: 600;
}

.flow-arrow { color: var(--accent-gold); padding: 0 0.2rem; }

.flow-count.axioms { background: var(--axiom-bg); color: var(--axiom-dot); }
.flow-count.theorems { background: var(--theorem-bg); color: var(--theorem-dot); }
.flow-count.derived { background: var(--def-bg); color: var(--def-dot); }

/* ── Legend ── */
.legend {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem 1rem;
  justify-content: center;
  margin-bottom: 1.2rem;
  font-size: 0.78rem;
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 0.3rem;
  color: var(--text-light);
}

.legend-dot {
  width: 10px;
  height: 10px;
  border-radius: 2px;
  flex-shrink: 0;
}

.legend-dot.axiom { background: var(--axiom-dot); }
.legend-dot.theorem { background: var(--theorem-dot); }
.legend-dot.def { background: var(--def-dot); }
.legend-dot.opaque { background: var(--opaque-dot); }
.legend-dot.structure { background: var(--structure-dot); }
.legend-dot.inductive { background: var(--inductive-dot); }
.legend-dot.proposition { background: var(--proposition-dot); }
.legend-dot.instance { background: var(--def-dot); }
.legend-dot.abbrev { background: var(--def-dot); }

/* ── Filter buttons ── */
.filter-bar {
  display: flex;
  flex-wrap: wrap;
  gap: 0.3rem;
  margin-bottom: 1rem;
  justify-content: center;
}

.filter-btn {
  font-family: monospace;
  font-size: 0.7rem;
  text-transform: uppercase;
  letter-spacing: 0.04em;
  padding: 0.3rem 0.7rem;
  border-radius: 3px;
  border: 1px solid var(--border);
  background: var(--bg);
  color: var(--text-light);
  cursor: pointer;
  -webkit-tap-highlight-color: transparent;
}

.filter-btn.active {
  background: var(--accent);
  color: var(--bg);
  border-color: var(--accent);
}

/* ── Back link ── */
.back-link {
  display: inline-block;
  margin-bottom: 1rem;
  font-family: Cinzel, Georgia, serif;
  font-size: 0.85rem;
  letter-spacing: 0.04em;
}

/* ── Footer ── */
.footer {
  text-align: center;
  padding-top: 2rem;
  font-size: 0.8rem;
  color: var(--text-muted);
  font-style: italic;
}

/* ── Responsive ── */
@media (max-width: 500px) {
  html { font-size: 16px; }
  .container { padding: 1rem 0.75rem 2rem; }
  h1 { font-size: 1.35rem; }
  .node-name { font-size: 0.75rem; }
}"""

JS = """function toggleNode(header) {
  header.parentElement.classList.toggle('open');
}

// Tap a dep chip to scroll to that node
document.addEventListener('click', function(e) {
  if (e.target.classList.contains('dep-chip')) {
    var target = e.target.getAttribute('data-target');
    var cards = document.querySelectorAll('.node-card');
    for (var i = 0; i < cards.length; i++) {
      if (cards[i].getAttribute('data-name') === target) {
        cards[i].classList.add('open');
        cards[i].scrollIntoView({ behavior: 'smooth', block: 'center' });
        cards[i].style.boxShadow = '0 0 0 3px var(--accent-gold)';
        setTimeout(function(c) { c.style.boxShadow = ''; }, 1500, cards[i]);
        break;
      }
    }
  }
});

// Search
document.getElementById('nodeSearch').addEventListener('input', function() {
  var q = this.value.toLowerCase();
  var cards = document.querySelectorAll('.node-card');
  for (var i = 0; i < cards.length; i++) {
    var name = cards[i].getAttribute('data-name').toLowerCase();
    var desc = (cards[i].querySelector('.node-desc') || {}).textContent || '';
    var show = !q || name.indexOf(q) !== -1 || desc.toLowerCase().indexOf(q) !== -1;
    cards[i].style.display = show ? '' : 'none';
  }
});

// Filter buttons
document.querySelectorAll('.filter-btn').forEach(function(btn) {
  btn.addEventListener('click', function() {
    document.querySelectorAll('.filter-btn').forEach(function(b) { b.classList.remove('active'); });
    this.classList.add('active');
    var filter = this.getAttribute('data-filter');
    var cards = document.querySelectorAll('.node-card');
    for (var i = 0; i < cards.length; i++) {
      if (filter === 'all' || cards[i].getAttribute('data-kind') === filter) {
        cards[i].style.display = '';
      } else {
        cards[i].style.display = 'none';
      }
    }
  });
});"""


def escape(text):
    """HTML-escape text."""
    return html.escape(text, quote=True)


def get_first_doc_line(docstring):
    """Extract the first meaningful line/sentence from a docstring."""
    if not docstring:
        return ''
    # Remove markdown-style headers
    lines = docstring.split('\n')
    for line in lines:
        line = line.strip()
        if not line:
            continue
        if line.startswith('#'):
            continue
        if line.startswith('*') and line.endswith('*'):
            continue
        # Take first sentence or first line
        # Remove leading markers like AXIOM, NOTE, etc.
        line = re.sub(r'^\*\*[A-Z_]+\**:?\s*', '', line)
        line = re.sub(r'^AXIOM\s*\([^)]*\):\s*', '', line)
        # Truncate at first period if long
        if '. ' in line and len(line) > 120:
            line = line[:line.index('. ') + 1]
        return line
    return ''


def generate_node_card(decl, depends_on, used_by):
    """Generate HTML for a single node card."""
    kind = decl['kind']
    name = decl['name']
    sig = decl['signature']
    doc = get_first_doc_line(decl.get('docstring', ''))

    deps = depends_on.get(name, [])
    usedby = used_by.get(name, [])

    parts = []
    parts.append(f'<div class="node-card kind-{kind}" data-kind="{kind}" data-name="{escape(name)}">')
    parts.append(f'  <div class="node-header" onclick="toggleNode(this)">')
    parts.append(f'    <span class="node-kind-badge">{kind}</span>')
    parts.append(f'    <span class="node-name">{escape(name)}</span>')
    parts.append(f'    <span class="node-chevron">&#9654;</span>')
    parts.append(f'  </div>')
    parts.append(f'  <div class="node-details">')
    parts.append(f'    <div class="node-prop"><pre><code>{escape(sig)}</code></pre></div>')

    if doc:
        parts.append(f'<div class="node-desc">{escape(doc)}</div>')

    if deps:
        parts.append('<div class="node-dep-section"><div class="node-dep-label">Depends on</div><div class="node-dep-list">')
        for d in deps:
            parts.append(f'<span class="dep-chip" data-target="{escape(d)}">{escape(d)}</span>')
        parts.append('</div></div>')

    if usedby:
        parts.append('<div class="node-dep-section"><div class="node-dep-label">Used by</div><div class="node-dep-list">')
        for u in usedby:
            parts.append(f'<span class="dep-chip" data-target="{escape(u)}">{escape(u)}</span>')
        parts.append('</div></div>')

    parts.append(f'  </div>')
    parts.append(f'</div>')

    return '\n'.join(parts)


def generate_page(category, module, declarations, depends_on, used_by, ccc_sections):
    """Generate a full HTML page for a module."""
    n = len(declarations)

    # Count kinds
    kind_counts = OrderedDict()
    for d in declarations:
        k = d['kind']
        kind_counts[k] = kind_counts.get(k, 0) + 1

    # Sort kind_counts by a canonical order
    kind_order = ['axiom', 'theorem', 'proposition', 'def', 'opaque', 'structure', 'inductive', 'instance', 'abbrev']
    sorted_kinds = []
    for k in kind_order:
        if k in kind_counts:
            sorted_kinds.append(k)

    # Build legend
    legend_items = []
    for k in sorted_kinds:
        legend_items.append(f'<span class="legend-item"><span class="legend-dot {k}"></span>{k}</span>')
    legend_html = '<div class="legend">' + ''.join(legend_items) + '</div>'

    # Build filter bar
    filter_items = ['<button class="filter-btn active" data-filter="all">All</button>']
    for k in sorted_kinds:
        filter_items.append(f'<button class="filter-btn" data-filter="{k}">{k} ({kind_counts[k]})</button>')
    filter_html = '<div class="filter-bar">' + ''.join(filter_items) + '</div>'

    # Build CCC section refs
    ccc_html = ''
    if ccc_sections:
        refs = ', '.join(f'&sect;{s}' for s in ccc_sections)
        ccc_html = f'\n  <div style="text-align:center;font-size:0.82rem;color:var(--text-muted);margin-bottom:1rem;font-style:italic;">CCC {refs}</div>\n'

    # Build node cards
    node_cards = []
    for d in declarations:
        node_cards.append(generate_node_card(d, depends_on, used_by))
    nodes_html = '\n'.join(node_cards)

    page = f"""<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">
  <title>{escape(module)} — Catlib Explorer</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600&family=Cormorant+Garamond:ital,wght@0,400;0,500;1,400&display=swap" rel="stylesheet">
  <style>
{CSS}
</style>
</head>
<body>
<div class="container">
  <a href="index.html" class="back-link">&larr; All files</a>
  <h1>{escape(module)}</h1>
  <div class="subtitle">{escape(category)} &middot; {n} declarations</div>
  {ccc_html}
  {legend_html}

  {filter_html}

  <input type="text" class="search-box" placeholder="Search declarations..." id="nodeSearch">

  <div id="nodeList">
    {nodes_html}
  </div>

  <div class="footer">
    Generated from <code>Catlib/{escape(category)}/{escape(module)}.lean</code>
  </div>
</div>

<script>
{JS}
</script>
</body>
</html>"""

    return page


# ---------------------------------------------------------------------------
# Main
# ---------------------------------------------------------------------------

def main():
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    generated = 0
    skipped = 0

    for category, module in MODULES:
        print(f"Processing {category}/{module}...")

        source = read_lean_file(category, module)
        if source is None:
            skipped += 1
            continue

        declarations = parse_declarations(source)
        if not declarations:
            print(f"  WARNING: No declarations found in {category}/{module}")
            skipped += 1
            continue

        depends_on, used_by = build_dependencies(declarations)
        ccc_sections = extract_ccc_sections(declarations)

        page_html = generate_page(category, module, declarations, depends_on, used_by, ccc_sections)

        out_path = os.path.join(OUTPUT_DIR, f"{category}_{module}.html")
        with open(out_path, 'w', encoding='utf-8') as f:
            f.write(page_html)

        # Summary
        kind_counts = {}
        for d in declarations:
            k = d['kind']
            kind_counts[k] = kind_counts.get(k, 0) + 1
        kinds_str = ', '.join(f"{v} {k}" for k, v in sorted(kind_counts.items()))
        print(f"  -> {out_path}")
        print(f"     {len(declarations)} declarations: {kinds_str}")
        if ccc_sections:
            print(f"     CCC sections: {', '.join(str(s) for s in ccc_sections[:10])}{'...' if len(ccc_sections) > 10 else ''}")

        generated += 1

    print(f"\nDone: {generated} pages generated, {skipped} skipped.")


if __name__ == '__main__':
    main()
