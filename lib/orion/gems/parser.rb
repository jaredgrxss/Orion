# frozen_string_literal: true

# lib/orion/gems/parser.rb

require "json"
require "bundler"
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
    end
  end
end
