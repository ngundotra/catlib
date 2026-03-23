"""Comprehensive tests for the theorem-tree CLI tool."""

import importlib.machinery
import importlib.util
import io
import os
import subprocess
import sys
import tempfile
import textwrap

import pytest

# ---------------------------------------------------------------------------
# Import the theorem-tree script as a module
# ---------------------------------------------------------------------------

TOOL_PATH = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "theorem-tree"))
_loader = importlib.machinery.SourceFileLoader("theorem_tree", TOOL_PATH)
spec = importlib.util.spec_from_loader("theorem_tree", _loader, origin=TOOL_PATH)
theorem_tree = importlib.util.module_from_spec(spec)
spec.loader.exec_module(theorem_tree)

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", ".."))
CATLIB_DIR = os.path.join(PROJECT_ROOT, "Catlib")


# ---------------------------------------------------------------------------
# Helpers for building mock declarations
# ---------------------------------------------------------------------------

def _make_decl(kind, name, refs=None, description="", file_path="/mock.lean"):
    """Create a Declaration with optional references."""
    decl = theorem_tree.Declaration(kind, name, description, 1, file_path)
    decl.references = refs or []
    decl.body_lines = ""
    return decl


def _make_lean_file(path, decls):
    """Create a LeanFile with the given declarations."""
    lf = theorem_tree.LeanFile(path)
    lf.declarations = decls
    return lf


def _build_mock_parsed(decl_specs):
    """Build a list of LeanFile objects from a list of (kind, name, refs) tuples.

    All declarations go into a single mock file unless a 4th element (filepath)
    is provided.
    """
    by_file = {}
    for spec in decl_specs:
        kind, name = spec[0], spec[1]
        refs = spec[2] if len(spec) > 2 else []
        fp = spec[3] if len(spec) > 3 else "/mock.lean"
        desc = spec[4] if len(spec) > 4 else ""
        if fp not in by_file:
            by_file[fp] = []
        by_file[fp].append(_make_decl(kind, name, refs, desc, fp))

    return [_make_lean_file(fp, decls) for fp, decls in by_file.items()]


def _capture_print(func, *args, **kwargs):
    """Capture stdout from a function call and return the output string."""
    old_stdout = sys.stdout
    sys.stdout = buf = io.StringIO()
    try:
        func(*args, **kwargs)
    finally:
        sys.stdout = old_stdout
    return buf.getvalue()


# ===========================================================================
# 1. Declaration parsing (parse_lean_file)
# ===========================================================================

class TestParseLeanFile:
    """Tests for parse_lean_file on synthetic Lean content."""

    def _write_and_parse(self, content):
        """Write content to a temp file, parse it, return the LeanFile."""
        with tempfile.NamedTemporaryFile(
            mode="w", suffix=".lean", delete=False, encoding="utf-8"
        ) as f:
            f.write(content)
            f.flush()
            path = f.name
        try:
            return theorem_tree.parse_lean_file(path)
        finally:
            os.unlink(path)

    def test_parse_axiom(self):
        lf = self._write_and_parse("axiom my_axiom : Prop\n")
        assert len(lf.declarations) == 1
        assert lf.declarations[0].kind == "axiom"
        assert lf.declarations[0].name == "my_axiom"

    def test_parse_theorem(self):
        lf = self._write_and_parse("theorem my_thm : True := trivial\n")
        assert len(lf.declarations) == 1
        assert lf.declarations[0].kind == "theorem"
        assert lf.declarations[0].name == "my_thm"

    def test_parse_def(self):
        lf = self._write_and_parse("def my_def : Nat := 42\n")
        assert len(lf.declarations) == 1
        assert lf.declarations[0].kind == "def"
        assert lf.declarations[0].name == "my_def"

    def test_parse_opaque(self):
        lf = self._write_and_parse("opaque Form : Type\n")
        assert len(lf.declarations) == 1
        assert lf.declarations[0].kind == "opaque"
        assert lf.declarations[0].name == "Form"

    def test_parse_structure(self):
        content = textwrap.dedent("""\
            structure MyStruct where
              field1 : Nat
              field2 : Bool
        """)
        lf = self._write_and_parse(content)
        assert len(lf.declarations) == 1
        assert lf.declarations[0].kind == "structure"
        assert lf.declarations[0].name == "MyStruct"

    def test_parse_inductive(self):
        content = textwrap.dedent("""\
            inductive MyEnum where
              | A
              | B
        """)
        lf = self._write_and_parse(content)
        assert len(lf.declarations) == 1
        assert lf.declarations[0].kind == "inductive"
        assert lf.declarations[0].name == "MyEnum"

    def test_parse_multiple_declarations(self):
        content = textwrap.dedent("""\
            axiom base_axiom : Prop
            def helper_def : Nat := 0
            theorem main_theorem : True := trivial
        """)
        lf = self._write_and_parse(content)
        assert len(lf.declarations) == 3
        kinds = [d.kind for d in lf.declarations]
        assert kinds == ["axiom", "def", "theorem"]

    def test_docstring_extraction(self):
        content = textwrap.dedent("""\
            /-- This is a description of my axiom. -/
            axiom documented_axiom : Prop
        """)
        lf = self._write_and_parse(content)
        assert len(lf.declarations) == 1
        assert lf.declarations[0].name == "documented_axiom"
        assert "description of my axiom" in lf.declarations[0].description

    def test_multiline_docstring(self):
        content = textwrap.dedent("""\
            /--
            This is a long docstring.
            It spans multiple lines.
            -/
            axiom multi_doc_axiom : Prop
        """)
        lf = self._write_and_parse(content)
        assert len(lf.declarations) == 1
        assert lf.declarations[0].full_docstring != ""
        assert "long docstring" in lf.declarations[0].full_docstring

    def test_module_doc_not_attached_to_decl(self):
        content = textwrap.dedent("""\
            /-!
            # Module documentation
            This is module-level docs.
            -/
            axiom after_module_doc : Prop
        """)
        lf = self._write_and_parse(content)
        assert len(lf.declarations) == 1
        # Module doc should not be attached as a declaration's docstring
        assert lf.declarations[0].description == ""

    def test_import_extraction(self):
        content = textwrap.dedent("""\
            import Catlib.Foundations
            import Catlib.Creed
            axiom some_axiom : Prop
        """)
        lf = self._write_and_parse(content)
        assert "Catlib.Foundations" in lf.imports
        assert "Catlib.Creed" in lf.imports

    def test_namespace_extraction(self):
        content = textwrap.dedent("""\
            namespace MyNamespace
            axiom ns_axiom : Prop
        """)
        lf = self._write_and_parse(content)
        assert lf.namespace == "MyNamespace"

    def test_reference_detection_in_body(self):
        """References are detected when declaration bodies mention other decl names."""
        content = textwrap.dedent("""\
            axiom long_axiom_name : Prop
            theorem uses_axiom : long_axiom_name := sorry
        """)
        lf = self._write_and_parse(content)
        # We need to resolve references across files
        theorem_tree.resolve_references([lf])
        thm = [d for d in lf.declarations if d.kind == "theorem"][0]
        assert "long_axiom_name" in thm.references

    def test_name_stripping_colon_paren(self):
        """Declaration names should have trailing : and ( stripped."""
        content = "axiom my_axiom: Prop\n"
        lf = self._write_and_parse(content)
        assert lf.declarations[0].name == "my_axiom"

    def test_nonexistent_file(self):
        lf = theorem_tree.parse_lean_file("/nonexistent/path.lean")
        assert lf.declarations == []


# ===========================================================================
# 2. --trace flag
# ===========================================================================

class TestTrace:
    """Tests for print_trace — transitive dependency tree."""

    def test_trace_shows_direct_deps(self):
        parsed = _build_mock_parsed([
            ("axiom", "base_axiom_a", []),
            ("axiom", "base_axiom_b", []),
            ("theorem", "my_theorem", ["base_axiom_a", "base_axiom_b"]),
        ])
        output = _capture_print(theorem_tree.print_trace, parsed, "/root", "my_theorem")
        assert "base_axiom_a" in output
        assert "base_axiom_b" in output

    def test_trace_shows_transitive_deps(self):
        parsed = _build_mock_parsed([
            ("axiom", "root_axiom", []),
            ("def", "middle_def", ["root_axiom"]),
            ("theorem", "top_thm", ["middle_def"]),
        ])
        output = _capture_print(theorem_tree.print_trace, parsed, "/root", "top_thm")
        assert "middle_def" in output
        assert "root_axiom" in output

    def test_trace_summary_count(self):
        parsed = _build_mock_parsed([
            ("axiom", "ax_one", []),
            ("axiom", "ax_two", []),
            ("theorem", "thm_trace", ["ax_one", "ax_two"]),
        ])
        output = _capture_print(theorem_tree.print_trace, parsed, "/root", "thm_trace")
        assert "Total transitive dependencies: 2" in output

    def test_trace_not_found_exits(self):
        parsed = _build_mock_parsed([
            ("axiom", "some_axiom", []),
        ])
        with pytest.raises(SystemExit) as exc_info:
            _capture_print(theorem_tree.print_trace, parsed, "/root", "nonexistent_name")
        assert exc_info.value.code == 1

    def test_trace_handles_circular_reference(self):
        """Circular references should be marked, not cause infinite recursion."""
        parsed = _build_mock_parsed([
            ("def", "def_alpha", ["def_beta"]),
            ("def", "def_beta", ["def_alpha"]),
            ("theorem", "thm_circ", ["def_alpha"]),
        ])
        output = _capture_print(theorem_tree.print_trace, parsed, "/root", "thm_circ")
        assert "circular" in output.lower()


# ===========================================================================
# 6. --defs flag
# ===========================================================================

class TestDefs:
    """Tests for print_defs — definitions and their theorem connections."""

    def test_defs_shows_definitions(self):
        parsed = _build_mock_parsed([
            ("def", "my_definition", []),
            ("theorem", "using_thm", ["my_definition"]),
        ])
        output = _capture_print(theorem_tree.print_defs, parsed, "/root")
        assert "my_definition" in output
        assert "using_thm" in output

    def test_defs_shows_unused(self):
        parsed = _build_mock_parsed([
            ("def", "orphan_def", []),
            ("theorem", "unrelated", []),
        ])
        output = _capture_print(theorem_tree.print_defs, parsed, "/root")
        assert "orphan_def" in output
        assert "(unused)" in output

    def test_defs_excludes_non_def_kinds(self):
        parsed = _build_mock_parsed([
            ("axiom", "not_a_def", []),
            ("theorem", "also_not", []),
        ])
        output = _capture_print(theorem_tree.print_defs, parsed, "/root")
        assert "not_a_def" not in output
        assert "Total: 0 defs" in output

    def test_defs_count_summary(self):
        parsed = _build_mock_parsed([
            ("def", "used_def", []),
            ("def", "unused_def", []),
            ("theorem", "thm_d", ["used_def"]),
        ])
        output = _capture_print(theorem_tree.print_defs, parsed, "/root")
        assert "2 defs" in output
        assert "1 used" in output
        assert "1 unused" in output


# ===========================================================================
# 7. Helper functions
# ===========================================================================

class TestHelpers:
    """Tests for helper functions."""

    def test_build_decl_index(self):
        parsed = _build_mock_parsed([
            ("axiom", "ax_idx", []),
            ("theorem", "thm_idx", []),
            ("def", "some_tag", []),         # should be included (no _tag suffix issue)
            ("def", "ignore_tag", []),        # name ends with _tag => excluded
        ])
        # Manually rename the last to end with _tag
        parsed[0].declarations[3].name = "something_tag"
        index = theorem_tree._build_decl_index(parsed)
        assert "ax_idx" in index
        assert "thm_idx" in index
        assert "something_tag" not in index

    def test_build_decl_index_excludes_provenance(self):
        parsed = _build_mock_parsed([
            ("def", "real_def", []),
            ("def", "fake_provenance", []),
        ])
        parsed[0].declarations[1].name = "my_provenance"
        index = theorem_tree._build_decl_index(parsed)
        assert "real_def" in index
        assert "my_provenance" not in index

    def test_transitive_dependents_bfs(self):
        """BFS should find all transitive dependents."""
        parsed = _build_mock_parsed([
            ("axiom", "root_ax", []),
            ("def", "mid_def", ["root_ax"]),
            ("theorem", "leaf_thm", ["mid_def"]),
        ])
        index = theorem_tree._build_decl_index(parsed)
        deps = theorem_tree._transitive_dependents("root_ax", index)
        assert "mid_def" in deps
        assert "leaf_thm" in deps
        assert "root_ax" not in deps  # should not include itself

    def test_transitive_dependents_empty(self):
        parsed = _build_mock_parsed([
            ("axiom", "alone_ax", []),
        ])
        index = theorem_tree._build_decl_index(parsed)
        deps = theorem_tree._transitive_dependents("alone_ax", index)
        assert deps == set()

    def test_transitive_dependencies(self):
        parsed = _build_mock_parsed([
            ("axiom", "dep_root", []),
            ("def", "dep_mid", ["dep_root"]),
            ("theorem", "dep_leaf", ["dep_mid"]),
        ])
        index = theorem_tree._build_decl_index(parsed)
        deps = theorem_tree._transitive_dependencies("dep_leaf", index)
        assert "dep_mid" in deps
        assert "dep_root" in deps
        assert "dep_leaf" not in deps

    def test_extract_short_description_simple(self):
        result = theorem_tree._extract_short_description("A simple description.")
        assert result == "A simple description."

    def test_extract_short_description_skips_metadata(self):
        """_extract_short_description skips *Source*: lines (asterisk-wrapped)."""
        text = "*Source*: CCC 123\nThe actual description here."
        result = theorem_tree._extract_short_description(text)
        assert "actual description" in result

    def test_extract_short_description_skips_caps_name(self):
        text = "THE PERSONALIST NORM\nEvery person must be treated as an end."
        result = theorem_tree._extract_short_description(text)
        assert "person must be treated" in result

    def test_extract_short_description_empty(self):
        assert theorem_tree._extract_short_description("") == ""

    def test_extract_short_description_truncates_long(self):
        long_text = "A " + "very " * 50 + "long description."
        result = theorem_tree._extract_short_description(long_text)
        assert len(result) <= 120

    def test_make_relative(self):
        result = theorem_tree.make_relative("/home/user/project/Catlib/File.lean", "/home/user/project")
        assert result == "Catlib/File.lean"

    def test_make_relative_same_dir(self):
        result = theorem_tree.make_relative("/a/b/c.lean", "/a/b")
        assert result == "c.lean"


# ===========================================================================
# 8. Integration tests — run as subprocess against actual Lean files
# ===========================================================================

class TestIntegration:
    """Run the tool as a subprocess against actual Lean files in Catlib/."""

    @pytest.fixture
    def tool_cmd(self):
        return [sys.executable, TOOL_PATH]

    def test_basic_tree_exit_code(self, tool_cmd):
        """Running against a known Lean file should exit 0."""
        result = subprocess.run(
            tool_cmd + [os.path.join(CATLIB_DIR, "Foundations", "Basic.lean")],
            capture_output=True, text=True, cwd=PROJECT_ROOT
        )
        assert result.returncode == 0
        assert len(result.stdout) > 0

    def test_directory_tree_exit_code(self, tool_cmd):
        """Running against the Catlib directory should exit 0."""
        result = subprocess.run(
            tool_cmd + [CATLIB_DIR],
            capture_output=True, text=True, cwd=PROJECT_ROOT
        )
        assert result.returncode == 0

    def test_missing_path_error(self, tool_cmd):
        """A nonexistent path should produce an error."""
        result = subprocess.run(
            tool_cmd + ["/nonexistent/path.lean"],
            capture_output=True, text=True, cwd=PROJECT_ROOT
        )
        assert result.returncode != 0

    def test_no_args_shows_help(self, tool_cmd):
        """No arguments should show help and exit 0."""
        result = subprocess.run(
            tool_cmd, capture_output=True, text=True, cwd=PROJECT_ROOT
        )
        assert result.returncode == 0
        assert "theorem-tree" in result.stdout

    def test_defs_subprocess(self, tool_cmd):
        result = subprocess.run(
            tool_cmd + ["--defs", CATLIB_DIR],
            capture_output=True, text=True, cwd=PROJECT_ROOT
        )
        assert result.returncode == 0
        assert "Definitions" in result.stdout

    def test_axioms_only_filter(self, tool_cmd):
        result = subprocess.run(
            tool_cmd + ["--axioms-only", CATLIB_DIR],
            capture_output=True, text=True, cwd=PROJECT_ROOT
        )
        assert result.returncode == 0
        # Should have [axiom] tags but no [theorem] or [def]
        lines = result.stdout.split("\n")
        for line in lines:
            assert "[theorem]" not in line
            assert "[def]" not in line

    def test_theorems_only_filter(self, tool_cmd):
        result = subprocess.run(
            tool_cmd + ["--theorems-only", CATLIB_DIR],
            capture_output=True, text=True, cwd=PROJECT_ROOT
        )
        assert result.returncode == 0
        lines = result.stdout.split("\n")
        for line in lines:
            assert "[axiom]" not in line
            assert "[def]" not in line


# ===========================================================================
# Edge case tests
# ===========================================================================

class TestEdgeCases:
    """Edge cases and regression tests."""

    def test_declaration_repr(self):
        decl = _make_decl("axiom", "test_repr")
        assert repr(decl) == "axiom test_repr"

    def test_declaration_display_kind(self):
        decl = _make_decl("theorem", "test_display")
        assert decl.display_kind() == "theorem"

    def test_find_lean_files_single_file(self):
        with tempfile.NamedTemporaryFile(suffix=".lean", delete=False) as f:
            path = f.name
        try:
            files = theorem_tree.find_lean_files(path)
            assert files == [path]
        finally:
            os.unlink(path)

    def test_find_lean_files_non_lean(self):
        with tempfile.NamedTemporaryFile(suffix=".py", delete=False) as f:
            path = f.name
        try:
            files = theorem_tree.find_lean_files(path)
            assert files == []
        finally:
            os.unlink(path)

    def test_find_lean_files_nonexistent(self):
        files = theorem_tree.find_lean_files("/totally/fake/path")
        assert files == []

    def test_resolve_references_skips_noise_names(self):
        """Names in NOISE_NAMES should not be resolved as references."""
        content = textwrap.dedent("""\
            opaque Person : Type
            axiom long_axiom_ref : Prop
            theorem uses_person : Person := sorry
        """)
        with tempfile.NamedTemporaryFile(
            mode="w", suffix=".lean", delete=False, encoding="utf-8"
        ) as f:
            f.write(content)
            path = f.name
        try:
            lf = theorem_tree.parse_lean_file(path)
            theorem_tree.resolve_references([lf])
            thm = [d for d in lf.declarations if d.kind == "theorem"][0]
            # Person is a noise name, should be excluded
            assert "Person" not in thm.references
        finally:
            os.unlink(path)

    def test_resolve_references_skips_short_names(self):
        """Names shorter than 4 chars should not be resolved."""
        content = textwrap.dedent("""\
            def foo_val : Nat := 0
            theorem uses_foo_val : foo_val = 0 := sorry
        """)
        with tempfile.NamedTemporaryFile(
            mode="w", suffix=".lean", delete=False, encoding="utf-8"
        ) as f:
            f.write(content)
            path = f.name
        try:
            lf = theorem_tree.parse_lean_file(path)
            theorem_tree.resolve_references([lf])
            thm = [d for d in lf.declarations if d.kind == "theorem"][0]
            assert "foo_val" in thm.references
        finally:
            os.unlink(path)

    def test_metadata_extraction_source(self):
        content = textwrap.dedent("""\
            /--
            A docstring with metadata.
            Source: CCC 1234
            Denominational scope: Universal
            HIDDEN ASSUMPTION: Something assumed
            [Scripture]
            -/
            axiom metadata_axiom : Prop
        """)
        with tempfile.NamedTemporaryFile(
            mode="w", suffix=".lean", delete=False, encoding="utf-8"
        ) as f:
            f.write(content)
            path = f.name
        try:
            lf = theorem_tree.parse_lean_file(path)
            decl = lf.declarations[0]
            assert "CCC 1234" in decl.source
            assert "Universal" in decl.scope
            assert len(decl.hidden_assumptions) == 1
            assert "Something assumed" in decl.hidden_assumptions[0]
            assert "Scripture" in decl.provenance_type
        finally:
            os.unlink(path)
