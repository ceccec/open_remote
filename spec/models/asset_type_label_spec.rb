require "rails_helper"

RSpec.describe AssetType, type: :model do
  describe "#rails_admin_label" do
    subject { AssetType.new(name: "internal_name", display_name: display_name) }
    let(:display_name) { "Pretty Name" }

    it_behaves_like "has rails_admin_label",
      fallback_to: :name,
      primary_field: :display_name

    it "returns display_name when present" do
      expect(subject.rails_admin_label).to eq("Pretty Name")
    end

    it "falls back to name when display_name is blank" do
      subject.display_name = nil
      expect(subject.rails_admin_label).to eq("internal_name")
    end
  end
end
