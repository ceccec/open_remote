# frozen_string_literal: true

namespace :interactions do
  desc "Generate interaction documentation from concern declarations"
  task generate_docs: :environment do
    Rails.application.eager_load!

    # Generate documentation directly
    doc = +"# Model Interactions via Concerns\n\n"
    doc << "This document describes how models interact with each other through shared concerns.\n\n"
    doc << "**Last Updated**: #{Time.current.strftime("%Y-%m-%d %H:%M:%S")}\n\n"
    doc << "---\n\n"

    # Find all concerns with interactions
    concerns = ObjectSpace.each_object(Module).select do |mod|
      next false unless mod.is_a?(Module)
      next false if mod.name.nil? || mod.name.empty?
      next false if mod.name.start_with?("Rails::") || mod.name.start_with?("ActiveRecord::") || mod.name.start_with?("Action")
      mod.respond_to?(:enables_interactions) && mod.enables_interactions.any?
    end

    concerns.each do |concern|
      doc << "## #{concern.name}\n\n"
      doc << "This concern enables the following model interactions:\n\n"

      concern.enables_interactions.each do |interaction|
        models = interaction[:models].map { |m| "`#{m}`" }.join(", ")
        doc << "### #{interaction[:type].to_s.humanize}\n\n"
        doc << "- **Models**: #{models}\n"
        doc << "- **Description**: #{interaction[:description]}\n\n" if interaction[:description]
      end

      doc << "---\n\n"
    end

    File.write("docs/model_interactions.md", doc)
    puts "✅ Generated: docs/model_interactions.md"
  end

  desc "List all model interactions"
  task list: :environment do
    Rails.application.eager_load!

    puts "\n🔗 Model Interactions via Concerns\n"
    puts "=" * 80

    # Find all concerns with interactions
    concerns = ObjectSpace.each_object(Module).select do |mod|
      next false unless mod.is_a?(Module)
      next false if mod.name.nil? || mod.name.empty?
      next false if mod.name.start_with?("Rails::") || mod.name.start_with?("ActiveRecord::") || mod.name.start_with?("Action")
      mod.respond_to?(:enables_interactions) && mod.enables_interactions.any?
    end

    concerns.each do |concern|
      puts "\n#{concern.name}:"
      concern.enables_interactions.each do |interaction|
        models = interaction[:models].join(", ")
        puts "  #{interaction[:type]}: #{models}"
        puts "    #{interaction[:description]}" if interaction[:description]
      end
    end

    # Show model capabilities
    puts "\n" + "=" * 80
    puts "\nModel Capabilities:\n"

    ActiveRecord::Base.descendants.each do |model|
      interactions = model.included_modules.flat_map do |mod|
        next [] unless mod.respond_to?(:enables_interactions)
        mod.enables_interactions.select { |i| i[:models].include?(model.name.to_sym) }
      end

      next if interactions.empty?

      puts "\n#{model.name}:"
      interactions.each do |interaction|
        puts "  - #{interaction[:type]}: #{interaction[:description]}"
      end
    end
  end
end
