require "rails_helper"

RSpec.describe RuleExecution, type: :model do
  let(:rule) do
    Rule.create!(
      name: "Test Rule",
      when_config: { "condition" => "Schedule" },
      then_config: [ { "action" => "Log event" } ]
    )
  end

  describe "validations" do
    it "is valid with valid attributes" do
      execution = RuleExecution.new(
        rule: rule,
        executed_at: Time.current,
        status: "success",
        result: {}
      )
      expect(execution).to be_valid
    end

    it "is invalid without executed_at" do
      execution = RuleExecution.new(rule: rule, status: "success")
      expect(execution).not_to be_valid
    end

    it "is invalid without status" do
      execution = RuleExecution.new(rule: rule, executed_at: Time.current)
      expect(execution).not_to be_valid
    end
  end

  describe "associations" do
    it "belongs to rule" do
      execution = RuleExecution.create!(
        rule: rule,
        executed_at: Time.current,
        status: "success"
      )
      expect(execution.rule).to eq(rule)
    end
  end
end
