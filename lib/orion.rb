# frozen_string_literal: true

require_relative "orion/version"
require_relative "orion/cli"

module Orion
  class Error < StandardError; end

  # CLI entry point - invoked from bin/orion 
  def self.run(args = ARGV)
    Orion::CLI.start(args)
  end
end
