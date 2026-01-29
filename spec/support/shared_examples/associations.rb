# frozen_string_literal: true

# Shared examples for testing ActiveRecord associations

RSpec.shared_examples "belongs to" do |association_name, options = {}|
  optional = options[:optional] || false
  association_class = options[:class_name] || association_name.to_s.classify.constantize

  it "belongs to #{association_name}" do
    associated_record = create_association_record(association_name, association_class)
    subject.send("#{association_name}=", associated_record)
    subject.save! if subject.respond_to?(:save!)

    expect(subject.send(association_name)).to eq(associated_record)
    expect(subject.send("#{association_name}_id")).to eq(associated_record.id)
  end

  unless optional
    it "requires #{association_name}" do
      subject.send("#{association_name}=", nil)
      expect(subject).not_to be_valid
      expect(subject.errors[association_name]).to be_present
    end
  end

  if optional
    it "can exist without #{association_name}" do
      subject.send("#{association_name}=", nil)
      expect(subject).to be_valid
    end
  end
end

RSpec.shared_examples "has many" do |association_name, options = {}|
  dependent = options[:dependent] || :destroy
  association_class = options[:class_name] || association_name.to_s.singularize.classify.constantize

  it "has many #{association_name}" do
    record = create_subject_record
    associated_record = create_association_record(association_name, association_class, record)

    expect(record.send(association_name)).to include(associated_record)
  end

  if dependent == :destroy
    it "destroys #{association_name} when destroyed" do
      record = create_subject_record
      associated_record = create_association_record(association_name, association_class, record)

      expect do
        record.destroy
      end.to change { association_class.count }.by(-1)
    end
  end
end

RSpec.shared_examples "has one" do |association_name, options = {}|
  optional = options[:optional] || false
  association_class = options[:class_name] || association_name.to_s.classify.constantize

  it "has one #{association_name}" do
    record = create_subject_record
    associated_record = create_association_record(association_name, association_class, record)

    expect(record.send(association_name)).to eq(associated_record)
  end
end

# Helper methods that should be defined in each spec file using these examples
# Example:
#   def create_subject_record
#     described_class.create!(build_valid_attributes)
#   end
#
#   def create_association_record(association_name, association_class, parent = nil)
#     # Custom logic to create associated record
#     # This will vary based on the association
#   end
