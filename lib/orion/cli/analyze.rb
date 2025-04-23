# frozen_string_literal: true

# lib/orion/cli/analyze.rb
require "thor"
require_relative "../gems/analyzer"
require_relative "../helpers/table_renderer"

module Orion
  module CLI
    # Subcommand that will handle analysis of code / gems
    class Analyze < Thor
      desc "gems", "Analyze gem dependencies"
      option :lockfile, type: :string, default: "Gemfile.lock", aliases: "-l", desc: "Path relative to your cwd for the Gemfile.lock to be parsed"
      option :format, type: :string, default: "table", enum: %w[table json], aliases: "-f", desc: "Specific formatting for results, default is table"
      option :include_dev, type: :boolean, default: false, aliases: "-d", desc: "Include development and test gems"

      def gems
        analyzer = Orion::Gems::Analyzer.new(lockfile: options[:lockfile])
        result = analyzer.run

        case options[:format]
        when "json"
          puts JSON.pretty_generate(result)
        else
          puts Orion::Helpers::TableRenderer.render(rows: result)
          puts "\nAnalyzed #{result.size} gems"
        end
      end
    end
  end
end
