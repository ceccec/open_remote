# frozen_string_literal: true

##
# Generates tests and documentation from model feature declarations.
class FeatureGenerator
  def initialize(model_class)
    @model_class = model_class
  end

  def generate_test
    content = <<~RUBY
      # frozen_string_literal: true

      require "rails_helper"

      RSpec.describe #{@model_class.name}, type: :model do
    RUBY

    content << generate_validation_tests if has_features?(:validates)
    content << generate_association_tests if has_features?(:associates)
    content << generate_method_tests if has_features?(:provides)
    content << generate_scope_tests if has_features?(:scopes)

    content << "  end\n"
    content
  end

  def generate_feature_spec
    content = <<~RUBY
      # frozen_string_literal: true

      require "rails_helper"

      RSpec.describe "#{@model_class.name} Features", type: :feature do
    RUBY

    @model_class.features.each do |feature|
      content << generate_feature_example(feature)
    end

    content << "  end\n"
    content
  end

  def generate_documentation
    @model_class.feature_documentation
  end

  private

  def has_features?(type)
    @model_class.features_of_type(type).any?
  end

  def generate_validation_tests
    content = "    describe \"validations\" do\n"
    @model_class.features_of_type(:validates).each do |feature|
      attr, options = feature[:args]
      content << generate_validation_test(attr, options)
    end
    content << "    end\n\n"
    content
  end

  def generate_validation_test(attr, options)
    content = ""
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
    content
  end

  def generate_association_tests
    content = "    describe \"associations\" do\n"
    @model_class.features_of_type(:associates).each do |feature|
      type, name, options = feature[:args]
      content << generate_association_test(type, name, options)
    end
    content << "    end\n\n"
    content
  end

  def generate_association_test(type, name, options)
    case type
    when :belongs_to
      "      it_behaves_like \"belongs to\", :#{name}, #{options.inspect}\n"
    when :has_many
      "      it_behaves_like \"has many\", :#{name}, #{options.inspect}\n"
    when :has_one
      "      it_behaves_like \"has one\", :#{name}, #{options.inspect}\n"
    else
      ""
    end
  end

  def generate_method_tests
    content = "    describe \"instance methods\" do\n"
    @model_class.features_of_type(:provides).each do |feature|
      feature[:args].each do |method|
        content << "      describe \"##{method}\" do\n"
        content << "        it \"responds to #{method}\" do\n"
        content << "          expect(subject).to respond_to(:#{method})\n"
        content << "        end\n"
        content << "      end\n"
      end
    end
    content << "    end\n\n"
    content
  end

  def generate_scope_tests
    content = "    describe \"scopes\" do\n"
    @model_class.features_of_type(:scopes).each do |feature|
      feature[:args].each do |scope|
        content << "      describe \".#{scope}\" do\n"
        content << "        it \"responds to #{scope}\" do\n"
        content << "          expect(described_class).to respond_to(:#{scope})\n"
        content << "        end\n"
        content << "      end\n"
      end
    end
    content << "    end\n\n"
    content
  end

  def generate_feature_example(feature)
    case feature[:type]
    when :validates
      attr, _opts = feature[:args]
      <<~RUBY
        it "validates #{attr}" do
          subject = described_class.new
          subject.#{attr} = nil
          expect(subject).not_to be_valid
        end

      RUBY
    when :associates
      type, name, _opts = feature[:args]
      <<~RUBY
        it "#{type} #{name}" do
          expect(described_class.reflect_on_association(:#{name})).to be_present
        end

      RUBY
    when :provides
      methods = feature[:args]
      methods.map do |method|
        <<~RUBY
          it "provides ##{method}" do
            expect(described_class.new).to respond_to(:#{method})
          end

        RUBY
      end.join
    when :scopes
      scopes = feature[:args]
      scopes.map do |scope|
        <<~RUBY
          it "provides scope .#{scope}" do
            expect(described_class).to respond_to(:#{scope})
          end

        RUBY
      end.join
    else
      ""
    end
  end
end
