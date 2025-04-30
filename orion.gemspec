# frozen_string_literal: true

require_relative "lib/orion/version"

Gem::Specification.new do |spec|
  spec.name = "orion"
  spec.version = Orion::VERSION
  spec.authors = ["Jared"]
  spec.email = ["jaredgrossthe@gmail.com"]

  spec.summary = "An advanced code and dependency analzyer for Ruby projects."
  spec.description = "Orion is intended to be used for various parts of your ruby application lifecyle. From dependency analsis, code quality and formatting checks, to visualizing and syncing dependencies across your project. Orion aims to be a versatile solution to most ruby project problems."
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["source_code_uri"] = "https://github.com/jaredgrxss/orion"
  spec.metadata["changelog_uri"] = "https://github.com/jaredgrxss/orion/blog/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bundler", ">= 2.0", "< 3.0"
  spec.add_dependency "bundler-audit", ">= 0.9.0", "< 1.0"
  spec.add_dependency "pastel", "~> 0.8"
  spec.add_dependency "thor", "~> 1.3.2"
  spec.add_dependency "tty-table", "~> 0.12"
end
