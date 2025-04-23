# frozen_string_literal: true

# lib/orion/cli/root.rb
require "thor"
require_relative "analyze"

module Orion
  module CLI
    # Main class for all top level CLI commands
    # Delegates to subcommands based on the first verb
    class Root < Thor
      desc "analyze SUBCOMMAND ...ARGS", "Analyze code or gem dependencies"
      subcommand "analyze", Orion::CLI::Analyze
    end
  end
end
