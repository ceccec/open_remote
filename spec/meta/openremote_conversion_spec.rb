require "rails_helper"

RSpec.describe "OpenRemote upstream test coverage" do
  it "has 1:1 converted, non-skeleton RSpec specs for all upstream Java tests" do
    java_root = Rails.root.join("tmp", "openremote")
    skip "Upstream OpenRemote repo not present under tmp/openremote" unless Dir.exist?(java_root)

    java_tests = Dir.glob(java_root.join("**", "src", "test", "java", "**", "*Test.java"))

    missing_specs = []
    unconverted_specs = []

    java_tests.each do |java_path|
      relative = java_path.sub(%r{\A#{Regexp.escape(java_root.to_s)}/?}, "")
      parts = relative.split(File::SEPARATOR)
      idx = parts.index("java")
      next unless idx

      package_parts = parts[(idx + 1)..-1]
      class_file = package_parts.pop
      class_name = class_file.sub(/\.java\z/, "")

      spec_dir_parts = package_parts.map(&:downcase)
      spec_filename = "#{class_name.underscore}_spec.rb"
      spec_path = Rails.root.join("spec", "openremote_mirror", *spec_dir_parts, spec_filename)

      unless File.exist?(spec_path)
        missing_specs << spec_path.relative_path_from(Rails.root).to_s
        next
      end

      content = File.read(spec_path)

      if content.match?(/RSpec\.describe\s+\w+Test\b/) ||
         content.include?('pending "TODO: port from Java"') ||
         content.include?('skip "port from OpenRemote Java test"')
        unconverted_specs << spec_path.relative_path_from(Rails.root).to_s
      end
    end

    messages = []
    messages << "Missing mirror specs for upstream Java tests:\n  #{missing_specs.join("\n  ")}" if missing_specs.any?
    messages << "Unconverted mirror specs (still skeletons or skipped):\n  #{unconverted_specs.join("\n  ")}" if unconverted_specs.any?

    expect(missing_specs).to be_empty, messages.join("\n\n") if missing_specs.any?
    expect(unconverted_specs).to be_empty, messages.join("\n\n") if unconverted_specs.any?
  end
end
