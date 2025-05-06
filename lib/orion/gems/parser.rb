# frozen_string_literal: true

require "json"
require "csv"
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

      def gems_to_csv(gems, vulns, include_vulns: false)
        CSV.generate(headers: true) do |csv|
          if include_vulns
            csv << [
              "Gem", "Version", "Source", "Secure",
              "Advisories", "CVEs", "URLs", "Patched Versions"
            ]

            gems.each do |gem|
              gem_vulns = vulns.select { |v| v[:name] == gem[:name] }
              advisories = gem_vulns.map { |v| v[:advisory] }.join(" | ")
              cves = gem_vulns.map { |v| v[:cve] }.compact.join(" | ")
              urls = gem_vulns.map { |v| v[:url] }.compact.join(" | ")
              patched_versions = gem_vulns.flat_map { |v| v[:patched_versions] }.compact.uniq.join(" | ")
              csv << [
                gem[:name], gem[:version], gem[:source], gem[:secure],
                advisories, cves, urls, patched_versions
              ]
            end
          else
            csv << %w[Gem Version Source Secure]
            gems.each do |gem|
              csv << [gem[:name], gem[:version], gem[:source], gem[:secure]]
            end
          end
        end
      end

      def write_out(dir, filename, data)
        path = File.join(dir, filename)
        File.write(path, data)
        path
      end

      def export_gem_report(gems, vulns, include_vulns: false, filename: "orion_gem_report", type: "json")
        dir = File.join(Dir.pwd, "orion-report")
        FileUtils.mkdir_p(dir) unless Dir.exist?(dir)

        case type
        when "json"
          data = gems_to_json(gems, vulns, include_vulns: include_vulns)
          write_out(dir, "#{filename}.json", data)
        when "csv"
          data = gems_to_csv(gems, vulns, include_vulns: include_vulns)
          write_out(dir, "#{filename}.csv", data)
        end
      end
    end
  end
end
