# frozen_string_literal: true

require "minitest/autorun"
require "test_helper"
require "orion/cli/analyze"

class AnalyzeCLITest < Minitest::Test
  def setup
    @mock_data = [
      [
        [{ name: "rails", version: "6.1.0", source: "rubygems", secure: "❌" }],
        [{ name: "rails", advisory: "Critical vuln", cve: "CVE-123", url: "https://example.com", patched_versions: [">= 6.1.1"] }]
      ],
      [
        [{ name: "rack", version: "2.2.3", source: "rubygems", secure: "✅" }],
        []
      ]
    ]
  end

  def test_gems_command_without_included_vulns
    stubbed_parser = StubbedParser.new(*@mock_data[1])
    Orion::Gems::Parser.stub(:new, ->(*, **) { stubbed_parser }) do
      output = capture_stdout do
        Orion::CLI::Analyze.start(%w[gems --format table])
      end

      assert_includes output, "Analyzed 1 gems, Found 0 vulnerabilities"
      assert_includes output, "rack"
      refute_includes output, "Vulnerabilities Found"
    end
  end

  def test_gems_commad_with_included_vulns
    Orion::Gems::Parser.stub :new, ->(**_) { StubbedParser.new(*@mock_data[0]) } do
      output = capture_stdout do
        Orion::CLI::Analyze.start(%w[gems --format table --include-vulns])
      end

      assert_includes output, "rails"
      assert_includes output, "Analyzed 1 gems, Found 1 vulnerabilities"
      assert_includes output, "CVE-123"
      assert_includes output, "https://example.com"
    end
  end

  class StubbedParser
    def initialize(analyed_gems, vulnerabilities)
      @analyzed_gems = analyed_gems
      @vulnerabilities = vulnerabilities
    end

    def run
      [@analyzed_gems, @vulnerabilities]
    end
  end

  def capture_stdout
    out = StringIO.new
    # necessary stub to ensure cross compatibility with windows and linux
    TTY::Screen.stub(:width, 80) do
      $stdout = out
      yield
    ensure
      $stdout = STDOUT
    end
    out.string
  end
end
