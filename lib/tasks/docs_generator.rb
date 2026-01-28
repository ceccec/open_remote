##
# Generates VitePress-style documentation from RSpec test examples.
# Auto-discovers all Rails components (models, controllers, services, jobs, concerns)
# and extracts test cases to create comprehensive API documentation.
#
class DocsGenerator
  require "set"

  DOCS_DIR = Rails.root.join("docs")
  API_DIR = DOCS_DIR.join("api")
  EXAMPLES_DIR = DOCS_DIR.join("examples")
  COMPONENT_PATHS = {
    models: "app/models",
    controllers: "app/controllers",
    services: "app/services",
    jobs: "app/jobs",
    concerns: "app/models/concerns"
  }

  def initialize
    @test_files = Dir[Rails.root.join("spec", "**", "*_spec.rb")]
    @examples_by_class = {}
    @components = {}
    @component_tree = {}
  end

  def generate
    setup_directories
    discover_components
    extract_test_examples
    generate_index
    generate_api_docs
    generate_examples_docs
    generate_vitepress_config
  end

  private

  def setup_directories
    FileUtils.mkdir_p(DOCS_DIR)
    FileUtils.mkdir_p(API_DIR)
    FileUtils.mkdir_p(EXAMPLES_DIR)
    FileUtils.mkdir_p(DOCS_DIR.join(".vitepress"))
    
    # Create component-specific directories
    COMPONENT_PATHS.each_key do |type|
      FileUtils.mkdir_p(API_DIR.join(type.to_s))
    end
  end

  ##
  # Auto-discover all Rails components (models, controllers, services, jobs, concerns).
  # Scans the app directory structure and extracts class names, file paths, and metadata.
  #
  def discover_components
    COMPONENT_PATHS.each do |type, path|
      full_path = Rails.root.join(path)
      next unless Dir.exist?(full_path)

      @components[type] = []
      @component_tree[type] = {}
      seen_classes = Set.new

      discover_components_in_directory(full_path, type, "", seen_classes)
    end
  end

  ##
  # Recursively discover components in a directory.
  #
  def discover_components_in_directory(dir_path, type, namespace_prefix, seen_classes)
    Dir.glob(File.join(dir_path, "**", "*.rb")).each do |file_path|
      next if file_path.include?("/concerns/") && type != :concerns
      next if File.basename(file_path) == "application_record.rb"
      next if File.basename(file_path) == "application_controller.rb"

      relative_path = Pathname.new(file_path).relative_path_from(Rails.root.join(COMPONENT_PATHS[type]))
      namespace = relative_path.dirname.to_s.split("/").reject(&:empty?)
      
      content = File.read(file_path)
      class_name = extract_class_name_from_file(content, file_path, type, namespace)

      next unless class_name
      
      # Skip if we've already seen this class name for this type
      class_key = "#{type}::#{class_name}"
      next if seen_classes.include?(class_key)
      seen_classes.add(class_key)

      component_info = {
        class_name: class_name,
        file_path: file_path,
        relative_path: relative_path.to_s,
        namespace: namespace,
        type: type,
        description: extract_description(content),
        methods: extract_methods(content),
        associations: extract_associations(content, type),
        includes: extract_includes(content)
      }

      @components[type] << component_info
      
      # Build tree structure for sidebar
      build_component_tree(type, namespace, component_info)
    end
  end

  ##
  # Extract class name from Ruby file content.
  #
  def extract_class_name_from_file(content, file_path, type, namespace)
    # Try to match class/module definitions
    if content =~ /^(class|module)\s+([A-Z][\w:]+)/
      $2
    else
      # Infer from file path
      base_name = File.basename(file_path, ".rb")
      
      case type
      when :controllers
        base_name.gsub("_controller", "").camelize + "Controller"
      when :models
        if namespace.empty?
          base_name.camelize
        else
          (namespace.map(&:camelize) + [base_name.camelize]).join("::")
        end
      when :services, :jobs
        base_name.camelize
      when :concerns
        (namespace.map(&:camelize) + [base_name.camelize]).join("::")
      else
        base_name.camelize
      end
    end
  end

  ##
  # Extract YARD-style description from file.
  #
  def extract_description(content)
    if content =~ /^##\s*(.+?)(?:\n|$)/
      $1.strip
    elsif content =~ /^#\s*(.+?)(?:\n|$)/
      $1.strip
    else
      nil
    end
  end

  ##
  # Extract method definitions from file.
  #
  def extract_methods(content)
    methods = []
    content.scan(/^\s*(def\s+(?:self\.)?([\w?!=]+)|def\s+self\.([\w?!=]+))/).each do |match|
      method_name = match[1] || match[2]
      methods << method_name if method_name
    end
    methods.uniq
  end

  ##
  # Extract ActiveRecord associations from model files.
  #
  def extract_associations(content, type)
    return [] unless type == :models

    associations = []
    content.scan(/(has_many|has_one|belongs_to|has_and_belongs_to_many)\s+:(\w+)/) do |assoc_type, name|
      associations << { type: assoc_type, name: name }
    end
    associations
  end

  ##
  # Extract included modules/concerns.
  #
  def extract_includes(content)
    includes = []
    content.scan(/include\s+([A-Z][\w:]+)/) do |mod|
      includes << mod[0]
    end
    includes
  end

  ##
  # Build component tree structure for sidebar navigation.
  #
  def build_component_tree(type, namespace, component_info)
    current = @component_tree[type]
    
    namespace.each do |segment|
      current[segment] ||= { _components: [], _children: {} }
      current = current[segment][:_children]
    end
    
    current[:_components] ||= []
    current[:_components] << component_info
  end

  def extract_test_examples
    @test_files.each do |file|
      content = File.read(file)
      class_name = extract_class_name(content, file)

      next unless class_name

      examples = extract_examples(content, file)
      @examples_by_class[class_name] ||= []
      @examples_by_class[class_name].concat(examples)
    end
  end

  def extract_class_name(content, file_path)
    # Try to find the class being tested
    if content =~ /RSpec\.describe\s+([A-Z][\w:]+)/
      $1
    elsif file_path =~ /spec\/(models|controllers|services|jobs|concerns)\/(.+)_spec\.rb/
      module_path = $2.split("/")
      module_path.map(&:camelize).join("::")
    else
      nil
    end
  end

  def extract_examples(content, file_path)
    examples = []
    current_example = nil
    current_description = nil

    content.lines.each do |line|
      # Match RSpec example blocks
      if line =~ /^\s*(it|specify|example)\s+["'](.+?)["']/
        current_example = {
          description: $2,
          code: [],
          file: file_path,
          line_number: content.lines.index(line) + 1
        }
        examples << current_example
      elsif line =~ /^\s*describe\s+["'](.+?)["']/
        current_description = $2
      elsif current_example && line =~ /^\s*(expect|let|before|after|context)/
        # Include relevant test code
        current_example[:code] << line.rstrip
      elsif current_example && line.strip == "end"
        # End of example block
        current_example = nil
      end
    end

    examples
  end

  def generate_index
    content = <<~MARKDOWN
      # OpenRemote Rails API Documentation

      Comprehensive API documentation auto-generated from Rails components and test examples.

      ## Quick Start

      ```bash
      # Generate documentation from components and tests
      bundle exec rake docs:from_tests

      # View documentation
      npm run docs:dev
      ```

      ## Components

      #{generate_component_index}

      ## Examples

      All examples are extracted from RSpec test files and demonstrate real usage.

      See [Examples](/examples/) for detailed test-driven examples.
    MARKDOWN

    File.write(DOCS_DIR.join("index.md"), content)
  end

  def generate_component_index
    sections = []
    
    COMPONENT_PATHS.each_key do |type|
      components = @components[type] || []
      next if components.empty?

      sections << "### #{type.to_s.capitalize} (#{components.size})"
      sections << ""
      components.sort_by { |c| c[:class_name] }.each do |component|
        path = component_path(component)
        sections << "- [#{component[:class_name]}](#{path})"
      end
      sections << ""
    end

    sections.join("\n")
  end

  def component_path(component)
    type = component[:type]
    class_name = component[:class_name]
    "/api/#{type}/#{class_name.gsub('::', '/').underscore}"
  end

  def generate_api_docs
    # Generate docs for all discovered components
    @components.each do |type, components|
      components.each do |component|
        class_name = component[:class_name]
        examples = @examples_by_class[class_name] || []
        
        path = class_name.gsub("::", "/").underscore
        file_path = API_DIR.join(type.to_s, "#{path}.md")

        content = generate_component_doc(component, examples)
        FileUtils.mkdir_p(file_path.dirname)
        File.write(file_path, content)
      end
    end

    # Also generate docs for classes that have tests but weren't discovered
    @examples_by_class.each do |class_name, examples|
      next if examples.empty?
      
      # Check if already generated
      already_generated = @components.values.flatten.any? { |c| c[:class_name] == class_name }
      next if already_generated

      path = class_name.gsub("::", "/").underscore
      file_path = API_DIR.join("api", "#{path}.md")

      content = generate_class_doc(class_name, examples)
      FileUtils.mkdir_p(file_path.dirname)
      File.write(file_path, content)
    end
  end

  def generate_component_doc(component, examples)
    class_name = component[:class_name]
    description = component[:description] || extract_class_description(class_name)
    methods = component[:methods] || []
    
    # Try to load the actual class to get more method info
    begin
      klass = class_name.constantize
      all_methods = (klass.instance_methods(false) + klass.methods(false)).map(&:to_s)
      methods = (methods + all_methods).uniq
    rescue NameError, LoadError
      # Use extracted methods only
    end

    <<~MARKDOWN
      # #{class_name}

      #{description || "API documentation for #{class_name}"}

      **Type:** #{component[:type].to_s.capitalize}  
      **File:** `#{component[:relative_path]}`

      #{generate_associations_section(component) if component[:associations].any?}
      #{generate_includes_section(component) if component[:includes].any?}

      ## Methods

      #{generate_methods_doc(class_name, methods, examples)}

      #{examples.any? ? "## Examples\n\nThe following examples are extracted from test files:\n\n#{examples.map { |ex| generate_example_markdown(ex) }.join("\n\n")}" : ""}

      ## Source Code

      See: `#{component[:file_path]}`

      #{examples.any? ? "## Test File\n\nSee: `#{examples.first[:file]}`" : ""}

      ---

      [← Back to Index](/)
    MARKDOWN
  end

  def generate_class_doc(class_name, examples)
    # Try to load the actual class to get method signatures
    begin
      klass = class_name.constantize
      methods = klass.instance_methods(false) + klass.methods(false)
    rescue NameError
      methods = []
    end

    <<~MARKDOWN
      # #{class_name}

      #{extract_class_description(class_name)}

      ## Examples

      The following examples are extracted from test files:

      #{examples.map { |ex| generate_example_markdown(ex) }.join("\n\n")}

      ## Methods

      #{generate_methods_doc(class_name, methods, examples)}

      ## Test File

      See: `#{examples.first[:file]}`

      ---

      [← Back to Index](/)
    MARKDOWN
  end

  def generate_associations_section(component)
    return "" unless component[:associations].any?

    assoc_list = component[:associations].map do |assoc|
      "- `#{assoc[:type]} :#{assoc[:name]}`"
    end.join("\n")

    <<~MARKDOWN
      ## Associations

      #{assoc_list}

    MARKDOWN
  end

  def generate_includes_section(component)
    return "" unless component[:includes].any?

    includes_list = component[:includes].map { |inc| "- `#{inc}`" }.join("\n")

    <<~MARKDOWN
      ## Included Modules

      #{includes_list}

    MARKDOWN
  end

  def extract_class_description(class_name)
    # Try to find the class file and extract its description
    file_path = Rails.root.join("app", "models", "#{class_name.underscore}.rb")
    file_path = Rails.root.join("app", "services", "#{class_name.underscore}.rb") unless File.exist?(file_path)
    file_path = Rails.root.join("app", "controllers", "#{class_name.underscore}_controller.rb") unless File.exist?(file_path)

    if File.exist?(file_path)
      content = File.read(file_path)
      if content =~ /^##\s*(.+)$/
        $1.strip
      else
        "API documentation for #{class_name}"
      end
    else
      "API documentation for #{class_name}"
    end
  end

  def generate_example_markdown(example)
    code_block = example[:code].join("\n")
    code_block = "```ruby\n#{code_block}\n```" unless code_block.empty?

    <<~MARKDOWN
      ### #{example[:description]}

      #{code_block}

      _Source: `#{example[:file]}:#{example[:line_number]}`_
    MARKDOWN
  end

  def generate_methods_doc(class_name, methods, examples)
    return "No methods documented." if methods.empty?

    methods.map do |method|
      method_examples = examples.select { |ex| ex[:code].join.include?(method.to_s) }
      example_text = method_examples.any? ? "\n\n**Examples:**\n#{method_examples.map { |ex| "- #{ex[:description]}" }.join("\n")}" : ""

      <<~MARKDOWN
        ### `#{method}`

        #{example_text}
      MARKDOWN
    end.join("\n\n")
  end

  def generate_examples_docs
    # Group examples by feature/concern
    examples_by_feature = group_examples_by_feature

    examples_by_feature.each do |feature, examples|
      file_path = EXAMPLES_DIR.join("#{feature.parameterize}.md")
      content = generate_feature_doc(feature, examples)
      File.write(file_path, content)
    end
  end

  def group_examples_by_feature
    features = {}
    @examples_by_class.each do |class_name, examples|
      feature = class_name.split("::").first
      features[feature] ||= []
      features[feature].concat(examples.map { |ex| ex.merge(class: class_name) })
    end
    features
  end

  def generate_feature_doc(feature, examples)
    <<~MARKDOWN
      # #{feature} Examples

      Test-driven examples for #{feature} functionality.

      #{examples.map { |ex| generate_example_markdown(ex) }.join("\n\n---\n\n")}

      ---

      [← Back to Index](/)
    MARKDOWN
  end

  def generate_vitepress_config
    # Determine base path: use GitHub Pages path if GITHUB_REPOSITORY is set, otherwise root
    base_path = if ENV["GITHUB_REPOSITORY"]
      repo_name = ENV["GITHUB_REPOSITORY"].split("/").last
      "/#{repo_name}/"
    else
      "/"
    end

    # Determine output directory: use dist for GitHub Pages, public for local
    # VitePress outDir is relative to the site root (docs/)
    # GitHub Pages expects files in docs/.vitepress/dist, local Rails serves from public/
    out_dir = if ENV["GITHUB_ACTIONS"] == "true"
      ".vitepress/dist"
    else
      "../public"
    end

    config = {
      title: "OpenRemote Rails API",
      description: "API documentation auto-generated from Rails components and test examples",
      themeConfig: {
        nav: generate_nav_config,
        sidebar: generate_sidebar_config_all
      }
    }

    # Generate JavaScript config file with proper formatting
    nav_config = format_nav_for_js(generate_nav_config)
    sidebar_config = format_sidebar_for_js(generate_sidebar_config_all)
    
    js_content = <<~JS
      export default {
        title: 'OpenRemote Rails API',
        description: 'API documentation auto-generated from Rails components and test examples',
        base: '#{base_path}',
        outDir: '#{out_dir}',
        ignoreDeadLinks: true,
        themeConfig: {
          nav: #{nav_config},
          sidebar: {
#{sidebar_config}
          }
        }
      }
    JS

    File.write(DOCS_DIR.join(".vitepress", "config.js"), js_content)
  end

  def generate_nav_config
    nav = [
      { text: "Home", link: "/" }
    ]

    COMPONENT_PATHS.each_key do |type|
      components = @components[type] || []
      next if components.empty?
      
      nav << {
        text: type.to_s.capitalize,
        link: "/api/#{type}/"
      }
    end

    nav << { text: "Examples", link: "/examples/" }
    nav
  end

  def generate_sidebar_config_all
    sidebar = {}

    # Generate sidebar for each component type
    COMPONENT_PATHS.each_key do |type|
      components = @components[type] || []
      next if components.empty?

      sidebar["/api/#{type}/"] = generate_sidebar_for_type(type)
    end

    # Generate sidebar for examples
    sidebar["/examples/"] = generate_examples_sidebar

    sidebar
  end

  def generate_sidebar_for_type(type)
    components = (@components[type] || []).sort_by { |c| c[:class_name] }
    
    # Build tree structure, deduplicating by class_name
    sidebar_items = []
    seen_classes = Set.new
    
    components.each do |component|
      next if seen_classes.include?(component[:class_name])
      seen_classes.add(component[:class_name])
      
      path = component_path(component)
      sidebar_items << {
        text: component[:class_name],
        link: path
      }
    end

    sidebar_items
  end

  def generate_examples_sidebar
    features = @examples_by_class.keys.map { |c| c.split("::").first }.uniq.sort
    features.map do |feature|
      {
        text: feature,
        link: "/examples/#{feature.parameterize}"
      }
    end
  end

  def format_nav_for_js(nav_config)
    items = nav_config.map do |item|
      "    { text: '#{item[:text]}', link: '#{item[:link]}' }"
    end
    "[\n#{items.join(",\n")}\n  ]"
  end

  def format_sidebar_for_js(sidebar_config)
    return "" if sidebar_config.empty?
    
    items = sidebar_config.map do |path, sidebar_items|
      # Deduplicate sidebar items by link
      unique_items = sidebar_items.uniq { |item| item.is_a?(Hash) ? item[:link] : item }
      
      formatted_items = unique_items.map do |item|
        if item.is_a?(Hash)
          "        { text: '#{item[:text]}', link: '#{item[:link]}' }"
        else
          "        '#{item}'"
        end
      end
      "      '#{path}': [\n#{formatted_items.join(",\n")}\n      ]"
    end
    items.join(",\n")
  end
end
