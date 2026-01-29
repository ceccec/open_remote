# frozen_string_literal: true

# Shared examples for testing concern behaviors

RSpec.shared_examples "a concern included in a model" do |model_class|
  it "is included in #{model_class}" do
    expect(model_class.included_modules).to include(described_class)
  end

  it "adds instance methods to #{model_class}" do
    instance = model_class.new
    # This will be overridden by specific concern examples
    expect(instance).to respond_to(:some_method)
  end
end

RSpec.shared_examples "sends email via ActionMailer" do |method_name, mailer_class, mailer_method|
  it "enqueues #{mailer_class}##{mailer_method} job" do
    expect do
      subject.send(method_name)
    end.to have_enqueued_job(ActionMailer::MailDeliveryJob)
      .with(mailer_class.to_s, mailer_method.to_s, "deliver_now", { args: [ subject ] })
  end

  it "updates timestamp after sending" do
    timestamp_attribute = "#{method_name.to_s.gsub(/send_|_instructions/, "")}_sent_at".to_sym
    if subject.respond_to?(timestamp_attribute)
      subject.send(method_name)
      expect(subject.send(timestamp_attribute)).to be_within(1.second).of(Time.current)
    end
  end
end

RSpec.shared_examples "updates timestamp" do |method_name, timestamp_attribute|
  it "updates #{timestamp_attribute} when #{method_name} is called" do
    expect(subject.send(timestamp_attribute)).to be_nil
    subject.send(method_name)
    expect(subject.send(timestamp_attribute)).to be_within(1.second).of(Time.current)
  end
end

RSpec.shared_examples "is idempotent" do |method_name, attribute_to_check = nil|
  it "is idempotent (can be called multiple times safely)" do
    subject.send(method_name)
    initial_value = attribute_to_check ? subject.send(attribute_to_check) : nil

    expect do
      subject.send(method_name)
    end.not_to change { attribute_to_check ? subject.send(attribute_to_check) : subject.reload }

    if attribute_to_check
      expect(subject.send(attribute_to_check)).to eq(initial_value)
    end
  end
end
