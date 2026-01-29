# frozen_string_literal: true

##
# Enriches documentation markdown files with standard VitePress styling
# Adds callouts, badges, tables, and consistent formatting
#
class DocsStylingEnricher
  DOCS_DIR = Rails.root.join("docs")
  API_DIR = DOCS_DIR.join("api")

  def enrich_all
    puts "Enriching documentation with standard VitePress styling..."

    # Process all markdown files
    markdown_files = Dir.glob(DOCS_DIR.join("**/*.md"))
    markdown_files.reject! { |f| f.include?("node_modules") || f.include?(".vitepress") }

    markdown_files.each do |file_path|
      enrich_file(file_path)
    end

    puts "✅ Enriched #{markdown_files.size} documentation files"
  end

  private

  def enrich_file(file_path)
    content = File.read(file_path)
    original_content = content.dup

    # Apply styling enhancements
    content = enrich_rails_references(content)
    content = enrich_code_examples(content)
    content = enrich_method_sections(content)
    content = enrich_test_statistics(content)
    content = enrich_source_links(content)
    content = enrich_type_badges(content)
    content = enrich_file_references(content)
    content = enrich_inheritance_info(content)

    # Only write if content changed
    if content != original_content
      File.write(file_path, content)
      relative_path = Pathname.new(file_path).relative_path_from(Rails.root)
      puts "  ✓ Enriched: #{relative_path}"
    end
  end

  def enrich_rails_references(content)
    # Convert Rails Framework References to a styled callout
    if content.include?("**Rails Framework References:**")
      content = content.gsub(
        /(\*\*Rails Framework References:\*\*\s*\n)((?:\*\*[^*]+\*\*:.*\n?)+)/m,
        <<~MARKDOWN
          ::: info Rails Framework References

          This component extends Rails framework functionality. Key references:

          \\2
          :::
        MARKDOWN
      )
    end

    content
  end

  def enrich_code_examples(content)
    # Fix malformed code blocks (closing with ```ruby instead of ```)
    content = content.gsub(
      /```ruby\n([^`]+)```ruby\n/m,
      "```ruby\n\\1```\n"
    )

    # Fix multiple nested small tags
    while content.include?("<small><small")
      content = content.gsub(
        /<small><small([^>]*)>/,
        '<small\\1>'
      )
      content = content.gsub(
        /<\/small><\/small>/,
        "</small>"
      )
    end

    content
  end

  def enrich_method_sections(content)
    # Convert method lists to tables for better readability
    if content.match?(/^## Methods\s*\n\s*\n- `/)
      methods = content.scan(/^- `([^`]+)`/)
      if methods.any? && methods.size > 3 # Only convert if multiple methods
        table = "## Methods\n\n| Method | Description |\n|--------|-------------|\n"
        methods.each do |method_name|
          table += "| `#{method_name[0]}` | _See method documentation_ |\n"
        end
        table += "\n"
        content = content.gsub(
          /(## Methods\s*\n\s*\n)(- `[^`]+`\s*\n?)+/m,
          table
        )
      end
    end

    content
  end

  def enrich_test_statistics(content)
    # Convert statistics lists to tables
    if content.include?("**Tests by Type:**") && !content.include?("| Type | Count |")
      # Extract the list items
      list_match = content.match(/(\*\*Tests by Type:\*\*\s*\n\s*\n)((?:\*\*[^*]+\*\*:.*\n?)+)/m)
      if list_match
        list_items = list_match[2].scan(/- \*\*([^*]+)\*\*: (\d+) (test files?)/)
        if list_items.any?
          table = "**Tests by Type:**\n\n| Type | Count |\n|------|-------|\n"
          list_items.each do |type, count, unit|
            table += "| **#{type}** | #{count} #{unit} |\n"
          end
          table += "\n"
          content = content.gsub(
            /(\*\*Tests by Type:\*\*\s*\n\s*\n)((?:\*\*[^*]+\*\*:.*\n?)+)/m,
            table
          )
        end
      end
    end

    content
  end

  def enrich_source_links(content)
    # Remove all existing small tags around source links first
    content = content.gsub(
      /<small[^>]*>_Source: ([^<]+)<\/small>/,
      '_Source: \\1'
    )

    # Now wrap source links that aren't already wrapped
    content = content.gsub(
      /_Source: `([^`]+)`_/,
      '<small class="text-gray-500">_Source: `\\1`_</small>'
    )

    content = content.gsub(
      /_Source: (\/Users\/[^_]+)_/,
      '<small class="text-gray-500">_Source: `\\1`_</small>'
    )

    content
  end

  def enrich_type_badges(content)
    # Fix literal \n in badges first
    content = content.gsub(
      /<Badge[^>]+>\\n/,
      "<Badge type=\"info\" text=\"Models\" />\n"
    )

    # Convert Type labels to badges (only if not already converted)
    content = content.gsub(
      /\*\*Type:\*\* (.+?)\s*\n/,
      "<Badge type=\"info\" text=\"\\1\" />\n\n"
    )

    content
  end

  def enrich_file_references(content)
    # Style file references with code formatting
    content = content.gsub(
      /\*\*File:\*\* `([^`]+)`/,
      '**File:** <code>\\1</code>'
    )

    content
  end

  def enrich_inheritance_info(content)
    # Remove ALL inheritance callouts first (we'll add one back if needed)
    content = content.gsub(
      /::: tip \w+ Inheritance\s+\n\s+This \w+ inherits from `[^`]+`, providing access to all base functionality\.\s+\n\s+:::\s*\n+/m,
      ""
    )

    # Add callout for inheritance information (only once, if inheritance line exists)
    if content.match?(/This (model|concern|controller|service|job) inherits from/)
      inheritance_match = content.match(/This (model|concern|controller|service|job) inherits from `([^`]+)`/)
      if inheritance_match && !content.include?("::: tip")
        type = inheritance_match[1]
        base_class = inheritance_match[2]

        tip = <<~MARKDOWN

          ::: tip #{type.capitalize} Inheritance

          This #{type} inherits from `#{base_class}`, providing access to all base functionality.

          :::
        MARKDOWN

        # Insert after the inheritance line
        content = content.gsub(
          /(This #{type} inherits from `#{base_class}`[^\n]+\n)/,
          "\\1#{tip}"
        )
      end
    end

    content
  end
end
