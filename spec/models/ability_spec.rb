require "rails_helper"
require "cancan/matchers"

RSpec.describe Ability, type: :model do
  subject(:ability) { described_class.new(user) }

  context "when user is an admin" do
    let(:user) do
      User.create!(
        email: "admin@example.com",
        password: "password123",
        admin: true
      )
    end

    it "can manage everything" do
      expect(ability).to be_able_to(:manage, :all)
    end
  end

  context "when user is a guest" do
    let(:user) do
      User.create!(
        email: "guest@example.com",
        password: "password123",
        admin: false
      )
    end

    it "cannot manage anything" do
      expect(ability).not_to be_able_to(:manage, :all)
    end
  end

  context "when user is nil" do
    let(:user) { nil }

    it "treats the user as a guest" do
      expect(ability).not_to be_able_to(:manage, :all)
    end
  end
end
