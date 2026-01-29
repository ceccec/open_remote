# frozen_string_literal: true

namespace :features do
  desc "Generate tests from model feature declarations"
  task generate_tests: :environment do
    require_relative "../models/feature_generator"
    Rails.application.eager_load!

    models = ActiveRecord::Base.descendants.select { |m| m.respond_to?(:features) && m.features.any? }

    models.each do |model|
      generator = FeatureGenerator.new(model)
      spec_path = "spec/models/#{model.name.underscore}_spec.rb"
      FileUtils.mkdir_p(File.dirname(spec_path))
      File.write(spec_path, generator.generate_test)
      puts "✅ Generated: #{spec_path}"
    end
  end

  desc "Generate feature specs from model feature declarations"
  task generate_feature_specs: :environment do
    require_relative "../models/feature_generator"
    Rails.application.eager_load!

    models = ActiveRecord::Base.descendants.select { |m| m.respond_to?(:features) && m.features.any? }

    models.each do |model|
      generator = FeatureGenerator.new(model)
      spec_path = "spec/features/models/#{model.name.underscore}_features_spec.rb"
      FileUtils.mkdir_p(File.dirname(spec_path))
      File.write(spec_path, generator.generate_feature_spec)
      puts "✅ Generated: #{spec_path}"
    end
  end

  desc "Generate feature documentation"
  task generate_docs: :environment do
    require_relative "../models/feature_generator"
    Rails.application.eager_load!

    models = ActiveRecord::Base.descendants.select { |m| m.respond_to?(:features) && m.features.any? }

    doc_content = "# Model Features\n\n"
    doc_content << "This document is auto-generated from model feature declarations.\n\n"
    doc_content << "**Last Updated**: #{Time.current.strftime("%Y-%m-%d %H:%M:%S")}\n\n"
    doc_content << "---\n\n"

    models.each do |model|
      doc_content << model.feature_documentation
      doc_content << "\n---\n\n"
    end

    File.write("docs/model_features.md", doc_content)
    puts "✅ Generated: docs/model_features.md"
  end

  desc "List all declared features"
  task list: :environment do
    # Load all models
    Rails.application.eager_load!

    models = ActiveRecord::Base.descendants.select { |m| m.respond_to?(:features) && m.features.any? }

    puts "\n📋 Model Features Summary\n"
    puts "=" * 80

    models.each do |model|
      puts "\n#{model.name}:"
      puts "  Validations: #{model.features_of_type(:validates).count}"
      puts "  Associations: #{model.features_of_type(:associates).count}"
      puts "  Methods: #{model.features_of_type(:provides).sum { |f| f[:args].count }}"
      puts "  Scopes: #{model.features_of_type(:scopes).sum { |f| f[:args].count }}"
    end

    total_features = models.sum { |m| m.features.count }
    puts "\n" + "=" * 80
    puts "Total: #{models.count} models, #{total_features} feature declarations"
  end
end
