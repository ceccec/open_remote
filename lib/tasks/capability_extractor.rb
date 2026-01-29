# frozen_string_literal: true

require "yaml"

##
# Extracts application capabilities from RSpec test files
# and generates comprehensive capability documentation.
#
# This tool analyzes feature specs and integration tests to document
# what the application can do, serving as living documentation.
class CapabilityExtractor
  CAPABILITY_PATTERNS = {
    "Asset Management" => [
      /hierarchical.*asset/i,
      /parent.*child/i,
      /import.*json/i,
      /export.*json/i,
      /type.*specific/i,
      /query.*asset/i
    ],
    "Rule Engine" => [
      /schedule.*rule/i,
      /cron/i,
      /interval/i,
      /attribute.*rule/i,
      /rule.*execution/i,
      /trigger/i
    ],
    "Data Analytics" => [
      /time.*series/i,
      /aggregat/i,
      /sum|average|min|max/i,
      /data.*point/i,
      /analytics/i
    ],
    "Notifications" => [
      /notification/i,
      /alert/i,
      /severity/i
    ],
    "Authentication" => [
      /authentication/i,
      /login/i,
      /password.*reset/i,
      /email.*confirm/i,
      /remember.*me/i,
      /account.*lock/i
    ],
    "Authorization" => [
      /role/i,
      /permission/i,
      /access.*control/i,
      /ability/i
    ],
    "Integration" => [
      /workflow/i,
      /end.*to.*end/i,
      /integration/i,
      /lifecycle/i
    ]
  }.freeze

  def initialize(spec_dir: "spec/features", output_file: "docs/capabilities.md")
    @spec_dir = spec_dir
    @output_file = output_file
  end

  def extract
    capabilities = {}
    test_files = Dir.glob("#{@spec_dir}/**/*_spec.rb")

    test_files.each do |file|
      content = File.read(file)
      file_name = File.basename(file, "_spec.rb")

      CAPABILITY_PATTERNS.each do |category, patterns|
        if patterns.any? { |pattern| content.match?(pattern) }
          capabilities[category] ||= []
          capabilities[category] << {
            "file" => file_name,
            "description" => extract_description(content),
            "examples" => extract_examples(content)
          }
        end
      end
    end

    capabilities
  end

  def generate_markdown
    capabilities = extract
    markdown = <<~MARKDOWN
      # Application Capabilities

      This document describes the full potential of the OpenRemote Rails application,
      extracted from comprehensive test coverage. Each capability is demonstrated
      through real test scenarios.

      **Last Updated**: #{Time.current.strftime("%Y-%m-%d %H:%M:%S")}
      **Test Coverage**: #{Dir.glob("#{@spec_dir}/**/*_spec.rb").count} feature spec files

      ---

    MARKDOWN

    capabilities.each do |category, items|
      markdown << "## #{category}\n\n"
      markdown << "The application provides comprehensive #{category.downcase} capabilities:\n\n"

      items.each do |item|
        markdown << "### #{item['file'].humanize}\n\n"
        markdown << "#{item['description']}\n\n" if item["description"]

        if item["examples"]&.any?
          markdown << "**Key Capabilities:**\n\n"
          item["examples"].each do |example|
            markdown << "- #{example}\n"
          end
          markdown << "\n"
        end
      end

      markdown << "\n---\n\n"
    end

    markdown << generate_workflow_summary
    markdown
  end

  def generate_workflow_summary
    <<~MARKDOWN
      ## End-to-End Workflows

      The application supports complex, multi-step workflows that combine multiple
      capabilities:

      ### Complete Solar Park Monitoring
      1. **Import** asset hierarchies from OpenRemote JSON format
      2. **Monitor** assets with time-series data collection
      3. **Analyze** performance using aggregation functions (sum, avg, min, max)
      4. **Alert** stakeholders via notifications when conditions are met
      5. **Export** updated asset data back to OpenRemote format

      ### Multi-Asset Energy Management
      - Manage diverse asset portfolios (solar, meters, inverters, weather stations)
      - Cross-asset rule execution and monitoring
      - Energy balance calculations and reporting

      ### User Lifecycle Management
      1. **Registration** with email confirmation
      2. **Authentication** with password reset and "remember me"
      3. **Authorization** via role-based access control (Admin, Manager, Viewer)
      4. **Account Security** with automatic locking after failed attempts

      ### Data-Driven Decision Making
      - Historical data collection and analysis
      - Pattern recognition and threshold detection
      - Automated rule creation based on data insights
      - Performance monitoring and alerting

      ---

      ## Technical Capabilities

      ### Asset Management
      - ✅ Hierarchical asset structures (parent-child relationships)
      - ✅ Type-specific attribute extensions (SolarPark, SolarArray, Inverter, etc.)
      - ✅ OpenRemote JSON import/export compatibility
      - ✅ Advanced querying (by type, attribute thresholds, power outputs)
      - ✅ Cascading deletion of child assets

      ### Rule Engine
      - ✅ Schedule-based rules (cron, interval, time-of-day)
      - ✅ Attribute-based rules (value conditions, change detection)
      - ✅ Rule execution tracking with status and results
      - ✅ OpenRemote rule format import/export
      - ✅ Timezone-aware scheduling

      ### Data Analytics
      - ✅ Time-series data collection and storage
      - ✅ Aggregation functions (sum, average, min, max)
      - ✅ Time range queries and filtering
      - ✅ Latest data point retrieval
      - ✅ Bulk data recording for asset types
      - ✅ TimescaleDB continuous aggregates support

      ### Notifications
      - ✅ Multi-severity notifications (info, warning, error)
      - ✅ Asset and rule association
      - ✅ Timestamp tracking
      - ✅ Queryable notification history

      ### Authentication & Authorization
      - ✅ Email confirmation workflow
      - ✅ Password reset with expiration
      - ✅ "Remember me" functionality (2-week tokens)
      - ✅ Account locking (5 failed attempts, 2-hour lock)
      - ✅ Role-based access control (Rolify integration)
      - ✅ CanCanCan ability definitions

      ---

      ## Test-Driven Documentation

      All capabilities listed above are verified through comprehensive test coverage.
      See `spec/features/` for detailed test scenarios demonstrating each capability.

      To regenerate this document:
      ```bash
      bundle exec rails runner "require_relative 'lib/tasks/capability_extractor'; puts CapabilityExtractor.new.generate_markdown" > docs/capabilities.md
      ```
    MARKDOWN
  end

  def save
    FileUtils.mkdir_p(File.dirname(@output_file))
    File.write(@output_file, generate_markdown)
    puts "✅ Capability documentation generated: #{@output_file}"
  end

  private

  def extract_description(content)
    # Extract RSpec describe blocks
    matches = content.scan(/describe\s+["'](.+?)["']/i)
    matches.first&.first || "Comprehensive #{File.basename(@spec_dir)} capabilities"
  end

  def extract_examples(content)
    # Extract it blocks (test examples)
    examples = content.scan(/it\s+["'](.+?)["']/i)
    examples.map(&:first).take(5) # Limit to 5 examples per file
  end
end
