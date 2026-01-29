# frozen_string_literal: true

# Shared examples for testing asset type-specific attribute concerns

RSpec.shared_examples "asset attribute accessors" do |attribute_methods|
  attribute_methods.each do |method_name, expected_key|
    describe "##{method_name}" do
      it "returns the value from attributes_data for #{expected_key}" do
        asset = described_class.new(
          name: "Test Asset",
          asset_type: asset_type,
          attributes_data: { expected_key => "test_value_123" }
        )
        expect(asset.send(method_name)).to eq("test_value_123")
      end

      it "returns nil when #{expected_key} is not present" do
        asset = described_class.new(
          name: "Test Asset",
          asset_type: asset_type,
          attributes_data: {}
        )
        expect(asset.send(method_name)).to be_nil
      end

      it "handles nil attributes_data gracefully" do
        asset = described_class.new(
          name: "Test Asset",
          asset_type: asset_type,
          attributes_data: nil
        )
        # Should not raise error
        expect(asset.send(method_name)).to be_nil
      end
    end
  end
end
