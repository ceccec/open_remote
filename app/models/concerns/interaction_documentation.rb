# frozen_string_literal: true

##
# Documents model interactions enabled by concerns.
# Generates documentation showing how models interact through shared concerns.
module InteractionDocumentation
  extend ActiveSupport::Concern

  module ClassMethods
    ##
    # Generate interaction documentation for all models and concerns.
    #
    # @return [String] markdown documentation
    def generate_interaction_docs
      doc = "# Model Interactions via Concerns\n\n"
      doc << "This document describes how models interact with each other through shared concerns.\n\n"
      doc << "**Last Updated**: #{Time.current.strftime("%Y-%m-%d %H:%M:%S")}\n\n"
      doc << "---\n\n"

      # Group interactions by concern
      concerns_by_interaction = {}

      # Find all concerns with interaction declarations
      Rails.application.eager_load!
      ObjectSpace.each_object(Module).select do |mod|
        next false unless mod.is_a?(Module)
        next false if mod.name.nil? || mod.name.empty?
        next false if mod.name.start_with?("Rails::") || mod.name.start_with?("ActiveRecord::") || mod.name.start_with?("Action")
        mod.respond_to?(:enables_interactions) && mod.enables_interactions.any?
      end.each do |concern|
        concern.enables_interactions.each do |interaction|
          concern_name = concern.name
          concerns_by_interaction[concern_name] ||= []
          concerns_by_interaction[concern_name] << interaction
        end
      end

      concerns_by_interaction.each do |concern_name, interactions|
        doc << "## #{concern_name}\n\n"
        doc << "This concern enables the following model interactions:\n\n"

        interactions.each do |interaction|
          models = interaction[:models].map { |m| "`#{m}`" }.join(", ")
          doc << "### #{interaction[:type].to_s.humanize}\n\n"
          doc << "- **Models**: #{models}\n"
          doc << "- **Description**: #{interaction[:description]}\n\n" if interaction[:description]
        end

        doc << "---\n\n"
      end

      # Group by model to show what each model can do
      doc << "## Model Capabilities\n\n"

      models_with_concerns = ActiveRecord::Base.descendants.select do |model|
        model.included_modules.any? { |mod| mod.respond_to?(:enables_interactions) }
      end

      models_with_concerns.each do |model|
        doc << "### #{model.name}\n\n"
        doc << "**Interactions enabled by concerns:**\n\n"

        model.included_modules.select { |mod| mod.respond_to?(:enables_interactions) }.each do |concern|
          concern.enables_interactions.each do |interaction|
            if interaction[:models].include?(model.name.to_sym)
              doc << "- **#{interaction[:type].to_s.humanize}**: #{interaction[:description]}\n"
            end
          end
        end

        doc << "\n"
      end

      doc
    end
  end
end
