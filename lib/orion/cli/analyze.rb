# frozen_string_literal: true

require "thor"
require_relative "../gems/parser"
require_relative "../helpers/renderer"

module Orion
  module CLI
    class Analyze < Thor
      desc "gems", "Analyze gem dependencies"
      option :lockfile, type: :string, default: "Gemfile.lock", aliases: "-l", desc: "Path relative to your cwd for the Gemfile.lock to be parsed"
      option :format, type: :string, default: "table", enum: %w[table json], aliases: "-f", desc: "Specific formatting for results, default is table"
      option :include_dev, type: :boolean, default: false, aliases: "-d", desc: "Include development and test gems"
      option :include_vulns, type: :boolean, default: false, aliases: "-v", desc: "Show vulnerable gems, formatted into a separate table"

      def gems
        analyzer = Orion::Gems::Parser.new(
          lockfile: options[:lockfile],
          include_dev: options[:include_dev]
        )

        analyzed_gems, vulnerabilities = analyzer.run

        case options[:format]
        when "json"
          puts JSON.pretty_generate(result)
        else
          puts Orion::Helpers::Renderer.render_table(rows: analyzed_gems)
          puts "\nAnalyzed #{analyzed_gems.size} gems, Found #{vulnerabilities.size} vulnerabilities"

          if options[:include_vulns]
            puts "\nVulnerabilities Found:"
            Orion::Helpers::Renderer.render_list(rows: vulnerabilities)
          end
        end
      end
    end
  end
end
