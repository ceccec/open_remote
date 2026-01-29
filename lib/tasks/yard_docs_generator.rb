# frozen_string_literal: true

##
# YARD-based documentation generator.
# Uses YARD to parse code structure and generate VitePress-compatible documentation.
# Much simpler than manual parsing - YARD handles all the heavy lifting.
#
class YardDocsGenerator
  require "yard"

  DOCS_DIR = OpenRemote::Config::DOCS_DIR
  API_DIR = OpenRemote::Config::DOCS_API_DIR
  EXAMPLES_DIR = OpenRemote::Config::DOCS_EXAMPLES_DIR

  def initialize
    @registry = nil
    @coverage_stats = compute_coverage_stats
    @test_stats = compute_test_stats
  end

  ##
  # Compute coverage statistics from SimpleCov results if available
  #
  def compute_coverage_stats
    stats = {
      total_coverage: nil,
      covered_lines: 0,
      total_lines: 0,
      covered_files: 0,
      total_files: 0,
      last_updated: nil
    }

    # Try to read SimpleCov JSON result if available
    coverage_json_path = Rails.root.join("coverage", ".resultset.json")
    if File.exist?(coverage_json_path)
      begin
        require "json"
        coverage_data = JSON.parse(File.read(coverage_json_path))

        # SimpleCov stores data by command name, usually "RSpec"
        rspec_data = coverage_data["RSpec"] || coverage_data.values.first

        if rspec_data
          covered_lines = rspec_data["covered_lines"] || 0
          total_lines = rspec_data["covered_lines"] + (rspec_data["missed_lines"] || 0)

          stats[:covered_lines] = covered_lines
          stats[:total_lines] = total_lines
          stats[:total_coverage] = total_lines > 0 ? ((covered_lines.to_f / total_lines) * 100).round(2) : 0

          # Count files
          coverage_by_file = rspec_data["coverage"] || {}
          stats[:total_files] = coverage_by_file.keys.count
          stats[:covered_files] = coverage_by_file.values.count { |file_data| file_data && file_data.is_a?(Array) && file_data.any? { |line| line && line > 0 } }
        end

        # Get last updated time
        stats[:last_updated] = File.mtime(coverage_json_path).iso8601
      rescue JSON::ParserError, StandardError => e
        # If parsing fails, return empty stats
        Rails.logger.warn("Could not parse coverage data: #{e.message}") if defined?(Rails.logger)
      end
    end

    stats
  end

  ##
  # Compute test statistics from test files
  #
  def compute_test_stats
    test_files = Dir[Rails.root.join("spec", "**", "*_spec.rb")]
    test_files_count = test_files.count

    # Count by type
    test_files_by_type = Hash.new(0)
    test_files.each do |file|
      case file
      when /spec\/models\//
        test_files_by_type[:models] += 1
      when /spec\/controllers\//
        test_files_by_type[:controllers] += 1
      when /spec\/services\//
        test_files_by_type[:services] += 1
      when /spec\/jobs\//
        test_files_by_type[:jobs] += 1
      when /spec\/concerns\//
        test_files_by_type[:concerns] += 1
      when /spec\/mailers\//
        test_files_by_type[:mailers] += 1
      else
        test_files_by_type[:other] += 1
      end
    end

    {
      test_files_count: test_files_count,
      test_files_by_type: test_files_by_type,
      last_computed: Time.current.iso8601
    }
  end

  ##
  # Generate detailed coverage and testing statistics section
  #
  def generate_detailed_stats_section(class_name = nil)
    content = +"::: details 📊 Coverage & Testing Statistics\n\n"

    if @coverage_stats[:total_coverage]
      content << "### Code Coverage\n\n"
      coverage = @coverage_stats[:total_coverage]
      badge_type = coverage >= 100 ? "tip" : coverage >= 90 ? "info" : "warning"
      content << "<Badge type=\"#{badge_type}\" text=\"Coverage: #{coverage}%\" />\n"
      content << "<Badge type=\"info\" text=\"#{@coverage_stats[:covered_lines]}/#{@coverage_stats[:total_lines]} lines\" />\n"
      content << "<Badge type=\"info\" text=\"#{@coverage_stats[:covered_files]}/#{@coverage_stats[:total_files]} files\" />\n\n"
      content << "- **Coverage**: #{@coverage_stats[:total_coverage]}%\n"
      content << "- **Covered Lines**: #{@coverage_stats[:covered_lines]} / #{@coverage_stats[:total_lines]}\n"
      content << "- **Covered Files**: #{@coverage_stats[:covered_files]} / #{@coverage_stats[:total_files]}\n"
      if @coverage_stats[:last_updated]
        content << "- **Last Updated**: #{Time.parse(@coverage_stats[:last_updated]).strftime("%Y-%m-%d %H:%M:%S")}\n"
      end
      content << "\n"
    end

    content << "### Test Suite Statistics\n\n"
    content << "<Badge type=\"tip\" text=\"#{@test_stats[:test_files_count]} test files\" />\n\n"
    content << "- **Total Test Files**: #{@test_stats[:test_files_count]}\n"

    if @test_stats[:test_files_by_type].any?
      content << "\n**Tests by Type:**\n\n"
      @test_stats[:test_files_by_type].sort_by { |_k, v| -v }.each do |type, count|
        content << "- **#{type.to_s.capitalize}**: #{count} test file#{'s' if count != 1}\n"
      end
      content << "\n"
    end

    content << ":::\n\n"
    content
  end

  def generate
    puts "📚 Parsing code with YARD..."
    parse_code

    puts "📝 Generating API documentation..."
    setup_directories
    generate_api_docs_from_yard
    generate_testing_ux_doc
    generate_vitepress_config
  end

  private

  def parse_code
    # Parse all Ruby files with YARD
    # YARD needs to parse files - specify what to parse
    files = Dir[Rails.root.join("app", "**", "*.rb")]
    YARD.parse(files)
    @registry = YARD::Registry
  end

  def setup_directories
    FileUtils.mkdir_p(DOCS_DIR)
    FileUtils.mkdir_p(API_DIR)
    FileUtils.mkdir_p(EXAMPLES_DIR)
    FileUtils.mkdir_p(OpenRemote::Config::DOCS_VITEPRESS_CONFIG_DIR)

    # Create component-specific directories
    %w[models controllers services jobs mailers concerns].each do |type|
      FileUtils.mkdir_p(API_DIR.join(type))
    end
  end

  def generate_api_docs_from_yard
    # Get all classes and modules
    classes = @registry.all(:class)
    modules = @registry.all(:module)

    # Generate docs for classes (models, controllers, jobs, mailers)
    classes.each do |klass|
      next if skip_class?(klass)

      file_path = determine_file_path(klass)
      next unless file_path

      content = generate_class_doc_from_yard(klass)
      FileUtils.mkdir_p(file_path.dirname)
      File.write(file_path, content)
    end

    # Generate docs for modules (concerns)
    modules.each do |mod|
      next if skip_module?(mod)

      file_path = determine_file_path(mod)
      next unless file_path

      content = generate_module_doc_from_yard(mod)
      FileUtils.mkdir_p(file_path.dirname)
      File.write(file_path, content)
    end
  end

  def generate_class_doc_from_yard(klass)
    class_name = klass.path
    # Get docstring, clean it up, or provide default
    docstring = klass.docstring
    docstring = docstring.to_s.strip if docstring
    docstring = "API documentation for #{class_name}" if docstring.nil? || docstring.empty?

    # Get Rails API info from distributed method if available
    rails_api_info = get_rails_api_info(klass)

    # Get methods (public instance and class methods)
    instance_methods = klass.meths(visibility: :public, inherited: false).select { |m| m.scope == :instance }
    class_methods = klass.meths(visibility: :public, inherited: false).select { |m| m.scope == :class }

    # Get associations if ActiveRecord model
    associations = extract_associations_from_yard(klass)

    # Get validations
    validations = extract_validations_from_yard(klass)

    # Get scopes
    scopes = extract_scopes_from_yard(klass)

    # Get included modules/concerns
    includes = extract_includes_from_yard(klass)

    # Compute component type and badge from actual class structure (RailsAdmin-style)
    klass_obj = begin
      klass.path.constantize
    rescue
      nil
    end

    component_type = klass_obj ? compute_component_type(klass_obj) : :concern
    badge_type = component_type == :model ? "tip" : component_type == :controller ? "info" : "warning"

    # Compute SEO-friendly description from docstring and code structure
    seo_description = compute_seo_description(class_name, docstring, component_type, klass_obj, associations, validations, scopes, includes)

    # Compute keywords from code structure
    keywords = compute_keywords(class_name, component_type, klass_obj, associations, validations, scopes, includes, instance_methods, class_methods)

    # Generate VitePress-compatible frontmatter with computed SEO metadata
    content = +"---\n"
    content << "title: #{class_name}\n"
    content << "description: #{seo_description}\n"
    content << "lastUpdated: #{Time.current.iso8601}\n"
    content << "tags:\n"
    content << "  - #{component_type}\n"
    content << "  - api\n"
    if klass_obj && klass_obj.is_a?(Class) && klass_obj < ActiveRecord::Base
      content << "  - activerecord\n"
    end
    # Add computed SEO metadata
    content << "head:\n"
    content << "  - - meta\n"
    content << "    - name: keywords\n"
    content << "      content: #{keywords.join(', ')}\n"
    content << "  - - meta\n"
    content << "    - property: og:title\n"
    content << "      content: #{class_name} - OpenRemote Rails API\n"
    content << "  - - meta\n"
    content << "    - property: og:description\n"
    content << "      content: #{seo_description}\n"
    content << "  - - meta\n"
    content << "    - property: og:type\n"
    content << "      content: website\n"
    content << "---\n\n"

    content << "# #{class_name} <Badge type=\"#{badge_type}\" text=\"#{component_type.to_s.capitalize}\" />\n\n"
    content << "#{docstring}\n\n"

    # Add file path with custom container
    if klass.files.any?
      file_path = klass.files.first.first
      relative_path = file_path.sub(Rails.root.to_s + "/", "")
      content << "::: info File Location\n"
      content << "**Source:** `#{relative_path}`\n"
      content << ":::\n\n"
    end

    # Add Rails API references with custom container
    if rails_api_info
      content << "::: tip Rails Framework\n"
      content << rails_api_info.gsub(/^\*\*Rails Framework References:\*\*/, "**Rails Framework References:**")
      content << ":::\n\n"
    end

    # Add included concerns/modules with custom container
    if includes.any?
      content << "## Included Modules\n\n"
      includes.each do |inc|
        mod_name = inc.is_a?(Array) ? inc.first : inc
        mod_name = mod_name.to_s.gsub(/^\["|"\]$/, "").gsub(/"/, "")
        content << "- <Badge type=\"info\" text=\"Module\" /> `#{mod_name}`\n"
      end
      content << "\n"
    end

    # Add associations with VitePress table formatting
    if associations.any?
      content << "## Associations\n\n"
      content << "<Badge type=\"info\" text=\"#{associations.count} association#{'s' if associations.count != 1}\" />\n\n"
      content << "| Type | Name | Options |\n"
      content << "|------|------|----------|\n"
      associations.each do |assoc|
        opts = ""
        if assoc[:options] && assoc[:options].any?
          opts = assoc[:options].map { |k, v|
            val = v.to_s.gsub(/^:|^"|"$/, "")
            "`#{k}: #{val}`"
          }.join(", ")
        end
        content << "| <Badge type=\"tip\" text=\"#{assoc[:type]}\" /> | `:#{assoc[:name]}` | #{opts} |\n"
      end
      content << "\n"
    end

    # Add validations with VitePress table formatting
    if validations.any?
      content << "## Validations\n\n"
      content << "<Badge type=\"warning\" text=\"#{validations.count} validation#{'s' if validations.count != 1}\" />\n\n"
      content << "| Attribute | Type | Options |\n"
      content << "|-----------|------|----------|\n"
      validations.each do |val|
        opts = ""
        if val[:options] && val[:options].any?
          opts = val[:options].map { |k, v| "`#{k}: #{v.inspect}`" }.join(", ")
        end
        content << "| `:#{val[:attribute]}` | <Badge type=\"info\" text=\"#{val[:type]}\" /> | #{opts} |\n"
      end
      content << "\n"
    end

    # Add scopes with VitePress badges
    if scopes.any?
      content << "## Scopes\n\n"
      content << "<Badge type=\"tip\" text=\"#{scopes.count} scope#{'s' if scopes.count != 1}\" />\n\n"
      scopes.each do |scope|
        content << "- <Badge type=\"tip\" text=\"Scope\" /> `scope :#{scope[:name]}`"
        if scope[:description]
          content << " - #{scope[:description]}"
        end
        content << "\n"
      end
      content << "\n"
    end

    # Add class methods with code groups
    if class_methods.any?
      content << "## Class Methods\n\n"
      content << "::: details View all #{class_methods.count} class method#{'s' if class_methods.count != 1}\n\n"
      class_methods.first(25).each do |meth|
        content << generate_method_doc(meth)
      end
      if class_methods.count > 25
        content << "\n*... and #{class_methods.count - 25} more*\n"
      end
      content << ":::\n\n"
    end

    # Add instance methods with code groups
    if instance_methods.any?
      content << "## Instance Methods\n\n"
      content << "::: details View all #{instance_methods.count} instance method#{'s' if instance_methods.count != 1}\n\n"
      instance_methods.first(25).each do |meth|
        content << generate_method_doc(meth)
      end
      if instance_methods.count > 25
        content << "\n*... and #{instance_methods.count - 25} more*\n"
      end
      content << ":::\n\n"
    end

    # Add examples from YARD @example tags with VitePress custom containers
    examples = klass.tags(:example)
    if examples.any?
      content << "## Examples\n\n"
      content << "<Badge type=\"tip\" text=\"#{examples.count} example#{'s' if examples.count != 1}\" />\n\n"
      examples.each_with_index do |example, idx|
        content << "::: tip #{example.name || "Example #{idx + 1}"}\n"
        content << "```ruby\n#{example.text}\n```\n"
        content << ":::\n\n"
      end
    end

    # Add coverage and testing statistics
    content << generate_detailed_stats_section(class_name)

    # Note about test examples with VitePress alert
    content << "::: info Test Examples\n"
    content << "Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).\n"
    content << ":::\n\n"

    content << "---\n\n"
    content << "<Badge type=\"info\" text=\"Navigation\" /> [← Back to Index](/docs/api/)\n"

    content
  end

  def generate_method_doc(meth)
    content = +"- `#{meth.name}`"

    # Add parameters
    params = meth.tags(:param)
    if params.any?
      param_list = params.map { |p|
        type = p.types&.first || "Object"
        # Remove angle brackets to avoid VitePress HTML parsing issues
        type = type.to_s.gsub(/[<>]/, "")
        "#{p.name}: #{type}"
      }.join(", ")
      content << "(#{param_list})"
    end

    # Add return type
    returns = meth.tags(:return)
    if returns.any?
      return_type = returns.first.types&.first || "Object"
      # Use plain text arrow (not HTML entity)
      content << " -> `#{return_type}`"
    end

    # Add description
    if meth.docstring && !meth.docstring.empty?
      first_line = meth.docstring.split("\n").first.strip
      content << " - #{first_line}"
    end

    content << "\n"
  end

  def generate_module_doc_from_yard(mod)
    module_name = mod.path
    # Get docstring, clean it up, or provide default
    docstring = mod.docstring
    docstring = docstring.to_s.strip if docstring

    # For nested modules, YARD sometimes attaches docstring to parent module
    # Check parent module if this one is empty
    if (docstring.nil? || docstring.empty?) && module_name.include?("::")
      parent_name = module_name.split("::")[0..-2].join("::")
      if parent_name && @registry.at(parent_name)
        parent_docstring = @registry.at(parent_name).docstring
        if parent_docstring && !parent_docstring.empty?
          docstring = parent_docstring.to_s.strip
        end
      end

      # Also try reading source file directly for docstring
      if (docstring.nil? || docstring.empty?) && mod.files.any?
        file_path = mod.files.first.first
        if File.exist?(file_path)
          content = File.read(file_path)
          # Look for YARD docstring before module definition
          # Match ## followed by module name
          if content =~ /##\s*\n\s*#\s*(.+?)\n\s*module\s+#{module_name.split("::").last}/m
            docstring = $1.strip
          elsif content =~ /##\s*\n\s*#\s*(.+?)\n\s*module\s+#{module_name.split("::").last}/m
            docstring = $1.strip
          end
        end
      end
    end

    # Fallback to default
    if docstring.nil? || docstring.empty?
      docstring = "API documentation for #{module_name}"
    end

    # Get Rails API info
    rails_api_info = get_rails_api_info(mod)

    # Get methods (separate class and instance)
    instance_methods = mod.meths(visibility: :public, inherited: false).select { |m| m.scope == :instance }
    class_methods = mod.meths(visibility: :public, inherited: false).select { |m| m.scope == :class }

    # Generate VitePress-compatible frontmatter for modules
    content = +"---\n"
    content << "title: #{module_name}\n"
    content << "description: #{docstring.split("\n").first.strip}\n"
    content << "lastUpdated: #{Time.current.iso8601}\n"
    content << "tags:\n"
    content << "  - concern\n"
    content << "  - api\n"
    content << "  - module\n"
    content << "---\n\n"

    content << "# #{module_name} <Badge type=\"warning\" text=\"Concern\" />\n\n"
    content << "#{docstring}\n\n"

    # Add file path with custom container
    if mod.files.any?
      file_path = mod.files.first.first
      relative_path = file_path.sub(Rails.root.to_s + "/", "")
      content << "::: info File Location\n"
      content << "**Source:** `#{relative_path}`\n"
      content << ":::\n\n"
    end

    # Add Rails API references with custom container
    if rails_api_info
      content << "::: tip Rails Framework\n"
      content << rails_api_info.gsub(/^\*\*Rails Framework References:\*\*/, "**Rails Framework References:**")
      content << ":::\n\n"
    end

    # Add class methods with VitePress collapsible details
    if class_methods.any?
      content << "## Class Methods\n\n"
      content << "<Badge type=\"info\" text=\"#{class_methods.count} class method#{'s' if class_methods.count != 1}\" />\n\n"
      content << "::: details View all #{class_methods.count} class method#{'s' if class_methods.count != 1}\n\n"
      class_methods.first(25).each do |meth|
        content << generate_method_doc(meth)
      end
      if class_methods.count > 25
        content << "\n::: tip More Methods\n"
        content << "*... and #{class_methods.count - 25} more class methods*\n"
        content << ":::\n"
      end
      content << ":::\n\n"
    end

    # Add instance methods with VitePress collapsible details
    if instance_methods.any?
      content << "## Instance Methods\n\n"
      content << "<Badge type=\"info\" text=\"#{instance_methods.count} instance method#{'s' if instance_methods.count != 1}\" />\n\n"
      content << "::: details View all #{instance_methods.count} instance method#{'s' if instance_methods.count != 1}\n\n"
      instance_methods.first(25).each do |meth|
        content << generate_method_doc(meth)
      end
      if instance_methods.count > 25
        content << "\n::: tip More Methods\n"
        content << "*... and #{instance_methods.count - 25} more instance methods*\n"
        content << ":::\n"
      end
      content << ":::\n\n"
    end

    # Add examples from YARD @example tags with VitePress custom containers
    examples = mod.tags(:example)
    if examples.any?
      content << "## Examples\n\n"
      content << "<Badge type=\"tip\" text=\"#{examples.count} example#{'s' if examples.count != 1}\" />\n\n"
      examples.each_with_index do |example, idx|
        content << "::: tip #{example.name || "Example #{idx + 1}"}\n"
        content << "```ruby\n#{example.text}\n```\n"
        content << ":::\n\n"
      end
    end

    # Note about test examples with VitePress alert
    content << "::: info Test Examples\n"
    content << "Comprehensive test-driven examples are available in the [Examples section](/docs/examples/).\n"
    content << ":::\n\n"

    content << "---\n\n"
    content << "<Badge type=\"info\" text=\"Navigation\" /> [← Back to Index](/docs/api/)\n"

    content
  end

  def get_rails_api_info(code_object)
    # Try to get Rails API info from the actual class/module
    klass = begin
      code_object.path.constantize
    rescue
      nil
    end

    return "" unless klass

    # Use distributed rails_api_info if available
    if klass.respond_to?(:rails_api_info)
      rails_info = klass.rails_api_info
      return generate_rails_api_links_from_info(rails_info, klass)
    end

    # Fallback: determine from inheritance
    determine_rails_api_links(klass)
  end

  def generate_rails_api_links_from_info(rails_info, klass)
    return "" unless rails_info

    base_class = rails_info[:base_class]
    features = rails_info[:features] || []
    rails_modules = rails_info[:rails_modules] || []

    # For concerns, if no base_class but uses_concern is true, use ActiveSupport::Concern
    if klass.is_a?(Module) && !klass.is_a?(Class) && !base_class && rails_info[:uses_concern]
      base_class = "ActiveSupport::Concern"
    end

    return "" unless base_class

    feature_text = features.any? ? " providing #{features.join(', ')}" : ""
    description = "This #{klass.is_a?(Class) ? 'class' : 'concern'} uses `#{base_class}`#{feature_text}. See [#{base_class}](https://api.rubyonrails.org/classes/#{base_class.gsub('::', '/')}.html) for the complete API."

    links = []
    if base_class == "ActiveSupport::Concern"
      links << "- **Base Module**: [#{base_class}](https://api.rubyonrails.org/classes/#{base_class.gsub('::', '/')}.html) - Modular, reusable behavior"
      links << "- **ActiveSupport**: [ActiveSupport](https://api.rubyonrails.org/classes/ActiveSupport.html) - Utility classes and Ruby extensions"
    else
      links << "- **Base Class**: [#{base_class}](https://api.rubyonrails.org/classes/#{base_class.gsub('::', '/')}.html)"
    end

    rails_modules.each do |mod|
      next if mod == base_class # Don't duplicate base class
      mod_path = mod.gsub("::", "/")
      links << "- **#{mod.split('::').last}**: [#{mod}](https://api.rubyonrails.org/classes/#{mod_path}.html)"
    end

    "\n#{description}\n\n**Rails Framework References:**\n#{links.join("\n")}\n\n"
  end

  def determine_rails_api_links(klass)
    # Handle modules (concerns) that extend ActiveSupport::Concern
    if klass.is_a?(Module) && !klass.is_a?(Class)
      # Compute if it extends ActiveSupport::Concern using reflection
      if uses_active_support_concern?(klass)
        return generate_concern_rails_api_links(klass)
      end
      return ""
    end

    return "" unless klass.is_a?(Class)

    # Compute base class using reflection
    base_class = klass.superclass
    return "" unless base_class

    # Compute Rails framework from inheritance hierarchy
    if inherits_from?(klass, ActiveRecord::Base)
      generate_active_record_rails_api_links(base_class)
    elsif inherits_from?(klass, ActionController::Base)
      generate_controller_rails_api_links(base_class)
    elsif inherits_from?(klass, ActiveJob::Base)
      generate_job_rails_api_links(base_class)
    elsif inherits_from?(klass, ActionMailer::Base)
      generate_mailer_rails_api_links(base_class)
    else
      ""
    end
  end

  def uses_active_support_concern?(mod)
    mod.included_modules.include?(ActiveSupport::Concern) ||
    mod.singleton_class.ancestors.include?(ActiveSupport::Concern) ||
    mod.respond_to?(:class_methods)
  end

  def inherits_from?(klass, base_class)
    klass < base_class rescue false
  end

  def generate_concern_rails_api_links(klass)
    "\nThis concern uses `ActiveSupport::Concern` to provide shared behavior across multiple classes. Concerns encapsulate cross-cutting functionality and can define class methods, instance methods, and callbacks. See [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) for the complete API.\n\n**Rails Framework References:**\n- **Base Module**: [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) - Modular, reusable behavior\n- **ActiveSupport**: [ActiveSupport](https://api.rubyonrails.org/classes/ActiveSupport.html) - Utility classes and Ruby extensions\n\n"
  end

  def generate_active_record_rails_api_links(base_class)
    "\nThis model inherits from `#{base_class.name}`, providing database persistence. See [#{base_class.name}](https://api.rubyonrails.org/classes/#{base_class.name.gsub('::', '/')}.html) for the complete API.\n\n**Rails Framework References:**\n- **Base Class**: [#{base_class.name}](https://api.rubyonrails.org/classes/#{base_class.name.gsub('::', '/')}.html)\n- **ActiveRecord**: [ActiveRecord](https://api.rubyonrails.org/classes/ActiveRecord.html)\n\n"
  end

  def generate_controller_rails_api_links(base_class)
    "\nThis controller inherits from `#{base_class.name}`, handling HTTP requests. See [#{base_class.name}](https://api.rubyonrails.org/classes/#{base_class.name.gsub('::', '/')}.html) for the complete API.\n\n**Rails Framework References:**\n- **Base Class**: [#{base_class.name}](https://api.rubyonrails.org/classes/#{base_class.name.gsub('::', '/')}.html)\n\n"
  end

  def generate_job_rails_api_links(base_class)
    "\nThis job inherits from `#{base_class.name}`, enabling asynchronous processing. See [#{base_class.name}](https://api.rubyonrails.org/classes/#{base_class.name.gsub('::', '/')}.html) for the complete API.\n\n**Rails Framework References:**\n- **Base Class**: [#{base_class.name}](https://api.rubyonrails.org/classes/#{base_class.name.gsub('::', '/')}.html)\n\n"
  end

  def generate_mailer_rails_api_links(base_class)
    "\nThis mailer inherits from `#{base_class.name}`, providing email composition. See [#{base_class.name}](https://api.rubyonrails.org/classes/#{base_class.name.gsub('::', '/')}.html) for the complete API.\n\n**Rails Framework References:**\n- **Base Class**: [#{base_class.name}](https://api.rubyonrails.org/classes/#{base_class.name.gsub('::', '/')}.html)\n\n"
  end

  def extract_associations_from_yard(klass)
    # Use Rails metadata instead of parsing source code (RailsAdmin-style)
    klass_obj = begin
      klass.path.constantize
    rescue
      nil
    end

    return [] unless klass_obj && klass_obj.is_a?(Class) && klass_obj < ActiveRecord::Base

    associations = []

    # Use ActiveRecord reflection to get associations
    klass_obj.reflect_on_all_associations.each do |assoc|
      options = {}
      options[:class_name] = assoc.class_name if assoc.options[:class_name]
      options[:foreign_key] = assoc.foreign_key if assoc.options[:foreign_key]
      options[:dependent] = assoc.options[:dependent] if assoc.options[:dependent]
      options[:optional] = assoc.options[:optional] if assoc.options[:optional]

      associations << {
        type: assoc.macro,
        name: assoc.name,
        options: options
      }
    end

    associations
  end

  def extract_validations_from_yard(klass)
    # Use Rails metadata instead of parsing source code (RailsAdmin-style)
    klass_obj = begin
      klass.path.constantize
    rescue
      nil
    end

    return [] unless klass_obj && klass_obj.is_a?(Class) && klass_obj < ActiveRecord::Base

    validations = []

    # Use ActiveRecord validators metadata
    klass_obj.validators.each do |validator|
      attrs = validator.attributes
      validator_type = validator.kind
      options = validator.options.dup

      attrs.each do |attr|
        validations << {
          attribute: attr,
          type: validator_type,
          options: options
        }
      end
    end

    validations
  end

  def extract_scopes_from_yard(klass)
    # Use Rails metadata instead of parsing source code (RailsAdmin-style)
    klass_obj = begin
      klass.path.constantize
    rescue
      nil
    end

    return [] unless klass_obj && klass_obj.is_a?(Class) && klass_obj < ActiveRecord::Base

    scopes = []

    # Use ActiveRecord scopes metadata (scopes is a hash of name => scope proc)
    if klass_obj.respond_to?(:scopes) && klass_obj.scopes.is_a?(Hash)
      klass_obj.scopes.each do |name, _scope|
        scopes << { name: name, description: nil }
      end
    end

    scopes
  end

  def extract_includes_from_yard(klass)
    # Use Rails metadata instead of parsing source code (RailsAdmin-style)
    klass_obj = begin
      klass.path.constantize
    rescue
      nil
    end

    return [] unless klass_obj

    # Use Ruby reflection to get included modules
    klass_obj.included_modules.reject do |mod|
      # Exclude Rails internal modules
      mod.name.nil? ||
      mod.name.start_with?("Rails::") ||
      mod.name.start_with?("ActiveRecord::") ||
      mod.name.start_with?("ActiveSupport::") ||
      mod.name.start_with?("ActionController::") ||
      mod.name.start_with?("ActionView::") ||
      mod.name == "Kernel" ||
      mod.name == "Object"
    end.map(&:name)
  end

  def skip_class?(klass)
    # Skip internal Rails classes
    klass.path.start_with?("Rails::") ||
    klass.path.start_with?("ActiveRecord::") ||
    klass.path.start_with?("ActionController::") ||
    klass.path.start_with?("ActiveJob::") ||
    klass.path == "ApplicationRecord" ||
    klass.path == "ApplicationController" ||
    klass.path == "ApplicationJob"
  end

  def skip_module?(mod)
    # Skip internal Rails modules
    mod.path.start_with?("Rails::") ||
    mod.path.start_with?("ActiveRecord::") ||
    mod.path.start_with?("ActiveSupport::") ||
    mod.path.start_with?("ActionController::")
  end

  def determine_file_path(code_object)
    # Compute component type from actual class structure
    klass = begin
      code_object.path.constantize
    rescue
      nil
    end

    return API_DIR.join("concerns", "#{code_object.path.gsub('::', '/').underscore}.md") unless klass

    # Compute type from inheritance hierarchy (like RailsAdmin)
    component_type = compute_component_type(klass)
    path = code_object.path.gsub("::", "/").underscore

    case component_type
    when :model
      API_DIR.join("models", "#{path}.md")
    when :controller
      API_DIR.join("controllers", "#{path}.md")
    when :mailer
      API_DIR.join("mailers", "#{path}.md")
    when :service
      API_DIR.join("services", "#{path}.md")
    when :job
      API_DIR.join("jobs", "#{path}.md")
    when :concern
      # Compute namespace structure dynamically
      namespace_parts = code_object.path.split("::")
      if namespace_parts.length > 1
        base = namespace_parts.first.underscore
        sub_path = namespace_parts[1..-1].join("/").underscore
        API_DIR.join("concerns", base, "#{sub_path}.md")
      else
        API_DIR.join("concerns", "#{path}.md")
      end
    else
      API_DIR.join("concerns", "#{path}.md")
    end
  end

  def compute_component_type(klass)
    # Compute type from actual inheritance (RailsAdmin-style)
    return :model if klass.is_a?(Class) && inherits_from?(klass, ActiveRecord::Base)
    return :controller if klass.is_a?(Class) && inherits_from?(klass, ActionController::Base)
    return :mailer if klass.is_a?(Class) && inherits_from?(klass, ActionMailer::Base)
    return :job if klass.is_a?(Class) && inherits_from?(klass, ActiveJob::Base)
    return :service if klass.is_a?(Class) && klass.name.end_with?("Service")
    return :concern if klass.is_a?(Module)
    :concern # Default fallback
  end

  def generate_testing_ux_doc
    # Delegate to DocsGenerator for consistency
    require_relative "docs_generator"
    generator = DocsGenerator.new
    generator.send(:generate_testing_ux_doc)
  end

  def generate_vitepress_config
    # Generate VitePress config from YARD registry
    require_relative "docs_generator"
    generator = DocsGenerator.new

    # Discover components from YARD registry
    discover_components_from_yard(generator)

    # Extract test examples (still use existing method - this links tests to docs)
    generator.send(:extract_test_examples)

    # Generate examples documentation (from tests)
    generator.send(:generate_examples_docs)

    # Generate config
    generator.generate_vitepress_config
  end

  def discover_components_from_yard(generator)
    # Populate generator's component structure from YARD
    classes = @registry.all(:class).reject { |c| skip_class?(c) }
    modules = @registry.all(:module).reject { |m| skip_module?(m) }

    # Categorize by type
    components = {
      models: [],
      controllers: [],
      services: [],
      jobs: [],
      mailers: [],
      concerns: []
    }

    classes.each do |klass|
      # Compute type from actual class structure (RailsAdmin-style)
      klass_obj = begin
        klass.path.constantize
      rescue
        nil
      end

      next unless klass_obj

      type = compute_component_type(klass_obj)
      next unless type && components[type] # Ensure type exists in components hash

      file_path = klass.files.first&.first || ""
      relative_path = file_path.sub(Rails.root.to_s + "/", "") if file_path && !file_path.empty?

      component_info = {
        class_name: klass.path,
        file_path: file_path,
        relative_path: relative_path || "",
        namespace: klass.path.split("::")[0..-2],
        type: type,
        description: klass.docstring || "",
        methods: klass.meths(visibility: :public).map(&:name),
        associations: extract_associations_from_yard(klass),
        includes: []
      }

      components[type] << component_info
    end

    modules.each do |mod|
      file_path = mod.files.first&.first || ""
      relative_path = file_path.sub(Rails.root.to_s + "/", "") if file_path && !file_path.empty?

      component_info = {
        class_name: mod.path,
        file_path: file_path,
        relative_path: relative_path || "",
        namespace: mod.path.split("::")[0..-2],
        type: :concerns,
        description: mod.docstring || "",
        methods: mod.meths(visibility: :public).map(&:name),
        associations: [],
        includes: []
      }

      components[:concerns] << component_info
    end

    generator.instance_variable_set(:@components, components)
  end

  def determine_type_from_yard(klass)
    # Compute type from actual class structure (RailsAdmin-style)
    klass_obj = begin
      klass.path.constantize
    rescue
      nil
    end

    return nil unless klass_obj

    compute_component_type(klass_obj)
  end

  ##
  # Compute SEO-friendly description from code structure
  #
  def compute_seo_description(class_name, docstring, component_type, klass_obj, associations, validations, scopes, includes)
    parts = []

    # Start with docstring first line if available
    if docstring && !docstring.strip.empty?
      first_line = docstring.split("\n").first.strip
      parts << first_line unless first_line.empty?
    end

    # Add component type information
    case component_type
    when :model
      parts << "ActiveRecord model"
      if klass_obj && klass_obj < ActiveRecord::Base
        parts << "with #{associations.count} association#{'s' if associations.count != 1}"
        parts << "#{validations.count} validation#{'s' if validations.count != 1}"
        parts << "#{scopes.count} scope#{'s' if scopes.count != 1}" if scopes.any?
      end
    when :controller
      parts << "Rails controller"
    when :service
      parts << "Service object"
    when :job
      parts << "Background job"
    when :mailer
      parts << "Email mailer"
    when :concern
      parts << "Reusable concern module"
    end

    # Add included concerns
    if includes.any?
      concern_names = includes.map { |inc|
        name = inc.is_a?(Array) ? inc.first : inc
        name.to_s.gsub(/^\["|"\]$/, "").gsub(/"/, "")
      }.reject(&:empty?)
      if concern_names.any?
        parts << "includes #{concern_names.join(', ')}"
      end
    end

    # Fallback if nothing computed
    if parts.empty?
      parts << "API documentation for #{class_name}"
    end

    # Join and limit length for SEO (150-160 chars ideal)
    description = parts.join(", ")
    if description.length > 160
      description = description[0..157] + "..."
    end

    description
  end

  ##
  # Compute keywords from code structure for SEO
  #
  def compute_keywords(class_name, component_type, klass_obj, associations, validations, scopes, includes, instance_methods, class_methods)
    keywords = []

    # Base keywords
    keywords << class_name
    keywords << component_type.to_s
    keywords << "rails"
    keywords << "api"
    keywords << "ruby"

    # Component-specific keywords
    case component_type
    when :model
      keywords << "activerecord"
      keywords << "model"
      if klass_obj && klass_obj < ActiveRecord::Base
        keywords << "database"
        keywords << "orm"
      end
    when :controller
      keywords << "actioncontroller"
      keywords << "http"
      keywords << "rest"
    when :service
      keywords << "service"
      keywords << "business logic"
    when :job
      keywords << "activejob"
      keywords << "background"
      keywords << "async"
    when :mailer
      keywords << "actionmailer"
      keywords << "email"
    when :concern
      keywords << "module"
      keywords << "reusable"
    end

    # Add association types as keywords
    associations.each do |assoc|
      keywords << assoc[:type].to_s
      keywords << assoc[:name].to_s
    end

    # Add validation types as keywords
    validations.each do |val|
      keywords << val[:type].to_s
      keywords << "validation"
    end

    # Add scope names as keywords
    scopes.each do |scope|
      keywords << scope[:name].to_s
      keywords << "scope"
    end

    # Add included module names
    includes.each do |inc|
      name = inc.is_a?(Array) ? inc.first : inc
      name = name.to_s.gsub(/^\["|"\]$/, "").gsub(/"/, "")
      keywords << name unless name.empty?
    end

    # Add method names (limit to first 10 to avoid keyword stuffing)
    all_methods = (instance_methods.map(&:name) + class_methods.map(&:name)).first(10)
    all_methods.each do |meth_name|
      keywords << meth_name.to_s
    end

    # Remove duplicates and empty strings, limit to reasonable number
    keywords.uniq.reject(&:empty?).first(30)
  end
end
