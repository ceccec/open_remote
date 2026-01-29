# frozen_string_literal: true

namespace :docs do
  desc "Generate all documentation including README"
  task generate_all: :environment do
    require_relative "docs_generator_comprehensive"
    generator = ComprehensiveDocsGenerator.new
    generator.generate_all
  end

  desc "Generate README.md"
  task readme: :environment do
    require_relative "docs_generator_comprehensive"
    generator = ComprehensiveDocsGenerator.new
    generator.generate_readme
  end

  desc "Generate model features documentation"
  task features: :environment do
    require_relative "docs_generator_comprehensive"
    generator = ComprehensiveDocsGenerator.new
    generator.generate_model_features_doc
  end

  desc "Generate interactions documentation"
  task interactions: :environment do
    require_relative "docs_generator_comprehensive"
    generator = ComprehensiveDocsGenerator.new
    generator.generate_interactions_doc
  end

  desc "Generate capabilities documentation"
  task capabilities: :environment do
    require_relative "docs_generator_comprehensive"
    generator = ComprehensiveDocsGenerator.new
    generator.generate_capabilities_doc
  end

  desc "Generate architecture documentation"
  task architecture: :environment do
    require_relative "docs_generator_comprehensive"
    generator = ComprehensiveDocsGenerator.new
    generator.generate_architecture_doc
  end

  desc "Generate API index"
  task api_index: :environment do
    require_relative "docs_generator_comprehensive"
    generator = ComprehensiveDocsGenerator.new
    generator.generate_api_index
  end

  desc "Generate VitePress config"
  task vitepress_config: :environment do
    require_relative "docs_generator_comprehensive"
    generator = ComprehensiveDocsGenerator.new
    generator.generate_vitepress_config
  end
end
