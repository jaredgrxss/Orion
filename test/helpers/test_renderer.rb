# frozen_string_literal: true

require "minitest/autorun"
require "test_helper"
require "orion/helpers/renderer"

class RendererTest < Minitest::Test
  def test_render_table
    rows = [
      { name: "Test", version: "1.0.0" },
      { name: "Another", version: "2.0.0" }
    ]

    output = Orion::Helpers::Renderer.render_table(rows: rows)

    assert_includes output, "Test"
    assert_includes output, "1.0.0"
    assert_includes output, "Another"
    assert_includes output, "2.0.0"
  end

  def test_render_table_with_no_data
    output = Orion::Helpers::Renderer.render_table(rows: [])
    assert_equal "(no data)", output
  end

  def test_render_table_first_json_determines_headers
    rows = [
      { name: "Test", version: "1.0.0", secure: "true" },
      { name: "Another", version: "2.0.0" },
      { name: "Another again" }
    ]

    output = Orion::Helpers::Renderer.render_table(rows: rows)

    assert_includes output, "Test"
    assert_includes output, "1.0.0"
    assert_includes output, "true"
    assert_includes output, "Another"
    assert_includes output, "2.0.0"
    assert_includes output, "Another again"
    assert_includes output, "-"
  end

  def test_render_list_with_no_data
    output = Orion::Helpers::Renderer.render_list(rows: [])
    assert_equal output, "(no data)"
  end

  def test_render_list_with_data
    rows = [
      { name: "Example", cve: "CVE-2024-0001", url: "http://example.com" }
    ]

    output, _err = capture_io do
      Orion::Helpers::Renderer.render_list(rows: rows)
    end

    assert_includes output, "Example"
    assert_includes output, "CVE-2024-0001"
    assert_includes output, "http://example.com"
  end
end
