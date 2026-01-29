# frozen_string_literal: true

##
# Integrates SimpleCov coverage data into documentation generation
# Shows coverage metrics, uncovered lines, and test coverage visualization
#
class DocsCoverageIntegration
  require "json"

  COVERAGE_DIR = Rails.root.join("coverage")
  COVERAGE_JSON = COVERAGE_DIR.join(".resultset.json")

  def initialize
    @coverage_data = load_coverage_data
  end

  ##
  # Get coverage for a specific file
  #
  def coverage_for_file(file_path)
    return nil unless @coverage_data

    file_path_obj = file_path.is_a?(Pathname) ? file_path : Pathname.new(file_path)

    # Try both relative and absolute paths
    relative_path = file_path_obj.relative_path_from(Rails.root).to_s
    absolute_path = file_path_obj.to_s

    rspec_coverage = @coverage_data.dig("RSpec", "coverage") || {}

    # First try relative path
    file_coverage = rspec_coverage[relative_path]
    # If not found, try absolute path
    file_coverage ||= rspec_coverage[absolute_path]
    # If still not found, try finding by matching the end of the path
    file_coverage ||= rspec_coverage.find { |k, _| k.end_with?(relative_path) || k.end_with?(absolute_path) }&.last

    return nil unless file_coverage && file_coverage.is_a?(Hash)

    {
      lines: file_coverage["lines"],
      branches: file_coverage["branches"],
      coverage_percentage: calculate_coverage_percentage(file_coverage["lines"]),
      covered_lines: covered_lines(file_coverage["lines"]),
      uncovered_lines: uncovered_lines(file_coverage["lines"])
    }
  end

  ##
  # Get coverage for a specific method within a file
  #
  def coverage_for_method(file_path, method_name, line_number)
    file_coverage = coverage_for_file(file_path)
    return nil unless file_coverage

    method_lines = method_lines_range(file_path, method_name, line_number)
    return nil unless method_lines

    lines_data = file_coverage[:lines]

    # Extract coverage for method lines
    if lines_data.is_a?(Array)
      # Array format: index is line number (0-indexed, so subtract 1)
      method_coverage = method_lines.each_with_object({}) do |line_num, hash|
        array_index = line_num - 1
        hash[line_num] = lines_data[array_index] if array_index >= 0 && array_index < lines_data.length
      end
    else
      # Hash format
      method_coverage = lines_data.select { |line_num, _| method_lines.include?(line_num) }
    end

    {
      method_name: method_name,
      line_range: method_lines,
      covered_lines: method_coverage.select { |_, count| count && count > 0 }.keys.sort,
      uncovered_lines: method_coverage.select { |_, count| count.nil? || count == 0 }.keys.sort,
      coverage_percentage: calculate_method_coverage(method_coverage)
    }
  end

  ##
  # Get overall project coverage statistics
  #
  def overall_coverage
    return nil unless @coverage_data

    rspec_coverage = @coverage_data.dig("RSpec", "coverage") || {}
    total_lines = 0
    covered_lines = 0

    rspec_coverage.each_value do |file_data|
      file_data["lines"]&.each_value do |count|
        total_lines += 1
        covered_lines += 1 if count && count > 0
      end
    end

    {
      total_lines: total_lines,
      covered_lines: covered_lines,
      uncovered_lines: total_lines - covered_lines,
      percentage: total_lines > 0 ? (covered_lines.to_f / total_lines * 100).round(2) : 0
    }
  end

  private

  def load_coverage_data
    return nil unless COVERAGE_JSON.exist?

    JSON.parse(COVERAGE_JSON.read)
  rescue StandardError => e
    warn "Failed to load coverage data: #{e.message}"
    nil
  end

  def calculate_coverage_percentage(lines)
    return 0 if lines.nil? || lines.empty?

    # SimpleCov stores lines as either:
    # - Array: [nil, 1, 2, nil, 0, ...] where index is line number
    # - Hash: {1 => 1, 2 => 2, 5 => 0, ...} where key is line number
    if lines.is_a?(Array)
      # Array format: count non-nil entries as total, count > 0 as covered
      total = lines.count { |count| !count.nil? }
      covered = lines.count { |count| count && count > 0 }
    else
      # Hash format
      total = lines.size
      covered = lines.values.count { |count| count && count > 0 }
    end

    total > 0 ? (covered.to_f / total * 100).round(2) : 0
  end

  def calculate_method_coverage(method_coverage)
    return 0 if method_coverage.empty?

    # method_coverage is a hash from method_lines_range
    total = method_coverage.size
    covered = method_coverage.values.count { |count| count && count > 0 }

    total > 0 ? (covered.to_f / total * 100).round(2) : 0
  end

  def covered_lines(lines)
    if lines.is_a?(Array)
      # Array format: return indices where value > 0
      lines.each_with_index.select { |count, _| count && count > 0 }.map { |_, idx| idx + 1 }
    else
      # Hash format
      lines.select { |_, count| count && count > 0 }.keys.sort
    end
  end

  def uncovered_lines(lines)
    if lines.is_a?(Array)
      # Array format: return indices where value is nil or 0
      lines.each_with_index.select { |count, _| count.nil? || count == 0 }.map { |_, idx| idx + 1 }
    else
      # Hash format
      lines.select { |_, count| count.nil? || count == 0 }.keys.sort
    end
  end

  def method_lines_range(file_path, method_name, line_number)
    # Parse file to find method definition and its end
    file_path_obj = file_path.is_a?(Pathname) ? file_path : Pathname.new(file_path)
    content = file_path_obj.read
    lines = content.lines

    start_line = line_number - 1
    end_line = find_method_end(lines, start_line)

    (start_line + 1..end_line).to_a
  end

  def find_method_end(lines, start_line)
    indent_level = lines[start_line].match(/^(\s*)/)[1].length
    current_line = start_line + 1

    while current_line < lines.length
      line = lines[current_line]
      # Method ends when we find a line with same or less indentation (and it's not empty/comment)
      if line.strip.empty? || line.start_with?("#")
        current_line += 1
        next
      end

      current_indent = line.match(/^(\s*)/)[1].length
      return current_line - 1 if current_indent <= indent_level && !line.strip.empty?

      current_line += 1
    end

    lines.length
  end
end
