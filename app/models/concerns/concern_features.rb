# frozen_string_literal: true

##
# Feature declarations for concerns.
# Concerns declare how they enable model interactions and shared behaviors.
module ConcernFeatures
  def self.extended(base)
    base.instance_variable_set(:@concern_features, [])
    base.instance_variable_set(:@enables_interactions, [])

    def base.concern_features
      @concern_features ||= []
    end

    def base.enables_interactions
      @enables_interactions ||= []
    end
  end

  ##
  # Declare a feature this concern provides.
  #
  # @param feature_type [Symbol] type of feature
  # @param args [Array] feature-specific arguments
  #
  # @example
  #   concern_feature :provides, :from_openremote_json, :to_openremote_json_tree
  #   concern_feature :enables, :json_import, :json_export
  def concern_feature(feature_type, *args)
    @concern_features ||= []
    @concern_features << { type: feature_type, args: args }
  end

  ##
  # Declare model interactions this concern enables.
  #
  # @param interaction_type [Symbol] type of interaction
  # @param models [Array<Symbol>] models that interact through this concern
  # @param description [String] description of the interaction
  #
  # @example
  #   enables_interaction :import_export, [:Asset, :Rule], "JSON import/export between models"
  #   enables_interaction :querying, [:Asset], "Advanced querying capabilities"
  def enables_interaction(interaction_type, models, description = nil)
    @enables_interactions ||= []
    @enables_interactions << {
      type: interaction_type,
      models: models,
      description: description
    }
  end

  ##
  # Compute Rails API information for documentation generation.
  # Cached for performance - computed once per concern.
  #
  # @return [Hash] Rails API information with :base_class, :features, and :rails_modules
  #
  def rails_api_info
    return @rails_api_info if defined?(@rails_api_info)

    # Check if this module extends ActiveSupport::Concern
    # When a module does `extend ActiveSupport::Concern`, it's added to singleton class ancestors
    uses_concern = begin
      singleton_class.ancestors.include?(ActiveSupport::Concern) ||
      # Alternative check: if it has class_methods block, it's using Concern
      respond_to?(:class_methods)
    rescue
      # If we can't check, assume true if it's a module (most concerns use Concern)
      is_a?(Module)
    end

    # Check for callbacks - concerns can define callbacks via ActiveSupport::Callbacks
    has_callbacks = begin
      instance_methods.grep(/^before_|^after_|^around_/).any? ||
      respond_to?(:before_action) || respond_to?(:after_action)
    rescue
      false
    end

    # Return structure compatible with generate_rails_api_links_from_info
    features = []
    features << "modular behavior" if uses_concern
    features << "callbacks" if has_callbacks

    rails_modules = []
    rails_modules << "ActiveSupport::Concern" if uses_concern
    rails_modules << "ActiveSupport::Callbacks" if has_callbacks

    @rails_api_info = {
      base_class: uses_concern ? "ActiveSupport::Concern" : nil,
      features: features,
      rails_modules: rails_modules,
      uses_concern: uses_concern,
      has_callbacks: has_callbacks
    }
  end

  ##
  # Get all interactions enabled by this concern.
  def interactions_for_model(model_name)
    (@enables_interactions || []).select { |i| i[:models].include?(model_name.to_sym) }
  end
end
