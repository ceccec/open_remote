##
# Rake tasks to run tests and generate documentation together.
# Relies on the SimpleCov + after(:suite) hook in spec/rails_helper,
# which generates both:
# - YARD docs into doc/
# - VitePress content + config via DocsGenerator into docs/
#
namespace :test do
  desc "Run all tests and generate documentation"
  task doc: :environment do
    puts "=" * 80
    puts "Running test suite..."
    puts "=" * 80

    # Run RSpec tests with documentation format for structured rich docs content
    # spec/rails_helper will:
    # - enforce coverage via SimpleCov
    # - generate YARD docs
    # - generate VitePress docs (DocsGenerator)
    rspec_result = system("bundle exec rspec --format documentation")
    unless rspec_result
      puts "\n⚠️  Tests failed. Documentation generation may be partial."
    end

    puts "\n" + "=" * 80
    puts "✅ Documentation pipeline finished"
    puts "   YARD docs:   doc/index.html"
    puts "   VitePress docs content + config: docs/"
    puts "=" * 80
  end

  desc "Run tests, check coverage, and generate documentation"
  task coverage_doc: :environment do
    puts "=" * 80
    puts "Running test suite with coverage..."
    puts "=" * 80

    # Run RSpec with coverage and documentation format for structured rich docs content
    # SimpleCov in spec/rails_helper enforces the minimum_coverage gate and triggers
    # doc + VitePress generation.
    rspec_result = system("COVERAGE=true bundle exec rspec --format documentation")

    puts "\n" + "=" * 80
    puts "✅ Coverage + documentation pipeline finished"
    puts "📊 Coverage report available at coverage/index.html"
    puts "📚 YARD API documentation available at doc/index.html"
    puts "📚 VitePress docs content + config available under docs/"
    puts "=" * 80
  end
end
