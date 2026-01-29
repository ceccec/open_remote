# frozen_string_literal: true

# Helper methods for model testing

module ModelTestHelpers
  # Automatically test validations based on model configuration
  def self.test_validations(model_class, validations_config)
    RSpec.describe model_class, type: :model do
      describe "validations" do
        validations_config.each do |validation_type, config|
          case validation_type
          when :presence
            Array(config[:attributes]).each do |attr|
              it_behaves_like "validates presence of", attr
            end
          when :uniqueness
            Array(config[:attributes]).each do |attr|
              options = config[:options] || {}
              it_behaves_like "validates uniqueness of", attr, options
            end
          when :format
            Array(config[:attributes]).each do |attr|
              invalid_value = config[:invalid_value] || "invalid"
              error_message = config[:error_message]
              it_behaves_like "validates format of", attr, invalid_value, error_message
            end
          when :length
            Array(config[:attributes]).each do |attr|
              options = config[:options] || {}
              it_behaves_like "validates length of", attr, options
            end
          when :inclusion
            Array(config[:attributes]).each do |attr|
              invalid_value = config[:invalid_value]
              valid_values = config[:valid_values] || []
              it_behaves_like "validates inclusion of", attr, invalid_value, valid_values
            end
          end
        end
      end
    end
  end

  # Automatically test associations based on model configuration
  def self.test_associations(model_class, associations_config)
    RSpec.describe model_class, type: :model do
      describe "associations" do
        associations_config.each do |association_type, config|
          case association_type
          when :belongs_to
            Array(config[:associations]).each do |assoc|
              options = config[:options] || {}
              it_behaves_like "belongs to", assoc, options
            end
          when :has_many
            Array(config[:associations]).each do |assoc|
              options = config[:options] || {}
              it_behaves_like "has many", assoc, options
            end
          when :has_one
            Array(config[:associations]).each do |assoc|
              options = config[:options] || {}
              it_behaves_like "has one", assoc, options
            end
          end
        end
      end
    end
  end

  # Automatically test rails_admin_label method
  def self.test_rails_admin_label(model_class, label_config)
    RSpec.describe model_class, type: :model do
      describe "#rails_admin_label" do
        it_behaves_like "has rails_admin_label", label_config
      end
    end
  end
end
