##
# Generates VitePress-style documentation from RSpec test examples.
# Auto-discovers all Rails components (models, controllers, services, jobs, concerns)
# and extracts test cases to create comprehensive API documentation.
#
class DocsGenerator
  require "set"

  DOCS_DIR = OpenRemote::Config::DOCS_DIR
  API_DIR = OpenRemote::Config::DOCS_API_DIR
  EXAMPLES_DIR = OpenRemote::Config::DOCS_EXAMPLES_DIR
  COMPONENT_PATHS = {
    models: "app/models",
    controllers: "app/controllers",
    services: "app/services",
    jobs: "app/jobs",
    concerns: "app/models/concerns"
  }

  # Soft limits to keep generated docs (and VitePress builds) lightweight
  MAX_METHODS_PER_COMPONENT = 50
  MAX_EXAMPLES_PER_COMPONENT = 20
  MAX_EXAMPLES_PER_FEATURE = 40
  MAX_EXAMPLE_REFERENCES_PER_METHOD = 5

  def initialize
    @test_files = Dir[Rails.root.join("spec", "**", "*_spec.rb")]
    @examples_by_class = {}
    @components = {}
    @component_tree = {}
    @coverage_stats = compute_coverage_stats
    @test_stats = compute_test_stats
    @coverage_integration = load_coverage_integration
  end

  ##
  # Load DocsCoverageIntegration if available
  #
  def load_coverage_integration
    coverage_integration_path = Rails.root.join("lib", "tasks", "docs_coverage_integration.rb")
    if coverage_integration_path.exist?
      require_relative "docs_coverage_integration"
      DocsCoverageIntegration.new
    else
      nil
    end
  rescue StandardError => e
    Rails.logger.warn("Could not load coverage integration: #{e.message}") if defined?(Rails.logger)
    nil
  end

  def generate
    setup_directories
    discover_components
    extract_test_examples
    # Recompute test stats after extracting examples
    @test_stats = compute_test_stats
    generate_index
    generate_api_docs
    generate_examples_index
    generate_examples_docs
    generate_testing_ux_doc
    generate_vitepress_config
  end

  ##
  # Generate VitePress configuration file.
  # Public method so it can be called independently.
  #
  def generate_testing_ux_doc
    puts "\n📝 Generating Testing UX documentation..."

    # Compute SEO metadata from actual test structure
    test_files_count = @test_files.count
    examples_count = @examples_by_class.values.flatten.count
    test_classes_count = @examples_by_class.keys.count

    seo_description = "Comprehensive guide to testing in OpenRemote Rails. Learn test-driven development, RSpec workflows, #{test_files_count} test files, #{examples_count} examples, and how tests generate documentation automatically."
    keywords = [
      "testing", "rspec", "test-driven development", "tdd", "rails testing",
      "ruby testing", "test coverage", "documentation", "examples",
      "#{test_files_count} tests", "#{examples_count} examples", "bdd"
    ]

    content = <<~MARKDOWN
      ---
      title: Testing Experience
      description: #{seo_description}
      lastUpdated: #{Time.current.iso8601}
      head:
        - - meta
          - name: keywords
            content: #{keywords.join(', ')}
        - - meta
          - property: og:title
            content: Testing Experience - OpenRemote Rails API
        - - meta
          - property: og:description
            content: #{seo_description}
        - - meta
          - property: og:type
            content: website
      ---

      # Testing Experience

      > **Tests are living documentation.** Every test describes how the code works, what it does, and how to use it.

      ## Philosophy

      In OpenRemote Rails, tests serve a dual purpose:

      1. **Verification**: Tests ensure code works correctly
      2. **Documentation**: Tests demonstrate how to use the code

      When you write a test, you're writing documentation that will never go out of date. When you read a test, you're learning how the code actually works.

      ## Running Tests

      ### Quick Test Run

      ```bash
      # Run all tests with beautiful documentation output
      bundle exec rspec

      # Run tests for a specific file
      bundle exec rspec spec/models/asset_spec.rb

      # Run tests matching a pattern
      bundle exec rspec spec/models/asset*
      ```

      ### Test-Driven Development Workflow

      ```bash
      # 1. Write a failing test (red)
      bundle exec rspec spec/models/new_feature_spec.rb

      # 2. Implement the feature (green)
      # ... write code ...

      # 3. Refactor while keeping tests green
      bundle exec rspec

      # 4. Generate documentation from tests
      bundle exec rake test:doc
      ```

      ### Running Only Failed Tests

      After a test run, you can rerun only the failures:

      ```bash
      bundle exec rspec --only-failures
      ```

      This saves time during development by focusing on what needs fixing.

      ## Test Output Format

      Tests use the **documentation format** by default, which produces human-readable output:

      ```
      Asset
        #create
          creates an asset with valid attributes
          validates presence of name
          validates presence of asset_type_id
        #update
          updates asset attributes
          validates name uniqueness
        Associations
          belongs to AssetType
          has many DataPoints
        Concerns
          includes Assets::Querying
          includes Mapping::JsonImport
      ```

      This format makes it easy to:
      - Understand what's being tested
      - See the structure of your code
      - Generate documentation automatically

      ## Coverage Requirements

      **100% code coverage is required.** This ensures:

      - Every line of code is tested
      - Every branch is exercised
      - Every edge case is considered

      When you run tests with coverage:

      ```bash
      bundle exec rake test:coverage_doc
      ```

      You'll get:
      - A coverage report at `coverage/index.html`
      - Automatic documentation generation
      - A gate that fails if coverage drops below 100%

      ::: tip Coverage Philosophy
      High coverage doesn't guarantee quality, but it ensures nothing is forgotten. Combined with good test design, it creates confidence in the codebase.
      :::

      ## Test Structure

      Tests follow RSpec conventions:

      ```ruby
      RSpec.describe Asset do
        describe "#create" do
          it "creates an asset with valid attributes" do
            asset = Asset.create!(name: "Test", asset_type: asset_type)
            expect(asset).to be_persisted
          end
        end
      end
      ```

      The structure mirrors the code structure, making it easy to find tests for specific functionality.

      ## Test-Driven Documentation

      Tests automatically generate documentation:

      ### 1. Examples Extraction

      Test examples are extracted and displayed in API documentation:

      ```ruby
      # In spec/models/asset_spec.rb
      it "queries assets by type" do
        assets = Asset.by_type("sensor")
        expect(assets).to include(sensor_asset)
      end
      ```

      This becomes documentation showing how to use `Asset.by_type`.

      ### 2. Living Examples

      Every example in the documentation comes from a passing test. This means:

      - Examples are always up-to-date
      - Examples are verified to work
      - Examples demonstrate real usage

      ### 3. Automatic Updates

      When you run tests, documentation is automatically regenerated:

      ```bash
      bundle exec rake test:doc
      ```

      This ensures documentation never goes stale.

      #{generate_detailed_stats_section}

      ## Developer Workflow

      ### Starting a New Feature

      1. **Write the test first** (red)
         ```ruby
         RSpec.describe NewFeature do
           it "does something useful" do
             # Test the behavior you want
           end
         end
         ```

      2. **Run the test** (see it fail)
         ```bash
         bundle exec rspec spec/models/new_feature_spec.rb
         ```

      3. **Implement the feature** (green)
         ```ruby
         class NewFeature
           def do_something_useful
             # Implementation
           end
         end
         ```

      4. **Refactor** (keep it green)
         ```bash
         bundle exec rspec
         ```

      5. **Generate docs** (documentation is ready)
         ```bash
         bundle exec rake test:doc
         ```

      ### Fixing a Bug

      1. **Write a test that reproduces the bug**
         ```ruby
         it "handles edge case correctly" do
           # Test that fails due to bug
         end
         ```

      2. **Fix the bug** (test passes)
      3. **Run full suite** (ensure nothing broke)
         ```bash
         bundle exec rspec
         ```

      4. **Documentation updates automatically**

      ### Understanding Existing Code

      When you encounter unfamiliar code:

      1. **Read the tests first**
         ```bash
         # Find the test file
         find spec -name "*asset*_spec.rb"
         ```

      2. **Run the tests** (see how it's used)
         ```bash
         bundle exec rspec spec/models/asset_spec.rb
         ```

      3. **Read the generated docs** (see examples)
         ```bash
         # View in browser after generating docs
         npm run docs:dev
         ```

      ## Test Organization

      Tests mirror the application structure:

      ```
      spec/
      ├── models/
      │   ├── asset_spec.rb
      │   └── data_point_spec.rb
      ├── controllers/
      │   └── sessions_controller_spec.rb
      ├── services/
      │   └── rule_manager_spec.rb
      ├── concerns/
      │   └── batch_actions_spec.rb
      └── support/
          └── shared_examples/
              └── queryable.rb
      ```

      This makes it easy to find tests for any component.

      ## Continuous Integration

      Tests run automatically in CI:

      ```bash
      # CI runs:
      bundle exec rake test:coverage_doc
      ```

      This ensures:
      - All tests pass
      - Coverage stays at 100%
      - Documentation is up-to-date

      ## Best Practices

      ### Write Descriptive Test Names

      ```ruby
      # Good: describes what the test verifies
      it "creates an asset with valid attributes"
      it "validates presence of name"
      it "queries assets by type"

      # Bad: doesn't explain what's being tested
      it "works"
      it "test 1"
      it "does stuff"
      ```

      ### Use Context Blocks

      ```ruby
      describe "#update" do
        context "with valid attributes" do
          it "updates the asset"
        end

        context "with invalid attributes" do
          it "raises a validation error"
        end
      end
      ```

      ### Test Behavior, Not Implementation

      ```ruby
      # Good: tests what the code does
      it "returns assets filtered by type" do
        expect(Asset.by_type("sensor").count).to eq(2)
      end

      # Bad: tests implementation details
      it "calls where method" do
        expect(Asset).to receive(:where)
      end
      ```

      ## Summary

      Testing in OpenRemote Rails is designed to be:

      - **Fast**: Run only what you need
      - **Clear**: Documentation format shows what's tested
      - **Comprehensive**: 100% coverage ensures nothing is missed
      - **Documented**: Tests become documentation automatically
      - **Confident**: High coverage + good tests = reliable code

      ::: info Next Steps
      - Run `bundle exec rspec` to see tests in action
      - Check `coverage/index.html` for coverage details
      - View generated docs with `npm run docs:dev`
      :::

      ---

      [← Back to Index](/)
    MARKDOWN

    File.write(DOCS_DIR.join("testing-ux.md"), content)
    puts "  ✅ docs/testing-ux.md"
  end

  def generate_vitepress_config
    # Use centralized configuration from OpenRemote::Config
    base_path = OpenRemote::Config::VITEPRESS_BASE_PATH
    out_dir = OpenRemote::Config::VITEPRESS_OUT_DIR
    cache_dir = OpenRemote::Config::VITEPRESS_CACHE_DIR
    app_name = OpenRemote::Config::APP_NAME
    app_description = OpenRemote::Config::APP_DESCRIPTION
    lang = OpenRemote::Config::VITEPRESS_LANG
    last_updated = OpenRemote::Config::VITEPRESS_LAST_UPDATED
    appearance = OpenRemote::Config::VITEPRESS_APPEARANCE
    ignore_dead_links = OpenRemote::Config::VITEPRESS_IGNORE_DEAD_LINKS

    # Generate JavaScript config file with proper formatting
    nav_config = format_nav_for_js(generate_nav_config)
    sidebar_config = format_sidebar_for_js(generate_sidebar_config_all)

    # Format appearance value (can be boolean, string, or object)
    appearance_js = case appearance
    when true then "true"
    when false then "false"
    when String then "'#{appearance}'"
    else "true"
    end

    # Format ignoreDeadLinks value
    ignore_dead_links_js = case ignore_dead_links
    when true then "true"
    when false then "false"
    when String then "'#{ignore_dead_links}'"
    else "false"
    end

    # Compute SEO metadata from actual components
    total_components = @components.values.flatten.count
    models_count = @components[:models]&.count || 0
    controllers_count = @components[:controllers]&.count || 0
    services_count = @components[:services]&.count || 0
    jobs_count = @components[:jobs]&.count || 0
    concerns_count = @components[:concerns]&.count || 0
    examples_count = @examples_by_class.values.flatten.count

    # Compute SEO description from actual content
    computed_description = "#{app_description} #{total_components} components (#{models_count} models, #{controllers_count} controllers, #{services_count} services, #{jobs_count} jobs, #{concerns_count} concerns) and #{examples_count} test-driven examples."

    # Compute keywords from component structure
    computed_keywords = [
      "rails api", "ruby on rails", "openremote", "api documentation",
      "#{models_count} models", "#{controllers_count} controllers",
      "#{services_count} services", "#{examples_count} examples",
      "activerecord", "test-driven", "auto-generated", "rspec"
    ].join(", ")

    js_content = <<~JS
      // Auto-generated VitePress configuration
      // To regenerate: rake docs:generate_all or rake docs:from_tests
      // Last updated: #{Time.current.strftime("%Y-%m-%d %H:%M:%S")}
      //
      // This file is automatically generated from Rails components.
      // Do not edit manually - changes will be overwritten.

      import { defineConfig } from 'vitepress'

      export default defineConfig({
        // Site metadata (computed from actual components)
        title: '#{app_name}',
        description: '#{computed_description}',
        lang: '#{lang}',
#{'        '}
        // SEO metadata (computed)
        head: [
          ['meta', { name: 'keywords', content: '#{computed_keywords}' }],
          ['meta', { property: 'og:title', content: '#{app_name}' }],
          ['meta', { property: 'og:description', content: '#{computed_description}' }],
          ['meta', { property: 'og:type', content: 'website' }],
          ['meta', { name: 'twitter:card', content: 'summary' }],
          ['meta', { name: 'twitter:title', content: '#{app_name}' }],
          ['meta', { name: 'twitter:description', content: '#{computed_description}' }]
        ],

        // Routing
        base: '#{base_path}docs/',

        // Build configuration
        // All docs are compiled in docs/, then VitePress builds to public/docs/
        outDir: '#{out_dir}',
        cacheDir: '#{cache_dir}',
        ignoreDeadLinks: #{ignore_dead_links_js},

        // Theming
        appearance: #{appearance_js},
        lastUpdated: #{last_updated},

        // Theme configuration
        themeConfig: {
          // Site title in nav bar
          siteTitle: '#{app_name}',
#{'          '}
          // Navigation bar
          nav: #{nav_config},
#{'          '}
          // Sidebar configuration with grouping
          sidebar: {
#{sidebar_config}
          },
#{'          '}
          // Search configuration
          search: {
            provider: 'local',
            options: {
              locales: {
                root: {
                  translations: {
                    button: {
                      buttonText: 'Search',
                      buttonAriaLabel: 'Search documentation'
                    },
                    modal: {
                      noResultsText: 'No results for',
                      resetButtonTitle: 'Reset search',
                      footer: {
                        selectText: 'to select',
                        navigateText: 'to navigate',
                        closeText: 'to close'
                      }
                    }
                  }
                }
              }
            }
          },
#{'          '}
          // Social links (GitHub)
          socialLinks: [
            {
              icon: 'github',
              link: 'https://github.com/#{ENV["GITHUB_REPOSITORY"] || "ceccec/openremote"}'
            }
          ],
#{'          '}
          // Edit link configuration
          editLink: {
            pattern: 'https://github.com/#{ENV["GITHUB_REPOSITORY"] || "ceccec/openremote"}/edit/main/docs/:path',
            text: 'Edit this page on GitHub'
          },
#{'          '}
          // Footer configuration
          footer: {
            message: 'Auto-generated from Rails components and tests',
            copyright: 'Copyright © #{Time.current.year} OpenRemote Rails'
          },
#{'          '}
          // Logo (optional - can be added later)
          // logo: '/logo.svg',
#{'          '}
          // Outline configuration
          outline: {
            level: [2, 3],
            label: 'On this page'
          }
        }
      })
    JS

    File.write(OpenRemote::Config::DOCS_VITEPRESS_CONFIG_DIR.join("config.js"), js_content)
  end

  private

  def setup_directories
    FileUtils.mkdir_p(DOCS_DIR)
    FileUtils.mkdir_p(API_DIR)
    FileUtils.mkdir_p(EXAMPLES_DIR)
    FileUtils.mkdir_p(OpenRemote::Config::DOCS_VITEPRESS_CONFIG_DIR)

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
          (namespace.map(&:camelize) + [ base_name.camelize ]).join("::")
        end
      when :services, :jobs
        base_name.camelize
      when :concerns
        (namespace.map(&:camelize) + [ base_name.camelize ]).join("::")
      else
        base_name.camelize
      end
    end
  end

  ##
  # Determine type from class name for Rails API links.
  #
  def determine_type_from_class_name_for_api(class_name)
    case class_name
    when /Controller$/
      :controllers
    when /Mailer$/
      :mailers
    when /Service$/
      :services
    when /Job$/
      :jobs
    when /^Mapping::|^Assets?::|^DataPoint::|^Rule::|^User::|^Ability::/
      :concerns
    else
      # Check if it inherits from ActiveRecord by looking at file
      :models
    end
  end

  ##
  # Generate Rails API documentation links and inline descriptions.
  # Uses distributed declarations from models/concerns for speed.
  #
  def generate_rails_api_links(type, class_name)
    return "" unless class_name

    # Try to constantize the class to get Rails API info
    klass = begin
      class_name.constantize
    rescue NameError, LoadError, ArgumentError => e
      # Fallback if class can't be loaded
      return generate_rails_api_links_fallback(type, class_name)
    end

    return generate_rails_api_links_fallback(type, class_name) unless klass

    # Use distributed Rails API info if available (faster)
    rails_info = if klass.respond_to?(:rails_api_info)
      klass.rails_api_info
    else
      nil
    end

    links = []
    description_parts = []

    begin
      # Handle both classes and modules
      base_class = klass.is_a?(Class) ? klass.superclass : nil

      case type
      when :models
        if klass.is_a?(Class) && base_class && (base_class == ActiveRecord::Base || klass < ActiveRecord::Base)
          # Use distributed Rails API info if available (much faster)
          if rails_info
            base_class_name = rails_info[:base_class] || base_class.name
            features = rails_info[:features] || []
            assoc_types = rails_info[:association_types] || []
          else
            # Fallback to reflection (slower)
            base_class_name = base_class.name
            features = []
            begin
              features << "validations" if klass.respond_to?(:validators) && klass.validators.any?
            rescue
            end
            begin
              if klass.respond_to?(:reflect_on_all_associations) && klass.reflect_on_all_associations.any?
                features << "associations"
                assoc_types = klass.reflect_on_all_associations.map(&:macro).uniq
              end
            rescue
            end
            begin
              callbacks_present = klass.instance_methods.grep(/^before_|^after_|^around_/).any?
              features << "callbacks" if callbacks_present
            rescue
            end
            begin
              features << "scopes" if klass.respond_to?(:scopes) && klass.scopes.any?
            rescue
            end
            features << "query methods" if klass.respond_to?(:where)
            assoc_types ||= []
          end

          description_parts << "This model inherits from `#{base_class_name}`, providing database persistence"
          if features.any?
            description_parts << features.join(", ")
          end
          description_parts << "and more."

          description = "#{description_parts.join(', ')} See [#{base_class_name}](https://api.rubyonrails.org/classes/#{base_class_name.gsub('::', '/')}.html) for the complete API."

          links << "- **Base Class**: [#{base_class_name}](https://api.rubyonrails.org/classes/#{base_class_name.gsub('::', '/')}.html) - Database persistence, querying, and model lifecycle"

          # Add links based on Rails modules used (from rails_api_info)
          rails_modules = rails_info[:rails_modules] if rails_info

          if assoc_types.any?
            links << "- **Associations**: [ActiveRecord::Associations](https://api.rubyonrails.org/classes/ActiveRecord/Associations.html) - #{assoc_types.map { |t| "`#{t}`" }.join(', ')} relationships. See [ClassMethods](https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html) for `has_many`, `belongs_to`, `has_one`"
          elsif rails_modules&.include?("ActiveRecord::Associations")
            links << "- **Associations**: [ActiveRecord::Associations](https://api.rubyonrails.org/classes/ActiveRecord/Associations.html) - Model relationships"
          end

          if features.include?("validations")
            links << "- **Validations**: [ActiveRecord::Validations](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html) - Model validation rules and error handling"
          elsif rails_modules&.include?("ActiveRecord::Validations")
            links << "- **Validations**: [ActiveRecord::Validations](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html) - Validation framework"
          end

          if features.include?("callbacks")
            links << "- **Callbacks**: [ActiveRecord::Callbacks](https://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html) - Lifecycle hooks (`before_save`, `after_create`, etc.)"
          elsif rails_modules&.include?("ActiveRecord::Callbacks")
            links << "- **Callbacks**: [ActiveRecord::Callbacks](https://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html) - Lifecycle callbacks"
          end

          if features.include?("scopes")
            links << "- **Scoping**: [ActiveRecord::Scoping](https://api.rubyonrails.org/classes/ActiveRecord/Scoping.html) - Named scopes and default scopes"
          elsif rails_modules&.include?("ActiveRecord::Scoping")
            links << "- **Scoping**: [ActiveRecord::Scoping](https://api.rubyonrails.org/classes/ActiveRecord/Scoping.html) - Scope definitions"
          end

          if features.include?("query methods") || rails_modules&.include?("ActiveRecord::QueryMethods")
            links << "- **Query Methods**: [ActiveRecord::QueryMethods](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html) - Query building (`where`, `joins`, `includes`, etc.)"
            links << "- **Querying**: [ActiveRecord::Querying](https://api.rubyonrails.org/classes/ActiveRecord/Querying.html) - Query interface and finder methods"
          end

          if rails_modules&.include?("ActiveRecord::Persistence")
            links << "- **Persistence**: [ActiveRecord::Persistence](https://api.rubyonrails.org/classes/ActiveRecord/Persistence.html) - `save`, `create`, `update`, `destroy` methods"
          end

          # Always include base ActiveRecord link
          links << "- **ActiveRecord Module**: [ActiveRecord](https://api.rubyonrails.org/classes/ActiveRecord.html) - Complete API reference"
        end

      when :controllers
        if klass.is_a?(Class) && base_class && (base_class == ActionController::Base || klass < ActionController::Base)
          description_parts << "This controller inherits from `#{base_class.name}`, handling HTTP requests"

          features = []
          begin
            features << "rendering" if klass.instance_methods.grep(/render|respond_to/).any?
            features << "session management" if klass.instance_methods.grep(/session/).any?
            features << "strong parameters" if klass.instance_methods.grep(/params|permit/).any?
          rescue
          end

          begin
            features << "filters" if klass.respond_to?(:_process_action_callbacks) && klass._process_action_callbacks.any?
          rescue
          end

          if features.any?
            description_parts << features.join(", ")
          end
          description_parts << "and more."

          description = "#{description_parts.join(', ')} See [#{base_class.name}](https://api.rubyonrails.org/classes/#{base_class.name.gsub('::', '/')}.html) for the complete API."

          links << "- **Base Class**: [#{base_class.name}](https://api.rubyonrails.org/classes/#{base_class.name.gsub('::', '/')}.html) - Request handling, rendering, and controller lifecycle"

          begin
            if klass.instance_methods.grep(/params|permit/).any?
              links << "- **Parameters**: [ActionController::Parameters](https://api.rubyonrails.org/classes/ActionController/Parameters.html) - Strong parameters and request data filtering"
            end
          rescue
          end

          links << "- **Routing**: [ActionDispatch::Routing](https://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper.html) - URL routing and route helpers"

          begin
            if klass.respond_to?(:_process_action_callbacks) && klass._process_action_callbacks.any?
              links << "- **Filters**: [ActionController::Filters](https://api.rubyonrails.org/classes/ActionController/Filters/ClassMethods.html) - `before_action`, `after_action`, `around_action`"
            end
          rescue
          end
        end

      when :jobs
        if klass.is_a?(Class) && base_class && (base_class == ActiveJob::Base || klass < ActiveJob::Base)
          description = "This job inherits from `#{base_class.name}`, enabling asynchronous background processing. Jobs are enqueued and executed by Active Job adapters. See [#{base_class.name}](https://api.rubyonrails.org/classes/#{base_class.name.gsub('::', '/')}.html) for the complete API."

          links << "- **Base Class**: [#{base_class.name}](https://api.rubyonrails.org/classes/#{base_class.name.gsub('::', '/')}.html) - Job enqueueing, callbacks, and execution"

          begin
            if klass.respond_to?(:_perform_callbacks) && klass._perform_callbacks.any?
              links << "- **Callbacks**: [ActiveJob::Callbacks](https://api.rubyonrails.org/classes/ActiveJob/Callbacks.html) - `before_enqueue`, `around_perform`, `after_perform`"
            end
          rescue
          end

          links << "- **Queue Adapters**: [ActiveJob::QueueAdapters](https://api.rubyonrails.org/classes/ActiveJob/QueueAdapters.html) - Background job processing adapters"
        end

      when :mailers
        if klass.is_a?(Class) && base_class && (base_class == ActionMailer::Base || klass < ActionMailer::Base)
          description = "This mailer inherits from `#{base_class.name}`, providing email composition and delivery. Mailers define email templates and can deliver synchronously or asynchronously. See [#{base_class.name}](https://api.rubyonrails.org/classes/#{base_class.name.gsub('::', '/')}.html) for the complete API."

          links << "- **Base Class**: [#{base_class.name}](https://api.rubyonrails.org/classes/#{base_class.name.gsub('::', '/')}.html) - Email composition and delivery"
          links << "- **Message Delivery**: [ActionMailer::MessageDelivery](https://api.rubyonrails.org/classes/ActionMailer/MessageDelivery.html) - `deliver_now`, `deliver_later`"
        end

      when :concerns
        begin
          # Use distributed Rails API info from ConcernFeatures if available (fastest)
          if rails_info
            uses_concern = rails_info[:uses_concern]
            has_callbacks = rails_info[:has_callbacks]
          else
            # Fallback to reflection (slower)
            uses_concern = klass.included_modules.include?(ActiveSupport::Concern) || klass.ancestors.include?(ActiveSupport::Concern)
            has_callbacks = begin
              klass.instance_methods.grep(/^before_|^after_|^around_/).any?
            rescue
              false
            end
          end

          if uses_concern
            description = "This concern uses `ActiveSupport::Concern` to provide shared behavior across multiple classes. Concerns encapsulate cross-cutting functionality and can define class methods, instance methods, and callbacks. See [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) for the complete API."

            links << "- **Base Module**: [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) - Modular, reusable behavior"

            if has_callbacks
              links << "- **Callbacks**: [ActiveSupport::Callbacks](https://api.rubyonrails.org/classes/ActiveSupport/Callbacks.html) - Callback support for concerns"
            end
          end
        rescue
        end
      end
    rescue => e
      # If anything fails, fall back to hardcoded version
      return generate_rails_api_links_fallback(type, class_name)
    end

    if links.empty?
      generate_rails_api_links_fallback(type, class_name)
    else
      "\n#{description}\n**Rails Framework References:**\n#{links.join("\n")}\n"
    end
  end

  ##
  # Fallback to hardcoded descriptions if class inspection fails.
  #
  def generate_rails_api_links_fallback(type, class_name)
    case type
    when :models
      "\nThis model inherits from `ActiveRecord::Base`, providing database persistence, validations, associations, and callbacks. See [ActiveRecord::Base](https://api.rubyonrails.org/classes/ActiveRecord/Base.html) for the complete API.\n\n**Rails Framework References:**\n- **Base Class**: [ActiveRecord::Base](https://api.rubyonrails.org/classes/ActiveRecord/Base.html) - Database persistence, querying, and model lifecycle\n- **Associations**: [ActiveRecord::Associations](https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html) - `has_many`, `belongs_to`, `has_one` relationships\n- **Validations**: [ActiveRecord::Validations](https://api.rubyonrails.org/classes/ActiveRecord/Validations.html) - Model validation rules and error handling\n- **Callbacks**: [ActiveRecord::Callbacks](https://api.rubyonrails.org/classes/ActiveRecord/Callbacks.html) - Lifecycle hooks\n- **Query Interface**: [ActiveRecord::QueryMethods](https://api.rubyonrails.org/classes/ActiveRecord/QueryMethods.html) - Query building (`where`, `joins`, `includes`, etc.)\n"
    when :controllers
      "\nThis controller inherits from `ActionController::Base`, handling HTTP requests, rendering responses, and managing sessions. See [ActionController::Base](https://api.rubyonrails.org/classes/ActionController/Base.html) for the complete API.\n\n**Rails Framework References:**\n- **Base Class**: [ActionController::Base](https://api.rubyonrails.org/classes/ActionController/Base.html) - Request handling, rendering, and controller lifecycle\n- **Parameters**: [ActionController::Parameters](https://api.rubyonrails.org/classes/ActionController/Parameters.html) - Strong parameters and request data filtering\n- **Routing**: [ActionDispatch::Routing](https://api.rubyonrails.org/classes/ActionDispatch/Routing/Mapper.html) - URL routing and route helpers\n- **Filters**: [ActionController::Filters](https://api.rubyonrails.org/classes/ActionController/Filters/ClassMethods.html) - `before_action`, `after_action`, `around_action`\n"
    when :jobs
      "\nThis job inherits from `ActiveJob::Base`, enabling asynchronous background processing. Jobs are enqueued and executed by Active Job adapters. See [ActiveJob::Base](https://api.rubyonrails.org/classes/ActiveJob/Base.html) for the complete API.\n\n**Rails Framework References:**\n- **Base Class**: [ActiveJob::Base](https://api.rubyonrails.org/classes/ActiveJob/Base.html) - Job enqueueing, callbacks, and execution\n- **Callbacks**: [ActiveJob::Callbacks](https://api.rubyonrails.org/classes/ActiveJob/Callbacks.html) - `before_enqueue`, `around_perform`, `after_perform`\n- **Queue Adapters**: [ActiveJob::QueueAdapters](https://api.rubyonrails.org/classes/ActiveJob/QueueAdapters.html) - Background job processing adapters\n"
    when :mailers
      "\nThis mailer inherits from `ActionMailer::Base`, providing email composition and delivery. Mailers define email templates and can deliver synchronously or asynchronously. See [ActionMailer::Base](https://api.rubyonrails.org/classes/ActionMailer/Base.html) for the complete API.\n\n**Rails Framework References:**\n- **Base Class**: [ActionMailer::Base](https://api.rubyonrails.org/classes/ActionMailer/Base.html) - Email composition and delivery\n- **Message Delivery**: [ActionMailer::MessageDelivery](https://api.rubyonrails.org/classes/ActionMailer/MessageDelivery.html) - `deliver_now`, `deliver_later`\n"
    when :concerns
      "\nThis concern uses `ActiveSupport::Concern` to provide shared behavior across multiple classes. Concerns encapsulate cross-cutting functionality and can define class methods, instance methods, and callbacks. See [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) for the complete API.\n\n**Rails Framework References:**\n- **Base Module**: [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) - Modular, reusable behavior\n- **Callbacks**: [ActiveSupport::Callbacks](https://api.rubyonrails.org/classes/ActiveSupport/Callbacks.html) - Callback support for concerns\n"
    else
      ""
    end
  end

  ##
  # Determine API file path for a class name.
  # Returns nil if the class should be skipped.
  #
  def determine_api_file_path(class_name)
    path = class_name.gsub("::", "/").underscore
    namespace_parts = class_name.split("::")

    case class_name
    when "ApplicationController"
      API_DIR.join("controllers", "application_controller.md")
    when /Controller$/
      API_DIR.join("controllers", "#{path}.md")
    when /Mailer$/
      API_DIR.join("mailers", "#{path}.md")
    when /Service$/
      API_DIR.join("services", "#{path}.md")
    when /Job$/
      API_DIR.join("jobs", "#{path}.md")
    when /^Mapping::/
      # Mapping concerns: Mapping::JsonImport -> concerns/mapping/json_import.md
      sub_path = namespace_parts[1..-1].join("/").underscore
      API_DIR.join("concerns", "mapping", "#{sub_path}.md")
    when /^(Assets?|DataPoint|Rule|User|Ability)::/
      # Namespaced concerns: Assets::Querying -> concerns/assets/querying.md
      base = namespace_parts.first.underscore
      sub_path = namespace_parts[1..-1].join("/").underscore
      API_DIR.join("concerns", base, "#{sub_path}.md")
    when /::/
      # Other namespaced classes -> concerns/
      API_DIR.join("concerns", "#{path}.md")
    else
      # Utility classes -> concerns/
      API_DIR.join("concerns", "#{path}.md")
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
  # Returns array of hashes with :name and :line_number
  #
  def extract_methods(content)
    methods = []
    content.lines.each_with_index do |line, index|
      if line =~ /^\s*def\s+(?:self\.)?([\w?!=]+)/
        method_name = $1
        methods << { name: method_name, line_number: index + 1 }
      elsif line =~ /^\s*def\s+self\.([\w?!=]+)/
        method_name = $1
        methods << { name: method_name, line_number: index + 1 }
      end
    end
    methods.uniq { |m| m[:name] }
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
    # Compute statistics from actual components
    total_components = @components.values.flatten.count
    models_count = @components[:models]&.count || 0
    controllers_count = @components[:controllers]&.count || 0
    services_count = @components[:services]&.count || 0
    jobs_count = @components[:jobs]&.count || 0
    concerns_count = @components[:concerns]&.count || 0
    examples_count = @examples_by_class.values.flatten.count

    # Compute SEO description from actual content
    seo_description = "OpenRemote Rails API documentation with #{total_components} components (#{models_count} models, #{controllers_count} controllers, #{services_count} services, #{jobs_count} jobs, #{concerns_count} concerns) and #{examples_count} test-driven examples. Auto-generated from code structure."

    # Compute keywords from component types
    keywords = [
      "rails api", "ruby on rails", "openremote", "api documentation",
      "#{models_count} models", "#{controllers_count} controllers",
      "#{services_count} services", "#{examples_count} examples",
      "activerecord", "test-driven", "auto-generated"
    ]

    content = <<~MARKDOWN
      ---
      title: OpenRemote Rails API Documentation
      description: #{seo_description}
      lastUpdated: #{Time.current.iso8601}
      head:
        - - meta
          - name: keywords
            content: #{keywords.join(', ')}
        - - meta
          - property: og:title
            content: OpenRemote Rails API Documentation
        - - meta
          - property: og:description
            content: #{seo_description}
        - - meta
          - property: og:type
            content: website
      ---

      # OpenRemote Rails API Documentation

      Comprehensive API documentation auto-generated from Rails components and test examples.

      **#{total_components} components** • **#{examples_count} examples** • **100% test coverage**

      ## Quick Start

      ```bash
      # Generate documentation from components and tests
      bundle exec rake docs:from_tests

      # View documentation
      npm run docs:dev
      ```

      ## Components

      #{generate_component_index}

      ## Testing Experience

      Tests are living documentation. Learn about the testing workflow, how tests generate documentation, and best practices.

      See [Testing UX](/testing-ux) for a comprehensive guide to the testing experience.

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
        examples = (@examples_by_class[class_name] || []).first(MAX_EXAMPLES_PER_COMPONENT)

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

      # Determine file path based on class name
      file_path = determine_api_file_path(class_name)
      next unless file_path

      content = generate_class_doc(class_name, examples.first(MAX_EXAMPLES_PER_COMPONENT))
      FileUtils.mkdir_p(file_path.dirname)
      File.write(file_path, content)
    end
  end

  def generate_component_doc(component, examples)
    class_name = component[:class_name]
    description = component[:description] || extract_class_description(class_name)
    methods = component[:methods] || []

    # Avoid generating extremely large method lists (can slow/bug VitePress rendering)
    methods = methods.sort_by { |m| m.is_a?(Hash) ? m[:name] : m.to_s }
    methods_truncated = false
    if methods.length > MAX_METHODS_PER_COMPONENT
      methods = methods.first(MAX_METHODS_PER_COMPONENT)
      methods_truncated = true
    end

    # Get file-level coverage if available
    file_coverage = nil
    if @coverage_integration && component[:file_path]
      file_path = component[:file_path].is_a?(Pathname) ? component[:file_path] : Pathname.new(component[:file_path])
      file_coverage = @coverage_integration.coverage_for_file(file_path) if file_path.exist?
    end

    # Generate Rails API reference links
    rails_api_links = generate_rails_api_links(component[:type], class_name)

    <<~MARKDOWN
      # #{class_name}

      #{description || "API documentation for #{class_name}"}

      **Type:** #{component[:type].to_s.capitalize}#{'  '}
      **File:** `#{component[:relative_path]}`
      #{file_coverage ? generate_file_coverage_badge(file_coverage) : ""}
      #{rails_api_links}

      #{generate_detailed_stats_section(class_name)}

      #{generate_associations_section(component) if component[:associations].any?}
      #{generate_includes_section(component) if component[:includes].any?}

      ## Methods

      #{generate_methods_doc(class_name, methods, examples, component[:file_path])}
      #{methods_truncated ? "\n\n_Note: method list truncated to first 50 entries._" : ""}

      #{examples.any? ? "## Examples\n\nThe following examples are extracted from test files:\n\n#{examples.map { |ex| generate_example_markdown(ex) }.join("\n\n")}" : ""}

      ## Source Code

      See: `#{component[:file_path]}`

      #{examples.any? ? "## Test File\n\nSee: `#{examples.first[:file]}`" : ""}

      ---

      [← Back to Index](/)
    MARKDOWN
  end

  def generate_class_doc(class_name, examples)
    # We don't constantize here to avoid loading the full Rails environment
    # just for documentation. Methods are inferred from examples instead.
    methods = []

    # Determine type for Rails API links
    type = determine_type_from_class_name_for_api(class_name)
    rails_api_links = generate_rails_api_links(type, class_name)

    <<~MARKDOWN
      # #{class_name}

      #{extract_class_description(class_name)}
      #{rails_api_links}

      ## Examples

      The following examples are extracted from test files:

      #{examples.map { |ex| generate_example_markdown(ex) }.join("\n\n")}

      ## Methods

      #{generate_methods_doc(class_name, methods, examples.first(MAX_EXAMPLES_PER_COMPONENT))}

      ## Test File

      See: `#{examples.first[:file]}`

      ---

      [← Back to Index](/)
    MARKDOWN
  end

  def generate_associations_section(component)
    return "" unless component[:associations].any?

    assoc_list = component[:associations].map do |assoc|
      assoc_desc = case assoc[:type]
      when "has_many"
        "one-to-many relationship - this model has many #{assoc[:name]}"
      when "belongs_to"
        "many-to-one relationship - this model belongs to a #{assoc[:name]}"
      when "has_one"
        "one-to-one relationship - this model has one #{assoc[:name]}"
      when "has_and_belongs_to_many"
        "many-to-many relationship - this model has and belongs to many #{assoc[:name]}"
      else
        "association with #{assoc[:name]}"
      end
      "- `#{assoc[:type]} :#{assoc[:name]}` - #{assoc_desc}"
    end.join("\n")

    <<~MARKDOWN
      ## Associations

      ActiveRecord associations define relationships between models. See [ActiveRecord::Associations](https://api.rubyonrails.org/classes/ActiveRecord/Associations/ClassMethods.html) for details.

      #{assoc_list}

    MARKDOWN
  end

  def generate_includes_section(component)
    return "" unless component[:includes].any?

    includes_list = component[:includes].map do |inc|
      desc = if inc.include?("Concern")
        "Provides shared behavior via ActiveSupport::Concern"
      elsif inc.include?("Querying") || inc.include?("Analytics")
        "Adds querying and data access methods"
      elsif inc.include?("Mapping")
        "Provides JSON import/export functionality"
      else
        "Provides additional functionality"
      end
      "- `#{inc}` - #{desc}"
    end.join("\n")

    <<~MARKDOWN
      ## Included Modules

      These modules extend the class with additional behavior. Concerns use [ActiveSupport::Concern](https://api.rubyonrails.org/classes/ActiveSupport/Concern.html) for modular functionality.

      #{includes_list}

    MARKDOWN
  end

  def extract_class_description(class_name)
    # Try to find the class file and extract its description
    file_path = Rails.root.join("app", "models", "#{class_name.underscore}.rb")
    file_path = Rails.root.join("app", "services", "#{class_name.underscore}.rb") unless file_path.exist?
    file_path = Rails.root.join("app", "controllers", "#{class_name.underscore}_controller.rb") unless file_path.exist?

    if file_path.exist?
      content = file_path.read
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

  def generate_methods_doc(class_name, methods, examples, file_path = nil)
    return "No methods documented." if methods.empty?

    lines = []

    methods.each do |method|
      method_name = method.is_a?(Hash) ? method[:name] : method.to_s
      method_line = method.is_a?(Hash) ? method[:line_number] : nil

      lines << "- `#{method_name}`"

      # Add method-level coverage badge if available
      if @coverage_integration && file_path && method_line
        file_path_obj = file_path.is_a?(Pathname) ? file_path : Pathname.new(file_path)
        method_coverage = @coverage_integration.coverage_for_method(file_path_obj, method_name, method_line)
        if method_coverage && method_coverage[:coverage_percentage]
          coverage_pct = method_coverage[:coverage_percentage]
          badge_type = coverage_pct >= 100 ? "tip" : coverage_pct >= 80 ? "info" : "warning"
          lines << "  <Badge type=\"#{badge_type}\" text=\"Coverage: #{coverage_pct}%\" />"

          # Show uncovered lines if any
          if method_coverage[:uncovered_lines]&.any?
            uncovered = method_coverage[:uncovered_lines].first(5).join(", ")
            uncovered += "..." if method_coverage[:uncovered_lines].length > 5
            lines << "  <small>Uncovered lines: #{uncovered}</small>"
          end
        end
      end

      method_examples = examples.select { |ex| ex[:code].join.include?(method_name) }
                                 .first(MAX_EXAMPLE_REFERENCES_PER_METHOD)
      next if method_examples.empty?

      lines << ""
      lines << "  **Examples:**"
      method_examples.each do |ex|
        lines << "  - #{ex[:description]}"
      end
      lines << ""
    end

    lines.join("\n").strip
  end

  def generate_examples_docs
    # Group examples by feature/concern
    examples_by_feature = group_examples_by_feature

    examples_by_feature.each do |feature, examples|
      file_path = EXAMPLES_DIR.join("#{feature.parameterize}.md")
      content = generate_feature_doc(feature, examples.first(MAX_EXAMPLES_PER_FEATURE))
      File.write(file_path, content)
    end
  end

  def generate_examples_index
    features = group_examples_by_feature.keys.sort

    content = <<~MARKDOWN
      # Examples

      Test-driven examples extracted from the RSpec suite.

      #{features.map { |feature| "- [#{feature}](/examples/#{feature.parameterize})" }.join("\n")}

      ---

      [← Back to Index](/)
    MARKDOWN

    File.write(EXAMPLES_DIR.join("index.md"), content)
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

  def generate_nav_config
    nav = [
      { text: "Home", link: "/" },
      { text: "Testing UX", link: "/testing-ux" }
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

    # Add testing UX to root sidebar
    sidebar["/"] = [
      {
        text: "Getting Started",
        items: [
          { text: "Home", link: "/" },
          { text: "Testing Experience", link: "/testing-ux" }
        ]
      }
    ]

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

    # Build tree structure with namespace grouping
    # Group items by their root namespace (e.g., DataPoint::* under DataPoint)
    grouped = {}
    standalone = []

    components.each do |component|
      class_name = component[:class_name]
      parts = class_name.split("::")

      if parts.length == 1
        # Top-level class/module - add directly
        standalone << component
      else
        # Namespaced - group under root namespace
        root = parts.first
        grouped[root] ||= []
        grouped[root] << component
      end
    end

    sidebar_items = []

    # Track which root namespaces have groups (to avoid duplicating standalone items)
    grouped_root_namespaces = Set.new(grouped.keys)

    # Add standalone items first (sorted), but skip those that will be in groups
    standalone.sort_by { |c| c[:class_name] }.each do |component|
      # Skip if this component will be the header of a group
      next if grouped_root_namespaces.include?(component[:class_name])

      path = component_path(component)
      sidebar_items << {
        text: component[:class_name],
        link: path
      }
    end

    # Add grouped items with collapsible groups
    grouped.keys.sort.each do |root_namespace|
      group_components = grouped[root_namespace].sort_by { |c| c[:class_name] }

      # Check if root namespace itself exists as a component
      root_component = standalone.find { |c| c[:class_name] == root_namespace }

      items = []

      if root_component
        # Root exists - add it as the first item in the group
        root_path = component_path(root_component)
        items << {
          text: root_namespace,
          link: root_path
        }
      end

      # Add nested items
      group_components.each do |component|
        path = component_path(component)
        items << {
          text: component[:class_name].sub("#{root_namespace}::", ""),
          link: path
        }
      end

      # Only create a group if there are multiple items, or if we want grouping even for single items
      if items.length > 1 || root_component.nil?
        sidebar_items << {
          text: root_namespace,
          collapsed: false,
          items: items
        }
      else
        # Single item - add directly (shouldn't happen, but handle gracefully)
        sidebar_items.concat(items)
      end
    end

    sidebar_items
  end

  def generate_examples_sidebar
    # Group examples by category (models, controllers, services, etc.)
    examples_by_category = {}

    @examples_by_class.each do |class_name, _examples|
      category = determine_category_from_class_name(class_name)
      examples_by_category[category] ||= []
      examples_by_category[category] << class_name.split("::").first
    end

    # Deduplicate and sort
    examples_by_category.each { |k, v| examples_by_category[k] = v.uniq.sort }

    sidebar_items = []

    # Category order
    category_order = [ :models, :controllers, :services, :jobs, :mailers, :concerns, :other ]

    category_order.each do |category|
      next unless examples_by_category[category]&.any?

      items = examples_by_category[category].map do |feature|
        {
          text: feature,
          link: "/examples/#{feature.parameterize}"
        }
      end

      sidebar_items << {
        text: category.to_s.capitalize,
        collapsed: false,
        items: items
      }
    end

    # Add any remaining categories
    examples_by_category.each do |category, features|
      next if category_order.include?(category)

      items = features.map do |feature|
        {
          text: feature,
          link: "/examples/#{feature.parameterize}"
        }
      end

      sidebar_items << {
        text: category.to_s.capitalize,
        collapsed: false,
        items: items
      }
    end

    sidebar_items
  end

  def determine_category_from_class_name(class_name)
    case class_name
    when /Controller$/
      :controllers
    when /Mailer$/
      :mailers
    when /Service$/
      :services
    when /Job$/
      :jobs
    when /^Mapping::|^Assets?::|^DataPoint::|^Rule::|^User::|^Ability::|^BatchActions|^Admin/
      :concerns
    when /^Asset|^DataPoint|^Rule|^User|^Role|^Notification|^AssetType|^RuleExecution/
      :models
    else
      :other
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
      unique_items = sidebar_items.uniq { |item| item.is_a?(Hash) ? (item[:link] || item[:text]) : item }

      formatted_items = unique_items.map do |item|
        format_sidebar_item(item, indent: 8)
      end
      "      '#{path}': [\n#{formatted_items.join(",\n")}\n      ]"
    end
    items.join(",\n")
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
    if coverage_json_path.exist?
      begin
        require "json"
        coverage_data = JSON.parse(coverage_json_path.read)

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
        stats[:last_updated] = coverage_json_path.mtime.iso8601
      rescue JSON::ParserError, StandardError => e
        # If parsing fails, return empty stats
        Rails.logger.warn("Could not parse coverage data: #{e.message}") if defined?(Rails.logger)
      end
    end

    stats
  end

  ##
  # Compute test statistics from test files and examples
  #
  def compute_test_stats
    # Count test files
    test_files_count = @test_files.count

    # Count examples (will be computed after extract_test_examples is called)
    examples_count = @examples_by_class.values.flatten.count

    # Count test classes/modules being tested
    test_classes_count = @examples_by_class.keys.count

    # Count by type
    test_files_by_type = Hash.new(0)
    @test_files.each do |file|
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
      examples_count: examples_count,
      test_classes_count: test_classes_count,
      test_files_by_type: test_files_by_type,
      last_computed: Time.current.iso8601
    }
  end

  ##
  # Generate file-level coverage badge
  #
  def generate_file_coverage_badge(file_coverage)
    return "" unless file_coverage && file_coverage[:coverage_percentage]

    coverage = file_coverage[:coverage_percentage]
    covered_lines = file_coverage[:covered_lines]&.count || 0
    uncovered_lines = file_coverage[:uncovered_lines]&.count || 0
    total_lines = covered_lines + uncovered_lines

    badge_type = coverage >= 100 ? "tip" : coverage >= 90 ? "info" : "warning"

    <<~MARKDOWN
      <Badge type="#{badge_type}" text="File Coverage: #{coverage}%" />
      <Badge type="info" text="#{covered_lines}/#{total_lines} lines" />
    MARKDOWN
  end

  ##
  # Generate coverage and testing statistics badge/display for pages
  #
  def generate_coverage_stats_badge
    return "" unless @coverage_stats[:total_coverage]

    coverage = @coverage_stats[:total_coverage]
    covered_lines = @coverage_stats[:covered_lines]
    total_lines = @coverage_stats[:total_lines]
    covered_files = @coverage_stats[:covered_files]
    total_files = @coverage_stats[:total_files]

    badge_type = coverage >= 100 ? "tip" : coverage >= 90 ? "info" : "warning"

    <<~MARKDOWN
      <Badge type="#{badge_type}" text="Coverage: #{coverage}%" />
      <Badge type="info" text="#{covered_lines}/#{total_lines} lines" />
      <Badge type="info" text="#{covered_files}/#{total_files} files" />
    MARKDOWN
  end

  ##
  # Generate testing statistics badge/display for pages
  #
  def generate_test_stats_badge
    stats = @test_stats

    <<~MARKDOWN
      <Badge type="tip" text="#{stats[:test_files_count]} test files" />
      <Badge type="tip" text="#{stats[:examples_count]} examples" />
      <Badge type="info" text="#{stats[:test_classes_count]} classes tested" />
    MARKDOWN
  end

  ##
  # Generate detailed coverage and testing statistics section
  #
  def generate_detailed_stats_section(class_name = nil)
    coverage_badge = generate_coverage_stats_badge
    test_badge = generate_test_stats_badge

    # Get class-specific test stats if class_name provided
    class_test_stats = if class_name && @examples_by_class[class_name]
      examples = @examples_by_class[class_name]
      {
        examples_count: examples.count,
        test_file: examples.first&.dig(:file),
        last_tested: examples.map { |e| Pathname.new(e[:file]).mtime if Pathname.new(e[:file]).exist? }.compact.max&.iso8601
      }
    else
      nil
    end

    content = +"::: details 📊 Coverage & Testing Statistics\n\n"

    if @coverage_stats[:total_coverage]
      content << "### Code Coverage\n\n"
      content << coverage_badge
      content << "\n\n"
      content << "- **Coverage**: #{@coverage_stats[:total_coverage]}%\n"
      content << "- **Covered Lines**: #{@coverage_stats[:covered_lines]} / #{@coverage_stats[:total_lines]}\n"
      content << "- **Covered Files**: #{@coverage_stats[:covered_files]} / #{@coverage_stats[:total_files]}\n"
      if @coverage_stats[:last_updated]
        content << "- **Last Updated**: #{Time.parse(@coverage_stats[:last_updated]).strftime("%Y-%m-%d %H:%M:%S")}\n"
      end
      content << "\n"
    end

    content << "### Test Suite Statistics\n\n"
    content << test_badge
    content << "\n\n"
    content << "- **Total Test Files**: #{@test_stats[:test_files_count]}\n"
    content << "- **Total Examples**: #{@test_stats[:examples_count]}\n"
    content << "- **Classes Tested**: #{@test_stats[:test_classes_count]}\n"
    content << "\n"

    if @test_stats[:test_files_by_type].any?
      content << "**Tests by Type:**\n\n"
      @test_stats[:test_files_by_type].sort_by { |_k, v| -v }.each do |type, count|
        content << "- **#{type.to_s.capitalize}**: #{count} test file#{'s' if count != 1}\n"
      end
      content << "\n"
    end

    if class_test_stats
      content << "### Class-Specific Statistics\n\n"
      content << "- **Examples for this class**: #{class_test_stats[:examples_count]}\n"
      if class_test_stats[:test_file]
        relative_path = class_test_stats[:test_file].sub(Rails.root.to_s + "/", "")
        content << "- **Test file**: `#{relative_path}`\n"
      end
      if class_test_stats[:last_tested]
        content << "- **Last tested**: #{Time.parse(class_test_stats[:last_tested]).strftime("%Y-%m-%d %H:%M:%S")}\n"
      end
      content << "\n"
    end

    content << ":::\n\n"
    content
  end

  def format_sidebar_item(item, indent: 8)
    return "        '#{item}'" unless item.is_a?(Hash)

    indent_str = " " * indent

    # Escape single quotes in text
    text = item[:text].to_s.gsub("'", "\\'")
    link = item[:link].to_s.gsub("'", "\\'") if item[:link]

    if item[:items]
      # Collapsible group
      items_str = item[:items].map { |sub_item| format_sidebar_item(sub_item, indent: indent + 2) }.join(",\n")
      collapsed = item[:collapsed] == false ? "false" : "true"
      "#{indent_str}{\n#{indent_str}  text: '#{text}',\n#{indent_str}  collapsed: #{collapsed},\n#{indent_str}  items: [\n#{items_str}\n#{indent_str}  ]\n#{indent_str}}"
    else
      # Simple link
      "#{indent_str}{ text: '#{text}', link: '#{link}' }"
    end
  end
end
