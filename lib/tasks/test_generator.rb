# frozen_string_literal: true

##
# Automated test generator for models and concerns.
# Analyzes code structure and generates slim, focused tests.
class TestGenerator
  def initialize(target_path)
    @target_path = target_path
    @code = File.read(target_path)
  end

  def generate
    if concern?
      generate_concern_spec
    elsif model?
      generate_model_spec
    else
      raise "Unknown file type: #{@target_path}"
    end
  end

  def self.generate_for(path)
    new(path).generate
  end

  private

  def concern?
    @target_path.include?("app/models/concerns")
  end

  def model?
    @target_path.include?("app/models") && !@target_path.include?("concerns")
  end

  def extract_methods
    instance_methods = @code.scan(/^\s+def\s+([a-z_]+[!?]?)/).flatten
    class_methods = @code.scan(/^\s+def\s+self\.([a-z_]+[!?]?)/).flatten
    [ instance_methods, class_methods ]
  end

  def extract_validations
    @code.scan(/validates\s+:(\w+)/).flatten.uniq
  end

  def extract_associations
    belongs_to = @code.scan(/belongs_to\s+:(\w+)/).flatten
    has_many = @code.scan(/has_many\s+:(\w+)/).flatten
    has_one = @code.scan(/has_one\s+:(\w+)/).flatten
    { belongs_to: belongs_to, has_many: has_many, has_one: has_one }
  end

  def generate_concern_spec
    instance_methods, class_methods = extract_methods
    concern_name = extract_concern_name
    model_name = extract_model_name

    spec_content = <<~RUBY
      # frozen_string_literal: true

      require "rails_helper"

      RSpec.describe #{concern_name}, type: :model do
        let(:model_class) { #{model_name} }
        let(:subject) { model_class.new }

        describe "inclusion" do
          it "is included in #{model_name}" do
            expect(model_class.included_modules).to include(described_class)
          end
        end

    RUBY

    if instance_methods.any?
      spec_content << "        describe \"instance methods\" do\n"
      instance_methods.each do |method|
        spec_content << <<~RUBY
          describe "##{method}" do
            it "responds to #{method}" do
              expect(subject).to respond_to(:#{method})
            end
          end

        RUBY
      end
      spec_content << "        end\n\n"
    end

    if class_methods.any?
      spec_content << "        describe \"class methods\" do\n"
      class_methods.each do |method|
        spec_content << <<~RUBY
          describe ".#{method}" do
            it "responds to #{method}" do
              expect(model_class).to respond_to(:#{method})
            end
          end

        RUBY
      end
      spec_content << "        end\n\n"
    end

    spec_content << "      end\n"
    spec_content
  end

  def generate_model_spec
    validations = extract_validations
    associations = extract_associations
    model_name = extract_model_name

    spec_content = <<~RUBY
      # frozen_string_literal: true

      require "rails_helper"

      RSpec.describe #{model_name}, type: :model do
    RUBY

    if validations.any?
      spec_content << "        describe \"validations\" do\n"
      validations.each do |attr|
        spec_content << "          it_behaves_like \"validates presence of\", :#{attr}\n"
      end
      spec_content << "        end\n\n"
    end

    if associations[:belongs_to].any?
      spec_content << "        describe \"associations\" do\n"
      associations[:belongs_to].each do |assoc|
        spec_content << "          it_behaves_like \"belongs to\", :#{assoc}\n"
      end
      associations[:has_many].each do |assoc|
        spec_content << "          it_behaves_like \"has many\", :#{assoc}\n"
      end
      spec_content << "        end\n\n"
    end

    spec_content << <<~RUBY
        describe "#rails_admin_label" do
          it "returns a string" do
            subject = described_class.new
            expect(subject.rails_admin_label).to be_a(String)
          end
        end
      end
    RUBY

    spec_content
  end

  def extract_concern_name
    # Extract module name from path
    parts = @target_path.split("/")
    concern_idx = parts.index("concerns")
    module_parts = parts[(concern_idx + 1)..-2] + [ File.basename(@target_path, ".rb") ]
    module_parts.map(&:camelize).join("::")
  end

  def extract_model_name
    # Extract model class name
    File.basename(@target_path, ".rb").camelize
  end
end
