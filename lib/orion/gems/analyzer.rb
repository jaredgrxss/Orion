# frozen_string_literal: true

# lib/orion/gems/analyzer.rb

require "json"
require "bundler"

module Orion
  module Gems
    # Main entry point for dependency analysis
    class Analyzer
      def initialize(lockfile:, include_dev: false)
        @lockfile = lockfile
        @include_dev = include_dev
      end

      def run
        content = File.read(@lockfile)
        parser = Bundler::LockfileParser.new(content)
        parser.specs.map do |spec|
          {
            name: spec.name,
            version: spec.version.to_s,
            source: spec.source.to_s
          }
        end
      end
    end
  end
end
