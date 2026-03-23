"""Tests for the Catholic Answers metadata indexer."""

import importlib.machinery
import importlib.util
import os
import sys


TOOL_PATH = os.path.abspath(os.path.join(os.path.dirname(__file__), "..", "ca-indexer"))
loader = importlib.machinery.SourceFileLoader("ca_indexer", TOOL_PATH)
spec = importlib.util.spec_from_loader("ca_indexer", loader, origin=TOOL_PATH)
ca_indexer = importlib.util.module_from_spec(spec)
sys.modules[spec.name] = ca_indexer
spec.loader.exec_module(ca_indexer)


SAMPLE_HTML = """
<html>
  <head>
    <title>Why Masturbation Is Wrong | Catholic Answers</title>
    <meta property="og:title" content="Why Masturbation Is Wrong" />
    <meta name="author" content="Catholic Answers Staff" />
    <meta property="article:published_time" content="2023-02-01T00:00:00Z" />
    <link rel="canonical" href="https://www.catholic.com/qa/why-masturbation-is-wrong" />
  </head>
  <body>
    <main>
      <p>Question: Why is masturbation wrong?</p>
      <p>Answer: Catholic moral theology holds that sexual acts belong within marriage and must respect their procreative and unitive meanings. See CCC 2352 and 1 Cor 6:18-20. Trent is not the key source here.</p>
      <a href="/qa/how-do-i-get-started-studying-apologetics">Related</a>
      <a href="https://www.catholic.com/tract/answers-for-non-catholics">Tract</a>
    </main>
  </body>
</html>
"""


def test_normalize_url_strips_www_and_query():
    url = "https://www.catholic.com/qa/foo?x=1#bar"
    assert ca_indexer.normalize_url(url) == "https://catholic.com/qa/foo"


def test_supported_content_url():
    assert ca_indexer.is_supported_content_url("https://catholic.com/qa/foo")
    assert ca_indexer.is_supported_content_url("https://catholic.com/tract/bar")
    assert not ca_indexer.is_supported_content_url("https://catholic.com/qa")
    assert not ca_indexer.is_supported_content_url("https://example.com/qa/foo")


def test_detect_source_type():
    assert ca_indexer.detect_source_type("https://catholic.com/qa/foo") == "qa"
    assert ca_indexer.detect_source_type("https://catholic.com/tract/foo") == "tract"


def test_discover_links_filters_to_supported_content():
    links = ca_indexer.discover_links("https://www.catholic.com/qa", SAMPLE_HTML)
    assert "https://catholic.com/qa/how-do-i-get-started-studying-apologetics" in links
    assert "https://catholic.com/tract/answers-for-non-catholics" in links


def test_extract_citations():
    text = "See CCC 2352, 1 Cor 6:18-20, and the Council of Trent."
    citations = ca_indexer.extract_citations(text)
    types = {item["type"] for item in citations}
    assert "CCC" in types
    assert "Scripture" in types
    assert "Council" in types


def test_parse_page_extracts_metadata():
    record = ca_indexer.parse_page("https://www.catholic.com/qa/why-masturbation-is-wrong", SAMPLE_HTML)
    assert record.source_org == "Catholic Answers"
    assert record.source_type == "qa"
    assert record.title == "Why Masturbation Is Wrong"
    assert record.author == "Catholic Answers Staff"
    assert record.question_text == "Why is masturbation wrong?"
    assert "Catholic moral theology holds" in record.answer_summary
    assert record.canonical_url == "https://catholic.com/qa/why-masturbation-is-wrong"
    assert record.content_hash
