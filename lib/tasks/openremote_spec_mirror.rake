namespace :openremote do
  desc "Pull latest changes from upstream OpenRemote git repository into tmp/openremote"
  task :pull do
    java_root = Rails.root.join("tmp", "openremote")

    unless Dir.exist?(java_root)
      warn "Upstream OpenRemote repo not found at #{java_root} – clone it there first, then re-run rake openremote:pull"
      next
    end

    git_dir = java_root.join(".git")
    unless Dir.exist?(git_dir)
      warn "#{java_root} exists but is not a git repository (no .git directory)."
      next
    end

    Dir.chdir(java_root) do
      system("git pull --rebase --ff-only") || abort("git pull failed in #{java_root}")
    end
  end

  desc "Generate RSpec skeletons mirroring upstream OpenRemote Java tests"
  task generate_spec_skeletons: :environment do
    require "fileutils"

    java_root = Rails.root.join("tmp", "openremote")
    unless Dir.exist?(java_root)
      warn "Upstream OpenRemote repo not found at #{java_root}"
      next
    end

    spec_root = Rails.root.join("spec", "openremote_mirror")
    FileUtils.mkdir_p(spec_root)

    # Find all Java test files (simple heuristic: *Test.java under src/test/java)
    pattern = File.join(java_root.to_s, "**", "src", "test", "java", "**", "*Test.java")
    test_files = Dir.glob(pattern)

    if test_files.empty?
      warn "No Java test files found under #{pattern}"
      next
    end

    test_files.each do |java_path|
      relative = java_path.sub(%r{\A#{Regexp.escape(java_root.to_s)}/?}, "")

      # Extract package path and class name from the Java path
      parts = relative.split(File::SEPARATOR)
      idx = parts.index("java")
      next unless idx
      package_parts = parts[(idx + 1)..-1]
      class_file = package_parts.pop
      class_name = class_file.sub(/\.java\z/, "")
      package_name = package_parts.join(".")

      # Determine spec file path (mirror package structure)
      spec_dir = File.join(spec_root, *package_parts.map { |p| p.downcase })
      FileUtils.mkdir_p(spec_dir)
      spec_path = File.join(spec_dir, "#{class_name.underscore}_spec.rb")

      # Read Java file to discover test methods
      src = File.read(java_path)

      # Match methods either annotated with @Test or named starting with test*
      method_names = []

      src.scan(/@Test\s+public\s+void\s+(\w+)\s*\(/) do |m|
        method_names << m.first
      end

      src.scan(/public\s+void\s+(test\w*)\s*\(/) do |m|
        method_names << m.first
      end

      method_names.uniq!
      next if method_names.empty?

      # Build or update spec file
      unless File.exist?(spec_path)
        File.open(spec_path, "w") do |f|
          f.puts 'require "rails_helper"'
          f.puts
          f.puts "RSpec.describe #{class_name}, :openremote_source_package => \"#{package_name}\" do"
          f.puts "end"
        end
      end

      existing = File.read(spec_path)

      method_names.each do |method_name|
        marker = %Q(it "#{method_name}")
        next if existing.include?(marker)

        File.open(spec_path, "a") do |f|
          f.puts
          f.puts %Q(  it "#{method_name}", :openremote_source => "#{package_name}.#{class_name}##{method_name}" do)
          f.puts %Q(    pending "TODO: port from Java")
          f.puts "  end"
        end
      end
    end

    puts "Generated/updated RSpec skeletons under #{spec_root}"
  end
end
