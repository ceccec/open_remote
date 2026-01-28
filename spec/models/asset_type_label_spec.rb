require "rails_helper"

RSpec.describe AssetType, type: :model do
  describe "#rails_admin_label" do
    it "returns display_name when present" do
      type = AssetType.new(name: "internal_name", display_name: "Pretty Name")
      expect(type.rails_admin_label).to eq("Pretty Name")
    end

    it "falls back to name when display_name is blank" do
      type = AssetType.new(name: "internal_name", display_name: nil)
      expect(type.rails_admin_label).to eq("internal_name")
    end
  end
end

