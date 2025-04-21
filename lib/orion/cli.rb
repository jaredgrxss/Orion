require "thor"
require_relative "cli/analyze"

module Orion 
  class CLI < Thor 
    desc "analyze SUBCOMMAND ...ARGS", "Analyze code or gem dependencies"
    subcommand "analyze", Orion::CLI::Analyze
  end
end
