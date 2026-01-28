require "rails_helper"

RSpec.describe Mapping::AttributeNormalization do
  let(:test_class) do
    Class.new do
      include Mapping::AttributeNormalization
    end
  end

  describe ".normalize_openremote_attributes" do
    it "extracts values from OpenRemote format" do
      input = {
        "totalCapacity" => { "value" => 5000 },
        "status" => { "value" => "active" }
      }
      result = test_class.normalize_openremote_attributes(input)
      expect(result["totalCapacity"]).to eq(5000)
      expect(result["status"]).to eq("active")
    end

    it "handles already normalized attributes" do
      input = {
        "totalCapacity" => 5000,
        "status" => "active"
      }
      result = test_class.normalize_openremote_attributes(input)
      expect(result["totalCapacity"]).to eq(5000)
    end

    it "handles empty hash" do
      expect(test_class.normalize_openremote_attributes({})).to eq({})
    end

    it "handles nil" do
      expect(test_class.normalize_openremote_attributes(nil)).to eq({})
    end
  end

  describe ".denormalize_to_openremote_attributes" do
    it "wraps values in OpenRemote format" do
      input = {
        "totalCapacity" => 5000,
        "status" => "active"
      }
      result = test_class.denormalize_to_openremote_attributes(input)
      expect(result["totalCapacity"]["value"]).to eq(5000)
      expect(result["status"]["value"]).to eq("active")
    end

    it "handles empty hash" do
      expect(test_class.denormalize_to_openremote_attributes({})).to eq({})
    end

    it "handles nil" do
      expect(test_class.denormalize_to_openremote_attributes(nil)).to eq({})
    end
  end
end
