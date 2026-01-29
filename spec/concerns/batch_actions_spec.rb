require "rails_helper"

RSpec.describe BatchActions do
  describe "when included in Rule" do
    let!(:rule1) { Rule.create!(name: "Rule 1", enabled: false, timezone: "EST", when_config: { condition: "Schedule" }, then_config: [ { action: "log" } ]) }
    let!(:rule2) { Rule.create!(name: "Rule 2", enabled: false, timezone: "EST", when_config: { condition: "Schedule" }, then_config: [ { action: "log" } ]) }
    let!(:rule3) { Rule.create!(name: "Rule 3", enabled: true, timezone: "EST", when_config: { condition: "Schedule" }, then_config: [ { action: "log" } ]) }

    describe ".batch_enable" do
      it "enables multiple rules by ID" do
        expect { Rule.batch_enable([ rule1.id, rule2.id ]) }
          .to change { rule1.reload.enabled }.from(false).to(true)
          .and change { rule2.reload.enabled }.from(false).to(true)
      end

      it "does not affect other rules" do
        expect { Rule.batch_enable([ rule1.id ]) }
          .not_to change { rule3.reload.enabled }
      end

      it "works with ActiveRecord::Relation" do
        expect { Rule.batch_enable(Rule.disabled) }
          .to change { Rule.where(id: [ rule1.id, rule2.id ]).pluck(:enabled) }.to([ true, true ])
      end

      it "returns the number of records updated" do
        expect(Rule.batch_enable([ rule1.id, rule2.id ])).to eq(2)
      end
    end

    describe ".batch_disable" do
      it "disables multiple rules by ID" do
        expect { Rule.batch_disable([ rule3.id ]) }
          .to change { rule3.reload.enabled }.from(true).to(false)
      end

      it "works with ActiveRecord::Relation" do
        expect { Rule.batch_disable(Rule.enabled) }
          .to change { rule3.reload.enabled }.from(true).to(false)
      end

      it "returns the number of records updated" do
        expect(Rule.batch_disable([ rule3.id ])).to eq(1)
      end
    end

    describe ".batch_update" do
      it "updates multiple records with attributes" do
        expect { Rule.batch_update([ rule1.id, rule2.id ], { timezone: "UTC" }) }
          .to change { rule1.reload.timezone }.to("UTC")
          .and change { rule2.reload.timezone }.to("UTC")
      end

      it "works with ActiveRecord::Relation" do
        # Change timezone from EST to UTC to ensure there's an actual change
        rule1.update_column(:timezone, "EST")
        rule2.update_column(:timezone, "EST")
        expect { Rule.batch_update(Rule.disabled, { timezone: "UTC" }) }
          .to change { Rule.where(id: [ rule1.id, rule2.id ]).pluck(:timezone) }.from([ "EST", "EST" ]).to([ "UTC", "UTC" ])
      end

      it "returns the number of records updated" do
        expect(Rule.batch_update([ rule1.id ], { timezone: "UTC" })).to eq(1)
      end

      it "returns 0 if attributes are blank" do
        expect(Rule.batch_update([ rule1.id ], {})).to eq(0)
      end
    end

    describe ".batch_delete" do
      it "deletes multiple records by ID" do
        expect { Rule.batch_delete([ rule1.id, rule2.id ]) }
          .to change { Rule.count }.by(-2)
      end

      it "works with ActiveRecord::Relation" do
        expect { Rule.batch_delete(Rule.disabled) }
          .to change { Rule.count }.by(-2)
      end

      it "returns the number of records deleted" do
        expect(Rule.batch_delete([ rule1.id ])).to eq(1)
      end
    end

    describe ".batch_execute" do
      it "executes a method on multiple records" do
        results = Rule.batch_execute([ rule1.id, rule2.id ], :name)
        expect(results[:success]).to eq(2)
        expect(results[:failed]).to eq(0)
      end

      it "handles methods that don't exist" do
        results = Rule.batch_execute([ rule1.id ], :nonexistent_method)
        expect(results[:success]).to eq(0)
        expect(results[:failed]).to eq(1)
        expect(results[:errors].first[:error]).to include("nonexistent_method")
      end

      it "handles errors gracefully" do
        allow_any_instance_of(Rule).to receive(:name).and_raise(StandardError.new("Test error"))
        results = Rule.batch_execute([ rule1.id ], :name)
        expect(results[:failed]).to eq(1)
        expect(results[:errors].first[:error]).to eq("Test error")
      end
    end
  end

  describe "when included in Asset" do
    let!(:asset_type) { AssetType.find_or_create_by!(name: "TestType") { |at| at.display_name = "Test Type" } }
    let!(:parent) { Asset.create!(name: "Parent", asset_type: asset_type, attributes_data: {}) }
    let!(:asset1) { Asset.create!(name: "Asset 1", asset_type: asset_type, attributes_data: {}) }
    let!(:asset2) { Asset.create!(name: "Asset 2", asset_type: asset_type, attributes_data: {}) }

    describe ".batch_assign_parent" do
      it "assigns multiple assets to a parent" do
        expect { Asset.batch_assign_parent([ asset1.id, asset2.id ], parent.id) }
          .to change { asset1.reload.parent_id }.to(parent.id)
          .and change { asset2.reload.parent_id }.to(parent.id)
      end

      it "can make assets root by passing nil" do
        asset1.update!(parent: parent)
        expect { Asset.batch_assign_parent([ asset1.id ], nil) }
          .to change { asset1.reload.parent_id }.to(nil)
      end

      it "returns the number of records updated" do
        expect(Asset.batch_assign_parent([ asset1.id ], parent.id)).to eq(1)
      end
    end
  end

  describe "when included in Notification" do
    let!(:notification1) { Notification.create!(message: "Test 1", severity: "info", sent_at: Time.current) }
    let!(:notification2) { Notification.create!(message: "Test 2", severity: "info", sent_at: Time.current) }

    describe ".batch_acknowledge" do
      it "acknowledges multiple notifications" do
        expect { Notification.batch_acknowledge([ notification1.id, notification2.id ]) }
          .to change { notification1.reload.acknowledged_at }.from(nil)
          .and change { notification2.reload.acknowledged_at }.from(nil)
      end

      it "works with ActiveRecord::Relation" do
        expect { Notification.batch_acknowledge(Notification.unacknowledged) }
          .to change { Notification.where(id: [ notification1.id, notification2.id ]).pluck(:acknowledged_at) }
          .from([ nil, nil ])
      end

      it "returns the number of records updated" do
        expect(Notification.batch_acknowledge([ notification1.id ])).to eq(1)
      end
    end
  end

  describe "when included in DataPoint" do
    let!(:asset_type) { AssetType.find_or_create_by!(name: "TestType") { |at| at.display_name = "Test Type" } }
    let!(:asset) { Asset.create!(name: "Test Asset", asset_type: asset_type, attributes_data: {}) }
    let!(:data_point1) { DataPoint.create!(asset: asset, attribute_name: "power", value: { value: 100 }, timestamp: Time.current) }
    let!(:data_point2) { DataPoint.create!(asset: asset, attribute_name: "power", value: { value: 200 }, timestamp: Time.current) }

    describe ".batch_delete" do
      it "deletes multiple data points" do
        expect { DataPoint.batch_delete([ data_point1.id, data_point2.id ]) }
          .to change { DataPoint.count }.by(-2)
      end
    end
  end
end
