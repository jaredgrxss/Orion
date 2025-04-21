# frozen_string_literal: true

require_relative "orion/version"
require_relative "orion/cli/root"

module Orion
  class Error < StandardError; end

  # CLI entry point - invoked from bin/orion 
  def self.run(args = ARGV)
    Orion::CLI::Root.start(args)
  end
end
