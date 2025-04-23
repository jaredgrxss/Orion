# frozen_string_literal: true

require_relative "orion/version"
require_relative "orion/cli/root"

# Main module for Orion, starts up the CLI interface
# With arguments passed upon invoking the exe (i.e orion <subcommand> command)
module Orion
  class Error < StandardError; end

  # CLI entry point - invoked from bin/orion
  def self.run(args = ARGV)
    Orion::CLI::Root.start(args)
  end
end
