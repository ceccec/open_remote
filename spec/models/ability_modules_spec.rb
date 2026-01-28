require "rails_helper"
require "cancan/matchers"

RSpec.describe "Ability Modules", type: :model do
  describe "Ability::Admin" do
    let(:ability) { Ability.new(nil) }
    let(:admin_user) do
      User.create!(
        email: "admin@example.com",
        password: "password123",
        admin: true
      )
    end

    it "defines manage all permissions" do
      Ability::Admin.define(ability, admin_user)
      expect(ability).to be_able_to(:manage, :all)
    end

    it "allows access to all models" do
      Ability::Admin.define(ability, admin_user)
      expect(ability).to be_able_to(:manage, Asset)
      expect(ability).to be_able_to(:manage, AssetType)
      expect(ability).to be_able_to(:manage, Rule)
      expect(ability).to be_able_to(:manage, DataPoint)
      expect(ability).to be_able_to(:manage, Notification)
      expect(ability).to be_able_to(:manage, RuleExecution)
      expect(ability).to be_able_to(:manage, User)
    end
  end

  describe "Ability::Guest" do
    let(:ability) { Ability.new(nil) }
    let(:guest_user) do
      User.create!(
        email: "guest@example.com",
        password: "password123",
        admin: false
      )
    end

    it "defines no permissions" do
      Ability::Guest.define(ability, guest_user)
      expect(ability).not_to be_able_to(:manage, :all)
    end

    it "denies access to all models" do
      Ability::Guest.define(ability, guest_user)
      expect(ability).not_to be_able_to(:manage, Asset)
      expect(ability).not_to be_able_to(:manage, AssetType)
      expect(ability).not_to be_able_to(:manage, Rule)
      expect(ability).not_to be_able_to(:manage, DataPoint)
      expect(ability).not_to be_able_to(:manage, Notification)
      expect(ability).not_to be_able_to(:manage, RuleExecution)
      expect(ability).not_to be_able_to(:manage, User)
    end
  end
end
