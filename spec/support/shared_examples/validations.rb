# frozen_string_literal: true

# Shared examples for testing ActiveRecord validations

RSpec.shared_examples "validates presence of" do |attribute|
  it "is invalid without #{attribute}" do
    subject.send("#{attribute}=", nil)
    expect(subject).not_to be_valid
    expect(subject.errors[attribute]).to include("can't be blank")
  end
end

RSpec.shared_examples "validates uniqueness of" do |attribute, options = {}|
  scope = options[:scoped_to]
  unique_value = options[:with_value] || "test_value_#{SecureRandom.hex(4)}"

  it "enforces uniqueness of #{attribute}#{scope ? " scoped to #{scope}" : ""}" do
    # Create first record
    first_record = described_class.create!(
      build_valid_attributes(attribute => unique_value)
    )

    # Try to create duplicate
    duplicate = described_class.new(
      build_valid_attributes(attribute => unique_value)
    )

    expect(duplicate).not_to be_valid
    expect(duplicate.errors[attribute]).to include("has already been taken")
  end
end

RSpec.shared_examples "validates format of" do |attribute, invalid_value, error_message = nil|
  it "is invalid with invalid #{attribute} format" do
    subject.send("#{attribute}=", invalid_value)
    expect(subject).not_to be_valid
    if error_message
      expect(subject.errors[attribute]).to include(error_message)
    end
  end
end

RSpec.shared_examples "validates length of" do |attribute, options = {}|
  min = options[:minimum]
  max = options[:maximum]

  if min
    it "is invalid when #{attribute} is shorter than #{min} characters" do
      subject.send("#{attribute}=", "a" * (min - 1))
      expect(subject).not_to be_valid
      expect(subject.errors[attribute]).to be_present
    end
  end

  if max
    it "is invalid when #{attribute} is longer than #{max} characters" do
      subject.send("#{attribute}=", "a" * (max + 1))
      expect(subject).not_to be_valid
      expect(subject.errors[attribute]).to be_present
    end
  end
end

RSpec.shared_examples "validates inclusion of" do |attribute, invalid_value, valid_values = []|
  it "is invalid when #{attribute} is not in allowed values" do
    subject.send("#{attribute}=", invalid_value)
    expect(subject).not_to be_valid
    expect(subject.errors[attribute]).to be_present
  end

  valid_values.each do |valid_value|
    it "is valid when #{attribute} is #{valid_value}" do
      subject.send("#{attribute}=", valid_value)
      expect(subject).to be_valid
    end
  end
end

# Helper method that should be defined in each spec file using these examples
# Example:
#   def build_valid_attributes(overrides = {})
#     {
#       name: "Test Name",
#       email: "test@example.com",
#       # ... other required attributes
#     }.merge(overrides)
#   end
