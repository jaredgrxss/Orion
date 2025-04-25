# frozen_string_literal: true

# lib/orion/gems/security.rb

require "bundler/audit/scanner"

module Orion
  module Gems
    class Security
      def initialize(lockfile:)
        @lockfile = lockfile
        @lockfile_dir = Pathname.new(@lockfile).dirname.to_s
        @scan_results = nil

        begin
          Bundler::Audit::Database.new
        rescue ArgumentError
          puts "Advisory DB not found. Attempting to update..."
          Bundler::Audit::Database.update!
        end
      end

      def scan!
        return @scan_results if @scan_results

        scanner = Bundler::Audit::Scanner.new(@lockfile_dir)
        @scan_results = scanner.scan
      end

      def vulnerable_gems_map
        scan!.each_with_object({}) do |result, hash|
          hash[result.gem.name] = true
        end
      end

      def detailed_vulnerabilities
        scan!.map do |result|
          {
            name: result.gem.name,
            advisory: result.advisory.title,
            cve: result.advisory.cve || "N/A",
            url: result.advisory.url || "N/A",
            patched_versions: result.advisory.patched_versions.map(&:to_s)
          }
        end
      end
    end
  end
end
