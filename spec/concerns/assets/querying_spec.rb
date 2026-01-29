require "rails_helper"

RSpec.describe Assets::Querying do
  let(:solar_park_type) { AssetType.find_or_create_by!(name: "SolarPark") { |at| at.display_name = "Solar Park" } }
  let(:solar_array_type) { AssetType.find_or_create_by!(name: "SolarArray") { |at| at.display_name = "Solar Array" } }

  before do
    @park = Asset.create!(
      name: "Test Park",
      asset_type: solar_park_type,
      attributes_data: { "totalCapacity" => 5000 }
    )
    @array = Asset.create!(
      name: "Test Array",
      asset_type: solar_array_type,
      attributes_data: { "powerOutput" => 1000 }
    )
  end

  describe ".solar_arrays" do
    it "returns only solar arrays" do
      arrays = Asset.solar_arrays
      expect(arrays).to include(@array)
      expect(arrays).not_to include(@park)
    end
  end

  describe ".solar_parks" do
    it "returns only solar parks" do
      parks = Asset.solar_parks
      expect(parks).to include(@park)
      expect(parks).not_to include(@array)
    end
  end

  describe ".of_type" do
    it "returns assets of specific type" do
      parks = Asset.of_type("SolarPark")
      expect(parks).to include(@park)
      expect(parks).not_to include(@array)
    end
  end

  describe ".solar_array_power_outputs" do
    it "returns id and power output pairs for solar arrays" do
      array2 = Asset.create!(
        name: "Array 2",
        asset_type: solar_array_type,
        attributes_data: { "powerOutput" => 2000 }
      )

      pairs = Asset.solar_array_power_outputs

      expect(pairs.size).to eq(2)
      expect(pairs.map(&:first)).to contain_exactly(@array.id.to_s, array2.id.to_s)
      expect(pairs.map(&:last)).to contain_exactly(1000.0, 2000.0)
    end

    it "returns empty array when no solar arrays exist" do
      Asset.where(asset_type: solar_array_type).destroy_all

      pairs = Asset.solar_array_power_outputs
      expect(pairs).to be_empty
    end

    it "handles arrays without powerOutput attribute" do
      array_no_power = Asset.create!(
        name: "Array No Power",
        asset_type: solar_array_type,
        attributes_data: {}
      )

      pairs = Asset.solar_array_power_outputs
      # Arrays without powerOutput should return 0.0
      pair = pairs.find { |p| p.first == array_no_power.id.to_s }
      expect(pair).to be_present
      expect(pair.last).to eq(0.0)
    end

    it "handles arrays with nil attributes_data" do
      array_nil = Asset.create!(
        name: "Array Nil",
        asset_type: solar_array_type,
        attributes_data: {}
      )
      # Bypass validation to set nil for testing the code path
      array_nil.update_column(:attributes_data, nil)

      pairs = Asset.solar_array_power_outputs
      pair = pairs.find { |p| p.first == array_nil.id.to_s }
      expect(pair).to be_present
      expect(pair.last).to eq(0.0)
    end

    it "handles string numeric powerOutput values" do
      array_string = Asset.create!(
        name: "Array String",
        asset_type: solar_array_type,
        attributes_data: { "powerOutput" => "1500" }
      )

      pairs = Asset.solar_array_power_outputs
      expect(pairs.map(&:last)).to include(1500.0)
    end

    it "ensures id is always a string" do
      pairs = Asset.solar_array_power_outputs
      pairs.each do |id_str, _power|
        expect(id_str).to be_a(String)
      end
    end
  end

  describe ".with_numeric_attribute_greater_than" do
    it "filters assets by numeric attribute value" do
      high_capacity = Asset.create!(
        name: "High Capacity Park",
        asset_type: solar_park_type,
        attributes_data: { "totalCapacity" => 10000 }
      )
      low_capacity = Asset.create!(
        name: "Low Capacity Park",
        asset_type: solar_park_type,
        attributes_data: { "totalCapacity" => 1000 }
      )

      result = Asset.with_numeric_attribute_greater_than("totalCapacity", 5000)

      expect(result).to include(high_capacity)
      expect(result).not_to include(low_capacity)
      expect(result).not_to include(@park)
    end

    it "handles string numeric values" do
      asset = Asset.create!(
        name: "String Value",
        asset_type: solar_park_type,
        attributes_data: { "totalCapacity" => "8000" }
      )

      result = Asset.with_numeric_attribute_greater_than("totalCapacity", 5000)
      expect(result).to include(asset)
    end

    it "excludes assets without the attribute" do
      asset_no_attr = Asset.create!(
        name: "No Attribute",
        asset_type: solar_park_type,
        attributes_data: {}
      )

      result = Asset.with_numeric_attribute_greater_than("totalCapacity", 5000)
      expect(result).not_to include(asset_no_attr)
    end

    it "handles different attribute names" do
      asset = Asset.create!(
        name: "Test Asset",
        asset_type: solar_park_type,
        attributes_data: { "customAttribute" => 100 }
      )

      result = Asset.with_numeric_attribute_greater_than("customAttribute", 50)
      expect(result).to include(asset)

      result = Asset.with_numeric_attribute_greater_than("customAttribute", 150)
      expect(result).not_to include(asset)
    end
  end
end
