require "rails_helper"

RSpec.describe "Mapping::AttributeNormalization", type: :model do
  describe ".normalize_openremote_attributes" do
    it "extracts value from nested hash structure" do
      input = {
        "totalCapacity" => { "value" => 1000 },
        "totalPowerOutput" => { "value" => 800 }
      }

      result = Asset.normalize_openremote_attributes(input)

      expect(result["totalCapacity"]).to eq(1000)
      expect(result["totalPowerOutput"]).to eq(800)
    end

    it "preserves non-nested values" do
      input = {
        "name" => "Test Asset",
        "status" => "active"
      }

      result = Asset.normalize_openremote_attributes(input)

      expect(result["name"]).to eq("Test Asset")
      expect(result["status"]).to eq("active")
    end

    it "handles mixed nested and non-nested values" do
      input = {
        "name" => "Test Asset",
        "totalCapacity" => { "value" => 1000 },
        "status" => "active"
      }

      result = Asset.normalize_openremote_attributes(input)

      expect(result["name"]).to eq("Test Asset")
      expect(result["totalCapacity"]).to eq(1000)
      expect(result["status"]).to eq("active")
    end

    it "returns empty hash for blank input" do
      expect(Asset.normalize_openremote_attributes(nil)).to eq({})
      expect(Asset.normalize_openremote_attributes({})).to eq({})
    end

    it "handles hash without value key" do
      input = {
        "metadata" => { "source" => "sensor", "unit" => "kW" }
      }

      result = Asset.normalize_openremote_attributes(input)

      expect(result["metadata"]).to eq({ "source" => "sensor", "unit" => "kW" })
    end
  end

  describe ".denormalize_to_openremote_attributes" do
    it "wraps values in nested hash structure" do
      input = {
        "totalCapacity" => 1000,
        "totalPowerOutput" => 800
      }

      result = Asset.denormalize_to_openremote_attributes(input)

      expect(result["totalCapacity"]).to eq({ "value" => 1000 })
      expect(result["totalPowerOutput"]).to eq({ "value" => 800 })
    end

    it "handles various value types" do
      input = {
        "name" => "Test Asset",
        "capacity" => 1000,
        "active" => true,
        "ratio" => 0.85
      }

      result = Asset.denormalize_to_openremote_attributes(input)

      expect(result["name"]).to eq({ "value" => "Test Asset" })
      expect(result["capacity"]).to eq({ "value" => 1000 })
      expect(result["active"]).to eq({ "value" => true })
      expect(result["ratio"]).to eq({ "value" => 0.85 })
    end

    it "returns empty hash for blank input" do
      expect(Asset.denormalize_to_openremote_attributes(nil)).to eq({})
      expect(Asset.denormalize_to_openremote_attributes({})).to eq({})
    end

    it "handles nil values" do
      input = {
        "name" => "Test",
        "value" => nil
      }

      result = Asset.denormalize_to_openremote_attributes(input)

      expect(result["name"]).to eq({ "value" => "Test" })
      expect(result["value"]).to eq({ "value" => nil })
    end
  end
end
