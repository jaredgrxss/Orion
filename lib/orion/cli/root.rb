# lib/orion/cli/root.rb
require "thor"
require_relative "analyze"

module Orion
  module CLI
    class Root < Thor
      desc "analyze SUBCOMMAND ...ARGS", "Analyze code or gem dependencies"
      subcommand "analyze", Orion::CLI::Analyze
    end
  end
end
