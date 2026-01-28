require "rails_helper"

RSpec.describe "Rule::Execution compare_values", type: :model do
  let(:asset_type) { AssetType.find_or_create_by!(name: "SolarPark") { |at| at.display_name = "Solar Park" } }
  let(:rule) do
    Rule.create!(
      name: "Test Rule",
      enabled: true,
      when_config: {
        "condition" => "Asset attribute value",
        "attribute" => "totalPowerOutput",
        "operator" => "greater than",
        "value" => 500
      },
      then_config: [ { "action" => "Log event" } ]
    )
  end

  describe "#compare_values" do
    it "handles less than operator with numeric values" do
      asset = Asset.create!(
        name: "Test Park",
        asset_type: asset_type,
        attributes_data: { "totalPowerOutput" => 400 }
      )

      rule.when_config["operator"] = "less than"
      rule.when_config["value"] = 500

      result = rule.send(:compare_values, asset.attributes_data["totalPowerOutput"], "less than", 500)
      expect(result).to be true

      result = rule.send(:compare_values, 600, "less than", 500)
      expect(result).to be false
    end

    it "handles greater than operator with numeric values" do
      result = rule.send(:compare_values, 600, "greater than", 500)
      expect(result).to be true

      result = rule.send(:compare_values, 400, "greater than", 500)
      expect(result).to be false
    end

    it "handles equals operator with exact match" do
      rule.when_config["operator"] = "equals"
      rule.when_config["value"] = 500

      result = rule.send(:compare_values, 500, "equals", 500)
      expect(result).to be true

      result = rule.send(:compare_values, 501, "equals", 500)
      expect(result).to be false
    end

    it "handles string numeric values with less than" do
      result = rule.send(:compare_values, "400", "less than", "500")
      expect(result).to be true

      result = rule.send(:compare_values, "600", "less than", "500")
      expect(result).to be false
    end

    it "handles string numeric values with greater than" do
      result = rule.send(:compare_values, "600", "greater than", "500")
      expect(result).to be true

      result = rule.send(:compare_values, "400", "greater than", "500")
      expect(result).to be false
    end

    it "handles decimal values" do
      result = rule.send(:compare_values, 500.5, "greater than", 500)
      expect(result).to be true

      result = rule.send(:compare_values, 499.5, "less than", 500)
      expect(result).to be true
    end

    it "handles nil values" do
      result = rule.send(:compare_values, nil, "greater than", 500)
      expect(result).to be false

      result = rule.send(:compare_values, nil, "less than", 500)
      expect(result).to be false

      result = rule.send(:compare_values, nil, "equals", 500)
      expect(result).to be false
    end

    it "handles zero values" do
      result = rule.send(:compare_values, 0, "greater than", 500)
      expect(result).to be false

      result = rule.send(:compare_values, 0, "less than", 500)
      expect(result).to be true

      result = rule.send(:compare_values, 0, "equals", 0)
      expect(result).to be true
    end

    it "handles negative values" do
      result = rule.send(:compare_values, -100, "greater than", -200)
      expect(result).to be true

      result = rule.send(:compare_values, -100, "less than", -50)
      expect(result).to be true
    end

    it "returns false for unknown operators" do
      result = rule.send(:compare_values, 600, "unknown", 500)
      expect(result).to be false

      result = rule.send(:compare_values, 400, "not an operator", 500)
      expect(result).to be false
    end

    it "handles equals with non-numeric values" do
      rule.when_config["operator"] = "equals"
      rule.when_config["value"] = "active"

      result = rule.send(:compare_values, "active", "equals", "active")
      expect(result).to be true

      result = rule.send(:compare_values, "inactive", "equals", "active")
      expect(result).to be false
    end

    it "handles equals with boolean values" do
      rule.when_config["operator"] = "equals"
      rule.when_config["value"] = true

      result = rule.send(:compare_values, true, "equals", true)
      expect(result).to be true

      result = rule.send(:compare_values, false, "equals", true)
      expect(result).to be false
    end
  end

  describe "#condition_met?" do
    let(:asset) do
      Asset.create!(
        name: "Test Park",
        asset_type: asset_type,
        attributes_data: { "totalPowerOutput" => 800 }
      )
    end

    it "returns true for non-attribute-value conditions" do
      rule.when_config["condition"] = "Schedule"

      assets = [ asset ]
      result = rule.send(:condition_met?, assets)
      expect(result).to be true
    end

    it "returns true when at least one asset meets condition" do
      asset1 = Asset.create!(
        name: "Park 1",
        asset_type: asset_type,
        attributes_data: { "totalPowerOutput" => 400 }
      )
      asset2 = Asset.create!(
        name: "Park 2",
        asset_type: asset_type,
        attributes_data: { "totalPowerOutput" => 600 }
      )

      result = rule.send(:condition_met?, [ asset1, asset2 ])
      expect(result).to be true
    end

    it "returns false when no assets meet condition" do
      asset1 = Asset.create!(
        name: "Park 1",
        asset_type: asset_type,
        attributes_data: { "totalPowerOutput" => 400 }
      )
      asset2 = Asset.create!(
        name: "Park 2",
        asset_type: asset_type,
        attributes_data: { "totalPowerOutput" => 300 }
      )

      result = rule.send(:condition_met?, [ asset1, asset2 ])
      expect(result).to be false
    end

    it "handles assets with nil attributes_data" do
      asset = Asset.create!(
        name: "Park",
        asset_type: asset_type,
        attributes_data: {}
      )
      # Use update_column to bypass validations and set to nil
      asset.update_column(:attributes_data, nil)

      result = rule.send(:condition_met?, [ asset ])
      expect(result).to be false
    end

    it "handles assets with missing attribute keys" do
      asset = Asset.create!(
        name: "Park",
        asset_type: asset_type,
        attributes_data: { "otherAttribute" => 1000 }
      )

      result = rule.send(:condition_met?, [ asset ])
      expect(result).to be false
    end

    it "handles empty assets array" do
      result = rule.send(:condition_met?, [])
      expect(result).to be false
    end
  end
end
