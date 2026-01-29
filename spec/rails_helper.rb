unless ENV["NO_COVERAGE"]
  require "simplecov"

  SimpleCov.start "rails" do
    add_filter "/spec/"
    add_filter "/app/models/concerns/admin/" # RailsAdmin configuration DSL, not business logic
    add_filter "/app/jobs/application_job.rb" # Rails boilerplate base class
    add_filter "/app/mailers/application_mailer.rb" # Rails boilerplate base class
    add_filter "/app/helpers/application_helper.rb" # Rails boilerplate helper (empty)
    # Require 100% coverage - all code must be tested
    minimum_coverage 100
  end
end

ENV["RAILS_ENV"] ||= "test"

require File.expand_path("../config/environment", __dir__)

abort("The Rails environment is running in production mode!") if Rails.env.production?

require "rspec/rails"

Dir[Rails.root.join("spec", "support", "**", "*.rb")].sort.each { |f| require f }

RSpec.configure do |config|
  # Ensure all tests use database transactions
  # This wraps each test in a database transaction that rolls back after the test completes
  # All tests (model, controller, feature, system) go through the database
  config.use_transactional_fixtures = true

  # Ensure database connection is established before running tests
  config.before(:suite) do
    ActiveRecord::Base.connection
  end

  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.include FactoryBot::Syntax::Methods if defined?(FactoryBot)
  config.include ActiveJob::TestHelper

  # Generate documentation after test suite completes
  config.after(:suite) do
    if ENV["GENERATE_DOCS"] != "false"
      puts "\n" + "=" * 80
      puts "Generating documentation..."
      puts "=" * 80

      # Generate YARD documentation
      begin
        result = system("bundle exec yard doc --no-cache --quiet")
        if result
          puts "✅ YARD documentation generated in doc/ directory"
        else
          puts "⚠️  YARD documentation generation failed (exit code: #{$CHILD_STATUS.exitstatus})"
        end
      rescue StandardError => e
        puts "⚠️  YARD documentation generation failed: #{e.message}"
      end

      # Generate VitePress documentation from components and tests
      begin
        docs_generator_path = Rails.root.join("lib", "tasks", "docs_generator.rb")
        if File.exist?(docs_generator_path)
          require docs_generator_path.to_s
          generator = DocsGenerator.new
          generator.generate
          puts "✅ VitePress documentation generated in docs/ directory"
          puts "   Run 'npm run docs:dev' to view documentation"
        else
          puts "⚠️  VitePress docs generator not found at #{docs_generator_path}"
        end
      rescue LoadError, StandardError => e
        puts "⚠️  VitePress documentation generation failed: #{e.message}"
        puts "   Run 'bundle exec rake docs:from_tests' manually to generate docs"
      end

      # Generate all comprehensive documentation
      begin
        comprehensive_docs_path = Rails.root.join("lib", "tasks", "docs_generator_comprehensive.rb")
        if File.exist?(comprehensive_docs_path)
          require comprehensive_docs_path.to_s
          generator = ComprehensiveDocsGenerator.new
          generator.generate_all
          puts "✅ All documentation generated (README, features, interactions, capabilities, architecture)"
        end
      rescue LoadError, StandardError => e
        puts "⚠️  Comprehensive documentation generation failed: #{e.message}"
        puts "   Run 'bundle exec rake docs:generate_all' manually to generate docs"
      end
    end
  end
end
