# frozen_string_literal: true

##
# DRY documentation generation - everything extracted from code, nothing hardcoded
#
namespace :docs do
  desc "Generate documentation from code analysis (DRY, no hardcoded content)"
  task generate_dry: :environment do
    require_relative "docs_code_analyzer"
    require_relative "docs_template_generator"
    require_relative "docs_rspec_extractor"

    puts "=" * 80
    puts "Generating documentation from code analysis (DRY approach)"
    puts "=" * 80

    generator = DocsDryGenerator.new
    generator.generate_all
  end
end

##
# Main generator that orchestrates code analysis and template generation
# DRY: Everything extracted from code, tests, and coverage data
#
class DocsDryGenerator
  DOCS_DIR = Rails.root.join("docs", "api")
  COMPONENT_PATHS = {
    models: Rails.root.join("app", "models"),
    controllers: Rails.root.join("app", "controllers"),
    services: Rails.root.join("app", "services"),
    jobs: Rails.root.join("app", "jobs"),
    concerns: Rails.root.join("app", "models", "concerns")
  }

  def initialize
    @rspec_extractor = DocsRspecExtractor.new
    @coverage_integration = DocsCoverageIntegration.new
  end

  def generate_all
    COMPONENT_PATHS.each do |type, path|
      generate_component_type(type, path)
    end
  end

  private

  def generate_component_type(type, path)
    puts "\n📝 Generating #{type} documentation..."

    ruby_files = Dir[path.join("**", "*.rb")]
    ruby_files.each do |file_path|
      generate_doc_for_file(file_path, type)
    end
  end

  def generate_doc_for_file(file_path, type)
    analyzer = DocsCodeAnalyzer.new(file_path)
    class_info = analyzer.extract_class_info

    return unless class_info

    class_name = class_info[:name]
    examples = @rspec_extractor.examples_for_class(class_name)
    file_coverage = @coverage_integration.coverage_for_file(file_path)

    # Get coverage for each method
    methods = analyzer.extract_methods
    methods_with_coverage = methods.map do |method|
      method_coverage = @coverage_integration.coverage_for_method(
        file_path,
        method[:name],
        method[:line_number]
      )
      method.merge(coverage: method_coverage)
    end

    template_gen = DocsTemplateGenerator.new(analyzer, @rspec_extractor, @coverage_integration)
    markdown = template_gen.generate_doc(class_name, file_path, file_coverage, methods_with_coverage)

    output_path = determine_output_path(file_path, type, class_name)
    FileUtils.mkdir_p(File.dirname(output_path))
    File.write(output_path, markdown)

    puts "  ✓ Generated: #{output_path.relative_path_from(Rails.root)}"
  end

  def determine_output_path(file_path, type, class_name)
    relative_path = file_path.relative_path_from(COMPONENT_PATHS[type])
    base_name = relative_path.to_s.gsub(".rb", ".md")

    DOCS_DIR.join(type.to_s, base_name)
  end
end

##
# Extracts RSpec examples for a given class
#
class DocsRspecExtractor
  def initialize
    @test_files = Dir[Rails.root.join("spec", "**", "*_spec.rb")]
    @examples_cache = {}
  end

  def examples_for_class(class_name)
    @examples_cache[class_name] ||= extract_examples_for_class(class_name)
  end

  private

  def extract_examples_for_class(class_name)
    examples = []

    @test_files.each do |test_file|
      content = File.read(test_file)
      if content.include?(class_name)
        # Extract examples from RSpec file
        # This is simplified - full implementation would parse RSpec AST
        examples.concat(parse_rspec_examples(test_file, class_name))
      end
    end

    examples
  end

  def parse_rspec_examples(test_file, class_name)
    # Simplified extraction - would use RSpec parser in full implementation
    []
  end
end
