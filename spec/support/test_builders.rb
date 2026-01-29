# frozen_string_literal: true

##
# Slim test builders for common test scenarios.
# Reduces boilerplate and makes tests more readable.
module TestBuilders
  # Build a test for an attribute accessor
  def self.attribute_test(attribute_name, options = {})
    {
      description: "##{attribute_name}",
      expectations: [
        {
          type: :respond_to,
          method: attribute_name
        }
      ]
    }
  end

  # Build a test for a validation
  def self.validation_test(attribute, validation_type, options = {})
    {
      description: "validates #{validation_type} of #{attribute}",
      shared_example: "validates #{validation_type} of",
      args: [ attribute, options ]
    }
  end

  # Build a test for an association
  def self.association_test(association_name, association_type, options = {})
    {
      description: "#{association_type} #{association_name}",
      shared_example: association_type == :belongs_to ? "belongs to" : "has many",
      args: [ association_name, options ]
    }
  end

  # Generate a slim spec from a hash of test definitions
  def self.generate_spec(class_name, tests)
    spec = <<~RUBY
      # frozen_string_literal: true

      require "rails_helper"

      RSpec.describe #{class_name}, type: :model do
    RUBY

    tests.each do |test|
      spec << "      describe \"#{test[:description]}\" do\n"
      if test[:shared_example]
        args = test[:args] || []
        spec << "        it_behaves_like \"#{test[:shared_example]}\", #{args.map(&:inspect).join(", ")}\n"
      elsif test[:expectations]
        test[:expectations].each do |expectation|
          case expectation[:type]
          when :respond_to
            spec << "        it \"responds to #{expectation[:method]}\" do\n"
            spec << "          expect(subject).to respond_to(:#{expectation[:method]})\n"
            spec << "        end\n"
          end
        end
      end
      spec << "      end\n\n"
    end

    spec << "    end\n"
    spec
  end
end
