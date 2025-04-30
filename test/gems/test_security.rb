# frozen_string_literal: true

require "minitest/autorun"
require "test_helper"
require "ostruct"
require "orion/gems/security"

class SecurityTest < Minitest::Test
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

  def stub_scan_with_results(results)
    scanner = Minitest::Mock.new
    scanner.expect(:scan, results)

    Bundler::Audit::Scanner.stub(:new, scanner) do
      Bundler::Audit::Database.stub(:new, nil) do
        yield
      end
    end
  end

  def test_vulnerable_gem_map_with_known_vulns
    result = OpenStruct.new(gem: OpenStruct.new(name: "rails"))
    stub_scan_with_results([result]) do
      security = Orion::Gems::Security.new(lockfile: @tempfile)
      gem_map = security.vulnerable_gems_map
      expected_gem_map = { "rails" => true }
      assert_equal expected_gem_map, gem_map
    end
  end

  def test_vulnerable_gem_map_with_no_vulns
    stub_scan_with_results([]) do
      security = Orion::Gems::Security.new(lockfile: @tempfile)
      gem_map = security.vulnerable_gems_map
      assert_equal({}, gem_map)
    end
  end

  def test_detailed_vulnerabilities_with_known_vulns
    result = OpenStruct.new(
      gem: OpenStruct.new(name: "rack"),
      advisory: OpenStruct.new(
        title: "Remote Code Execution",
        cve: "CVE-2020-1234",
        url: "https://example.com",
        patched_versions: ["2.2.4"]
      )
    )

    stub_scan_with_results([result]) do
      security = Orion::Gems::Security.new(lockfile: @tempfile.path)
      detailed = security.detailed_vulnerabilities

      expected = [{
        name: "rack",
        advisory: "Remote Code Execution",
        cve: "CVE-2020-1234",
        url: "https://example.com",
        patched_versions: ["2.2.4"]
      }]

      assert_equal expected, detailed
    end
  end

  def test_detailed_vulnerabilities_with_no_vulns
    stub_scan_with_results([]) do
      security = Orion::Gems::Security.new(lockfile: @tempfile.path)
      detailed = security.detailed_vulnerabilities
      assert_empty detailed
    end
  end

  def test_scan_should_return_scanned_gemfile
    result = OpenStruct.new(gem: OpenStruct.new(name: "rails"))
    stub_scan_with_results([result]) do
      security = Orion::Gems::Security.new(lockfile: @tempfile.path)
      results = security.scan!
      assert_equal [result], results
    end
  end
end
