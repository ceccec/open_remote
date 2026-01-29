# frozen_string_literal: true

# Shared examples for testing token generation patterns (common in User concerns)

RSpec.shared_examples "generates unique token" do |token_method, token_attribute = nil|
  token_attribute ||= token_method.to_s.gsub(/generate_|!/, "").concat("_token").to_sym

  it "generates a token" do
    expect(subject.send(token_attribute)).to be_nil
    subject.send(token_method)
    expect(subject.send(token_attribute)).to be_present
  end

  it "generates a unique token even if collision occurs" do
    existing_record = create_existing_record_with_token(token_attribute, "collision-token")
    allow(SecureRandom).to receive(:urlsafe_base64).and_return("collision-token", "unique-token")

    subject.send(token_method)
    expect(subject.send(token_attribute)).to eq("unique-token")
  end

  it "generates different tokens for different records" do
    record1 = create_subject_record
    record2 = create_subject_record

    record1.send(token_method)
    record2.send(token_method)

    expect(record1.send(token_attribute)).not_to eq(record2.send(token_attribute))
  end
end

RSpec.shared_examples "clears token" do |clear_method, token_attribute|
  it "clears the #{token_attribute}" do
    subject.send("#{token_attribute}=", SecureRandom.urlsafe_base64(32))
    subject.save! if subject.respond_to?(:save!)

    subject.send(clear_method)
    subject.reload if subject.respond_to?(:reload)

    expect(subject.send(token_attribute)).to be_nil
  end
end

RSpec.shared_examples "validates token period" do |valid_method, sent_at_attribute, period_duration|
  it "returns false when #{sent_at_attribute} is nil" do
    expect(subject.send(valid_method)).to be_falsey
  end

  it "returns true when sent within #{period_duration}" do
    subject.send("#{sent_at_attribute}=", period_duration.ago + 1.hour)
    expect(subject.send(valid_method)).to be_truthy
  end

  it "returns false when sent more than #{period_duration} ago" do
    subject.send("#{sent_at_attribute}=", period_duration.ago - 1.hour)
    expect(subject.send(valid_method)).to be_falsey
  end
end

# Helper methods that should be defined in each spec file using these examples
# Example:
#   def create_subject_record
#     described_class.create!(build_valid_attributes)
#   end
#
#   def create_existing_record_with_token(token_attribute, token_value)
#     # Custom logic to create a record with a specific token
#   end
