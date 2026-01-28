require "rails_helper"

RSpec.describe Notification, type: :model do
  let(:asset_type) { AssetType.find_or_create_by!(name: "SolarPark") { |at| at.display_name = "Solar Park" } }
  let(:asset) do
    Asset.create!(
      name: "Test Park",
      asset_type: asset_type,
      attributes_data: {}
    )
  end
  let(:rule) do
    Rule.create!(
      name: "Test Rule",
      when_config: { "condition" => "Schedule" },
      then_config: [ { "action" => "Log event" } ]
    )
  end

  describe "validations" do
    it "is valid with valid attributes" do
      notification = Notification.new(
        asset: asset,
        rule: rule,
        message: "Test notification",
        severity: "info",
        sent_at: Time.current
      )
      expect(notification).to be_valid
    end

    it "is invalid without message" do
      notification = Notification.new(
        severity: "info",
        sent_at: Time.current
      )
      expect(notification).not_to be_valid
    end

    it "is invalid without severity" do
      notification = Notification.new(
        message: "Test",
        sent_at: Time.current
      )
      expect(notification).not_to be_valid
    end

    it "is invalid without sent_at" do
      notification = Notification.new(
        message: "Test",
        severity: "info"
      )
      expect(notification).not_to be_valid
    end

    it "can exist without asset" do
      notification = Notification.new(
        rule: rule,
        message: "Test",
        severity: "info",
        sent_at: Time.current
      )
      expect(notification).to be_valid
    end

    it "can exist without rule" do
      notification = Notification.new(
        asset: asset,
        message: "Test",
        severity: "info",
        sent_at: Time.current
      )
      expect(notification).to be_valid
    end
  end

  describe "associations" do
    it "belongs to asset optionally" do
      notification = Notification.create!(
        asset: asset,
        message: "Test",
        severity: "info",
        sent_at: Time.current
      )
      expect(notification.asset).to eq(asset)
    end

    it "belongs to rule optionally" do
      notification = Notification.create!(
        rule: rule,
        message: "Test",
        severity: "info",
        sent_at: Time.current
      )
      expect(notification.rule).to eq(rule)
    end
  end
end
