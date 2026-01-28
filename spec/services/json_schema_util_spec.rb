require "rails_helper"

RSpec.describe JsonSchemaUtil do
  describe ".build_property_schema" do
    it "falls back to string type for unknown Ruby-ish types" do
      schema = described_class.build_property_schema(type: :unknown_type, title: "Unknown")

      expect(schema["type"]).to eq("string")
      expect(schema["title"]).to eq("Unknown")
    end
  end
end
