# frozen_string_literal: true

namespace :docs do
  desc "Generate capability documentation from feature specs"
  task :capabilities do
    require_relative "capability_extractor"
    extractor = CapabilityExtractor.new(
      spec_dir: "spec/features",
      output_file: "docs/capabilities.md"
    )
    extractor.save
  end
end
