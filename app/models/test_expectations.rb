# frozen_string_literal: true

##
# Feature declarations for models.
# Models declare their capabilities, which are used to:
# - Generate comprehensive tests
# - Generate documentation
# - Validate feature completeness
#
# @example
#   class Notification < ApplicationRecord
#     include TestExpectations
#
#     # Declare features
#     feature :validates, :message, presence: true
#     feature :associates, :belongs_to, :asset, optional: true
#     feature :provides, :rails_admin_label
#     feature :scopes, :recent, :by_severity
#   end
module TestExpectations
  extend ActiveSupport::Concern

  included do
    class_attribute :features, default: []
  end

  module ClassMethods
    ##
    # Declare a feature/capability of this model.
    #
    # @param feature_type [Symbol] type of feature (:validates, :associates, :provides, :scopes)
    # @param args [Array] feature-specific arguments
    #
    # @example Validations
    #   feature :validates, :name, presence: true
    #   feature :validates, :email, uniqueness: true, format: URI::MailTo::EMAIL_REGEXP
    #
    # @example Associations
    #   feature :associates, :belongs_to, :asset_type
    #   feature :associates, :has_many, :data_points, dependent: :destroy
    #
    # @example Methods
    #   feature :provides, :rails_admin_label
    #   feature :provides, :update_performance_ratio!, :calculate_sum
    #
    # @example Scopes
    #   feature :scopes, :enabled, :recent, :by_severity
    def feature(feature_type, *args)
      self.features = features.dup
      features << { type: feature_type, args: args }
    end

    ##
    # Declare validation features (shorthand).
    def validates_feature(attribute, options = {})
      feature(:validates, attribute, options)
    end

    ##
    # Declare association features (shorthand).
    def associates_feature(type, name, options = {})
      feature(:associates, type, name, options)
    end

    ##
    # Declare method features (shorthand).
    def provides_feature(*methods)
      feature(:provides, *methods)
    end

    ##
    # Declare scope features (shorthand).
    def scopes_feature(*scopes)
      feature(:scopes, *scopes)
    end

    ##
    # Get all features of a specific type.
    def features_of_type(type)
      features.select { |f| f[:type] == type }
    end

    ##
    # Compute Rails API information for documentation generation.
    # Uses feature declarations and Rails API structure from https://api.rubyonrails.org/classes/ActiveRecord.html
    # Cached for performance - computed once per class.
    #
    def rails_api_info
      return @rails_api_info if defined?(@rails_api_info)

      base_class = superclass.name if is_a?(Class) && superclass
      features_list = []
      assoc_types = []
      rails_modules = []

      # Use feature declarations if available (fastest)
      if respond_to?(:features) && features.any?
        if features_of_type(:validates).any?
          features_list << "validations"
          rails_modules << "ActiveRecord::Validations"
        end

        assoc_features = features_of_type(:associates)
        if assoc_features.any?
          features_list << "associations"
          assoc_types = assoc_features.map { |f| f[:args][0] }.uniq
          rails_modules << "ActiveRecord::Associations"
        end

        if features_of_type(:scopes).any?
          features_list << "scopes"
          rails_modules << "ActiveRecord::Scoping"
        end
      else
        # Fallback to reflection (slower)
        begin
          if respond_to?(:validators) && validators.any?
            features_list << "validations"
            rails_modules << "ActiveRecord::Validations"
          end
        rescue
        end
        begin
          if respond_to?(:reflect_on_all_associations) && reflect_on_all_associations.any?
            features_list << "associations"
            assoc_types = reflect_on_all_associations.map(&:macro).uniq
            rails_modules << "ActiveRecord::Associations"
          end
        rescue
        end
        begin
          if respond_to?(:scopes) && scopes.any?
            features_list << "scopes"
            rails_modules << "ActiveRecord::Scoping"
          end
        rescue
        end
      end

      # Check for callbacks (ActiveRecord::Callbacks)
      begin
        callbacks_present = instance_methods.grep(/^before_|^after_|^around_/).any?
        if callbacks_present
          features_list << "callbacks"
          rails_modules << "ActiveRecord::Callbacks"
        end
      rescue
      end

      # Query methods (ActiveRecord::QueryMethods, ActiveRecord::Querying)
      if respond_to?(:where)
        features_list << "query methods"
        rails_modules << "ActiveRecord::QueryMethods" unless rails_modules.include?("ActiveRecord::QueryMethods")
        rails_modules << "ActiveRecord::Querying" unless rails_modules.include?("ActiveRecord::Querying")
      end

      # Persistence (ActiveRecord::Persistence)
      if respond_to?(:save) || respond_to?(:create) || respond_to?(:update)
        rails_modules << "ActiveRecord::Persistence" unless rails_modules.include?("ActiveRecord::Persistence")
      end

      @rails_api_info = {
        base_class: base_class,
        features: features_list,
        association_types: assoc_types,
        rails_modules: rails_modules.uniq
      }
    end

    ##
    # Generate test file content based on declared features.
    def generate_test
      TestGenerator.new(self).generate
    end

    ##
    # Generate feature documentation.
    def feature_documentation
      doc = "# #{name}\n\n"
      doc << "## Features\n\n"

      features_of_type(:validates).each do |f|
        attr, opts = f[:args]
        doc << "- **Validates** `#{attr}`: #{opts.keys.join(", ")}\n"
      end

      features_of_type(:associates).each do |f|
        type, name, opts = f[:args]
        opts ||= {}
        doc << "- **#{type}** `#{name}`#{opts.any? ? " (#{opts.keys.join(", ")})" : ""}\n"
      end

      features_of_type(:provides).each do |f|
        methods = f[:args]
        doc << "- **Provides methods**: #{methods.map { |m| "`##{m}`" }.join(", ")}\n"
      end

      features_of_type(:scopes).each do |f|
        scopes = f[:args]
        doc << "- **Provides scopes**: #{scopes.map { |s| "`.#{s}`" }.join(", ")}\n"
      end

      doc
    end
  end
end
