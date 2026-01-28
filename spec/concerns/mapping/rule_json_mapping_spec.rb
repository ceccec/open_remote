require "rails_helper"

RSpec.describe Mapping::RuleJsonMapping, type: :concern do
  describe ".from_openremote_json" do
    it "creates rule from OpenRemote JSON node" do
      json_node = {
        "name" => "Test Rule",
        "description" => "Test Description",
        "enabled" => true,
        "when" => { "schedule" => "FREQ=DAILY" },
        "then" => [ { "action" => "log" } ]
      }

      rule = Rule.from_openremote_json(json_node)

      expect(rule).to be_persisted
      expect(rule.name).to eq("Test Rule")
      expect(rule.description).to eq("Test Description")
      expect(rule.enabled).to be(true)
      expect(rule.when_config).to eq({ "schedule" => "FREQ=DAILY" })
      expect(rule.then_config).to eq([ { "action" => "log" } ])
    end

    it "extracts schedule and timezone from when config" do
      json_node = {
        "name" => "Scheduled Rule",
        "when" => {
          "schedule" => "FREQ=HOURLY",
          "timezone" => "America/New_York"
        },
        "then" => []
      }

      rule = Rule.from_openremote_json(json_node)

      expect(rule.schedule).to eq("FREQ=HOURLY")
      expect(rule.timezone).to eq("America/New_York")
    end

    it "defaults enabled to true if not provided" do
      json_node = {
        "name" => "Default Enabled",
        "when" => {},
        "then" => []
      }

      rule = Rule.from_openremote_json(json_node)

      expect(rule.enabled).to be(true)
    end

    it "defaults timezone to UTC if not provided" do
      json_node = {
        "name" => "Default Timezone",
        "when" => {},
        "then" => []
      }

      rule = Rule.from_openremote_json(json_node)

      expect(rule.timezone).to eq("UTC")
    end

    it "updates existing rule if name matches" do
      existing = Rule.create!(
        name: "Existing",
        when_config: { "old" => "data" },
        then_config: [ { "action" => "Log event" } ]
      )

      json_node = {
        "name" => "Existing",
        "when" => { "new" => "data" },
        "then" => []
      }

      expect do
        Rule.from_openremote_json(json_node)
      end.not_to change(Rule, :count)

      existing.reload
      expect(existing.when_config).to eq({ "new" => "data" })
    end
  end

  describe "#to_openremote_json" do
    let(:rule) do
      Rule.create!(
        name: "Test Rule",
        description: "Test Description",
        enabled: true,
        when_config: { "schedule" => "FREQ=DAILY" },
        then_config: [ { "action" => "log" } ]
      )
    end

    it "exports rule to OpenRemote JSON format" do
      json = rule.to_openremote_json

      expect(json["name"]).to eq("Test Rule")
      expect(json["description"]).to eq("Test Description")
      expect(json["enabled"]).to be(true)
      expect(json["when"]).to eq({ "schedule" => "FREQ=DAILY" })
      expect(json["then"]).to eq([ { "action" => "log" } ])
    end

    it "handles nil description" do
      rule.update!(description: nil)
      json = rule.to_openremote_json

      expect(json["description"]).to be_nil
    end

    it "defaults empty configs to empty objects/arrays" do
      # Use update_columns to bypass validations for this test
      rule.update_columns(when_config: {}, then_config: [])
      json = rule.to_openremote_json

      expect(json["when"]).to eq({})
      expect(json["then"]).to eq([])
    end
  end
end
