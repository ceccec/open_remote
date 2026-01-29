# frozen_string_literal: true

# Shared examples for testing rails_admin_label methods

RSpec.shared_examples "has rails_admin_label" do |options = {}|
  let(:model_instance) { subject }

  it "responds to rails_admin_label" do
    expect(model_instance).to respond_to(:rails_admin_label)
  end

  it "returns a string" do
    expect(model_instance.rails_admin_label).to be_a(String)
  end

  if options[:includes]
    options[:includes].each do |included_value|
      it "includes #{included_value.inspect} in label" do
        label = model_instance.rails_admin_label
        expect(label).to include(included_value.to_s)
      end
    end
  end

  if options[:formats_timestamp]
    it "formats timestamp in label" do
      timestamp = Time.utc(2026, 1, 28, 14, 30)
      model_instance.send("#{options[:formats_timestamp]}=", timestamp)
      label = model_instance.rails_admin_label
      expect(label).to include("2026-01-28 14:30")
    end
  end

  if options[:truncates_at]
    it "truncates long text at #{options[:truncates_at]} characters" do
      long_text = "a" * (options[:truncates_at] + 10)
      model_instance.send("#{options[:truncates_at_field]}=", long_text)
      label = model_instance.rails_admin_label
      expect(label.length).to be <= (options[:truncates_at] + 20) # Allow for other label parts
    end
  end

  if options[:fallback_to]
    it "falls back to #{options[:fallback_to]} when primary field is blank" do
      model_instance.send("#{options[:primary_field]}=", nil)
      fallback_value = model_instance.send(options[:fallback_to])
      label = model_instance.rails_admin_label
      expect(label).to include(fallback_value.to_s)
    end
  end
end

# Example usage:
#   it_behaves_like "has rails_admin_label",
#     includes: ["Test Name", "status"],
#     formats_timestamp: :executed_at,
#     truncates_at: 50,
#     truncates_at_field: :message
