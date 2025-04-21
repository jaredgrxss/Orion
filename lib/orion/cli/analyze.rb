# lib/orion/cli/analyze.rb
require "thor"
require_relative "../gems/analyzer"

module Orion
  module CLI 
    class Analyze < Thor
      desc "gems", "Analyze gem dependencies"
      option :lockfile, type: :string, default: "Gemfile.lock", aliases: "-l"
      option :format, type: :string, default: "table", enum: %w[table json], aliases: "-f"

      def gems 
        analyzer = Orion::Gems::Analyzer.new(lockfile: options[:lockfile])
        result = analyzer.run
        
        case options[:format]
        when "json"
          puts JSON.pretty_generate(result)
        else
          puts result.to_s
        end
      end

    end
  end
end
