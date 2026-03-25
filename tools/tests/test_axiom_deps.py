"""Comprehensive tests for the kernel-mode functions in theorem-tree.

These test the functions that were originally in axiom-deps, now merged
into theorem-tree as kernel mode (--true-islands, --kernel, --compare, --json).
"""

import importlib.machinery
import importlib.util
import io
import os
import sys
import tempfile
from pathlib import Path
from unittest.mock import patch

import pytest

# ---------------------------------------------------------------------------
# Import theorem-tree as a module (it's a script, not a package)
# ---------------------------------------------------------------------------

TOOL_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "theorem-tree")
loader = importlib.machinery.SourceFileLoader("theorem_tree", TOOL_PATH)
spec = importlib.util.spec_from_loader("theorem_tree", loader, origin=TOOL_PATH)
theorem_tree = importlib.util.module_from_spec(spec)
spec.loader.exec_module(theorem_tree)

# Convenience aliases — kernel-mode functions
def scan_declarations(path):
    """Wrapper that drops the namespaces return value for backward compat."""
    theorems, axioms, _ns = theorem_tree.kernel_scan_declarations(path)
    return theorems, axioms
filter_catlib_axioms = theorem_tree.filter_catlib_axioms
print_true_islands = theorem_tree.print_true_islands
_parse_print_axioms_output = theorem_tree._parse_print_axioms_output
_is_import_only = theorem_tree._is_import_only

CATLIB_ROOT = os.path.join(os.path.dirname(__file__), "..", "..", "Catlib")


# ===========================================================================
# Helpers
# ===========================================================================

def _write_lean(tmpdir, name, content):
    """Write a .lean file inside tmpdir and return its Path."""
    p = Path(tmpdir) / name
    p.parent.mkdir(parents=True, exist_ok=True)
    p.write_text(content, encoding="utf-8")
    return p


# ===========================================================================
# 1. scan_declarations
# ===========================================================================

class TestScanDeclarations:
    """Tests for scan_declarations."""

    def test_finds_theorem(self, tmp_path):
        _write_lean(tmp_path, "A.lean", "theorem foo : Prop := sorry\n")
        theorems, axioms = scan_declarations(str(tmp_path))
        assert len(theorems) == 1
        assert theorems[0][0] == "foo"

    def test_finds_axiom(self, tmp_path):
        _write_lean(tmp_path, "A.lean", "axiom bar : Prop\n")
        theorems, axioms = scan_declarations(str(tmp_path))
        assert len(axioms) == 1
        assert axioms[0][0] == "bar"
        assert axioms[0][3] == "axiom"

    def test_finds_opaque(self, tmp_path):
        _write_lean(tmp_path, "A.lean", "opaque Form : Type\n")
        theorems, axioms = scan_declarations(str(tmp_path))
        assert len(axioms) == 1
        assert axioms[0][0] == "Form"
        assert axioms[0][3] == "opaque"

    def test_kind_field_is_fourth_element(self, tmp_path):
        _write_lean(tmp_path, "A.lean", (
            "axiom myAxiom : Prop\n"
            "opaque myOpaque : Type\n"
        ))
        _, axioms = scan_declarations(str(tmp_path))
        assert len(axioms) == 2
        # Each axiom tuple: (fqn, file_path, line_no, kind)
        kinds = {a[0]: a[3] for a in axioms}
        assert kinds["myAxiom"] == "axiom"
        assert kinds["myOpaque"] == "opaque"

    def test_namespace_fqn(self, tmp_path):
        _write_lean(tmp_path, "A.lean", (
            "namespace Foo\n"
            "theorem bar : Prop := sorry\n"
            "axiom baz : Prop\n"
            "end Foo\n"
        ))
        theorems, axioms = scan_declarations(str(tmp_path))
        assert theorems[0][0] == "Foo.bar"
        assert axioms[0][0] == "Foo.baz"

    def test_nested_namespaces(self, tmp_path):
        _write_lean(tmp_path, "A.lean", (
            "namespace A\n"
            "namespace B\n"
            "theorem t : Prop := sorry\n"
            "end B\n"
            "end A\n"
        ))
        theorems, _ = scan_declarations(str(tmp_path))
        # Only the innermost namespace is tracked by the regex (stack-based)
        # When inside A > B, ns_stack = ["A", "B"], current_ns = "B"
        # The tool uses ns_stack[-1] for FQN, so it would be "B.t"
        assert theorems[0][0] == "B.t"

    def test_skips_line_comments(self, tmp_path):
        _write_lean(tmp_path, "A.lean", (
            "-- theorem fake : Prop := sorry\n"
            "theorem real : Prop := sorry\n"
        ))
        theorems, _ = scan_declarations(str(tmp_path))
        assert len(theorems) == 1
        assert theorems[0][0] == "real"

    def test_skips_block_comments(self, tmp_path):
        _write_lean(tmp_path, "A.lean", (
            "/- This is a block comment\n"
            "theorem fake : Prop := sorry\n"
            "-/\n"
            "theorem real : Prop := sorry\n"
        ))
        theorems, _ = scan_declarations(str(tmp_path))
        assert len(theorems) == 1
        assert theorems[0][0] == "real"

    def test_skips_inline_block_comment(self, tmp_path):
        """A block comment that opens and closes on the same line."""
        _write_lean(tmp_path, "A.lean", (
            "/- theorem fake : Prop -/\n"
            "theorem real : Prop := sorry\n"
        ))
        theorems, _ = scan_declarations(str(tmp_path))
        assert len(theorems) == 1
        assert theorems[0][0] == "real"

    def test_skips_doc_comments(self, tmp_path):
        _write_lean(tmp_path, "A.lean", (
            "/-- A doc comment\n"
            "    with theorem keyword in it -/\n"
            "theorem real : Prop := sorry\n"
        ))
        theorems, _ = scan_declarations(str(tmp_path))
        assert len(theorems) == 1
        assert theorems[0][0] == "real"

    def test_skips_import_only_files(self, tmp_path):
        _write_lean(tmp_path, "Imports.lean", (
            "import Foo\n"
            "import Bar\n"
        ))
        _write_lean(tmp_path, "Real.lean", (
            "theorem t : Prop := sorry\n"
        ))
        theorems, _ = scan_declarations(str(tmp_path))
        assert len(theorems) == 1
        assert theorems[0][0] == "t"

    def test_strips_trailing_colon(self, tmp_path):
        """Lean declarations often have `theorem foo:` — the colon should be stripped."""
        _write_lean(tmp_path, "A.lean", "theorem foo: Prop := sorry\n")
        theorems, _ = scan_declarations(str(tmp_path))
        # The regex captures \S+ then strips trailing colons
        assert ":" not in theorems[0][0]

    def test_strips_trailing_paren(self, tmp_path):
        """theorem foo (x : Nat) — with space before paren, name is captured correctly."""
        _write_lean(tmp_path, "A.lean", "theorem foo (x : Nat) : Prop := sorry\n")
        theorems, _ = scan_declarations(str(tmp_path))
        assert theorems[0][0] == "foo"
        assert "(" not in theorems[0][0]

    def test_rejects_invalid_identifiers(self, tmp_path):
        """Names that aren't valid Lean identifiers (e.g. starting with digit) are skipped."""
        _write_lean(tmp_path, "A.lean", (
            "theorem 123bad : Prop := sorry\n"
            "theorem good : Prop := sorry\n"
        ))
        theorems, _ = scan_declarations(str(tmp_path))
        assert len(theorems) == 1
        assert theorems[0][0] == "good"

    def test_records_file_and_line(self, tmp_path):
        _write_lean(tmp_path, "A.lean", (
            "-- comment\n"
            "theorem t1 : Prop := sorry\n"
        ))
        theorems, _ = scan_declarations(str(tmp_path))
        assert theorems[0][1].endswith("A.lean")
        assert theorems[0][2] == 2  # line 2

    def test_empty_file(self, tmp_path):
        _write_lean(tmp_path, "Empty.lean", "")
        theorems, axioms = scan_declarations(str(tmp_path))
        # Empty file is import-only (no non-import lines), so skipped
        assert len(theorems) == 0
        assert len(axioms) == 0

    def test_multiple_files(self, tmp_path):
        _write_lean(tmp_path, "A.lean", "theorem t1 : Prop := sorry\n")
        _write_lean(tmp_path, "B.lean", "axiom a1 : Prop\nopaque o1 : Type\n")
        theorems, axioms = scan_declarations(str(tmp_path))
        assert len(theorems) == 1
        assert len(axioms) == 2

    def test_indented_declarations_ignored(self, tmp_path):
        """Only col-0 declarations are matched (not inside where blocks etc.)."""
        _write_lean(tmp_path, "A.lean", (
            "  theorem indented : Prop := sorry\n"
            "theorem top_level : Prop := sorry\n"
        ))
        theorems, _ = scan_declarations(str(tmp_path))
        assert len(theorems) == 1
        assert theorems[0][0] == "top_level"


# ===========================================================================
# 2. --true-islands (print_true_islands)
# ===========================================================================

class TestPrintTrueIslands:
    """Tests for print_true_islands — the critical --true-islands flag."""

    def _capture_islands(self, results, source_axioms):
        """Run print_true_islands and return its stdout."""
        buf = io.StringIO()
        with patch("sys.stdout", buf):
            print_true_islands(results, source_axioms)
        return buf.getvalue()

    def test_unused_axiom_is_island(self):
        """An axiom not in any theorem's deps IS an island."""
        results = {
            "thm1": ["propext", "some_axiom"],
        }
        source_axioms = [
            ("unused_axiom", "file.lean", 10, "axiom"),
        ]
        output = self._capture_islands(results, source_axioms)
        assert "unused_axiom" in output

    def test_used_axiom_is_not_island(self):
        """An axiom that IS in a theorem's deps is NOT an island."""
        results = {
            "thm1": ["used_axiom"],
        }
        source_axioms = [
            ("used_axiom", "file.lean", 10, "axiom"),
        ]
        output = self._capture_islands(results, source_axioms)
        # The axiom is used, so it should not appear in the island list
        # (it will appear in the header text like "Of 1 declared..., 0 are not used")
        lines = [l.strip() for l in output.splitlines() if l.strip().startswith("used_axiom")]
        assert len(lines) == 0

    def test_opaque_not_island_even_if_unused(self):
        """CRITICAL: An opaque not in any theorem's deps is NOT an island.
        The --true-islands flag should ONLY report axiom-kind declarations."""
        results = {
            "thm1": ["propext"],
        }
        source_axioms = [
            ("Form", "file.lean", 5, "opaque"),
            ("Matter", "file.lean", 6, "opaque"),
            ("real_axiom", "file.lean", 10, "axiom"),
        ]
        output = self._capture_islands(results, source_axioms)
        # Opaques should not appear as islands
        assert "Form" not in output.split("are not used")[1] if "are not used" in output else True
        # But the axiom should be there since it's unused
        assert "real_axiom" in output

    def test_opaque_filtered_out_completely(self):
        """Even if opaques outnumber axioms, only axiom-kind shows up."""
        results = {}  # no theorems at all
        source_axioms = [
            ("O1", "f.lean", 1, "opaque"),
            ("O2", "f.lean", 2, "opaque"),
            ("O3", "f.lean", 3, "opaque"),
            ("A1", "f.lean", 4, "axiom"),
        ]
        output = self._capture_islands(results, source_axioms)
        # Only A1 should appear as an island, not O1/O2/O3
        assert "A1" in output
        # None of the opaques should be in the island listing
        for name in ["O1", "O2", "O3"]:
            # Check the lines after the header — island listings are indented with 2 spaces
            island_lines = [l for l in output.splitlines()
                           if l.strip() == name]
            assert len(island_lines) == 0, f"{name} should not be listed as island"

    def test_empty_results_all_axioms_are_islands(self):
        """If no theorems analyzed, all axioms are islands."""
        results = {}
        source_axioms = [
            ("ax1", "f.lean", 1, "axiom"),
            ("ax2", "f.lean", 2, "axiom"),
        ]
        output = self._capture_islands(results, source_axioms)
        assert "ax1" in output
        assert "ax2" in output

    def test_no_axioms_no_islands(self):
        """If no axioms declared, there are no islands."""
        results = {"thm1": ["propext"]}
        source_axioms = []
        output = self._capture_islands(results, source_axioms)
        assert "0 are not used" in output

    def test_mixed_axiom_and_opaque_only_axiom_counted(self):
        """Count header should say 'Of N declared' where N = number of axiom-kind only."""
        results = {"thm1": ["used_ax"]}
        source_axioms = [
            ("used_ax", "f.lean", 1, "axiom"),
            ("unused_op", "f.lean", 2, "opaque"),
            ("unused_ax", "f.lean", 3, "axiom"),
        ]
        output = self._capture_islands(results, source_axioms)
        # Should count 2 axioms (not 3 total including opaque)
        assert "Of 2 declared" in output
        # Only unused_ax is an island (unused_op is opaque, filtered out)
        assert "unused_ax" in output
        # The opaque should NOT appear
        island_section = output.split("are not used")[1] if "are not used" in output else ""
        assert "unused_op" not in island_section

    def test_builtin_axioms_not_counted_as_used(self):
        """Lean builtins in deps should be filtered before computing islands."""
        results = {
            "thm1": ["propext", "Classical.choice"],
        }
        source_axioms = [
            ("my_axiom", "f.lean", 1, "axiom"),
        ]
        output = self._capture_islands(results, source_axioms)
        # my_axiom is not in deps (only builtins are), so it's an island
        assert "my_axiom" in output


# ===========================================================================
# 3. filter_catlib_axioms
# ===========================================================================

class TestFilterCatlibAxioms:
    """Tests for filter_catlib_axioms."""

    def test_filters_builtins(self):
        deps = ["propext", "Classical.choice", "Quot.mk", "Quot.sound",
                "Quot.ind", "Quot.lift", "rfl", "Eq.refl", "my_axiom"]
        result = filter_catlib_axioms(deps)
        assert result == ["my_axiom"]

    def test_filters_lean_prefix(self):
        deps = ["Lean.Meta.something", "Lean.Elab.foo", "my_axiom"]
        result = filter_catlib_axioms(deps)
        assert result == ["my_axiom"]

    def test_keeps_catlib_names(self):
        deps = ["Catlib.Creed.ORIGINAL_INTEGRITY", "Catlib.Foundations.s1_god_exists"]
        result = filter_catlib_axioms(deps)
        assert len(result) == 2

    def test_empty_list(self):
        assert filter_catlib_axioms([]) == []

    def test_all_builtins(self):
        deps = ["propext", "Classical.choice"]
        assert filter_catlib_axioms(deps) == []


# ===========================================================================
# 4. _parse_print_axioms_output
# ===========================================================================

class TestParseOutput:
    """Tests for _parse_print_axioms_output."""

    def _parse(self, text):
        results = {}
        errors = {}
        _parse_print_axioms_output(text, results, errors)
        return results, errors

    def test_single_line_deps(self):
        text = "'MyThm' depends on axioms: [propext, Classical.choice]\n"
        results, errors = self._parse(text)
        assert results["MyThm"] == ["propext", "Classical.choice"]
        assert len(errors) == 0

    def test_no_deps(self):
        text = "'MyThm' does not depend on any axioms\n"
        results, errors = self._parse(text)
        assert results["MyThm"] == []

    def test_multiline_brackets(self):
        text = (
            "'BigThm' depends on axioms: [propext,\n"
            " Classical.choice,\n"
            " my_axiom]\n"
        )
        results, errors = self._parse(text)
        assert "BigThm" in results
        assert set(results["BigThm"]) == {"propext", "Classical.choice", "my_axiom"}

    def test_error_unknown_identifier(self):
        text = "unknown identifier 'BadName'\n"
        results, errors = self._parse(text)
        assert len(results) == 0
        assert "BadName" in errors

    def test_error_unknown_constant(self):
        text = "unknown constant 'BadConst'\n"
        results, errors = self._parse(text)
        assert "BadConst" in errors

    def test_empty_output(self):
        results, errors = self._parse("")
        assert len(results) == 0
        assert len(errors) == 0

    def test_multiple_theorems(self):
        text = (
            "'Thm1' depends on axioms: [a, b]\n"
            "'Thm2' does not depend on any axioms\n"
            "'Thm3' depends on axioms: [c]\n"
        )
        results, errors = self._parse(text)
        assert len(results) == 3
        assert results["Thm1"] == ["a", "b"]
        assert results["Thm2"] == []
        assert results["Thm3"] == ["c"]

    def test_mixed_results_and_errors(self):
        text = (
            "'Good' depends on axioms: [propext]\n"
            "unknown identifier 'Bad'\n"
            "'Also.Good' does not depend on any axioms\n"
        )
        results, errors = self._parse(text)
        assert "Good" in results
        assert "Also.Good" in results
        assert "Bad" in errors

    def test_single_axiom_dep(self):
        text = "'T' depends on axioms: [one]\n"
        results, _ = self._parse(text)
        assert results["T"] == ["one"]

    def test_ignores_blank_lines(self):
        text = "\n\n'T' depends on axioms: [a]\n\n\n"
        results, _ = self._parse(text)
        assert results["T"] == ["a"]

    def test_fqn_with_dots(self):
        text = "'Catlib.Creed.OriginalSin.s8_derived' depends on axioms: [Catlib.Creed.OriginalSin.GRACE_IS_THE_HEALING]\n"
        results, _ = self._parse(text)
        assert "Catlib.Creed.OriginalSin.s8_derived" in results
        assert results["Catlib.Creed.OriginalSin.s8_derived"] == [
            "Catlib.Creed.OriginalSin.GRACE_IS_THE_HEALING"
        ]


# ===========================================================================
# 5. _is_import_only
# ===========================================================================

class TestIsImportOnly:
    """Tests for _is_import_only."""

    def test_import_only_file(self, tmp_path):
        p = tmp_path / "Imports.lean"
        p.write_text("import Foo\nimport Bar\n")
        assert _is_import_only(p) is True

    def test_import_with_comments(self, tmp_path):
        p = tmp_path / "Imports.lean"
        p.write_text("-- Module imports\nimport Foo\nimport Bar\n")
        assert _is_import_only(p) is True

    def test_file_with_declarations(self, tmp_path):
        p = tmp_path / "Real.lean"
        p.write_text("import Foo\ntheorem t : Prop := sorry\n")
        assert _is_import_only(p) is False

    def test_file_with_namespace(self, tmp_path):
        p = tmp_path / "NS.lean"
        p.write_text("import Foo\nnamespace Bar\nend Bar\n")
        assert _is_import_only(p) is False

    def test_empty_file(self, tmp_path):
        p = tmp_path / "Empty.lean"
        p.write_text("")
        assert _is_import_only(p) is True

    def test_whitespace_only(self, tmp_path):
        p = tmp_path / "Ws.lean"
        p.write_text("   \n\n  \n")
        assert _is_import_only(p) is True

    def test_set_option_is_not_import_only(self, tmp_path):
        p = tmp_path / "Opts.lean"
        p.write_text("import Foo\nset_option autoImplicit false\n")
        assert _is_import_only(p) is False


# ===========================================================================
# 6. Integration tests against real Catlib files
# ===========================================================================

class TestIntegrationRealFiles:
    """Integration tests that scan the actual Catlib/ directory."""

    @pytest.fixture(autouse=True)
    def _check_catlib(self):
        if not Path(CATLIB_ROOT).is_dir():
            pytest.skip("Catlib/ directory not found")

    def test_scan_finds_theorems_and_axioms(self):
        theorems, axioms = scan_declarations(CATLIB_ROOT)
        assert len(theorems) > 0, "Expected at least one theorem"
        assert len(axioms) > 0, "Expected at least one axiom/opaque"

    def test_axiom_kinds_are_valid(self):
        _, axioms = scan_declarations(CATLIB_ROOT)
        for fqn, filepath, lineno, kind in axioms:
            assert kind in ("axiom", "opaque"), f"Invalid kind '{kind}' for {fqn}"

    def test_has_both_axioms_and_opaques(self):
        _, axioms = scan_declarations(CATLIB_ROOT)
        kinds = {a[3] for a in axioms}
        assert "axiom" in kinds, "Expected at least one axiom-kind declaration"
        assert "opaque" in kinds, "Expected at least one opaque-kind declaration"

    def test_original_sin_axioms_found(self):
        """OriginalSin.lean should contribute specific axioms."""
        _, axioms = scan_declarations(CATLIB_ROOT)
        axiom_names = {a[0] for a in axioms}
        # These are axiom-kind declarations in OriginalSin.lean
        expected = {
            "OriginalSin.original_integrity",
            "OriginalSin.the_fall",
            "OriginalSin.wound_requires_healing",
            "OriginalSin.grace_is_the_healing",
            "OriginalSin.original_sin_not_personal",
        }
        for name in expected:
            matches = [n for n in axiom_names if name in n]
            assert len(matches) > 0, f"Expected to find axiom matching '{name}'"

    def test_original_sin_opaques_found(self):
        """OriginalSin.lean should contribute opaque declarations."""
        _, axioms = scan_declarations(CATLIB_ROOT)
        opaque_names = {a[0] for a in axioms if a[3] == "opaque"}
        # canReachSupernaturalEnd, natureIsWounded, graceHealsWound, isPersonalFault
        expected_fragments = [
            "canReachSupernaturalEnd",
            "natureIsWounded",
            "graceHealsWound",
            "isPersonalFault",
        ]
        for frag in expected_fragments:
            matches = [n for n in opaque_names if frag in n]
            assert len(matches) > 0, f"Expected opaque matching '{frag}'"

    def test_true_islands_output_has_no_opaques(self, capsys):
        """The --true-islands output should never list opaque-kind names."""
        _, axioms = scan_declarations(CATLIB_ROOT)
        opaque_names = {a[0] for a in axioms if a[3] == "opaque"}

        # Use empty results (no theorems resolved) — all axioms become islands
        # but opaques should still be filtered out
        results = {}
        print_true_islands(results, axioms)
        output = capsys.readouterr().out

        # Extract the island listing (lines after the header, indented)
        island_lines = []
        in_listing = False
        for line in output.splitlines():
            if "are not used" in line:
                in_listing = True
                continue
            if in_listing and line.strip():
                island_lines.append(line.strip())

        for island in island_lines:
            assert island not in opaque_names, (
                f"Opaque '{island}' should NOT appear in --true-islands output"
            )

    def test_scan_theorems_have_valid_structure(self):
        theorems, _ = scan_declarations(CATLIB_ROOT)
        for t in theorems:
            assert len(t) == 3, f"Theorem tuple should be (fqn, file, line), got {len(t)} elements"
            fqn, filepath, lineno = t
            assert isinstance(fqn, str) and len(fqn) > 0
            assert isinstance(filepath, str)
            assert isinstance(lineno, int) and lineno > 0

    def test_scan_axioms_have_valid_structure(self):
        _, axioms = scan_declarations(CATLIB_ROOT)
        for a in axioms:
            assert len(a) == 4, f"Axiom tuple should be (fqn, file, line, kind), got {len(a)} elements"
            fqn, filepath, lineno, kind = a
            assert isinstance(fqn, str) and len(fqn) > 0
            assert isinstance(filepath, str)
            assert isinstance(lineno, int) and lineno > 0
            assert kind in ("axiom", "opaque")


# ===========================================================================
# 7. _short_name helper
# ===========================================================================

class TestShortName:
    """Tests for the _short_name display helper."""

    def test_strips_catlib_prefix(self):
        assert theorem_tree._kernel_short_name("Catlib.Creed.OriginalSin.THE_FALL") == "THE_FALL"

    def test_strips_foundations_prefix(self):
        # "Catlib.Foundations.Love." is in the prefix list, so it strips fully
        assert theorem_tree._kernel_short_name("Catlib.Foundations.Love.something") == "something"

    def test_no_prefix(self):
        assert theorem_tree._kernel_short_name("standalone") == "standalone"
