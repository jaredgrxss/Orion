# frozen_string_literal: true

require "minitest/autorun"
require "test_helper"
require "orion/gems/parser"

class ParserTest < Minitest::Test
  def setup
    @tempfile = Tempfile.new("Gemfile.lock")
    @tempfile.write <<~LOCKFILE
      GEM
        remote: https://rubygems.org/
        specs:
          rails (6.1.0)
          rack (2.2.3)

      DEPENDENCIES
        rails
        rack

      BUNDLED WITH
        2.2.3
    LOCKFILE
    @tempfile.flush
  end

  def teardown
    @tempfile.close
    @tempfile.unlink
  end

  def test_parsing_lockfile_with_vulns
    security_mock = Minitest::Mock.new
    security_mock.expect :vulnerable_gems_map, { "rails" => true }
    security_mock.expect :detailed_vulnerabilities, [{ name: "rails", cve: "CVE-1234" }]

    Orion::Gems::Security.stub :new, security_mock do
      parser = Orion::Gems::Parser.new(lockfile: @tempfile)
      analyzed_gems, vulnerabilities = parser.run

      assert_equal 2, analyzed_gems.size

      rails_gem = analyzed_gems.find { |g| g[:name] == "rails" }
      rack_gem = analyzed_gems.find { |g| g[:name] == "rack" }

      assert_equal "❌", rails_gem[:secure]
      assert_equal "✅", rack_gem[:secure]

      assert_equal [{ name: "rails", cve: "CVE-1234" }], vulnerabilities
    end
  end

  def test_parsing_lockfile_with_no_vulns
    security_mock = Minitest::Mock.new
    security_mock.expect :vulnerable_gems_map, {}
    security_mock.expect :detailed_vulnerabilities, []

    Orion::Gems::Security.stub :new, security_mock do
      parser = Orion::Gems::Parser.new(lockfile: @tempfile)
      analyzed_gems, vulnerabilities = parser.run

      assert_equal 2, analyzed_gems.size

      analyzed_gems.each do |gem|
        assert_equal "✅", gem[:secure]
      end

      assert_empty vulnerabilities
    end
  end

  def test_parsing_for_json
    security_mock = Minitest::Mock.new
    security_mock.expect :vulnerable_gems_map, { "rails" => true }
    security_mock.expect :detailed_vulnerabilities, [{ name: "rails", cve: "CVE-1234" }]

    Orion::Gems::Security.stub :new, security_mock do
      parser = Orion::Gems::Parser.new(lockfile: @tempfile)
      analyzed_gems, vulnerabilities = parser.run

      assert_equal 2, analyzed_gems.size
      assert_equal 1, vulnerabilities.size

      json_obj = parser.gems_to_json(analyzed_gems, vulnerabilities, include_vulns: false)
      parsed = JSON.parse(json_obj)

      assert_equal 2, parsed["gems"].size
      refute parsed.key?("vulnerabilities")
      assert_equal 2, parsed["total"]["gems"]
      refute parsed["total"].key?("vulnerabilities")
    end
  end

  def test_parsing_for_json_with_vulns
    security_mock = Minitest::Mock.new
    security_mock.expect :vulnerable_gems_map, { "rails" => true }
    security_mock.expect :detailed_vulnerabilities, [{ name: "rails", cve: "CVE-1234" }]

    Orion::Gems::Security.stub :new, security_mock do
      parser = Orion::Gems::Parser.new(lockfile: @tempfile)
      analyzed_gems, vulnerabilities = parser.run

      assert_equal 2, analyzed_gems.size
      assert_equal 1, vulnerabilities.size

      json_obj = parser.gems_to_json(analyzed_gems, vulnerabilities, include_vulns: true)
      parsed = JSON.parse(json_obj)

      assert_equal 2, parsed["gems"].size
      assert_equal 1, parsed["vulnerabilities"].size
      assert_equal 2, parsed["total"]["gems"]
      assert_equal 1, parsed["total"]["vulnerabilities"]
    end
  end

  def test_parsing_for_csv
    security_mock = Minitest::Mock.new
    security_mock.expect :vulnerable_gems_map, {}
    security_mock.expect :detailed_vulnerabilities, []

    Orion::Gems::Security.stub :new, security_mock do
      parser = Orion::Gems::Parser.new(lockfile: @tempfile)
      analyzed_gems, vulnerabilities = parser.run

      csv_output = parser.gems_to_csv(analyzed_gems, vulnerabilities, include_vulns: false)

      assert_includes csv_output, "Gem,Version,Source,Secure"
      assert_includes csv_output, "rails,6.1.0,locally installed gems,✅"
      assert_includes csv_output, "rack,2.2.3,locally installed gems,✅"
      refute_includes csv_output, "CVE"
    end
  end

  def test_parsing_for_csv_with_vulns
    security_mock = Minitest::Mock.new
    security_mock.expect :vulnerable_gems_map, { "rails" => true }
    security_mock.expect :detailed_vulnerabilities, [
      {
        name: "rails",
        advisory: "Critical vuln",
        cve: "CVE-123",
        url: "https://example.com",
        patched_versions: [">= 6.1.1"]
      }
    ]

    Orion::Gems::Security.stub :new, security_mock do
      parser = Orion::Gems::Parser.new(lockfile: @tempfile)
      analyzed_gems, vulnerabilities = parser.run

      csv_output = parser.gems_to_csv(analyzed_gems, vulnerabilities, include_vulns: true)

      assert_includes csv_output, "Gem,Version,Source,Secure,Advisories,CVEs,URLs,Patched Versions"
      assert_includes csv_output, "rails,6.1.0,locally installed gems,❌"
      assert_includes csv_output, "Critical vuln"
      assert_includes csv_output, "CVE-123"
      assert_includes csv_output, "https://example.com"
      assert_includes csv_output, ">= 6.1.1"
    end
  end
end
