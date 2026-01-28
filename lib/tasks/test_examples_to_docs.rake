##
# Rake task to extract test examples and add them to code documentation.
# Reads RSpec test files and generates @example tags for YARD documentation.
#
namespace :doc do
  desc "Extract examples from tests and update documentation"
  task extract_test_examples: :environment do
    require "fileutils"
    require_relative "../test_example_extractor"

    puts "=" * 80
    puts "Extracting test examples for documentation..."
    puts "=" * 80

    extractor = TestExampleExtractor.new
    examples = extractor.extract_all_examples

    puts "\nFound #{examples.size} test examples"
    puts "Updating source files with @example tags..."

    examples.each do |example|
      extractor.add_example_to_source(example)
    end

    puts "✅ Test examples added to source documentation"
    puts "   Run 'bundle exec rake doc:generate' to regenerate YARD docs"
  end

  desc "Generate documentation with test examples"
  task generate_with_examples: [ :extract_test_examples, :generate ] do
    puts "\n✅ Documentation generated with test examples"
  end
end
