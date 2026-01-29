# frozen_string_literal: true

namespace :test do
  desc "Generate slim tests for a model or concern"
  task :generate, [ :path ] => :environment do |_t, args|
    require_relative "test_generator"

    path = args[:path] || raise("Usage: rake test:generate[app/models/concerns/user/confirmable.rb]")

    unless File.exist?(path)
      puts "❌ File not found: #{path}"
      exit 1
    end

    generator = TestGenerator.new(path)
    spec_content = generator.generate

    # Determine output path
    spec_path = path.gsub("app/models", "spec/models").gsub(".rb", "_spec.rb")
    FileUtils.mkdir_p(File.dirname(spec_path))
    File.write(spec_path, spec_content)

    puts "✅ Generated spec: #{spec_path}"
  end

  desc "Generate tests for all untested models and concerns"
  task generate_all: :environment do
    require_relative "test_generator"

    models = Dir.glob("app/models/**/*.rb").reject { |f| f.include?("concerns") || f.include?("ability") }
    concerns = Dir.glob("app/models/concerns/**/*.rb").reject { |f| f.include?("admin") }

    generated = 0
    skipped = 0

    (models + concerns).each do |model_path|
      spec_path = model_path.gsub("app/models", "spec/models").gsub(".rb", "_spec.rb")
      next if File.exist?(spec_path)

      begin
        generator = TestGenerator.new(model_path)
        spec_content = generator.generate
        FileUtils.mkdir_p(File.dirname(spec_path))
        File.write(spec_path, spec_content)
        puts "✅ Generated: #{spec_path}"
        generated += 1
      rescue StandardError => e
        puts "⚠️  Skipped #{model_path}: #{e.message}"
        skipped += 1
      end
    end

    puts "\n📊 Summary: Generated #{generated}, Skipped #{skipped}"
  end
end
