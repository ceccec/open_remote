# frozen_string_literal: true

##
# Modular, DRY documentation generator
# Extracts everything from code - no hardcoded content
# Composed of reusable modules
#
module DocsModular
  ##
  # Code analyzer module - extracts structure from Ruby files
  #
  module CodeAnalyzer
    def self.analyze_file(file_path)
      content = File.read(file_path)

      {
        class_name: extract_class_name(content),
        methods: extract_methods(content),
        associations: extract_associations(content),
        validations: extract_validations(content),
        includes: extract_includes(content),
        superclass: extract_superclass(content)
      }
    end

    def self.extract_class_name(content)
      # Extract from: class ClassName or module ModuleName
      match = content.match(/^(?:class|module)\s+([A-Z][\w:]+)/)
      match ? match[1] : nil
    end

    def self.extract_methods(content)
      methods = []
      content.scan(/^\s*def\s+(?:self\.)?(\w+)(?:\(([^)]*)\))?/).each do |name, params|
        methods << {
          name: name,
          parameters: parse_parameters(params || ""),
          type: content.match(/def\s+self\.#{name}/) ? :class_method : :instance_method
        }
      end
      methods
    end

    def self.parse_parameters(param_string)
      return [] if param_string.strip.empty?

      params = []
      param_string.split(",").each do |param|
        param = param.strip
        if param.include?("=")
          name, default = param.split("=", 2).map(&:strip)
          params << { name: name, default: default }
        else
          params << { name: param, default: nil }
        end
      end
      params
    end

    def self.extract_associations(content)
      associations = []
      %w[belongs_to has_many has_one].each do |type|
        content.scan(/#{type}\s+:(\w+)/).each do |name|
          associations << { type: type, name: name[0] }
        end
      end
      associations
    end

    def self.extract_validations(content)
      validations = []
      content.scan(/validates\s+:(\w+),\s+presence:\s+true/).each do |attr|
        validations << { type: :presence, attribute: attr[0] }
      end
      content.scan(/validates\s+:(\w+),\s+uniqueness:\s+true/).each do |attr|
        validations << { type: :uniqueness, attribute: attr[0] }
      end
      validations
    end

    def self.extract_includes(content)
      includes = []
      content.scan(/include\s+([A-Z][\w:]+)/).each do |mod|
        includes << mod[0]
      end
      includes
    end

    def self.extract_superclass(content)
      match = content.match(/class\s+\w+\s*<\s*([A-Z][\w:]+)/)
      match ? match[1] : nil
    end
  end

  ##
  # RSpec extractor module - extracts examples from test files
  #
  module RspecExtractor
    def self.extract_examples(class_name)
      examples = []
      test_files = Dir[Rails.root.join("spec", "**", "*_spec.rb")]

      test_files.each do |test_file|
        content = File.read(test_file)
        next unless content.include?(class_name)

        # Extract it blocks
        content.scan(/it\s+["'](.+?)["']\s+do\s+(.+?)end/m).each do |description, code|
          examples << {
            description: description,
            code: code.strip,
            source_file: test_file.relative_path_from(Rails.root).to_s,
            class_name: class_name
          }
        end
      end

      examples
    end

    def self.examples_for_method(method_name, class_name)
      extract_examples(class_name).select do |ex|
        ex[:code].include?(method_name) || ex[:description].downcase.include?(method_name.downcase)
      end
    end
  end

  ##
  # Template builder module - generates markdown from extracted data
  #
  module TemplateBuilder
    def self.build_doc(code_info, examples)
      parts = []

      parts << build_header(code_info)
      parts << build_metadata(code_info, examples)
      parts << build_description(code_info)
      parts << build_methods(code_info, examples)
      parts << build_associations(code_info) if code_info[:associations].any?
      parts << build_validations(code_info) if code_info[:validations].any?
      parts << build_examples(examples) if examples.any?

      parts.compact.join("\n\n")
    end

    def self.build_header(code_info)
      "# #{code_info[:class_name]}\n"
    end

    def self.build_metadata(code_info, examples)
      badges = []
      badges << '<Badge type="info" text="' + component_type(code_info) + '" />'
      badges << '<Badge type="success" text="' + examples.count.to_s + ' Examples" />' if examples.any?
      badges.join(" ") + "\n"
    end

    def self.build_description(code_info)
      return nil unless code_info[:superclass]

      <<~MARKDOWN
        ::: tip Inheritance

        Inherits from `#{code_info[:superclass]}`.

        :::
      MARKDOWN
    end

    def self.build_methods(code_info, examples)
      return nil if code_info[:methods].empty?

      parts = [ "## Methods\n" ]

      code_info[:methods].each do |method|
        method_examples = RspecExtractor.examples_for_method(method[:name], code_info[:class_name])
        parts << build_method_doc(method, method_examples)
      end

      parts.join("\n\n")
    end

    def self.build_method_doc(method, examples)
      parts = []
      parts << "### `#{method[:name]}`"
      parts << "**Signature:** `#{build_signature(method)}`"

      if method[:parameters].any?
        parts << build_parameters_table(method[:parameters])
      end

      if examples.any?
        parts << "**Examples:**"
        examples.each do |ex|
          parts << "```ruby"
          parts << ex[:code]
          parts << "```"
          parts << "<small>_Source: `#{ex[:source_file]}`_</small>"
        end
      end

      parts.join("\n\n")
    end

    def self.build_signature(method)
      params = method[:parameters].map do |p|
        p[:default] ? "#{p[:name]} = #{p[:default]}" : p[:name]
      end.join(", ")

      "#{method[:type] == :class_method ? 'self.' : ''}#{method[:name]}(#{params})"
    end

    def self.build_parameters_table(parameters)
      table = [ "| Name | Default |", "|------|---------|" ]
      parameters.each do |param|
        table << "| `#{param[:name]}` | #{param[:default] || '_required_'} |"
      end
      table.join("\n")
    end

    def self.build_associations(code_info)
      return nil if code_info[:associations].empty?

      table = [ "## Associations\n", "| Type | Name |", "|------|------|" ]
      code_info[:associations].each do |assoc|
        table << "| `#{assoc[:type]}` | `#{assoc[:name]}` |"
      end
      table.join("\n")
    end

    def self.build_validations(code_info)
      return nil if code_info[:validations].empty?

      parts = [ "## Validations\n" ]
      code_info[:validations].each do |val|
        parts << "- **#{val[:type]}:** `#{val[:attribute]}`"
      end
      parts.join("\n")
    end

    def self.build_examples(examples)
      return nil if examples.empty?

      parts = [ "## Examples\n" ]
      examples.each do |ex|
        parts << "### #{ex[:description]}"
        parts << "```ruby"
        parts << ex[:code]
        parts << "```"
        parts << "<small>_Source: `#{ex[:source_file]}`_</small>"
      end
      parts.join("\n\n")
    end

    def self.component_type(code_info)
      code_info[:superclass] ? "Model" : "Module"
    end
  end

  ##
  # Main generator - orchestrates the modules
  #
  class Generator
    def initialize
      @component_paths = {
        models: Rails.root.join("app", "models"),
        controllers: Rails.root.join("app", "controllers"),
        services: Rails.root.join("app", "services"),
        jobs: Rails.root.join("app", "jobs"),
        concerns: Rails.root.join("app", "models", "concerns")
      }
    end

    def generate_all
      @component_paths.each do |type, path|
        generate_component_type(type, path)
      end
    end

    private

    def generate_component_type(type, path)
      puts "\n📝 Generating #{type} documentation (DRY approach)..."

      ruby_files = Dir[path.join("**", "*.rb")]
      ruby_files.each do |file_path|
        generate_doc_for_file(file_path, type)
      end
    end

    def generate_doc_for_file(file_path, type)
      code_info = CodeAnalyzer.analyze_file(file_path)
      return unless code_info[:class_name]

      examples = RspecExtractor.extract_examples(code_info[:class_name])
      markdown = TemplateBuilder.build_doc(code_info, examples)

      output_path = determine_output_path(file_path, type, code_info[:class_name])
      FileUtils.mkdir_p(File.dirname(output_path))
      File.write(output_path, markdown)

      puts "  ✓ Generated: #{output_path.relative_path_from(Rails.root)}"
    end

    def determine_output_path(file_path, type, class_name)
      relative_path = file_path.relative_path_from(@component_paths[type])
      base_name = relative_path.to_s.gsub(".rb", ".md")

      Rails.root.join("docs", "api", type.to_s, base_name)
    end
  end
end
