require "rails_helper"

RSpec.describe Role, type: :model do
  describe "validations" do
    it "requires a name" do
      role = Role.new(name: nil)
      expect(role).not_to be_valid
      expect(role.errors[:name]).to include("can't be blank")
    end

    it "enforces uniqueness of name scoped to resource" do
      Role.create!(name: "custom")
      duplicate = Role.new(name: "custom")

      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:name]).to include("has already been taken")
    end
  end

  describe ".find_or_create_by_name" do
    it "finds an existing global role" do
      existing = Role.create!(name: "special_manager")
      found = Role.find_or_create_by_name("special_manager")
      expect(found.id).to eq(existing.id)
    end

    it "creates a new global role when missing" do
      expect do
        Role.find_or_create_by_name("new_role_name")
      end.to change { Role.where(name: "new_role_name").count }.by(1)
      role = Role.find_by(name: "new_role_name")
      expect(role.resource).to be_nil
    end
  end

  describe "#rails_admin_label" do
    it "returns just the name for global roles" do
      role = Role.create!(name: "custom_admin")
      expect(role.rails_admin_label).to eq("custom_admin")
    end

    it "includes resource_type and resource name when present" do
      role = Role.new(name: "manager")
      allow(role).to receive(:resource_type).and_return("Asset")
      allow(role).to receive(:resource).and_return(double(name: "Main Park"))

      label = role.rails_admin_label
      expect(label).to include("manager")
      expect(label).to include("Asset")
      expect(label).to include("Main Park")
    end
  end
end

