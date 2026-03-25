#!/usr/bin/env python3
"""Generate explorer HTML pages from Lean source files for catlib."""

import re
import sys
import os
from pathlib import Path
from collections import defaultdict

SITE_DIR = Path(__file__).parent.parent / "site" / "explorer"
CATLIB_DIR = Path(__file__).parent.parent / "Catlib"


def parse_lean_file(filepath):
    """Parse a Lean file and extract declarations with their types, signatures, and docstrings."""
    with open(filepath) as f:
        content = f.read()
    lines = content.split('\n')

    declarations = []
    i = 0
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()

        # Collect docstring if present
        docstring = ""
        if stripped.startswith('/--') or stripped.startswith('/-!'):
            doc_start = i
            doc_lines = []
            # Find the end of the docstring
            in_doc = True
            while i < len(lines) and in_doc:
                doc_lines.append(lines[i])
                if '-/' in lines[i] and i > doc_start or (i == doc_start and '-/' in lines[i][3:]):
                    in_doc = False
                i += 1
            docstring = '\n'.join(doc_lines)
            # Extract just the first sentence/line of actual doc content
            doc_text = docstring
            # Remove /-- and -/ markers
            doc_text = re.sub(r'^/--\s*', '', doc_text)
            doc_text = re.sub(r'^/-!\s*', '', doc_text)
            doc_text = re.sub(r'\s*-/$', '', doc_text)
            # Get first meaningful line
            for dl in doc_text.split('\n'):
                dl = dl.strip()
                if dl and not dl.startswith('#') and not dl.startswith('##'):
                    docstring = dl[:120]
                    break
            continue

        # Check for declaration keywords
        decl_match = re.match(
            r'^(axiom|theorem|def|opaque|structure|inductive|instance|abbrev|class)\s+(\S+)',
            stripped
        )
        if decl_match:
            kind = decl_match.group(1)
            name = decl_match.group(2)

            # Remove namespace qualifiers for display
            short_name = name.split('.')[-1] if '.' in name and kind not in ('def',) else name

            # Collect the full signature (until := or where or next declaration or blank line)
            sig_lines = [lines[i]]
            j = i + 1
            # For multiline signatures, collect continuation lines
            while j < len(lines):
                next_line = lines[j].strip()
                # Stop conditions
                if next_line == '' and kind in ('axiom', 'opaque'):
                    break
                if next_line.startswith(':=') or next_line == ':= by':
                    sig_lines.append(lines[j])
                    break
                if re.match(r'^(axiom|theorem|def|opaque|structure|inductive|instance|abbrev|class|/-|/--)\s', next_line):
                    break
                if next_line == '':
                    break
                sig_lines.append(lines[j])
                j += 1

            signature = '\n'.join(sig_lines).strip()
            # Clean up signature - remove proof body
            signature = re.sub(r'\s*:=\s*by\s*$', '', signature)
            signature = re.sub(r'\s*:=\s*$', '', signature)
            # For match expressions in defs, include a few lines of the body
            if kind == 'def' and j + 1 < len(lines):
                peek = lines[j].strip() if j < len(lines) else ''
                if peek.startswith(':='):
                    # Check if next lines are match arms
                    k = j + 1
                    body_lines = []
                    while k < len(lines) and len(body_lines) < 6:
                        bl = lines[k].strip()
                        if bl == '' or re.match(r'^(axiom|theorem|def|opaque|structure|inductive|instance|abbrev|class|/--|/-!)\s', bl):
                            break
                        if bl.startswith('|') or bl.startswith('⟨') or bl.startswith('{'):
                            body_lines.append(lines[k])
                        elif bl.startswith('fun ') or bl.startswith('match '):
                            body_lines.append(lines[k])
                        else:
                            break
                        k += 1
                    if body_lines:
                        signature = signature + '\n' + '\n'.join(body_lines)

            # For inductive/structure, include constructors
            if kind in ('inductive', 'structure'):
                signature = f"{kind} {name} where"
                # Don't include constructor details in the signature

            # Determine if this is a proposition (def returning Prop)
            is_prop = False
            if kind == 'def':
                # Check if the type annotation includes ": Prop" or "→ Prop"
                full_sig = '\n'.join(sig_lines)
                if re.search(r':\s*Prop\b', full_sig) or re.search(r'→\s*Prop\b', full_sig):
                    is_prop = True
                # Also check body for " : Prop :="
                if j < len(lines) and 'Prop' in lines[j]:
                    is_prop = True

            actual_kind = kind
            if is_prop:
                actual_kind = 'proposition'

            declarations.append({
                'kind': actual_kind,
                'name': name,
                'signature': signature,
                'docstring': docstring,
            })
            docstring = ""  # Reset after use

        i += 1

    return declarations


def extract_ccc_refs(filepath):
    """Extract CCC section references from a Lean file."""
    with open(filepath) as f:
        content = f.read()
    refs = set()
    for m in re.finditer(r'§(\d+)', content):
        refs.add(int(m.group(1)))
    return sorted(refs)


def compute_dependencies(declarations, filepath):
    """Compute basic dependencies between declarations in the same file."""
    with open(filepath) as f:
        content = f.read()

    names = {d['name'] for d in declarations}
    deps = defaultdict(set)  # name -> set of names it depends on
    used_by = defaultdict(set)  # name -> set of names that use it

    # For each declaration, find which other declarations from this file it references
    lines = content.split('\n')
    i = 0
    current_decl = None
    decl_starts = {}

    # First pass: find where each declaration starts
    for idx, line in enumerate(lines):
        stripped = line.strip()
        m = re.match(r'^(axiom|theorem|def|opaque|structure|inductive|instance|abbrev|class)\s+(\S+)', stripped)
        if m:
            decl_starts[m.group(2)] = idx

    # Second pass: for each declaration, scan its body for references to other declarations
    sorted_decls = sorted(decl_starts.items(), key=lambda x: x[1])
    for idx, (decl_name, start_line) in enumerate(sorted_decls):
        # Find the end of this declaration (start of next one or end of file)
        if idx + 1 < len(sorted_decls):
            end_line = sorted_decls[idx + 1][1]
        else:
            end_line = len(lines)

        body = '\n'.join(lines[start_line:end_line])
        for other_name in names:
            if other_name == decl_name:
                continue
            # Check if other_name appears in the body (as a word boundary)
            # Use simple substring matching with word boundaries
            pattern = r'\b' + re.escape(other_name) + r'\b'
            if re.search(pattern, body):
                deps[decl_name].add(other_name)
                used_by[other_name].add(decl_name)

    return deps, used_by


def html_escape(s):
    """Escape HTML special characters."""
    return s.replace('&', '&amp;').replace('<', '&lt;').replace('>', '&gt;').replace('"', '&quot;')


def generate_node_card(decl, deps, used_by):
    """Generate a single node card HTML."""
    kind = decl['kind']
    name = decl['name']
    sig = html_escape(decl['signature'])
    desc = html_escape(decl['docstring'])

    dep_list = sorted(deps.get(name, set()))
    use_list = sorted(used_by.get(name, set()))

    html = f'''<div class="node-card kind-{kind}" data-kind="{kind}" data-name="{name}">
  <div class="node-header" onclick="toggleNode(this)">
    <span class="node-kind-badge">{kind}</span>
    <span class="node-name">{name}</span>
    <span class="node-chevron">&#9654;</span>
  </div>
  <div class="node-details">
    <div class="node-prop"><pre><code>{sig}</code></pre></div>
'''
    if desc:
        html += f'<div class="node-desc">{desc}</div>\n'

    if dep_list:
        chips = ''.join(f'<span class="dep-chip" data-target="{d}">{d}</span>' for d in dep_list)
        html += f'<div class="node-dep-section"><div class="node-dep-label">Depends on</div><div class="node-dep-list">{chips}</div></div>\n'

    if use_list:
        chips = ''.join(f'<span class="dep-chip" data-target="{u}">{u}</span>' for u in use_list)
        html += f'<div class="node-dep-section"><div class="node-dep-label">Used by</div><div class="node-dep-list">{chips}</div></div>\n'

    html += '''  </div>
</div>'''
    return html


CSS_AND_STYLE = '''<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=yes">
  <title>MODULE_TITLE — Catlib Explorer</title>
  <link rel="preconnect" href="https://fonts.googleapis.com">
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
  <link href="https://fonts.googleapis.com/css2?family=Cinzel:wght@400;600&family=Cormorant+Garamond:ital,wght@0,400;0,500;1,400&display=swap" rel="stylesheet">
  <style>
:root {
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

/* -- Search -- */
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

/* -- Node cards -- */
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

/* -- Flow diagram header -- */
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

/* -- Legend -- */
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

/* -- Filter buttons -- */
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

/* -- Back link -- */
.back-link {
  display: inline-block;
  margin-bottom: 1rem;
  font-family: Cinzel, Georgia, serif;
  font-size: 0.85rem;
  letter-spacing: 0.04em;
}

/* -- Footer -- */
.footer {
  text-align: center;
  padding-top: 2rem;
  font-size: 0.8rem;
  color: var(--text-muted);
  font-style: italic;
}

/* -- Responsive -- */
@media (max-width: 500px) {
  html { font-size: 16px; }
  .container { padding: 1rem 0.75rem 2rem; }
  h1 { font-size: 1.35rem; }
  .node-name { font-size: 0.75rem; }
}
</style>
</head>
<body>
<div class="container">
'''

JS_TEMPLATE = '''
<script>
function toggleNode(header) {
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
});
</script>
</body>
</html>'''


def generate_page(lean_path, module_name, category="Creed"):
    """Generate a full explorer HTML page for a Lean module."""
    declarations = parse_lean_file(lean_path)
    if not declarations:
        print(f"  WARNING: No declarations found in {lean_path}")
        return None

    ccc_refs = extract_ccc_refs(lean_path)
    deps, used_by = compute_dependencies(declarations, lean_path)

    # Count by kind
    counts = defaultdict(int)
    for d in declarations:
        counts[d['kind']] += 1

    total = len(declarations)

    # Build legend (only for kinds present)
    kind_order = ['axiom', 'def', 'inductive', 'opaque', 'proposition', 'structure', 'theorem']
    legend_items = []
    for k in kind_order:
        if counts[k] > 0:
            legend_items.append(f'<span class="legend-item"><span class="legend-dot {k}"></span>{k}</span>')
    legend_html = '<div class="legend">' + ''.join(legend_items) + '</div>'

    # Build filter bar
    filter_buttons = ['<button class="filter-btn active" data-filter="all">All</button>']
    for k in kind_order:
        if counts[k] > 0:
            filter_buttons.append(f'<button class="filter-btn" data-filter="{k}">{k} ({counts[k]})</button>')
    filter_html = '<div class="filter-bar">' + ''.join(filter_buttons) + '</div>'

    # CCC references
    ccc_html = ""
    if ccc_refs:
        refs_str = ', '.join(f'&sect;{r}' for r in ccc_refs[:12])
        if len(ccc_refs) > 12:
            refs_str += f' (+{len(ccc_refs) - 12} more)'
        ccc_html = f'\n  <div style="text-align:center;font-size:0.82rem;color:var(--text-muted);margin-bottom:1rem;font-style:italic;">CCC {refs_str}</div>\n'

    # Build node cards
    node_cards = []
    for d in declarations:
        node_cards.append(generate_node_card(d, deps, used_by))

    # Assemble page
    html = CSS_AND_STYLE.replace('MODULE_TITLE', module_name)
    html += f'  <a href="index.html" class="back-link">&larr; All files</a>\n'
    html += f'  <h1>{module_name}</h1>\n'
    html += f'  <div class="subtitle">{category} &middot; {total} declarations</div>\n'
    html += f'\n  {ccc_html}'
    html += f'  {legend_html}\n\n'
    html += f'  {filter_html}\n\n'
    html += f'  <input type="text" class="search-box" placeholder="Search declarations..." id="nodeSearch">\n\n'
    html += f'  <div id="nodeList">\n'
    html += '    ' + '\n'.join(node_cards)
    html += '\n  </div>\n\n'
    html += f'  <div class="footer">\n'
    html += f'    Generated from <code>Catlib/{category}/{module_name}.lean</code>\n'
    html += f'  </div>\n'
    html += '</div>\n'
    html += JS_TEMPLATE

    return html


def main():
    modules = sys.argv[1:] if len(sys.argv) > 1 else []

    if not modules:
        print("Usage: gen_explorer.py Module1 Module2 ...")
        print("  Generates/regenerates explorer pages for the given Creed modules.")
        print("  Example: gen_explorer.py LordsPrayer Miracles SaintsIntercession")
        sys.exit(1)

    for module in modules:
        lean_path = CATLIB_DIR / "Creed" / f"{module}.lean"
        if not lean_path.exists():
            print(f"SKIP {module}: {lean_path} does not exist")
            continue

        print(f"Generating Creed_{module}.html ...")
        html = generate_page(lean_path, module, "Creed")
        if html:
            out_path = SITE_DIR / f"Creed_{module}.html"
            with open(out_path, 'w') as f:
                f.write(html)
            print(f"  Written to {out_path}")
        else:
            print(f"  FAILED: no output generated")


if __name__ == '__main__':
    main()
