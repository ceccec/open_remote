# frozen_string_literal: true

##
# Generates test files based on model feature declarations.
# @deprecated Use FeatureGenerator instead
class TestGenerator
  def initialize(model_class)
    @model_class = model_class
  end

  def generate
    content = <<~RUBY
      # frozen_string_literal: true

      require "rails_helper"

      RSpec.describe #{@model_class.name}, type: :model do
    RUBY

    content << generate_validations if @model_class.test_validations.any?
    content << generate_associations if @model_class.test_associations.any?
    content << generate_methods if @model_class.test_methods.any?
    content << generate_scopes if @model_class.test_scopes.any?

    content << "  end\n"
    content
  end

  private

  def generate_validations
    content = "    describe \"validations\" do\n"
    @model_class.test_validations.each do |validation|
      attr = validation[:attribute]
      options = validation[:options]

      if options[:presence]
        content << "      it_behaves_like \"validates presence of\", :#{attr}\n"
      end

      if options[:uniqueness]
        scope_opts = options[:uniqueness] == true ? {} : { scoped_to: options[:uniqueness] }
        content << "      it_behaves_like \"validates uniqueness of\", :#{attr}, #{scope_opts.inspect}\n"
      end

      if options[:format]
        content << "      it_behaves_like \"validates format of\", :#{attr}, \"invalid\", /#{options[:format].source}/\n"
      end

      if options[:length]
        length_opts = options[:length].is_a?(Hash) ? options[:length] : { minimum: options[:length] }
        content << "      it_behaves_like \"validates length of\", :#{attr}, #{length_opts.inspect}\n"
      end
    end
    content << "    end\n\n"
    content
  end

  def generate_associations
    content = "    describe \"associations\" do\n"
    @model_class.test_associations.each do |association|
      type = association[:type]
      name = association[:name]
      options = association[:options]

      case type
      when :belongs_to
        content << "      it_behaves_like \"belongs to\", :#{name}, #{options.inspect}\n"
      when :has_many
        content << "      it_behaves_like \"has many\", :#{name}, #{options.inspect}\n"
      when :has_one
        content << "      it_behaves_like \"has one\", :#{name}, #{options.inspect}\n"
      end
    end
    content << "    end\n\n"
    content
  end

  def generate_methods
    content = "    describe \"instance methods\" do\n"
    @model_class.test_methods.each do |method|
      content << "      describe \"##{method}\" do\n"
      content << "        it \"responds to #{method}\" do\n"
      content << "          expect(subject).to respond_to(:#{method})\n"
      content << "        end\n"
      content << "      end\n"
    end
    content << "    end\n\n"
    content
  end

  def generate_scopes
    content = "    describe \"scopes\" do\n"
    @model_class.test_scopes.each do |scope|
      content << "      describe \".#{scope}\" do\n"
      content << "        it \"responds to #{scope}\" do\n"
      content << "          expect(described_class).to respond_to(:#{scope})\n"
      content << "        end\n"
      content << "      end\n"
    end
    content << "    end\n\n"
    content
  end
end
