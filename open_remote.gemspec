require_relative "lib/open_remote/version"

Gem::Specification.new do |spec|
  spec.name          = "open_remote"
  spec.version       = OpenRemote::Version::STRING
  spec.authors       = [ "ceccec" ]
  spec.email         = [ "ceccec@psg.bg" ]

  spec.summary       = "OpenRemote Rails manager as a mountable engine."
  spec.description   = "Rails-based OpenRemote manager packaged as a Rails engine for reuse and deployment."
  spec.homepage      = "https://github.com/ceccec/open_remote"
  spec.license       = "Nonstandard"

  spec.required_ruby_version = ">= 3.3.0"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      f.start_with?("coverage/") ||
        f.start_with?("log/") ||
        f.start_with?("tmp/") ||
        f.start_with?("docs/.vitepress/dist") ||
        f.start_with?("public/")
    end
  end

  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{\Abin/}) { |f| File.basename(f) }
  spec.require_paths = [ "lib" ]

  # Runtime dependencies (mirroring Gemfile)
  spec.add_dependency "rails", ">= 8.1.2", "< 9.0"
  spec.add_dependency "pg", "~> 1.1"
  spec.add_dependency "puma", ">= 5.0", "< 8.0"
  spec.add_dependency "importmap-rails", "~> 2.0"
  spec.add_dependency "turbo-rails", "~> 2.0"
  spec.add_dependency "stimulus-rails", "~> 1.3"
  spec.add_dependency "jbuilder", "~> 2.0"
  spec.add_dependency "solid_cache", "~> 1.0"
  spec.add_dependency "solid_queue", "~> 1.0"
  spec.add_dependency "solid_cable", "~> 1.0"
  spec.add_dependency "bootsnap", "~> 1.16", ">= 1.16.0"
  spec.add_dependency "vite_rails", "~> 3.0"
  spec.add_dependency "rails_admin", "~> 3.3"
  spec.add_dependency "cancancan", "~> 3.0"
  spec.add_dependency "paper_trail", "~> 17.0"
  spec.add_dependency "rolify", "~> 6.0"
  spec.add_dependency "yard", "~> 0.9.38"

  # Development / test dependencies are expected to be provided by the host app,
  # but we keep them here for completeness when working on the engine itself.
  spec.add_development_dependency "rspec-rails", "~> 8.0"
  spec.add_development_dependency "capybara", "~> 3.0"
  spec.add_development_dependency "selenium-webdriver", "~> 4.0"
  spec.add_development_dependency "simplecov", "~> 0.22"
  spec.add_development_dependency "debug", "~> 1.0"
  spec.add_development_dependency "bundler-audit", "~> 0.9"
  spec.add_development_dependency "brakeman", "~> 8.0"
  spec.add_development_dependency "rubocop-rails-omakase", "~> 1.0"
end
