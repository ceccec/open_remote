# frozen_string_literal: true

##
# Rake task to enrich documentation with standard VitePress styling
# Adds callouts, badges, tables, and consistent formatting
#
namespace :docs do
  desc "Enrich documentation with standard VitePress styling"
  task enrich_styling: :environment do
    require_relative "docs_styling_enricher"
    enricher = DocsStylingEnricher.new
    enricher.enrich_all
  end
end
