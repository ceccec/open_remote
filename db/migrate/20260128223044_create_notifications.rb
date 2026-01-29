##
# Create notifications table.
# Stores notifications sent to users about asset or rule events.
#
class CreateNotifications < ActiveRecord::Migration[8.1]
  def change
    create_table :notifications, id: :uuid do |t|
      t.references :asset, null: true, foreign_key: true, type: :uuid
      t.references :rule, null: true, foreign_key: true, type: :uuid
      t.text :message, null: false
      t.string :severity, null: false
      t.datetime :sent_at, null: false
      t.datetime :acknowledged_at

      t.timestamps
    end

    # Indexes for queries
    # Note: asset_id and rule_id indexes are automatically created by t.references
    add_index :notifications, :sent_at
    add_index :notifications, :severity
    add_index :notifications, :acknowledged_at

    # Composite index for common query patterns
    add_index :notifications, [ :acknowledged_at, :severity, :sent_at ], name: "index_notifications_on_ack_severity_sent"
  end
end
