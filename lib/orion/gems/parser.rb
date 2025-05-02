# frozen_string_literal: true

require "json"
require "bundler"
require "fileutils"
require_relative "security"

module Orion
  module Gems
    class Parser
      def initialize(lockfile:, include_dev: false)
        @lockfile = lockfile
        @include_dev = include_dev
      end

      def run
        content = File.read(@lockfile)
        parser = Bundler::LockfileParser.new(content)
        security = Orion::Gems::Security.new(lockfile: @lockfile)

        vuln_map = security.vulnerable_gems_map
        vulnerabilities = security.detailed_vulnerabilities

        analyzed_gems = parser.specs.map do |spec|
          {
            name: spec.name,
            version: spec.version.to_s,
            source: spec.source.to_s,
            secure: vuln_map[spec.name] ? "❌" : "✅"
          }
        end

        [analyzed_gems, vulnerabilities]
      end

      def gems_to_json(gems, vulns, include_vulns: false)
        data = {
          gems: gems,
          total: {
            gems: gems.size
          }
        }
        if include_vulns
          data[:vulnerabilities] = vulns
          data[:total][:vulnerabilities] = vulns.size
        end

        JSON.pretty_generate(data)
      end

      def export_gem_report(gems, vulns, include_vulns: false, filename: "orion_gem_report.json")
        dir = File.join(Dir.pwd, "orion-report")
        FileUtils.mkdir_p(dir) unless Dir.exist?(dir)

        data = gems_to_json(gems, vulns, include_vulns: include_vulns)
        path = File.join(dir, filename)

        File.write(path, data)
        path
      end
    end
  end
end
