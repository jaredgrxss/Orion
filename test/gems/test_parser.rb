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
end
