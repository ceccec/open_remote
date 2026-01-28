##
# Rake tasks to run tests and generate documentation together.
# Links test results to documentation generation.
#
namespace :test do
  desc "Run all tests and generate documentation"
  task doc: :environment do
    puts "=" * 80
    puts "Running test suite..."
    puts "=" * 80

    # Run RSpec tests
    rspec_result = system("bundle exec rspec")
    unless rspec_result
      puts "\n⚠️  Tests failed. Documentation will still be generated."
    end

    puts "\n" + "=" * 80
    puts "Generating YARD documentation..."
    puts "=" * 80

    # Generate YARD documentation
    require "yard"
    YARD::CLI::CommandParser.run("doc", [ "--no-cache" ])

    puts "\n" + "=" * 80
    puts "✅ Documentation generated in doc/ directory"
    puts "=" * 80
  end

  desc "Run tests, check coverage, and generate documentation"
  task coverage_doc: :environment do
    puts "=" * 80
    puts "Running test suite with coverage..."
    puts "=" * 80

    # Run RSpec with coverage
    rspec_result = system("COVERAGE=true bundle exec rspec")

    puts "\n" + "=" * 80
    puts "Generating YARD documentation..."
    puts "=" * 80

    # Generate YARD documentation
    require "yard"
    YARD::CLI::CommandParser.run("doc", [ "--no-cache" ])

    puts "\n" + "=" * 80
    puts "✅ Documentation generated in doc/ directory"
    puts "📊 Coverage report available at coverage/index.html"
    puts "📚 API documentation available at doc/index.html"
    puts "=" * 80
  end
end
