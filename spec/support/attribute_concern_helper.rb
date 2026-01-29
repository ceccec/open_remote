# frozen_string_literal: true

##
# Helper for testing attribute concerns (like EnergyMeterAttributes, InverterAttributes, etc.)
# Provides a slim way to test all attribute accessors at once.
module AttributeConcernHelper
  def self.test_attribute_concern(concern_module, attributes_map)
    RSpec.describe concern_module, type: :model do
      let(:asset_type) { AssetType.create!(name: concern_module.name.demodulize.gsub("Attributes", "")) }
      let(:asset) do
        Asset.create!(
          name: "Test Asset",
          asset_type: asset_type,
          attributes_data: attributes_map.transform_keys { |k| k.to_s.camelize(:lower) }
        )
      end

      attributes_map.each do |method_name, test_value|
        describe "##{method_name}" do
          it "returns the attribute value from attributes_data" do
            expect(asset.send(method_name)).to eq(test_value)
          end

          it "returns nil when attribute is missing" do
            asset.update!(attributes_data: {})
            expect(asset.send(method_name)).to be_nil
          end
        end
      end
    end
  end

  # Usage:
  # AttributeConcernHelper.test_attribute_concern(
  #   Assets::EnergyMeterAttributes,
  #   active_power: 1000,
  #   reactive_power: 500,
  #   voltage: 240
  # )
end
