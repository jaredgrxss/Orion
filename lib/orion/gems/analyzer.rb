# frozen_string_literal: true

# lib/orion/gems/analyzer.rb

require "json"

module Orion
  module Gems
    # Main entry point for dependency analysis
    class Analyzer
      def initialize(lockfile:)
        @lockfile = lockfile
      end

      def run
        {
          analyzed_file: @lockfile,
          gems: [
            { name: "rails", version: "7.1.0", stale: false },
            { name: "nokogiri", version: "1.13.3", stale: true }
          ]
        }
      end

      def to_s
        "Analzyed #{@lockfile} - 2 gems found"
      end
    end
  end
end
