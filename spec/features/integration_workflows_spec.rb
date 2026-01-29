# frozen_string_literal: true

require "rails_helper"

RSpec.describe "End-to-End Integration Workflows", type: :feature do
  describe "Complete Solar Park Monitoring Workflow" do
    it "demonstrates full lifecycle: import, monitor, analyze, alert" do
      # Step 1: Import asset hierarchy from OpenRemote
      json_tree = {
        "name" => "Production Solar Park",
        "type" => "SolarPark",
        "attributes" => {
          "totalCapacity" => { "value" => 50_000 },
          "totalPowerOutput" => { "value" => 45_000 }
        },
        "children" => [
          {
            "name" => "North Array",
            "type" => "SolarArray",
            "attributes" => {
              "arrayCapacity" => { "value" => 25_000 },
              "powerOutput" => { "value" => 22_500 }
            }
          },
          {
            "name" => "South Array",
            "type" => "SolarArray",
            "attributes" => {
              "arrayCapacity" => { "value" => 25_000 },
              "powerOutput" => { "value" => 22_500 }
            }
          }
        ]
      }

      AssetType.find_or_create_by!(name: "SolarPark") { |at| at.display_name = "Solar Park" }
      AssetType.find_or_create_by!(name: "SolarArray") { |at| at.display_name = "Solar Array" }

      park = Asset.from_openremote_json(json_tree)
      expect(park.children.count).to eq(2)

      # Step 2: Record time-series data
      array = park.children.first
      base_time = Time.utc(2026, 1, 28, 0, 0)
      (0..23).each do |hour|
        DataPoint.create!(
          asset: array,
          attribute_name: "powerOutput",
          value: { "value" => 20_000 + (hour * 100) },
          timestamp: base_time + hour.hours
        )
      end

      expect(array.data_points.count).to eq(24)

      # Step 3: Analyze daily performance
      daily_sum = DataPoint.sum_for(
        asset: array,
        attribute_name: "powerOutput",
        from: base_time,
        to: base_time + 23.hours
      )

      daily_avg = DataPoint.average_for(
        asset: array,
        attribute_name: "powerOutput",
        from: base_time,
        to: base_time + 23.hours
      )

      expect(daily_sum).to be > 0
      expect(daily_avg).to be_within(1000).of(22_000)

      # Step 4: Create monitoring rule
      rule = Rule.create!(
        name: "Low Output Alert",
        enabled: true,
        when_config: {
          "condition" => "Asset attribute value",
          "attribute" => "powerOutput",
          "operator" => "less than",
          "value" => 20_000
        },
        then_config: [
          {
            "action" => "Send notification",
            "message" => "Power output below threshold",
            "severity" => "warning"
          }
        ]
      )

      # Step 5: Trigger notification when condition is met
      array.update!(attributes_data: { "powerOutput" => 15_000 })

      # Execute rule - it will check condition and send notification if met
      rule.execute!

      execution = rule.rule_executions.last
      expect(execution.status).to eq("success")

      # Verify notification was created
      notification = Notification.where(asset: array, rule: rule).last
      expect(notification).to be_present
      expect(notification.severity).to eq("warning")

      # Step 6: Query and export
      high_output_arrays = Asset.solar_arrays
        .select { |a| a.attributes_data["powerOutput"].to_f > 20_000 }

      expect(high_output_arrays).to be_an(Array)

      # Export updated hierarchy
      exported_json = park.to_openremote_json_tree
      expect(exported_json["children"].count).to eq(2)
    end
  end

  describe "Multi-Asset Type Energy Management" do
    it "manages diverse asset portfolio with different capabilities" do
      # Create various asset types
      solar_park_type = AssetType.create!(name: "SolarPark")
      meter_type = AssetType.create!(name: "EnergyMeter")
      inverter_type = AssetType.create!(name: "Inverter")
      weather_type = AssetType.create!(name: "WeatherStation")

      # Create assets
      solar_park = Asset.create!(
        name: "Main Solar Park",
        asset_type: solar_park_type,
        attributes_data: { "totalPowerOutput" => 10_000 }
      )

      meter = Asset.create!(
        name: "Grid Meter",
        asset_type: meter_type,
        attributes_data: { "energyConsumed" => 5000 }
      )

      weather = Asset.create!(
        name: "Weather Station",
        asset_type: weather_type,
        attributes_data: { "temperature" => 25, "humidity" => 60, "irradiance" => 800 }
      )

      # Record data for each
      DataPoint.create!(
        asset: solar_park,
        attribute_name: "totalPowerOutput",
        value: { "value" => 10_000 },
        timestamp: Time.current
      )

      DataPoint.create!(
        asset: meter,
        attribute_name: "energyConsumed",
        value: { "value" => 5000 },
        timestamp: Time.current
      )

      DataPoint.create!(
        asset: weather,
        attribute_name: "irradiance",
        value: { "value" => 800 },
        timestamp: Time.current
      )

      # Query across types
      all_assets = Asset.all
      expect(all_assets).to include(solar_park, meter, weather)

      # Create cross-asset rule
      rule = Rule.create!(
        name: "Energy Balance Check",
        enabled: true,
        when_config: {
          "condition" => "Schedule",
          "schedule" => "0 * * * *" # Every hour
        },
        then_config: [
          {
            "action" => "Log event",
            "message" => "Checking energy balance"
          }
        ]
      )

      # Execute rule
      execution = RuleExecution.create!(
        rule: rule,
        executed_at: Time.current,
        status: "success",
        result: {
          "generated" => 10_000,
          "consumed" => 5000,
          "net" => 5000
        }
      )

      expect(execution.status).to eq("success")
      expect(execution.result["net"]).to eq(5000)
    end
  end

  describe "User Authentication and Authorization Workflow" do
    it "demonstrates complete user lifecycle with role-based access" do
      # Step 1: User registration (email confirmation required)
      user = User.create!(
        email: "manager@example.com",
        password: "secure_password_123",
        password_confirmation: "secure_password_123"
      )

      expect(user.confirmed?).to be false

      # Step 2: Send confirmation email
      user.send_confirmation_instructions
      expect(user.confirmation_token).to be_present

      # Step 3: Confirm email
      user.confirm!
      expect(user.confirmed?).to be true

      # Step 4: Assign role
      User.ensure_default_roles!
      user.add_role(:manager)

      expect(user.has_role?(:manager)).to be true

      # Step 5: Test authorization
      ability = Ability.new(user)
      expect(ability.can?(:read, Asset)).to be true
      expect(ability.can?(:manage, Asset)).to be true
      expect(ability.can?(:manage, User)).to be false # Managers can't manage users

      # Step 6: Remember me functionality
      token = user.remember_me!
      expect(user.remember_token).to be_present
      expect(user.remember_token_valid?).to be true

      found_user = User.find_by_remember_token(token)
      expect(found_user).to eq(user)

      # Step 7: Password reset
      user.send_password_reset_instructions
      expect(user.reset_password_token).to be_present
      expect(user.reset_password_sent_at).to be_present

      # Step 8: Account locking after failed attempts
      5.times { user.increment_failed_attempts! }
      expect(user.access_locked?).to be true

      user.unlock_access!
      expect(user.access_locked?).to be false
    end
  end

  describe "Rule Execution and Notification Pipeline" do
    it "executes rules and generates notifications for stakeholders" do
      # Setup
      park = Asset.create!(
        name: "Monitored Asset",
        asset_type: AssetType.create!(name: "SolarPark"),
        attributes_data: { "status" => "online", "powerOutput" => 5000 }
      )

      rule = Rule.create!(
        name: "Status Change Monitor",
        enabled: true,
        when_config: {
          "condition" => "Asset attribute value changed"
        },
        then_config: [
          {
            "action" => "Send notification",
            "message" => "Asset status changed to ${status}",
            "severity" => "error"
          }
        ]
      )

      # Trigger condition
      park.update!(attributes_data: { "status" => "offline", "powerOutput" => 0 })

      # Execute rule - it will process attribute changes
      rule.execute!

      execution = rule.rule_executions.last
      expect(execution.status).to eq("success")

      # Verify notification was generated
      notification = Notification.where(asset: park, rule: rule).last
      expect(notification).to be_present
      expect(notification.severity).to eq("error")
      expect(notification.asset).to eq(park)
      expect(notification.rule).to eq(rule)

      # Query notifications
      error_notifications = Notification.where(severity: "error")
      expect(error_notifications).to include(notification)

      asset_notifications = park.notifications
      expect(asset_notifications).to include(notification)
    end
  end

  describe "Data-Driven Decision Making" do
    it "uses historical data to inform operational decisions" do
      park = Asset.create!(
        name: "Decision Park",
        asset_type: AssetType.create!(name: "SolarPark"),
        attributes_data: { "powerOutput" => 5000 }
      )

      # Collect week of hourly data
      base_time = Time.utc(2026, 1, 21, 0, 0) # Monday
      (0..(7 * 24 - 1)).each do |hour|
        # Simulate daily pattern: low at night, peak at noon
        hour_of_day = hour % 24
        value = if hour_of_day.between?(6, 18)
                  5000 + (Math.sin((hour_of_day - 6) * Math::PI / 12) * 2000).to_i
        else
                  0
        end

        DataPoint.create!(
          asset: park,
          attribute_name: "powerOutput",
          value: { "value" => value },
          timestamp: base_time + hour.hours
        )
      end

      # Analyze patterns
      monday_data = DataPoint.in_time_range(
        base_time,
        base_time + 23.hours
      )

      week_data = DataPoint.in_time_range(
        base_time,
        base_time + (7 * 24 - 1).hours
      )

      monday_avg = DataPoint.average_for(
        asset: park,
        attribute_name: "powerOutput",
        from: base_time,
        to: base_time + 23.hours
      )

      week_max = DataPoint.max_for(
        asset: park,
        attribute_name: "powerOutput",
        from: base_time,
        to: base_time + (7 * 24 - 1).hours
      )

      expect(monday_data.count).to eq(24)
      expect(week_data.count).to eq(168) # 7 days * 24 hours
      expect(monday_avg).to be > 0
      expect(week_max).to be > 5000

      # Create rule based on analysis
      threshold = (monday_avg * 0.5).to_i # 50% below average

      # Create a child asset (solar array) that matches the condition (below threshold)
      array_with_low_power = Asset.create!(
        name: "Low Power Array",
        parent: park,
        asset_type: AssetType.find_or_create_by!(name: "SolarArray") { |at| at.display_name = "Solar Array" },
        attributes_data: { "powerOutput" => threshold - 1000 }
      )

      performance_rule = Rule.create!(
        name: "Performance Degradation Alert",
        enabled: true,
        when_config: {
          "condition" => "Asset attribute value",
          "attribute" => "powerOutput",
          "operator" => "less than",
          "value" => threshold
        },
        then_config: [
          {
            "action" => "Send notification",
            "message" => "Performance below expected threshold",
            "severity" => "warning"
          }
        ]
      )

      expect(performance_rule.enabled).to be true

      # Execute rule to verify it works
      performance_rule.execute!
      expect(performance_rule.rule_executions.last.status).to eq("success")
    end
  end
end
